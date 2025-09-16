-- ====================== 
-- TABELAS BÁSICAS
-- ======================

CREATE TABLE Endereco (
    idEndereco SERIAL PRIMARY KEY,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    referencia VARCHAR(45),
    cep VARCHAR(9),
    CidadeIdCidade INT
);

CREATE TABLE Pessoa (
    cpfPessoa VARCHAR(20) PRIMARY KEY,
    nomePessoa VARCHAR(60),
    emailPessoa VARCHAR(60),
    senhaPessoa VARCHAR(32),
    dataNascimentoPessoa DATE,
    EnderecoIdEndereco INT REFERENCES Endereco(idEndereco)
);
 
CREATE TABLE Cargo (
    idCargo SERIAL PRIMARY KEY,
    nomeCargo VARCHAR(45)
);

CREATE TABLE Funcionario ( 
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    salario DOUBLE PRECISION,
    CargosIdCargo INT REFERENCES Cargo(idCargo)
);

CREATE TABLE Cliente (
    PessoaCpfPessoa VARCHAR(20) PRIMARY KEY REFERENCES Pessoa(cpfPessoa),
    rendaCliente DOUBLE PRECISION,
    dataDeCadastroCliente DATE
);

CREATE TABLE Produto (
    idProduto SERIAL PRIMARY KEY,
    nomeProduto VARCHAR(45),
    quantidadeEmEstoque INT,
    precoUnitario DOUBLE PRECISION
);

CREATE TABLE Pedido (
    idPedido SERIAL PRIMARY KEY,
    dataDoPedido DATE,
    ClientePessoaCpfPessoa VARCHAR(20) REFERENCES Cliente(PessoaCpfPessoa),
    FuncionarioPessoaCpfPessoa VARCHAR(20) REFERENCES Funcionario(PessoaCpfPessoa)
);

CREATE TABLE PedidoHasProduto (
    ProdutoIdProduto INT REFERENCES Produto(idProduto),
    PedidoIdPedido INT REFERENCES Pedido(idPedido),
    quantidade INT,
    precoUnitario DOUBLE PRECISION,
    PRIMARY KEY (ProdutoIdProduto, PedidoIdPedido)
);

CREATE TABLE Pagamento (
    PedidoIdPedido INT PRIMARY KEY REFERENCES Pedido(idPedido),
    dataPagamento TIMESTAMP,
    valorTotalPagamento DOUBLE PRECISION
);

CREATE TABLE FormaDePagamento (
    idFormaPagamento SERIAL PRIMARY KEY,
    nomeFormaPagamento VARCHAR(100)
);

CREATE TABLE PagamentoHasFormaPagamento (
    PagamentoIdPedido INT REFERENCES Pagamento(PedidoIdPedido),
    FormaPagamentoIdFormaPagamento INT REFERENCES FormaDePagamento(idFormaPagamento),
    valorPago DOUBLE PRECISION,
    PRIMARY KEY (PagamentoIdPedido, FormaPagamentoIdFormaPagamento)
);

-- ======================
-- POPULAR COM 10 REGISTROS
-- ======================

-- Endereco
INSERT INTO Endereco (logradouro, numero, referencia, cep, CidadeIdCidade) VALUES
('Rua A', '10', 'Próx. praça', '11111-111', 1),
('Rua B', '20', 'Esquina', '22222-222', 1),
('Rua C', '30', 'Ao lado do mercado', '33333-333', 2),
('Rua D', '40', 'Próx. escola', '44444-444', 2),
('Rua E', '50', 'Próx. hospital', '55555-555', 3),
('Rua F', '60', 'Centro', '66666-666', 3),
('Rua G', '70', 'Bairro novo', '77777-777', 4),
('Rua H', '80', 'Fundos', '88888-888', 4),
('Rua I', '90', 'Lado direito', '99999-999', 5),
('Rua J', '100', 'Final da rua', '10101-101', 5);

-- Pessoa
-- (cpfPessoa, nomePessoa, emailPessoa, senhaPessoa, dataNascimentoPessoa, EnderecoIdEndereco)
INSERT INTO Pessoa (cpfPessoa, nomePessoa, emailPessoa, senhaPessoa, dataNascimentoPessoa, EnderecoIdEndereco) VALUES
('11111111111', 'Ana Silva', 'ana@email.com', '123456', '1990-01-01', 1),
('22222222222', 'João Souza', 'joao@email.com', '123456', '1985-02-02', 2),
('33333333333', 'Maria Oliveira', 'maria@email.com', '123456', '1992-03-03', 3),
('44444444444', 'Pedro Santos', 'pedro@email.com', '123456', '1988-04-04', 4),
('55555555555', 'Carla Ferreira', 'carla@email.com', '123456', '1995-05-05', 5),
('66666666666', 'Lucas Lima', 'lucas@email.com', '123456', '1991-06-06', 6),
('77777777777', 'Marcos Pereira', 'marcos@email.com', '123456', '1987-07-07', 7),
('88888888888', 'Fernanda Costa', 'fernanda@email.com', '123456', '1993-08-08', 8),
('99999999999', 'Juliana Rocha', 'juliana@email.com', '123456', '1994-09-09', 9),
('10101010101', 'Ricardo Alves', 'ricardo@email.com', '123456', '1996-10-10', 10);

-- Cargo
INSERT INTO Cargo (nomeCargo) VALUES
('Gerente'),
('Atendente'),
('Caixa'),
('Vendedor'),
('Supervisor'),
('Estoquista'),
('Auxiliar'),
('RH'),
('Marketing'),
('TI');

-- Funcionario
-- (PessoaCpfPessoa, salario, CargosIdCargo)
INSERT INTO Funcionario VALUES
('11111111111', 3000, 1),
('22222222222', 2000, 2),
('33333333333', 2200, 3),
('44444444444', 2500, 4),
('55555555555', 2700, 5),
('66666666666', 2800, 6),
('77777777777', 2600, 7),
('88888888888', 2100, 8),
('99999999999', 2300, 9),
('10101010101', 2400, 10);

-- Cliente
-- (PessoaCpfPessoa, rendaCliente, dataDeCadastroCliente)
INSERT INTO Cliente VALUES
('11111111111', 4000, '2020-01-01'),
('22222222222', 3000, '2020-02-01'),
('33333333333', 3500, '2020-03-01'),
('44444444444', 2500, '2020-04-01'),
('55555555555', 2000, '2020-05-01'),
('66666666666', 5000, '2020-06-01'),
('77777777777', 6000, '2020-07-01'),
('88888888888', 7000, '2020-08-01'),
('99999999999', 8000, '2020-09-01'),
('10101010101', 9000, '2020-10-01');

-- Produto
INSERT INTO Produto (nomeProduto, quantidadeEmEstoque, precoUnitario) VALUES
('Produto A', 100, 10.5),
('Produto B', 200, 20.0),
('Produto C', 150, 15.0),
('Produto D', 300, 5.5),
('Produto E', 250, 7.0),
('Produto F', 120, 30.0),
('Produto G', 80, 25.0),
('Produto H', 90, 50.0),
('Produto I', 70, 60.0),
('Produto J', 110, 12.0);

-- Pedido
-- (dataDoPedido, ClientePessoaCpfPessoa, FuncionarioPessoaCpfPessoa)
INSERT INTO Pedido (dataDoPedido, ClientePessoaCpfPessoa, FuncionarioPessoaCpfPessoa) VALUES
('2023-01-01', '11111111111', '22222222222'),
('2023-01-02', '33333333333', '44444444444'),
('2023-01-03', '55555555555', '66666666666'),
('2023-01-04', '77777777777', '88888888888'),
('2023-01-05', '99999999999', '10101010101'),
('2023-01-06', '22222222222', '33333333333'),
('2023-01-07', '44444444444', '55555555555'),
('2023-01-08', '66666666666', '77777777777'),
('2023-01-09', '88888888888', '99999999999'),
('2023-01-10', '10101010101', '11111111111');

-- PedidoHasProduto
INSERT INTO PedidoHasProduto VALUES
(1, 1, 2, 10.5),
(2, 2, 1, 20.0),
(3, 3, 5, 15.0),
(4, 4, 3, 5.5),
(5, 5, 2, 7.0),
(6, 6, 4, 30.0),
(7, 7, 1, 25.0),
(8, 8, 2, 50.0),
(9, 9, 6, 60.0),
(10, 10, 2, 12.0);

-- Pagamento
INSERT INTO Pagamento VALUES
(1, '2023-01-02 10:00:00', 21.0),
(2, '2023-01-03 11:00:00', 20.0),
(3, '2023-01-04 12:00:00', 75.0),
(4, '2023-01-05 13:00:00', 16.5),
(5, '2023-01-06 14:00:00', 14.0),
(6, '2023-01-07 15:00:00', 120.0),
(7, '2023-01-08 16:00:00', 25.0),
(8, '2023-01-09 17:00:00', 100.0),
(9, '2023-01-10 18:00:00', 360.0),
(10, '2023-01-11 19:00:00', 24.0);

-- FormaDePagamento
INSERT INTO FormaDePagamento (nomeFormaPagamento) VALUES
('Cartão de Crédito'),
('Cartão de Débito'),
('PIX'),
('Boleto'),
('Dinheiro'),
('Vale Alimentação'),
('PayPal'),
('Transferência Bancária'),
('Crédito Loja'),
('Criptomoeda');

-- PagamentoHasFormaPagamento
INSERT INTO PagamentoHasFormaPagamento VALUES
(1, 1, 21.0),
(2, 2, 20.0),
(3, 3, 75.0),
(4, 4, 16.5),
(5, 5, 14.0),
(6, 6, 120.0),
(7, 7, 25.0),
(8, 8, 100.0),
(9, 9, 360.0),
(10, 10, 24.0);