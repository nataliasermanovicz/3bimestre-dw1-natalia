//import { query } from '../database.js';
const { query } = require('../database');
// Funções do controller

const path = require('path');

exports.abrirCrudFuncionarios = (req, res) => {
//  console.log('funcionariosController - Rota /abrirCrudFuncionarios - abrir o crudFuncionarios');
  res.sendFile(path.join(__dirname, '../../frontend/funcionarios/funcionarios.html'));
} 

exports.listarFuncionarios = async (req, res) => {
  try {
    const result = await query('SELECT * FROM funcionarios ORDER BY PessoaCpfPessoa');
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar funcionarios:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.criarFuncionarios = async (req, res) => {
  try {
    const { PessoaCpfPessoa, salario, CargosIdCargo } = req.body;

    // Validação básica
    if (!PessoaCpfPessoa || !salario || !CargosIdCargo) {
      return res.status(400).json({
        error: 'CPF, salario e cargo são obrigatórios'
      });
    }


    const result = await query(
      'INSERT INTO funcionarios (PessoaCpfPessoa, salario, CargosIdCargo) VALUES ($1, $2, $3) RETURNING *',
      [PessoaCpfPessoa, salario, CargosIdCargo]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar funcionarios:', error);



    // Verifica se é erro de violação de constraint NOT NULL
    if (error.code === '23502') {
      return res.status(400).json({
        error: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.obterFuncionarios = async (req, res) => {
  try {
    const cpf = req.params.cpf; // CPF é string

    if (!cpf) {
      return res.status(400).json({ error: 'CPF é obrigatório' });
    }

    const result = await query(
      'SELECT * FROM funcionarios WHERE PessoaCpfPessoa = $1',
      [cpf]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionarios não encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao obter funcionarios:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.atualizarFuncionarios = async (req, res) => {
  try {
    const cpf = req.params.cpf;
    const { salario, CargosIdCargo } = req.body;

    // Verifica se a funcionarios existe
    const existingPersonResult = await query(
      'SELECT * FROM funcionarios WHERE PessoaCpfPessoa = $1',
      [cpf]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionarios não encontrada' });
    }

    // Atualiza a funcionarios
    const updateResult = await query(
      'UPDATE funcionarios SET salario = $1, CargosIdCargo = $2 WHERE PessoaCpfPessoa = $3 RETURNING *',
      [salario, CargosIdCargo, cpf]
    );

    res.json(updateResult.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar funcionarios:', error);


    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.deletarFuncionarios = async (req, res) => {
  try {
    const cpf = req.params.cpf;
    // Verifica se a funcionarios existe
    const existingPersonResult = await query(
      'SELECT * FROM funcionarios WHERE PessoaCpfPessoa = $1',
      [cpf]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Funcionarios não encontrada' });
    }

    // Deleta a funcionarios (as constraints CASCADE cuidarão das dependências)
    await query(
      'DELETE FROM funcionarios WHERE PessoaCpfPessoa = $1',
      [cpf]
    );

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar funcionarios:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        error: 'Não é possível deletar funcionarios com dependências associadas'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}
