import 'dart:io';

class TcpClient {
  late Socket _socket;

  Future<void> connect(String host, int port) async {
    try {
      _socket = await Socket.connect(host, port);
      print('Conexão estabelecida com $host:$port');

      _socket.listen(
        (List<int> event) {
          print('Mensagem recebida: ${String.fromCharCodes(event)}');
        },
        onError: (e) {
          print('Erro na conexão: $e');
          _socket.destroy();
        },
        onDone: () {
          print('Conexão encerrada pelo servidor.');
          _socket.destroy();
        },
      );
    } catch (e) {
      print('Erro ao conectar: $e');
    }
  }

  void close() {
    _socket.close();
    print('Conexão encerrada.');
  }
}
