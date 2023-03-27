import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mailer {
  static Future<String> sendCredentialsEmail(
      {required String password, required String destEmail}) async {
    String _username = 'shivendu.2024cs1136@kiet.edu';
    String _password = 'Shivendu123@';
    final smtpServer = gmail(_username, _password);
    final message = Message()
      ..from = Address(_username, 'Tiwari Propmart')
      ..recipients.add(destEmail)
      ..subject = "Tiwari Propmarts Registration Successfull."
      ..html =
          "<h2>Registration Successfull</h2><br><p> Hi there,<br>Your account is successfully created on Tiwari Propmart.<br>Please find your login credentials below.<br> Credentials: <br> Login Id: ${destEmail} <br> Password: ${password}</p><br><h4>Best & Regards</h4><br><p>Tiwari Propmarts</p>";
    var connection = PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
    try {
      final sendReport = await send(message, smtpServer);
      return 'Message sent: ' + sendReport.toString();
    } on MailerException catch (e) {
      return 'Message not sent.';
    }
  }
}
