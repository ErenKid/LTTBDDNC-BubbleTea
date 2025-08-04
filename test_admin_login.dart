import 'dart:convert';
import 'dart:io';

void main() async {
  // Test login với tài khoản admin
  await testAdminLogin();
}

Future<void> testAdminLogin() async {
  try {
    final client = HttpClient();
    final request = await client.postUrl(Uri.parse('http://localhost:8080/login'));
    
    request.headers.set('Content-Type', 'application/json');
    
    final loginData = {
      'email': 'admin@gmail.com',
      'password': 'admin123'
    };
    
    request.write(jsonEncode(loginData));
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    print('Status Code: ${response.statusCode}');
    print('Response: $responseBody');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      if (data['success'] == true) {
        print('✅ Login thành công!');
        print('📧 Email: ${data['user']['email']}');
        print('👤 Tên: ${data['user']['name']}');
        print('🔐 Là Admin: ${data['user']['isAdmin']}');
      }
    } else {
      print('❌ Login thất bại');
    }
    
    client.close();
  } catch (e) {
    print('Lỗi kết nối: $e');
    print('Hãy đảm bảo server đang chạy trên port 8080');
  }
}
