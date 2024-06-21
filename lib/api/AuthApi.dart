import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  bool ok;
  String msg;
  T? result;

  ApiResponse.ok() : ok = true, msg = '';
  ApiResponse.error(this.msg) : ok = false, result = null;
}

class LoginService {
  final String baseUrl;

  LoginService({required this.baseUrl});

  Future<ApiResponse<void>> login(String login, String senha) async {
    Map<String, String> params = {
      "login": login,
      "senha": senha,
    };

    try {
      final url = Uri.parse('$baseUrl/login');
      print(url);
      print(convert.json.encode(params));

      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
        },
        body: convert.json.encode(params),
      );

      print(response);

      print("STATUS CODE ${response.statusCode}");
      print(response.body);
      print(url);

      if (response.statusCode == 200) {
        return ApiResponse.ok();
      }

      if (response.statusCode == 401) {
        return ApiResponse.error("Usuário e/ou senha inválido.");
      }

      return ApiResponse.error("Falha ao realizar login.");
    } catch (e) {
      print("ERRO $e");
      return ApiResponse.error("Falha ao realizar login. Tente novamente!");
    }
  }
}
