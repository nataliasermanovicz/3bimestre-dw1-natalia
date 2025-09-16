const express = require('express');
const router = express.Router();
const funcionarioController = require('../controllers/funcionarioController');

// CRUD de Funcionarios


router.get('/', funcionarioController.listarFuncionario);
router.post('/', funcionarioController.criarFuncionario);
router.get('/:id', funcionarioController.obterFuncionario);
// não tem atualizar funcionario
router.delete('/:id', funcionarioController.deletarFuncionario);

module.exports = router;
