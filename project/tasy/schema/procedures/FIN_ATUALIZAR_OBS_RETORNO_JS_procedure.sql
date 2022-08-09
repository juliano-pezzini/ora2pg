-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_atualizar_obs_retorno_js ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p bigint, nm_usuario_p text) AS $body$
BEGIN


if (coalesce(ie_opcao_p, -1) = 0) then

	update	convenio_retorno_item
	set	ds_observacao	= substr(ds_observacao_p, 1, 4000),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_p;

elsif (coalesce(ie_opcao_p, -1) = 1) then

	update   convenio_receb
	set	ds_observacao	= substr(ds_observacao_p, 1, 4000),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where    nr_sequencia	= nr_sequencia_p;

elsif (coalesce(ie_opcao_p, -1) = 6) then

	update	convenio_retorno_glosa
	set	ds_observacao	= substr(ds_observacao_p, 1, 4000),
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
-- REVOKE ALL ON PROCEDURE fin_atualizar_obs_retorno_js ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;
