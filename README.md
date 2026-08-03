# Banco de Dados — FAESA

Material didático da disciplina **Banco de Dados** (código D009519) do **Prof. M.Sc. Howard Cruz Roatti** — FAESA Centro Universitário.

As apresentações são escritas em **[Marp](https://marp.app/)** (Markdown → slides), versionadas e com diagramas em **Mermaid**. Isso torna o material fácil de manter, versionar e reutilizar.

> 🎯 Este repositório reúne o material **modernizado** da disciplina (2026/2), unidade a unidade.

**Comece por aqui:** [Apresentação da Disciplina](unidades/00-apresentacao/apresentacao-disciplina.md) (ementa, avaliação, ambiente e bibliografia).

## Índice por unidade

| Unidade | Tópico | Status |
|---|---|---|
| 1 | [Conceitos de Banco de Dados](unidades/01-conceitos/conceitos-bd.md) | ✅ |
| 2 | [Arquitetura para Banco de Dados](unidades/02-arquitetura/arquitetura-bd.md) | ✅ |
| 3 | Modelo Relacional — [Introdução (Codd)](unidades/03-relacional/introducao-relacional.md) · [Álgebra](unidades/03-relacional/algebra-relacional.md) · [Views, SQL e Indexação](unidades/03-relacional/views-sql-indexacao.md) | ✅ |
| 4 | Modelagem Relacional — [Conceitual (ER)](unidades/04-modelagem/modelagem-conceitual.md) · [Lógica](unidades/04-modelagem/modelagem-logica.md) · [Normalização](unidades/04-modelagem/normalizacao.md) | ✅ |
| 5 | [Linguagem SQL (DDL/DML/DQL)](unidades/05-sql/linguagem-sql.md) · [Procedimentos Armazenados](unidades/05-sql/procedimentos-armazenados.md) | ✅ |
| 6 | [Processamento de Transações](unidades/06-transacoes/transacoes.md) | ✅ |
| 7 | Bancos de Dados NoSQL — [Conceitos](unidades/07-nosql/nosql-conceitos.md) · [MongoDB na VM](unidades/07-nosql/mongodb-na-vm.md) · [De SQL para MongoDB](unidades/07-nosql/de-sql-para-mongodb.md) | ✅ |

*(⏳ = em produção · ✅ = publicado)*

## Como visualizar / renderizar

Os slides ficam em `unidades/<unidade>/*.md`; os diagramas em `unidades/<unidade>/assets/*.mmd` (Mermaid, versionável).

**Build de tudo** (renderiza `.mmd → .svg` e `.md → .html` ao lado dos fontes):

```bash
./build.sh                              # tudo
./build.sh unidades/06-transacoes/transacoes.md   # um deck só
```

**Manual**, se preferir:

```bash
mmdc -i assets/diag.mmd -o assets/diag.svg -t neutral -b transparent   # diagrama
marp deck.md --theme themes/faesa.css --html -o deck.html              # slides
marp deck.md --theme themes/faesa.css --pdf                            # ou PDF/PPTX
```

Requisitos: [Node.js](https://nodejs.org), `npm i -g @marp-team/marp-cli @mermaid-js/mermaid-cli`. No VS Code, a extensão **Marp for VS Code** dá pré-visualização ao vivo.

### Convenções do template
- Capa: `<!-- _class: capa -->` · Divisória de seção: `<!-- _class: secao -->`
- Caixas: `<div class="dica">`, `<div class="aviso">`, `<div class="vm">`
- Diagramas: escreva em `assets/nome.mmd` e referencie `![w:640 center](assets/nome.svg)`
- Veja o modelo completo em [`_template/exemplo.md`](_template/exemplo.md).

## Ambiente de prática

Os exemplos de SQL e MongoDB são pensados para rodar na **VM LabDatabase** da disciplina (Docker com Oracle, PostgreSQL, MySQL e MongoDB). Quando pertinente, os slides trazem notas de portabilidade entre SGBDs.

## Licença

Material licenciado sob **[CC BY 4.0](LICENSE)** — você pode compartilhar e adaptar, inclusive comercialmente, desde que dê o devido crédito.

> Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2
