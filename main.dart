import 'package:flutter/material.dart';
import 'conexao.dart';
import 'cadastrar_usuario.dart';
import 'tela_produtos.dart';

void main() {
  runApp(const MaterialApp(home: MyHomePage()));
}

int idUsuario = 0;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController txtUsuario = TextEditingController();
  TextEditingController txtSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logo(),
            caixaUsuario(),
            caixaSenha(),
            botaoLogin(context),
            textoBotao(context),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return SizedBox(
      width: 300,
      height: 250,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png',
      ),
    );
  }

  Widget caixaUsuario() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: txtUsuario,
        decoration: const InputDecoration(
          labelText: 'Usuário',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget caixaSenha() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: txtSenha,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Senha',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget botaoLogin(BuildContext context) {
    return ElevatedButton(
      onPressed: () => consultaLogin(context),
      child: const Text('Login'),
    );
  }

  Future<void> consultaLogin(BuildContext context) async {
    var db = Conexao();
    String usuario = txtUsuario.text;
    String senha = txtSenha.text;

    String sql = "SELECT * FROM usuarios WHERE usuario = '$usuario' AND senha = '$senha'";

    try {
      var conn = await db.getConnection();
      var results = await conn.query(sql);

      for (var res in results) {
        idUsuario = res['id'];
      }

      if (idUsuario > 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TelaProdutos()),
        );
      } else {
        mensagemErro(context);
      }

      conn.close();
    } catch (e) {
      print('Error: $e');
      mensagemErro(context); // Show error message on exception
    }
  }

  Widget textoBotao(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CadastrarUsuario()),
        );
      },
      child: const Text('Não tem Login? Cadastre-se'),
    );
  }

  void mensagemErro(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login'),
        content: const Text('Usuário não cadastrado ou senha incorreta'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}
