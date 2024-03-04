import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'picture_event.dart';
part 'picture_state.dart';

class PictureBloc extends Bloc<PictureEvent, PictureState> {
  FirebaseStorage storage = FirebaseStorage.instance;
  PictureBloc() : super(PictureInitial()) {
    on<UploadPictureEvent>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        if (event.image.isNotEmpty) {}
      } catch (e) {
        emit(UploadPictureFailure(message: e.toString()));
      }
    });

    on<SelectPictureEvent>((event, emit) async {
      final imagePicker = ImagePicker();
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        final pickedFile =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();

          Reference referenceRoot = storage.ref();
          Reference refDirImages = referenceRoot.child("images");
          Reference refImageToUpload = refDirImages.child(fileName);

          await refImageToUpload.putFile(File(pickedFile.path));
          String imageUrl = await refImageToUpload.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: event.email)
              .get()
              .then((value) {
                value.docs.forEach((doc) {
                  doc.reference.update({'image':imageUrl});
                 });
              });

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
