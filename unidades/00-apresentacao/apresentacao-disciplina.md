---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Banco de Dados
## Apresentação da Disciplina

**2026/2** · Cursos de Computação
Prof. M.Sc. Howard Cruz Roatti
howard.cruz@faesa.br

---

## Boas-vindas

Nesta disciplina você vai aprender a **projetar, construir e consultar** bancos de dados — a espinha dorsal de praticamente todo sistema de software.

Do **modelo conceitual** ao **SQL** em produção, passando por **transações**, **desempenho** e os **bancos NoSQL** que sustentam as aplicações modernas na nuvem.

<div class="dica">💡 Todo o material é público e versionado: <strong>github.com/howardroatti/banco-de-dados-faesa</strong></div>

---

## Ementa

- Conceitos de banco de dados e SGBD.
- Arquitetura ANSI/SPARC e independência de dados.
- Modelo relacional, modelagem conceitual (ER) e lógica.
- Normalização de dados.
- Linguagem **SQL** (DDL, DML, DQL, DCL) e programação no servidor.
- Processamento de **transações** (ACID, concorrência, recuperação).
- Bancos de dados **NoSQL** e tendências (nuvem, dados vetoriais).

---

## Objetivos de aprendizagem

Ao final da disciplina, você será capaz de:

1. **Modelar** um domínio em diagramas ER e traduzi-lo em tabelas.
2. **Normalizar** esquemas até 3FN/BCNF de forma justificada.
3. **Escrever** consultas SQL — de simples a junções e agregações.
4. **Programar** no servidor (views, procedures, funções, triggers).
5. **Explicar** transações, isolamento e recuperação.
6. **Escolher** entre relacional e NoSQL conforme o problema.

---

## Conteúdo por unidade

| # | Unidade |
|---|---|
| 1 | Conceitos de Banco de Dados |
| 2 | Arquitetura para Banco de Dados |
| 3 | Modelo Relacional (Codd, álgebra, views, indexação) |
| 4 | Modelagem Relacional (ER, lógica, normalização) |
| 5 | Linguagem SQL + Procedimentos Armazenados |
| 6 | Processamento de Transações |
| 7 | Bancos de Dados NoSQL |

---

## Metodologia

- **Aulas expositivas** com os slides deste repositório.
- **Prática guiada** na **VM LabDatabase** (Docker com Oracle, PostgreSQL, MySQL, MongoDB e Redis) — o mesmo ambiente para todos.
- **Roteiro Prático de SQL** como fio condutor da parte de linguagem.
- **Listas de exercícios** e questões no estilo **ENADE**.

<div class="vm">🖥️ Você não instala SGBD no seu PC: conecta na VM e trabalha nos containers já provisionados.</div>

---

## Avaliação

O semestre tem **três ciclos** de avaliação — **C1, C2 e C3**. Cada ciclo vale **10,0** e combina:

| Componente | Peso | O que é |
|---|---|---|
| **A1** | 2,0 | Questionário / atividade no AVA |
| **A2** | 8,0 | Prova ou trabalho (individual/grupo) |

<div class="dica">💡 As <strong>datas de cada A1/A2</strong> e as entregas em grupo estão no <strong>Cronograma Quinzenal</strong> da sua turma, no AVA.</div>

---

## Ambiente e ferramentas

- **VM LabDatabase** — SGBDs em Docker (acesso via SSH / cliente SQL).
- **DBeaver** (ou cliente equivalente) para conectar e consultar.
- **mongosh** para a parte de MongoDB.
- **Git / GitHub** — material da disciplina versionado e sempre atualizado.

---

## Bibliografia

**Básica**
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.
- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Elsevier, 2004.
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. **Sistema de Banco de Dados.** 7ª ed. Elsevier, 2020.

**Complementar**
- HEUSER, C. A. **Projeto de Banco de Dados.** 6ª ed. Bookman, 2009.
- SADALAGE, P.; FOWLER, M. **NoSQL Essencial.** Novatec, 2019.

---

<!-- _class: secao -->

# Vamos começar!
### Unidade 1 — Conceitos de Banco de Dados
howard.cruz@faesa.br

<a class="proximo" href="../01-conceitos/conceitos-bd.html">Começar →<small>Unidade 1 — Conceitos de Banco de Dados</small></a>
