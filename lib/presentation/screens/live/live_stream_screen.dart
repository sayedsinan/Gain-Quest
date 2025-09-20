import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/live_controller.dart';
import 'package:gain_quest/presentation/screens/team/live_stream_detail_screen.dart';
import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LiveStreamsScreen extends StatelessWidget {
  final LiveController controller = Get.put(LiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Streams'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: controller.refreshStreams,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.liveStreams.isEmpty) {
          return _buildLoadingState();
        }

        if (controller.liveStreams.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshStreams,
          child: AnimationLimiter(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Get.width > 600 ? 3 : 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: controller.liveStreams.length,
              itemBuilder: (context, index) {
                final stream = controller.liveStreams[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: Get.width > 600 ? 3 : 2,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: LiveStreamCard(
                        stream: stream,
                        onTap: () => Get.to(() => LiveStreamDetailScreen(stream: stream)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Start a live stream
          Get.snackbar('Info', 'Start streaming feature coming soon!');
        },
        child: Icon(Icons.videocam),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Start Live Stream',
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading live streams...',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv_outlined,
            size: 64,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No Live Streams',
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Check back later for live team events',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshStreams,
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

class LiveStreamCard extends StatelessWidget {
  final Map<String, dynamic> stream;
  final VoidCallback onTap;

  const LiveStreamCard({
    Key? key,
    required this.stream,
    required this.onTap,
  }) : super(key: key);

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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Get.theme.colorScheme.surface,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
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
                                  color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Get.theme.colorScheme.surface,
                                child: Icon(
                                  Icons.live_tv,
                                  size: 40,
                                  color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                                ),
                              ),
                            )
                          : Icon(
                              Icons.live_tv,
                              size: 40,
                              color: Get.theme.colorScheme.onSurface.withOpacity(0.3),
                            ),
                    ),
                  ),
                  // Live indicator
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
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
                  // Viewer count
                  if (stream['viewerCount'] != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 2),
                            Text(
                              '${stream['viewerCount']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
            
            // Stream info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
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
                    SizedBox(height: 4),
                    Text(
                      stream['teamName'] ?? 'Unknown Team',
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Spacer(),
                    if (stream['category'] != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                            fontSize: 10,
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