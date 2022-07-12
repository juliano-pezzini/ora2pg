-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_suspensao_cpoe (NR_SEQ_DIETA_CPOE_P bigint) RETURNS timestamp AS $body$
DECLARE


DT_SUSPENSAO_W  timestamp;


BEGIN
IF (NR_SEQ_DIETA_CPOE_P IS NOT NULL AND NR_SEQ_DIETA_CPOE_P::text <> '') THEN

SELECT  MAX(DT_SUSPENSAO)
INTO STRICT DT_SUSPENSAO_W
FROM  CPOE_DIETA
WHERE  NR_SEQUENCIA = NR_SEQ_DIETA_CPOE_P;

END IF;

RETURN DT_SUSPENSAO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_suspensao_cpoe (NR_SEQ_DIETA_CPOE_P bigint) FROM PUBLIC;
