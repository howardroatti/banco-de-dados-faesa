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

## Da notação de Chen à notação de aula

- A notação original de **Chen** (entidades em retângulos, relacionamentos em losangos, atributos em elipses) fica **poluída** em modelos grandes.
- Adotamos a notação de **"pé de galinha" (crow's foot)** — mais enxuta e usada pelas ferramentas (SQL Power Architect, Mermaid).

```text
||   um e somente um        o|   zero ou um
|{   um ou muitos           o{   zero ou muitos
```

---

## Ferramentas de modelagem

**Padrão da disciplina: Mermaid `erDiagram`** — o diagrama vira **texto** (fácil de versionar, colar no material e revisar):

```text
erDiagram
    FORNECEDOR  ||--o{ NOTA_FISCAL : emite
    NOTA_FISCAL ||--|{ ITEM        : contem
    FORNECEDOR  { int id PK
                  string nome }
```

- Cardinalidade em **pé de galinha**: `||` um · `o{` zero ou muitos · `|{` um ou muitos.

<div class="dica">💡 <strong>Também aceitos</strong> (mesma notação crow's foot): <strong>draw.io</strong> e <strong>brModelo</strong>. Entregue a <strong>imagem/PDF</strong> do diagrama e, se usar Mermaid, também o <strong>código</strong>.</div>

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

## Exercícios

<div class="cols">
<div>

**Controle de Pedidos**
- **Cliente**: nome, endereço, telefone, e-mail
- **Produto**: nome, descrição, preço
- **Pedido**: data, hora, cliente, produto, quantidade
- **Pagamento**: data, valor, cliente, cartão

</div>
<div>

**Jogos Digitais (RPG)**
- **Jogador**: ID, nome, nível
- **Personagem**: ID, nome, tipo
- **Arma**: ID, nome, tipo, dano
- **Missão**: ID, nome, dificuldade

</div>
</div>

<div class="dica">Modele o **ER** de cada caso: identifique entidades, atributos, relacionamentos e cardinalidades.</div>

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
