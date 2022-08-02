-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_att_resultado_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
dt_mes_referencia_w	timestamp;
dt_inicial_w		timestamp;
dt_final_w		timestamp;

C01 CURSOR FOR 
	SELECT	dt_mes 
	from	mes_v 
	where	dt_mes between dt_inicial_p and dt_final_p 
	order by dt_mes;


BEGIN 
dt_inicial_w	:= trunc(dt_inicial_p,'month');
dt_final_w	:= last_day(dt_final_p);
 
open C01;
loop 
fetch C01 into 
	dt_mes_referencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	CALL pls_gerar_valores_result_benef(dt_mes_referencia_w, nm_usuario_p, cd_estabelecimento_p);
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_att_resultado_periodo ( dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

