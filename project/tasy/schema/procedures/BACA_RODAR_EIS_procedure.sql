-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_rodar_eis (dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
DECLARE

 
dt_inicial_w	timestamp;
dt_final_w		timestamp;
dt_referencia_w	timestamp;

c01 CURSOR FOR 
SELECT 	dt_inicial_w + 1 
 
where 	dt_inicial_w <= dt_final_w;


BEGIN 
dt_inicial_w	:= dt_inicial_p - 1;
dt_final_w		:= dt_final_p;
 
open C01;
loop 
	fetch C01 	into 
   	dt_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		CALL GERAR_EIS_CIRURGIA(dt_referencia_w -1,'TASY');
		CALL Gerar_EIS_Ocupacao_Hospitalar(dt_referencia_w -1, 'TASY');
		CALL Gerar_EIS_Procedimento(dt_referencia_w -1, 'TASY', 'D', 'S');
		CALL Gerar_EIS_Atendimento_Mat(dt_referencia_w -1, 'TASY');
		CALL GERAR_EIS_COMPRAS(dt_referencia_w -1,'TASY');
		CALL GERAR_EIS_PRONTO_SOCORRO(dt_referencia_w -1,'TASY');
		CALL GERAR_EIS_RESULTADO(dt_referencia_w,'TASY');
		end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_rodar_eis (dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

