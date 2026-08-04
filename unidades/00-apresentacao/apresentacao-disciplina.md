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

- Banco de Dados Relacional.
- Modelagem Relacional de Dados.
- SQL – DDL e DML — Teoria e Prática.
- Procedimentos Armazenados – Triggers e Procedures — noções básicas.
- Processamento de Transações: conceitos e processamento concorrente.
- Banco de Dados não estruturado.

---

## Objetivos (1/2)

1. **Descrever** os conceitos e a estrutura do Banco de Dados Relacional, especialmente quanto às questões de integridade, estrutura de armazenamento e formas de manipulação.
2. **Aplicar** os conceitos de Modelagem Relacional de Dados e demonstrá-los através da elaboração de modelos lógicos.
3. **Conhecer** a técnica de Normalização de Bases de Dados e aplicar tais conhecimentos na modelagem de problemas.
4. **Escrever** comandos SQL (DDL e DML) para fornecer resposta a situações propostas.

---

## Objetivos (2/2)

5. **Desenvolver** programas para solução de problemas utilizando-se dos fundamentos de Stored Procedures e Triggers.
6. **Descrever** o Processamento de Transações e as Transações Concorrentes.
7. **Conhecer** os principais conceitos relacionados a Banco de Dados não estruturados ou não relacionais e as aplicações mais comuns.
8. **Desenvolver** aplicações utilizando uma linguagem de programação com persistência em banco de dados estruturado e não estruturado.

---

## Conteúdo por unidade

| # | Unidade |
|---|---|
| 1 | Conceitos Básicos de Gerenciamento de Banco de Dados |
| 2 | Uma Arquitetura para Sistema de Banco de Dados |
| 3 | Uma Introdução ao Banco de Dados Relacional |
| 4 | Modelagem Relacional de Dados |
| 5 | Teoria e Prática de SQL (DDL e DML) + Procedimentos Armazenados |
| 6 | Processamento de Transações |
| 7 | Banco de Dados não estruturado |

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

<div class="dica">💡 As <strong>datas de cada A1/A2</strong> e as entregas em grupo estão no <strong>Cronograma Quinzenal</strong> da sua turma — veja o link no próximo slide.</div>

---

## Avaliações — quadro da sua turma

Quando serão as avaliações (A1/A2 de **C1, C2 e C3**), com pontuação e instrumentos? Abra o **quadro de avaliações da sua turma**:

- 🖥️ **4HC1 — Ciência da Computação** · [ver avaliações](https://ava.faesa.br/content/enforced/87384-2026_2_D009519_CI-1010-262-4HC1/Clique%20aqui%20para%20acessar%20as%20avalia%C3%A7%C3%B5es.html)
- 🖥️ **4HC1A — Ciência da Computação** · [ver avaliações](https://ava.faesa.br/content/enforced/87385-2026_2_D009519_CI-1010-262-4HC1A/Clique%20aqui%20para%20acessar%20as%20avalia%C3%A7%C3%B5es.html)
- 🖥️ **4SC1 — Sistemas de Informação** · [ver avaliações](https://ava.faesa.br/content/enforced/87391-2026_2_D009519_CI-1006-262-4SC1/Clique%20aqui%20para%20acessar%20as%20avalia%C3%A7%C3%B5es.html)
- 🖥️ **4DC1 — Análise e Desenv. de Sistemas (TADS)** · [ver avaliações](https://ava.faesa.br/content/enforced/87386-2026_2_D009519_CI-1014-262-4DC1/Clique%20aqui%20para%20acessar%20as%20avalia%C3%A7%C3%B5es.html)

<div class="aviso">Os links abrem <strong>no AVA</strong> — é preciso estar logado e matriculado na turma.</div>

---

## Ambiente e ferramentas

- **VM LabDatabase** — SGBDs em Docker (acesso via SSH / cliente SQL).
- **DBeaver** (ou cliente equivalente) para conectar e consultar.
- **mongosh** para a parte de MongoDB.
- **Git / GitHub** — material da disciplina versionado e sempre atualizado.

<div class="dica">📎 Setup passo a passo no <strong>Apêndice — Laboratório</strong> (VirtualBox, Docker, DBeaver, mongosh, Compass).</div>

---

## Bibliografia — Básica

- COUGO, P. **Modelagem Conceitual e Projeto de Bancos de Dados.** Rio de Janeiro: Campus, 1997.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 6ª ed. São Paulo: Pearson Addison Wesley, 2011.
- SILBERSCHATZ, A.; KORTH, H. F.; SUDARSHAN, S. **Sistemas de Banco de Dados.** 5ª ed. Rio de Janeiro: Elsevier, 2006.

---

## Bibliografia — Complementar

- DATE, C. J. **Introdução a Sistemas de Bancos de Dados.** Rio de Janeiro: Elsevier, 2004.
- GARCIA-MOLINA, H.; ULLMAN, J. D.; WIDOM, J. **Implementação de Sistemas de Bancos de Dados.** Rio de Janeiro: Campus, 2001.
- HEUSER, C. A. **Projeto de Banco de Dados.** 6ª ed. Porto Alegre: Bookman, 2010.
- SETZER, V. W. **Bancos de Dados.** 3ª ed. São Paulo: Edgard Blücher, 2000.
- POMPILHO, S. **Análise Essencial: guia prático de Análise de Sistemas.** Rio de Janeiro: Ciência Moderna, 2002.

---

<!-- _class: secao -->

# Vamos começar!
### Unidade 1 — Conceitos de Banco de Dados
howard.cruz@faesa.br

<a class="proximo" href="../01-conceitos/conceitos-bd.html">Começar →<small>Unidade 1 — Conceitos de Banco de Dados</small></a>
