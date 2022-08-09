-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_simul_perfil_js ( nr_seq_simul_param_item_p bigint, nr_seq_simul_perfil_p bigint, ie_acao_executada_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (ie_acao_executada_p in (1,2)) then

	CALL pls_atualizar_simul_perf_item(nr_seq_simul_param_item_p, nm_usuario_p);

end if;

CALL pls_calc_indice_simul_perfil(nr_seq_simul_perfil_p, nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_simul_perfil_js ( nr_seq_simul_param_item_p bigint, nr_seq_simul_perfil_p bigint, ie_acao_executada_p bigint, nm_usuario_p text) FROM PUBLIC;
