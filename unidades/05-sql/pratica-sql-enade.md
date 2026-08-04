---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Prática — Questões estilo ENADE

## SQL e modelagem (múltipla escolha)

**Unidade 5** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Como usar

- São **5 questões** no formato ENADE (caso → pergunta → 5 alternativas).
- Tente responder **antes** de avançar para o slide da resposta.
- Cobrem **SQL** (agregação, DDL, LIKE) e **modelagem** (integridade referencial, M:N).

<div class="dica">💡 Ótimo para revisão e para treinar o estilo de questão do ENADE.</div>

---

## Q1 — Média com filtro

**Contexto:** tabela `Clientes(ID, Nome, Idade)`. Quer a **média de idade** dos clientes com **mais de 30 anos**.

a) `SELECT AVG(Idade) FROM Clientes WHERE Idade > 30;`
b) `SELECT AVG(Idade) FROM Clientes HAVING Idade > 30;`
c) `... WHERE Idade > 30 GROUP BY Idade;`
d) `... WHERE Idade > 30 GROUP BY Nome;`
e) `... HAVING Idade > 30;`

---

## Q1 — Resposta: **a)**

`SELECT AVG(Idade) FROM Clientes WHERE Idade > 30;`

- O filtro é sobre **linhas** → usa-se **`WHERE`** (não `HAVING`, que filtra **grupos**).
- Não há agrupamento → **sem `GROUP BY`**. As opções com `GROUP BY` mudam o resultado; as com `HAVING` sem `GROUP BY` são inválidas/incorretas.

---

## Q2 — CREATE TABLE no Oracle

**Contexto:** criar `Produtos(ID, Nome, Preço, Quantidade)` no **Oracle**, com `ID` como **PK**.

a) `CREATE TABLE Produtos (ID NUMBER PRIMARY KEY, Nome VARCHAR2(50), Preço NUMBER, Quantidade NUMBER);`
b) `... (ID PRIMARY KEY, Nome VARCHAR(50), Preço DECIMAL, ...);`
c) `... (ID INT PRIMARY KEY, Nome VARCHAR(50), Preço FLOAT, ...);`
d) `... (ID INT PRIMARY KEY, Nome VARCHAR2(50), Preço FLOAT, ...);`
e) `... (ID INT, ..., PRIMARY KEY(ID));`

---

## Q2 — Resposta: **a)**

`... (ID NUMBER PRIMARY KEY, Nome VARCHAR2(50), Preço NUMBER, Quantidade NUMBER);`

- No **Oracle**, os tipos idiomáticos são **`NUMBER`** e **`VARCHAR2`** (não `INT`/`VARCHAR`/`DECIMAL`/`FLOAT`).
- `ID NUMBER PRIMARY KEY` define a chave primária **inline** corretamente.

<div class="dica">💡 Cada SGBD tem seus tipos — portabilidade é tema recorrente (ver deck de Linguagem SQL).</div>

---

## Q3 — Modelagem: e-commerce

**Contexto:** produtos, clientes e **pedidos**; cada pedido pode conter **vários produtos**. Qual modelagem respeita a **integridade referencial**?

a) Tabelas de produtos, clientes e pedidos, relacionadas por **chaves estrangeiras**.
b) Uma tabela de produtos com campos de clientes/pedidos (sem relacionamentos).
c) Uma **única** tabela desnormalizada.
d) Tabelas separadas **sem** relacionamentos.
e) Pedidos com produtos/clientes em **listas separadas por vírgula**.

---

## Q3 — Resposta: **a)**

Tabelas separadas + **chaves estrangeiras**.

- É o que garante **integridade referencial** e evita redundância/anomalias.
- O "cada pedido com vários produtos" (**M:N**) pede ainda uma **tabela associativa** de itens do pedido.
- As demais opções desnormalizam ou quebram os relacionamentos.

---

## Q4 — Modelagem: alunos × disciplinas

**Contexto:** alunos e disciplinas, com a necessidade de **registrar as matrículas** dos alunos nas disciplinas.

a) Tabelas de alunos, de disciplinas e de **matrículas**, ligadas por **FKs**.
b) Tabela única desnormalizada.
c) Alunos com campos adicionais de disciplinas.
d) Tabelas separadas sem relacionamentos.
e) Disciplinas com alunos/matrículas em listas por vírgula.

---

## Q4 — Resposta: **a)**

Alunos + Disciplinas + **Matrículas** (associativa) com FKs.

- Aluno×Disciplina é um **M:N** → resolve-se com uma **tabela associativa** (matrículas), que ainda guarda dados da matrícula (semestre, nota…).
- É o mesmo padrão da Q3 — o **M:N com entidade associativa** é um clássico do ENADE.

---

## Q5 — Buscar por palavra-chave

**Contexto:** buscar livros cujo **título contenha** uma palavra-chave.

a) `WHERE Título = 'palavra-chave';`
b) `WHERE Título LIKE '%palavra-chave%';`
c) `WHERE Título = '%palavra-chave%';`
d) `WHERE Título LIKE 'palavra-chave%';`
e) `WHERE Título LIKE '%palavra-chave';`

---

## Q5 — Resposta: **b)**

`WHERE Título LIKE '%palavra-chave%';`

- **`LIKE`** com **`%`** dos dois lados = "**contém**" a palavra em qualquer posição.
- `=` exige igualdade exata; `'%...%'` com `=` não funciona; `'palavra%'` só casa no **início** e `'%palavra'` só no **fim**.

---

<!-- _class: secao -->

# Fim da prática
### Confira também o Roteiro Prático (na VM) e o deck de Linguagem SQL.

<a class="proximo" href="../../index.html">↩ Voltar ao índice<small>todas as unidades</small></a>
