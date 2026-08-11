---
marp: true
theme: faesa
paginate: true
---

<!-- _class: capa -->
# Simulado estilo ENADE — Banco de Dados + Análise de Dados
20 questões de múltipla escolha · Prof. Howard Cruz Roatti

---

## Q1. (Banco de Dados) Considere `Aluno(Matricula, Nome, IdCurso)` e `Curso(IdCurso, NomeCurso)`. Deseja-se obter apenas os nomes dos alunos matriculados no curso "Sistemas de Informação". Assinale a expressão de álgebra relacional correta.

a) Projeção de Nome sobre (Aluno junção Curso), sem filtrar o curso.
b) Seleção por Nome sobre a projeção de NomeCurso de (Aluno junção Curso).
c) Projeção de Nome sobre a seleção de NomeCurso = 'Sistemas de Informação' em (Aluno junção Curso).
d) Projeção de NomeCurso sobre a seleção de Nome = 'Sistemas de Informação'.
e) Seleção de NomeCurso = 'Sistemas de Informação' em (Aluno junção Curso), sem projeção.

**Resposta correta: C**

---

## Q2. (Banco de Dados) Dadas `Cliente(id, nome)`, `Pedido(id, id_cliente)` e `Item(id_pedido, qtd, valor)`, qual consulta retorna o nome dos clientes cujo valor total comprado (soma de qtd*valor) ultrapassa 1000?

a) Usa WHERE SUM(qtd*valor) > 1000 com GROUP BY nome.
b) Junta as três tabelas, agrupa por nome e usa HAVING SUM(qtd*valor) > 1000.
c) Agrupa por nome e usa HAVING qtd*valor > 1000 (coluna não agregada).
d) SELECT nome FROM Cliente WHERE SUM(valor) > 1000, sem junções.
e) Usa HAVING SUM(qtd*valor) > 1000 sem GROUP BY.

**Resposta correta: B**

---

## Q3. (Banco de Dados) A relação R(Aluno, Disciplina, Professor) tem chave primária composta (Aluno, Disciplina) e a dependência funcional Disciplina → Professor. Qual forma normal é violada e por quê?

a) 1FN, por conter atributo multivalorado.
b) 3FN, por dependência transitiva entre atributos não-chave.
c) Nenhuma; a relação já está em 3FN.
d) 2FN, pois Professor depende parcialmente da chave (apenas de Disciplina).
e) Apenas a BCNF; a relação está em 3FN.

**Resposta correta: D**

---

## Q4. (Banco de Dados) Pessoa (supertipo) especializa-se em PessoaFisica (CPF) e PessoaJuridica (CNPJ), de forma total e disjunta. Qual mapeamento relacional evita colunas nulas e respeita a exclusividade?

a) Uma tabela por subtipo, cada uma com os atributos comuns de Pessoa, sem tabela do supertipo.
b) Uma única tabela Pessoa com todas as colunas (CPF e CNPJ), a maioria nula.
c) Pessoa mais subtabelas por chave estrangeira, permitindo ser física e jurídica ao mesmo tempo.
d) Uma tabela Pessoa com listas de CPF/CNPJ separadas por vírgula.
e) Substituir a generalização por um relacionamento N:N entre CPF e CNPJ.

**Resposta correta: A**

---

## Q5. (Banco de Dados) Em T1 lê-se o saldo de uma conta; em seguida T2 atualiza e confirma esse saldo; ao ler novamente, T1 obtém um valor diferente. Qual anomalia ocorreu e qual nível de isolamento a evita?

a) Leitura suja (dirty read); evitada por READ COMMITTED.
b) Leitura fantasma (phantom); evitada por READ UNCOMMITTED.
c) Perda de atualização; evitada por READ UNCOMMITTED.
d) Nenhuma anomalia; o comportamento é sempre correto.
e) Leitura não repetível; evitada a partir de REPEATABLE READ.

**Resposta correta: E**

---

## Q6. (Banco de Dados) Com bloqueio de duas fases (2PL): T1 bloqueia A e T2 bloqueia B; então T1 solicita B e T2 solicita A, cada uma aguardando a outra. Assinale a opção correta.

a) O 2PL garante que deadlocks nunca ocorram.
b) As duas transações concluem sem qualquer espera.
c) Ocorre deadlock (espera circular); o SGBD detecta, escolhe uma vítima e faz rollback.
d) Há starvation permanente que o SGBD não consegue tratar.
e) O fenômeno observado é uma leitura fantasma.

**Resposta correta: C**

---

## Q7. (Banco de Dados) Após uma falha do sistema: T1 executou commit antes da falha (mas as alterações podem não ter ido ao disco); T2 estava ativa (sem commit). Que ações a recuperação por log (WAL) aplica?

a) UNDO em T1 e REDO em T2.
b) REDO em T1 (refaz, pois confirmou) e UNDO em T2 (desfaz, pois não confirmou).
c) REDO em ambas.
d) UNDO em ambas.
e) Nenhuma ação; o commit de T1 dispensa recuperação.

**Resposta correta: B**

---

## Q8. (Banco de Dados) Em qual situação a criação de um índice tende a NÃO melhorar o desempenho?

a) Coluna cpf única usada em WHERE cpf = valor.
b) Chave estrangeira usada com frequência em JOIN.
c) Coluna de data usada em faixas (BETWEEN).
d) Coluna de baixa seletividade (poucos valores distintos, ex.: booleano) usada em filtro que retorna metade das linhas.
e) Coluna usada com frequência em ORDER BY.

**Resposta correta: D**

---

## Q9. (Banco de Dados) Um carrinho de compras distribuído globalmente precisa continuar disponível e aceitando escritas mesmo durante partições de rede, tolerando inconsistência temporária. Segundo o Teorema CAP, qual escolha é adequada?

a) Sistema AP (disponibilidade e tolerância a partição) com consistência eventual, ex.: banco de documentos/chave-valor distribuído.
b) Sistema CA que garante as três propriedades simultaneamente.
c) Banco relacional com bloqueio global síncrono entre todos os nós.
d) Sistema CP que recusa escritas durante a partição.
e) Indiferente: o Teorema CAP não se aplica a bancos NoSQL.

**Resposta correta: A**

---

## Q10. (Banco de Dados) Uma equipe adiciona índices e muda a organização física de armazenamento de uma tabela, sem alterar os programas de aplicação nem o esquema conceitual. Esse cenário, na arquitetura ANSI-SPARC, ilustra a:

a) Independência lógica de dados.
b) Ausência de independência de dados.
c) Independência de domínio.
d) Independência referencial.
e) Independência física de dados.

**Resposta correta: E**

---

## Q11. (Análise de Dados) Uma amostra de salários (R$) é: 2000, 2200, 2500, 2800, 50000. Deseja-se descrever o valor típico do conjunto. Assinale a opção correta.

a) A média é sempre a melhor medida de tendência central.
b) A mediana (2500) representa melhor o típico, pois é robusta a outliers, enquanto a média (cerca de 11900) é distorcida pelo valor extremo.
c) A moda é a única medida válida para dados numéricos.
d) O outlier (50000) não afeta a média.
e) Média e mediana são sempre iguais.

**Resposta correta: B**

---

## Q12. (Análise de Dados) Dois conjuntos têm a mesma média, mas um tem valores muito mais espalhados em torno dela. Assinale a opção correta sobre desvio-padrão e IQR.

a) Desvio-padrão e IQR não têm relação com dispersão.
b) O IQR é sensível a outliers, por isso deve ser evitado.
c) Conjuntos de mesma média têm sempre o mesmo desvio-padrão.
d) O conjunto mais disperso tem maior desvio-padrão; o IQR (Q3 menos Q1) mede os 50% centrais e é robusto a outliers.
e) O desvio-padrão pode ser negativo.

**Resposta correta: D**

---

## Q13. (Análise de Dados) Estima-se a média de uma população a partir de médias amostrais de tamanho n. Assinale a opção correta.

a) Pelo Teorema Central do Limite, a distribuição das médias amostrais tende à normal conforme n cresce, e o erro-padrão (sigma sobre raiz de n) diminui com n.
b) O TLC exige que a população seja normal.
c) O erro-padrão aumenta com o tamanho da amostra.
d) A distribuição amostral da média é sempre uniforme.
e) Aumentar n não altera a precisão da estimativa.

**Resposta correta: A**

---

## Q14. (Análise de Dados) Em um teste com significância alfa = 0,05, obtém-se p-valor = 0,03. Assinale a decisão e a interpretação corretas.

a) O p-valor é a probabilidade de H0 ser verdadeira.
b) Como p menor que alfa, aceita-se H0.
c) Como p (0,03) menor que alfa (0,05), rejeita-se H0; o p-valor é a probabilidade de obter resultado tão ou mais extremo que o observado, supondo H0 verdadeira.
d) Rejeitar H0 sendo ela verdadeira é erro tipo II.
e) Um p-valor pequeno prova H1 com certeza.

**Resposta correta: C**

---

## Q15. (Análise de Dados) Ajusta-se vendas em função de investimento em anúncios por regressão linear: coeficiente angular positivo e R2 = 0,64. Assinale a interpretação correta.

a) O R2 = 0,64 prova que anúncios causam vendas.
b) Coeficiente angular positivo indica correlação negativa.
c) O R2 mede a inclinação da reta.
d) Correlação de 0,64 significa 64% de acurácia de classificação.
e) O R2 = 0,64 indica que 64% da variabilidade das vendas é explicada pelo modelo; correlação alta não implica causalidade.

**Resposta correta: E**

---

## Q16. (Análise de Dados) Um modelo apresenta erro muito baixo no treino e erro alto no teste. Assinale o diagnóstico e a mitigação corretos.

a) Underfitting; a solução é aumentar a complexidade.
b) Overfitting: o modelo memorizou o treino (baixo viés, alta variância) e não generaliza; mitigar com mais dados, regularização, menor complexidade e validação cruzada.
c) O modelo está ideal, pois errou pouco no treino.
d) Vazamento de dados garante boa generalização.
e) Alta acurácia no treino garante alta no teste.

**Resposta correta: B**

---

## Q17. (Análise de Dados) Em detecção de fraude, 99% das transações são legítimas e 1% são fraude. Um classificador que prevê sempre "legítima" atinge 99% de acurácia. Assinale a opção correta.

a) A acurácia é sempre a melhor métrica.
b) A revocação mede a proporção de negativos corretos.
c) 99% de acurácia significa boa detecção de fraudes.
d) A acurácia é enganosa em dados desbalanceados (o classificador trivial já atinge 99%); precisão, revocação e F1 (ou AUC) avaliam melhor a classe minoritária.
e) O F1 ignora os falsos negativos.

**Resposta correta: D**

---

## Q18. (Análise de Dados) Uma empresa quer segmentar clientes em grupos de comportamento semelhante, sem rótulos predefinidos. Assinale a abordagem adequada.

a) Aprendizado não supervisionado (clusterização, ex.: k-means), que agrupa por similaridade sem rótulos.
b) Aprendizado supervisionado (classificação), pois há rótulos definidos.
c) Regressão linear, para prever o grupo.
d) k-means é supervisionado e exige a variável-alvo.
e) É preciso rotular manualmente todos os clientes antes de qualquer análise.

**Resposta correta: A**

---

## Q19. (Análise de Dados) No pandas, considere: df = DataFrame com colunas 'regiao' = [S, N, S, N] e 'venda' = [10, 20, 30, 40]; r = df.groupby('regiao')['venda'].mean(). O que r contém?

a) Uma Series com a soma: S = 40, N = 60.
b) Um DataFrame com todas as linhas originais.
c) Uma Series com a média por região: S = 20.0 e N = 30.0.
d) Erro, pois groupby não aceita coluna categórica.
e) O primeiro valor de cada grupo: S = 10, N = 20.

**Resposta correta: C**

---

## Q20. (Análise de Dados) Ao preparar um modelo, escalona-se todo o conjunto usando média/desvio calculados sobre todos os dados e só então divide-se em treino e teste. Assinale a opção correta.

a) Não há problema; escalonar antes de dividir é a prática recomendada.
b) O correto é ajustar no teste e aplicar no treino.
c) Vazamento de dados melhora a generalização.
d) Escalonamento nunca afeta a avaliação do modelo.
e) Há vazamento de dados: o scaler usou estatísticas do teste; o correto é ajustar (fit) só no treino e aplicar (transform) no teste, idealmente via Pipeline.

**Resposta correta: E**
