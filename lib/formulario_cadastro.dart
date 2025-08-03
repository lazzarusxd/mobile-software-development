import 'package:flutter/material.dart';

class FormularioCadastro extends StatefulWidget {
  const FormularioCadastro({super.key});

  @override
  State<FormularioCadastro> createState() => _FormularioCadastroState();
}

class _FormularioCadastroState extends State<FormularioCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  // Variáveis de estado para os campos de data e sexo
  String? _sexo;
  int? _diaSelecionado;
  int? _mesSelecionado;
  int? _anoSelecionado;

  final List<String> _opcoesSexo = ['Homem', 'Mulher'];

  // Função para validar se o usuário tem mais de 18 anos
  String? _validarIdade() {
    if (_diaSelecionado == null || _mesSelecionado == null || _anoSelecionado == null) {
      return 'Por favor, insira a data completa.';
    }

    try {
      // Constrói a data de nascimento a partir dos campos selecionados
      final dataNascimento = DateTime(_anoSelecionado!, _mesSelecionado!, _diaSelecionado!);

      final hoje = DateTime.now();
      // Calcula a data exata de 18 anos atrás
      final dezoitoAnosAtras = DateTime(hoje.year - 18, hoje.month, hoje.day);

      if (dataNascimento.isAfter(dezoitoAnosAtras)) {
        return 'É necessário ter mais de 18 anos.';
      }
    } catch (e) {
      // Captura datas inválidas como 31 de Fevereiro
      return 'Data inválida.';
    }

    return null;
  }

  // Função para processar o cadastro
  void _cadastrar() {
    // Valida o formulário inteiro, incluindo a validação de idade customizada
    if (_formKey.currentState!.validate()) {
      // Dispara a validação da idade separadamente
      final erroIdade = _validarIdade();
      if (erroIdade != null) {
        // Se houver erro de idade, exibe um Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(erroIdade), backgroundColor: Colors.red),
        );
        return;
      }

      // Se tudo estiver válido, exibe o diálogo de sucesso
      final dataNascimentoFormatada = "${_diaSelecionado!.toString().padLeft(2,'0')}/${_mesSelecionado!.toString().padLeft(2,'0')}/$_anoSelecionado";

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Cadastro Realizado com Sucesso!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome: ${_nomeController.text}'),
                Text('Data de Nascimento: $dataNascimentoFormatada'),
                Text('Sexo: $_sexo'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('FECHAR'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Cadastro'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Campo Nome Completo
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, insira o seu nome completo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Seção Data de Nascimento
              const Text('Data de Nascimento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Dia
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _diaSelecionado,
                      hint: const Text('Dia'),
                      items: List.generate(31, (index) => index + 1)
                          .map((dia) => DropdownMenuItem(value: dia, child: Text(dia.toString())))
                          .toList(),
                      onChanged: (valor) => setState(() => _diaSelecionado = valor),
                      validator: (v) => v == null ? '*' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown Mês
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _mesSelecionado,
                      hint: const Text('Mês'),
                      items: List.generate(12, (index) => index + 1)
                          .map((mes) => DropdownMenuItem(value: mes, child: Text(mes.toString())))
                          .toList(),
                      onChanged: (valor) => setState(() => _mesSelecionado = valor),
                      validator: (v) => v == null ? '*' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Dropdown Ano
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<int>(
                      value: _anoSelecionado,
                      hint: const Text('Ano'),
                      items: List.generate(101, (index) => DateTime.now().year - index)
                          .map((ano) => DropdownMenuItem(value: ano, child: Text(ano.toString())))
                          .toList(),
                      onChanged: (valor) => setState(() => _anoSelecionado = valor),
                      validator: (v) => v == null ? '*' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Campo Sexo
              DropdownButtonFormField<String>(
                value: _sexo,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.wc),
                ),
                items: _opcoesSexo.map((String valor) {
                  return DropdownMenuItem<String>(value: valor, child: Text(valor));
                }).toList(),
                onChanged: (String? novoValor) => setState(() => _sexo = novoValor),
                validator: (value) => value == null ? 'Selecione o sexo.' : null,
              ),
              const SizedBox(height: 32.0),

              // Botão de Cadastro
              ElevatedButton(
                onPressed: _cadastrar,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}