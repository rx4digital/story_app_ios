// lib/gravar_comigo_page.dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class GravarComigoPage extends StatefulWidget {
  const GravarComigoPage({super.key, this.roteiro});
  final String? roteiro;

  @override
  State<GravarComigoPage> createState() => _GravarComigoPageState();
}

class _GravarComigoPageState extends State<GravarComigoPage>
    with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;

  bool _initializing = true;
  bool _isRecording = false;
  int _selectedIndex = 0;

  XFile? _lastVideo;
  VideoPlayerController? _videoController;

  // Cronômetro
  Timer? _timer;
  int _seconds = 0;

  // Teleprompter
  bool _showScript = true;
  bool _autoScroll = false;
  double _fontSize = 22; // legível
  double _speed = 18; // px/s
  final _scrollCtrl = ScrollController();
  Timer? _scrollTimer;

  // suavização
  final int _initialDelayMs = 1200;
  final int _rampUpMs = 1500;
  DateTime? _autoScrollStart;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setup();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _scrollTimer?.cancel();
    _videoController?.dispose();
    _controller?.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _setup() async {
    try {
      await Permission.camera.request();
      await Permission.microphone.request();
      await Permission.photos.request();

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _show('Nenhuma câmera encontrada.');
        return;
      }

      final frontIndex = _cameras.indexWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
      );
      _selectedIndex = frontIndex >= 0 ? frontIndex : 0;
      await _initController(_cameras[_selectedIndex]);
    } catch (e) {
      if (!mounted) return;
      _show('Erro ao iniciar câmera: $e');
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  Future<void> _initController(CameraDescription desc) async {
    final old = _controller;
    _controller = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _controller!.initialize();
    await old?.dispose();
    if (mounted) setState(() {});
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _fmt(int s) {
    final m = s ~/ 60, r = s % 60;
    return '${m.toString().padLeft(2, '0')}:${r.toString().padLeft(2, '0')}';
  }

  // ===== Teleprompter =====
  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _autoScroll = true;
    _autoScrollStart = DateTime.now();
    const tick = Duration(milliseconds: 16); // ~60fps

    _scrollTimer = Timer.periodic(tick, (_) {
      if (!_autoScroll || !_scrollCtrl.hasClients) return;

      final now = DateTime.now();
      final elapsedMs = now.difference(_autoScrollStart!).inMilliseconds;
      if (elapsedMs < _initialDelayMs) return;

      final rampElapsed =
      (elapsedMs - _initialDelayMs).clamp(0, _rampUpMs);
      final rampFactor = rampElapsed / _rampUpMs; // 0..1
      final currentSpeed =
          _speed * (0.2 + 0.8 * rampFactor); // 20% → 100%

      final delta =
          currentSpeed * (tick.inMilliseconds / 1000.0); // px/frame
      final max = _scrollCtrl.position.maxScrollExtent;
      final next = (_scrollCtrl.offset + delta).clamp(0.0, max);
      _scrollCtrl.jumpTo(next);
    });
    setState(() {});
  }

  void _stopAutoScroll() {
    _autoScroll = false;
    _scrollTimer?.cancel();
    setState(() {});
  }

  void _toggleAutoScroll() =>
      _autoScroll ? _stopAutoScroll() : _startAutoScroll();

  // ===== Ações =====
  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _selectedIndex = (_selectedIndex + 1) % _cameras.length;
    await _initController(_cameras[_selectedIndex]);
  }

  void _startTimer() {
    _seconds = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
    });
  }

  Future<void> _startRecording() async {
    if (_controller == null || _isRecording) return;
    try {
      await _controller!.startVideoRecording();
      _isRecording = true;
      _startTimer();

      if (_showScript && (widget.roteiro?.isNotEmpty ?? false)) {
        if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(0);
        _startAutoScroll();
      }
      setState(() {});
    } catch (e) {
      _show('Não foi possível começar a gravar: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (_controller == null || !_isRecording) return;
    try {
      final file = await _controller!.stopVideoRecording();
      _isRecording = false;
      _timer?.cancel();
      _stopAutoScroll();
      setState(() {});
      _lastVideo = file;

      final perm = await PhotoManager.requestPermissionExtend();
      if (perm.isAuth) {
        final saved = await PhotoManager.editor.saveVideo(
          File(file.path),
          title: 'Story Feito ${DateTime.now().millisecondsSinceEpoch}.mp4',
        );
        _show(
          saved != null
              ? 'Vídeo salvo na Galeria.'
              : 'Falha ao salvar o vídeo.',
        );
      } else {
        _show(
          'Permissão da galeria negada. Não foi possível salvar o vídeo.',
        );
      }

      await _prepareVideoPreview(File(file.path));
    } catch (e) {
      _show('Erro ao finalizar gravação: $e');
    }
  }

  Future<void> _prepareVideoPreview(File f) async {
    final old = _videoController;
    _videoController = VideoPlayerController.file(f);
    await _videoController!.initialize();
    _videoController!.setLooping(true);
    await old?.dispose();
    if (mounted) setState(() {});
  }

  Future<void> _regravar() async {
    _videoController?.pause();
    await _videoController?.dispose();
    _videoController = null;
    _lastVideo = null;
    _stopAutoScroll();
    if (_scrollCtrl.hasClients) _scrollCtrl.jumpTo(0);
    if (mounted) setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      ctrl.pausePreview();
      _stopAutoScroll();
    } else if (state == AppLifecycleState.resumed) {
      ctrl.resumePreview();
      if (_isRecording && _showScript) _startAutoScroll();
    }
  }

  // ===== UI =====
  Widget _buildCameraPreview() {
    if (_initializing) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: Text(
          'Câmera não disponível.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Stack(
      children: [
        Center(child: CameraPreview(_controller!)),
        if (_isRecording)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _fmt(_seconds),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 12,
          right: 12,
          child: IconButton.filled(
            onPressed: _switchCamera,
            icon: const Icon(Icons.cameraswitch),
          ),
        ),

        // teleprompter
        if (_showScript && (widget.roteiro?.isNotEmpty ?? false))
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                minimum: const EdgeInsets.only(bottom: 100),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollCtrl,
                    child: SingleChildScrollView(
                      controller: _scrollCtrl,
                      physics: const NeverScrollableScrollPhysics(),
                      child: Text(
                        widget.roteiro!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.35,
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordedPreview() {
    if (_videoController == null ||
        !_videoController!.value.isInitialized) {
      return const Center(
        child: Text(
          'Vídeo salvo. Se quiser, toque em "Regravar" e faça de novo.',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      );
    }
    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio == 0
                ? 16 / 9
                : _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: FloatingActionButton.small(
            onPressed: () {
              final v = _videoController!;
              v.value.isPlaying ? v.pause() : v.play();
              setState(() {});
            },
            child: Icon(
              _videoController!.value.isPlaying
                  ? Icons.pause
                  : Icons.play_arrow,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    final hasRecorded = _lastVideo != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed:
                _isRecording ? _stopRecording : _startRecording,
                icon: Icon(
                  _isRecording
                      ? Icons.stop
                      : Icons.fiber_manual_record,
                ),
                label: Text(_isRecording ? 'Parar' : 'Gravar'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor:
                  _isRecording ? Colors.redAccent : Colors.orange,
                  foregroundColor: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: hasRecorded ? _regravar : null,
                icon: const Icon(Icons.refresh),
                label: const Text('Regravar'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        if (widget.roteiro?.isNotEmpty ?? false)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(
                      _showScript ? 'Roteiro: ON' : 'Roteiro: OFF',
                    ),
                    selected: _showScript,
                    onSelected: (_) =>
                        setState(() => _showScript = !_showScript),
                  ),
                  FilterChip(
                    label: Text(_autoScroll
                        ? 'Auto-rolagem: ON'
                        : 'Auto-rolagem: OFF'),
                    selected: _autoScroll,
                    onSelected: (_) => _toggleAutoScroll(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Tamanho',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      min: 14,
                      max: 32,
                      value: _fontSize,
                      onChanged: (v) =>
                          setState(() => _fontSize = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Veloc.',
                    style: TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      min: 8,
                      max: 60,
                      value: _speed,
                      onChanged: (v) =>
                          setState(() => _speed = v),
                    ),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasRecorded = _lastVideo != null;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0C12),
        foregroundColor: Colors.white,
        title: const Text(
          'Gravar junto comigo',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: hasRecorded
                ? _buildRecordedPreview()
                : _buildCameraPreview(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: _buildControls(),
          ),
        ],
      ),
    );
  }
}
