// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart';
// import 'package:shelf_router/shelf_router.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';

// // Lưu mã xác nhận tạm thời (email -> code)
// final Map<String, String> verificationCodes = {};

// final handler = Router()
//   ..post('/send-code', (Request request) async {
//     final body = await request.readAsString();
//     final data = jsonDecode(body);
//     final email = data['email'] as String?;

//     if (email == null) {
//       return Response.badRequest(body: 'Missing email');
//     }

//     // Sinh mã xác nhận 6 số
//     final code = (Random().nextInt(900000) + 100000).toString();
//     verificationCodes[email] = code;

//     // Gửi email
//     final smtpServer = gmail('YOUR_GMAIL', 'YOUR_APP_PASSWORD');
//     final message = Message()
//       ..from = Address('YOUR_GMAIL', 'Your App Name')
//       ..recipients.add(email)
//       ..subject = 'Mã xác nhận đặt lại mật khẩu'
//       ..text = 'Mã xác nhận của bạn là: $code';

//     try {
//       final sendReport = await send(message, smtpServer);
//       print('Message sent: ' + sendReport.toString());
//       return Response.ok(jsonEncode({'success': true}));
//     } catch (e) {
//       print('Message not sent: $e');
//       return Response.internalServerError(body: 'Failed to send email');
//     }
//   })
//   ..post('/verify-code', (Request request) async {
//     final body = await request.readAsString();
//     final data = jsonDecode(body);
//     final email = data['email'] as String?;
//     final code = data['code'] as String?;

//     if (email == null || code == null) {
//       return Response.badRequest(body: 'Missing email or code');
//     }

//     if (verificationCodes[email] == code) {
//       return Response.ok(jsonEncode({'success': true}));
//     } else {
//       return Response.forbidden(jsonEncode({'success': false, 'message': 'Mã xác nhận không đúng'}));
//     }
//   })
//   ..post('/reset-password', (Request request) async {
//     final body = await request.readAsString();
//     final data = jsonDecode(body);
//     final email = data['email'] as String?;
//     final code = data['code'] as String?;
//     final newPassword = data['newPassword'] as String?;

//     if (email == null || code == null || newPassword == null) {
//       return Response.badRequest(body: 'Missing fields');
//     }

//     if (verificationCodes[email] == code) {
//       // TODO: Cập nhật mật khẩu mới vào database (bạn cần tự xử lý phần này)
//       verificationCodes.remove(email);
//       return Response.ok(jsonEncode({'success': true}));
//     } else {
//       return Response.forbidden(jsonEncode({'success': false, 'message': 'Mã xác nhận không đúng'}));
//     }
//   });

// void main() async {
//   final server = await serve(
//     logRequests().addHandler(handler),
//     InternetAddress.anyIPv4,
//     8080,
//   );
//   print('Server listening on port [32m${server.port}[0m');
// } 