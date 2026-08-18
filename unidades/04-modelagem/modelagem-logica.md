---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Modelagem Relacional de Dados
## Parte 2 — Modelagem Lógica (do ER às tabelas)

**Unidade 4** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Nesta aula

- Do **modelo conceitual (ER)** ao **modelo lógico (tabelas)**
- **Regras de tradução**: entidades, atributos, relacionamentos
- **Atributos multivalorados/compostos** e **entidades fracas**
- Relacionamentos **1:1, 1:N, M:N**
- **Ferramentas**: **Mermaid** (padrão, diagrama como código), também draw.io e brModelo — e SQL Power Architect na VM

---

<!-- _class: secao -->

# Do conceitual ao lógico

---

## O que traduz em quê

| Conceitual (ER) | Lógico (relacional) |
|---|---|
| Entidade | **Tabela** |
| Atributo | **Coluna** |
| Atributo determinante | **Chave Primária (PK)** |
| Relacionamento | **Chave Estrangeira (FK)** ou **tabela associativa** |

<div class="dica">💡 O modelo lógico ainda é independente do fabricante — só na modelagem <strong>física</strong> escolhemos tipos e recursos de um SGBD.</div>

---

## Tradução E-R → Tabelas — Entidade e multivalorado

<div class="cols">
<div>

**Diagrama E-R**
![w:300](assets/er-fornecedor.svg)

</div>
<div>

**Tabelas (lógico)**
![h:300](assets/tab-fornecedor.svg)

</div>
</div>

<div class="dica">A entidade vira <strong>tabela</strong>; o <strong>composto</strong> ENDERECO é decomposto em colunas; o <strong>multivalorado</strong> {telefones} vira a tabela <code>TELEFONES</code> (com FK).</div>

<div class="vm">🖥️ <strong>SQL Power Architect:</strong> defina tipos e constraints na aba <em>Columns</em> (PK, NOT NULL); use <em>Add Relationship</em> para ligar TELEFONES.</div>

---

## Tradução E-R → Tabelas — Relacionamento 1:N

<div class="cols">
<div>

**Diagrama E-R**
![w:420](assets/er-notas.svg)

</div>
<div>

**Tabelas (lógico)**
![h:300](assets/tab-notas.svg)

</div>
</div>

<div class="dica">A PK do lado "1" (<code>numero</code>) vira <strong>FK</strong> em <code>ITENS_NF</code>; a PK de ITENS é <strong>composta</strong> (numero + item).</div>

<div class="vm">🖥️ <strong>SQL Power Architect:</strong> arraste de uma tabela para a outra — o sistema sugere a cardinalidade automaticamente.</div>

---

## Tradução E-R → Tabelas — Relacionamento N:M

<div class="cols">
<div>

**Diagrama E-R**
![w:420](assets/er-fornecimento.svg)

</div>
<div>

**Tabelas (lógico)**
![h:300](assets/tab-fornecimento.svg)

</div>
</div>

<div class="dica">O M:N vira a <strong>tabela associativa</strong> <code>FORNECIMENTOS</code>: as duas FKs formam a <strong>PK composta</strong>, mais o atributo <code>preco</code>.</div>

<div class="vm">🖥️ <strong>SQL Power Architect:</strong> para N:M, crie a tabela intermediária <em>manualmente</em> e ligue com dois relacionamentos 1:N.</div>

---

## Tradução E-R → Tabelas — Generalização

<div class="cols">
<div>

**Diagrama E-R**
![w:340](assets/er-pessoa.svg)

</div>
<div>

**Tabelas (lógico)**
![h:300](assets/tab-pessoa.svg)

</div>
</div>

<div class="dica">Uma <strong>tabela por tipo</strong>: <code>FISICAS</code> e <code>JURIDICAS</code> usam a mesma PK de <code>PESSOAS</code> (que também é <strong>FK</strong>) — herdam a identidade.</div>

<div class="vm">🖥️ <strong>SQL Power Architect:</strong> crie uma tabela por subtipo e marque a PK do supertipo como <em>PK e FK</em> na subtabela.</div>

---

## Tradução E-R → Tabelas — Auto-relacionamento

<div class="cols">
<div>

**Diagrama E-R**
![w:400](assets/er-funcionario.svg)

</div>
<div>

**Tabelas (lógico)**
![w:360](assets/tab-funcionario.svg)

</div>
</div>

<div class="dica"><code>codigo_gestor</code> é uma <strong>FK</strong> que aponta para a própria tabela <code>FUNCIONARIOS</code> (o gestor também é funcionário).</div>

<div class="vm">🖥️ <strong>SQL Power Architect:</strong> adicione a FK <code>codigo_gestor</code> referenciando a própria <code>FUNCIONARIOS</code> (auto-relacionamento).</div>

---

## Entidades regulares

- Cada entidade vira uma **tabela**.
- O **atributo determinante** vira a **PK**.
- Atributos **simples e monovalorados** viram **colunas**.

```sql
CREATE TABLE clientes (
    codigo        INT          PRIMARY KEY,
    razao_social  VARCHAR(100) NOT NULL,
    logradouro    VARCHAR(100) NOT NULL
);
```

---

## Atributos multivalorados e compostos

- **Multivalorado** (ex.: vários telefones) → **nova tabela** ligada por FK.
- **Composto** (ex.: endereço = logradouro + número + cidade) → **decompor** em colunas simples.

![h:330 center](assets/logica-multivalorado.svg)

---

## Entidades fracas

- Não têm identidade própria — dependem de uma entidade forte.
- Viram tabela com **PK composta**: a chave da entidade forte **+** um atributo diferenciador.

![h:400 center](assets/entidade-fraca.svg)

---

## Relacionamentos 1:1 e 1:N

- **1:1** — a PK de um lado vira **FK** no outro (onde fizer mais sentido).
- **1:N** — a PK do lado "1" vira **FK** na tabela do lado "N".

```sql
-- 1:N — cada oferta pertence a uma disciplina
ALTER TABLE ofertas
  ADD CONSTRAINT fk_oferta_disc
  FOREIGN KEY (disciplina) REFERENCES disciplinas(codigo);
```

---

## Relacionamento M:N → tabela associativa

Todo **muitos-para-muitos** vira uma **tabela associativa** com as duas FKs (que juntas formam a PK):

![h:450 center](assets/logica-mn.svg)

---

## Notação: Mermaid (diagrama como código)

O próprio diagrama vira **texto versionável** — os deste material são feitos assim:

```text
erDiagram
    ALUNOS ||--o{ MATRICULAS : faz
    DISCIPLINAS ||--o{ MATRICULAS : recebe
    ALUNOS { int matricula PK }
    MATRICULAS { int matricula PK  int codigo PK }
```

| Ponta (Mermaid) | Significado |
|---|---|
| `--o\|` | zero ou um |
| `--\|\|` | exatamente um |
| `--o{` | zero ou muitos |
| `--\|{` | um ou muitos |

---

## Mermaid × SQL Power Architect

<div class="cols">
<div>

**Mermaid** — quando…
- projeto **versionado** no Git
- documentação integrada (Markdown)
- equipe colaborativa
- diagramas simples a médios

</div>
<div>

**SQL Power Architect** — quando…
- modelos **grandes/complexos**
- **engenharia reversa** de um banco
- geração de DDL visual
- disponível na **VM LabDatabase**

</div>
</div>

<div class="vm">🖥️ Ambas as ferramentas estão na VM; use a que melhor se encaixa ao tamanho do projeto.</div>

<div class="dica">💡 <strong>Padrão da disciplina: Mermaid.</strong> Também aceitos: <strong>draw.io</strong> e <strong>brModelo</strong> (mesma notação crow's foot) — entregue a imagem/PDF e, no Mermaid, também o código.</div>

---

## Exercício

Pegue os ERs que você modelou na Parte 1 (**Controle de Pedidos** e **Jogos/RPG**) e:

1. Traduza cada entidade em **tabela** (defina PK).
2. Resolva os relacionamentos com **FK** ou **tabela associativa**.
3. Trate **multivalorados/compostos** e **entidades fracas**.
4. Escreva o **DDL** (`CREATE TABLE …`) — continua na **Unidade 5**.

---

## Bibliografia

- COUGO, P. **Modelagem Conceitual e Projeto de Bancos de Dados.** Campus, 1997.
- HEUSER, C. A. **Projeto de Banco de Dados.** 6ª ed. Bookman, 2009.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="modelagem-logica-avancada.html">Próximo →<small>Modelagem Lógica — Aprofundando</small></a>
