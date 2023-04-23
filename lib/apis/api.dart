import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate/model/activity_model.dart';
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
    return await firestore.collection('agents').doc(a.email).set(a.toJson());
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

  static Stream<Property?> getAssignedProperty(String customerId) async* {
    final cs = await firestore.collection("customer").doc(customerId).get();
    try {
      CustomerModel cm = CustomerModel.fromJson(cs.data()!);
      for (var propid in cm.property_id) {
        final propdata =
            await firestore.collection("property").doc(propid).get();

        Property p = Property.fromJson(propdata.data()!);
        yield p;
      }
    } catch (e) {
      yield null;
    }
  }

  static Future<CustomerModel?> isCustomerExists(String phoneNumber) async {
    final data = await firestore.collection("customer").get();
    for (var ele in data.docs) {
      CustomerModel c = CustomerModel.fromJson(ele.data());
      if (c.phonenumber == phoneNumber) {
        return c;
      }
    }
    return null;
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

  static Future<Property?> getPropertyByPropertyId(String propId) async {
    final data = await FirebaseFirestore.instance
        .collection('property')
        .doc(propId)
        .get();
    if (data != null || data.data() != null) {
      return Property.fromJson(data.data()!);
    }
    return null;
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

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAssignedCustomers(
      AgentModel a, Property p) {
    return firestore
        .collection("customer")
        .where('agent_id', arrayContains: a.id)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCustomers() {
    return firestore.collection("customer").snapshots();
  }

  static Future<void> deleteAgentWithAgentId(String agentId) async {
    final propertyDocs = await firestore.collection("property").get();

    for (var prop in propertyDocs.docs) {
      await firestore
          .collection("property")
          .doc(prop.id)
          .collection("assigned_agents")
          .doc(agentId)
          .delete();
    }
    final customerDocs = await firestore.collection("customer").get();

    for (var cust in customerDocs.docs) {
      final data = await firestore.collection("customer").doc(cust.id).get();
      if (data != null) {
        CustomerModel? c = CustomerModel.fromJson(data.data()!);
        if (c.agent_id.contains(agentId)) {
          List<dynamic> mlist = c.agent_id;
          List<dynamic> mprop = c.property_id;
          int ele = 0;
          for (int idx = 0; idx < mlist.length; idx++) {
            if (mlist[idx] == agentId) {
              ele = idx;
              break;
            }
          }
          mprop.remove(mprop[ele]);
          mlist.remove(agentId);
          await firestore.collection("customer").doc(cust.id).set(CustomerModel(
                  customer_name: c.customer_name,
                  property_id: mprop,
                  agent_id: mlist,
                  phonenumber: c.phonenumber,
                  address: c.address,
                  customer_id: c.customer_id,
                  isLoan: c.isLoan,
                  isPurchase: c.isPurchase)
              .toJson());
        }
      }
    }
    activityDeleteAgent(msg: "Admin deleted Agent with email id - ${agentId}");
    await firestore.collection('agents').doc(agentId).delete();
  }

  static Future<void> updateEmailAndPassword(
      String newEmail, String newPassword) async {
    await firestore
        .collection("agents")
        .doc(newEmail)
        .update({"password": newPassword});
  }

  static Future<CustomerModel?> getCustomerById(String customerId) async {
    final data = await firestore.collection("customer").doc(customerId).get();
    if (data != null) {
      return CustomerModel.fromJson(data.data()!);
    } else {
      return null;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getActivity() {
    return firestore.collection("activity").snapshots();
  }

  static Future<AgentModel?> getSpecificAgentDetail(String email) async {
    final mdata = await firestore.collection("agents").doc(email).get();
    if (mdata.data() != null) {
      return AgentModel.fromJson(mdata.data()!);
    } else {
      return null;
    }
  }

  static Stream<List<LatLng>> getAgentCoordinates(
      CustomerModel c, String propId, String agentId) async* {
    final mdata = await firestore
        .collection("tracking")
        .doc(propId)
        .collection(agentId)
        .doc(c.customer_id)
        .collection("coordinates")
        .get();
    List<LatLng> mlist = [];
    for (var ele in mdata.docs) {
      final data = ele.data();
      log(data.toString());
      mlist.add(LatLng(double.parse(data['lat']), double.parse(data['long'])));
    }
    yield mlist;
  }

  static Stream<AgentModel?> getAssignedAgentwithProperty(
      Property mproperty) async* {
    final agentIds = await firestore
        .collection("property")
        .doc(mproperty.id)
        .collection("assigned_agents")
        .get();

    for (var element in agentIds.docs) {
      AgentModel? a = await getSpecificAgentDetail(element.id);
      yield a;
    }
  }

  static Stream<CustomerModel> getClientsofProperty(Property mproperty) async* {
    final customerDocs = await firestore.collection("customer").get();

    for (var element in customerDocs.docs) {
      CustomerModel? a = await getCustomerById(element.id);
      if (a != null) {
        if (a.property_id.contains(mproperty.id)) {
          yield a;
        }
      }
    }
  }

  static Stream<CustomerModel> getCustomerWhoWantLoan() async* {
    final customerDocs = await firestore.collection("customer").get();

    for (var element in customerDocs.docs) {
      CustomerModel? a = await getCustomerById(element.id);
      if (a != null) {
        if (a.isLoan == true) {
          yield a;
        }
      }
    }
  }

  static void submitReview(CustomerModel c, String review) async {
    await firestore.collection("customer").doc(c.customer_id).set(CustomerModel(
            address: c.address,
            agent_id: c.agent_id,
            customer_id: c.customer_id,
            customer_name: c.customer_name,
            isLoan: c.isLoan,
            phonenumber: c.phonenumber,
            property_id: c.property_id,
            review: review,
            isPurchase: c.isPurchase)
        .toJson());
  }

  static void setisLoan(CustomerModel c, bool isLoan) async {
    await firestore.collection("customer").doc(c.customer_id).set(CustomerModel(
            address: c.address,
            agent_id: c.agent_id,
            customer_id: c.customer_id,
            customer_name: c.customer_name,
            isLoan: isLoan,
            phonenumber: c.phonenumber,
            property_id: c.property_id,
            review: c.review,
            isPurchase: c.isPurchase)
        .toJson());
  }

  static Future<bool> isAgentExists(String emailid) async {
    final agent = await firestore.collection("agents").doc(emailid).get();
    if (agent == null) {
      return false;
    }
    return true;
  }

  static toDouble(String num) {
    return double.parse(num);
  }

  static Future<void> activityAddProperty(
      {required String property_id,
      required String msg,
      String? agent_id = "",
      String? customer_id = "",
      bool? isAdmin = true}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "1",
            property_id: property_id,
            agent_id: agent_id!,
            customer_id: customer_id!,
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityAssignedProperty(
      {required String property_id,
      required String msg,
      required String agent_id,
      required String customer_id,
      bool? isAdmin = true}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "19",
            property_id: property_id,
            agent_id: agent_id!,
            customer_id: customer_id!,
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityLogin(String agentId, String msg) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "9",
            property_id: "",
            agent_id: agentId,
            customer_id: "",
            msg: msg,
            isAdmin: false,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityLogout(String agentId, String msg) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "9",
            property_id: "",
            agent_id: agentId,
            customer_id: "",
            msg: msg,
            isAdmin: false,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityGenerateOtp({
    required String property_id,
    required String msg,
    required String agent_id,
    required String customer_id,
  }) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "400",
            property_id: property_id,
            agent_id: agent_id,
            customer_id: customer_id,
            msg: msg,
            isAdmin: false,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityUpdateProperty(
      {required String property_id,
      required String msg,
      String? agent_id = "",
      String? customer_id = "",
      bool? isAdmin = true}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "5",
            property_id: property_id,
            agent_id: agent_id!,
            customer_id: customer_id!,
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityAddAgent(
      {String? property_id = "",
      required String msg,
      required String agent_id,
      String? customer_id = "",
      bool? isAdmin = true}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "2",
            property_id: property_id!,
            agent_id: agent_id!,
            customer_id: customer_id!,
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityUpdateAgent(
      {String? property_id = "",
      required String msg,
      required String agent_id,
      String? customer_id = "",
      bool? isAdmin = true}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "6",
            property_id: property_id!,
            agent_id: agent_id!,
            customer_id: customer_id!,
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityDeleteAgent(
      {bool? isAdmin = true, required String msg}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "3",
            property_id: "",
            agent_id: "",
            customer_id: "",
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityDeleteProperty(
      {bool? isAdmin = true, required String msg}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "7",
            property_id: "",
            agent_id: "",
            customer_id: "",
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }

  static Future<void> activityCallAgent(
      {bool? isAdmin = true, required String msg}) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    await firestore.collection("activity").doc(dateTime).set(ActivityModel(
            code: "4",
            property_id: "",
            agent_id: "",
            customer_id: "",
            msg: msg,
            isAdmin: isAdmin!,
            dateTime: dateTime)
        .toJson());
  }
}
