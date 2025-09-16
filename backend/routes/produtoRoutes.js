const express = require('express');
const router = express.Router();
const produtoController = require('../controllers/produtoController');

// CRUD de Produtos


router.get('/', produtoController.listarProduto);
router.post('/', produtoController.criarProduto);
router.get('/:id', produtoController.obterProduto);
// não tem atualizar produto
router.delete('/:id', produtoController.deletarProduto);

module.exports = router;
