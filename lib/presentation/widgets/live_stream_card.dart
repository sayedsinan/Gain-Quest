import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveStreamCard extends StatelessWidget {
  final Map<String, dynamic> stream;
  final VoidCallback onTap;

  const LiveStreamCard({
    super.key,
    required this.stream,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with live indicator
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Get.theme.colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: stream['thumbnailUrl'] != null
                          ? CachedNetworkImage(
                              imageUrl: stream['thumbnailUrl'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Get.theme.colorScheme.surface,
                                child: Icon(
                                  Icons.live_tv,
                                  size: 40,
                                  color: Get.theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Get.theme.colorScheme.surface,
                                child: Icon(
                                  Icons.live_tv,
                                  size: 40,
                                  color: Get.theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                ),
                              ),
                            )
                          : Icon(
                              Icons.live_tv,
                              size: 40,
                              color: Get.theme.colorScheme.onSurface
                                  .withOpacity(0.3),
                            ),
                    ),
                  ),
              
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding:const   EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                         const   SizedBox(width: 4),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (stream['viewerCount'] != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding:
                           const   EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           const  Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 12,
                            ),
                             const SizedBox(width: 2),
                            Text(
                              '${stream['viewerCount']}',
                              style:const  TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:const  EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stream['title'] ?? 'Live Stream',
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                   const SizedBox(height: 4),
                    Text(
                      stream['teamName'] ?? 'Unknown Team',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                   const Spacer(),
                    if (stream['category'] != null)
                      Container(
                        padding:
                           const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Get.theme.primaryColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          stream['category'],
                          style: TextStyle(
                            color: Get.theme.primaryColor,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
