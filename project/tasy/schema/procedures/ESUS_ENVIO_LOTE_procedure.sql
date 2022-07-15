-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE esus_envio_lote (nm_usuario_p text, nr_seq_lote_p text, ds_arquivo_p text, ie_acao_p text) AS $body$
BEGIN

if (ie_acao_p = 'E') then
	update esus_lote_envio
	set dt_envio_lote = clock_timestamp(),
	ds_arquivo_envio = ds_arquivo_p,
	nm_usuario_envio = nm_usuario_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
	where
	nr_sequencia = nr_seq_lote_p;
else
	update esus_lote_envio
	set dt_envio_lote  = NULL,
	ds_arquivo_envio  = NULL,
	nm_usuario_envio  = NULL,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
	where
	nr_sequencia = nr_seq_lote_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE esus_envio_lote (nm_usuario_p text, nr_seq_lote_p text, ds_arquivo_p text, ie_acao_p text) FROM PUBLIC;

