import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/colors.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.tag,
    this.fontSize = 10,
    this.height = 20,
    this.chipColor,
    this.onChipColor,
  });

  final String tag;
  final double fontSize;
  final double height;
  final Color? chipColor;
  final Color? onChipColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      clipBehavior: Clip.hardEdge,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: chipColor ??
                Theme.of(context).extension<TagChipTheme>()?.chipColor ??
                AppColors.whiteTransparent,
          ),
          child: SizedBox(
            height: height,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFrom(tag),
                    color: onChipColor ??
                        Theme.of(context).extension<TagChipTheme>()?.onChipColor ??
                        Colors.white,
                    size: fontSize,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: _textStyle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFrom(String tag) {
    switch (tag) {
      case 'Adventure sports':
        return Icons.kayaking_outlined;
      case 'Beach':
        return Icons.beach_access_outlined;
      case 'City':
        return Icons.location_city_outlined;
      case 'Cultural experiences':
        return Icons.museum_outlined;
      case 'Foodie':
      case 'Food tours':
        return Icons.restaurant;
      case 'Hiking':
        return Icons.hiking;
      case 'Historic':
        return Icons.menu_book_outlined;
      case 'Island':
      case 'Coastal':
      case 'Lake':
      case 'River':
        return Icons.water;
      case 'Luxury':
        return Icons.attach_money_outlined;
      case 'Mountain':
      case 'Wildlife watching':
        return Icons.landscape_outlined;
      case 'Nightlife':
        return Icons.local_bar_outlined;
      case 'Off-the-beaten-path':
        return Icons.do_not_step_outlined;
      case 'Romantic':
        return Icons.favorite_border_outlined;
      case 'Rural':
        return Icons.agriculture_outlined;
      case 'Secluded':
        return Icons.church_outlined;
      case 'Sightseeing':
        return Icons.attractions_outlined;
      case 'Skiing':
        return Icons.downhill_skiing_outlined;
      case 'Wine tasting':
        return Icons.wine_bar_outlined;
      case 'Winter destination':
        return Icons.ac_unit;
      default:
        return Icons.label_outlined;
    }
  }

  TextStyle _textStyle(BuildContext context) => GoogleFonts.openSans(
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          color: onChipColor ??
              Theme.of(context).extension<TagChipTheme>()?.onChipColor ??
              Colors.white,
          textBaseline: TextBaseline.alphabetic,
        ),
      );
}

class TagChipTheme extends ThemeExtension<TagChipTheme> {
  final Color chipColor;
  final Color onChipColor;

  const TagChipTheme({required this.chipColor, required this.onChipColor});

  @override
  ThemeExtension<TagChipTheme> copyWith({Color? chipColor, Color? onChipColor}) {
    return TagChipTheme(
      chipColor: chipColor ?? this.chipColor,
      onChipColor: onChipColor ?? this.onChipColor,
    );
  }

  @override
  ThemeExtension<TagChipTheme> lerp(covariant ThemeExtension<TagChipTheme> other, double t) {
    if (other is! TagChipTheme) return this;
    return TagChipTheme(
      chipColor: Color.lerp(chipColor, other.chipColor, t) ?? chipColor,
      onChipColor: Color.lerp(onChipColor, other.onChipColor, t) ?? onChipColor,
    );
  }
}
