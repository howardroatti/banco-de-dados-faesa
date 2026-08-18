---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Modelagem Relacional de Dados
## Parte 1 — Modelagem Conceitual (Diagrama ER)

**Unidade 4** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- **Níveis de abstração** — do mundo real ao banco
- **Diagrama Entidade-Relacionamento (ER)** — história e elementos
- **Entidades, Atributos e Relacionamentos**
- **Cardinalidade** e **participação**
- Casos: 1:N, N:N, **generalização** e **auto-relacionamento**
- **Ferramentas de modelagem**: **Mermaid** (padrão), também draw.io e brModelo
- **Exercícios** de modelagem

<div class="dica">🎯 Objetivo: compreender os conceitos, ler e criar diagramas ER, e praticar com exemplos reais.</div>

---

<!-- _class: secao -->

# Modelagem Conceitual

---

## Níveis de abstração

![w:1000 center](assets/abstracao.svg)

- **Conceitual** descreve o negócio **sem** pensar em SGBD; o **lógico** já é relacional (tabelas); o **físico** é específico (Oracle/PostgreSQL/MySQL).

---

## O Diagrama Entidade-Relacionamento

- Proposto por **Peter Chen (1976)** — tornou-se referência na modelagem de dados.
- Modelo **gráfico** que representa **entidades**, seus **atributos** e os **relacionamentos** entre elas.
- Abordagem simples e flexível; independente do SGBD.

> "O mundo está cheio de coisas, que possuem características próprias e se relacionam entre si." (Cougo, 1997)

---

## Elementos do modelo

| Elemento | O que é | Pista linguística |
|---|---|---|
| **Entidade** | coisa/conceito relevante (Cliente, Produto) | **substantivo** |
| **Atributo** | característica da entidade (nome, preço) | qualidade/dado |
| **Relacionamento** | associação entre entidades (compra, possui) | **verbo** |

<div class="dica">💡 Truque de leitura: <strong>substantivos</strong> viram entidades; <strong>verbos</strong> viram relacionamentos.</div>

---

## Notação de Chen (a do modelo conceitual)

- **Entidades** em **retângulos**, **relacionamentos** em **losangos**, ligados por linhas com a **cardinalidade** nas pontas (ex.: `1`, `N`).
- É a notação clássica do **conceitual**: mostra **o quê se relaciona com o quê**, sem detalhar campos.

<div class="dica">💡 A notação <strong>"pé de galinha" (crow's foot)</strong> — mais enxuta e já com <strong>campos/PK/FK</strong> — entra no <strong>modelo lógico</strong> (Parte 2).</div>

---

## Ferramentas de modelagem

**No ER (conceitual), o padrão é o Mermaid `flowchart`** — desenha a notação de Chen (**losangos**) como texto:

```text
flowchart LR
    LEITOR["LEITOR"] ---|1| R{"faz"}
    R ---|N| EMPRESTIMO["EMPRESTIMO"]
```

- `[ ]` entidade · `{ }` **relacionamento (losango)** · `---|1|` / `---|N|` cardinalidade.

<div class="aviso">📌 No ER, <strong>sem os campos</strong>. Tipos, <strong>PK, FK e nulls</strong> entram no <strong>modelo lógico</strong> (Parte 2), onde usamos o <code>erDiagram</code> (crow's foot).</div>

<div class="dica">💡 Também aceitos: <strong>draw.io</strong> e <strong>brModelo</strong> (fazem Chen nativo). Entregue a imagem/PDF e, no Mermaid, também o código.</div>

---

## Cardinalidade

Quantas ocorrências de uma entidade se associam a outra:

| Notação | Significado |
|---|---|
| **(1,1)** | exatamente um |
| **(0,1)** | zero ou um |
| **(0,N)** | zero ou muitos |
| **(1,N)** | um ou muitos |

- **1:1** — funcionário ↔ um número de identificação (NIS).
- **1:N** — um fornecedor emite várias notas fiscais.
- **N:N** — produtos são fornecidos por vários fornecedores.

---

## Exemplo 1:N — Notas Fiscais e Itens

![h:430 center](assets/er-notas.svg)

- Uma nota fiscal **discrimina** vários itens; cada item pertence a **uma** nota.

---

## Exemplo N:N — Fornecimento

![h:340 center](assets/er-fornecimento.svg)

- Relacionamento **muitos-para-muitos** entre `FORNECEDORES` e `PRODUTOS` (o "fornecem" carrega dados próprios, ex.: preço).

---

## Generalização / Especialização

![h:430 center](assets/generalizacao.svg)

- `PESSOAS` (geral) especializa-se em `FÍSICAS` e `JURÍDICAS`, que **herdam** os atributos comuns e acrescentam os próprios.

---

## Auto-relacionamento

![h:400 center](assets/auto-rel.svg)

- Uma entidade se relaciona **consigo mesma**: um funcionário **gerencia** outros funcionários (o gestor também é funcionário).

---

## Do diagrama de classes ao ER

Partindo de um **diagrama de classes** (UML), traduzimos para o **ER (Chen)**:

![h:210 center](assets/biblioteca-classes.svg)

- **Classes → entidades** · **associações → relacionamentos (losango)** · **multiplicidades → cardinalidade** (`1`, `N`).
- No ER, **sem os campos** — tipos, PK e FK ficam para o **modelo lógico** (Parte 2).

---

## O ER em notação de Chen

![h:230 center](assets/exemplo-biblioteca.svg)

- `LEITOR` **1:N** `EMPRESTIMO` · `LIVRO` **1:N** `EMPRESTIMO` — o `EMPRESTIMO` resolve o **N:M** entre leitor e livro.

<div class="dica">💡 <strong>Sua vez:</strong> traduza os diagramas de classes dos exercícios (Pedidos e RPG) para o ER em Chen — entidades, losangos e cardinalidade.</div>

---

## Exercício 1 — Controle de Pedidos

<div class="cols">
<div>

**Entidades (atributos)**
- **Cliente** — nome, endereço, telefone, e-mail
- **Produto** — nome, descrição, preço, imagem
- **Pedido** — data, hora, quantidade
- **Pagamento** — data, hora, valor, cartão
- **Fornecedor** — nome, endereço, telefone, e-mail

</div>
<div>

**Relacionamentos e cardinalidade**
- **Cliente 1:N Pedido** — um cliente faz vários pedidos
- **Pedido 1:N Produto** — um pedido tem vários itens
- **Pedido 1:1 Pagamento** — cada pedido, um pagamento
- **Fornecedor 1:N Pedido** — um fornecedor atende vários pedidos

</div>
</div>

<div class="dica">Modele o <strong>ER</strong> (entidades, relacionamentos e cardinalidades). No ER, <strong>sem os campos tipados</strong> — PK/FK/tipos ficam no modelo lógico.</div>

---

## Exercício 2 — Jogos Digitais (RPG)

<div class="cols">
<div>

**Entidades (atributos)**
- **Jogador** — nome, data de nascimento, nível
- **Personagem** — nome, tipo
- **Arma** — nome, tipo, dano
- **Missão** — nome, dificuldade, recompensa
- **Inventário** — itens do jogador (liga Jogador e Arma)
- **Conquista** — nome, descrição

</div>
<div>

**Relacionamentos e cardinalidade**
- **Jogador 1:N Personagem**
- **Personagem N:M Arma**
- **Jogador N:M Missão**
- **Jogador 1:N Inventário**
- **Jogador N:M Conquista**

</div>
</div>

<div class="dica">Modele o <strong>ER</strong> (entidades, relacionamentos e cardinalidades). Nos <strong>N:M</strong>, lembre da <strong>entidade associativa</strong> ao passar para o lógico.</div>

---

## Bibliografia

- COUGO, P. **Modelagem Conceitual e Projeto de Bancos de Dados.** Rio de Janeiro: Campus, 1997.
- HEUSER, C. A. **Projeto de Banco de Dados.** 6ª ed. Porto Alegre: Bookman, 2009.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019. (cap. Modelagem ER)

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="modelagem-conceitual-avancada.html">Próximo →<small>Modelagem Conceitual — Aprofundando</small></a>
