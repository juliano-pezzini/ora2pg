-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_dialise_solucao_item_v (nr_sequencia, nr_seq_protocolo, nr_solucao, nr_solucao_item, cd_mat_soluc, qt_dose_soluc, cd_unid_med_dose_sol) AS SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 1                     AS nr_solucao_item
       , cd_mat_soluc1         AS cd_mat_soluc
       , qt_dose_soluc1        AS qt_dose_soluc
       , cd_unid_med_dose_sol1 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc1 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 2                     AS nr_solucao_item
       , cd_mat_soluc2         AS cd_mat_soluc
       , qt_dose_soluc2        AS qt_dose_soluc
       , cd_unid_med_dose_sol2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 3                     AS nr_solucao_item
       , cd_mat_soluc3         AS cd_mat_soluc
       , qt_dose_soluc3        AS qt_dose_soluc
       , cd_unid_med_dose_sol3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 4                     AS nr_solucao_item
       , cd_mat_soluc4         AS cd_mat_soluc
       , qt_dose_soluc4        AS qt_dose_soluc
       , cd_unid_med_dose_sol4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 5                     AS nr_solucao_item
       , cd_mat_soluc5         AS cd_mat_soluc
       , qt_dose_soluc5        AS qt_dose_soluc
       , cd_unid_med_dose_sol5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 6                     AS nr_solucao_item
       , cd_mat_soluc6         AS cd_mat_soluc
       , qt_dose_soluc6        AS qt_dose_soluc
       , cd_unid_med_dose_sol6 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc6 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 1                     AS nr_solucao
       , 7                     AS nr_solucao_item
       , cd_mat_soluc7         AS cd_mat_soluc
       , qt_dose_soluc7        AS qt_dose_soluc
       , cd_unid_med_dose_sol7 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc7 IS NOT NULL

UNION

-- SOLUCAO 2

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 1                       AS nr_solucao_item
       , cd_mat_soluc1_2         AS cd_mat_soluc
       , qt_dose_soluc1_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol1_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc1_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 2                       AS nr_solucao_item
       , cd_mat_soluc2_2         AS cd_mat_soluc
       , qt_dose_soluc2_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol2_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc2_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 3                       AS nr_solucao_item
       , cd_mat_soluc3_2         AS cd_mat_soluc
       , qt_dose_soluc3_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol3_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc3_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 4                       AS nr_solucao_item
       , cd_mat_soluc4_2         AS cd_mat_soluc
       , qt_dose_soluc4_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol4_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc4_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 5                       AS nr_solucao_item
       , cd_mat_soluc5_2         AS cd_mat_soluc
       , qt_dose_soluc5_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol5_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc5_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 6                       AS nr_solucao_item
       , cd_mat_soluc6_2         AS cd_mat_soluc
       , qt_dose_soluc6_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol6_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc6_2 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 2                       AS nr_solucao
       , 7                       AS nr_solucao_item
       , cd_mat_soluc7_2         AS cd_mat_soluc
       , qt_dose_soluc7_2        AS qt_dose_soluc
       , cd_unid_med_dose_sol7_2 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc7_2 IS NOT NULL

UNION

-- SOLUCAO 3

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 1                       AS nr_solucao_item
       , cd_mat_soluc1_3         AS cd_mat_soluc
       , qt_dose_soluc1_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol1_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc1_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 2                       AS nr_solucao_item
       , cd_mat_soluc2_3         AS cd_mat_soluc
       , qt_dose_soluc2_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol2_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc2_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 3                       AS nr_solucao_item
       , cd_mat_soluc3_3         AS cd_mat_soluc
       , qt_dose_soluc3_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol3_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc3_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 4                       AS nr_solucao_item
       , cd_mat_soluc4_3         AS cd_mat_soluc
       , qt_dose_soluc4_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol4_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc4_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 5                       AS nr_solucao_item
       , cd_mat_soluc5_3         AS cd_mat_soluc
       , qt_dose_soluc5_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol5_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc5_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 6                       AS nr_solucao_item
       , cd_mat_soluc6_3         AS cd_mat_soluc
       , qt_dose_soluc6_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol6_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc6_3 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 3                       AS nr_solucao
       , 7                       AS nr_solucao_item
       , cd_mat_soluc7_3         AS cd_mat_soluc
       , qt_dose_soluc7_3        AS qt_dose_soluc
       , cd_unid_med_dose_sol7_3 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc7_3 IS NOT NULL

UNION

-- SOLUCAO 4

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 1                       AS nr_solucao_item
       , cd_mat_soluc1_4         AS cd_mat_soluc
       , qt_dose_soluc1_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol1_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc1_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 2                       AS nr_solucao_item
       , cd_mat_soluc2_4         AS cd_mat_soluc
       , qt_dose_soluc2_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol2_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc2_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 3                       AS nr_solucao_item
       , cd_mat_soluc3_4         AS cd_mat_soluc
       , qt_dose_soluc3_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol3_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc3_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 4                       AS nr_solucao_item
       , cd_mat_soluc4_4         AS cd_mat_soluc
       , qt_dose_soluc4_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol4_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc4_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 5                       AS nr_solucao_item
       , cd_mat_soluc5_4         AS cd_mat_soluc
       , qt_dose_soluc5_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol5_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc5_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 6                       AS nr_solucao_item
       , cd_mat_soluc6_4         AS cd_mat_soluc
       , qt_dose_soluc6_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol6_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc6_4 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 4                       AS nr_solucao
       , 7                       AS nr_solucao_item
       , cd_mat_soluc7_4         AS cd_mat_soluc
       , qt_dose_soluc7_4        AS qt_dose_soluc
       , cd_unid_med_dose_sol7_4 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc7_4 IS NOT NULL

UNION

-- SOLUCAO 5

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 1                       AS nr_solucao_item
       , cd_mat_soluc1_5         AS cd_mat_soluc
       , qt_dose_soluc1_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol1_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc1_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 2                       AS nr_solucao_item
       , cd_mat_soluc2_5         AS cd_mat_soluc
       , qt_dose_soluc2_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol2_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc2_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 3                       AS nr_solucao_item
       , cd_mat_soluc3_5         AS cd_mat_soluc
       , qt_dose_soluc3_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol3_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc3_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 4                       AS nr_solucao_item
       , cd_mat_soluc4_5         AS cd_mat_soluc
       , qt_dose_soluc4_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol4_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc4_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 5                       AS nr_solucao_item
       , cd_mat_soluc5_5         AS cd_mat_soluc
       , qt_dose_soluc5_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol5_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc5_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 6                       AS nr_solucao_item
       , cd_mat_soluc6_5         AS cd_mat_soluc
       , qt_dose_soluc6_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol6_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc6_5 IS NOT NULL

UNION

SELECT nr_sequencia
       , nr_seq_protocolo
       , 5                       AS nr_solucao
       , 7                       AS nr_solucao_item
       , cd_mat_soluc7_5         AS cd_mat_soluc
       , qt_dose_soluc7_5        AS qt_dose_soluc
       , cd_unid_med_dose_sol7_5 AS cd_unid_med_dose_sol
FROM   cpoe_dialise
WHERE  cd_mat_soluc7_5 IS NOT NULL;
