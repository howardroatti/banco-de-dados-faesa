---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Visões, Linguagem SQL e Indexação

**Unidade 3** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- **Visões (Views)** — o que são, objetivos e limites
- A **Linguagem SQL** — história e os grupos **DDL, DML, DQL, DCL**
- **Indexação** — índices ordenados (esparso/denso) e hash

---

<!-- _class: secao -->

# Visões (Views)

---

## O que é uma View

- Uma **tabela virtual** definida por uma **consulta** — não armazena dados próprios (salvo *materialized views*).
- Formas diferentes de **visualizar** o mesmo conjunto de dados.

**Objetivos:**
- **Segurança** — expor só colunas/linhas permitidas.
- **Simplificação** — esconder consultas complexas atrás de um nome.
- **Reúso** — "armazenar" consultas complexas.

---

## Definindo Views

```sql
CREATE VIEW alunos_matriculados AS
SELECT a.matricula, a.nome, o.disciplina
  FROM alunos a
  JOIN alunos_ofertas ao ON ao.aluno  = a.matricula
  JOIN ofertas        o  ON o.codigo   = ao.oferta;
```

Operações comuns na definição: `WHERE` (filtrar linhas), escolher **colunas**, `GROUP BY` (sumarizar), `JOIN` (múltiplas tabelas).

---

## Views atualizáveis

Uma view é **atualizável** (aceita `INSERT/UPDATE/DELETE`) quando, em geral:

- Deriva de **uma única** tabela/consulta;
- Inclui as **chaves primárias** e as colunas **não nulas** obrigatórias;
- **Não** usa `DISTINCT`, `GROUP BY`, agregações ou remove duplicatas.

<div class="aviso">Views com junção/agregação normalmente são <strong>somente leitura</strong> — para alterar dados, use as tabelas base (ou <code>INSTEAD OF triggers</code>).</div>

---

<!-- _class: secao -->

# A Linguagem SQL

---

## História e padrões

- **SQL** (*Structured Query Language*): linguagem **declarativa** — você descreve **o que** quer, não **como** obter.
- Origem: **SEQUEL** (*Structured English Query Language*), IBM System R.
- Padrões **ANSI/ISO**: SQL-86, SQL-89, **SQL-92 (SQL2)**, SQL:1999, SQL:2003 … SQL:2016/2023.

<div class="dica">💡 Os SGBDs não implementam 100% do padrão e ainda acrescentam extensões próprias — daí as diferenças entre Oracle, PostgreSQL e MySQL.</div>

---

## Os quatro grupos da SQL

| Grupo | Para quê | Comandos |
|---|---|---|
| **DDL** — *Definition* | estrutura | `CREATE`, `ALTER`, `DROP` |
| **DML** — *Manipulation* | dados | `INSERT`, `UPDATE`, `DELETE` |
| **DQL** — *Query* | consulta | `SELECT` |
| **DCL** — *Control* | permissões | `GRANT`, `REVOKE` |

*(alguns autores incluem TCL — `COMMIT`, `ROLLBACK`, `SAVEPOINT`.)*

<div class="vm">🖥️ A prática completa de DDL/DML/DQL está no <strong>Roteiro Prático de SQL</strong> (Unidade 5), na VM.</div>

---

<!-- _class: secao -->

# Indexação

---

## Índices

> Estrutura **adicional** associada a uma tabela para **acelerar consultas** — como o índice remissivo de um livro.

- **Vantagem:** buscas muito mais rápidas (evita varredura completa).
- **Custo:** ocupa espaço e **torna escritas** (`INSERT/UPDATE/DELETE`) um pouco mais lentas (o índice também é mantido).

```sql
CREATE INDEX alunos_nome_idx ON alunos(nome);
```

---

## Índices Ordenados: esparso × denso

- **Denso:** uma entrada de índice para **cada** valor de chave da tabela.
- **Esparso:** uma entrada apenas para **alguns** valores (ex.: um por bloco) — menor, mas exige leitura sequencial a partir da entrada.

| Tipo | Entradas | Tamanho | Busca |
|---|---|---|---|
| Denso | todas as chaves | maior | direta |
| Esparso | algumas chaves | menor | aproxima + varre |

---

## Índices Hash

- Aplicam uma **função hash** à chave para localizar o registro em **tempo praticamente constante**.
- Ótimos para busca por **igualdade** (`= valor`); **ruins** para faixas (`BETWEEN`, `>`, `ORDER BY`).

<div class="dica">💡 Regra prática: indexe as colunas usadas em <code>WHERE</code>, <code>JOIN</code> e <code>ORDER BY</code> frequentes — mas não indexe tudo (custo de escrita).</div>

---

## Bibliografia

- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Elsevier, 2004.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. **Sistema de Banco de Dados.** 7ª ed. Elsevier, 2020.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="../04-modelagem/modelagem-conceitual.html">Próxima unidade →<small>Unidade 4 — Modelagem Conceitual (ER)</small></a>
