-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_se_grava_log_atend (qt_minutos_analise_p bigint) AS $body$
DECLARE

 
cont_w	bigint;


BEGIN 
 
select	count(*) 
into STRICT	cont_w 
from	emissao_atend_log 
where	dt_passagem between clock_timestamp() - qt_minutos_analise_p/1440 and clock_timestamp();
 
if (cont_w = 0) then 
	CALL gerar_evento_log_atend(322,'Tasy');
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_se_grava_log_atend (qt_minutos_analise_p bigint) FROM PUBLIC;

