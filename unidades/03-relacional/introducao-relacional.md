---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Introdução ao Banco de Dados Relacional
## Fundamentos, as 12 regras de Codd e integridade

**Unidade 3** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- **Histórico** — E. F. Codd e o modelo relacional
- As **12 regras de Codd**
- **Esquema × Instância**
- Os **três aspectos**: estrutural, integridade e manipulador
- **Restrições de integridade** (chaves, entidade, referencial)
- O **Catálogo** (dicionário de dados)

---

<!-- _class: secao -->

# Histórico

---

## O Modelo Relacional

- Proposto por **Edgar F. Codd** (IBM, 1970), no artigo *"A Relational Model of Data for Large Shared Data Banks"*.
- Baseado em **teoria dos conjuntos** e **lógica de predicados**.
- Dados representados por **relações** (tabelas) — simples, formal e independente da implementação física.
- Na década de 1970 a IBM desenvolveu o protótipo **System R** e a linguagem **SEQUEL** (depois **SQL**).

> Regra fundamental: um SGBD relacional deve gerenciar o banco **inteiramente** por meio de suas capacidades relacionais.

---

## As 12 regras de Codd (1/3)

| # | Regra | Ideia |
|---|---|---|
| **1** | Informação | tudo é representado **como valores em tabelas** |
| **2** | Acesso garantido | todo dado é acessível por **tabela + PK + coluna** |
| **3** | Tratamento sistemático de nulos | **NULL** distinto de zero/vazio, tratado de forma uniforme |
| **4** | Catálogo dinâmico online | o **dicionário de dados** é relacional e consultável como dado |

---

## As 12 regras de Codd (2/3)

| # | Regra | Ideia |
|---|---|---|
| **5** | Sublinguagem abrangente | uma linguagem (SQL) para **definição, consulta, manipulação, integridade, transação e autorização** |
| **6** | Atualização de visões | **views** teoricamente atualizáveis devem ser atualizáveis |
| **7** | Inserção/atualização/exclusão de alto nível | operar sobre **conjuntos** de linhas, não uma a uma |
| **8** | Independência física | mudar o **armazenamento** não afeta a aplicação |

---

## As 12 regras de Codd (3/3)

| # | Regra | Ideia |
|---|---|---|
| **9** | Independência lógica | mudanças nas **tabelas** que preservam informação não quebram a aplicação |
| **10** | Independência de integridade | as **restrições** ficam no catálogo, não no código |
| **11** | Independência de distribuição | o banco pode ser **distribuído** sem afetar a aplicação |
| **12** | Não-subversão | se houver uma linguagem de baixo nível, ela **não pode burlar** as regras de integridade |

<div class="dica">💡 Nenhum SGBD comercial cumpre 100% das 12 regras — elas são o <strong>ideal</strong> que define "quão relacional" é um sistema.</div>

---

## Esquema × Instância

- **Esquema (projeto lógico):** define as tabelas — nome, colunas, tipos e **restrições de integridade**. Muda **raramente**.
- **Instância:** o **conjunto de valores** (as linhas) em um dado momento. Muda a **cada operação**.

```text
Esquema:   ALUNOS(matricula INT PK, nome VARCHAR, curso VARCHAR)
Instância: (101, 'Ana', 'CC'), (102, 'Bruno', 'SI'), ...
```

---

<!-- _class: secao -->

# Os três aspectos

---

## Estrutural · Integridade · Manipulador

Todo SGBD relacional pressupõe três aspectos:

- **Estrutural** — como os dados são organizados (**relações/tabelas**).
- **Integridade** — regras que garantem dados **válidos e consistentes**.
- **Manipulador** — como se **opera** sobre os dados (Álgebra Relacional / SQL — *próxima aula*).

---

## Aspecto Estrutural

| Conceito | Significado |
|---|---|
| **Domínio** | conjunto de valores válidos para um atributo |
| **Atributo** | uma coluna (com nome e domínio) |
| **Tupla** | uma linha (registro) |
| **Relação** | a tabela (conjunto de tuplas) |

<div class="dica">💡 No relacional, uma relação é um <strong>conjunto</strong>: não há ordem entre as tuplas nem tuplas duplicadas.</div>

---

## Aspecto de Integridade

Restrições sobre os valores que uma coluna/tabela pode receber. Três conjuntos:

1. **Baseadas em Modelo** — inerentes ao modelo relacional (ex.: não há ordenação de tuplas, não há duplicatas).
2. **Baseadas em Aplicação** — regras de negócio que **não** se expressam no esquema; ficam nos programas.
3. **Baseadas em Esquema** — expressas na **DDL** (chaves, integridade referencial etc.).

---

## Restrições de Chave

- Garantem que **não existam duas tuplas iguais** — princípios da **unicidade** e da **minimalidade**.
- **Chave Primária (PK)**: identifica unicamente cada tupla; **não admite nulos**.
- **Chave Candidata**: qualquer chave apta a ser PK. **Chave Alternativa**: candidata não escolhida como PK.

---

## Integridade de Entidade

- A existência de **chave** dá a cada tupla uma **identidade única**.
- **Não ter chave = não ter identidade.**
- Consequência: a **PK não pode ser nula** (nem parcialmente, se composta).

---

## Integridade Referencial

- Garante a **consistência das ligações** entre tabelas.
- **Chave Estrangeira (FK):** valores que devem existir como PK na tabela referenciada (ou ser nulos).

**Ações referenciais** ao excluir/alterar a linha referenciada:

| Ação | Efeito |
|---|---|
| **CASCADE** | propaga a exclusão/alteração |
| **RESTRICT / NO ACTION** | impede se houver dependentes |
| **SET NULL / SET DEFAULT** | zera/assume padrão na FK |

---

<!-- _class: secao -->

# Catálogo

---

## Catálogo (Dicionário de Dados)

- Armazena a **descrição do banco**: esquemas, mapeamentos, restrições de integridade e critérios de segurança.
- É um **metadado**: "dados sobre os dados" (tabelas, colunas, índices, usuários, permissões).
- **Regra 4 de Codd:** o catálogo é **relacional** e pode ser consultado como qualquer tabela.

```sql
-- exemplos (variam por SGBD)
SELECT table_name  FROM user_tables;          -- Oracle
SELECT * FROM information_schema.columns;      -- PostgreSQL / MySQL
```

---

## Bibliografia

- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Rio de Janeiro: Elsevier, 2004.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. São Paulo: Pearson, 2019.
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. **Sistema de Banco de Dados.** 7ª ed. Elsevier, 2020.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br
