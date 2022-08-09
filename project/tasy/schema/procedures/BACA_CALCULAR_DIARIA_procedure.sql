-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_calcular_diaria (nm_usuario_p text, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp) AS $body$
DECLARE

 
data_w	timestamp;


BEGIN 
 
data_w:= dt_periodo_inicial_p;
 
while(data_w <= dt_periodo_final_p) loop 
	begin 
	CALL Calcular_diaria(nm_usuario_p,data_w);
    data_w:= data_w + 1;
	end;
END LOOP;
 
COMMIT;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_calcular_diaria (nm_usuario_p text, dt_periodo_inicial_p timestamp, dt_periodo_final_p timestamp) FROM PUBLIC;
