-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_preferencial (NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint) RETURNS varchar AS $body$
DECLARE


CD_MEDICO_W	varchar(20);

BEGIN

SELECT DISTINCT
  MED.CD_PESSOA_FISICA
  INTO STRICT CD_MEDICO_W
  FROM LISTA_CENTRAL_EXAME LCE
  JOIN LISTA_CENTRAL_MEDICO LCM
    ON LCM.NR_SEQUENCIA = LCE.NR_SEQ_LISTA_MEDICO
  JOIN MEDICO MED ON LCM.CD_MEDICO = MED.CD_PESSOA_FISICA
WHERE 1 = 1
  AND LCE.NR_PRESCRICAO = NR_PRESCRICAO_P
  AND LCE.NR_SEQUENCIA_PRESCRICAO = NR_SEQ_PRESCRICAO_P;

  RETURN	CD_MEDICO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_preferencial (NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint) FROM PUBLIC;
