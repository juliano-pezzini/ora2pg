-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_analise_prod_migr () AS $body$
DECLARE

 
hr_horario_w	smallint;


BEGIN 
hr_horario_w := (to_char(clock_timestamp(),'hh24'))::numeric;
 
if (hr_horario_w > 6) and (hr_horario_w < 19) then 
	begin 
	CALL gerar_analise_prod_migr_colab();
	CALL gerar_anal_prod_migr_colab_mes();
	 
	CALL gerar_analise_prod_migr_grupo();
	CALL gerar_anal_prod_migr_grupo_mes();
	 
	CALL gerar_analise_prod_migr_geral();
	CALL gerar_anal_prod_migr_geral_mes();
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_analise_prod_migr () FROM PUBLIC;
