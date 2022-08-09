-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_update_arquivo_lote_fed_sc (nr_seq_lote_p bigint, ds_arquivo_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	update  pls_lote_preco_unimed_sc
	set	ds_arquivo 	= ds_arquivo_p,
		nm_usuario	= nm_usuario_p
	where  	nr_sequencia 	= nr_seq_lote_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_update_arquivo_lote_fed_sc (nr_seq_lote_p bigint, ds_arquivo_p text, nm_usuario_p text) FROM PUBLIC;
