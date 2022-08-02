-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE processa_especialidade_med_jst (IE_EVENTO_P text, CD_PESSOA_FISICA_P text, NR_SEQUENCIA_SUP_P bigint) AS $body$
DECLARE

  E RECORD;

BEGIN
  IF (CD_PESSOA_FISICA_P IS NOT NULL AND CD_PESSOA_FISICA_P::text <> '' AND NR_SEQUENCIA_SUP_P IS NOT NULL AND NR_SEQUENCIA_SUP_P::text <> '') THEN
    FOR E IN (SELECT MIN(EM.CD_ESPECIALIDADE) CD_ESPECIALIDADE
                FROM ESPECIALIDADE_MEDICA EM
               WHERE EM.DS_ESPECIALIDADE IN (SELECT trim(both JST.VL_CAMPO)
                                               FROM JSON_SCHEMA_T JST
                                              WHERE JST.IE_EVENTO = IE_EVENTO_P
                                                AND JST.NM_TABELA = 'ESPECIALIDADE_MEDICA'
                                                AND JST.NR_SEQUENCIA_SUP = NR_SEQUENCIA_SUP_P)
                 AND NOT EXISTS (SELECT 1
                                   FROM MEDICO_ESPECIALIDADE ME
                                  WHERE ME.CD_PESSOA_FISICA = CD_PESSOA_FISICA_P
                                    AND ME.CD_ESPECIALIDADE = EM.CD_ESPECIALIDADE)
               GROUP BY EM.DS_ESPECIALIDADE) LOOP
      INSERT INTO MEDICO_ESPECIALIDADE(CD_PESSOA_FISICA, CD_ESPECIALIDADE, NR_SEQ_PRIORIDADE, DT_ATUALIZACAO, NM_USUARIO)
      VALUES (CD_PESSOA_FISICA_P, E.CD_ESPECIALIDADE, 100, clock_timestamp(), coalesce(WHEB_USUARIO_PCK.GET_NM_USUARIO, 'integracao'));

      COMMIT;
    END LOOP;
  END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processa_especialidade_med_jst (IE_EVENTO_P text, CD_PESSOA_FISICA_P text, NR_SEQUENCIA_SUP_P bigint) FROM PUBLIC;

