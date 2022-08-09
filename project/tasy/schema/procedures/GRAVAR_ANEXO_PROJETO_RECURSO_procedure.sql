-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_anexo_projeto_recurso ( nr_seq_proj_p bigint, ds_arquivo_p text, nm_usuario_p text) AS $body$
BEGIN

if (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	insert into projeto_rec_anexo(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_proj_rec,
		ds_arquivo)
	values (	nextval('projeto_rec_anexo_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_proj_p,
		ds_arquivo_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_anexo_projeto_recurso ( nr_seq_proj_p bigint, ds_arquivo_p text, nm_usuario_p text) FROM PUBLIC;
