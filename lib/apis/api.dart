import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/model/customer_model.dart';
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
    final data = await firestore.collection('agents').doc(agentEmail).get();

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
    await firestore.collection('agents').doc(a.id).update({
      'photo': imageUrl,
    });
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllAgents() {
    return firestore.collection('agents').snapshots();
  }

  static Future<void> assignPropertyToAgent(Property p, AgentModel a) async {
    await firestore
        .collection('property')
        .doc(p.id)
        .collection('assigned_agents')
        .doc(a.id)
        .set({'agent_id': a.id});
    await firestore
        .collection('agents')
        .doc(a.id)
        .collection('assigned_properties')
        .doc(p.id)
        .set({'property_id': p.id});
  }

  static Future<void> addCustomer(CustomerModel c) async {
    return await firestore
        .collection('customer')
        .doc(c.customer_id)
        .set(c.toJson());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getPropertyByPropertyId(
      String propId) {
    return FirebaseFirestore.instance
        .collection('property')
        .doc(propId)
        .snapshots();
  }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getAgentAssignedPropertyId(
  //     AgentModel a) {
  //   return firestore
  //       .collection("agents")
  //       .doc("${a.id}")
  //       .collection("assigned_properties")
  //       .snapshots();
  // }

  static Future<List<Property>> getAssignedPropertyofAgents(
      AgentModel a) async {
    List<Property> p = [];
    var propId = await firestore
        .collection("agents")
        .doc(a.id)
        .collection("assigned_properties")
        .get();
    for (var ele in propId.docs) {
      var propertySnapshot =
          await firestore.collection("property").doc(ele.id).get();
      p.add(Property(
          property_name: propertySnapshot.get('property_name'),
          bedrooms: propertySnapshot.get('bedrooms'),
          cost: propertySnapshot.get('cost'),
          bathrooms: propertySnapshot.get('bathrooms'),
          garages: propertySnapshot.get('garages'),
          area: propertySnapshot.get('area'),
          id: propertySnapshot.get('id'),
          address: propertySnapshot.get('address'),
          lat: propertySnapshot.get('lat'),
          lon: propertySnapshot.get('lon'),
          showImg: propertySnapshot.get('showImg'),
          yearBuilt: propertySnapshot.get('yearBuilt')));
    }
    log(p.toString());
    return p;
  }
}
/**.get()
            .data()
            .then((propertySnapshot) {
          log("propertySnapshot : ${propertySnapshot.data()}");
          if (propertySnapshot != null) {
            list.add(Property(
                property_name: propertySnapshot.get('property_name'),
                bedrooms: propertySnapshot.get('bedrooms'),
                cost: propertySnapshot.get('cost'),
                bathrooms: propertySnapshot.get('bathrooms'),
                garages: propertySnapshot.get('garages'),
                area: propertySnapshot.get('area'),
                id: propertySnapshot.get('id'),
                address: propertySnapshot.get('address'),
                lat: propertySnapshot.get('lat'),
                lon: propertySnapshot.get('lon'),
                showImg: propertySnapshot.get('showImg'),
                yearBuilt: propertySnapshot.get('yearBuilt')));
          } */