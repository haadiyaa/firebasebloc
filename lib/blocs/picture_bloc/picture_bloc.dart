import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  PictureBloc() : super(PictureInitial()) {
    on<UploadPictureEvent>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        if (event.image.isNotEmpty) {
          
        }
      } catch (e) {
        emit(UploadPictureFailure(message: e.toString()));
      }
    });
    
    on<SelectPictureEvent>((event, emit)async{
      final imagePicker=ImagePicker();
      try {
        final pickedFile=await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile!=null) {
          final bytes=await pickedFile.readAsBytes();
          emit(UploadPictureSuccess(userImage: bytes));
        } else {
          emit(UploadPictureFailure(message: 'not selected'));
        }
      } catch (e) {
        emit(UploadPictureFailure(message: 'error picking image:$e'));
        print(e);
      }
    });
  }
}
