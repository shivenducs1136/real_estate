import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/model/property_model.dart';

import '../model/agent_model.dart';

class APIs {
  static bool isLoggedin = false;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static bool adminLogin(String loginId, String password) {
    if (loginId == "admin" && password == "123") {
      return true;
    }
    return false;
  }

  static Future<bool> agentLogin(String agentEmail, String password) async {
    final data = await firestore.collection('agent').doc(agentEmail).get();

    log('data : $data');
    if (data.exists) {
      if (data.get('password').toString() == password) {
        return true;
      }
    }
    return false;
  }

  static Future<void> addPropertyToFirebase(Property p) async {
    return await firestore.collection('property').doc(p.id).set(p.toJson());
  }

  static Future<void> addAgentToFirebase(AgentModel a) async {
    return await firestore.collection('agents').doc(a.id).set(a.toJson());
  }

  static Future<void> addAgentImage(XFile file, AgentModel a) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');

    //storage file ref with path
    final ref = storage.ref().child('agent_pictures/${a.id}/${file.name}.$ext');

    //uploading image
    await ref
        .putFile(File(file.path), SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await firestore
        .collection('agents')
        .doc(a.id)
        .collection('photos')
        .doc("${file.name}.${ext}")
        .set({"image": imageUrl});
  }

  static Future<void> addPropertyPhotos(List<XFile> images, Property p) async {
    bool x = true;
    for (XFile file in images) {
      final ext = file.path.split('.').last;
      log('Extension: $ext');

      //storage file ref with path
      final ref =
          storage.ref().child('property_pictures/${p.id}/${file.name}.$ext');

      //uploading image
      await ref
          .putFile(File(file.path), SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      });

      //updating image in firestore database
      final imageUrl = await ref.getDownloadURL();
      await firestore
          .collection('property')
          .doc(p.id)
          .collection('photos')
          .doc("${file.name}.${ext}")
          .set({"image": imageUrl});
      if (x) {
        await firestore.collection('property').doc(p.id).update({
          'showImg': imageUrl,
        });
        x = false;
      }
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProperties() {
    return firestore.collection('property').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllPhotos(Property p) {
    return firestore
        .collection('property')
        .doc(p.id)
        .collection("photos")
        .snapshots();
  }
}
