-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_atualizar_compl_hist_movto ( nr_sequencia_p bigint, ds_compl_historico_p text, nm_usuario_p text) AS $body$
BEGIN

update	ctb_movimento
set	ds_compl_historico	= substr(ds_compl_historico_p,1,255),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_atualizar_compl_hist_movto ( nr_sequencia_p bigint, ds_compl_historico_p text, nm_usuario_p text) FROM PUBLIC;

