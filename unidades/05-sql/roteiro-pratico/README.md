# Roteiro Prático de SQL

Guia de aulas práticas de SQL da disciplina, para ser executado na **VM LabDatabase** (Oracle). Serve de base para o deck [Linguagem SQL](../linguagem-sql.md).

## Conteúdo

- **[Roteiro-Pratico-SQL.pdf](Roteiro-Pratico-SQL.pdf)** — o roteiro passo a passo.
- **[Dados-para-Inserir.xlsx](Dados-para-Inserir.xlsx)** — massa de dados de apoio.
- **Diagrama-Roteiro.architect** — modelo do banco (abrir no SQL Power Architect).
- **`Scripts/`** — os scripts SQL, na ordem de execução:

| Parte | Arquivo | Tema | Domínio |
|---|---|---|---|
| 1 | `script_pratica_sql_parte_1_DDL.sql` | DDL: tabelas, sequences, índices, views, PK/FK | Acadêmico |
| 2.1 | `script_pratica_sql_parte_2_1_insert.sql` | `INSERT` | Acadêmico |
| 2.2 | `script_pratica_sql_parte_2_2_update.sql` | `UPDATE` | Acadêmico |
| 2.3 | `script_pratica_sql_parte_2_3_delete.sql` | `DELETE` + `ROLLBACK` | Acadêmico |
| 2.4 | `script_pratica_sql_parte_2_4_select.sql` | `SELECT` (filtros, funções, joins) | Acadêmico |
| 3 | `script_pratica_sql_parte_3_select.sql` | DQL avançado: agregações, `GROUP BY`/`HAVING`, subconsultas | Vendas |
| — | `FAESA Banco de Dados V3.SQL.sql` | script consolidado | — |

## Como usar

1. Conecte na VM LabDatabase (container Oracle) pelo DBeaver (ou `sqlplus`).
2. Rode os scripts **na ordem** (Parte 1 → 2 → 3).
3. Acompanhe pelo PDF do roteiro, que explica cada exercício.

> Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2
