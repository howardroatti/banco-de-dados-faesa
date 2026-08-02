---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Bancos de Dados NoSQL
## Dados não estruturados, famílias e o elo com a IA

**Unidade 7** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- **Tipos de dado** — estruturado, semiestruturado e não estruturado
- **Por que NoSQL** — escala, esquema flexível e o **Teorema CAP**
- **Famílias** — chave-valor, documento, coluna, grafo (e além)
- **NoSQL na nuvem** — serviços gerenciados (DBaaS)
- **NoSQL + IA** — **bancos vetoriais** e **RAG**
- **SQL × NoSQL** — não é "melhor", é **adequação**

---

<!-- _class: secao -->

# Tipos de dado

---

## Estruturado · Semiestruturado · Não estruturado

| Tipo | Estrutura | Exemplos |
|---|---|---|
| **Estruturado** | rígida (tabelas, colunas) | tabelas relacionais, planilhas |
| **Semiestruturado** | flexível, autodescritiva | **JSON**, XML, logs |
| **Não estruturado** | sem esquema definido | texto, e-mail, imagem, áudio, vídeo |

<div class="aviso">📊 Estima-se que a <strong>maior parte</strong> dos dados gerados hoje é <strong>não estruturada</strong> — e cresce mais rápido que a estruturada.</div>

---

## Por que os bancos NoSQL surgiram?

- **Volume e velocidade** (Big Data, web em escala) exigiram **escala horizontal** — distribuir em muitos servidores comuns.
- O **modelo relacional** (esquema rígido, JOINs, transações fortes) é difícil de escalar horizontalmente.
- Aplicações web passaram a lidar com dados **flexíveis** e **semiestruturados** (JSON).

> **NoSQL** = "Not Only SQL" — uma **família** de bancos não relacionais, cada um para um tipo de problema.

---

<!-- _class: secao -->

# Fundamentos

---

## Características comuns

- **Escalabilidade horizontal** (*scale-out*): adicionar nós em vez de um servidor maior.
- **Esquema flexível** (*schema-less* ou *schema-on-read*): o dado carrega sua estrutura.
- **Orientação a agregados**: o dado é lido/gravado como uma **unidade** (documento, item) — menos JOINs.
- **Alta disponibilidade** e tolerância a partições de rede.

<div class="dica">💡 "Agregado" = um conjunto de dados tratado como uma unidade (ex.: um pedido com seus itens em um único documento).</div>

---

## Teorema CAP

Em um sistema **distribuído**, na presença de uma **partição de rede (P)**, escolhe-se entre:

<div class="cols">
<div>

- **C — Consistência**
  todos leem o dado mais recente
- **A — Disponibilidade**
  toda requisição recebe resposta
- **P — Tolerância a Partição**
  funciona mesmo com falha de rede

</div>
<div>

**Não dá para ter C + A + P ao mesmo tempo.**

- Relacionais clássicos → tendem a **CP**
- Muitos NoSQL → tendem a **AP** (consistência *eventual*)

</div>
</div>

<div class="aviso">Consistência <strong>eventual</strong>: após um tempo sem novas escritas, todos os nós convergem para o mesmo valor.</div>

---

<!-- _class: secao -->

# Famílias NoSQL

---

## Chave-valor (Key-Value)

- Modelo mais simples: uma **chave** aponta para um **valor** opaco.
- Extremamente rápido; ideal para **cache**, **sessões**, contadores.
- Exemplos: **Redis**, **Amazon DynamoDB**, Riak.

```text
SET sessao:abc123  "{ user: 42, exp: 1699999999 }"
GET sessao:abc123
```

<div class="vm">🖥️ A <strong>VM LabDatabase</strong> tem <strong>Redis</strong> disponível para prática.</div>

---

## Orientado a Documentos

- Armazena **documentos** (JSON/BSON) com estrutura flexível, agrupados em **coleções**.
- Bom para catálogos, perfis, conteúdo — o "agregado" cabe em um documento.
- Exemplos: **MongoDB**, Couchbase, Firestore.

```json
{
  "_id": "P-1001",
  "nome": "Notebook",
  "preco": 3500,
  "tags": ["eletrônicos", "informática"]
}
```

---

## Orientado a Colunas · Grafos

<div class="cols">
<div>

**Colunar (wide-column)**
- Dados por **família de colunas**; ótimo para escrita massiva e séries.
- Escala para petabytes.
- Ex.: **Cassandra**, HBase, ScyllaDB.

</div>
<div>

**Grafos**
- **Nós** e **relacionamentos** como cidadãos de 1ª classe.
- Ideal para redes sociais, recomendação, detecção de fraude.
- Ex.: **Neo4j**, Amazon Neptune.

</div>
</div>

<div class="dica">Ainda há nichos: <strong>séries temporais</strong> (InfluxDB, TimescaleDB), <strong>espaciais</strong> (PostGIS) e <strong>busca</strong> (Elasticsearch).</div>

---

## NoSQL na nuvem (DBaaS)

- Bancos **gerenciados**: sem instalar/manter servidor — escala, backup e alta disponibilidade automáticos.
- **Amazon DynamoDB**, **Azure Cosmos DB**, **Google Firestore**, **MongoDB Atlas**, **Redis Cloud**.
- Modelo **serverless** e cobrança por uso — comum em projetos modernos e no **free tier**.

<div class="dica">💡 Ótimo para o MVP do Projeto Integrador: subir um banco na nuvem em minutos, sem infraestrutura.</div>

---

<!-- _class: secao -->

# NoSQL + Inteligência Artificial

---

## Bancos vetoriais

- Guardam **embeddings**: vetores numéricos que representam o **significado** de textos, imagens, áudio.
- Permitem **busca por similaridade** (vizinhos mais próximos) — "encontre o parecido", não o "igual".
- Exemplos: **pgvector** (extensão do PostgreSQL), **Chroma**, **Qdrant**, **Pinecone**.

```sql
-- PostgreSQL + pgvector: itens mais próximos de um vetor de consulta
SELECT id, texto
  FROM documentos
 ORDER BY embedding <-> :consulta   -- distância vetorial
 LIMIT 5;
```

---

## RAG — Retrieval-Augmented Generation

O banco vetorial dá **memória e contexto** a um LLM: recupera trechos relevantes e os injeta no prompt.

![w:1000 center](assets/rag-pipeline.svg)

<div class="dica">💡 É a ponte direta entre <strong>Banco de Dados</strong> e as <strong>aplicações de IA</strong> do Projeto Integrador (GenAI, RAG).</div>

---

## Persistência poliglota

> Usar **o banco certo para cada necessidade** dentro da mesma aplicação.

![w:760 center](assets/poliglota.svg)

---

## SQL × NoSQL — adequação, não competição

| Prefira **SQL (relacional)** quando… | Prefira **NoSQL** quando… |
|---|---|
| dados estruturados e estáveis | esquema flexível / evolutivo |
| transações fortes (ACID) | escala horizontal massiva |
| relatórios com muitos JOINs | agregados lidos como unidade |
| consistência imediata | disponibilidade / baixa latência |

<div class="aviso">A resposta madura é quase sempre <strong>“depende do problema”</strong> — e frequentemente <strong>os dois</strong> (persistência poliglota).</div>

---

## Bibliografia

- SADALAGE, P.; FOWLER, M. **NoSQL Distilled** (Um Guia Conciso para o Mundo Emergente da Persistência Poliglota). Novatec, 2013.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019. (cap. NoSQL/Big Data)
- KLEPPMANN, M. **Designing Data-Intensive Applications.** O'Reilly, 2017.
- Documentação: **MongoDB**, **Redis**, **Amazon DynamoDB**, **pgvector**.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br
