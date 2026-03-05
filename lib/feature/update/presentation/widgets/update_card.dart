import 'package:flutter/material.dart';

import '../../data/model/update_model.dart';

class UpdatePostCard extends StatelessWidget {
  const UpdatePostCard({
    super.key,
    required this.item,
    this.isInteriorTheme = false,
  });

  final UpdateModel item;
  final bool isInteriorTheme;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isInteriorTheme
        ? Colors.transparent
        : Colors.transparent;
    final borderColor = isInteriorTheme
        ? Colors.transparent
        : Colors.white.withValues(alpha: .08);
    final primaryTextColor = isInteriorTheme
        ? const Color(0xFF1B1B1B)
        : Colors.white;
    final secondaryTextColor = isInteriorTheme
        ? const Color(0xFF6F6B62)
        : Colors.white.withValues(alpha: .55);
    final contentTextColor = isInteriorTheme
        ? const Color(0xFF1D1D1D)
        : Colors.white.withValues(alpha: .85);
    final metaStatColor = isInteriorTheme
        ? const Color(0xFFF3EEDD)
        : Colors.white.withValues(alpha: .65);
    final fallbackImage =
        "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=900&auto=format&fit=crop";
    final postImage = (item.thumbnailUrl?.trim().isNotEmpty ?? false)
        ? item.thumbnailUrl!.trim()
        : fallbackImage;

    return Container(
      // padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&h=200&fit=crop",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category.toUpperCase(),
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .4,
                      ),
                    ),
                  ],
                ),
              ),
              //Icon(Icons.more_horiz, color: secondaryTextColor),
            ],
          ),

          const SizedBox(height: 10),

          // Post text
          Text(
            item.description.trim().isEmpty ? item.title : item.description,
            style: TextStyle(
              color: contentTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                postImage,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Image.network(fallbackImage, fit: BoxFit.cover),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Reactions row
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              const SizedBox(width: 6),
              Text(
                "3",
                style: TextStyle(
                  color: isInteriorTheme ? Colors.white : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                "3 Comments",
                style: TextStyle(
                  color: metaStatColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "2 Shares",
                style: TextStyle(
                  color: metaStatColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Divider(color: isInteriorTheme ? const Color(0xCCCDC1A7) : Colors.white.withValues(alpha: .10), height: 1),
          const SizedBox(height: 6),

          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionBtn(
                icon: Icons.favorite_border,
                label: "Heart",
                onTap: () {},
                isInteriorTheme: isInteriorTheme,
              ),
              _ActionBtn(
                icon: Icons.mode_comment_outlined,
                label: "Comment",
                onTap: () {},
                isInteriorTheme: isInteriorTheme,
              ),
              _ActionBtn(
                icon: Icons.share_outlined,
                label: "Share",
                onTap: () {},
                isInteriorTheme: isInteriorTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isInteriorTheme;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isInteriorTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: isInteriorTheme ? const Color(0xFFD7C5A4) : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isInteriorTheme ? const Color(0xFFD7C5A4) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
