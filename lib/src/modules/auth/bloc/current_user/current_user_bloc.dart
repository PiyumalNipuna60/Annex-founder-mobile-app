import 'dart:async';
import 'dart:io';

import 'package:annex_finder/src/services/repository/image_upload/firebase_image.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../model/user_model/user_model.dart';
import '../../../../services/repository/auth/user.dart'; // Assuming your service is here

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final MyUsers _userRepository;

  // Constructor with dependency injection for user repository
  CurrentUserBloc({required MyUsers userRepository})
      : _userRepository = userRepository,
        super(CurrentUserInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<CurrentUserBlockEvent>(_onBlockUser);
    on<CurrentUserUnBlockEvent>(_onUnblockUser);
    on<CurrentUserUpdateEvent>(_onUserUpdate);
  }

  // Handler for getting the current user profile
  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<CurrentUserState> emit) async {
    emit(CurrentUserLoading()); // Emit loading state
    try {
      final currentUser =
          await _userRepository.getCurrentUserProfile(); // Fetch user profile
      if (currentUser != null) {
        emit(CurrentUserLoaded(
            user: currentUser)); // Emit loaded state with user data
      } else {
        emit(const CurrentUserError(
            message: "No user found.")); // Emit error state
      }
    } catch (error) {
      emit(const CurrentUserError(
          message:
              "Failed to fetch current user profile.")); // Emit error state
    }
  }

  // Handler for blocking a user
  Future<void> _onBlockUser(
      CurrentUserBlockEvent event, Emitter<CurrentUserState> emit) async {
    try {
      await _userRepository.blockUser(event.userId); // Call block user function
      emit(CurrentUserBlocked(userId: event.userId)); // Emit blocked state
    } catch (error) {
      emit(const CurrentUserError(
          message: "Failed to block user.")); // Emit error state
    }
  }

  // Handler for unblocking a user
  Future<void> _onUnblockUser(
      CurrentUserUnBlockEvent event, Emitter<CurrentUserState> emit) async {
    try {
      await _userRepository
          .unblockUser(event.userId); // Call unblock user function
      emit(CurrentUserUnblocked(userId: event.userId)); // Emit unblocked state
    } catch (error) {
      emit(CurrentUserError(
          message: "Failed to unblock user.")); // Emit error state
    }
  }

  // Handler for updating the current user profile
  FutureOr<void> _onUserUpdate(
      CurrentUserUpdateEvent event, Emitter<CurrentUserState> emit) async {
    try {
      emit(CurrentUserLoading()); // Emit loading state

      // Check if there's an image file to upload
      String? imageUrl;
      if (event.imageFile != null) {
        // Upload the image and get the download URL
        imageUrl =
            await FirebaseImageUpload().uploadUserImage(event.imageFile!);
        if (imageUrl == null) {
          emit(const CurrentUserError(message: "Failed to upload image."));
          return;
        }
      }

      // Ensure all fields are non-null by falling back to existing values
      final updatedUser = event.myUser.copyWith(
        fullName: event.myUser.fullName ??
            event.myUser.fullName, // Keep the old fullName if not updated
        phoneNumber: event.myUser.phoneNumber ??
            event.myUser.phoneNumber, // Keep old phone number
        address: event.myUser.address ??
            event.myUser.address, // Keep the old address
        imageUrl: imageUrl ??
            event.myUser.imageUrl, // Keep the old imageUrl if not updated
      );

      // Update the user data in the repository
      final result = await _userRepository.getCurrentUserUpdate(
        event.userId,
        updatedUser,
      );

      if (result != null) {
        emit(CurrentUserLoaded(
            user: result)); // Emit loaded state with updated user
      } else {
        emit(const CurrentUserError(message: "Failed to update user."));
      }
    } catch (error) {
      emit(const CurrentUserError(
          message: "Failed to update user.")); // Emit error state
    }
  }
}
