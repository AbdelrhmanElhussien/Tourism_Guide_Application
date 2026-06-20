import 'package:tourist_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:tourist_app/features/chat/data/models/conversation_model.dart';
import 'package:tourist_app/features/chat/data/models/chat_message_model.dart';
import 'package:tourist_app/features/guide/services/guide_service.dart';
import 'package:tourist_app/features/guide/models/guide_model.dart';

class ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  final GuideService _guideService;
  
  // Cache resolved guide details to avoid hitting the endpoint multiple times
  final Map<String, GuideModel> _guideCache = {};

  ChatRepository({
    ChatRemoteDataSource? remoteDataSource,
    GuideService? guideService,
  })  : _remoteDataSource = remoteDataSource ?? ChatRemoteDataSource(),
        _guideService = guideService ?? GuideService();

  Future<List<ConversationModel>> getConversations() async {
    final conversations = await _remoteDataSource.fetchConversations();
    
    // Resolve guide profiles in parallel
    final resolvedConversations = await Future.wait(
      conversations.map((conv) async {
        if (conv.otherUserId.isEmpty) return conv;
        try {
          GuideModel guide;
          if (_guideCache.containsKey(conv.otherUserId)) {
            guide = _guideCache[conv.otherUserId]!;
          } else {
            guide = await _guideService.fetchGuideDetails(conv.otherUserId);
            _guideCache[conv.otherUserId] = guide;
          }
          conv.otherUserName = guide.fullName;
          conv.otherUserImageUrl = guide.imageUrl;
        } catch (e) {
          // If guide details fail to fetch (e.g. invalid ID or network error), use a standard fallback
          conv.otherUserName = 'Tour Guide';
          conv.otherUserImageUrl = '';
        }
        return conv;
      }),
    );
    
    return resolvedConversations;
  }

  Future<List<ChatMessageModel>> getChatHistory(String currentUserId, String guideId) async {
    return await _remoteDataSource.fetchChatHistory(currentUserId, guideId);
  }
  
  Future<GuideModel?> getGuideDetails(String guideId) async {
    try {
      if (_guideCache.containsKey(guideId)) {
        return _guideCache[guideId];
      }
      final guide = await _guideService.fetchGuideDetails(guideId);
      _guideCache[guideId] = guide;
      return guide;
    } catch (_) {
      return null;
    }
  }
}
