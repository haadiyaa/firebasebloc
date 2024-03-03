// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picture_bloc.dart';

@immutable
abstract class PictureState {}

class PictureInitial extends PictureState {}

class UploadPictureFailure extends PictureState {
  final String message;
  UploadPictureFailure({
    required this.message,
  });
}

class UploadPictureLoading extends PictureState {}

class UploadPictureSuccess extends PictureState {
  final Uint8List userImage;
  
  UploadPictureSuccess({required this.userImage});
}
