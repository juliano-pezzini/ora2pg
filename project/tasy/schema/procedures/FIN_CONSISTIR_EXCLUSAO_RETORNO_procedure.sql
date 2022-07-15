-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_consistir_exclusao_retorno ( nr_seq_ret_item_p bigint, nr_seq_retorno_p bigint, nr_interno_conta_p bigint, cd_autorizacao_p text, ie_excluir_glosa_p text, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(ie_excluir_glosa_p, 'N') = 'S') then
	delete	FROM convenio_retorno_glosa
	where	nr_seq_ret_item = nr_seq_ret_item_p;
end if;

/*
insert into log_XXXtasy (
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
values (		sysdate,
	    	 nm_usuario_p,
	       	 55709,
		'Retorno: '	|| nr_seq_retorno_p		|| chr(13) ||
		'Conta: '		|| nr_interno_conta_p	|| chr(13) ||
		'Guia: '		|| cd_autorizacao_p);

commit;  */
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_consistir_exclusao_retorno ( nr_seq_ret_item_p bigint, nr_seq_retorno_p bigint, nr_interno_conta_p bigint, cd_autorizacao_p text, ie_excluir_glosa_p text, nm_usuario_p text) FROM PUBLIC;

