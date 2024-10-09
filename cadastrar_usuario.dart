import 'dart:io';
import 'package:flutter/material.dart';
import 'conexao.dart';

class CadastrarUsuario extends StatefulWidget {
  const CadastrarUsuario({super.key});

  @override
  State<CadastrarUsuario> createState() => _CadastrarUsuarioState();
}

class _CadastrarUsuarioState extends State<CadastrarUsuario> {
  TextEditingController txtUsuario = TextEditingController();
  TextEditingController txtSenha = TextEditingController();
  TextEditingController txtConfirmaSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Column(
        children: [
          caixaUsuario(),
          caixaSenha(),
          caixaConfirmaSenha(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              botaoCadastrar(context),
              botaoCancelar(),
            ],
          ),
        ],
      ),
    );
  }

  Widget caixaUsuario() {
    return TextField(
      controller: txtUsuario,
      decoration: const InputDecoration(
        labelText: 'Informe o nome do usuário',
      ),
    );
  }

  Widget caixaSenha() {
    return TextField(
      controller: txtSenha,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Informe uma senha segura',
      ),
    );
  }

  Widget caixaConfirmaSenha() {
    return TextField(
      controller: txtConfirmaSenha,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Confirma a senha',
      ),
    );
  }

  Widget botaoCadastrar(BuildContext context) {
    return ElevatedButton(
      onPressed: () => incluir(context),
      child: const Text('Cadastrar'),
    );
  }

  Future<void> incluir(BuildContext context) async {
    if (txtUsuario.text.isEmpty || txtSenha.text.isEmpty || txtConfirmaSenha.text.isEmpty) {
      mensagem(context, 'Favor preencher todos os campos');
      return;
    }

    if (txtSenha.text != txtConfirmaSenha.text) {
      mensagem(context, 'Senhas não conferem');
      return;
    }

    final db = Conexao();
    try {
      var conn = await db.getConnection();
      String sql = 'INSERT INTO usuarios (usuario, senha) VALUES (?, ?);';
      await conn.query(sql, [txtUsuario.text, txtSenha.text]);
      atualizaTela(context);
    } catch (e) {
      print('Error: $e');
      mensagem(context, 'Erro ao cadastrar usuário');
    }
  }

  void atualizaTela(BuildContext context) {
    txtUsuario.clear();
    txtSenha.clear();
    txtConfirmaSenha.clear();
    mensagem(context, 'Cadastro realizado com sucesso');
  }

  void mensagem(BuildContext context, String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cadastro'),
        content: Text(mensagem),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget botaoCancelar() {
    return ElevatedButton(
      onPressed: () => exit(0),
      child: const Text('Cancelar'),
    );
  }
}
