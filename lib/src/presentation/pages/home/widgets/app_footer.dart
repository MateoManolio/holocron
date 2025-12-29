import 'package:flutter/material.dart';
import '../../../../config/theme/app_theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.deepSpace, AppTheme.spaceBlack],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        border: Border(
          top: BorderSide(
            color: AppTheme.holoBlue.withValues(alpha: .2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.imperialYellow, AppTheme.holoBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.imperialYellow.withValues(alpha: .2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppTheme.spaceBlack,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'HOLOCRON',
                style: AppTheme.heading2.copyWith(
                  color: AppTheme.imperialYellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Your gateway to the Star Wars universe',
            style: AppTheme.bodyText.copyWith(
              fontSize: 14,
              color: AppTheme.lightGray.withValues(alpha: .7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            width: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.holoBlue.withValues(alpha: .5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _FooterLink(text: 'About', onTap: () {}),
              _FooterLink(text: 'Privacy', onTap: () {}),
              _FooterLink(text: 'Terms', onTap: () {}),
              _FooterLink(text: 'Support', onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© 2024 Holocron. All rights reserved.',
            style: AppTheme.caption.copyWith(
              fontSize: 11,
              color: AppTheme.lightGray.withValues(alpha: .5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Star Wars and all associated names and characters are trademarks of Lucasfilm Ltd.',
            style: AppTheme.caption.copyWith(
              fontSize: 10,
              color: AppTheme.lightGray.withValues(alpha: .4),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({required this.text, required this.onTap});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: AppTheme.caption.copyWith(
            fontSize: 12,
            color: _isHovered
                ? AppTheme.holoBlue
                : AppTheme.lightGray.withValues(alpha: .6),
            decoration: _isHovered ? TextDecoration.underline : null,
            decorationColor: AppTheme.holoBlue,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
