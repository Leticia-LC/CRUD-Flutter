import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BancoDeDadosHelper {
  static final BancoDeDadosHelper _instancia = BancoDeDadosHelper._interno();
  static Database? _bancoDeDados;

  factory BancoDeDadosHelper() {
    return _instancia;
  }

  BancoDeDadosHelper._interno();

  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _inicializarBancoDeDados();
    return _bancoDeDados!;
  }

  Future<Database> _inicializarBancoDeDados() async {
    String caminho = join(await getDatabasesPath(), 'pessoa_banco.db');
    return await openDatabase(
      caminho,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int versao) async {
    await db.execute(
        '''
      CREATE TABLE pessoa(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        idade INTEGER
      )
      '''
    );
  }

  Future<int> inserirPessoa(Map<String, dynamic> pessoa) async {
    Database db = await bancoDeDados;
    return await db.insert('pessoa', pessoa);
  }

  Future<List<Map<String, dynamic>>> obterPessoas() async {
    Database db = await bancoDeDados;
    return await db.query('pessoa');
  }

  Future<int> atualizarPessoa(Map<String, dynamic> pessoa) async {
    Database db = await bancoDeDados;
    int id = pessoa['id'];
    return await db.update(
      'pessoa',
      pessoa,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletarPessoa(int id) async {
    Database db = await bancoDeDados;
    return await db.delete(
      'pessoa',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
