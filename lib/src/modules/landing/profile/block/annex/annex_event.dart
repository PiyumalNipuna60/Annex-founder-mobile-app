import 'package:equatable/equatable.dart';
import 'dart:io';
import '../../../../../model/annex/annex_model.dart';

abstract class AnnexEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SubmitAnnexDetailsEvent extends AnnexEvent {
  final AnnexModel annexModel;
  final List<File> newImages; // New images to be uploaded

  SubmitAnnexDetailsEvent({
    required this.annexModel,
    required this.newImages,
  });

  @override
  List<Object> get props => [annexModel, newImages];
}

class UpdateAnnexDetailsEvent extends AnnexEvent {
  final AnnexModel annexModel;
  final List<File> newImages; // New images to be uploaded

  UpdateAnnexDetailsEvent({
    required this.annexModel,
    required this.newImages,
  });

  @override
  List<Object> get props => [annexModel, newImages];
}
