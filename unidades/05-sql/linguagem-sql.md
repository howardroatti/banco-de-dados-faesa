---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Linguagem SQL
## DDL, DML e DQL na prática

**Unidade 5** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- **SQL**: uma linguagem, quatro grupos — **DDL, DML, DQL, DCL**
- **DDL** — criar e alterar a estrutura (tabelas, chaves, índices, views)
- **DML** — inserir, atualizar e apagar dados
- **DQL** — consultar (`SELECT`): filtros, junções, agregações, subconsultas
- **Portabilidade** Oracle / PostgreSQL / MySQL

<div class="vm">🖥️ Todos os exemplos saem do <strong>Roteiro Prático de SQL</strong> e rodam na <strong>VM LabDatabase</strong>.</div>

---

## O domínio de exemplo (acadêmico)

Um mini sistema acadêmico — o mesmo do Roteiro Prático:

- **ALUNOS**, **PROFESSORES**, **DISCIPLINAS**
- **OFERTAS** (uma disciplina, um professor, um horário)
- **ALUNOS_OFERTAS** (matrícula do aluno numa oferta — tabela associativa M:N)
- **TELEFONES_ALUNOS** (telefones de um aluno — 1:N)

<div class="dica">💡 Na Parte 3 o roteiro troca para um domínio de <strong>vendas</strong> (clientes, produtos, pedidos) para praticar consultas mais ricas.</div>

---

## Os quatro grupos da SQL

| Grupo | Para quê | Comandos |
|---|---|---|
| **DDL** — *Definition* | estrutura | `CREATE`, `ALTER`, `DROP` |
| **DML** — *Manipulation* | dados | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** — *Query* | consulta | `SELECT` |
| **DCL** — *Control* | permissões | `GRANT`, `REVOKE` |

*(há ainda o TCL — `COMMIT`, `ROLLBACK`, `SAVEPOINT` — visto na Unidade 6.)*

---

<!-- _class: secao -->

# DDL — definindo a estrutura

---

## CREATE TABLE

```sql
CREATE TABLE ALUNOS (
    MATRICULA        NUMERIC       NOT NULL,
    NOME             VARCHAR2(100) NOT NULL,
    DATA_NASCIMENTO  DATE          NOT NULL
);

CREATE TABLE DISCIPLINAS (
    CODIGO_DISCIPLINA   NUMERIC       NOT NULL,
    NOME_DISCIPLINA     VARCHAR2(100) NOT NULL,
    CARGA_HORARIA       NUMERIC(3)    NOT NULL,
    EMENTA              VARCHAR2(4000) NOT NULL,
    CODIGO_DISCIPLINA_DEPENDENCIA NUMERIC    -- auto-relacionamento
);
```

`NOT NULL` é uma **restrição de integridade**: o campo é obrigatório.

---

## Tipos de dados mais comuns

| Categoria | Oracle | PostgreSQL / MySQL |
|---|---|---|
| Texto | `VARCHAR2(n)` | `VARCHAR(n)` |
| Inteiro | `NUMERIC` / `NUMBER` | `INTEGER` / `INT` |
| Decimal | `NUMBER(p,s)` | `NUMERIC(p,s)` |
| Data | `DATE` | `DATE` |
| Data + hora | `TIMESTAMP` | `TIMESTAMP` |

<div class="dica">💡 Escolha o tipo pelo <strong>significado</strong> do dado — não guarde data como texto nem dinheiro como <code>float</code>.</div>

---

## ALTER TABLE — evoluindo a estrutura

```sql
-- adicionar / modificar coluna
ALTER TABLE ALUNOS   ADD    EMAIL VARCHAR2(200);
ALTER TABLE ALUNOS   MODIFY EMAIL VARCHAR2(250);
ALTER TABLE OFERTAS  MODIFY DATA_CRIACAO DATE DEFAULT SYSDATE NOT NULL;

-- renomear tabela e coluna
ALTER TABLE TELEFONES RENAME TO TELEFONES_ALUNOS;
ALTER TABLE ALUNOS RENAME COLUMN MATRICULA TO MATRICULA_ALUNO;

-- remover coluna
ALTER TABLE ALUNOS DROP COLUMN EMAIL;
```

<div class="aviso"><code>DROP COLUMN</code> apaga os dados daquela coluna — é irreversível sem backup.</div>

---

## Chaves: PRIMARY KEY e FOREIGN KEY

```sql
-- chave primária (simples e composta)
ALTER TABLE ALUNOS         ADD PRIMARY KEY (MATRICULA_ALUNO);
ALTER TABLE ALUNOS_OFERTAS ADD PRIMARY KEY (MATRICULA_ALUNO, CODIGO_OFERTA);

-- chave estrangeira
ALTER TABLE OFERTAS
  ADD CONSTRAINT OFERTAS_PROFESSOR_FK
      FOREIGN KEY (MATRICULA_PROFESSOR)
      REFERENCES PROFESSORES (MATRICULA_PROFESSOR);
```

A **FK** garante a **integridade referencial**: não existe oferta apontando para um professor inexistente.

---

## Sequences e Índices

```sql
-- sequência para gerar códigos automáticos (Oracle)
CREATE SEQUENCE DISCIPLINAS_SEQ;
INSERT INTO DISCIPLINAS VALUES (DISCIPLINAS_SEQ.NEXTVAL, ...);

-- índice para acelerar buscas por nome
CREATE INDEX ALUNOS_NOME_IDX ON ALUNOS (NOME_ALUNO);
```

<div class="dica">💡 Em PostgreSQL/MySQL, o autoincremento costuma vir de <code>SERIAL</code> / <code>AUTO_INCREMENT</code> em vez de <em>sequence</em> explícita.</div>

---

## Views — consultas com nome

```sql
CREATE VIEW ALUNOS_MATRICULADOS AS
  SELECT A.NOME_ALUNO AS ALUNO, AO.SEMESTRE,
         O.DIA_SEMANA, P.NOME_PROFESSOR AS PROFESSOR,
         D.NOME_DISCIPLINA
    FROM ALUNOS_OFERTAS AO
    JOIN ALUNOS       A ON AO.MATRICULA_ALUNO = A.MATRICULA_ALUNO
    JOIN OFERTAS      O ON AO.CODIGO_OFERTA   = O.CODIGO_OFERTA
    JOIN PROFESSORES  P ON O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR
    JOIN DISCIPLINAS  D ON O.CODIGO_DISCIPLINA   = D.CODIGO_DISCIPLINA;
```

Depois é só `SELECT * FROM ALUNOS_MATRICULADOS;` — a complexidade fica escondida.

---

<!-- _class: secao -->

# DML — manipulando os dados

---

## INSERT

```sql
INSERT INTO ALUNOS
VALUES (40001, 'JOÃO GABRIEL', TO_DATE('02/04/1985','DD/MM/YYYY'));

-- forma explícita (recomendada): lista as colunas
INSERT INTO ALUNOS (MATRICULA_ALUNO, NOME_ALUNO, DATA_NASCIMENTO)
VALUES (40002, 'JOÃO JOSÉ', TO_DATE('31/12/2001','DD/MM/YYYY'));
```

<div class="dica">💡 Listar as colunas deixa o comando <strong>imune</strong> a mudanças na ordem/quantidade de colunas da tabela.</div>

---

## UPDATE

```sql
-- sempre com WHERE! (senão altera a tabela inteira)
UPDATE ALUNOS
   SET DATA_NASCIMENTO = TO_DATE('29/04/2011','DD/MM/YYYY')
 WHERE MATRICULA_ALUNO = 40004;

-- atualização condicional por conjunto
UPDATE PROFESSORES
   SET FORMACAO = 'PHD'
 WHERE FORMACAO = 'DOUTORADO';
```

<div class="aviso">Um <code>UPDATE</code> sem <code>WHERE</code> altera <strong>todas</strong> as linhas. Confira o filtro com um <code>SELECT</code> antes.</div>

---

## DELETE

```sql
DELETE FROM DISCIPLINAS
 WHERE CODIGO_DISCIPLINA IN (85853, 75189);

-- apagar professores que não têm nenhuma oferta
DELETE FROM PROFESSORES P
 WHERE NOT EXISTS (SELECT 1 FROM OFERTAS O
                    WHERE O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR);
```

<div class="dica">💡 Enquanto não houver <code>COMMIT</code>, um <code>ROLLBACK</code> desfaz o que você apagou (Unidade 6 — Transações).</div>

---

<!-- _class: secao -->

# DQL — consultando com SELECT

---

## SELECT: projeção, alias e funções

```sql
SELECT MATRICULA_ALUNO,
       INITCAP(NOME_ALUNO) AS NOME_ALUNO,
       TO_CHAR(DATA_NASCIMENTO, 'DD/MM/YYYY') AS NASCIMENTO
  FROM ALUNOS
 WHERE DATA_NASCIMENTO <= TO_DATE('01/01/2000', 'DD/MM/YYYY');
```

- **Projeção**: escolher **colunas** (em vez de `SELECT *`).
- **Alias** (`AS`): renomear a coluna no resultado.
- **Funções**: `INITCAP`, `SUBSTR`, `TO_CHAR`, `UPPER`/`LOWER`…

---

## WHERE: operadores de filtro

```sql
WHERE PED.VALOR_TOTAL NOT BETWEEN 100 AND 5000        -- faixa
WHERE CLI.UF IN ('ES','MG')                           -- lista
WHERE CLI.UF NOT IN ('RJ','SP')
WHERE CODIGO_DISCIPLINA_DEPENDENCIA IS NULL           -- ausência de valor
WHERE CLI.CODIGO_CLIENTE < 5 OR CLI.CODIGO_CLIENTE > 25
```

<div class="dica">💡 <code>NULL</code> não é igual a nada — nem a <code>NULL</code>. Teste sempre com <code>IS NULL</code> / <code>IS NOT NULL</code>.</div>

---

## LIKE — padrões de texto

- `%` → qualquer sequência de caracteres · `_` → **um** caractere

```sql
WHERE NOME_ALUNO LIKE '%ANTONIO%'      -- contém ANTONIO
WHERE UPPER(NOME_PRODUTO) LIKE 'MA______'  -- MA + 6 caracteres
WHERE UPPER(NOME_PRODUTO) LIKE '__ACA%'    -- 'ACA' na 3ª posição
WHERE UPPER(NOME_PRODUTO) LIKE '%A\_P%' ESCAPE '\'  -- '_' literal
```

<div class="dica">💡 Use <code>ESCAPE</code> quando precisar procurar os próprios caracteres <code>%</code> ou <code>_</code>.</div>

---

## ORDER BY e DISTINCT

```sql
-- valores únicos, ordenados
SELECT DISTINCT CIDADE, UF, CEP
  FROM CLIENTES
 ORDER BY UF;

-- ordenação decrescente pelo alias
SELECT NOME_CLIENTE, SUM(VALOR_TOTAL) AS TOTAL
  FROM ...
 ORDER BY TOTAL DESC;
```

`DISTINCT` remove linhas repetidas; `ORDER BY` ordena (`ASC` padrão, `DESC` inverte).

---

## JOIN — combinando tabelas

```sql
-- INNER JOIN: só o que casa dos dois lados
SELECT A.NOME_ALUNO, T.TELEFONE
  FROM ALUNOS A
  INNER JOIN TELEFONES_ALUNOS T
    ON A.MATRICULA_ALUNO = T.MATRICULA_ALUNO;

-- LEFT OUTER JOIN: produtos que nunca foram pedidos
SELECT PRO.*
  FROM PRODUTOS PRO
  LEFT OUTER JOIN ITENS_PEDIDOS ITE
    ON PRO.CODIGO_PRODUTO = ITE.CODIGO_PRODUTO
 WHERE ITE.CODIGO_PRODUTO IS NULL;
```

---

## Funções de agregação

```sql
SELECT MIN(VALOR_TOTAL) AS MINIMO,
       MAX(VALOR_TOTAL) AS MAXIMO,
       SUM(VALOR_TOTAL) AS TOTAL,
       ROUND(AVG(VALOR_TOTAL), 2) AS MEDIA,
       COUNT(1) AS QTDE
  FROM PEDIDOS;
```

`COUNT`, `SUM`, `MIN`, `MAX`, `AVG` **resumem** um conjunto de linhas em um valor.

---

## GROUP BY e HAVING

```sql
SELECT CLI.CODIGO_CLIENTE,
       ROUND(AVG(PED.VALOR_TOTAL),2) AS MEDIA_POR_CLIENTE
  FROM CLIENTES CLI
  INNER JOIN PEDIDOS PED
    ON CLI.CODIGO_CLIENTE = PED.CODIGO_CLIENTE
 GROUP BY CLI.CODIGO_CLIENTE
 HAVING ROUND(AVG(PED.VALOR_TOTAL),2) > 8000
 ORDER BY MEDIA_POR_CLIENTE;
```

- **`GROUP BY`** agrupa as linhas antes de agregar.
- **`HAVING`** filtra **grupos** (o `WHERE` filtra **linhas**, antes do agrupamento).

---

## Subconsultas

```sql
-- escalar: comparar com a média geral
SELECT NOME_PRODUTO, PRECO_PRODUTO
  FROM PRODUTOS
 WHERE PRECO_PRODUTO > (SELECT AVG(PRECO_PRODUTO) FROM PRODUTOS);

-- diferença de conjuntos com IN / NOT IN
SELECT CLI.*
  FROM CLIENTES CLI
 WHERE CLI.CODIGO_CLIENTE IN     (SELECT CODIGO_CLIENTE FROM PEDIDOS WHERE DATA_PEDIDO = ...)
   AND CLI.CODIGO_CLIENTE NOT IN (SELECT CODIGO_CLIENTE FROM PEDIDOS WHERE DATA_PEDIDO = ...);
```

<div class="dica">💡 Uma subconsulta pode devolver um <strong>valor</strong> (escalar), uma <strong>lista</strong> (<code>IN</code>) ou existir/não existir (<code>EXISTS</code>).</div>

---

## Portabilidade entre SGBDs

| Recurso | Oracle | PostgreSQL | MySQL |
|---|---|---|---|
| Texto | `VARCHAR2` | `VARCHAR` | `VARCHAR` |
| Data literal | `TO_DATE('..','DD/MM/YYYY')` | `DATE '2026-01-01'` | `STR_TO_DATE` / `'2026-01-01'` |
| Data/hora atual | `SYSDATE` | `NOW()` | `NOW()` |
| Autoincremento | `SEQUENCE` | `SERIAL` | `AUTO_INCREMENT` |
| Trata `NULL` | `NVL(x,y)` | `COALESCE(x,y)` | `IFNULL` / `COALESCE` |
| Limitar linhas | `FETCH FIRST n ROWS` | `LIMIT n` | `LIMIT n` |

---

## Para praticar

- Você vai exercitar DDL, DML e DQL no **Roteiro Prático de SQL**, em partes:
  - **Parte 1** — DDL (montar o esquema acadêmico)
  - **Parte 2** — DML (insert/update/delete + consultas)
  - **Parte 3** — DQL avançado (domínio de vendas)

<div class="vm">🖥️ O roteiro é trabalhado <strong>em aula</strong>, na <strong>VM LabDatabase</strong>. O enunciado é disponibilizado pelo professor no AVA.</div>

---

## Bibliografia

- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.
- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Elsevier, 2004.
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. **Sistema de Banco de Dados.** 7ª ed. Elsevier, 2020.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="procedimentos-armazenados.html">Próximo →<small>Procedimentos Armazenados</small></a>
