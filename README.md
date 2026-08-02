# Banco de Dados — FAESA

Material didático da disciplina **Banco de Dados** (código D009519) do **Prof. M.Sc. Howard Cruz Roatti** — FAESA Centro Universitário.

As apresentações são escritas em **[Marp](https://marp.app/)** (Markdown → slides), versionadas e com diagramas em **Mermaid**. Isso torna o material fácil de manter, versionar e reutilizar.

> 🎯 Este repositório está em **modernização por ondas** (2026/2). Os decks vão sendo publicados/atualizados unidade a unidade.

## Índice por unidade

| Unidade | Tópico | Status |
|---|---|---|
| 1 | Conceitos de Banco de Dados | ⏳ |
| 2 | Arquitetura para Banco de Dados | ⏳ |
| 3 | Introdução a Banco de Dados Relacional (+ Álgebra Relacional) | ⏳ |
| 4 | Modelagem Relacional de Dados (conceitual + lógica com Mermaid) | ⏳ |
| 5 | Linguagem SQL (DDL/DML/consultas) + [Procedimentos Armazenados](unidades/05-sql/procedimentos-armazenados.md) | ✅ |
| 6 | [Processamento de Transações](unidades/06-transacoes/transacoes.md) | ✅ |
| 7 | Bancos de Dados NoSQL / não estruturados | ⏳ |

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
