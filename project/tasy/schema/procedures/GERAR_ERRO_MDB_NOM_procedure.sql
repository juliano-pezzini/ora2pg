-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_erro_mdb_nom (ds_campo_p text, ds_valor_campo_p text, nr_valor_min_p bigint, nr_atendimento_p bigint) AS $body$
BEGIN

if (ds_campo_p IS NOT NULL AND ds_campo_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1064993, 'DS_FIELD= '||ds_campo_p ||
														';DS_VALUE='||ds_valor_campo_p ||
														';QT_SIZE='||nr_valor_min_p ||
														';DS_KEY='||nr_atendimento_p);

end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_erro_mdb_nom (ds_campo_p text, ds_valor_campo_p text, nr_valor_min_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
