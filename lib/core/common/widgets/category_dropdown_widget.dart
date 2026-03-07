import 'package:flutter/material.dart';

class CategoryDropdownWidget<T> extends StatelessWidget {
  final List<T> items;
  final int selectedIndex;
  final bool isMenuOpen;
  final bool isInteriorTheme;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelect;
  final String Function(T item) titleBuilder;
  final String Function(T item) subtitleBuilder;
  final String? Function(T item) thumbnailBuilder;
  final String fallbackAsset;

  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? chevronColor;
  final double borderRadius;
  final EdgeInsets rowPadding;
  final double thumbnailWidth;
  final double thumbnailHeight;
  final double thumbnailBorderRadius;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final double subtitleFontSize;
  final FontWeight subtitleFontWeight;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final double chevronSize;
  final double maxMenuHeight;
  final double? minHeight;

  const CategoryDropdownWidget({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.isMenuOpen,
    this.isInteriorTheme = false,
    required this.onToggle,
    required this.onSelect,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.thumbnailBuilder,
    required this.fallbackAsset,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.subtitleColor,
    this.chevronColor,
    this.borderRadius = 10,
    this.rowPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
    this.thumbnailWidth = 79,
    this.thumbnailHeight = 40,
    this.thumbnailBorderRadius = 6,
    this.titleFontSize = 14,
    this.titleFontWeight = FontWeight.w600,
    this.subtitleFontSize = 12,
    this.subtitleFontWeight = FontWeight.w400,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.chevronSize = 20,
    this.maxMenuHeight = 220,
    this.minHeight = 57,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final int safeSelectedIndex = selectedIndex.clamp(0, items.length - 1);
    final T selectedItem = items[safeSelectedIndex];
    final bool canExpand = items.length > 1;
    final resolvedBackgroundColor =
        backgroundColor ??
        (isInteriorTheme ? const Color(0xFFF3EFE7) : Colors.transparent);
    final resolvedBorderColor =
        borderColor ??
        (isInteriorTheme ? const Color(0xFF6B6458) : const Color(0xFFD7C5A4));
    final resolvedTitleColor =
        titleColor ??
        (isInteriorTheme ? const Color(0xFF131313) : Colors.white);
    final resolvedSubtitleColor =
        subtitleColor ??
        (isInteriorTheme ? const Color(0xFF5C554C) : const Color(0xFF8A979D));
    final resolvedChevronColor =
        chevronColor ??
        (isInteriorTheme ? const Color(0xFF584A2D) : const Color(0xFFD2A75D));

    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: resolvedBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onToggle,
                child: Padding(
                  padding: rowPadding,
                  child: _DropdownRow<T>(
                    item: selectedItem,
                    showChevron: canExpand,
                    isMenuOpen: isMenuOpen,
                    titleBuilder: titleBuilder,
                    subtitleBuilder: subtitleBuilder,
                    thumbnailBuilder: thumbnailBuilder,
                    fallbackAsset: fallbackAsset,
                    titleColor: resolvedTitleColor,
                    subtitleColor: resolvedSubtitleColor,
                    chevronColor: resolvedChevronColor,
                    thumbnailWidth: thumbnailWidth,
                    thumbnailHeight: thumbnailHeight,
                    thumbnailBorderRadius: thumbnailBorderRadius,
                    titleFontSize: titleFontSize,
                    titleFontWeight: titleFontWeight,
                    subtitleFontSize: subtitleFontSize,
                    subtitleFontWeight: subtitleFontWeight,
                    titleTextStyle: titleTextStyle,
                    subtitleTextStyle: subtitleTextStyle,
                    chevronSize: chevronSize,
                  ),
                ),
              ),
            ),
            if (isMenuOpen && canExpand) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: resolvedBorderColor.withValues(alpha: 0.35),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxMenuHeight),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < items.length; i++)
                        if (i != safeSelectedIndex)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => onSelect(i),
                              child: Padding(
                                padding: rowPadding,
                                child: _DropdownRow<T>(
                                  item: items[i],
                                  showChevron: false,
                                  isMenuOpen: false,
                                  titleBuilder: titleBuilder,
                                  subtitleBuilder: subtitleBuilder,
                                  thumbnailBuilder: thumbnailBuilder,
                                  fallbackAsset: fallbackAsset,
                                  titleColor: resolvedTitleColor,
                                  subtitleColor: resolvedSubtitleColor,
                                  chevronColor: resolvedChevronColor,
                                  thumbnailWidth: thumbnailWidth,
                                  thumbnailHeight: thumbnailHeight,
                                  thumbnailBorderRadius: thumbnailBorderRadius,
                                  titleFontSize: titleFontSize,
                                  titleFontWeight: titleFontWeight,
                                  subtitleFontSize: subtitleFontSize,
                                  subtitleFontWeight: subtitleFontWeight,
                                  titleTextStyle: titleTextStyle,
                                  subtitleTextStyle: subtitleTextStyle,
                                  chevronSize: chevronSize,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  const _DropdownRow({
    required this.item,
    required this.showChevron,
    required this.isMenuOpen,
    required this.titleBuilder,
    required this.subtitleBuilder,
    required this.thumbnailBuilder,
    required this.fallbackAsset,
    required this.titleColor,
    required this.subtitleColor,
    required this.chevronColor,
    required this.thumbnailWidth,
    required this.thumbnailHeight,
    required this.thumbnailBorderRadius,
    required this.titleFontSize,
    required this.titleFontWeight,
    required this.subtitleFontSize,
    required this.subtitleFontWeight,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.chevronSize,
  });

  final T item;
  final bool showChevron;
  final bool isMenuOpen;
  final String Function(T item) titleBuilder;
  final String Function(T item) subtitleBuilder;
  final String? Function(T item) thumbnailBuilder;
  final String fallbackAsset;
  final Color titleColor;
  final Color subtitleColor;
  final Color chevronColor;
  final double thumbnailWidth;
  final double thumbnailHeight;
  final double thumbnailBorderRadius;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final double subtitleFontSize;
  final FontWeight subtitleFontWeight;
  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final double chevronSize;

  @override
  Widget build(BuildContext context) {
    final thumb = thumbnailBuilder(item)?.trim() ?? '';

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(thumbnailBorderRadius),
          child: SizedBox(
            height: thumbnailHeight,
            width: thumbnailWidth,
            child: thumb.isNotEmpty
                ? Image.network(
                    thumb,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Image.asset(fallbackAsset, fit: BoxFit.cover),
                  )
                : Image.asset(fallbackAsset, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleBuilder(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (titleTextStyle ??
                            TextStyle(
                              color: titleColor,
                              fontSize: titleFontSize,
                              fontWeight: titleFontWeight,
                            ))
                        .copyWith(color: titleColor),
              ),
              Text(
                subtitleBuilder(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    (subtitleTextStyle ??
                            TextStyle(
                              color: subtitleColor,
                              fontSize: subtitleFontSize,
                              fontWeight: subtitleFontWeight,
                            ))
                        .copyWith(color: subtitleColor),
              ),
            ],
          ),
        ),
        if (showChevron)
          Icon(
            isMenuOpen
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: chevronColor,
            size: chevronSize,
          ),
      ],
    );
  }
}
