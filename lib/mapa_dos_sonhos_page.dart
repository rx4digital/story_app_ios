// lib/story_do_sonho_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryDoSonhoPage extends StatefulWidget {
  const StoryDoSonhoPage({super.key});

  @override
  State<StoryDoSonhoPage> createState() => _StoryDoSonhoPageState();
}

class _StoryDoSonhoPageState extends State<StoryDoSonhoPage> {
  static const _spKey = 'storyfeito_story_do_sonho_v1';

  static const _bg = Color(0xFF0E1217);
  static const _card = Color(0xFF121A21);
  static const _stroke = Color(0xFF1E2A33);
  static const _muted = Color(0xFF9FB2BB);

  final List<_Sonho> _sonhos = [];
  final List<String> _frases = const [
    "Cada story te aproxima do teu sonho.",
    "Constância hoje, conquista amanhã.",
    "Onde há propósito, há caminho.",
    "Começa simples. O importante é começar.",
    "Você já está mais perto do que imagina.",
    "Pequenas ações geram grandes viradas.",
  ];

  int _fraseIndex = 0;
  String _query = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_spKey);
    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List)
          .map((e) => _Sonho.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      _sonhos
        ..clear()
        ..addAll(list);
    }
    setState(() => _loading = false);
  }

  Future<void> _salvar() async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(_sonhos.map((e) => e.toMap()).toList());
    await sp.setString(_spKey, raw);
  }

  void _addSonho() async {
    final result = await showModalBottomSheet<_Sonho>(
      context: context,
      backgroundColor: _card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddEditSonhoSheet(
        title: "Adicionar sonho",
        initial: null,
      ),
    );

    if (result != null) {
      setState(() => _sonhos.insert(0, result));
      await _salvar();
    }
  }

  void _editSonho(_Sonho s) async {
    final idx = _sonhos.indexWhere((e) => e.id == s.id);
    if (idx < 0) return;

    final result = await showModalBottomSheet<_Sonho>(
      context: context,
      backgroundColor: _card,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddEditSonhoSheet(
        title: "Editar sonho",
        initial: s,
      ),
    );

    if (result != null) {
      setState(() => _sonhos[idx] = result);
      await _salvar();
    }
  }

  void _toggleDone(_Sonho s, bool? value) async {
    final idx = _sonhos.indexWhere((e) => e.id == s.id);
    if (idx < 0) return;
    setState(() => _sonhos[idx] = s.copyWith(done: value ?? false));
    await _salvar();
  }

  void _delete(_Sonho s) async {
    setState(() => _sonhos.removeWhere((e) => e.id == s.id));
    await _salvar();
  }

  double get _progresso {
    if (_sonhos.isEmpty) return 0;
    final done = _sonhos.where((e) => e.done).length;
    return done / _sonhos.length;
  }

  List<_Sonho> get _filtrados {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _sonhos;
    return _sonhos
        .where(
          (s) =>
      s.texto.toLowerCase().contains(q) ||
          (s.nota?.toLowerCase() ?? '').contains(q),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Story do Sonho',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: 'Nova frase',
            onPressed: () => setState(() {
              _fraseIndex = (_fraseIndex + 1) % _frases.length;
            }),
            icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        onPressed: _addSonho,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Adicionar'),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : Column(
        children: [
          // Frase motivacional + progresso
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _TopCard(
              frase: _frases[_fraseIndex],
              progresso: _progresso,
              total: _sonhos.length,
              concluidos: _sonhos.where((e) => e.done).length,
            ),
          ),

          // Busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar sonho…',
                hintStyle:
                TextStyle(color: Colors.white.withOpacity(.6)),
                filled: true,
                fillColor: _card,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _stroke),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: _stroke),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Colors.orange, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),

          Expanded(
            child: _filtrados.isEmpty
                ? _Empty(onAdd: _addSonho)
                : ReorderableListView.builder(
              padding:
              const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: _filtrados.length,
              onReorder: (oldIndex, newIndex) async {
                // Reordena na lista original (não só filtrada)
                final originalOrder =
                _filtrados.map((e) => e.id).toList();
                final fromId = originalOrder[oldIndex];
                final toId = (newIndex >= originalOrder.length)
                    ? originalOrder.last
                    : originalOrder[newIndex];

                final fromIdx = _sonhos
                    .indexWhere((e) => e.id == fromId);
                var toIdx =
                _sonhos.indexWhere((e) => e.id == toId);

                if (newIndex > oldIndex) toIdx += 1;
                final item = _sonhos.removeAt(fromIdx);
                _sonhos.insert(toIdx, item);
                setState(() {});
                await _salvar();
              },
              itemBuilder: (ctx, i) {
                final s = _filtrados[i];
                return Dismissible(
                  key: ValueKey(s.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20),
                    margin:
                    const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF201216),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4A2027),
                      ),
                    ),
                    child: const Icon(
                      Icons.delete_rounded,
                      color: Colors.redAccent,
                    ),
                  ),
                  onDismissed: (_) => _delete(s),
                  child: _SonhoCard(
                    sonho: s,
                    onToggle: (v) => _toggleDone(s, v),
                    onEdit: () => _editSonho(s),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final String frase;
  final double progresso;
  final int total;
  final int concluidos;

  const _TopCard({
    required this.frase,
    required this.progresso,
    required this.total,
    required this.concluidos,
  });

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF121A21);
    const stroke = Color(0xFF1E2A33);
    const muted = Color(0xFF9FB2BB);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            frase,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progresso,
            minHeight: 8,
            color: Colors.orange,
            backgroundColor: Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(height: 8),
          Text(
            total == 0
                ? 'Comece adicionando seu primeiro sonho ✨'
                : '$concluidos de $total sonhos concluídos',
            style: const TextStyle(
              color: muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SonhoCard extends StatelessWidget {
  final _Sonho sonho;
  final ValueChanged<bool?> onToggle;
  final VoidCallback onEdit;

  const _SonhoCard({
    required this.sonho,
    required this.onToggle,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF121A21);
    const stroke = Color(0xFF1E2A33);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: stroke),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        leading: Checkbox(
          value: sonho.done,
          activeColor: Colors.orange,
          onChanged: onToggle,
        ),
        title: Text(
          sonho.texto,
          style: TextStyle(
            color: Colors.white.withOpacity(sonho.done ? .7 : .95),
            fontWeight: FontWeight.w700,
            decoration: sonho.done
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            _formatDate(sonho.createdAt),
            style: TextStyle(color: Colors.white.withOpacity(.6)),
          ),
        ),
        trailing: IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          tooltip: 'Editar',
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return 'Criado em $d/$m/$y';
  }
}

class _AddEditSonhoSheet extends StatefulWidget {
  final String title;
  final _Sonho? initial;

  const _AddEditSonhoSheet({
    required this.title,
    required this.initial,
  });

  @override
  State<_AddEditSonhoSheet> createState() => _AddEditSonhoSheetState();
}

class _AddEditSonhoSheetState extends State<_AddEditSonhoSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textoCtrl;
  late TextEditingController _notaCtrl;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _textoCtrl = TextEditingController(text: widget.initial?.texto ?? '');
    _notaCtrl = TextEditingController(text: widget.initial?.nota ?? '');
    _done = widget.initial?.done ?? false;
  }

  @override
  void dispose() {
    _textoCtrl.dispose();
    _notaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + insets),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _textoCtrl,
              maxLines: 3,
              minLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(
                'Descreva seu sonho (ex.: abrir loja física, viajar com a família…)',
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Descreva o sonho' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _notaCtrl,
              maxLines: 3,
              minLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration(
                'Detalhes (opcional): por quê, quando, como…',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _done,
                  activeColor: Colors.orange,
                  onChanged: (v) => setState(() => _done = v ?? false),
                ),
                const Text(
                  'Marcar como concluído',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                label: const Text(
                  'Salvar',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: const Color(0xFF121A21),
    border: _border(),
    enabledBorder: _border(),
    focusedBorder: _borderFocused(),
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );

  OutlineInputBorder _border() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF1E2A33)),
  );

  OutlineInputBorder _borderFocused() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.orange, width: 1),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final s = _Sonho(
      id: widget.initial?.id ?? now.microsecondsSinceEpoch.toString(),
      texto: _textoCtrl.text.trim(),
      nota: _notaCtrl.text.trim().isEmpty ? null : _notaCtrl.text.trim(),
      createdAt: widget.initial?.createdAt ?? now,
      done: _done,
    );
    Navigator.pop(context, s);
  }
}

class _Sonho {
  final String id;
  final String texto;
  final String? nota;
  final DateTime createdAt;
  final bool done;

  _Sonho({
    required this.id,
    required this.texto,
    required this.createdAt,
    required this.done,
    this.nota,
  });

  _Sonho copyWith({
    String? id,
    String? texto,
    String? nota,
    DateTime? createdAt,
    bool? done,
  }) {
    return _Sonho(
      id: id ?? this.id,
      texto: texto ?? this.texto,
      nota: nota ?? this.nota,
      createdAt: createdAt ?? this.createdAt,
      done: done ?? this.done,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'texto': texto,
    'nota': nota,
    'createdAt': createdAt.toIso8601String(),
    'done': done,
  };

  factory _Sonho.fromMap(Map<String, dynamic> map) => _Sonho(
    id: map['id'] as String,
    texto: map['texto'] as String,
    nota: map['nota'] as String?,
    createdAt: DateTime.parse(map['createdAt'] as String),
    done: map['done'] as bool? ?? false,
  );
}

class _Empty extends StatelessWidget {
  final VoidCallback onAdd;
  const _Empty({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.orange,
              size: 44,
            ),
            const SizedBox(height: 10),
            const Text(
              'Nenhum sonho cadastrado ainda.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Adicione sonhos, metas e desejos. Cada story te aproxima deles ✨',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(.75),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              label: const Text(
                'Adicionar sonho',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
