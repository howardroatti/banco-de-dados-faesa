---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# De SQL para MongoDB
## Traduzindo o que você já sabe

**Unidade 7 — NoSQL** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Terminologia equivalente

| SQL (relacional) | MongoDB (documento) |
|---|---|
| Database | Database |
| Tabela | **Coleção** (collection) |
| Linha / registro | **Documento** (JSON/BSON) |
| Coluna / atributo | **Campo** (field) |
| Chave primária | campo **`_id`** |
| JOIN | **`$lookup`** ou **dado embutido** |
| Índice | Índice |

---

## Tabela × Documento

<div class="cols">
<div>

**Relacional** (normalizado)
```text
clientes(id, nome)
pedidos(id, cliente_id, data)
itens(pedido_id, produto, qtd)
```
Dados espalhados em 3 tabelas → JOINs para reunir.

</div>
<div>

**Documento** (agregado)
```json
{ "_id": 1, "nome": "Ana",
  "pedidos": [
    { "data": "2026-03-01",
      "itens": [
        {"produto":"Mouse","qtd":2}
      ] }
  ] }
```
O pedido inteiro em **um documento**.

</div>
</div>

---

## Criar e evoluir estrutura

<div class="cols">
<div>

**SQL**
```sql
CREATE TABLE people (
  id     NUMBER PRIMARY KEY,
  user_id VARCHAR2(30),
  status  VARCHAR2(1)
);
ALTER TABLE people
  ADD join_date DATE;
```

</div>
<div>

**MongoDB**
```javascript
// coleção criada ao inserir
db.people.insertOne({
  user_id: "abc", status: "A"
})
// "adicionar coluna" = só gravar o campo
db.people.updateOne(
  { user_id: "abc" },
  { $set: { join_date: new Date() } }
)
```

</div>
</div>

---

## Inserir

<div class="cols">
<div>

**SQL**
```sql
INSERT INTO people
  (user_id, age, status)
VALUES ('bcd001', 45, 'A');
```

</div>
<div>

**MongoDB**
```javascript
db.people.insertOne({
  user_id: "bcd001",
  age: 45,
  status: "A"
})
```

</div>
</div>

---

## Consultar (SELECT → find)

<div class="cols">
<div>

**SQL**
```sql
SELECT user_id, status
FROM people
WHERE status = 'A'
  AND age > 25
ORDER BY user_id;
```

</div>
<div>

**MongoDB**
```javascript
db.people.find(
  { status: "A", age: { $gt: 25 } },
  { user_id: 1, status: 1, _id: 0 }
).sort({ user_id: 1 })
```

</div>
</div>

<div class="dica">💡 <code>LIKE '%bc%'</code> → <code>{ user_id: /bc/ }</code> (expressão regular).</div>

---

## Atualizar e Excluir

<div class="cols">
<div>

**SQL**
```sql
UPDATE people
SET status = 'C'
WHERE age > 25;

DELETE FROM people
WHERE status = 'D';
```

</div>
<div>

**MongoDB**
```javascript
db.people.updateMany(
  { age: { $gt: 25 } },
  { $set: { status: "C" } }
)
db.people.deleteMany(
  { status: "D" }
)
```

</div>
</div>

---

## Agregação (GROUP BY → aggregate)

<div class="cols">
<div>

**SQL**
```sql
SELECT status,
       COUNT(*)  qtd,
       AVG(age)  media
FROM people
GROUP BY status
HAVING COUNT(*) > 1;
```

</div>
<div>

**MongoDB**
```javascript
db.people.aggregate([
  { $group: {
      _id: "$status",
      qtd:   { $sum: 1 },
      media: { $avg: "$age" } } },
  { $match: { qtd: { $gt: 1 } } }
])
```

</div>
</div>

---

## Relacionamentos: embutir × referenciar

- **Embutir** (documento aninhado): dados lidos **sempre juntos**, cardinalidade limitada → 1 leitura, sem JOIN.
- **Referenciar** (`_id` de outra coleção + **`$lookup`**): dados grandes/compartilhados, relação N:N.

```javascript
db.pedidos.aggregate([
  { $lookup: {
      from: "clientes", localField: "cliente_id",
      foreignField: "_id", as: "cliente" } }
])
```

<div class="aviso">Regra de ouro: <strong>modele pelos padrões de acesso</strong>. "O que é lido junto, guarde junto."</div>

---

## Resumo

- Você **já sabe** os conceitos — muda a **forma** de guardar e consultar.
- MongoDB troca **JOINs** por **agregados** e favorece **flexibilidade + escala**.
- Sintaxe atual: `insertOne/Many`, `updateOne/Many`, `deleteOne/Many`, `countDocuments`, `aggregate`.
- Pratique na **VM** (container Docker) e leve para o **Projeto Integrador** (inclusive na nuvem).

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="../../index.html">↩ Voltar ao índice<small>Fim da trilha — todas as unidades</small></a>
