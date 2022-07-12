-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_gerar_titulo_pck.pls_obter_conta_financ_regra_f ( nr_seq_prestador_p bigint, nr_seq_evento_p bigint) RETURNS bigint AS $body$
DECLARE

						
current_setting('pls_pp_gerar_titulo_pck.cd_conta_financ_w')::pls_parametros.cd_conta_financ_conta%type	bigint := null;


BEGIN

pls_obter_conta_financ_regra(	'PP', 		null, 			null,
				null, 		null, 			null,
				null, 		nr_seq_prestador_p, 	null,
				null, 		null, 			nr_seq_evento_p,
				null,		null, 			null,
				null, 		null,			current_setting('pls_pp_gerar_titulo_pck.cd_conta_financ_w')::pls_parametros.cd_conta_financ_conta%type);

return current_setting('pls_pp_gerar_titulo_pck.cd_conta_financ_w')::pls_parametros.cd_conta_financ_conta%type;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_gerar_titulo_pck.pls_obter_conta_financ_regra_f ( nr_seq_prestador_p bigint, nr_seq_evento_p bigint) FROM PUBLIC;