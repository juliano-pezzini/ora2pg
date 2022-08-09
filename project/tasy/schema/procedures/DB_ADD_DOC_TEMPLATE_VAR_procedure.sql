-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE db_add_doc_template_var ( nr_seq_doc_template_p bigint, nr_seq_content_macro_p db_content_macro.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


nr_seq_content_macro_w	bigint;
nr_seq_var_version_w	db_document_template_macro.nr_seq_var_version%type;
ds_variable_w		db_document_template_macro.ds_variable%type;


BEGIN
	select	nr_sequencia,
		nr_version,
		ds_macro
	into STRICT	nr_seq_content_macro_w,
		nr_seq_var_version_w,
		ds_variable_w
	from	db_content_macro
	where	nr_sequencia = nr_seq_content_macro_p;

	if (nr_seq_content_macro_w IS NOT NULL AND nr_seq_content_macro_w::text <> '') then
		begin
			insert
			into	db_document_template_macro(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					ds_variable,
					nr_seq_content_macro,
					nr_seq_doc_template,
					nr_seq_var_version
				)
				values (
					nextval('db_document_template_macro_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					ds_variable_w,
					nr_seq_content_macro_w,
					nr_seq_doc_template_p,
					nr_seq_var_version_w
				);
		end;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE db_add_doc_template_var ( nr_seq_doc_template_p bigint, nr_seq_content_macro_p db_content_macro.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
