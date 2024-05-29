import 'package:flutter/material.dart';
import 'database.dart';
import 'pessoa.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaListaPessoa(),
    );
  }
}

class TelaListaPessoa extends StatefulWidget {
  @override
  _TelaListaPessoaState createState() => _TelaListaPessoaState();
}

class _TelaListaPessoaState extends State<TelaListaPessoa> {
  final dbHelper = BancoDeDadosHelper();
  List<Pessoa> pessoas = [];
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  Pessoa? pessoaSelecionada;

  @override
  void initState() {
    super.initState();
    _atualizarListaPessoas();
  }

  _atualizarListaPessoas() async {
    final dados = await dbHelper.obterPessoas();
    setState(() {
      pessoas = dados.map((item) => Pessoa.fromMap(item)).toList();
    });
  }

  _adicionarOuAtualizarPessoa() async {
    if (pessoaSelecionada == null) {
      await dbHelper.inserirPessoa(
        Pessoa(nome: nomeController.text, idade: int.parse(idadeController.text)).toMap(),
      );
    } else {
      await dbHelper.atualizarPessoa(
        Pessoa(id: pessoaSelecionada!.id, nome: nomeController.text, idade: int.parse(idadeController.text)).toMap(),
      );
      pessoaSelecionada = null;
    }
    nomeController.clear();
    idadeController.clear();
    _atualizarListaPessoas();
  }

  _deletarPessoa(int id) async {
    await dbHelper.deletarPessoa(id);
    _atualizarListaPessoas();
  }

  _selecionarPessoa(Pessoa pessoa) {
    setState(() {
      pessoaSelecionada = pessoa;
      nomeController.text = pessoa.nome!;
      idadeController.text = pessoa.idade.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pessoas'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: idadeController,
              decoration: InputDecoration(labelText: 'Idade'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: _adicionarOuAtualizarPessoa,
            child: Text(pessoaSelecionada == null ? 'Adicionar' : 'Atualizar'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = pessoas[index];
                return ListTile(
                  title: Text(pessoa.nome!),
                  subtitle: Text('Idade: ${pessoa.idade}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deletarPessoa(pessoa.id!),
                  ),
                  onTap: () => _selecionarPessoa(pessoa),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
