-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_historico_pf (nr_seq_historico_p bigint, nm_usuario_p text, ds_observacao_p text) AS $body$
BEGIN

update	pessoa_fisica_historico
set	dt_cancelamento		= clock_timestamp(),
	nm_usuario		= nm_usuario_p,
	ds_obs_cancelamento	= substr(ds_observacao_p,1,4000)
where	nr_sequencia		= nr_seq_historico_p;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_historico_pf (nr_seq_historico_p bigint, nm_usuario_p text, ds_observacao_p text) FROM PUBLIC;

