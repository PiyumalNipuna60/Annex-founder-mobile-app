import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/annex/annex_model.dart';
import '../../../../../services/repository/annex_service.dart';
import 'annex_event.dart';
import 'annex_state.dart';

class AnnexBloc extends Bloc<AnnexEvent, AnnexState> {
  final AnnexService _annexService;

  AnnexBloc(this._annexService) : super(AnnexInitial()) {
    on<SubmitAnnexDetailsEvent>(_onSubmitAnnexDetailsEvent);
    on<UpdateAnnexDetailsEvent>(_onUpdateAnnexDetailsEvent);
  }

  Future<void> _onSubmitAnnexDetailsEvent(
      SubmitAnnexDetailsEvent event, Emitter<AnnexState> emit) async {
    emit(AnnexLoading());

    try {
      List<String> imageUrls = [];
      for (File image in event.newImages) {
        String imageUrl =
            await _annexService.uploadImage(image, event.annexModel.userId!);
        imageUrls.add(imageUrl);
      }

      // Create an updated annex model with the image URLs
      AnnexModel updatedAnnex = event.annexModel.copyWith(imageUrls: imageUrls);

      await _annexService.addAnnexDetails(updatedAnnex);

      emit(AnnexLoaded(updatedAnnex));
    } catch (e) {
      emit(AnnexError('Failed to submit annex details: $e'));
    }
  }

  FutureOr<void> _onUpdateAnnexDetailsEvent(
      UpdateAnnexDetailsEvent event, Emitter<AnnexState> emit) async {
    emit(AnnexLoading());

    try {
      List<String> imageUrls = [];
      for (File image in event.newImages) {
        String imageUrl =
            await _annexService.uploadImage(image, event.annexModel.userId!);
        imageUrls.add(imageUrl);
      }

      // Create an updated annex model with the image URLs
      AnnexModel updatedAnnex = event.annexModel.copyWith(imageUrls: imageUrls);

      await _annexService.updateAnnexDetails(updatedAnnex);

      emit(AnnexLoaded(updatedAnnex));
    } catch (e) {
      emit(AnnexError('Failed to submit annex details: $e'));
    }
  }
}
