// lib/screens/sobre_rayanne_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class SobreRayannePage extends StatelessWidget {
  final ImageProvider image; // Foto de Rayanne (Asset ou Network)
  const SobreRayannePage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Rayanne Duarte'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fundo com blur
          Positioned.fill(
            child: Image(image: image, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.55)),
            ),
          ),

          // Conteúdo principal
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto
                  Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nome
                  Text(
                    'Rayanne Duarte',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'Idealizadora do App Story Feito',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Texto
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Text(
                      '''
Rayanne Duarte é a mente criativa e o coração por trás do Story Feito — um aplicativo criado para transformar a forma como empreendedores comunicam suas ideias e impulsionam seus resultados.

Formada em Análise e Desenvolvimento de Sistemas, pós-graduada em Marketing e com MBA em Neuromarketing, Rayanne une estratégia, sensibilidade e inovação em cada detalhe do projeto.

Mais do que tecnologia, ela acredita em propósito: em conectar pessoas, inspirar criatividade e mostrar que todo empreendedor tem uma história única — e que contá-la com autenticidade é o primeiro passo para o sucesso.
                      ''',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    'Obrigado por utilizar o aplicativo!',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
