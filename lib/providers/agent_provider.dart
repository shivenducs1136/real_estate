import 'package:flutter/foundation.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/customer_model.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgentProvider extends ChangeNotifier {
  /// Internal, private state of the cart.
  AgentModel? agentModel;
  Property? propertyModel;
  CustomerModel? customerModel;
  bool isTracking = msprefs!.getBool("isTracking") ?? false;

  void initialise() {
    if (isTracking) {
      String propId = msprefs!.getString("propertyId").toString();
      String customerId = msprefs!.getString("customerId").toString();
      String agentId = msprefs!.getString("agentId").toString();
      APIs.getCustomerById(customerId).then((customer) {
        customerModel = customer;
        APIs.getPropertyByPropertyId(propId).then((value) {
          propertyModel = value;
        });
      });
      notifyListeners();
    }
  }

  /// The current total price of all items (assuming all items cost $42).
  AgentModel? get getAgent => agentModel;
  Property? get getProperty => propertyModel;
  CustomerModel? get getCustomer => customerModel;
  bool get trackingInfo => isTracking;

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void setAgent(AgentModel a) {
    agentModel = a;
    notifyListeners();
  }

  void setProperty(Property p) {
    propertyModel = p;
    notifyListeners();
  }

  void setCustomer(CustomerModel c) {
    customerModel = c;
    notifyListeners();
  }

  void setTracking() {
    isTracking = !isTracking;
    notifyListeners();
  }
}
