-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gravar_anexo_teste (ds_arquivo_p text, nm_usuario_p text, nr_seq_ciclo_teste_p bigint ) AS $body$
BEGIN


if (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	insert into cm_teste_ciclo_anexo(
		nr_sequencia,		
		dt_atualizacao,
		nm_usuario,
		nr_seq_ciclo_teste,
		ds_arquivo,			
		dt_atualizacao_nrec,
		nm_usuario_nrec)
	values (	nextval('cm_teste_ciclo_anexo_seq'),	
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_ciclo_teste_p,
		ds_arquivo_p,
		clock_timestamp(),
		nm_usuario_p);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gravar_anexo_teste (ds_arquivo_p text, nm_usuario_p text, nr_seq_ciclo_teste_p bigint ) FROM PUBLIC;
