-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_data_vigencia ( dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
BEGIN

if (dt_inicial_p IS NOT NULL AND dt_inicial_p::text <> '') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') then

	if (dt_inicial_p > dt_final_p) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(122849);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_data_vigencia ( dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

