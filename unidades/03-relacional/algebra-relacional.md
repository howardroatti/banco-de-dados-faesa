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
- Operações: **seleção, projeção, união, interseção, diferença, produto cartesiano, junções, divisão, agregação, renomeação e atribuição**.

<div class="dica">💡 Toda operação da álgebra <strong>fecha</strong> sobre relações: a entrada é relação, a saída também. Por isso é possível <strong>compor</strong> operações.</div>

---

## Dataset de exemplo

<div style="display:grid;grid-template-columns:1fr 1fr 0.82fr;gap:16px;font-size:0.82em;">
<div>

**NFC** — Nota Fiscal de **Compra**
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

**NFV** — Nota Fiscal de **Venda**
| no-nf | nomecli | no-mat | valor |
|--|--|--|--|
| 1 | Ana | 1 | 150 |
| 2 | Carlos | 3 | 250 |
| 3 | Regina | 2 | 350 |
| 4 | Jose | 1 | 450 |
| 5 | Beatriz | 3 | 550 |

</div>
<div>

**M** — Materiais
| no-mat | nomemat | preço |
|--|--|--|
| 1 | Blusa | 2 |
| 2 | Carteira | 4 |
| 3 | Calça | 6 |
| 4 | Meia | 8 |
| 5 | Sapato | 10 |

</div>
</div>

<div class="dica">💡 <strong>NFV</strong> tem a <strong>mesma estrutura</strong> de <strong>NFC</strong>, com <code>nomecli</code> no lugar de <code>nomefor</code>.</div>

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

## Produto Cartesiano — exemplo e quando usar

Com relações **pequenas** dá para ver **todas** as combinações. Ex.: variações de um produto (**cor × tamanho**):

<div style="display:grid;grid-template-columns:0.5fr 0.5fr 1fr;gap:16px;font-size:0.9em;align-items:start;">
<div>

**Cores**
| cor |
|--|
| Azul |
| Verde |

</div>
<div>

**Tam.**
| tam |
|--|
| P |
| M |
| G |

</div>
<div>

**Cores × Tam.** → 2 × 3 = **6**
| cor | tam |
|--|--|
| Azul | P |
| Azul | M |
| Azul | G |
| Verde | P |
| Verde | M |
| Verde | G |

</div>
</div>

<div class="dica">💡 <strong>Faz sentido</strong> quando você quer <strong>todas as combinações</strong> (variações cor × tamanho, confrontos times × rodadas) ou como <strong>passo intermediário</strong> de uma junção (× + σ). <strong>Evite</strong> em tabelas grandes sem filtro: 1.000 × 1.000 = <strong>1 milhão</strong> de linhas (a "junção acidental").</div>

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

Preserva tuplas **sem par**, preenchendo o outro lado com **nulos**. Ex.: materiais **comprados** (NFC, `{1,3,4,5}`) × **vendidos** (NFV, `{1,2,3}`):

<div class="cols">
<div>

**Esquerda (⟕):** todas de **Comprados**
| no-mat | comprador | cliente |
|--|--|--|
| 1 | Jose | Ana |
| 3 | Geny | Carlos |
| 4 | Regina | *(nulo)* |
| 5 | Jose | *(nulo)* |

*(4 e 5 foram comprados, mas **nunca vendidos** → nulo.)*

</div>
<div>

**Direita (⟖):** todas de **Vendidos**
| no-mat | comprador | cliente |
|--|--|--|
| 1 | Jose | Ana |
| 2 | *(nulo)* | Regina |
| 3 | Geny | Carlos |

*(2 foi vendido, mas **nunca comprado** → nulo.)*

</div>
</div>

---

## Junção Externa — Completa (⟗)

Une as duas: preserva as tuplas **sem par dos dois lados**, com nulos onde faltar.

<div style="display:grid;grid-template-columns:0.42fr 0.42fr 1fr;gap:16px;font-size:0.88em;align-items:start;">
<div>

**Comprados**
| no-mat | comprador |
|--|--|
| 1 | Jose |
| 3 | Geny |
| 4 | Regina |
| 5 | Jose |

</div>
<div>

**Vendidos**
| no-mat | cliente |
|--|--|
| 1 | Ana |
| 2 | Regina |
| 3 | Carlos |

</div>
<div>

**Comprados ⟗ Vendidos**
| no-mat | comprador | cliente |
|--|--|--|
| 1 | Jose | Ana |
| 2 | *(nulo)* | Regina |
| 3 | Geny | Carlos |
| 4 | Regina | *(nulo)* |
| 5 | Jose | *(nulo)* |

</div>
</div>

<div class="dica">💡 O material <strong>2</strong> (só vendido) e os <strong>4, 5</strong> (só comprados) sobrevivem, com nulos do lado que falta. É o <code>FULL OUTER JOIN</code> — une <code>LEFT</code> + <code>RIGHT</code>.</div>

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

## Atribuição (←), Renomeação (ρ) e Projeção Generalizada

- **Atribuição:** guarda um resultado parcial em uma variável → `nome_cli ← Π nomecli (NFV)`.
- **Renomeação (ρ):** renomeia uma relação ou seus atributos → `ρ M2(cod, nome, val) (M)`. Essencial para **auto-junções** (juntar uma tabela com uma cópia de si mesma).
- **Projeção Generalizada:** permite **expressões aritméticas** na lista de projeção.

**Objetivo:** preço com 50% de desconto → Π *no-mat, nomemat, preço * 0,5* (M)

| no-mat | nomemat | preço×0,5 |
|--|--|--|
| 1 | Blusa | 1 |
| 3 | Calça | 3 |

---

## Divisão — ÷

**Sintaxe:** R ÷ S — responde perguntas do tipo **"para TODO"**: tuplas de R associadas a **todos** os valores de S.

**Objetivo:** fornecedores que forneceram **todos** os materiais de `S = {3, 4}`

<div class="cols">
<div>

`R = Π nomefor, no-mat (NFC)` ÷ `S = {3, 4}`

| nomefor |
|--|
| Regina |

</div>
<div>

<div class="dica">💡 Só <strong>Regina</strong> aparece com o material 3 <strong>e</strong> o 4. É o quantificador <strong>universal</strong> (∀).</div>

</div>
</div>

<div class="aviso">A divisão expressa o <strong>quantificador universal</strong> ("para todos"). A SQL não tem um operador direto para ela — veremos como escrevê-la na <strong>Unidade 5</strong>.</div>

---

## Da Álgebra ao SQL

| Álgebra | SQL |
|---|---|
| σ (seleção) | `WHERE` |
| Π (projeção) | `SELECT colunas` |
| ⋈ (junção) | `JOIN` |
| ∪ / ∩ / − | `UNION` / `INTERSECT` / `EXCEPT` |
| ÷ (divisão) | `NOT EXISTS` (dupla negação) |
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

<a class="proximo" href="exercicios-algebra-relacional.html">🎯 Lista de exercícios<small>2 por operação + gabarito</small></a>
<a class="proximo" href="views-sql-indexacao.html">Próximo →<small>Views, SQL e Indexação</small></a>
