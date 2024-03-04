// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picture_bloc.dart';

@immutable
sealed class PictureEvent {}

class UploadPictureEvent extends PictureEvent {
  Uint8List image;
  UploadPictureEvent({
    required this.image,
  });
}

class SelectPictureEvent extends PictureEvent {
  String email;
  SelectPictureEvent(this.email);
}
