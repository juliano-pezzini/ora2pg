-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_eau_anexos (ds_url_p eau_issue_data_attachment.ds_files%type, ie_tipo_p eau_issue_data_attachment.ie_type_attachment%type, nr_seq_issue_p eau_issue_data.nr_sequencia%type) AS $body$
BEGIN

if (ds_url_p IS NOT NULL AND ds_url_p::text <> '')then

	INSERT INTO eau_issue_data_attachment(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_files,
		ie_type_attachment,
		nr_seq_eau_issue_data
	) VALUES (
		nextval('eau_issue_data_attachment_seq'),
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		ds_url_p,
		ie_tipo_p,
		nr_seq_issue_p
	);
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_eau_anexos (ds_url_p eau_issue_data_attachment.ds_files%type, ie_tipo_p eau_issue_data_attachment.ie_type_attachment%type, nr_seq_issue_p eau_issue_data.nr_sequencia%type) FROM PUBLIC;
