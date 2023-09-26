import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  static final _remoteConfig = FirebaseRemoteConfig.instance;

  static initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
  }

  static setDefaults() async {
    await _remoteConfig.setDefaults(const {
      "COMPANY_NAME": "Tiwari Propmart",
      "COMPANY_EMAIL": "tiwaripropmart@gmail.com",
      "API_KEY": "",
      "EMAIL_ID": "tiwaripropmart.mail@gmail.com",
      "PASSWORD": "trbxdinhnmhqvdxn",
      "ADMIN_ID": "admin",
      "ADMIN_PASSWORD": "123",
    });
  }

  String getCOMPANY_NAME() => _remoteConfig.getString("COMPANY_NAME");
  String getCOMPANY_EMAIL() => _remoteConfig.getString("COMPANY_EMAIL");
  String getAPI_KEY() => _remoteConfig.getString("API_KEY");
  String getEMAIL_ID() => _remoteConfig.getString("EMAIL_ID");
  String getPASSWORD() => _remoteConfig.getString("PASSWORD");
  String getADMIN_ID() => _remoteConfig.getString("ADMIN_ID");
  String getADMIN_PASSWORD() => _remoteConfig.getString("ADMIN_PASSWORD");
}
