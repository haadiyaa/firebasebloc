import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PictureUpload {
  Future<String> uploadImage(String file, String uid) async {
    try {
      
      File imageFile = File(file);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("images");

      await firebaseStorageRef.putFile(imageFile);
      
      String url = await firebaseStorageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: uid)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.update({'image': url});
        });
      });
      print('picture uploading');
      return url;
    } catch (e) {
      return "$e error";
    }
  }
}
