-- ============================================
-- TRABALHO DE BANCO DE DADOS - DELICATESSEN
-- Integrantes:
-- Guilherme Oliveira Figueiredo
-- Maria Eduarda Oliveira de Amorim Meneses
-- Rodrigo de Souza Gomes
-- Nicolas de Oliveira Dutra
-- Eduardo Gabriel Martins de Lima Garcia
-- ============================================

-- CRIAÇÃO DAS TABELAS

-- Tabela Cliente
CREATE TABLE Cliente (
    telefone VARCHAR(15) PRIMARY KEY,
    nomeCliente VARCHAR(100) NOT NULL,
    dataCadastro DATE NOT NULL
);

-- Tabela Funcionario
CREATE TABLE Funcionario (
    nomeFunc VARCHAR(100) PRIMARY KEY,
    cargo VARCHAR(50) NOT NULL
);

-- Especializações de Funcionario
CREATE TABLE Atendente (
    nomeFunc VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (nomeFunc) REFERENCES Funcionario(nomeFunc)
);

CREATE TABLE Cozinheiro (
    nomeFunc VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (nomeFunc) REFERENCES Funcionario(nomeFunc)
);

CREATE TABLE Sommelier (
    nomeFunc VARCHAR(100) PRIMARY KEY,
    FOREIGN KEY (nomeFunc) REFERENCES Funcionario(nomeFunc)
);

-- Hierarquia de Origem (resultado da normalização 3FN do Queijo)
CREATE TABLE Pais (
    nomePais VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Cidade (
    nomeCidade VARCHAR(100) PRIMARY KEY,
    nomePais VARCHAR(100) NOT NULL,
    FOREIGN KEY (nomePais) REFERENCES Pais(nomePais)
);

CREATE TABLE Regiao (
    nomeRegiao VARCHAR(100) PRIMARY KEY,
    nomeCidade VARCHAR(100) NOT NULL,
    FOREIGN KEY (nomeCidade) REFERENCES Cidade(nomeCidade)
);

-- Tabela Produto (superclasse)
CREATE TABLE Produto (
    nomeProd VARCHAR(100) PRIMARY KEY,
    preco NUMERIC(10,2) NOT NULL,
    origem VARCHAR(100),
    dataValidade DATE,
    descricao VARCHAR(255),
    qtdDisponivel INTEGER NOT NULL,
    categoria VARCHAR(50)
);

-- Especializações de Produto
CREATE TABLE Queijo (
    nomeProd VARCHAR(100) PRIMARY KEY,
    maturacao VARCHAR(50),
    sabor VARCHAR(50),
    textura VARCHAR(50),
    nomeRegiao VARCHAR(100),
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd),
    FOREIGN KEY (nomeRegiao) REFERENCES Regiao(nomeRegiao)
);

CREATE TABLE Vinho_Bebida (
    nomeProd VARCHAR(100) PRIMARY KEY,
    teorAlcoolico NUMERIC(4,2),
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd)
);

CREATE TABLE Pao (
    nomeProd VARCHAR(100) PRIMARY KEY,
    formato VARCHAR(50),
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd)
);

CREATE TABLE Acessorio (
    nomeProd VARCHAR(100) PRIMARY KEY,
    tipoPrep VARCHAR(50),
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd)
);

-- Resultado da normalização 1FN do Acessorio (multivalorado)
CREATE TABLE AcessorioBebida (
    nomeProd VARCHAR(100),
    bebida VARCHAR(100),
    tempoPrep INTEGER,
    PRIMARY KEY (nomeProd, bebida),
    FOREIGN KEY (nomeProd) REFERENCES Acessorio(nomeProd)
);

-- Item Preparado Internamente (especialização de Produto)
CREATE TABLE ItemPrepInterno (
    nomeProd VARCHAR(100) PRIMARY KEY,
    dataConfec DATE NOT NULL,
    nomeFunc VARCHAR(100) NOT NULL,
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd),
    FOREIGN KEY (nomeFunc) REFERENCES Cozinheiro(nomeFunc)
);

-- Tabela Encomenda
CREATE TABLE Encomenda (
    numeroPedido INTEGER PRIMARY KEY,
    dataEncomenda DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    telefone VARCHAR(15) NOT NULL,
    nomeFunc VARCHAR(100) NOT NULL,
    FOREIGN KEY (telefone) REFERENCES Cliente(telefone),
    FOREIGN KEY (nomeFunc) REFERENCES Atendente(nomeFunc)
);

-- Tabela Harmonizacao
CREATE TABLE Harmonizacao (
    nomeProdQueijo VARCHAR(100),
    nomeProdVinho VARCHAR(100),
    nomeFunc VARCHAR(100) NOT NULL,
    PRIMARY KEY (nomeProdQueijo, nomeProdVinho),
    FOREIGN KEY (nomeProdQueijo) REFERENCES Queijo(nomeProd),
    FOREIGN KEY (nomeProdVinho) REFERENCES Vinho_Bebida(nomeProd),
    FOREIGN KEY (nomeFunc) REFERENCES Sommelier(nomeFunc)
);

-- Itens da Encomenda
CREATE TABLE ItensEncomenda (
    numeroPedido INTEGER,
    nomeProd VARCHAR(100),
    quantidade INTEGER NOT NULL,
    PRIMARY KEY (numeroPedido, nomeProd),
    FOREIGN KEY (numeroPedido) REFERENCES Encomenda(numeroPedido),
    FOREIGN KEY (nomeProd) REFERENCES Produto(nomeProd)
);

-- ============================================
-- POPULAÇÃO DAS TABELAS (INSERTS)
-- ============================================

-- Cliente
INSERT INTO Cliente (telefone, nomeCliente, dataCadastro) VALUES
('21900010001', 'Ana Souza', '2024-01-10'),
('21900010002', 'Bruno Lima', '2024-02-15'),
('21900010003', 'Carla Mendes', '2024-03-20'),
('21900010004', 'Diego Alves', '2024-04-05'),
('21900010005', 'Elaine Costa', '2024-05-12'),
('21900010006', 'Fabio Nunes', '2024-06-01'),
('21900010007', 'Gabriela Teixeira', '2024-07-18'),
('21900010008', 'Henrique Barbosa', '2024-08-22'),
('21900010009', 'Isabela Freitas', '2024-09-30'),
('21900010010', 'Joao Pedro Martins', '2024-10-14');

-- Funcionario
INSERT INTO Funcionario (nomeFunc, cargo) VALUES
('Fernando Rocha', 'Atendente'),
('Gustavo Pires', 'Atendente'),
('Mariana Lopes', 'Atendente'),
('Helena Dias', 'Cozinheiro'),
('Igor Santos', 'Cozinheiro'),
('Patricia Oliveira', 'Cozinheiro'),
('Julia Ramos', 'Sommelier'),
('Carlos Gerente', 'Gerente'),
('Beatriz Gerente', 'Gerente');

-- Especializações de Funcionario
INSERT INTO Atendente (nomeFunc) VALUES
('Fernando Rocha'),
('Gustavo Pires'),
('Mariana Lopes');

INSERT INTO Cozinheiro (nomeFunc) VALUES
('Helena Dias'),
('Igor Santos'),
('Patricia Oliveira');

INSERT INTO Sommelier (nomeFunc) VALUES
('Julia Ramos');

-- Pais
INSERT INTO Pais (nomePais) VALUES
('Franca'),
('Italia'),
('Portugal'),
('Brasil'),
('Espanha'),
('Holanda');

-- Cidade
INSERT INTO Cidade (nomeCidade, nomePais) VALUES
('Roquefort-sur-Soulzon', 'Franca'),
('Brie', 'Franca'),
('Parma', 'Italia'),
('Grana', 'Italia'),
('Serra da Estrela', 'Portugal'),
('Minas Gerais', 'Brasil'),
('Sao Paulo', 'Brasil'),
('Manchega', 'Espanha'),
('Gouda', 'Holanda');

-- Regiao
INSERT INTO Regiao (nomeRegiao, nomeCidade) VALUES
('Roquefort-sur-Soulzon', 'Roquefort-sur-Soulzon'),
('Brie-de-Meaux', 'Brie'),
('Emilia-Romanha', 'Parma'),
('Pianura Padana', 'Grana'),
('Beira', 'Serra da Estrela'),
('Canastra', 'Minas Gerais'),
('Mantiqueira', 'Minas Gerais'),
('Serra Gaucha', 'Sao Paulo'),
('La Mancha', 'Manchega'),
('Zuid-Holland', 'Gouda');

-- Produto
INSERT INTO Produto (nomeProd, preco, origem, dataValidade, descricao, qtdDisponivel, categoria) VALUES
('Queijo Roquefort', 89.90, 'Franca', '2026-08-15', 'Queijo azul de leite de ovelha', 10, 'Queijo'),
('Queijo Brie', 72.00, 'Franca', '2026-07-10', 'Queijo macio de casca branca', 12, 'Queijo'),
('Queijo Parmesao', 75.50, 'Italia', '2026-09-01', 'Queijo duro maturado', 15, 'Queijo'),
('Queijo Grana Padano', 68.00, 'Italia', '2026-09-15', 'Queijo granulado italiano', 10, 'Queijo'),
('Queijo Serra da Estrela', 65.00, 'Portugal', '2026-07-20', 'Queijo de leite de ovelha cremoso', 8, 'Queijo'),
('Queijo Canastra', 55.00, 'Brasil', '2026-08-30', 'Queijo artesanal mineiro', 12, 'Queijo'),
('Queijo Mantiqueira', 50.00, 'Brasil', '2026-08-01', 'Queijo artesanal da Serra da Mantiqueira', 9, 'Queijo'),
('Queijo Manchego', 82.00, 'Espanha', '2026-10-01', 'Queijo espanhol de leite de ovelha', 7, 'Queijo'),
('Queijo Gouda', 60.00, 'Holanda', '2026-09-20', 'Queijo holandes semi-duro', 11, 'Queijo'),
('Vinho Tinto Reserva', 120.00, 'Brasil', '2028-01-01', 'Vinho tinto seco encorpado', 20, 'Vinho/Bebida'),
('Vinho Branco Seco', 95.00, 'Portugal', '2027-12-01', 'Vinho branco leve e frutado', 18, 'Vinho/Bebida'),
('Vinho Rose', 85.00, 'Franca', '2027-06-01', 'Vinho rose seco e refrescante', 14, 'Vinho/Bebida'),
('Cerveja Artesanal IPA', 22.00, 'Brasil', '2026-12-01', 'Cerveja amarga lupulada', 30, 'Vinho/Bebida'),
('Cerveja Artesanal Stout', 24.00, 'Brasil', '2026-11-01', 'Cerveja escura encorpada', 25, 'Vinho/Bebida'),
('Baguete Tradicional', 12.00, 'Franca', '2026-06-15', 'Pao crocante alongado', 25, 'Pao'),
('Pao de Forma Integral', 9.50, 'Brasil', '2026-06-18', 'Pao de forma com graos', 20, 'Pao'),
('Focaccia', 15.00, 'Italia', '2026-06-14', 'Pao italiano achatado com azeite', 10, 'Pao'),
('Pao Trancado', 13.00, 'Brasil', '2026-06-16', 'Pao trancado artesanal', 15, 'Pao'),
('Cafeteira Italiana', 85.00, 'Italia', NULL, 'Acessorio para preparo de cafe', 5, 'Acessorio'),
('Bule de Cha', 45.00, 'Brasil', NULL, 'Acessorio para preparo de cha', 7, 'Acessorio'),
('Filtro de Cafe', 30.00, 'Brasil', NULL, 'Filtro especial para cafe coado', 10, 'Acessorio'),
('Sanduiche de Pastrami', 28.00, 'Brasil', '2026-06-13', 'Sanduiche preparado na hora', 6, 'Item Preparado'),
('Salada Caprese', 24.00, 'Brasil', '2026-06-13', 'Salada com tomate e mussarela', 5, 'Item Preparado'),
('Quiche de Queijo', 22.00, 'Brasil', '2026-06-13', 'Quiche artesanal de queijo', 4, 'Item Preparado'),
('Tabule', 18.00, 'Brasil', '2026-06-13', 'Salada de trigo com legumes', 5, 'Item Preparado'),
('Lasanha Bolonhesa', 35.00, 'Brasil', '2026-06-14', 'Lasanha preparada no dia', 3, 'Item Preparado'),
('Azeitona Marinada', 18.00, 'Italia', '2026-10-01', 'Antepasto de azeitonas', 15, 'Antepasto'),
('Berinjela a Parmegiana', 22.00, 'Italia', '2026-06-15', 'Antepasto de berinjela', 8, 'Antepasto'),
('Azeite Extra Virgem', 45.00, 'Italia', '2027-03-01', 'Azeite de oliva premium', 20, 'Gourmet'),
('Geleia de Figo', 28.00, 'Brasil', '2027-01-01', 'Geleia artesanal de figo', 12, 'Gourmet');

-- Queijo
INSERT INTO Queijo (nomeProd, maturacao, sabor, textura, nomeRegiao) VALUES
('Queijo Roquefort', '3 meses', 'Picante', 'Cremosa', 'Roquefort-sur-Soulzon'),
('Queijo Brie', '6 semanas', 'Suave', 'Macia', 'Brie-de-Meaux'),
('Queijo Parmesao', '24 meses', 'Salgado', 'Dura', 'Emilia-Romanha'),
('Queijo Grana Padano', '18 meses', 'Delicado', 'Dura', 'Pianura Padana'),
('Queijo Serra da Estrela', '2 meses', 'Suave', 'Cremosa', 'Beira'),
('Queijo Canastra', '1 mes', 'Acentuado', 'Semidura', 'Canastra'),
('Queijo Mantiqueira', '45 dias', 'Suave', 'Semimole', 'Mantiqueira'),
('Queijo Manchego', '6 meses', 'Intenso', 'Firme', 'La Mancha'),
('Queijo Gouda', '4 meses', 'Adocicado', 'Semidura', 'Zuid-Holland');

-- Vinho_Bebida
INSERT INTO Vinho_Bebida (nomeProd, teorAlcoolico) VALUES
('Vinho Tinto Reserva', 13.50),
('Vinho Branco Seco', 12.00),
('Vinho Rose', 11.50),
('Cerveja Artesanal IPA', 6.50),
('Cerveja Artesanal Stout', 7.00);

-- Pao
INSERT INTO Pao (nomeProd, formato) VALUES
('Baguete Tradicional', 'Alongado'),
('Pao de Forma Integral', 'Retangular'),
('Focaccia', 'Achatado'),
('Pao Trancado', 'Trancado');

-- Acessorio
INSERT INTO Acessorio (nomeProd, tipoPrep) VALUES
('Cafeteira Italiana', 'Espresso'),
('Bule de Cha', 'Infusao'),
('Filtro de Cafe', 'Coado');

-- AcessorioBebida
INSERT INTO AcessorioBebida (nomeProd, bebida, tempoPrep) VALUES
('Cafeteira Italiana', 'Cafe Espresso', 5),
('Cafeteira Italiana', 'Cafe com Leite', 8),
('Bule de Cha', 'Cha Verde', 3),
('Bule de Cha', 'Cha de Camomila', 5),
('Bule de Cha', 'Cha de Hortela', 4),
('Filtro de Cafe', 'Cafe Coado', 10),
('Filtro de Cafe', 'Cafe Coado Forte', 15);

-- ItemPrepInterno
INSERT INTO ItemPrepInterno (nomeProd, dataConfec, nomeFunc) VALUES
('Sanduiche de Pastrami', '2026-06-10', 'Helena Dias'),
('Salada Caprese', '2026-06-10', 'Igor Santos'),
('Quiche de Queijo', '2026-06-11', 'Helena Dias'),
('Tabule', '2026-06-11', 'Patricia Oliveira'),
('Lasanha Bolonhesa', '2026-06-12', 'Igor Santos');

-- Encomenda
INSERT INTO Encomenda (numeroPedido, dataEncomenda, status, telefone, nomeFunc) VALUES
(1001, '2026-06-08', 'Entregue', '21900010001', 'Fernando Rocha'),
(1002, '2026-06-09', 'Pendente', '21900010002', 'Gustavo Pires'),
(1003, '2026-06-09', 'Entregue', '21900010001', 'Fernando Rocha'),
(1004, '2026-06-10', 'Pendente', '21900010003', 'Gustavo Pires'),
(1005, '2026-06-10', 'Cancelado', '21900010004', 'Fernando Rocha'),
(1006, '2026-06-11', 'Entregue', '21900010005', 'Mariana Lopes'),
(1007, '2026-06-11', 'Pendente', '21900010006', 'Fernando Rocha'),
(1008, '2026-06-12', 'Entregue', '21900010007', 'Gustavo Pires'),
(1009, '2026-06-12', 'Entregue', '21900010008', 'Mariana Lopes'),
(1010, '2026-06-13', 'Pendente', '21900010009', 'Fernando Rocha'),
(1011, '2026-06-13', 'Entregue', '21900010010', 'Gustavo Pires'),
(1012, '2026-06-13', 'Pendente', '21900010001', 'Mariana Lopes');

-- Harmonizacao
INSERT INTO Harmonizacao (nomeProdQueijo, nomeProdVinho, nomeFunc) VALUES
('Queijo Roquefort', 'Vinho Tinto Reserva', 'Julia Ramos'),
('Queijo Roquefort', 'Vinho Rose', 'Julia Ramos'),
('Queijo Brie', 'Vinho Branco Seco', 'Julia Ramos'),
('Queijo Parmesao', 'Vinho Branco Seco', 'Julia Ramos'),
('Queijo Parmesao', 'Vinho Tinto Reserva', 'Julia Ramos'),
('Queijo Grana Padano', 'Vinho Tinto Reserva', 'Julia Ramos'),
('Queijo Canastra', 'Cerveja Artesanal IPA', 'Julia Ramos'),
('Queijo Canastra', 'Vinho Tinto Reserva', 'Julia Ramos'),
('Queijo Mantiqueira', 'Vinho Branco Seco', 'Julia Ramos'),
('Queijo Serra da Estrela', 'Vinho Branco Seco', 'Julia Ramos'),
('Queijo Manchego', 'Vinho Rose', 'Julia Ramos'),
('Queijo Gouda', 'Cerveja Artesanal Stout', 'Julia Ramos');

-- ItensEncomenda
INSERT INTO ItensEncomenda (numeroPedido, nomeProd, quantidade) VALUES
(1001, 'Queijo Roquefort', 2),
(1001, 'Vinho Tinto Reserva', 3),
(1002, 'Baguete Tradicional', 4),
(1002, 'Queijo Canastra', 2),
(1003, 'Sanduiche de Pastrami', 3),
(1003, 'Cerveja Artesanal IPA', 6),
(1004, 'Salada Caprese', 2),
(1004, 'Queijo Parmesao', 2),
(1004, 'Vinho Branco Seco', 3),
(1005, 'Focaccia', 2),
(1006, 'Queijo Brie', 1),
(1006, 'Vinho Rose', 2),
(1006, 'Baguete Tradicional', 3),
(1007, 'Queijo Gouda', 2),
(1007, 'Cerveja Artesanal Stout', 4),
(1008, 'Lasanha Bolonhesa', 2),
(1008, 'Vinho Tinto Reserva', 2),
(1008, 'Queijo Manchego', 1),
(1009, 'Tabule', 3),
(1009, 'Queijo Mantiqueira', 2),
(1009, 'Pao Trancado', 4),
(1010, 'Quiche de Queijo', 3),
(1010, 'Vinho Branco Seco', 2),
(1011, 'Azeitona Marinada', 2),
(1011, 'Queijo Grana Padano', 1),
(1011, 'Cerveja Artesanal IPA', 5),
(1012, 'Azeite Extra Virgem', 2),
(1012, 'Geleia de Figo', 3),
(1012, 'Queijo Canastra', 2);

-- ============================================
-- CONSULTAS
-- ============================================

-- Consultas de Guilherme Oliveira Figueiredo

-- CONSULTA 1: Listar todas as encomendas feitas, mostrando o nome do cliente que fez o pedido, a data e o status da encomenda. (JOIN)
SELECT
    e.numeroPedido,
    c.nomeCliente,
    e.dataEncomenda,
    e.status
FROM Encomenda e
INNER JOIN Cliente c ON e.telefone = c.telefone;

-- CONSULTA 2: Listar os itens que foram preparados internamente na cozinha, exibindo o nome do produto, a data de confecção e o nome do cozinheiro que o preparou. (JOIN)
SELECT
    i.nomeProd,
    i.dataConfec,
    f.nomeFunc AS nomeCozinheiro
FROM ItemPrepInterno i
INNER JOIN Cozinheiro cz ON i.nomeFunc = cz.nomeFunc
INNER JOIN Funcionario f ON cz.nomeFunc = f.nomeFunc;

-- CONSULTA 3: Exibir a quantidade total de itens vendidos para cada produto nas encomendas, mostrando apenas os produtos que tiveram mais de 5 unidades vendidas no total. (GROUP BY)
SELECT
    nomeProd,
    SUM(Quantidade) AS totalVendido
FROM ItensEncomenda
GROUP BY nomeProd
HAVING SUM(Quantidade) > 5;

-- CONSULTA 4: Encontrar os nomes e preços dos produtos que pertencem às categorias de 'Vinho/Bebida' ou 'Queijo'. (IN)
SELECT
    nomeProd,
    preco,
    categoria
FROM Produto
WHERE categoria IN ('Vinho/Bebida', 'Queijo');

-- CONSULTA 5: Listar os nomes de todos os Sommeliers que já realizaram pelo menos uma indicação de harmonização. (EXISTS)
SELECT f.nomeFunc AS nomeSommelier
FROM Sommelier s
INNER JOIN Funcionario f ON s.nomeFunc = f.nomeFunc
WHERE EXISTS (
    SELECT 1
    FROM Harmonizacao h
    WHERE h.nomeFunc = s.nomeFunc
);

-- ============================================
-- Consultas de Maria Eduarda Oliveira de Amorim Meneses

-- CONSULTA 6: Listar todos os produtos que um determinado cliente já encomendou, exibindo o nome do cliente, nome do produto, data da encomenda e o preço. (JOIN)
SELECT
    c.nomeCliente,
    p.nomeProd,
    e.dataEncomenda,
    p.preco
FROM Cliente c
INNER JOIN Encomenda e ON c.telefone = e.telefone
INNER JOIN ItensEncomenda ie ON e.numeroPedido = ie.numeroPedido
INNER JOIN Produto p ON ie.nomeProd = p.nomeProd
WHERE c.nomeCliente = 'Ana Souza';

-- CONSULTA 7: Listar todas as harmonizações cadastradas, retornando o nome do queijo, o nome da bebida e o nome do sommelier responsável. (JOIN)
SELECT
    h.nomeProdQueijo,
    h.nomeProdVinho,
    f.nomeFunc AS nomeSommelier
FROM Harmonizacao h
INNER JOIN Sommelier s ON h.nomeFunc = s.nomeFunc
INNER JOIN Funcionario f ON s.nomeFunc = f.nomeFunc;

-- CONSULTA 8: Exibir quantas encomendas cada cliente já realizou, mostrando apenas os clientes que fizeram mais de 1 encomenda. (GROUP BY)
SELECT
    c.nomeCliente,
    COUNT(e.numeroPedido) AS totalEncomendas
FROM Cliente c
INNER JOIN Encomenda e ON c.telefone = e.telefone
GROUP BY c.nomeCliente
HAVING COUNT(e.numeroPedido) > 1
ORDER BY totalEncomendas DESC;

-- CONSULTA 9: Listar os nomes de todos os queijos que possuem ao menos uma harmonização indicada no sistema. (EXISTS)
SELECT q.nomeProd
FROM Queijo q
WHERE EXISTS (
    SELECT 1
    FROM Harmonizacao h
    WHERE h.nomeProdQueijo = q.nomeProd
);

-- CONSULTA 10: Listar os produtos com quantidade disponível menor que 5 unidades e que já foram pedidos em alguma encomenda. (IN)
SELECT
    nomeProd,
    categoria,
    qtdDisponivel
FROM Produto
WHERE qtdDisponivel < 5
  AND nomeProd IN (
      SELECT nomeProd
      FROM ItensEncomenda
  );

-- ============================================
-- Consultas de Rodrigo de Souza Gomes

-- CONSULTA 11: Listar as encomendas pendentes, exibindo o nome do cliente, telefone, nome do produto e quantidade pedida. (JOIN)
SELECT
    c.nomeCliente,
    c.telefone,
    ie.nomeProd,
    ie.Quantidade
FROM Encomenda e
INNER JOIN Cliente c ON e.telefone = c.telefone
INNER JOIN ItensEncomenda ie ON e.numeroPedido = ie.numeroPedido
WHERE e.status = 'Pendente';

-- CONSULTA 12: Listar os queijos exibindo nome, maturação, sabor, textura e origem completa (região, cidade e país). (JOIN)
SELECT
    q.nomeProd,
    q.maturacao,
    q.sabor,
    q.textura,
    r.nomeRegiao,
    c.nomeCidade,
    p.nomePais
FROM Queijo q
INNER JOIN Regiao r ON q.nomeRegiao = r.nomeRegiao
INNER JOIN Cidade c ON r.nomeCidade = c.nomeCidade
INNER JOIN Pais p ON c.nomePais = p.nomePais;

-- CONSULTA 13: Para cada categoria de produto, exibir a quantidade total disponível em estoque, mostrando apenas as categorias com total maior que 10 unidades. (GROUP BY)
SELECT
    categoria,
    SUM(qtdDisponivel) AS totalDisponivel
FROM Produto
GROUP BY categoria
HAVING SUM(qtdDisponivel) > 10;

-- CONSULTA 14: Listar os produtos que nunca foram pedidos em nenhuma encomenda. (IN)
SELECT
    nomeProd,
    categoria,
    descricao
FROM Produto
WHERE nomeProd NOT IN (
    SELECT nomeProd
    FROM ItensEncomenda
);

-- CONSULTA 15: Exibir os produtos mais encomendados em um determinado período, ordenados do mais pedido para o menos pedido. (JOIN + GROUP BY)
SELECT
    ie.nomeProd,
    SUM(ie.Quantidade) AS totalEncomendado
FROM ItensEncomenda ie
INNER JOIN Encomenda e ON ie.numeroPedido = e.numeroPedido
WHERE e.dataEncomenda BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY ie.nomeProd
ORDER BY totalEncomendado DESC
LIMIT 5;

-- ============================================
-- Consultas de Nicolas de Oliveira Dutra

-- CONSULTA 16: Listar os acessórios com tempo de preparo menor que 5 minutos, exibindo nome, tipo de preparo e tempo. (JOIN)
SELECT
    p.nomeProd,
    a.tipoPrep,
    ab.tempoPrep
FROM Produto p
INNER JOIN Acessorio a ON p.nomeProd = a.nomeProd
INNER JOIN AcessorioBebida ab ON a.nomeProd = ab.nomeProd
WHERE ab.tempoPrep < 5;

-- CONSULTA 17: Exibir a quantidade de pães cadastrados para cada formato, mostrando apenas os formatos com mais de 1 pão. (GROUP BY)
SELECT
    p.formato,
    COUNT(p.nomeProd) AS totalPorFormato
FROM Pao p
GROUP BY p.formato
HAVING COUNT(p.nomeProd) > 1;

-- CONSULTA 18: Listar todas as encomendas com status pendente, exibindo nome do cliente, telefone e data da encomenda. (JOIN)
SELECT
    c.nomeCliente,
    c.telefone,
    e.dataEncomenda
FROM Encomenda e
INNER JOIN Cliente c ON e.telefone = c.telefone
WHERE e.status = 'Pendente';

-- CONSULTA 19: Exibir a quantidade de itens que cada cozinheiro já preparou, mostrando apenas os que prepararam mais de 2 itens. (GROUP BY)
SELECT
    i.nomeFunc AS nomeCozinheiro,
    COUNT(i.dataConfec) AS totalPreparado
FROM ItemPrepInterno i
GROUP BY i.nomeFunc
HAVING COUNT(i.dataConfec) > 2;

-- CONSULTA 20: Listar os sommeliers que já possuem alguma indicação de harmonização cadastrada. (EXISTS)
SELECT s.nomeFunc AS nomeSommelier
FROM Sommelier s
WHERE EXISTS (
    SELECT 1
    FROM Harmonizacao h
    WHERE h.nomeFunc = s.nomeFunc
);

-- ============================================
-- Consultas de Eduardo Gabriel Martins de Lima Garcia

-- CONSULTA 21: Listar os produtos com data de validade vencida, útil para o gerente remover das gôndolas. (IN)
SELECT nomeProd, categoria, dataValidade
FROM Produto
WHERE dataValidade < CURRENT_DATE
AND nomeProd IN (
    SELECT nomeProd
    FROM Produto
    WHERE dataValidade IS NOT NULL
);

-- CONSULTA 22: Listar os vinhos e bebidas cujo teor alcoólico está acima da média de todos os cadastrados. (JOIN)
SELECT vb.nomeProd, vb.teorAlcoolico
FROM Vinho_Bebida vb
INNER JOIN Produto p ON vb.nomeProd = p.nomeProd
WHERE vb.teorAlcoolico > (
    SELECT AVG(teorAlcoolico)
    FROM Vinho_Bebida
);

-- CONSULTA 23: Listar os atendentes e o total de encomendas que cada um registrou, ordenado do maior para o menor. (JOIN + GROUP BY)
SELECT
    f.nomeFunc AS nomeAtendente,
    COUNT(e.numeroPedido) AS totalEncomendas
FROM Atendente a
INNER JOIN Funcionario f ON a.nomeFunc = f.nomeFunc
INNER JOIN Encomenda e ON a.nomeFunc = e.nomeFunc
GROUP BY f.nomeFunc
ORDER BY totalEncomendas DESC;

-- CONSULTA 24: Listar os produtos de origem estrangeira que já foram pedidos em ao menos uma encomenda. (EXISTS)
SELECT nomeProd, origem, categoria
FROM Produto
WHERE origem <> 'Brasil'
AND EXISTS (
    SELECT 1
    FROM ItensEncomenda ie
    WHERE ie.nomeProd = Produto.nomeProd
);

-- CONSULTA 25: Exibir o valor total de cada encomenda, mostrando o número do pedido, o nome do cliente e o valor total. (JOIN + GROUP BY)
SELECT
    e.numeroPedido,
    c.nomeCliente,
    SUM(p.preco * ie.quantidade) AS valorTotal
FROM Encomenda e
INNER JOIN Cliente c ON e.telefone = c.telefone
INNER JOIN ItensEncomenda ie ON e.numeroPedido = ie.numeroPedido
INNER JOIN Produto p ON ie.nomeProd = p.nomeProd
GROUP BY e.numeroPedido, c.nomeCliente
ORDER BY valorTotal DESC;
