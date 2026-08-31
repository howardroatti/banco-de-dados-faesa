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

<!-- _class: secao -->

# Exercícios de Consolidação
### Normalização · 8 questões estilo ENADE
#### Dependências, anomalias, 1FN → BCNF e desnormalização — responda antes de virar o slide!

---

## Q1 — Anomalias

Numa tabela única `PEDIDO`, os dados do fornecedor (nome, cidade) ficam **repetidos em cada linha** de pedido. Ao mudar a cidade de um fornecedor, é preciso alterar **várias linhas**, e um esquecimento deixa registros divergentes.

Esse problema é uma:

A) anomalia de **inserção**.
B) anomalia de **atualização**.
C) anomalia de **exclusão**.
D) violação da **1FN** por atributo multivalorado.

---

## Q1 — Gabarito: **B**

**Por que B:** repetir o mesmo dado em muitas linhas obriga a atualizá-lo em **todos** os pontos; falhar em um gera **inconsistência** — é a clássica **anomalia de atualização**.

- **A** — errada: a de **inserção** ocorre quando não se consegue registrar um fato (ex.: cadastrar um fornecedor **sem** um pedido).
- **C** — errada: a de **exclusão** ocorre quando apagar uma linha **perde** dados de outra entidade (apagar o último pedido some com o fornecedor).
- **D** — errada: o problema aqui é **redundância**, não célula com vários valores.

---

## Q2 — Dependência funcional

Considere a dependência funcional `CPF → nome`.

Assinale a interpretação **correta**.

A) `CPF` e `nome` são **independentes** entre si.
B) Saber o **nome** permite determinar o **CPF**.
C) Para um mesmo `CPF`, o **nome é sempre o mesmo** — o CPF **determina** o nome.
D) `CPF` e `nome`, juntos, são obrigatoriamente uma **chave candidata**.

---

## Q2 — Gabarito: **C**

**Por que C:** `A → B` significa que cada valor de `A` está associado a **um único** valor de `B`. Logo, `CPF → nome`: dado o CPF, o nome fica determinado.

- **A** — errada: existir a DF significa justamente que **há** dependência.
- **B** — errada: a relação **não** é simétrica; `nome → CPF` não está implicado (há nomes repetidos).
- **D** — errada: a DF não obriga o par a ser chave; `CPF` sozinho já determina o nome.

---

## Q3 — 1ª Forma Normal

Uma tabela tem a coluna `telefones` guardando `"9999-1111 / 9999-2222"` numa **única célula**. Para colocá-la na **1FN**, deve-se:

A) manter como está — a 1FN **não** trata de atomicidade.
B) criar colunas `telefone2`, `telefone3`… conforme a necessidade.
C) concatenar todos os telefones num **texto padronizado**.
D) garantir **valores atômicos**, tipicamente movendo os telefones para uma **tabela própria** ligada por chave estrangeira.

---

## Q3 — Gabarito: **D**

**Por que D:** a 1FN exige **valores atômicos** e **sem grupos repetitivos**. Um atributo multivalorado (vários telefones) vira uma **tabela própria** ligada por FK.

- **A** — errada: atomicidade é **exatamente** o que a 1FN garante.
- **B** — errada: `telefone2, telefone3…` recria um **grupo repetitivo** (agora em colunas) e desperdiça espaço.
- **C** — errada: concatenar mantém o valor **não atômico** — não dá para consultar/filtrar um telefone isolado.

---

## Q4 — 2ª Forma Normal

Em `ITEM_PEDIDO(num_pedido, cod_produto, qtd, nome_produto)`, com **chave composta** `(num_pedido, cod_produto)`, nota-se que `nome_produto` depende **apenas** de `cod_produto`.

Sobre essa tabela, é **correto** afirmar que:

A) está na **2FN**, pois todos os atributos dependem da chave.
B) **viola a 2FN**: `nome_produto` tem **dependência parcial** (depende só de parte da chave).
C) **viola a 3FN** por dependência **transitiva**.
D) **não pode** ser normalizada.

---

## Q4 — Gabarito: **B**

**Por que B:** na 2FN, todo atributo não-chave depende da **chave inteira**. `nome_produto` depende só de `cod_produto` (parte da chave composta) → **dependência parcial** → correção: mover para a tabela `PRODUTO(cod_produto, nome_produto)`.

- **A** — errada: `qtd` depende da chave inteira, mas `nome_produto` **não** — por isso viola.
- **C** — errada: aqui a dependência é **parcial** (com parte da chave), não **transitiva** (entre não-chaves).
- **D** — errada: decompor resolve — a normalização é justamente isso.

---

## Q5 — 3ª Forma Normal

Em `FUNCIONARIO(matricula, nome, cod_depto, nome_depto)`, com PK **`matricula`**, observa-se que `nome_depto` depende de `cod_depto` (que **não** é chave).

Isso caracteriza:

A) **dependência parcial** (viola a 2FN).
B) violação da **1FN**.
C) **dependência transitiva** (viola a 3FN).
D) a tabela já está corretamente na **3FN**.

---

## Q5 — Gabarito: **C**

**Por que C:** `matricula → cod_depto → nome_depto`: um atributo não-chave (`nome_depto`) depende de **outro atributo não-chave** (`cod_depto`) → **dependência transitiva** → correção: criar `DEPARTAMENTO(cod_depto, nome_depto)`.

- **A** — errada: a chave é **simples** (`matricula`); sem chave composta **não** há dependência parcial.
- **B** — errada: os valores são **atômicos** — a 1FN está satisfeita.
- **D** — errada: justamente por causa da transitiva, **não** está na 3FN.

---

## Q6 — A progressão das formas normais

Assinale a alternativa que associa **corretamente** cada forma normal à dependência que ela elimina.

A) **1FN** exige valores atômicos; **2FN** elimina dependências **parciais**; **3FN** elimina dependências **transitivas**.
B) **2FN** elimina dependências **transitivas**; **3FN** elimina dependências **parciais**.
C) **1FN** elimina dependências **transitivas**; **3FN** elimina grupos repetitivos.
D) A **BCNF** é uma regra **mais fraca** que a 3FN.

---

## Q6 — Gabarito: **A**

**Por que A:** é a sequência correta — **1FN** (atômico, sem grupos repetitivos) → **2FN** (sem dependência **parcial**) → **3FN** (sem dependência **transitiva**).

- **B** — errada: **inverte** os papéis de 2FN e 3FN.
- **C** — errada: grupos repetitivos são tratados na **1FN**, não na 3FN.
- **D** — errada: a **BCNF** é **mais forte** (mais restritiva) que a 3FN.

---

## Q7 — Forma Normal de Boyce-Codd

Em `TURMA(aluno, disciplina, professor)`, cada **professor leciona uma única disciplina** (`professor → disciplina`) e um aluno pode ter vários professores. A tabela está na **3FN**, mas **viola a BCNF**.

O motivo é que:

A) há um atributo **multivalorado**.
B) a **chave primária admite nulos**.
C) existe **dependência parcial** de `disciplina`.
D) `professor` **determina** `disciplina`, mas `professor` **não é superchave**.

---

## Q7 — Gabarito: **D**

**Por que D:** na BCNF, **toda** dependência `X → Y` exige que `X` seja **superchave**. Como `professor → disciplina` e `professor` **não** é superchave, a BCNF é violada → correção: `PROFESSOR_DISC(professor, disciplina)` + `ALUNO_PROF(aluno, professor)`.

- **A** — errada: não há atributo multivalorado; os valores são atômicos.
- **B** — errada: a PK não admite nulos, e não é disso que trata a BCNF.
- **C** — errada: é exatamente por **não** ser dependência parcial/transitiva que ela **passa** na 3FN — o problema só aparece na BCNF.

---

## Q8 — Desnormalização

Sobre **desnormalização**, assinale a alternativa **correta**.

A) Deve ser aplicada **sempre**, pois melhora a **consistência**.
B) É **sinônimo** de violar a 1FN por descuido.
C) É a introdução **controlada** de redundância para **acelerar leituras**, assumindo o custo de manter os dados coerentes.
D) **Elimina** a necessidade de índices.

---

## Q8 — Gabarito: **C**

**Por que C:** desnormalizar é **reintroduzir redundância de propósito** (relatórios, dashboards, *data warehouse*) para reduzir JOINs em leituras intensas — trocando consistência/simplicidade por **velocidade**, de forma consciente.

- **A** — errada: ela **piora** a consistência (mais redundância); só compensa **onde se mede** ganho.
- **B** — errada: não é descuido nem violação de 1FN — é uma decisão **deliberada** de projeto físico.
- **D** — errada: índices continuam necessários; são coisas **independentes**.

---

<div class="dica">💡 <strong>Gabarito geral:</strong> 1B · 2C · 3D · 4B · 5C · 6A · 7D · 8C</div>

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
