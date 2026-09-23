/* =====================================================================
   Parte 2 - DML | Seção 1 - Inserção (COMPLEMENTO)
   INSERT ALL (Oracle) - exemplo de utilização
   ---------------------------------------------------------------------
   Este script NÃO substitui o script_pratica_sql_parte_2_1_insert.sql.
   Ele é um COMPLEMENTO que demonstra o INSERT ALL do Oracle como opção
   à inserção linha a linha (INSERT INTO ... VALUES).

   Pré-requisito: as tabelas já devem existir e ter dados
                  (rode antes o parte_1_DDL e o parte_2_1_insert).

   Ideia central do INSERT ALL:
     - insere VÁRIAS linhas em UM único comando;
     - pode direcionar as linhas para VÁRIAS tabelas (com ou sem condição);
     - SEMPRE termina com uma subconsulta. Quando os valores são literais,
       usa-se a subconsulta "dummy" SELECT * FROM DUAL.

   Portabilidade: INSERT ALL é específico do Oracle. Em PostgreSQL/MySQL o
   equivalente para várias linhas é INSERT INTO ... VALUES (...),(...),(...).
   ===================================================================== */


/* ---------------------------------------------------------------------
   Preparação: deixa o script re-executável (limpa o que ele mesmo cria)
   --------------------------------------------------------------------- */
-- remove as linhas de ALUNOS usadas na demonstração (se já existirem)
DELETE FROM ALUNOS WHERE MATRICULA IN (40011, 40012, 40013);

-- remove as tabelas de demonstração, ignorando o erro se ainda não existirem
BEGIN
  FOR t IN (SELECT 'DISCIPLINAS_LONGAS' AS nome FROM DUAL
            UNION ALL SELECT 'DISCIPLINAS_CURTAS' FROM DUAL) LOOP
    BEGIN
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.nome || ' PURGE';
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE != -942 THEN RAISE; END IF;  -- -942 = tabela não existe
    END;
  END LOOP;
END;
/


/* =====================================================================
   EXEMPLO 1 - Várias linhas, MESMA tabela
   ---------------------------------------------------------------------
   Um único comando insere 3 alunos. Como os valores são literais,
   a subconsulta final é SELECT * FROM DUAL.
   ===================================================================== */
INSERT ALL
  INTO ALUNOS (MATRICULA, NOME, DATA_NASCIMENTO)
       VALUES (40011, 'ANA LÚCIA',  TO_DATE('10/03/2000', 'DD/MM/YYYY'))
  INTO ALUNOS (MATRICULA, NOME, DATA_NASCIMENTO)
       VALUES (40012, 'BRUNO DIAS', TO_DATE('22/08/1999', 'DD/MM/YYYY'))
  INTO ALUNOS (MATRICULA, NOME, DATA_NASCIMENTO)
       VALUES (40013, 'CARLA MOTA', TO_DATE('05/01/2001', 'DD/MM/YYYY'))
SELECT * FROM DUAL;

-- INSERT é DML: só persiste após o COMMIT (confirmamos aqui, pois logo
-- abaixo vem um CREATE TABLE, que é DDL e "fecha" a transação sozinho).
COMMIT;


/* =====================================================================
   EXEMPLO 2 - INSERT ALL CONDICIONAL (várias tabelas de destino)
   ---------------------------------------------------------------------
   Atenção: CREATE / TRUNCATE / DROP são DDL. No Oracle, cada comando DDL
   confirma automaticamente a transação em aberto — por isso os INSERTs
   dos exemplos abaixo não dependem de um COMMIT manual.
   ---------------------------------------------------------------------
   Lê uma vez a tabela DISCIPLINAS e distribui cada disciplina para a
   tabela certa conforme a carga horária:
     - >= 60h  -> DISCIPLINAS_LONGAS
     -  < 60h  -> DISCIPLINAS_CURTAS
   ===================================================================== */
CREATE TABLE DISCIPLINAS_LONGAS (
  CODIGO        NUMERIC,
  NOME          VARCHAR2(100),
  CARGA_HORARIA NUMERIC(3)
);

CREATE TABLE DISCIPLINAS_CURTAS (
  CODIGO        NUMERIC,
  NOME          VARCHAR2(100),
  CARGA_HORARIA NUMERIC(3)
);

INSERT ALL
  WHEN CARGA_HORARIA >= 60 THEN
    INTO DISCIPLINAS_LONGAS (CODIGO, NOME, CARGA_HORARIA)
         VALUES (CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA)
  WHEN CARGA_HORARIA < 60 THEN
    INTO DISCIPLINAS_CURTAS (CODIGO, NOME, CARGA_HORARIA)
         VALUES (CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA)
SELECT CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA
  FROM DISCIPLINAS;


/* =====================================================================
   EXEMPLO 3 - INSERT ALL x INSERT FIRST (a diferença importa!)
   ---------------------------------------------------------------------
   Com faixas que SE SOBREPÕEM:
     WHEN CARGA_HORARIA >= 80   (faixa "grande")
     WHEN CARGA_HORARIA >= 40   (faixa "média")

   - INSERT ALL   : avalia TODAS as condições. Uma disciplina de 80h
                    entra nas DUAS tabelas.
   - INSERT FIRST : para na PRIMEIRA condição verdadeira. Uma disciplina
                    de 80h entra APENAS na primeira (grande).

   (Reaproveita as tabelas do Exemplo 2 só para ilustrar; por isso
    esvaziamos antes com TRUNCATE.)
   ===================================================================== */
TRUNCATE TABLE DISCIPLINAS_LONGAS;
TRUNCATE TABLE DISCIPLINAS_CURTAS;

-- INSERT FIRST: cada disciplina vai para UMA tabela só (a 1ª que casar)
INSERT FIRST
  WHEN CARGA_HORARIA >= 80 THEN
    INTO DISCIPLINAS_LONGAS (CODIGO, NOME, CARGA_HORARIA)
         VALUES (CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA)
  WHEN CARGA_HORARIA >= 40 THEN
    INTO DISCIPLINAS_CURTAS (CODIGO, NOME, CARGA_HORARIA)
         VALUES (CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA)
SELECT CODIGO_DISCIPLINA, NOME_DISCIPLINA, CARGA_HORARIA
  FROM DISCIPLINAS;


/* ---------------------------------------------------------------------
   Confirmação da transação (sem COMMIT nada é persistido)
   --------------------------------------------------------------------- */
COMMIT;


/* =====================================================================
   VERIFICAÇÃO - confira os resultados
   ===================================================================== */
-- Exemplo 1: os três alunos inseridos
SELECT * FROM ALUNOS WHERE MATRICULA IN (40011, 40012, 40013);

-- Exemplos 2/3: como ficou a distribuição
SELECT 'LONGAS' AS TABELA, CODIGO, NOME, CARGA_HORARIA FROM DISCIPLINAS_LONGAS
UNION ALL
SELECT 'CURTAS' AS TABELA, CODIGO, NOME, CARGA_HORARIA FROM DISCIPLINAS_CURTAS
ORDER BY TABELA, CARGA_HORARIA DESC;


/* =====================================================================
   LIMPEZA (opcional) - remove os objetos criados na demonstração.
   Comente estas linhas se quiser inspecionar as tabelas depois.
   ===================================================================== */
DROP TABLE DISCIPLINAS_LONGAS PURGE;
DROP TABLE DISCIPLINAS_CURTAS PURGE;
-- Para desfazer também os alunos de teste:
-- DELETE FROM ALUNOS WHERE MATRICULA IN (40011, 40012, 40013);
-- COMMIT;
