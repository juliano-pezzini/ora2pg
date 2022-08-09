-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_ps_mensal (dt_inicio_mes_p timestamp, dt_final_mes_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
dt_atual_w	timestamp;


BEGIN 
 
dt_atual_w	:= dt_inicio_mes_p;
 
while(dt_atual_w <= dt_final_mes_p)loop 
	begin 
	 
	 
	if (dt_atual_w	<=clock_timestamp()) then /* Não é necessário chamar a procedure se a data for maior que a data atual*/
 
		CALL gerar_eis_pronto_socorro(dt_atual_w, nm_usuario_p);
	end if;
	dt_atual_w	:= dt_atual_w + 1;
 
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_ps_mensal (dt_inicio_mes_p timestamp, dt_final_mes_p timestamp, nm_usuario_p text) FROM PUBLIC;
