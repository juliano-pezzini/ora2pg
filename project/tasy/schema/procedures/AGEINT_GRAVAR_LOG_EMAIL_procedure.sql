-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gravar_log_email ( nr_seq_ageint_p bigint, ds_email_p text, ds_destinatario_p text, ds_Assunto_p text, nm_usuario_p text, ie_formatado_p text, ie_tipo_envio_p text, ds_email_cc_p text ) AS $body$
BEGIN

if (ie_formatado_p = 'S') then

	begin
	insert into ageint_log_envio(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda_int,
				dt_envio,
				ds_email_long,
				ds_email,
				ds_destinatario,
				ds_assunto,
				ie_tipo_envio,
				ds_email_cc
				)
			values (
				nextval('ageint_log_envio_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ageint_p,
				clock_timestamp(),
				ds_email_p,
				substr(ds_email_p,1,4000),
				substr(ds_destinatario_p,1,255),
				substr(ds_assunto_p,1,255),
				ie_tipo_envio_p,
				ds_email_cc_p
				);
	exception
	when others then
			insert into ageint_log_envio(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda_int,
				dt_envio,
				ds_email_long,
				ds_destinatario,
				ds_assunto,
				ie_tipo_envio,
				ds_email_cc
				)
			values (
				nextval('ageint_log_envio_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ageint_p,
				clock_timestamp(),
				ds_email_p,
				substr(ds_destinatario_p,1,255),
				substr(ds_assunto_p,1,255),
				ie_tipo_envio_p,
				ds_email_cc_p
				);
	end;

else
	begin
		insert into ageint_log_envio(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_agenda_int,
			dt_envio,
			ds_email,
			ds_email_long,
			ds_destinatario,
			ds_assunto,
			ie_tipo_envio,
			ds_email_cc
			)
		values (
			nextval('ageint_log_envio_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_ageint_p,
			clock_timestamp(),
			substr(ds_email_p,1,4000),
			ds_email_p,
			substr(ds_destinatario_p,1,255),
			substr(ds_assunto_p,1,255),
			ie_tipo_envio_p,
			ds_email_cc_p
			);
	exception
	when others then
		insert into ageint_log_envio(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_agenda_int,
			dt_envio,
			ds_email_long,
			ds_destinatario,
			ds_assunto,
			ie_tipo_envio,
			ds_email_cc
			)
		values (
			nextval('ageint_log_envio_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_ageint_p,
			clock_timestamp(),
			ds_email_p,
			substr(ds_destinatario_p,1,255),
			substr(ds_assunto_p,1,255),
			ie_tipo_envio_p,
			ds_email_cc_p
			);
	end;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gravar_log_email ( nr_seq_ageint_p bigint, ds_email_p text, ds_destinatario_p text, ds_Assunto_p text, nm_usuario_p text, ie_formatado_p text, ie_tipo_envio_p text, ds_email_cc_p text ) FROM PUBLIC;

