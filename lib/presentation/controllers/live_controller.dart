import 'package:get/get.dart';
import 'package:gain_quest/data/sources/firebase_service.dart';

class LiveController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final RxList<Map<String, dynamic>> liveStreams = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLiveStreams();
    
  
    _firebaseService.getLiveStreamsStream().listen((streams) {
      liveStreams.assignAll(streams);
    });
  }

  Future<void> loadLiveStreams() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _createSampleLiveStreams();
      
    } catch (e) {
      errorMessage.value = 'Failed to load live streams: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStreams() async {
    await loadLiveStreams();
  }

  Future<void> _createSampleLiveStreams() async {

    List<Map<String, dynamic>> sampleStreams = [
      {
        'id': 'stream1',
        'title': 'Q4 Sales Sprint - Live Updates',
        'teamName': 'Sales Stars',
        'teamId': 'team2',
        'isLive': true,
        'viewerCount': 45,
        'category': 'Sales',
        'thumbnailUrl': 'https://via.placeholder.com/300x200/00B894/FFFFFF?text=Sales+Sprint',
        'description': 'Follow our sales team as they work towards their Q4 targets!',
        'startedAt': DateTime.now().subtract(Duration(minutes: 15)).millisecondsSinceEpoch,
      },
      {
        'id': 'stream2',
        'title': 'Product Launch Countdown',
        'teamName': 'Tech Titans',
        'teamId': 'team1',
        'isLive': true,
        'viewerCount': 78,
        'category': 'Technology',
        'thumbnailUrl': 'https://via.placeholder.com/300x200/6C5CE7/FFFFFF?text=Product+Launch',
        'description': 'Watch our tech team prepare for the big product launch!',
        'startedAt': DateTime.now().subtract(Duration(hours: 1)).millisecondsSinceEpoch,
      },
      {
        'id': 'stream3',
        'title': 'Creative Campaign Brainstorm',
        'teamName': 'Marketing Mavericks',
        'teamId': 'team3',
        'isLive': true,
        'viewerCount': 23,
        'category': 'Marketing',
        'thumbnailUrl': 'https://via.placeholder.com/300x200/FFD93D/000000?text=Campaign+Ideas',
        'description': 'Join our marketing team\'s creative session for the new campaign!',
        'startedAt': DateTime.now().subtract(Duration(minutes: 30)).millisecondsSinceEpoch,
      },
    ];

    
    liveStreams.assignAll(sampleStreams);
  }

  Future<void> startLiveStream(Map<String, dynamic> streamData) async {
    try {
      await _firebaseService.createLiveStream(streamData);
      await refreshStreams();
    } catch (e) {
      Get.snackbar('Error', 'Failed to start live stream: ${e.toString()}');
    }
  }
}