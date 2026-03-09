import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephen_farmer/core/common/role_bg_color.dart';
import 'package:stephen_farmer/core/utils/images.dart';
import 'package:stephen_farmer/feature/auth/presentation/controller/login_controller.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<LoginController>();

    return Obx(() {
      final role = authController.role.value;
      final isInterior = RoleBgColor.isInterior(role);
      final titleColor = isInterior ? const Color(0xFF1F1B16) : Colors.white;
      final subtitleColor = isInterior
          ? const Color(0xFF5F584B)
          : const Color(0xFF9A9A9A);
      final fieldBorderColor = isInterior
          ? const Color(0xFF9B927F)
          : const Color(0xFF5B6670);
      final fieldFillColor = isInterior
          ? const Color(0xFFF2EEE6)
          : const Color(0xFF161E23);
      final logoutColor = const Color(0xFFFF2222);
      final displayName = authController.displayName.isEmpty
          ? 'User'
          : authController.displayName;
      final displayEmail = authController.displayEmail.isEmpty
          ? authController.email.value.trim().isEmpty
                ? 'No email available'
                : authController.email.value.trim()
          : authController.displayEmail;
      final displayRole = _formatRole(authController.normalizedRoleKey);
      final avatar = authController.displayAvatar;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: RoleBgColor.overlayStyle(role),
        child: Scaffold(
          backgroundColor: RoleBgColor.scaffoldColor(role),
          body: Container(
            decoration: RoleBgColor.decoration(role),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: Get.back,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: titleColor,
                            size: 18,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Personal Info',
                          style: GoogleFonts.outfit(
                            color: titleColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage Your Profile',
                          style: GoogleFonts.manrope(
                            color: subtitleColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 26),
                        Center(
                          child: Column(
                            children: [
                              _ProfileAvatar(
                                avatarUrl: avatar,
                                radius: 28,
                                isInterior: isInterior,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                displayName,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  color: titleColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '($displayRole)',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  color: titleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                displayEmail,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.manrope(
                                  color: titleColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 26),
                        Container(
                          height: 56,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: fieldFillColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: fieldBorderColor),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: isInterior
                                      ? const Color(0xFFCFBE9A)
                                      : const Color(0xFFC7B08A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 16,
                                  color: isInterior
                                      ? const Color(0xFF594C34)
                                      : Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  displayName,
                                  style: GoogleFonts.manrope(
                                    color: titleColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              final shouldLogout = await _showLogoutDialog(
                                context: context,
                                isInterior: isInterior,
                              );
                              if (shouldLogout == true) {
                                await authController.logoutUser();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: logoutColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Logout',
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<bool?> _showLogoutDialog({
    required BuildContext context,
    required bool isInterior,
  }) {
    final dialogBorderColor = isInterior
        ? const Color.fromRGBO(109, 111, 115, 1)
        : const Color(0xFF5D6570);
    final dialogBackground = isInterior
        ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(226, 221, 215, 1),
              Color.fromRGBO(144, 137, 120, 1),
            ],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F1A20), Color(0xFF0A141A)],
          );
    final accentColor = isInterior
        ? const Color(0xFF8E6500)
        : const Color(0xFFAF8C6A);
    final promptColor = isInterior ? const Color(0xFF040404) : Colors.white;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: dialogBorderColor, width: 2),
              gradient: dialogBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(AssetsImages.logout, height: 48, width: 48),
                const SizedBox(height: 14),
                Text(
                  'Are you sure ?',
                  style: GoogleFonts.manrope(
                    color: promptColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: accentColor,
                            side: BorderSide(color: accentColor, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.manrope(
                              color: accentColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Yes',
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'manager':
        return 'Site Manager';
      case 'user':
        return 'Client';
      default:
        final normalized = role.trim();
        if (normalized.isEmpty) return 'User';
        return normalized[0].toUpperCase() + normalized.substring(1);
    }
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.avatarUrl,
    required this.radius,
    required this.isInterior,
  });

  final String avatarUrl;
  final double radius;
  final bool isInterior;

  @override
  Widget build(BuildContext context) {
    final hasAvatar = avatarUrl.trim().isNotEmpty;
    return CircleAvatar(
      radius: radius,
      backgroundColor: isInterior
          ? const Color(0xFFE8DFD2)
          : const Color(0xFF182127),
      backgroundImage: hasAvatar
          ? NetworkImage(avatarUrl.trim())
          : const AssetImage(AssetsImages.placeholder) as ImageProvider,
    );
  }
}
