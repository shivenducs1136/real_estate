import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:real_estate/helper/remote_config.dart';

class Credentials {
  static String COMPANY_NAME = RemoteConfig().getCOMPANY_NAME();
  static String COMPANY_EMAIL = RemoteConfig().getCOMPANY_EMAIL();
  static String API_KEY = RemoteConfig().getAPI_KEY();
  static String EMAIL_ID = RemoteConfig().getEMAIL_ID();
  static String PASSWORD = RemoteConfig().getPASSWORD();
  static String ADMIN_ID = RemoteConfig().getADMIN_ID();
  static String ADMIN_PASSWORD = RemoteConfig().getADMIN_PASSWORD();
}
