---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Simulado estilo ENADE · Banco de Dados + Análise de Dados · 2026/2'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Simulado estilo ENADE

## Banco de Dados + Análise de Dados Aplicada à Computação

**20 questões de múltipla escolha** · CC e SI · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## Como usar

- **20 questões** no formato do ENADE (situação-problema → comando → 5 alternativas **A–E**, uma correta).
- **10 de Banco de Dados** (Q1–Q10) e **10 de Análise de Dados** (Q11–Q20).
- Tente responder **antes** de avançar para o slide de **gabarito comentado**.
- Nível cognitivo de **aplicar/analisar** — como o ENADE cobra (Resolução CNE/CES nº 5/2016; edições 2023 e 2026).

<div class="dica">💡 Bom para simulado, revisão e para treinar o estilo de item do INEP.</div>

---

<!-- _class: secao -->

# Parte I — Banco de Dados
### Q1 a Q10

---

## Q1 — Álgebra relacional

Considere `Aluno(Matricula, Nome, IdCurso)` e `Curso(IdCurso, NomeCurso)`. Deseja-se obter **apenas os nomes** dos alunos matriculados no curso **"Sistemas de Informação"**. Assinale a expressão correta.

a) π<sub>Nome</sub>( Aluno ⋈ Curso )
b) σ<sub>Nome</sub>( π<sub>NomeCurso='Sistemas de Informação'</sub>( Aluno ⋈ Curso ) )
c) π<sub>Nome</sub>( σ<sub>NomeCurso='Sistemas de Informação'</sub>( Aluno ⋈ Curso ) )
d) π<sub>NomeCurso</sub>( σ<sub>Nome='Sistemas de Informação'</sub>( Aluno ⋈ Curso ) )
e) σ<sub>NomeCurso='Sistemas de Informação'</sub>( Aluno ⋈ Curso )

---

## Q1 — Gabarito: **c)**

π<sub>Nome</sub>( σ<sub>NomeCurso='...'</sub>( Aluno ⋈ Curso ) )

- **σ** (seleção) filtra **linhas**; **π** (projeção) escolhe **colunas** (aqui, só `Nome`); a junção casa as chaves.
- Sem seleção (a) traz todos; papéis σ/π trocados (b); atributo errado (d); e **sem projeção** (e) devolve a tupla inteira — não "apenas os nomes".

---

## Q2 — SQL com junção e agregação

`Cliente(id, nome)` · `Pedido(id, id_cliente)` · `Item(id_pedido, qtd, valor)`. Quer-se o **nome** dos clientes cujo **valor total comprado** (∑ `qtd*valor`) **ultrapassa 1000**.

a) `... JOIN ... WHERE SUM(i.qtd*i.valor) > 1000 GROUP BY c.nome`
b) `... JOIN Pedido ... JOIN Item ... GROUP BY c.nome HAVING SUM(i.qtd*i.valor) > 1000`
c) `... JOIN ... GROUP BY c.nome HAVING i.qtd*i.valor > 1000`
d) `SELECT c.nome FROM Cliente c WHERE SUM(c.valor) > 1000`
e) `... JOIN ... HAVING SUM(i.qtd*i.valor) > 1000` (sem `GROUP BY`)

---

## Q2 — Gabarito: **b)**

`GROUP BY c.nome HAVING SUM(i.qtd*i.valor) > 1000`

- O filtro incide sobre um **agregado por grupo** → exige `GROUP BY` + **`HAVING`** (não `WHERE`, que filtra linhas **antes** de agrupar).
- (a) usa `SUM` no `WHERE`; (c) usa coluna não agregada no `HAVING`; (d) ignora as junções; (e) usa `HAVING` sem `GROUP BY`.

---

## Q3 — Normalização

`R(Aluno, Disciplina, Professor)` tem **chave primária composta** `(Aluno, Disciplina)` e a dependência funcional **`Disciplina → Professor`**. Qual forma normal é **violada** e por quê?

a) 1FN, por conter atributo **multivalorado**.
b) 3FN, por dependência **transitiva** entre atributos não-chave.
c) Nenhuma; a relação já está em 3FN.
d) 2FN, pois `Professor` depende **parcialmente** da chave (só de `Disciplina`).
e) Apenas a BCNF; a relação está em 3FN.

---

## Q3 — Gabarito: **d)**

Viola a **2ª Forma Normal**.

- A chave é composta `(Aluno, Disciplina)`; `Disciplina → Professor` faz `Professor` depender de **parte** da chave → **dependência parcial** → fere a **2FN**.
- Não é transitiva (seria 3FN) nem atomicidade (1FN). **Solução:** decompor em `Turma(Disciplina, Professor)` e `Matricula(Aluno, Disciplina)`.

---

## Q4 — Mapeamento de generalização

`Pessoa` (supertipo) especializa-se em `PessoaFisica` (CPF) e `PessoaJuridica` (CNPJ), especialização **total e disjunta**. Deseja-se um mapeamento relacional que **evite colunas nulas** e respeite a exclusividade.

a) Uma tabela por subtipo (`PessoaFisica`, `PessoaJuridica`), cada uma com os atributos comuns de `Pessoa`; sem tabela do supertipo.
b) Uma única tabela `Pessoa` com todas as colunas (CPF e CNPJ), a maioria nula em cada linha.
c) `Pessoa` + subtabelas por FK, permitindo uma pessoa ser física **e** jurídica.
d) Uma tabela `Pessoa` e listas de CPF/CNPJ separadas por vírgula.
e) Substituir a generalização por um relacionamento M:N entre CPF e CNPJ.

---

## Q4 — Gabarito: **a)**

**Uma tabela por subtipo** (para especialização **total e disjunta**).

- Como toda pessoa é **exatamente um** subtipo, tabelas por subtipo **eliminam os nulos** e preservam a disjunção.
- (b) gera muitas colunas **nulas**; (c) permitiria **sobreposição** (viola a exclusividade); (d) fere a 1FN; (e) descaracteriza a generalização.

---

## Q5 — Isolamento de transações

Em `T1` lê-se o saldo de uma conta; em seguida `T2` **atualiza e confirma (commit)** esse saldo; ao **ler novamente** o mesmo registro, `T1` obtém um **valor diferente**. Qual anomalia ocorreu e qual nível de isolamento a evita?

a) **Leitura suja** (dirty read); evitada por `READ COMMITTED`.
b) **Leitura fantasma** (phantom); evitada por `READ UNCOMMITTED`.
c) **Perda de atualização**; evitada por `READ UNCOMMITTED`.
d) Nenhuma anomalia; o comportamento é sempre correto.
e) **Leitura não repetível**; evitada a partir de `REPEATABLE READ`.

---

## Q5 — Gabarito: **e)**

**Leitura não repetível** (non-repeatable read).

- `T1` lê **duas vezes** e obtém valores diferentes por um **update confirmado** por `T2` no intervalo → evitada a partir de **`REPEATABLE READ`**.
- **Dirty read** = ler dado **não confirmado**; **phantom** = surgem **novas linhas**; **lost update** = duas escritas se sobrepõem.

---

## Q6 — Concorrência e bloqueios

Com bloqueio de duas fases (2PL): `T1` bloqueia **A** e `T2` bloqueia **B**; então `T1` solicita **B** e `T2` solicita **A**, cada uma aguardando a outra. Assinale a opção correta.

a) O 2PL **garante** que deadlocks nunca ocorram.
b) As duas transações concluem sem qualquer espera.
c) Ocorre **deadlock** (espera circular); o SGBD detecta, escolhe uma **vítima** e faz **rollback**.
d) Há **starvation** permanente que o SGBD não consegue tratar.
e) O fenômeno observado é uma **leitura fantasma**.

---

## Q6 — Gabarito: **c)**

**Deadlock** (espera circular).

- O 2PL garante **serialização**, mas **não previne deadlock**. O SGBD mantém um **grafo de espera**, detecta o ciclo, **aborta uma vítima** e faz **rollback** (a outra prossegue).
- Starvation é evitável por escalonamento; não há leitura de dados novos (phantom).

---

## Q7 — Recuperação com log (WAL)

Após uma **falha do sistema**: `T1` executou `commit` **antes** da falha (mas as alterações podem não ter ido ao disco); `T2` estava **ativa** (sem `commit`). Que ações a recuperação aplica?

a) **UNDO** em `T1` e **REDO** em `T2`.
b) **REDO** em `T1` (refaz, pois confirmou) e **UNDO** em `T2` (desfaz, pois não confirmou).
c) **REDO** em ambas.
d) **UNDO** em ambas.
e) Nenhuma ação; o `commit` de `T1` dispensa recuperação.

---

## Q7 — Gabarito: **b)**

**REDO** em `T1`, **UNDO** em `T2`.

- Pelo **write-ahead logging**: transações **confirmadas** não persistidas sofrem **REDO**; transações **não confirmadas** sofrem **UNDO** (garante **atomicidade**).
- O **checkpoint** limita quão atrás no log o REDO precisa começar.

---

## Q8 — Uso de índices

Índices aceleram consultas, mas têm custo de escrita/espaço. Em qual situação a criação de um índice **tende a NÃO melhorar** o desempenho?

a) Coluna `cpf` **única** usada em `WHERE cpf = ...`.
b) **Chave estrangeira** usada com frequência em `JOIN`.
c) Coluna de data usada em faixas (`BETWEEN`).
d) Coluna de **baixa seletividade** (poucos valores distintos, ex.: um booleano) usada em filtro que retorna **metade** das linhas.
e) Coluna usada com frequência em `ORDER BY`.

---

## Q8 — Gabarito: **d)**

Coluna de **baixa seletividade**.

- Índice compensa quando a busca é **seletiva** (retorna poucas linhas). Se o filtro devolve grande parte da tabela, o otimizador prefere **varredura completa** — e o índice ainda **onera** escrita e espaço.
- Igualdade única, FKs em junções, faixas e ordenação (a, b, c, e) são casos em que o índice **ajuda**.

---

## Q9 — NoSQL e Teorema CAP

Um carrinho de compras **distribuído globalmente** precisa continuar **disponível e aceitando escritas** mesmo durante **partições de rede**, tolerando inconsistência **temporária**. Qual escolha é adequada?

a) Sistema **AP** (disponibilidade + tolerância a partição) com **consistência eventual** — ex.: banco de documentos/chave-valor distribuído.
b) Sistema **CA** que garante **as três** propriedades simultaneamente.
c) Banco relacional com **bloqueio global síncrono** entre todos os nós.
d) Sistema **CP** que **recusa escritas** durante a partição.
e) Indiferente: o Teorema CAP não se aplica a bancos NoSQL.

---

## Q9 — Gabarito: **a)**

**AP + consistência eventual** (modelo **BASE**).

- Pelo **CAP**, sob **partição** escolhe-se **C ou A**. Como o carrinho precisa **aceitar escritas e permanecer disponível**, opta-se por **AP**, reconciliando depois (consistência **eventual**).
- (b) as três ao mesmo tempo é **impossível** sob partição; (d) CP recusaria escritas; (c) não escala globalmente.

---

## Q10 — Arquitetura ANSI-SPARC

Uma equipe adiciona **índices** e muda a **organização física** de armazenamento de uma tabela, **sem alterar** os programas de aplicação nem o esquema conceitual. Esse cenário ilustra a:

a) **Independência lógica de dados**.
b) Ausência de independência de dados.
c) Independência de **domínio**.
d) Independência **referencial**.
e) **Independência física de dados**.

---

## Q10 — Gabarito: **e)**

**Independência física de dados**.

- Nos **três níveis (externo, conceitual, interno)**, mudar o **nível interno/físico** (índices, armazenamento) **sem afetar** o conceitual/aplicações é a **independência física**.
- A **independência lógica** seria mudar o **esquema conceitual** sem afetar as **views**/aplicações — não é o caso aqui.

---

<!-- _class: secao -->

# Parte II — Análise de Dados
### Q11 a Q20

---

## Q11 — Medidas de tendência central

Uma amostra de salários (R$) é: **2000, 2200, 2500, 2800, 50000**. Deseja-se descrever o valor **típico** do conjunto. Assinale a opção correta.

a) A **média** é sempre a melhor medida de tendência central.
b) A **mediana** (2500) representa melhor o típico, pois é **robusta a outliers**, enquanto a **média** (~11 900) é distorcida pelo valor extremo.
c) A **moda** é a única medida válida para dados numéricos.
d) O outlier (50000) **não afeta** a média.
e) Média e mediana são **sempre iguais**.

---

## Q11 — Gabarito: **b)**

A **mediana** é mais representativa aqui.

- A **média** é **sensível a outliers**; um único valor extremo a puxa para ~11 900, longe do "típico".
- A **mediana** (valor central) é **robusta**. Em distribuições **assimétricas**, representa melhor a tendência central.

---

## Q12 — Medidas de dispersão

Dois conjuntos têm a **mesma média**, mas um tem valores muito mais **espalhados** em torno dela. Assinale a opção correta sobre desvio-padrão e IQR.

a) Desvio-padrão e IQR **não têm relação** com dispersão.
b) O IQR é **sensível a outliers**, por isso deve ser evitado.
c) Conjuntos de mesma média têm **sempre** o mesmo desvio-padrão.
d) O conjunto mais **disperso** tem **maior desvio-padrão**; o **IQR** (Q3−Q1) mede os **50% centrais** e é **robusto a outliers**.
e) O desvio-padrão pode ser **negativo**.

---

## Q12 — Gabarito: **d)**

Maior espalhamento → **maior desvio-padrão**.

- O **desvio-padrão** quantifica a dispersão **em torno da média**; mesma média **não** implica mesma dispersão.
- O **IQR** = Q3 − Q1 resume os **50% centrais** e é **robusto a outliers** (base do boxplot). O desvio-padrão nunca é negativo.

---

## Q13 — Amostragem e TLC

Estima-se a média de uma população a partir de **médias amostrais** de tamanho `n`. Assinale a opção correta.

a) Pelo **Teorema Central do Limite**, a distribuição das médias amostrais tende à **normal** conforme `n` cresce, e o **erro-padrão** (σ/√n) **diminui** com `n`.
b) O TLC exige que a **população** seja normal.
c) O erro-padrão **aumenta** com o tamanho da amostra.
d) A distribuição amostral da média é sempre **uniforme**.
e) Aumentar `n` **não altera** a precisão da estimativa.

---

## Q13 — Gabarito: **a)**

**TLC** + **erro-padrão** ∝ 1/√n.

- O **TLC** vale para `n` grande **independentemente** da forma da população; a distribuição das médias aproxima-se da **normal**.
- O **erro-padrão** (σ/√n) **cai** com `n` → estimativas mais **precisas** com amostras maiores.

---

## Q14 — Teste de hipótese

Em um teste com significância **α = 0,05**, obtém-se **p-valor = 0,03**. Assinale a decisão e a interpretação corretas.

a) O p-valor é a **probabilidade de H₀ ser verdadeira**.
b) Como p < α, **aceita-se H₀**.
c) Como **p (0,03) < α (0,05)**, **rejeita-se H₀**; o p-valor é a probabilidade de obter resultado **tão ou mais extremo** que o observado, **supondo H₀ verdadeira**.
d) Rejeitar H₀ sendo ela verdadeira é **erro tipo II**.
e) Um p-valor pequeno **prova** H₁ com certeza.

---

## Q14 — Gabarito: **c)**

**p < α ⇒ rejeita-se H₀**.

- O **p-valor** mede quão extremos são os dados **sob H₀** — **não** é P(H₀ verdadeira) nem prova de H₁.
- Rejeitar H₀ verdadeira é **erro tipo I** (probabilidade = α); **não** rejeitar H₀ falsa é **erro tipo II**.

---

## Q15 — Regressão e correlação

Ajusta-se `vendas ~ investimento_em_anúncios` por regressão linear: coeficiente angular **positivo** e **R² = 0,64**. Assinale a interpretação correta.

a) O R² = 0,64 **prova** que anúncios **causam** vendas.
b) Coeficiente angular positivo indica **correlação negativa**.
c) O R² mede a **inclinação** da reta.
d) Correlação de 0,64 significa **64% de acurácia** de classificação.
e) O **R² = 0,64** indica que **64% da variabilidade** das vendas é explicada pelo modelo; **correlação alta não implica causalidade**.

---

## Q15 — Gabarito: **e)**

**R²** = proporção da variância **explicada**.

- R² = 0,64 → o modelo explica **64%** da variabilidade de `vendas`; o restante fica com outros fatores/erro.
- **Correlação/regressão ≠ causalidade** (variáveis de confusão). O coeficiente **angular** (≠ R²) dá a variação de `y` por unidade de `x`.

---

## Q16 — Sobreajuste

Um modelo apresenta **erro muito baixo no treino** e **erro alto no teste**. Assinale o diagnóstico e a mitigação corretos.

a) **Underfitting**; a solução é **aumentar** a complexidade.
b) **Overfitting**: o modelo memorizou o treino (**baixo viés, alta variância**) e não **generaliza**; mitigar com mais dados, **regularização**, menor complexidade e **validação cruzada**.
c) O modelo está **ideal**, pois errou pouco no treino.
d) **Vazamento de dados** garante boa generalização.
e) Alta acurácia no **treino** garante alta no **teste**.

---

## Q16 — Gabarito: **b)**

**Overfitting** (sobreajuste).

- O **gap** entre bom desempenho no **treino** e ruim no **teste** é a assinatura do sobreajuste (**alta variância**).
- Mitigações: **mais dados**, **regularização**, **reduzir complexidade**, **validação cruzada** — o **trade-off viés–variância** em ação.

---

## Q17 — Métricas em dados desbalanceados

Em detecção de fraude, **99% das transações são legítimas** e 1% são fraude. Um classificador que **prevê sempre "legítima"** atinge **99% de acurácia**. Assinale a opção correta.

a) A **acurácia** é sempre a melhor métrica.
b) A **revocação** mede a proporção de **negativos** corretos.
c) 99% de acurácia significa **boa detecção** de fraudes.
d) A **acurácia é enganosa** em dados **desbalanceados** (o classificador trivial já atinge 99%); **precisão, revocação e F1** (ou AUC) avaliam melhor a **classe minoritária**.
e) O **F1** ignora os **falsos negativos**.

---

## Q17 — Gabarito: **d)**

Acurácia **engana** em classes desbalanceadas.

- O classificador "sempre legítima" tem 99% de acurácia e **revocação 0** para fraude — inútil.
- **Revocação** = TP/(TP+FN) (fraudes capturadas); **precisão** = TP/(TP+FP); **F1** = média harmônica das duas. São essas (ou a **AUC**) que revelam o desempenho na **classe rara**.

---

## Q18 — Tipo de aprendizado

Uma empresa quer **segmentar clientes** em grupos de comportamento semelhante, **sem rótulos** predefinidos. Assinale a abordagem adequada.

a) **Aprendizado não supervisionado** (clusterização, ex.: **k-means**), que agrupa por **similaridade** sem rótulos.
b) **Aprendizado supervisionado** (classificação), pois há rótulos definidos.
c) **Regressão linear**, para prever o grupo.
d) **k-means é supervisionado** e exige a variável-alvo.
e) É preciso **rotular manualmente** todos os clientes antes de qualquer análise.

---

## Q18 — Gabarito: **a)**

**Não supervisionado** (clusterização).

- Sem **variável-alvo (rótulo)**, usa-se aprendizado **não supervisionado**; o **k-means** agrupa por **distância/similaridade**.
- O **supervisionado** (classificação/regressão) exige `y` **rotulado** — que não existe aqui.

---

## Q19 — pandas: agregação por grupo

Considere o código:

```python
import pandas as pd
df = pd.DataFrame({'regiao': ['S','N','S','N'],
                   'venda':  [10, 20, 30, 40]})
r = df.groupby('regiao')['venda'].mean()
```

O que `r` contém?

a) Uma Series com a **soma**: S = 40, N = 60.
b) Um DataFrame com **todas** as linhas originais.
c) Uma **Series** com a média por região: **S = 20.0** e **N = 30.0**.
d) **Erro**, pois `groupby` não aceita coluna categórica.
e) O **primeiro** valor de cada grupo: S = 10, N = 20.

---

## Q19 — Gabarito: **c)**

**Series** com a **média por grupo**.

- `groupby('regiao')['venda'].mean()` agrupa por `regiao` e calcula a **média** em cada grupo:
  **S** = (10+30)/2 = **20.0**; **N** = (20+40)/2 = **30.0**.
- O resultado é uma **Series** indexada pela `regiao` (não a soma nem o primeiro valor).

---

## Q20 — Vazamento de dados

Ao preparar um modelo, escalona-se (normaliza) **todo o conjunto** usando média/desvio calculados sobre **todos os dados** e **só então** divide-se em treino e teste. Assinale a opção correta.

a) Não há problema; escalonar **antes** de dividir é a prática recomendada.
b) O correto é **ajustar no teste** e aplicar no treino.
c) **Vazamento de dados melhora** a generalização.
d) Escalonamento **nunca** afeta a avaliação do modelo.
e) Há **vazamento de dados**: o *scaler* usou estatísticas do **teste**; o correto é **ajustar (fit) só no treino** e **aplicar (transform)** no teste — idealmente via **Pipeline**.

---

## Q20 — Gabarito: **e)**

**Data leakage** (vazamento de dados).

- Calcular estatísticas de pré-processamento sobre **treino + teste** deixa informação do teste "vazar" e **infla** as métricas.
- Regra: **`fit` só no treino**, **`transform`** no teste. Um **`Pipeline`** + **`train_test_split`** (estratificado em classificação) garante isso.

---

<!-- _class: secao -->

# Fim do simulado
### 20 questões · Banco de Dados + Análise de Dados

**Gabarito:** 1c 2b 3d 4a 5e 6c 7b 8d 9a 10e · 11b 12d 13a 14c 15e 16b 17d 18a 19c 20e
