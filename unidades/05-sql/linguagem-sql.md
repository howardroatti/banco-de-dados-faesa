---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Linguagem SQL
## DDL, DML e DQL — seguindo o Roteiro Prático

**Unidade 5** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

Esta aula **explica a sintaxe da SQL**, organizada como o **Roteiro Prático** — depois você **pratica no próprio roteiro**:

- **Parte 1 — DDL:** montar e evoluir a estrutura (tabelas, colunas, índices, views, chaves).
- **Parte 2 — DML:** inserir, atualizar e apagar dados.
- **Parte 3 — DQL:** consultar com `SELECT`, em **6 fases** que sobem de nível.

<div class="vm">🖥️ Foco na <strong>sintaxe</strong> (Oracle); os <strong>exercícios</strong> você faz no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a>, na <strong>VM LabDatabase</strong>. Ao final, a tabela de portabilidade entre SGBDs.</div>

---

## O domínio do roteiro

<div class="cols">
<div>

**Partes 1 e 2 — Acadêmico**
- `ALUNOS`, `PROFESSORES`, `DISCIPLINAS`
- `OFERTAS` (disciplina + professor + horário)
- `ALUNOS_OFERTAS` (matrícula — M:N)
- `TELEFONES_ALUNOS` (1:N)

</div>
<div>

**Parte 3 — Vendas**
- `CLIENTES`, `PRODUTOS`, `UNIDADE_MEDIDA`, `UF`
- `PEDIDOS`, `ITENS_PEDIDOS`

</div>
</div>

<div class="dica">💡 O roteiro troca de domínio na Parte 3 (vendas) para praticar <strong>consultas mais ricas</strong> — mais junções e subconsultas.</div>

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

# Parte 1 · DDL
### Montar e evoluir a estrutura

---

## Passo 0 — deixar o script reexecutável

O roteiro **abre apagando tudo** (na ordem inversa das dependências), para você poder **rodar de novo** sem erro:

```sql
-- 1) tira as FKs   2) tira índices   3) tira tabelas   4) views e sequences
ALTER TABLE ALUNOS_OFERTAS DROP CONSTRAINT ALUNOS_OFERTA_FK;
DROP INDEX  ALUNOS_NOME_IDX;
DROP TABLE  ALUNOS_OFERTAS;
DROP VIEW   ALUNOS_MATRICULADOS;
DROP SEQUENCE DISCIPLINAS_SEQ;
```

<div class="aviso">⚠️ A ordem importa: não dá para apagar <code>ALUNOS</code> enquanto houver uma FK apontando para ela. Primeiro as <strong>constraints</strong>, depois as <strong>tabelas</strong>.</div>

---

## Passo 1 — CREATE TABLE (tabelas "cruas")

Primeiro as tabelas com as colunas essenciais — **sem chaves ainda**:

```sql
CREATE TABLE ALUNOS (
    MATRICULA        NUMERIC       NOT NULL,
    NOME             VARCHAR2(100) NOT NULL,
    DATA_NASCIMENTO  DATE          NOT NULL
);

CREATE TABLE DISCIPLINAS (
    CODIGO_DISCIPLINA   NUMERIC        NOT NULL,
    NOME_DISCIPLINA     VARCHAR2(100)  NOT NULL,
    CARGA_HORARIA       NUMERIC(3)     NOT NULL,
    EMENTA              VARCHAR2(4000) NOT NULL,
    CODIGO_DISCIPLINA_DEPENDENCIA NUMERIC        -- auto-relacionamento
);
```

<div class="dica">💡 <code>NOT NULL</code> é uma <strong>restrição</strong>: o campo é obrigatório. As <strong>chaves</strong> (PK/FK) o roteiro adiciona <strong>no fim</strong>, com <code>ALTER</code>.</div>

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

## Passo 2 — ALTER TABLE: evoluir as colunas

Raramente a tabela nasce perfeita. O roteiro usa o **ALTER** para **adicionar, modificar e renomear**:

```sql
-- adicionar / modificar
ALTER TABLE ALUNOS  ADD    EMAIL VARCHAR2(200);
ALTER TABLE ALUNOS  MODIFY EMAIL VARCHAR2(250);
ALTER TABLE OFERTAS MODIFY DATA_CRIACAO DATE DEFAULT SYSDATE NOT NULL;

-- renomear tabela e colunas (padronizar os nomes)
ALTER TABLE TELEFONES RENAME TO TELEFONES_ALUNOS;
ALTER TABLE ALUNOS RENAME COLUMN MATRICULA TO MATRICULA_ALUNO;
ALTER TABLE ALUNOS RENAME COLUMN NOME      TO NOME_ALUNO;
```

<div class="aviso">⚠️ Mais adiante o roteiro faz <code>ALTER TABLE ALUNOS DROP COLUMN EMAIL;</code> — o <code>DROP COLUMN</code> apaga os dados da coluna e é irreversível sem backup.</div>

---

## Passo 3 — Sequences e Índices

```sql
-- sequência: gerar códigos automáticos (Oracle)
CREATE SEQUENCE DISCIPLINAS_SEQ;
-- ... depois: INSERT INTO DISCIPLINAS VALUES (DISCIPLINAS_SEQ.NEXTVAL, ...);

-- índices: acelerar buscas frequentes por nome/dia
CREATE INDEX ALUNOS_NOME_IDX      ON ALUNOS (NOME_ALUNO);
CREATE INDEX OFERTAS_DIA_IDX      ON OFERTAS (DIA_SEMANA);
CREATE INDEX DISCIPLINA_NOME_IDX  ON DISCIPLINAS (NOME_DISCIPLINA);
```

<div class="dica">💡 Em PostgreSQL/MySQL o autoincremento vem de <code>SERIAL</code> / <code>AUTO_INCREMENT</code>, em vez de <em>sequence</em> explícita.</div>

---

## Passo 4 — Views: consultas com nome

```sql
CREATE VIEW ALUNOS_MATRICULADOS AS
  SELECT A.MATRICULA_ALUNO, A.NOME_ALUNO AS ALUNO, AO.SEMESTRE,
         O.DIA_SEMANA, P.NOME_PROFESSOR AS PROFESSOR, D.NOME_DISCIPLINA
    FROM ALUNOS_OFERTAS AO
    INNER JOIN ALUNOS      A ON AO.MATRICULA_ALUNO   = A.MATRICULA_ALUNO
    INNER JOIN OFERTAS     O ON AO.CODIGO_OFERTA     = O.CODIGO_OFERTA
    INNER JOIN PROFESSORES P ON O.MATRICULA_PROFESSOR = P.MATRICULA_PROFESSOR
    INNER JOIN DISCIPLINAS D ON O.CODIGO_DISCIPLINA   = D.CODIGO_DISCIPLINA;
```

Depois é só `SELECT * FROM ALUNOS_MATRICULADOS;` — a complexidade fica **escondida** atrás do nome.

---

## Passo 5 — Chaves por último: PK e FK

Com as tabelas prontas, o roteiro **fecha a integridade**:

```sql
-- chaves primárias (simples e composta)
ALTER TABLE ALUNOS         ADD PRIMARY KEY (MATRICULA_ALUNO);
ALTER TABLE ALUNOS_OFERTAS ADD PRIMARY KEY (MATRICULA_ALUNO, CODIGO_OFERTA);

-- chaves estrangeiras (constraint nomeada)
ALTER TABLE OFERTAS
  ADD CONSTRAINT OFERTAS_PROFESSOR_FK
      FOREIGN KEY (MATRICULA_PROFESSOR)
      REFERENCES PROFESSORES (MATRICULA_PROFESSOR);
```

<div class="dica">💡 <strong>Por que no fim?</strong> Uma FK só pode ser criada quando a tabela referenciada <strong>e sua PK</strong> já existem. Por isso a ordem do roteiro: tabelas → PKs → FKs.</div>

---

<!-- _class: secao -->

# Parte 2 · DML
### Inserir, atualizar e apagar

---

## INSERT

```sql
-- forma posicional
INSERT INTO ALUNOS
VALUES (40001, 'JOÃO GABRIEL', TO_DATE('02/04/1985','DD/MM/YYYY'));

-- forma explícita (recomendada): lista as colunas
INSERT INTO ALUNOS (MATRICULA_ALUNO, NOME_ALUNO, DATA_NASCIMENTO)
VALUES (40002, 'JOÃO JOSÉ', TO_DATE('31/12/2001','DD/MM/YYYY'));
```

<div class="dica">💡 Listar as colunas deixa o comando <strong>imune</strong> a mudanças na ordem/quantidade de colunas da tabela.</div>

---

## INSERT ALL (Oracle) — várias linhas

```sql
-- um único comando insere várias linhas na MESMA tabela
INSERT ALL
  INTO ALUNOS VALUES (40011, 'ANA LÚCIA',  TO_DATE('10/03/2000','DD/MM/YYYY'))
  INTO ALUNOS VALUES (40012, 'BRUNO DIAS', TO_DATE('22/08/1999','DD/MM/YYYY'))
  INTO ALUNOS VALUES (40013, 'CARLA MOTA', TO_DATE('05/01/2001','DD/MM/YYYY'))
SELECT * FROM DUAL;
```

<div class="dica">💡 Uma transação para <strong>N inserções</strong> — ótimo para <strong>carga de dados</strong>. Com valores literais, fecha com a subconsulta <code>SELECT * FROM DUAL</code>.</div>

---

## INSERT ALL — condicional (várias tabelas)

```sql
-- lê a consulta UMA vez e distribui as linhas por destino
INSERT ALL
  WHEN CARGA_HORARIA >= 60 THEN INTO DISCIPLINAS_LONGAS (CODIGO, NOME)
  WHEN CARGA_HORARIA <  60 THEN INTO DISCIPLINAS_CURTAS (CODIGO, NOME)
SELECT CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA
  FROM DISCIPLINAS;
```

<div class="dica">💡 <code>INSERT FIRST</code> para na 1ª condição verdadeira; <code>INSERT ALL</code> grava em <strong>todas</strong>.</div>

<div class="aviso">⚠️ Recurso <strong>específico do Oracle</strong> — ver a portabilidade no fim da aula.</div>

---

## UPDATE

```sql
-- SEMPRE com WHERE! (senão altera a tabela inteira)
UPDATE ALUNOS
   SET DATA_NASCIMENTO = TO_DATE('29/04/2011','DD/MM/YYYY')
 WHERE MATRICULA_ALUNO = 40004;

-- atualização por conjunto
UPDATE PROFESSORES
   SET FORMACAO = 'PHD'
 WHERE FORMACAO = 'DOUTORADO';
```

<div class="aviso">⚠️ Um <code>UPDATE</code> sem <code>WHERE</code> altera <strong>todas</strong> as linhas. Confira o filtro com um <code>SELECT</code> antes.</div>

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

<div class="dica">💡 Um <code>DELETE</code> só vira <strong>definitivo</strong> ao confirmar a transação (<code>COMMIT</code>) — desfazer/confirmar é assunto da <strong>Unidade 6</strong>.</div>

---

<!-- _class: secao -->

# Parte 3 · DQL
### `SELECT` em 6 fases (domínio de vendas)

---

## Fase 1 — projeção, DISTINCT e ORDER BY

```sql
-- todas as colunas × só as que interessam
SELECT PRO.NOME_PRODUTO FROM PRODUTOS PRO;

-- valores únicos, ordenados
SELECT DISTINCT CLI.CIDADE, CLI.UF, CLI.CEP
  FROM CLIENTES CLI
 ORDER BY CLI.UF;
```

- **Projeção**: escolher **colunas** (em vez de `SELECT *`).
- **`DISTINCT`** remove linhas repetidas; **`ORDER BY`** ordena (`ASC` padrão, `DESC` inverte).

---

## Fase 1 — filtros: comparação, faixa, lista, texto

```sql
SELECT PED.* FROM PEDIDOS PED
 WHERE PED.CODIGO_CLIENTE = 4 AND PED.VALOR_LIQUIDO > 10000;

SELECT PED.* FROM PEDIDOS PED
 WHERE PED.VALOR_TOTAL NOT BETWEEN 100 AND 5000;          -- faixa

SELECT CLI.* FROM CLIENTES CLI WHERE CLI.UF IN ('ES','MG'); -- lista

SELECT PRO.* FROM PRODUTOS PRO
 WHERE UPPER(PRO.NOME_PRODUTO) LIKE 'MA______';           -- MA + 6 chars
```

<div class="dica">💡 No <code>LIKE</code>: <code>%</code> = qualquer sequência · <code>_</code> = um caractere. Use <code>... LIKE '%A\_P%' ESCAPE '\'</code> para procurar o <code>_</code> literal. E teste ausência com <code>IS NULL</code> (nunca <code>= NULL</code>).</div>

---

## Fase 1 — outro exemplo (`OR` e `NOT IN`)

```sql
-- fora de uma faixa de códigos
SELECT CLI.* FROM CLIENTES CLI
 WHERE CLI.CODIGO_CLIENTE < 5 OR CLI.CODIGO_CLIENTE > 25;

-- excluir alguns estados
SELECT CLI.* FROM CLIENTES CLI
 WHERE CLI.UF NOT IN ('RJ','SP');
```

<div class="dica">💡 <code>OR</code> combina condições (basta uma ser verdadeira); <code>NOT IN</code> nega a lista.</div>

<div class="vm">🖥️ <strong>Pratique a Fase 1</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Fase 2 — junções (INNER JOIN)

```sql
SELECT PED.CODIGO_PEDIDO, CLI.NOME_CLIENTE,
       PRO.NOME_PRODUTO, UE.DESCRICAO_UNIDADE_MEDIDA
  FROM PEDIDOS PED
  INNER JOIN CLIENTES      CLI ON PED.CODIGO_CLIENTE = CLI.CODIGO_CLIENTE
  INNER JOIN ITENS_PEDIDOS ITE ON PED.CODIGO_PEDIDO  = ITE.CODIGO_PEDIDO
  INNER JOIN PRODUTOS      PRO ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
  INNER JOIN UNIDADE_MEDIDA UE ON PRO.CODIGO_UNIDADE_MEDIDA = UE.CODIGO_UNIDADE_MEDIDA;
```

<div class="dica">💡 Cada <code>JOIN ... ON</code> costura duas tabelas pela chave. Dá para renomear a saída com alias (<code>AS "PREÇO DO PRODUTO"</code>) e até criar <strong>colunas calculadas</strong> (<code>PRECO_PRODUTO * 1.3</code>).</div>

---

## Fase 2 — outro exemplo (alias, coluna calculada, subconsulta)

```sql
SELECT PRO.NOME_PRODUTO  AS "NOME DO PRODUTO",
       PRO.PRECO_PRODUTO AS "PREÇO ATUAL",
       (PRO.PRECO_PRODUTO * 1.3) AS "PREÇO PROJETADO"
  FROM PRODUTOS PRO
 WHERE PRO.CODIGO_PRODUTO IN (SELECT ITE.CODIGO_PRODUTO FROM ITENS_PEDIDOS ITE);
```

<div class="dica">💡 Alias entre aspas aceita <strong>acentos e espaços</strong>; dá para calcular colunas na hora (<code>* 1.3</code>) e filtrar por uma <strong>subconsulta</strong> (só produtos que já foram pedidos).</div>

<div class="vm">🖥️ <strong>Pratique a Fase 2</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Fase 3 — agregação, GROUP BY e HAVING

```sql
SELECT MIN(VALOR_TOTAL) AS MINIMO, MAX(VALOR_TOTAL) AS MAXIMO,
       SUM(VALOR_TOTAL) AS TOTAL, ROUND(AVG(VALOR_TOTAL),2) AS MEDIA,
       COUNT(1) AS QTDE
  FROM PEDIDOS;

SELECT CLI.CODIGO_CLIENTE, ROUND(AVG(PED.VALOR_TOTAL),2) AS MEDIA_POR_CLIENTE
  FROM CLIENTES CLI
  INNER JOIN PEDIDOS PED ON CLI.CODIGO_CLIENTE = PED.CODIGO_CLIENTE
 GROUP BY CLI.CODIGO_CLIENTE
 HAVING ROUND(AVG(PED.VALOR_TOTAL),2) > 8000;
```

- **`GROUP BY`** agrupa antes de agregar; **`HAVING`** filtra **grupos** (o `WHERE` filtra **linhas**, antes).

---

## Fase 3 — LEFT JOIN e subconsulta escalar

```sql
-- produtos que NUNCA foram pedidos (o que existe de um lado e não do outro)
SELECT PRO.*
  FROM PRODUTOS PRO
  LEFT OUTER JOIN ITENS_PEDIDOS ITE ON PRO.CODIGO_PRODUTO = ITE.CODIGO_PRODUTO
 WHERE ITE.CODIGO_PRODUTO IS NULL;

-- produtos acima da média geral de preço (subconsulta escalar)
SELECT PRO.NOME_PRODUTO, PRO.PRECO_PRODUTO
  FROM PRODUTOS PRO
 WHERE PRO.PRECO_PRODUTO > (SELECT AVG(PRECO_PRODUTO) FROM PRODUTOS);
```

---

## Fase 3 — outro exemplo (`COUNT` por grupo)

```sql
-- quantos clientes (que já pediram) cada UF tem
SELECT CLI.UF, COUNT(CLI.CODIGO_CLIENTE) AS QUANTIDADE_CLIENTES
  FROM CLIENTES CLI
 WHERE CLI.CODIGO_CLIENTE IN (SELECT PED.CODIGO_CLIENTE FROM PEDIDOS PED)
 GROUP BY CLI.UF
 ORDER BY QUANTIDADE_CLIENTES DESC;
```

<div class="dica">💡 O <code>WHERE</code> filtra as <strong>linhas</strong> antes; o <code>GROUP BY</code> forma os grupos; a agregação (<code>COUNT</code>) resume cada grupo; o <code>ORDER BY</code> ordena pelo resultado.</div>

<div class="vm">🖥️ <strong>Pratique a Fase 3</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Fase 4 — subconsultas de conjunto (`IN` / `NOT IN`)

```sql
-- clientes que pediram no dia 13 MAS não no dia 02
SELECT CLI.*
  FROM CLIENTES CLI
 WHERE CLI.CODIGO_CLIENTE IN     (SELECT PED.CODIGO_CLIENTE FROM PEDIDOS PED
                                   WHERE PED.DATA_PEDIDO = TO_DATE('13/01/2007','DD/MM/YYYY'))
   AND CLI.CODIGO_CLIENTE NOT IN (SELECT PED.CODIGO_CLIENTE FROM PEDIDOS PED
                                   WHERE PED.DATA_PEDIDO = TO_DATE('02/01/2007','DD/MM/YYYY'));
```

<div class="dica">💡 <code>IN</code> + <code>NOT IN</code> juntos expressam <strong>diferença de conjuntos</strong> ("está em A e não em B"). A subconsulta pode ainda ter seus próprios <code>JOIN</code>s.</div>

---

## Fase 4 — outro exemplo (subconsulta com junções)

```sql
-- produtos NUNCA pedidos por clientes do RJ
SELECT PRO.* FROM PRODUTOS PRO
 WHERE PRO.CODIGO_PRODUTO NOT IN (
   SELECT ITE.CODIGO_PRODUTO
     FROM ITENS_PEDIDOS ITE
     INNER JOIN PEDIDOS  PED ON ITE.CODIGO_PEDIDO  = PED.CODIGO_PEDIDO
     INNER JOIN CLIENTES CLI ON CLI.CODIGO_CLIENTE = PED.CODIGO_CLIENTE
    WHERE CLI.UF = 'RJ');
```

<div class="dica">💡 A subconsulta pode ter os seus próprios <code>JOIN</code>s e <code>WHERE</code> — ela monta a lista de "produtos pedidos por clientes do RJ", e o <code>NOT IN</code> pega o <strong>complemento</strong>.</div>

<div class="vm">🖥️ <strong>Pratique a Fase 4</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Fase 5 — outer joins encadeados e NULLS

```sql
-- total por produto, incluindo os que não venderam (total NULL primeiro)
SELECT PRO.CODIGO_PRODUTO, PRO.NOME_PRODUTO, PRO.PRECO_PRODUTO,
       SUM(PED.VALOR_TOTAL) AS TOTAL_POR_PRODUTO
  FROM PRODUTOS PRO
  LEFT JOIN ITENS_PEDIDOS ITE ON PRO.CODIGO_PRODUTO = ITE.CODIGO_PRODUTO
  LEFT JOIN PEDIDOS       PED ON ITE.CODIGO_PEDIDO  = PED.CODIGO_PEDIDO
 GROUP BY PRO.CODIGO_PRODUTO, PRO.NOME_PRODUTO, PRO.PRECO_PRODUTO
 ORDER BY TOTAL_POR_PRODUTO NULLS FIRST;
```

<div class="dica">💡 Encadear <code>LEFT JOIN</code> preserva os produtos mesmo sem item/pedido; <code>NULLS FIRST</code>/<code>NULLS LAST</code> controlam onde os nulos aparecem na ordenação.</div>

---

## Fase 5 — outro exemplo (LEFT JOIN encadeado)

```sql
-- todos os clientes e, se houver, os produtos que compraram
SELECT CLI.NOME_CLIENTE, PRO.NOME_PRODUTO
  FROM CLIENTES CLI
  LEFT JOIN PEDIDOS       PED ON CLI.CODIGO_CLIENTE = PED.CODIGO_CLIENTE
  LEFT JOIN ITENS_PEDIDOS ITE ON PED.CODIGO_PEDIDO  = ITE.CODIGO_PEDIDO
  LEFT JOIN PRODUTOS      PRO ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
 ORDER BY CLI.NOME_CLIENTE;
```

<div class="dica">💡 A <strong>cadeia</strong> de <code>LEFT JOIN</code> preserva o cliente em cada passo — quem não comprou aparece com <code>NULL</code> no produto, em vez de sumir do resultado.</div>

<div class="vm">🖥️ <strong>Pratique a Fase 5</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Fase 6 — subconsulta no `SELECT`/`HAVING` e views

```sql
-- comparar o total de um produto com um valor calculado por subconsulta
SELECT PRO.NOME_PRODUTO, SUM(PED.VALOR_TOTAL) AS TOTAL_VENDIDO
  FROM PRODUTOS PRO
  INNER JOIN ITENS_PEDIDOS ITE ON ITE.CODIGO_PRODUTO = PRO.CODIGO_PRODUTO
  INNER JOIN PEDIDOS       PED ON ITE.CODIGO_PEDIDO  = PED.CODIGO_PEDIDO
 GROUP BY PRO.NOME_PRODUTO
 HAVING SUM(PED.VALOR_TOTAL) > (SELECT SUM(PED.VALOR_TOTAL) FROM ...);  -- ex.: total do 'SAL'

-- guardar uma consulta pronta como VIEW
CREATE OR REPLACE VIEW PRODUTOS_MEDIDAS AS
  SELECT PRO.NOME_PRODUTO, UE.DESCRICAO_UNIDADE_MEDIDA
    FROM PRODUTOS PRO
    INNER JOIN UNIDADE_MEDIDA UE ON PRO.CODIGO_UNIDADE_MEDIDA = UE.CODIGO_UNIDADE_MEDIDA;
```

<div class="dica">💡 O fecho do roteiro: consultas que usam o resultado de <strong>outra consulta</strong> — e transformam as boas em <strong>views</strong> reutilizáveis.</div>

---

## Fase 6 — outro exemplo (VIEW a partir de agregação)

```sql
CREATE OR REPLACE VIEW TOTAL_CLIENTE_VITORIA AS
  SELECT CLI.NOME_CLIENTE, SUM(PED.VALOR_TOTAL) AS TOTAL_POR_CLIENTE
    FROM CLIENTES CLI
    INNER JOIN PEDIDOS PED ON CLI.CODIGO_CLIENTE = PED.CODIGO_CLIENTE
   WHERE UPPER(CLI.CIDADE) = 'VITORIA'
   GROUP BY CLI.NOME_CLIENTE
   HAVING SUM(PED.VALOR_TOTAL) > (SELECT AVG(PED.VALOR_TOTAL) FROM ...);
```

<div class="dica">💡 Uma <strong>view</strong> pode encapsular uma consulta inteira — com <code>GROUP BY</code>, <code>HAVING</code> e até subconsulta. Depois, é só <code>SELECT * FROM TOTAL_CLIENTE_VITORIA;</code>.</div>

<div class="vm">🖥️ <strong>Pratique a Fase 6</strong> no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (Parte 3).</div>

---

## Portabilidade entre SGBDs

| Recurso | Oracle | PostgreSQL | MySQL |
|---|---|---|---|
| Texto | `VARCHAR2` | `VARCHAR` | `VARCHAR` |
| Data literal | `TO_DATE('..','DD/MM/YYYY')` | `DATE '2026-01-01'` | `'2026-01-01'` |
| Data/hora atual | `SYSDATE` | `NOW()` | `NOW()` |
| Autoincremento | `SEQUENCE` | `SERIAL` | `AUTO_INCREMENT` |
| Trata `NULL` | `NVL(x,y)` | `COALESCE(x,y)` | `IFNULL` / `COALESCE` |
| Limitar linhas | `FETCH FIRST n ROWS` | `LIMIT n` | `LIMIT n` |
| Inserção em massa | `INSERT ALL` / `INSERT FIRST` | `INSERT … VALUES (…),(…)` | `INSERT … VALUES (…),(…)` |

---

## Para praticar — o Roteiro Prático de SQL

Você executa tudo na VM, na mesma ordem desta aula:

- **Parte 1 — DDL:** montar o esquema acadêmico (create → alter → índices → views → PK/FK).
- **Parte 2 — DML:** insert/update/delete e consultas básicas.
- **Parte 3 — DQL:** as **6 fases** de `SELECT` (vendas), da projeção às subconsultas e views.

<div class="vm">🖥️ Esta aula explica a <strong>sintaxe</strong>; os <strong>exercícios</strong> estão no <a href="roteiro-pratico/Roteiro-Pratico-SQL.pdf">Roteiro Prático de SQL</a> (PDF) — com os <strong>scripts <code>.sql</code></strong> por parte e os <strong>dados para inserir</strong> (também no <strong>Sumário → Unidade 5</strong>). Trabalhado <strong>em aula</strong>, na <strong>VM LabDatabase</strong>.</div>

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
