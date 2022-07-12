-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_os_tcd_proj ( NR_SEQ_PROJ_CRON_ETAPA_P bigint) RETURNS bigint AS $body$
DECLARE

 PR_RETORNO_W	bigint := NULL;

BEGIN

  BEGIN
    SELECT OS.NR_SEQUENCIA
      INTO STRICT PR_RETORNO_W
      FROM MAN_ORDEM_SERVICO OS
     WHERE OS.NR_SEQ_PROJ_CRON_ETAPA  = NR_SEQ_PROJ_CRON_ETAPA_P
       AND UPPER(OS.DS_DANO_BREVE) LIKE '%TEST%CASE%DESIGN%';
	  EXCEPTION
	  	WHEN no_data_found THEN
	  		PR_RETORNO_W := NULL;
	  	WHEN OTHERS THEN
	  		PR_RETORNO_W := NULL;
	END;

RETURN	PR_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_os_tcd_proj ( NR_SEQ_PROJ_CRON_ETAPA_P bigint) FROM PUBLIC;

