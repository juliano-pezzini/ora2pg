-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_anexo_autor (nr_sequencia_autor_p bigint, nm_usuario_p text, ds_arquivo_p text) AS $body$
BEGIN

if (ds_arquivo_p IS NOT NULL AND ds_arquivo_p::text <> '') then
	insert	into autorizacao_convenio_arq(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_sequencia_autor,
		ds_arquivo,
		ie_anexar_email,
		ds_observacao,
		nr_seq_tipo)
	values (nextval('autorizacao_convenio_arq_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_autor_p,
		ds_arquivo_p,
		'N',
		null,
		null);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_anexo_autor (nr_sequencia_autor_p bigint, nm_usuario_p text, ds_arquivo_p text) FROM PUBLIC;
