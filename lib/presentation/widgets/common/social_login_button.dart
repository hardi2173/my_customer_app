import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  factory SocialLoginButton.google({required VoidCallback onPressed}) {
    return SocialLoginButton(
      onPressed: onPressed,
      icon: Icons.g_mobiledata,
      iconColor: Colors.black87,
      backgroundColor: Colors.white,
    );
  }

  factory SocialLoginButton.facebook({required VoidCallback onPressed}) {
    return SocialLoginButton(
      onPressed: onPressed,
      icon: Icons.facebook,
      iconColor: const Color(0xFF1877F2),
      backgroundColor: Colors.white,
    );
  }

  factory SocialLoginButton.apple({required VoidCallback onPressed}) {
    return SocialLoginButton(
      onPressed: onPressed,
      icon: Icons.apple,
      iconColor: Colors.black87,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 64,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: iconColor),
        ),
      ),
    );
  }
}
