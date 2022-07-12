-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pkg_trimestre.buscar_trimestres_pipelined ( trimestre_selecionado bigint, ano bigint ) RETURNS SETOF TRIMESTRE_TABLE_TP AS $body$
DECLARE


  C_TRIMESTRE CURSOR FOR
    SELECT 'Q' || CASE WHEN  - 3 > 1 THEN trimestre_selecionado ELSE CASE WHEN trimestre_selecionado > 3 THEN trimestre_selecionado - 3 ELSE trimestre_selecionado + 1 END END || ' ' || CASE WHEN trimestre_selecionado - 3 > 0 THEN ano ELSE ano - 1 END as pr,
            'Q' || CASE WHEN trimestre_selecionado - 3 > -1 THEN CASE WHEN trimestre_selecionado < 3 THEN trimestre_selecionado + 2 ELSE trimestre_selecionado - 2 END ELSE trimestre_selecionado + 2 END || ' ' || CASE WHEN trimestre_selecionado - 3 >= 0 THEN ano ELSE ano - 1 END as seg,
            'Q' || CASE WHEN trimestre_selecionado - 3 > -2 THEN trimestre_selecionado - 1 ELSE trimestre_selecionado + 3 END || ' ' || CASE WHEN trimestre_selecionado - 3 > 0 THEN ano ELSE CASE WHEN(trimestre_selecionado + 3) > 4 THEN ano ELSE ano - 1 END END as ter,
            'Q' || trimestre_selecionado || ' ' || ano as qua
;

TYPE T_TRIMESTRE_TABLE_TP IS TABLE OF C_TRIMESTRE%ROWTYPE;
R_TRIMESTRE T_TRIMESTRE_TABLE_TP;

BEGIN 
  OPEN C_TRIMESTRE;
  LOOP
    FETCH C_TRIMESTRE BULK COLLECT INTO R_TRIMESTRE LIMIT 1000;

      BEGIN
        FOR i IN R_TRIMESTRE.FIRST..R_TRIMESTRE.LAST LOOP
          RETURN NEXT R_TRIMESTRE(i);
        END LOOP;
      EXCEPTION WHEN OTHERS THEN
        NULL;
      END;

    EXIT WHEN NOT FOUND; /* apply on C_TRIMESTRE */
 
  END LOOP;
  CLOSE C_TRIMESTRE;
  
  RETURN;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pkg_trimestre.buscar_trimestres_pipelined ( trimestre_selecionado bigint, ano bigint ) FROM PUBLIC;