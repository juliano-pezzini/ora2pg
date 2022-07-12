-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_item_prescr ( NR_PRESCRICAO_P bigint, NR_SEQ_ITEM_P bigint) RETURNS bigint AS $body$
DECLARE


NR_INTERNO_CONTA_W	bigint;


BEGIN

SELECT MAX(NR_INTERNO_CONTA)
INTO STRICT NR_INTERNO_CONTA_W
FROM PROCEDIMENTO_PACIENTE
WHERE NR_PRESCRICAO = NR_PRESCRICAO_P
  AND NR_SEQUENCIA_PRESCRICAO = NR_SEQ_ITEM_P;

RETURN NR_INTERNO_CONTA_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_item_prescr ( NR_PRESCRICAO_P bigint, NR_SEQ_ITEM_P bigint) FROM PUBLIC;

