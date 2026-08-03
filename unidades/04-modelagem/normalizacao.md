---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Normalização
## 1FN, 2FN, 3FN, BCNF — e quando desnormalizar

**Unidade 4** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Por que normalizar

- Eliminar **redundância** e as **anomalias** de inserção, atualização e exclusão.
- Baseia-se em **dependências funcionais**: `A → B` (o valor de A **determina** o de B).
- Um projeto normalizado é mais **consistente** e fácil de manter.

<div class="dica">💡 Normalizar = decompor tabelas "gordas" em tabelas menores e bem definidas, <strong>sem perder informação</strong>.</div>

---

## Tabela não normalizada (exemplo PEDIDO)

Uma tabela com **grupos repetitivos** e atributos **compostos**:

| Num | Data | Fornec. | CNPJ | Endereço | Produtos (cód, nome, qtd, preço)… |
|--|--|--|--|--|--|
| 003 | 20-jan | Software | 123 | Av. Lapa 777, RJ | 033A DOS 4 130 · 002M Corel 1 499 |

<div class="aviso">Problemas: grupos repetitivos, endereço não atômico, dados de fornecedor repetidos a cada pedido.</div>

---

## 1ª Forma Normal (1FN)

Uma tabela está na 1FN se:
- todas as células têm **valores atômicos** (indivisíveis);
- **não há grupos repetitivos**;
- há uma **chave** que garante unicidade das linhas.

**Como obter:** decompor atributos compostos (endereço → logradouro, número, cidade, UF, CEP) e **separar os grupos repetitivos** em linhas/tabela própria.

---

## 1FN — resultado

`PEDIDO` (dados atômicos) + linhas por produto:

| Num | Data | CNPJ | Logradouro | Nº | Cidade | UF | Cód.Prod | Nome | Qtd | Preço |
|--|--|--|--|--|--|--|--|--|--|--|
| 003 | 20-jan | 123 | Av. Lapa | 777 | RJ | RJ | 033A | DOS | 4 | 130 |
| 003 | 20-jan | 123 | Av. Lapa | 777 | RJ | RJ | 002M | Corel | 1 | 499 |

**Chave:** (Num + Cód.Prod).

---

## 2ª Forma Normal (2FN)

Está na 2FN se: está na **1FN** **e** todo atributo não-chave depende da **chave inteira** (elimina **dependência parcial**).

- Só se aplica a **chaves compostas**.
- Na tabela acima: `Nome do Produto` depende **só** de `Cód.Prod` (parte da chave) → **dependência parcial**.

---

## 2FN — resultado

Separa o que depende só de parte da chave:

<div class="cols">
<div>

**ITEM_PEDIDO** (Num + Cód.Prod)
| Num | Cód.Prod | Qtd | Preço |
|--|--|--|--|
| 003 | 033A | 4 | 130 |
| 003 | 002M | 1 | 499 |

</div>
<div>

**PRODUTO** (Cód.Prod)
| Cód.Prod | Nome |
|--|--|
| 033A | DOS |
| 002M | Corel |

</div>
</div>

`PEDIDO` (Num) fica com Data, CNPJ, endereço…

---

## 3ª Forma Normal (3FN)

Está na 3FN se: está na **2FN** **e** nenhum atributo não-chave depende de **outro atributo não-chave** (elimina **dependência transitiva**).

- Em `PEDIDO`: `Nome Fornec.`, `Logradouro`, `Cidade`… dependem de **CNPJ**, que **não é** a chave (Num) → **transitiva**.

---

## 3FN — resultado

<div class="cols">
<div>

**PEDIDO** (Num)
| Num | Data | CNPJ |
|--|--|--|
| 003 | 20-jan | 123 |
| 004 | 27-jan | 234 |

</div>
<div>

**FORNECEDOR** (CNPJ)
| CNPJ | Nome | Cidade | UF |
|--|--|--|--|
| 123 | Software | RJ | RJ |
| 234 | Brasoft | SP | SP |

</div>
</div>

<div class="dica">💡 Regra de bolso: cada atributo depende <strong>da chave, da chave inteira e de nada além da chave</strong>.</div>

---

## Forma Normal de Boyce-Codd (BCNF)

Um reforço da 3FN: para **toda** dependência funcional `X → Y`, `X` deve ser uma **superchave**.

- Trata casos com **múltiplas chaves candidatas sobrepostas** que a 3FN deixa passar.
- **Exemplo:** `TURMA(aluno, disciplina, professor)`, onde cada `professor` leciona **uma** disciplina (`professor → disciplina`). Está em 3FN, mas `professor` não é superchave → **viola a BCNF**.
- **Correção:** decompor em `PROFESSOR_DISC(professor, disciplina)` e `ALUNO_PROF(aluno, professor)`.

---

## Além da BCNF (visão geral)

- **4FN** — remove **dependências multivaloradas** (atributos multivalorados independentes na mesma tabela).
- **5FN** — trata dependências de junção (casos raros).

<div class="aviso">Na prática, chegar até <strong>3FN/BCNF</strong> resolve a grande maioria dos projetos.</div>

---

## Desnormalizar — quando e por quê

- Normalização favorece **consistência**; mas muitos **JOINs** podem custar desempenho em leituras intensas.
- **Desnormalização** = reintroduzir redundância **controlada** para acelerar leituras (relatórios, dashboards, *data warehouse*).
- Faça de forma **consciente**: você troca simplicidade/consistência por velocidade — e assume a responsabilidade de manter os dados coerentes.

<div class="dica">💡 Normalize primeiro; desnormalize depois, <strong>só onde medir</strong> que compensa.</div>

---

## Bibliografia

- COUGO, P. **Modelagem Conceitual e Projeto de Bancos de Dados.** Campus, 1997.
- DATE, C. J. **Introdução a Sistemas de Banco de Dados.** 8ª ed. Elsevier, 2004.
- ELMASRI, R.; NAVATHE, S. B. **Sistemas de Banco de Dados.** 7ª ed. Pearson, 2019.

---

<!-- _class: secao -->

# Dúvidas?
### howard.cruz@faesa.br


<a class="proximo" href="../05-sql/linguagem-sql.html">Próxima unidade →<small>Unidade 5 — Linguagem SQL</small></a>
