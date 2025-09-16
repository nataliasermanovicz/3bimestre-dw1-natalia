//import { query } from '../database.js';
const { query } = require('../database');
// Funções do controller

const path = require('path');

exports.abrirCrudPedidos = (req, res) => {
//  console.log('pedidosController - Rota /abrirCrudPedidos - abrir o crudPedidos');
  res.sendFile(path.join(__dirname, '../../frontend/pedidos/pedidos.html'));
} 

exports.listarPedidos = async (req, res) => {
  try {
    const result = await query('SELECT * FROM pedidos ORDER BY idPedido');
    res.json(result.rows);
  } catch (error) {
    console.error('Erro ao listar pedidos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.criarPedidos = async (req, res) => {
  try {
    const { idPedido, dataDoPedido, ClientePessoaIdPessoa, FuncionarioPessoaIdPessoa } = req.body;

    // Validação básica
    if (!idPedido || !ClientePessoaIdPessoa) {
      return res.status(400).json({
        error: 'ID, e cliente são obrigatórios'
      });
    }


    const result = await query(
      'INSERT INTO pedidos (idPedido, dataDoPedido, ClientePessoaIdPessoa,FuncionarioPessoaIdPessoa) VALUES ($1, $2, $3, $4) RETURNING *',
      [idPedido, dataDoPedido, ClientePessoaIdPessoa, FuncionarioPessoaIdPessoa]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao criar pedidos:', error);



    // Verifica se é erro de violação de constraint NOT NULL
    if (error.code === '23502') {
      return res.status(400).json({
        error: 'Dados obrigatórios não fornecidos'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.obterPedidos = async (req, res) => {
  try {
    const id = req.params.id; // ID é string

    if (!id) {
      return res.status(400).json({ error: 'ID é obrigatório' });
    }

    const result = await query(
      'SELECT * FROM pedidos WHERE idPedido = $1',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Pedidos não encontrado' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Erro ao obter pedidos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.atualizarPedidos = async (req, res) => {
  try {
    const id = req.params.id;
    const { dataDoPedido, ClientePessoaIdPessoa, FuncionarioPessoaIdPessoa } = req.body;

    // Verifica se a pedidos existe
    const existingPersonResult = await query(
      'SELECT * FROM pedidos WHERE idPedido = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pedidos não encontrado' });
    }

    // Atualiza a pedidos
    const updateResult = await query(
      'UPDATE pedidos SET dataDoPedido = $1, ClientePessoaIdPessoa = $ 2, FuncionarioPessoaIdPessoa = $ 3 WHERE idPedido = $4 RETURNING *',
      [dataDoPedido, ClientePessoaIdPessoa, FuncionarioPessoaIdPessoa, id]
    );

    res.json(updateResult.rows[0]);
  } catch (error) {
    console.error('Erro ao atualizar pedidos:', error);


    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}

exports.deletarPedidos = async (req, res) => {
  try {
    const id = req.params.id;
    // Verifica se a pedidos existe
    const existingPersonResult = await query(
      'SELECT * FROM pedidos WHERE idPedido = $1',
      [id]
    );

    if (existingPersonResult.rows.length === 0) {
      return res.status(404).json({ error: 'Pedidos não encontrado' });
    }

    // Deleta a pedidos (as constraints CASCADE cuidarão das dependências)
    await query(
      'DELETE FROM pedidos WHERE idPedido = $1',
      [id]
    );

    res.status(204).send();
  } catch (error) {
    console.error('Erro ao deletar pedidos:', error);

    // Verifica se é erro de violação de foreign key (dependências)
    if (error.code === '23503') {
      return res.status(400).json({
        error: 'Não é possível deletar pedidos com dependências associadas'
      });
    }

    res.status(500).json({ error: 'Erro interno do servidor' });
  }
}
