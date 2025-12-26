import 'dart:async';

import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/authentication/domain/usecases/get_current_user.dart';
import 'package:chat_app/features/chat/domain/entities/message.dart';
import 'package:chat_app/features/chat/domain/usecase/cleanActionGroup.dart';
import 'package:chat_app/features/chat/domain/usecase/deleteMessage.dart';
import 'package:chat_app/features/chat/domain/usecase/load_more_message.dart';
import 'package:chat_app/features/chat/domain/usecase/send_message.dart';
import 'package:chat_app/features/chat/domain/usecase/setActionGroup.dart';
import 'package:chat_app/features/chat/domain/usecase/stream_message.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:chat_app/features/chat/presentation/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState>{
  final SetActionGroup setActionGroup;
  final CleanActionGroup cleanActionGroup;
  final StreamMessage streamMessage;
  final LoadMoreMessages loadMoreMessages;
  final SendMessage sendMessage;
  final GetCurrentUser getCurrentUser;
  final DeleteMessage deleteMessage;

  StreamSubscription<List<Message>>? _subscription;
  String? _groupId;
  String? _userId;

  ChatBloc({
      required this.setActionGroup,
      required this.cleanActionGroup,
      required this.streamMessage,
      required this.loadMoreMessages,
      required this.sendMessage,
      required this.getCurrentUser,
      required this.deleteMessage,
  }) : super(ChatState.initial()){
    on<ChatStartedEvent>(_onChatStated);
    on<ChatMessagesUpdateEvent>(_onMessagesUpdated);
    on<ChatLoadMoreEvent>(_onLoadMore);
    on<ChatSendMessageEvent>(_onSendMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
  }

  @override
  Future<void> close() async {
    await cleanActionGroup(_userId!);
    await _subscription?.cancel();
    return super.close();
  }

  Future<void> _onChatStated(ChatStartedEvent event, Emitter<ChatState> emit) async {
    _groupId = event.groupId;
    _userId = event.userId;

    emit(state.copyWith(isLoading: true));

    await setActionGroup(SetActionGroupParams(_groupId!, _userId!));
    await _subscription?.cancel();

    _subscription = streamMessage(event.groupId).listen(
        (messages){
          add(ChatMessagesUpdateEvent(messages));
        },
      onError: (e){
          emit(state.copyWith(error: e.toString()));
      }
    );
  }

  void _onMessagesUpdated(ChatMessagesUpdateEvent event, Emitter<ChatState> emit,) {
    emit(state.copyWith(
      messages: event.messages,
      isLoading: false,
    ));
  }

  Future<void> _onLoadMore(ChatLoadMoreEvent event, Emitter<ChatState> emit,) async {
    if (state.isLoadingMore || !state.hasMore) return;

    emit(state.copyWith(isLoadingMore: true));

    final lastMessage = state.messages.last;

    final result = await loadMoreMessages(
      LoadMoreParams(
        groupId: _groupId!,
        lastMessage: lastMessage,
      ),
    );

    result.fold(
          (failure) {
            emit(state.copyWith(
              isLoadingMore: false,
              error: failure.message,
            ));
          },
          (olderMessages) {
            emit(state.copyWith(
              messages: [...state.messages, ...olderMessages],
              isLoadingMore: false,
              hasMore: olderMessages.isNotEmpty,
            ));
      },
    );
  }

  Future<void> _onSendMessage(ChatSendMessageEvent event, Emitter<ChatState> emit,) async {
    final userResult = await getCurrentUser(NoParams());
    Message message = Message(
        id: '',
        groupId: event.message.groupId,
        senderId: event.message.senderId,
        content: event.message.content,
        type: event.message.type,
        createdAt: DateTime.now(),
        senderName: event.message.senderName
    );
    userResult.fold(
        (failure){
          // print("Không lấy được user");
        },
        (user){
          // print("đã lấy user ${user?.displayName}");
          message = message.copyWith(senderName: user?.displayName);
        }
    );
    // print(message);
    final result = await sendMessage(message);

    result.fold(
          (failure) => emit(state.copyWith(error: failure.message)),
          (newId) {
            // final updatedMessage = event.message.copyWith(id: newId);
            // emit(state.copyWith(messages: [updatedMessage, ...state.messages],));
          },
    );
  }

  Future<void> _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async{
    // final currentState = state;

    final rs = await deleteMessage(DeleteMessageParams(event.groupId, event.messageId));

    rs.fold(
        (failure){
          state.copyWith(error: failure.message);
        },
        (_){

        });
  }
}

