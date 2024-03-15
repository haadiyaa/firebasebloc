// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'picture_bloc.dart';

@immutable
sealed class PictureEvent {}

class SelectPictureEvent extends PictureEvent {
  String email;
  SelectPictureEvent(this.email);
}
