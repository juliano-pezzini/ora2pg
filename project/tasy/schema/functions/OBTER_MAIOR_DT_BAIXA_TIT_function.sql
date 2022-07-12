-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_maior_dt_baixa_tit (nr_titulo_p bigint) RETURNS timestamp AS $body$
DECLARE

 
 
dt_recebimento_w			timestamp;


BEGIN 
 
 
SELECT	max(dt_recebimento) 
INTO STRICT	dt_recebimento_w 
FROM 	titulo_receber_liq 
WHERE	nr_titulo		= nr_titulo_p;
 
if (coalesce(dt_recebimento_w::text, '') = '') then 
 
	SELECT	dt_emissao 
	INTO STRICT	dt_recebimento_w 
	FROM 	titulo_receber 
	WHERE	nr_titulo		= nr_titulo_p;
	 
end if;
 
 
 
RETURN dt_recebimento_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_maior_dt_baixa_tit (nr_titulo_p bigint) FROM PUBLIC;

