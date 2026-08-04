---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Prática — MongoDB com Pokémon

## 15 exercícios de CRUD e agregação (mongosh)

**Unidade 7** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## O dataset

- Base pública **pogoapi.net** — cada documento é um Pokémon com `pokemon_name`, `form`, `pokedex_height`, `pokedex_weight`, `pokemon_id`, `buddy_scale`…
- Rode na **VM LabDatabase** (MongoDB via Docker), com **mongosh**.

```js
// 0 — criar a collection a partir do JSON
// baixe: https://pogoapi.net/api/v1/pokemon_height_weight_scale.json
db.pokemon.insertMany( /* array de documentos do JSON */ )
```

<div class="vm">🖥️ Tente cada exercício antes de olhar a solução no slide seguinte.</div>

---

## Busca e contagem (1–3)

```js
// 1 — o Pokémon "Ninetales"
db.pokemon.find({ pokemon_name: "Ninetales" })

// 2 — quantos documentos com "Pikachu"
db.pokemon.find({ pokemon_name: "Pikachu" }).count()

// 3 — Pikachu cuja "form" termina em "star" (regex)
db.pokemon.find({ pokemon_name: "Pikachu", form: /star$/ })
```

<div class="dica">💡 <code>/star$/</code> é uma <strong>expressão regular</strong> — o <code>$</code> ancora no fim.</div>

---

## Filtros numéricos (4–6)

```js
// 4 — altura = 1 e peso < 0.5
db.pokemon.find({ pokedex_height: 1.0, pokedex_weight: { $lt: 0.5 } })

// 5 — altura < 1.0
db.pokemon.find({ pokedex_height: { $lt: 1.0 } })

// 6 — contar o resultado anterior
db.pokemon.find({ pokedex_height: { $lt: 1.0 } }).count()
```

<div class="dica">💡 Operadores de comparação: <code>$lt</code>, <code>$lte</code>, <code>$gt</code>, <code>$gte</code>, <code>$ne</code>.</div>

---

## Atualizar, remover, recriar (7–9)

```js
// 7 — Bulbasaur: alterar a altura para 10.0
db.pokemon.updateMany(
  { pokemon_name: "Bulbasaur" },
  { $set: { pokedex_height: 10.0 } }
)

// 8 — remover todos os "Pikachu"
db.pokemon.deleteMany({ pokemon_name: "Pikachu" })

// 9 — apagar e recriar a collection
db.pokemon.drop()
db.pokemon.insertMany( /* dataset novamente */ )
```

<div class="aviso"><code>updateMany</code>/<code>deleteMany</code> afetam <strong>todos</strong> os documentos que casam — confira o filtro antes.</div>

---

## Projeção — escolher campos (11–13)

```js
// 11 — altura entre 0.3 e 0.75; só o nome, sem _id
db.pokemon.find(
  { pokedex_height: { $lte: 0.75, $gte: 0.3 } },
  { pokemon_name: 1, _id: 0 })

// 12 — form "Normal"; alguns campos
db.pokemon.find({ form: "Normal" },
  { buddy_scale: 1, form: 1, pokemon_id: 1, pokemon_name: 1, _id: 0 })

// 13 — form começando com "Fall"; id, pokemon_id e nome
db.pokemon.find({ form: /^Fall/ }, { pokemon_id: 1, pokemon_name: 1 })
```

<div class="dica">💡 Projeção: <code>1</code> inclui, <code>0</code> exclui. <code>_id</code> vem por padrão — use <code>_id: 0</code> para omitir.</div>

---

## Agregação (10 e 14)

```js
// 10 — somar as alturas de todos os Pokémon
db.pokemon.aggregate([
  { $group: { _id: null, TotalAltura: { $sum: "$pokedex_height" } } }
])

// 14 — agrupar por nome: somar pesos e contar repetidos
db.pokemon.aggregate([
  { $group: {
      _id: "$pokemon_name",
      Total: { $sum: "$pokedex_weight" },
      Quant: { $sum: 1 }
  } }
])
```

<div class="dica">💡 <code>$group</code> é o <code>GROUP BY</code> do MongoDB; <code>_id</code> define a chave do grupo (<code>null</code> = tudo num grupo só).</div>

---

## O que você praticou

- **CRUD**: `find`, `insertMany`, `updateMany`, `deleteMany`, `drop`.
- **Filtros**: igualdade, comparação (`$lt`/`$gte`), **regex** (`/star$/`, `/^Fall/`).
- **Projeção**: incluir/excluir campos, omitir `_id`.
- **Agregação**: `$group` com `$sum` e contagem.

<div class="dica">💡 Compare com o SQL equivalente no deck <strong>"De SQL para MongoDB"</strong>.</div>

---

<!-- _class: secao -->

# Fim da prática
### Dúvidas? howard.cruz@faesa.br

<a class="proximo" href="../../index.html">↩ Voltar ao índice<small>todas as unidades</small></a>
