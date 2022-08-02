-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_envio_rps ( nr_seq_lote_p bigint, nm_arquivo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
if (nm_arquivo_p IS NOT NULL AND nm_arquivo_p::text <> '') then
	update	pls_lote_rps
	set	ds_arquivo	= nm_arquivo_p,
		dt_envio	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
else
	update	pls_lote_rps
	set	ds_arquivo	 = NULL,
		dt_envio	 = NULL
	where	nr_sequencia	= nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_envio_rps ( nr_seq_lote_p bigint, nm_arquivo_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

