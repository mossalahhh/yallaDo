import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallado/features/ai/data/ai_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  const ChatMessage(this.text, this.isUser);
}

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  final List<ChatMessage> messages;
  final bool sending;
  ChatUpdated(this.messages, this.sending);
}

/// Holds the conversation and talks to `ai/chat`.
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final AiService _service = AiService();
  final List<ChatMessage> messages = [];

  Future<void> send(String prompt) async {
    messages.add(ChatMessage(prompt, true));
    emit(ChatUpdated(List.from(messages), true));

    final res = await _service.chat(prompt);
    final reply = (res.status && res.data is Map)
        ? (res.data['reply']?.toString() ?? '')
        : '';
    messages.add(ChatMessage(
      reply.isNotEmpty
          ? reply
          : (res.message.isNotEmpty ? res.message : 'Something went wrong'),
      false,
    ));
    emit(ChatUpdated(List.from(messages), false));
  }
}
