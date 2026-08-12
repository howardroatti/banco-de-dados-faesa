---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html) · [◀ Álgebra](algebra-relacional.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Lista de Exercícios — Álgebra Relacional

## 2 exercícios por operação · com gabarito

**Unidade 3** · Banco de Dados · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## As 3 tabelas (use estas em todos os exercícios)

<div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;font-size:0.82em;align-items:start;">
<div>

**ALUNO**
| matricula | nome | curso |
|--|--|--|
| 1 | Ana | CC |
| 2 | Bruno | SI |
| 3 | Carla | CC |
| 4 | Diego | SI |
| 5 | Elisa | CC |

</div>
<div>

**DISCIPLINA**
| cod | nome | creditos |
|--|--|--|
| 10 | Banco de Dados | 4 |
| 20 | Redes | 2 |
| 30 | Algoritmos | 4 |
| 40 | Ética | 2 |

</div>
<div>

**CURSA**
| matricula | cod | nota |
|--|--|--|
| 1 | 10 | 8 |
| 1 | 20 | 6 |
| 1 | 30 | 7 |
| 2 | 10 | 9 |
| 3 | 10 | 7 |
| 3 | 30 | 5 |
| 4 | 20 | 10 |

</div>
</div>

<div class="dica">💡 Elisa (5) não cursa nada; Ética (40) ninguém cursa — úteis nas <strong>junções externas</strong> e na <strong>diferença</strong>.</div>

---

## Exercícios — Seleção (σ), Projeção (Π), União (∪)

**1. Seleção (σ)**
&nbsp;&nbsp;a) Os alunos do curso **CC**.
&nbsp;&nbsp;b) As disciplinas com **4 créditos**.

**2. Projeção (Π)**
&nbsp;&nbsp;a) Apenas os **nomes** de todos os alunos.
&nbsp;&nbsp;b) O **código e o nome** de cada disciplina.

**3. União (∪)**
&nbsp;&nbsp;a) Matrículas que cursam a disciplina **10 ou a 20**.
&nbsp;&nbsp;b) Matrículas do curso **CC** ou que tiraram **nota 10** em alguma disciplina.

---

## Exercícios — Interseção (∩), Diferença (−), Produto Cartesiano (×)

**4. Interseção (∩)**
&nbsp;&nbsp;a) Matrículas que cursam a **10 e a 20**.
&nbsp;&nbsp;b) Matrículas que cursam a **10 e** são do curso **CC**.

**5. Diferença (−)**
&nbsp;&nbsp;a) Matrículas que cursam a **10, mas não a 20**.
&nbsp;&nbsp;b) Matrículas de alunos que **não cursam nenhuma** disciplina.

**6. Produto Cartesiano (×)**
&nbsp;&nbsp;a) Todas as combinações de **ALUNO × DISCIPLINA** — quantas linhas?
&nbsp;&nbsp;b) Cada aluno de **SI** com cada disciplina de **2 créditos**.

---

## Exercícios — Junções

**7. Junção Natural (⋈)**
&nbsp;&nbsp;a) Matrícula, **nome do aluno** e nota (ALUNO ⋈ CURSA).
&nbsp;&nbsp;b) **Nome do aluno** e **nome da disciplina** que ele cursa (as 3 tabelas).

**8. Junção Externa Esquerda/Direita (⟕ / ⟖)**
&nbsp;&nbsp;a) **Todos os alunos** e suas disciplinas, inclusive quem não cursa nada.
&nbsp;&nbsp;b) **Todas as disciplinas** e quem as cursa, inclusive as sem alunos.

**9. Junção Externa Completa (⟗)**
&nbsp;&nbsp;a) **DISCIPLINA ⟗ CURSA** (por cod): quem aparece com **nulos** e por quê?
&nbsp;&nbsp;b) **ALUNO ⟗ CURSA** (por matrícula): quem aparece com **nulos**?

---

## Exercícios — Agregação e Divisão

**10. Funções Agregadas (Ƒ)**
&nbsp;&nbsp;a) **Quantas** disciplinas existem e qual a **média de créditos**?
&nbsp;&nbsp;b) A **maior** e a **menor** nota de CURSA.

**11. Agregação com Agrupamento**
&nbsp;&nbsp;a) A **média de nota por disciplina** (cod).
&nbsp;&nbsp;b) **Quantas disciplinas cada aluno** cursa (por matrícula).

**12. Divisão (÷)**
&nbsp;&nbsp;a) Matrículas que cursam **todas as disciplinas de 4 créditos**.
&nbsp;&nbsp;b) Matrículas que cursam **todas as disciplinas que a Ana (1) cursa**.

---

<!-- _class: secao -->

# Gabarito
### Confira depois de tentar

---

## Gabarito — 1. Seleção (σ)

**a) Alunos do curso CC** · `σ curso='CC' (ALUNO)`
- A seleção filtra **linhas**: percorra ALUNO e mantenha as que têm `curso = 'CC'`.
- **Resultado:** Ana (1), Carla (3), Elisa (5).

**b) Disciplinas com 4 créditos** · `σ creditos=4 (DISCIPLINA)`
- Mantenha as linhas com `creditos = 4`.
- **Resultado:** Banco de Dados (10), Algoritmos (30).

---

## Gabarito — 2. Projeção (Π)

**a) Nomes dos alunos** · `Π nome (ALUNO)`
- A projeção fica só com a(s) **coluna(s)** pedida(s) e **elimina duplicatas** (aqui não há repetição).
- **Resultado:** Ana, Bruno, Carla, Diego, Elisa.

**b) Código e nome das disciplinas** · `Π cod, nome (DISCIPLINA)`
- Fique com as colunas `cod` e `nome`.
- **Resultado:** (10, BD), (20, Redes), (30, Algoritmos), (40, Ética).

---

## Gabarito — 3. União (∪)

**a) Cursam a 10 ou a 20** · `Π matricula(σ cod=10 (CURSA)) ∪ Π matricula(σ cod=20 (CURSA))`
- `σ cod=10` → matrículas **{1, 2, 3}**; `σ cod=20` → **{1, 4}**.
- União = tudo, **sem repetir** o 1. **Resultado:** **{1, 2, 3, 4}**.

**b) Curso CC ou nota 10** · `Π matricula(σ curso='CC' (ALUNO)) ∪ Π matricula(σ nota=10 (CURSA))`
- Curso CC → **{1, 3, 5}**; nota 10 → **{4}**.
- **Resultado:** **{1, 3, 4, 5}**. *(Exige união-compatibilidade: os dois lados projetam só `matricula`.)*

---

## Gabarito — 4. Interseção (∩)

**a) Cursam a 10 e a 20** · `Π matricula(σ cod=10 (CURSA)) ∩ Π matricula(σ cod=20 (CURSA))`
- {1, 2, 3} ∩ {1, 4} = só quem está nas **duas** listas.
- **Resultado:** **{1}** (só a Ana cursa as duas).

**b) Cursam a 10 e são do curso CC** · `Π matricula(σ cod=10 (CURSA)) ∩ Π matricula(σ curso='CC' (ALUNO))`
- {1, 2, 3} ∩ {1, 3, 5}.
- **Resultado:** **{1, 3}** (Ana e Carla).

---

## Gabarito — 5. Diferença (−)

**a) Cursam a 10, mas não a 20** · `Π matricula(σ cod=10 (CURSA)) − Π matricula(σ cod=20 (CURSA))`
- {1, 2, 3} **−** {1, 4}: tire do primeiro quem aparece no segundo (o **1** sai).
- **Resultado:** **{2, 3}**. *(Não é comutativa!)*

**b) Alunos que não cursam nada** · `Π matricula(ALUNO) − Π matricula(CURSA)`
- Todos {1, 2, 3, 4, 5} **−** quem tem linha em CURSA {1, 2, 3, 4}.
- **Resultado:** **{5}** (Elisa).

---

## Gabarito — 6. Produto Cartesiano (×)

**a) ALUNO × DISCIPLINA** · `ALUNO × DISCIPLINA`
- Cada linha de ALUNO combina com **cada** linha de DISCIPLINA. Nº de linhas = |ALUNO| × |DISCIPLINA|.
- **Resultado:** **5 × 4 = 20 linhas** (e 3 + 3 = 6 colunas).

**b) Alunos de SI × disciplinas de 2 créditos** · `σ curso='SI' (ALUNO) × σ creditos=2 (DISCIPLINA)`
- SI = {Bruno, Diego} (2); 2 créditos = {Redes, Ética} (2).
- **Resultado:** **2 × 2 = 4 linhas** — Bruno-Redes, Bruno-Ética, Diego-Redes, Diego-Ética.

---

## Gabarito — 7. Junção Natural (⋈)

**a) Matrícula, nome e nota** · `Π matricula, nome, nota (ALUNO ⋈ CURSA)`
- Casa ALUNO e CURSA pela `matricula` **igual**; a junção **interna descarta** quem não casa → **Elisa fica de fora**. 7 linhas (uma por linha de CURSA).
- **Resultado:** (1,Ana,8) (1,Ana,6) (1,Ana,7) (2,Bruno,9) (3,Carla,7) (3,Carla,5) (4,Diego,10).

**b) Nome do aluno e da disciplina** · `Π nome, nome_disc ((ALUNO ⋈ CURSA) ⋈ DISCIPLINA)`
- Junta as três (por `matricula`, depois por `cod`).
- **Resultado:** Ana-BD, Ana-Redes, Ana-Algoritmos, Bruno-BD, Carla-BD, Carla-Algoritmos, Diego-Redes.

---

## Gabarito — 8. Junção Externa Esquerda / Direita (⟕ / ⟖)

**a) Todos os alunos e suas disciplinas** · `ALUNO ⟕ CURSA`
- A externa à esquerda **preserva todas** as linhas de ALUNO; quem não cursa recebe **nulos**.
- **Resultado:** as 7 linhas da natural **+ Elisa (5)** com `cod` e `nota` **nulos** (8 linhas).

**b) Todas as disciplinas e quem as cursa** · `DISCIPLINA ⟕ CURSA`
- Preserva **todas** as disciplinas; a que ninguém cursa recebe nulos.
- **Resultado:** BD, Redes e Algoritmos com seus alunos **+ Ética (40)** com `matricula`/`nota` **nulas**.

---

## Gabarito — 9. Junção Externa Completa (⟗)

**a) DISCIPLINA ⟗ CURSA (por cod)**
- A completa preserva os **sem par dos dois lados**. Só a **Ética (40)** não é cursada → nulos. Nenhuma linha de CURSA fica órfã (**todo `cod` existe** em DISCIPLINA).
- **Resultado:** só **Ética com nulos** (aqui a completa = a externa à esquerda).

**b) ALUNO ⟗ CURSA (por matrícula)**
- **Elisa (5)** não cursa nada → nulos. Nenhuma linha de CURSA fica órfã (**toda `matricula` existe** em ALUNO).
- **Resultado:** só **Elisa com nulos**. *(Como CURSA aponta para ALUNO/DISCIPLINA por chaves válidas, não há órfãos daquele lado.)*

---

## Gabarito — 10. Funções Agregadas (Ƒ)

**a) Quantas disciplinas e média de créditos** · `Ƒ count(cod), avg(creditos) (DISCIPLINA)`
- Conta as linhas (4) e faz a média dos créditos: (4 + 2 + 4 + 2) ÷ 4 = 12 ÷ 4.
- **Resultado:** **count = 4**, **avg = 3**.

**b) Maior e menor nota** · `Ƒ max(nota), min(nota) (CURSA)`
- Notas = 8, 6, 7, 9, 7, 5, 10.
- **Resultado:** **max = 10**, **min = 5**.

---

## Gabarito — 11. Agregação com Agrupamento

**a) Média de nota por disciplina** · `cod Ƒ avg(nota) (CURSA)`
- Agrupe por `cod` e faça a média **dentro** de cada grupo:
- **10** → (8+9+7)/3 = **8** · **20** → (6+10)/2 = **8** · **30** → (7+5)/2 = **6**. *(Ética/40 não aparece — sem linhas em CURSA.)*

**b) Quantas disciplinas por aluno** · `matricula Ƒ count(cod) (CURSA)`
- Agrupe por `matricula` e conte:
- **1** → 3 · **2** → 1 · **3** → 2 · **4** → 1. *(Elisa/5 não aparece.)*

---

## Gabarito — 12. Divisão (÷)

**a) Cursam todas as disciplinas de 4 créditos** · `Π matricula, cod (CURSA) ÷ Π cod (σ creditos=4 (DISCIPLINA))`
- Divisor = **{10, 30}**. Fique com quem cursa **10 E 30**: Ana(1) ✓ · Bruno(2) só 10 ✗ · Carla(3) ✓ · Diego(4) 20 ✗.
- **Resultado:** **{1, 3}** (Ana e Carla).

**b) Cursam todas as disciplinas que a Ana cursa** · `Π matricula, cod (CURSA) ÷ Π cod (σ matricula=1 (CURSA))`
- Divisor = disciplinas de Ana = **{10, 20, 30}**. Quem cursa **as três**? Só a **Ana**.
- **Resultado:** **{1}**.

---

<!-- _class: secao -->

# Bom estudo! 🚀
### Tente sem o gabarito primeiro; depois confira.

<a class="proximo" href="algebra-relacional.html">◀ Voltar à Álgebra Relacional<small>a apresentação</small></a>
<a class="proximo" href="../../index.html">☰ Índice<small>todas as unidades</small></a>
