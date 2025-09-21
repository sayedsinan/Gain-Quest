import 'package:flutter/material.dart';
import 'package:gain_quest/presentation/controllers/live_controller.dart';
import 'package:gain_quest/presentation/screens/live/live_stream_detail_screen.dart';
import 'package:gain_quest/presentation/widgets/empty_state.dart';
import 'package:gain_quest/presentation/widgets/live_stream_card.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class LiveStreamsScreen extends StatelessWidget {
  final LiveController controller = Get.put(LiveController());

   LiveStreamsScreen({super.key});

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
          return const EmptyState(
            icon: Icons.live_tv_outlined,
            message: "No Live Streams",
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshStreams,
          child: AnimationLimiter(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
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
                        onTap: () => Get.to(
                            () => LiveStreamDetailScreen(stream: stream)),
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
          
          Get.snackbar('Info', 'Start streaming feature coming soon!');
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: 'Start Live Stream',
        child:const  Icon(Icons.videocam),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        const   CircularProgressIndicator(),
          const SizedBox(height: 16),
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

 
}

