-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gravar_param_lote ( nr_lote_contabil_p bigint, nr_seq_parametro_p bigint, ds_valor_parametro_p text, ds_valor_parametro_compl_p text, nm_usuario_p text) AS $body$
BEGIN

update	Lote_Contabil_Parametro
set	ds_valor_parametro		= ds_valor_parametro_p,
	ds_valor_parametro_compl	= ds_valor_parametro_compl_p,
	dt_atualizacao			= clock_timestamp(),
	nm_usuario			= nm_usuario_p
where	nr_lote_contabil		= nr_lote_contabil_p
and	nr_seq_parametro		= nr_seq_parametro_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gravar_param_lote ( nr_lote_contabil_p bigint, nr_seq_parametro_p bigint, ds_valor_parametro_p text, ds_valor_parametro_compl_p text, nm_usuario_p text) FROM PUBLIC;

