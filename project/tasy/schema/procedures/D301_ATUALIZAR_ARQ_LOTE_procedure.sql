-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE d301_atualizar_arq_lote (nr_seq_arquivo_p bigint, ds_arquivo_p text, nm_usuario_p text) AS $body$
BEGIN

update	D301_ARQUIVO_ENVIO
set	DS_ARQUIVO	= ds_arquivo_p,
	dt_atualizacao	= clock_timestamp(),
	DT_GERACAO	= clock_timestamp(),
	nm_usuario	= nm_usuario_p,
	ie_status_envio	= 'E'
where	nr_sequencia	= nr_seq_arquivo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE d301_atualizar_arq_lote (nr_seq_arquivo_p bigint, ds_arquivo_p text, nm_usuario_p text) FROM PUBLIC;

