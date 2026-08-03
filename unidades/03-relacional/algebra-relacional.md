---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Álgebra Relacional
## O aspecto manipulador do modelo relacional

**Unidade 3** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## O que é

- Conjunto de **operadores** que recebem **relações** e produzem uma **nova relação** (derivam tabelas de outras tabelas).
- É a base **formal** das consultas SQL (`SELECT` = seleção + projeção + junção…).
- Operações: **seleção, projeção, união, interseção, diferença, produto cartesiano, junções, agregação, atribuição**.

<div class="dica">💡 Toda operação da álgebra <strong>fecha</strong> sobre relações: a entrada é relação, a saída também. Por isso é possível <strong>compor</strong> operações.</div>

---

## Dataset de exemplo

<div class="cols">
<div>

**NFC** (Nota Fiscal de Compra)
| no-nf | nomefor | no-mat | valor |
|--|--|--|--|
| 1 | Jose | 1 | 100 |
| 2 | Geny | 3 | 200 |
| 3 | João | 3 | 300 |
| 4 | Regina | 4 | 400 |
| 5 | Regina | 3 | 500 |
| 6 | Jose | 5 | 600 |

</div>
<div>

**M** (Materiais)
| no-mat | nomemat | preço |
|--|--|--|
| 1 | Blusa | 2 |
| 2 | Carteira | 4 |
| 3 | Calça | 6 |
| 4 | Meia | 8 |
| 5 | Sapato | 10 |

</div>
</div>

*(NFV = Nota Fiscal de Venda, mesma estrutura de NFC com `nomecli`.)*

---

## Seleção — σ

**Sintaxe:** σ *&lt;condição&gt;* (R) — filtra **linhas** que satisfazem a condição.

**Objetivo:** notas fiscais do material 3 → σ *no-mat = 3* (NFC)

| no-nf | nomefor | no-mat | valor |
|--|--|--|--|
| 2 | Geny | 3 | 200 |
| 3 | João | 3 | 300 |
| 5 | Regina | 3 | 500 |

---

## Projeção — Π

**Sintaxe:** Π *&lt;lista de atributos&gt;* (R) — seleciona **colunas** (particionamento vertical).

**Objetivo:** fornecedor e material comprado → Π *nomefor, no-mat* (NFC)

<div class="cols">
<div>

| nomefor | no-mat |
|--|--|
| Jose | 1 |
| Geny | 3 |
| João | 3 |
| Regina | 4 |
| Jose | 5 |

</div>
<div>

<div class="dica">💡 A projeção <strong>elimina duplicatas</strong> (o resultado é um conjunto). "Regina/3" aparece uma vez.</div>

</div>
</div>

---

## União — ∪

**Sintaxe:** R ∪ S — tuplas que estão em **R ou S**. Exige **união-compatibilidade** (mesmo nº e domínio de atributos).

- Nº de atributos = igual ao das relações de origem.
- Duplicatas são eliminadas.

```text
Π nomefor (NFC)  ∪  Π nomecli (NFV)   → todos os que compraram OU venderam
```

---

## Interseção — ∩

**Sintaxe:** R ∩ S — tuplas presentes em **ambas** as relações.

**Objetivo:** materiais comprados **e** vendidos → Π *no-mat* (NFC) ∩ Π *no-mat* (NFV)

| no-mat |
|--|
| 1 |
| 3 |

---

## Diferença — −

**Sintaxe:** R − S — tuplas que estão em **R mas não em S** (não é comutativa).

**Objetivo:** materiais comprados e **nunca** vendidos → Π *no-mat* (NFC) − Π *no-mat* (NFV)

| no-mat |
|--|
| 4 |
| 5 |

---

## Produto Cartesiano — ×

**Sintaxe:** R × S — **todas as combinações** de pares de tuplas.

- Nº de atributos = **soma** dos atributos · Nº de tuplas = **produto** (|R| × |S|).
- Se NFC tem 6 tuplas e M tem 5 → **30 tuplas**. Base para as **junções**.

```text
NFC × M  →  6 × 5 = 30 tuplas (muitas sem sentido semântico)
```

<div class="aviso">Sozinho gera combinações "sem sentido"; combinado com uma <strong>seleção</strong> vira a <strong>junção</strong>.</div>

---

## Junção Teta (θ) e Natural

- **Junção θ:** produto cartesiano **+** condição de junção → σ *&lt;condição&gt;* (R × S). Usada quando não há atributo comum.
- **Junção Natural (⋈):** junção de igualdade pelo **atributo de mesmo nome**, **eliminando** a coluna duplicada.

**Objetivo:** dados da compra com o nome do material → NFC ⋈ M

| no-nf | nomefor | no-mat | valor | nomemat | preço |
|--|--|--|--|--|--|
| 1 | Jose | 1 | 100 | Blusa | 2 |
| 2 | Geny | 3 | 200 | Calça | 6 |
| 3 | João | 3 | 300 | Calça | 6 |

---

## Junção Externa — Esquerda / Direita

Preserva tuplas **sem par**, preenchendo o outro lado com **nulos**.

- **Externa à esquerda (⟕):** todas as tuplas de **R** (à esquerda).
- **Externa à direita (⟖):** todas as tuplas de **S** (à direita).

| no-mat | nomemat | preço | no-nf | valor |
|--|--|--|--|--|
| 1 | Blusa | 2 | 1 | 100 |
| 2 | Carteira | 4 | *(nulo)* | *(nulo)* |

*(Carteira nunca foi comprada → aparece com nulos na externa à direita.)*

---

## Junção Externa — Completa (⟗)

Une as duas anteriores: preserva as tuplas **sem par dos dois lados**, com nulos onde faltar.

<div class="dica">💡 As junções externas são o que o SQL chama de <code>LEFT / RIGHT / FULL OUTER JOIN</code>.</div>

---

## Funções Agregadas — Ƒ

Operam sobre um **conjunto de valores** e retornam **um único valor**: `SUM, COUNT, AVG, MIN, MAX`.

**Objetivo:** totais das compras → Ƒ *sum(valor), count(no-nf), avg(valor), min(valor), max(valor)* (NFC)

| sum | count | avg | min | max |
|--|--|--|--|--|
| 2100 | 6 | 350 | 100 | 600 |

---

## Agregação com Agrupamento

**Sintaxe:** *&lt;atributos&gt;* Ƒ *&lt;funções&gt;* (R) — agrupa por atributos e agrega dentro de cada grupo.

**Objetivo:** total de compras **por material** → *no-mat* Ƒ *sum(valor)* (NFC)

| no-mat | soma_compras |
|--|--|
| 1 | 100 |
| 3 | 1000 |
| 4 | 400 |
| 5 | 600 |

<div class="dica">💡 É o <code>GROUP BY</code> do SQL.</div>

---

## Atribuição (←) e Projeção Generalizada

- **Atribuição:** guarda um resultado parcial em uma variável → `nome_cli ← Π nomecli (NFV)`.
- **Projeção Generalizada:** permite **expressões aritméticas** na lista de projeção.

**Objetivo:** preço com 50% de desconto → Π *no-mat, nomemat, preço * 0,5* (M)

| no-mat | nomemat | preço×0,5 |
|--|--|--|
| 1 | Blusa | 1 |
| 3 | Calça | 3 |

---

## Da Álgebra ao SQL

| Álgebra | SQL |
|---|---|
| σ (seleção) | `WHERE` |
| Π (projeção) | `SELECT colunas` |
| ⋈ (junção) | `JOIN` |
| ∪ / ∩ / − | `UNION` / `INTERSECT` / `EXCEPT` |
| Ƒ (agregação) | `GROUP BY` + `SUM/AVG/...` |

<div class="dica">💡 Entender a álgebra ajuda a <strong>ler, escrever e otimizar</strong> consultas SQL — próxima unidade.</div>

---

## Bibliografia

- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Elsevier, 2004.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.
- SILBERSCHATZ, A.; KORTH, H.; SUDARSHAN, S. **Sistema de Banco de Dados.** 7ª ed. Elsevier, 2020.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="views-sql-indexacao.html">Próximo →<small>Views, SQL e Indexação</small></a>
