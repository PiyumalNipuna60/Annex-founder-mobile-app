import 'package:equatable/equatable.dart';

import '../../../../../model/annex/annex_model.dart';

abstract class AnnexState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AnnexInitial extends AnnexState {}

class AnnexLoading extends AnnexState {}

class AnnexLoaded extends AnnexState {
  final AnnexModel annex;

  AnnexLoaded(this.annex);

  @override
  List<Object?> get props => [annex];
}

class AnnexError extends AnnexState {
  final String errorMessage;

  AnnexError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
