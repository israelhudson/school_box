import 'package:flutter/material.dart';
import '../models/aluno_detalhado.dart';
import '../models/filtro_opcao.dart';
import '../repositories/aluno_repository.dart';
import '../use_cases/listar_alunos_use_case.dart';

class AlunosPage extends StatefulWidget {
  const AlunosPage({super.key});

  @override
  State<AlunosPage> createState() => _AlunosPageState();
}

class _AlunosPageState extends State<AlunosPage> {
  final ListarAlunosUseCase _listarAlunosUseCase = ListarAlunosUseCase(
    AlunoRepository(),
  );

  List<AlunoDetalhado> _alunos = [];
  List<FiltroOpcao> _escolas = [];
  List<FiltroOpcao> _segmentos = [];
  List<FiltroOpcao> _turnos = [];
  List<FiltroOpcao> _series = [];
  List<FiltroOpcao> _turmas = [];

  bool _carregando = false;
  String? _erro;

  String? _escolaSelecionada;
  String? _segmentoSelecionado;
  String? _turnoSelecionado;
  String? _serieSelecionada;
  String? _turmaSelecionada;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarFiltros();
    _carregarAlunos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _matriculaController.dispose();
    super.dispose();
  }

  Future<void> _carregarFiltros() async {
    try {
      final escolas = await _listarAlunosUseCase.buscarEscolas();
      final segmentos = await _listarAlunosUseCase.buscarSegmentos();
      final turnos = await _listarAlunosUseCase.buscarTurnos();

      setState(() {
        _escolas = escolas;
        _segmentos = segmentos;
        _turnos = turnos;
      });

      await _atualizarSeriesETurmas();
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar filtros: $e';
      });
    }
  }

  Future<void> _atualizarSeriesETurmas() async {
    try {
      final series = await _listarAlunosUseCase.buscarSeries(
        escolaId: _escolaSelecionada,
        segmentoId: _segmentoSelecionado,
        turnoId: _turnoSelecionado,
      );

      final turmas = await _listarAlunosUseCase.buscarTurmas(
        escolaId: _escolaSelecionada,
        segmentoId: _segmentoSelecionado,
        turnoId: _turnoSelecionado,
        serieId: _serieSelecionada,
      );

      setState(() {
        _series = series;
        _turmas = turmas;

        if (_serieSelecionada != null &&
            !_series.any((s) => s.id == _serieSelecionada)) {
          _serieSelecionada = null;
        }
        if (_turmaSelecionada != null &&
            !_turmas.any((t) => t.id == _turmaSelecionada)) {
          _turmaSelecionada = null;
        }
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao atualizar séries e turmas: $e';
      });
    }
  }

  Future<void> _carregarAlunos() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final filtros = FiltrosAluno(
        escolaId: _escolaSelecionada,
        segmentoId: _segmentoSelecionado,
        turnoId: _turnoSelecionado,
        serieId: _serieSelecionada,
        turmaId: _turmaSelecionada,
        nome: _nomeController.text.isNotEmpty ? _nomeController.text : null,
        matricula: _matriculaController.text.isNotEmpty
            ? _matriculaController.text
            : null,
      );

      final alunos = await _listarAlunosUseCase.executar(filtros);

      setState(() {
        _alunos = alunos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _erro = 'Erro ao carregar alunos: $e';
        _carregando = false;
      });
    }
  }

  void _limparFiltros() {
    setState(() {
      _escolaSelecionada = null;
      _segmentoSelecionado = null;
      _turnoSelecionado = null;
      _serieSelecionada = null;
      _turmaSelecionada = null;
      _nomeController.clear();
      _matriculaController.clear();
    });
    _atualizarSeriesETurmas();
    _carregarAlunos();
  }

  void _mostrarDetalhesAluno(AlunoDetalhado aluno) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(aluno.nome),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Matrícula: ${aluno.matricula ?? 'N/A'}'),
              Text('CPF: ${aluno.cpf ?? 'N/A'}'),
              Text('Celular: ${aluno.celular ?? 'N/A'}'),
              Text('Email: ${aluno.email ?? 'N/A'}'),
              const Divider(),
              Text('Escola: ${aluno.escolaNome}'),
              Text('Segmento: ${aluno.segmentoNome}'),
              Text('Série: ${aluno.serieNome}'),
              Text('Turma: ${aluno.turmaNome}'),
              Text('Turno: ${aluno.turnoNome}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alunos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarAlunos,
            tooltip: 'Atualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtros
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _limparFiltros,
                        child: const Text('Limpar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Campos de texto
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            labelText: 'Nome',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _carregarAlunos(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _matriculaController,
                          decoration: const InputDecoration(
                            labelText: 'Matrícula',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (_) => _carregarAlunos(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dropdowns
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _escolaSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Escola',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todas'),
                            ),
                            ..._escolas.map(
                              (e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(e.nome),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _escolaSelecionada = value);
                            _atualizarSeriesETurmas();
                            _carregarAlunos();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _segmentoSelecionado,
                          decoration: const InputDecoration(
                            labelText: 'Segmento',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todos'),
                            ),
                            ..._segmentos.map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.nome),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _segmentoSelecionado = value);
                            _atualizarSeriesETurmas();
                            _carregarAlunos();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _turnoSelecionado,
                          decoration: const InputDecoration(
                            labelText: 'Turno',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todos'),
                            ),
                            ..._turnos.map(
                              (t) => DropdownMenuItem(
                                value: t.id,
                                child: Text(t.nome),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _turnoSelecionado = value);
                            _atualizarSeriesETurmas();
                            _carregarAlunos();
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _serieSelecionada,
                          decoration: const InputDecoration(
                            labelText: 'Série',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('Todas'),
                            ),
                            ..._series.map(
                              (s) => DropdownMenuItem(
                                value: s.id,
                                child: Text(s.descricaoCompleta),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() => _serieSelecionada = value);
                            _atualizarSeriesETurmas();
                            _carregarAlunos();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: _turmaSelecionada,
                    decoration: const InputDecoration(
                      labelText: 'Turma',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Todas')),
                      ..._turmas.map(
                        (t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(t.descricaoCompleta),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _turmaSelecionada = value);
                      _carregarAlunos();
                    },
                  ),
                ],
              ),
            ),
          ),

          // Contador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Encontrados: ${_alunos.length} aluno(s)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_carregando)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista
          Expanded(
            child: _erro != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(_erro!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _carregarAlunos,
                          child: const Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  )
                : _carregando
                ? const Center(child: CircularProgressIndicator())
                : _alunos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum aluno encontrado',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _alunos.length,
                    itemBuilder: (context, index) {
                      final aluno = _alunos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: aluno.ativo
                                ? Colors.green
                                : Colors.grey,
                            child: Text(
                              aluno.nome.isNotEmpty
                                  ? aluno.nome[0].toUpperCase()
                                  : 'A',
                            ),
                          ),
                          title: Text(
                            aluno.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(aluno.identificacao),
                              Text(
                                aluno.localizacaoCompleta,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _mostrarDetalhesAluno(aluno),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
