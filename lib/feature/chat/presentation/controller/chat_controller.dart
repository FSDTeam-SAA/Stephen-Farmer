import 'dart:async';

import 'package:get/get.dart';

import '../../data/model/chat_model.dart';
import '../../data/service/chat_socket_service.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/repository/chat_repository.dart';

class ChatController extends GetxController {
  ChatController({
    required ChatRepository repository,
    required ChatSocketService socketService,
  }) : _repository = repository,
       _socketService = socketService;

  final ChatRepository _repository;
  final ChatSocketService _socketService;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<ChatEntity> chats = <ChatEntity>[].obs;
  final RxList<ChatMessageEntity> messages = <ChatMessageEntity>[].obs;
  final Rxn<ChatEntity> activeChat = Rxn<ChatEntity>();

  StreamSubscription<ChatMessageModel>? _messageSubscription;
  StreamSubscription<String>? _readSubscription;

  @override
  void onInit() {
    super.onInit();
    _bindSocket();
  }

  Future<void> loadChats() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      chats.assignAll(await _repository.getMyChats());
    } catch (_) {
      errorMessage.value = 'Failed to load chats.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<ChatEntity> openProjectChat(String projectId) async {
    final chat = await _repository.getOrCreateProjectChat(projectId);
    await _activateChat(chat);
    return chat;
  }

  Future<ChatEntity> openTaskChat(String taskId) async {
    final chat = await _repository.getOrCreateTaskChat(taskId);
    await _activateChat(chat);
    return chat;
  }

  Future<void> loadMessages(String chatId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      messages.assignAll(await _repository.getChatMessages(chatId));
      await _repository.markChatAsRead(chatId);
      _socketService.markRead(chatId);
    } catch (_) {
      errorMessage.value = 'Failed to load messages.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    final chat = activeChat.value;
    if (chat == null || text.trim().isEmpty) return;

    final payload = <String, dynamic>{'message': text.trim()};
    final sent = await _repository.sendMessage(chat.id, payload: payload);
    messages.add(sent);
    _socketService.sendMessage(chatId: chat.id, payload: payload);
  }

  Future<void> _activateChat(ChatEntity chat) async {
    activeChat.value = chat;
    await _socketService.connect();
    _socketService.joinChat(chat.id);
    await loadMessages(chat.id);
  }

  void _bindSocket() {
    _messageSubscription = _socketService.messages.listen((message) {
      if (activeChat.value?.id != message.chatId) return;
      messages.add(message);
    });
    _readSubscription = _socketService.readReceipts.listen((chatId) {
      if (activeChat.value?.id != chatId) return;
      final updatedChats = chats
          .map(
            (chat) => chat.id == chatId
                ? ChatModel(
                    id: chat.id,
                    projectId: chat.projectId,
                    taskId: chat.taskId,
                    title: chat.title,
                    lastMessage: chat.lastMessage,
                    updatedAt: chat.updatedAt,
                    unreadCount: 0,
                  )
                : chat,
          )
          .toList();
      chats.assignAll(updatedChats);
    });
  }

  @override
  void onClose() {
    _messageSubscription?.cancel();
    _readSubscription?.cancel();
    _socketService.disconnect();
    super.onClose();
  }
}
