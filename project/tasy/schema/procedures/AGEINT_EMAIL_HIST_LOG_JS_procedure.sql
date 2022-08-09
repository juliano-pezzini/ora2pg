-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_email_hist_log_js ( nr_seq_ageint_p bigint, ds_email_p text, ds_destinatario_p text, ds_assunto_p text, nm_usuario_p text, ie_tipo_email_p text, ie_formatado_p text, ds_email_cc_p text, ie_html_p text default 'N') AS $body$
BEGIN
	if (ie_formatado_p in ('S','E')) then
		CALL ageint_gerar_hist_log_email(nr_seq_ageint_p, ds_destinatario_p, ds_assunto_p, nm_usuario_p, ie_tipo_email_p, ds_email_cc_p, ds_email_p, ie_html_p);
	else
		CALL ageint_gerar_hist_email(nr_seq_ageint_p,ds_email_p,ds_destinatario_p,ds_assunto_p,nm_usuario_p,ie_tipo_email_p);
		CALL ageint_gravar_log_email(nr_seq_ageint_p,ds_email_p,ds_destinatario_p,ds_assunto_p,nm_usuario_p,ie_formatado_p, 'A', ds_email_cc_p);
	end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_email_hist_log_js ( nr_seq_ageint_p bigint, ds_email_p text, ds_destinatario_p text, ds_assunto_p text, nm_usuario_p text, ie_tipo_email_p text, ie_formatado_p text, ds_email_cc_p text, ie_html_p text default 'N') FROM PUBLIC;
