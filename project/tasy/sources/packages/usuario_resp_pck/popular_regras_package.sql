-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE usuario_resp_pck.popular_regras () AS $body$
DECLARE

nr_seq_regra_w		bigint;

  r RECORD;

BEGIN
PERFORM set_config('usuario_resp_pck.i', 0, false);

if (current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v.count = 0) then
	
	PERFORM set_config('usuario_resp_pck.i', 0, false);
	FOR r in (	SELECT	nr_sequencia,
			cd_convenio,
			cd_estabelecimento,
			ie_tipo_regra
		from	regra_prev_analise_grg
		where	ie_situacao = 'A') loop
		
		current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v(current_setting('usuario_resp_pck.i')::integer).NR_SEQUENCIA 		:= r.nr_sequencia;
		current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v(current_setting('usuario_resp_pck.i')::integer).cd_estabelecimento 	:= r.cd_estabelecimento;
		current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v(current_setting('usuario_resp_pck.i')::integer).cd_convenio 		:= r.cd_convenio;
		current_setting('usuario_resp_pck.regra_prev_w')::regra_prev_v(current_setting('usuario_resp_pck.i')::integer).ie_tipo_regra 		:=  r.ie_tipo_regra;
		PERFORM set_config('usuario_resp_pck.i', current_setting('usuario_resp_pck.i')::integer + 1, false);
	end loop;

end if;
CALL usuario_resp_pck.popular_regra_usuario();
CALL usuario_resp_pck.popular_regra_item();	
	

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE usuario_resp_pck.popular_regras () FROM PUBLIC;
