---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# MongoDB na prática
## Ambiente via Docker na VM + primeiros comandos

**Unidade 7 — NoSQL** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- Subir o **MongoDB** com **Docker** na **VM LabDatabase**
- Conectar com **mongosh** / **Compass** / **DBeaver**
- Modelo: **database → collection → document**
- **CRUD**: `insertOne`, `find`, `updateMany`, `deleteMany`
- **Índices** e uma pincelada em **aggregation**

<div class="vm">🖥️ Nada de instalar no Windows: usamos o <strong>container</strong> da VM (isolado, reprodutível, igual em qualquer máquina).</div>

---

## MongoDB via Docker na VM

O MongoDB já vem no `docker-compose.yml` da VM (serviço `mongo`, porta **27017**).

```bash
# na VM LabDatabase
cd ~/database_services
docker compose up -d mongo        # sobe só o MongoDB
docker compose ps                 # confere se está "running"
```

Rodar avulso (sem compose) também funciona:

```bash
docker run -d --name mongo -p 27017:27017 mongo:7
```

---

## Conectar ao banco

- **mongosh** (shell oficial) — dentro do container:

```bash
docker exec -it mongo mongosh
```

- **GUIs**: **MongoDB Compass** ou **DBeaver** →
  `mongodb://localhost:27017`

<div class="dica">💡 O <strong>DBeaver</strong> (mesma IDE do roteiro de SQL) também conecta ao MongoDB — mantém o fluxo de trabalho.</div>

---

## Modelo de dados

```text
Servidor
 └─ Database  (ex.: loja)
     └─ Collection  (ex.: produtos)   ← equivale à "tabela"
         └─ Document  (JSON/BSON)      ← equivale à "linha"
```

- **Sem esquema fixo**: documentos da mesma coleção podem ter campos diferentes.
- Todo documento tem um `_id` único (gerado automaticamente se omitido).

```javascript
use loja      // seleciona/cria a database
```

---

## CRUD — Inserir

```javascript
db.produtos.insertOne({
  nome: "Notebook", preco: 3500, tags: ["informática"]
})

db.produtos.insertMany([
  { nome: "Mouse",  preco: 80 },
  { nome: "Teclado", preco: 150, sem_fio: true }   // campo extra: tudo bem!
])
```

- A coleção `produtos` é **criada automaticamente** na primeira inserção.

---

## CRUD — Consultar (`find`)

```javascript
db.produtos.find()                              // todos
db.produtos.find({ preco: { $gt: 100 } })       // preço > 100
db.produtos.find({ tags: "informática" })       // array contém valor

// projeção + ordenação + limite
db.produtos.find(
  { preco: { $lte: 200 } },
  { nome: 1, preco: 1, _id: 0 }
).sort({ preco: -1 }).limit(5)
```

| Operador | Significado |
|---|---|
| `$gt` `$gte` `$lt` `$lte` | comparações |
| `$in` `$nin` | pertence / não pertence |
| `$and` `$or` | lógicos |

---

## CRUD — Atualizar e Excluir

```javascript
// atualizar (note: updateOne / updateMany, não "update")
db.produtos.updateOne(
  { nome: "Mouse" },
  { $set: { preco: 90 } }
)
db.produtos.updateMany(
  { preco: { $lt: 100 } },
  { $inc: { preco: 10 } }        // incrementa
)

// excluir
db.produtos.deleteOne({ nome: "Teclado" })
db.produtos.deleteMany({ preco: { $gt: 5000 } })
```

<div class="aviso">⚠️ Métodos antigos como <code>update()</code>/<code>remove()</code> estão <strong>obsoletos</strong> — use <code>updateOne/Many</code> e <code>deleteOne/Many</code>.</div>

---

## Índices e Aggregation

```javascript
// índice para acelerar buscas por nome
db.produtos.createIndex({ nome: 1 })

// aggregation pipeline: total e média de preço por tag
db.produtos.aggregate([
  { $unwind: "$tags" },
  { $group: { _id: "$tags",
              qtd: { $sum: 1 },
              preco_medio: { $avg: "$preco" } } },
  { $sort: { qtd: -1 } }
])
```

- O **pipeline de agregação** é o "GROUP BY / analytics" do MongoDB.

---

## Boas práticas e próximos passos

- Modele pensando nos **padrões de acesso** (o que a aplicação lê junto, guarde junto).
- Crie **índices** para as consultas frequentes; evite varrer coleções inteiras.
- **Não guarde a senha** no código — use variável de ambiente / `.env`.
- Explore **Aggregation**, **schema validation** e o **MongoDB Atlas** (nuvem, free tier).
- Próximo deck: **De SQL para MongoDB** — traduzindo o que você já sabe.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="de-sql-para-mongodb.html">Próximo →<small>De SQL para MongoDB</small></a>
