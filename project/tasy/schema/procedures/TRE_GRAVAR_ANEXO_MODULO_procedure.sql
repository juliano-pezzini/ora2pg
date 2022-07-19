-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_gravar_anexo_modulo (nr_seq_modulo_p bigint, ds_arquivo_p text, nm_usuario_p text) AS $body$
BEGIN

if (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	insert into tre_modulo_anexo(
		NR_SEQUENCIA,
		NR_SEQ_MODULO          ,
		DT_ATUALIZACAO        ,
		NM_USUARIO            ,
		DT_ATUALIZACAO_NREC,
		NM_USUARIO_NREC     ,
		DS_ARQUIVO             )
	values (	nextval('tre_modulo_anexo_seq'),
		nr_seq_modulo_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_arquivo_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_gravar_anexo_modulo (nr_seq_modulo_p bigint, ds_arquivo_p text, nm_usuario_p text) FROM PUBLIC;

