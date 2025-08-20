import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class FormularioCadastro extends StatefulWidget {
  const FormularioCadastro({super.key});

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final _pageController = PageController();
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final _nomeController = TextEditingController();
  String? _sexo;
  int? _diaSelecionado;
  int? _mesSelecionado;
  int? _anoSelecionado;
  int _currentPage = 0;

  final List<String> _opcoesSexo = ['Homem', 'Mulher', 'Outro'];

  @override
  void dispose() {
    _pageController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  String? _validarIdade() {
    if (_diaSelecionado == null || _mesSelecionado == null || _anoSelecionado == null) {
      return 'Por favor, insira a data completa.';
    }
    try {
      final dataNascimento = DateTime(_anoSelecionado!, _mesSelecionado!, _diaSelecionado!);
      final hoje = DateTime.now();
      final dezoitoAnosAtras = DateTime(hoje.year - 18, hoje.month, hoje.day);

      if (dataNascimento.isAfter(dezoitoAnosAtras)) {
        return 'É necessário ter mais de 18 anos.';
      }
    } catch (e) {
      return 'Data inválida (ex: 31 de Fevereiro).';
    }
    return null;
  }

  void _nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage == 1) {
        final erroIdade = _validarIdade();
        if (erroIdade != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(erroIdade), backgroundColor: Colors.red),
          );
          return;
        }
      }

      if (_currentPage < _formKeys.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _cadastrar() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.login();

      final dataNascimentoFormatada =
          "${_diaSelecionado!.toString().padLeft(2, '0')}/${_mesSelecionado!.toString().padLeft(2, '0')}/$_anoSelecionado";

      final userData = {
        'nome': _nomeController.text,
        'dataNascimento': dataNascimentoFormatada,
        'sexo': _sexo!,
        'telefone': '99 99999-9999',
      };

      Navigator.pushReplacementNamed(
        context,
        '/profile',
        arguments: userData,
      );
    }
  }

  Widget _buildNomePage() {
    return Form(
      key: _formKeys[0],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Qual o seu nome?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome Completo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return 'Por favor, insira um nome válido.';
                }
                return null;
              },
              onFieldSubmitted: (_) => _nextPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataNascimentoPage() {
    return Form(
      key: _formKeys[1],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Sua data de nascimento', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _diaSelecionado,
                    hint: const Text('Dia'),
                    items: List.generate(31, (i) => i + 1).map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
                    onChanged: (v) => setState(() => _diaSelecionado = v),
                    validator: (v) => v == null ? '*' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _mesSelecionado,
                    hint: const Text('Mês'),
                    items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(value: m, child: Text('$m'))).toList(),
                    onChanged: (v) => setState(() => _mesSelecionado = v),
                    validator: (v) => v == null ? '*' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<int>(
                    value: _anoSelecionado,
                    hint: const Text('Ano'),
                    items: List.generate(101, (i) => DateTime.now().year - i).map((a) => DropdownMenuItem(value: a, child: Text('$a'))).toList(),
                    onChanged: (v) => setState(() => _anoSelecionado = v),
                    validator: (v) => v == null ? '*' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSexoPage() {
    return Form(
      key: _formKeys[2],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Como você se identifica?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _sexo,
              decoration: const InputDecoration(
                labelText: 'Sexo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.wc_outlined),
              ),
              items: _opcoesSexo.map((String v) => DropdownMenuItem<String>(value: v, child: Text(v))).toList(),
              onChanged: (String? v) => setState(() => _sexo = v),
              validator: (v) => v == null ? 'Selecione uma opção.' : null,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_formKeys.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
          ),
        );
      }),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _previousPage,
              child: const Text('ANTERIOR'),
            )
          else
            const SizedBox(),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: _currentPage == _formKeys.length - 1 ? _cadastrar : _nextPage,
            child: Text(_currentPage == _formKeys.length - 1 ? 'CADASTRAR' : 'PRÓXIMO'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro em Etapas'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          _buildProgressIndicator(),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildNomePage(),
                _buildDataNascimentoPage(),
                _buildSexoPage(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }
}