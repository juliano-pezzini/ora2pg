-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_atualizar_obs_proc_mat_rep ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(ie_opcao_p, 'X') = 'P') then

	update	procedimento_repasse
	set	ds_observacao	= ds_observacao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;

elsif (coalesce(ie_opcao_p, 'X') = 'M') then

	update	material_repasse
	set	ds_observacao	= ds_observacao_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_atualizar_obs_proc_mat_rep ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

