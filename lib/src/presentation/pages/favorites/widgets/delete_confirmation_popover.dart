import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class DeleteConfirmationPopover extends StatelessWidget {
  final String characterName;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  const DeleteConfirmationPopover({
    super.key,
    required this.characterName,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * -10),
              child: child,
            ),
          );
        },
        child: Container(
          width: 290,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground.withValues(alpha: .98),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.terminalGreen.withValues(alpha: .3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .6),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'REMOVE ENTRY',
                            style: AppTheme.caption.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              color: AppTheme.terminalGreen,
                              fontSize: 10,
                              height: 1.2,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: onClose,
                          icon: const Icon(Icons.close, size: 16),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.white.withValues(alpha: .4),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: .1),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm holocron removal for $characterName?',
                          style: AppTheme.bodyText.copyWith(
                            fontSize: 12,
                            height: 1.5,
                            color: Colors.white.withValues(alpha: .9),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.accentRed.withValues(alpha: .85),
                                AppTheme.accentRed,
                              ],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              onDelete();
                              onClose();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Confirm Removal',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
