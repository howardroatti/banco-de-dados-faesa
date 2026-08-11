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

## Gabarito — 1 a 6

**1a)** σ *curso='CC'* (ALUNO) → **Ana, Carla, Elisa**. **1b)** σ *creditos=4* (DISCIPLINA) → **BD (10), Algoritmos (30)**.
**2a)** Π *nome* (ALUNO) → **Ana, Bruno, Carla, Diego, Elisa**. **2b)** Π *cod, nome* (DISCIPLINA) → as 4 disciplinas.
**3a)** Π *mat*(σ *cod=10*) ∪ Π *mat*(σ *cod=20*) → **{1, 2, 3, 4}**. **3b)** Π *mat*(σ *curso=CC* ALUNO) ∪ Π *mat*(σ *nota=10* CURSA) → **{1, 3, 4, 5}**.
**4a)** {1,2,3} ∩ {1,4} → **{1}**. **4b)** {1,2,3} ∩ {1,3,5} → **{1, 3}**.
**5a)** {1,2,3} − {1,4} → **{2, 3}**. **5b)** Π *mat*(ALUNO) − Π *mat*(CURSA) → **{5}** (Elisa).
**6a)** 5 × 4 = **20 linhas**. **6b)** SI = {Bruno, Diego}; 2 créditos = {Redes, Ética} → 2 × 2 = **4 linhas**.

---

## Gabarito — 7 a 12

**7a)** ALUNO ⋈ CURSA → **7 linhas** (uma por curso; Elisa não entra na natural). **7b)** (ALUNO ⋈ CURSA) ⋈ DISCIPLINA → **Ana-BD, Ana-Redes, Ana-Algoritmos, Bruno-BD, Carla-BD, Carla-Algoritmos, Diego-Redes**.
**8a)** ALUNO ⟕ CURSA → os 7 + **Elisa com nulos**. **8b)** DISCIPLINA ⟕ CURSA → BD/Redes/Algoritmos com alunos + **Ética com nulos**.
**9a)** **Ética (40)** aparece com nulos (ninguém cursa); nenhum CURSA fica órfão (todo cod existe). **9b)** **Elisa (5)** aparece com nulos (não cursa nada).
**10a)** count = **4**; avg(creditos) = (4+2+4+2)/4 = **3**. **10b)** max = **10**, min = **5**.
**11a)** *cod* Ƒ *avg(nota)* → **10 = 8 · 20 = 8 · 30 = 6** (Ética sem notas). **11b)** *mat* Ƒ *count(cod)* → **1 = 3 · 2 = 1 · 3 = 2 · 4 = 1**.
**12a)** ÷ pelas de 4 créditos {10,30} → **{1, 3}** (Ana e Carla cursam ambas). **12b)** ÷ pelas de Ana {10,20,30} → **{1}** (só a Ana cursa todas).

---

<!-- _class: secao -->

# Bom estudo! 🚀
### Tente sem o gabarito primeiro; depois confira.

<a class="proximo" href="algebra-relacional.html">◀ Voltar à Álgebra Relacional<small>a apresentação</small></a>
<a class="proximo" href="../../index.html">☰ Índice<small>todas as unidades</small></a>
