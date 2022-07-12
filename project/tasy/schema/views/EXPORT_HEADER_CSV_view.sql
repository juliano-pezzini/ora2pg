-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW export_header_csv (campo_1, campo_2, campo_3, campo_4, dt_inicio_parto) AS SELECT
     EXTRACT(YEAR FROM LOCALTIMESTAMP) ||'-V-1' CAMPO_1, 
     'Tasy' CAMPO_2, 
     TO_CHAR(LOCALTIMESTAMP,'DD.MM.YYYY') CAMPO_3, 
     Obter_Setor_Atendimento(PARTO.NR_ATENDIMENTO) CAMPO_4,
     DT_INICIO_PARTO
FROM PARTO

UNION ALL

SELECT '16/1', 
    'M', 
    EXTRACT(YEAR FROM LOCALTIMESTAMP) ||'-V-1' ||';exportedMotherCSV.csv', 
    1,
    DT_INICIO_PARTO
FROM PARTO

UNION ALL

    SELECT '16/1', 'K', EXTRACT(YEAR FROM LOCALTIMESTAMP) ||'-V-1'||';' || 'exportedBirthCSV.csv', QT_FETO,DT_INICIO_PARTO
FROM PARTO;

