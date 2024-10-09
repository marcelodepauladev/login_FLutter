import 'package:mysql1/mysql1.dart';

class Conexao {
  Future<MySqlConnection> getConnection() async {
    ConnectionSettings settings = ConnectionSettings(
        host: 'db4free.net',
        port: 3306,
        user: 'etecjau070',
        password: 'Etec@1234',
        db: 'bd_etecjau');
    return await MySqlConnection.connect(settings);
  }
}
