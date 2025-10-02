import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/activity/activity.dart';

import '../../core/ui/custom_checkbox.dart';

class ActivityEntry extends StatelessWidget {
  const ActivityEntry({
    super.key,
    required this.activity,
    required this.selected,
    required this.onChanged,
  });

  final Activity activity;
  final bool selected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: activity.imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => 
                  Image.asset('assets/user.jpg', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activity.timeOfDay.name.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  activity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          CustomCheckbox(
            key: ValueKey('${activity.ref}-checkbox'),
            value: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
