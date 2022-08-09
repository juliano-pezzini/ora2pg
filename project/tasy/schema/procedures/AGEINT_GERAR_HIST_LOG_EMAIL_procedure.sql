-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_hist_log_email (nr_seq_ageint_p bigint, ds_destinatario_p text, ds_Assunto_p text, nm_usuario_p text, ie_tipo_email_p text, ds_email_cc_p text, ds_email_p text, ie_html_p text default 'N') AS $body$
DECLARE


nr_seq_agenda_exame_w	agenda_paciente.nr_sequencia%type;
nr_seq_agenda_cons_w	agenda_consulta.nr_sequencia%type;

nr_seq_age_pac_envio_w	agenda_paciente_envio.nr_sequencia%type;
nr_seq_age_cons_envio_w	agenda_consulta_envio.nr_sequencia%type;

ageint_log_envio_seq_w	ageint_log_envio.nr_sequencia%type;

dt_envio_cons_w			timestamp;

ds_email_w ageint_log_envio.ds_email_long%type;

C01 CURSOR FOR
	SELECT	nr_seq_agenda_exame,
			nr_seq_agenda_cons
	from	agenda_integrada_item
	where	nr_seq_agenda_int	= nr_seq_ageint_p;


BEGIN

/*Inicio - Gravacao dos historicos de envio para as agendas.*/

open C01;
loop
fetch C01 into
	nr_seq_agenda_exame_w,
	nr_seq_agenda_cons_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	/*Grava historico para as agendas de exames*/

	if (nr_seq_agenda_exame_w IS NOT NULL AND nr_seq_agenda_exame_w::text <> '') then

		select 	nextval('agenda_paciente_envio_seq')
		into STRICT	nr_seq_age_pac_envio_w
		;
	
	begin
	
		ds_email_w := ds_email_p;
		
		insert into agenda_paciente_envio(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_agenda,
					dt_envio,
					ds_destinatario,
					ds_assunto,
					ie_tipo_email,
					ds_email_long
					) values (
					nr_seq_age_pac_envio_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_agenda_exame_w,
					clock_timestamp(),
					substr(ds_destinatario_p,1,255),
					substr(ds_assunto_p,1,255),
					ie_tipo_email_p,
				    ds_email_w);
		commit;
		
	exception
	when others then

		insert into agenda_paciente_envio(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_agenda,
					dt_envio,
					ds_destinatario,
					ds_assunto,
					ie_tipo_email
					) values (
					nr_seq_age_pac_envio_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_agenda_exame_w,
					clock_timestamp(),
					substr(ds_destinatario_p,1,255),
					substr(ds_assunto_p,1,255),
					ie_tipo_email_p);
		commit;
		/*Gera update com o conteudo long de uma tabela para outra*/

		CALL COPIA_CAMPO_LONG_DE_PARA_NOVO(	'W_AGENDA_ENVIO_EMAIL',
										'DS_CONTEUDO',
										'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
										'NR_SEQUENCIA='||nr_seq_ageint_p,
										'AGENDA_PACIENTE_ENVIO',
										'DS_EMAIL_LONG',
										'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
										'NR_SEQUENCIA='||nr_seq_age_pac_envio_w,
										'L',
									    ie_html_p);

		select	max(dt_envio_cons)
		into STRICT	dt_envio_cons_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_exame_w;

		if (coalesce(dt_envio_cons_w::text, '') = '') then
			update	agenda_paciente
			set		dt_envio_cons = clock_timestamp()
			where	nr_sequencia 	= nr_seq_agenda_exame_w;
		end if;
	end;

	/*Grava historico para as agendas de consultas/servicos*/

	elsif (nr_seq_agenda_cons_w IS NOT NULL AND nr_seq_agenda_cons_w::text <> '') then

		select 	nextval('agenda_consulta_envio_seq')
		into STRICT	nr_seq_age_cons_envio_w
		;

		begin
	
		ds_email_w := ds_email_p;
			
		insert into agenda_consulta_envio(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda,
				dt_envio,
				ds_destinatario,
				ds_assunto,
				ie_tipo_email,
				ds_email_long
			) values (
				nr_seq_age_cons_envio_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_agenda_cons_w,
				clock_timestamp(),
				substr(ds_destinatario_p,1,255),
				substr(ds_assunto_p,1,255),
				ie_tipo_email_p,
				ds_email_w);
		commit;
		
	exception
	when others then
	
		insert into agenda_consulta_envio(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_agenda,
				dt_envio,
				ds_destinatario,
				ds_assunto,
				ie_tipo_email
			) values (
				nr_seq_age_cons_envio_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_agenda_cons_w,
				clock_timestamp(),
				substr(ds_destinatario_p,1,255),
				substr(ds_assunto_p,1,255),
				ie_tipo_email_p);
		commit;

		/*Gera update com o conteudo long de uma tabela para outra*/

		CALL COPIA_CAMPO_LONG_DE_PARA_NOVO(	'W_AGENDA_ENVIO_EMAIL',
										'DS_CONTEUDO',
										'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
										'NR_SEQUENCIA='||nr_seq_ageint_p,
										'AGENDA_CONSULTA_ENVIO',
										'DS_EMAIL_LONG',
										'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
										'NR_SEQUENCIA='||nr_seq_age_cons_envio_w,
										'L',
										ie_html_p);
	end;
	end if;

	end;
end loop;
close C01;

/*Fim - Gravacao dos historicos de envio para as agendas.*/



/*Inicio - Gravacao de logs de envio do e-mail para a Agenda Integrada.*/

select 	nextval('ageint_log_envio_seq')
into STRICT	ageint_log_envio_seq_w
;

begin
	
ds_email_w := ds_email_p;	
	
insert into ageint_log_envio(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_agenda_int,
		dt_envio,
		ds_destinatario,
		ds_assunto,
		ie_tipo_envio,
		ds_email_cc,
		ds_email_long
	) values (
		ageint_log_envio_seq_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_ageint_p,
		clock_timestamp(),
		substr(ds_destinatario_p,1,255),
		substr(ds_assunto_p,1,255),
		'A',
		ds_email_cc_p,
		ds_email_w);
	commit;
		
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
		ds_destinatario,
		ds_assunto,
		ie_tipo_envio,
		ds_email_cc
	) values (
		ageint_log_envio_seq_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_ageint_p,
		clock_timestamp(),
		substr(ds_destinatario_p,1,255),
		substr(ds_assunto_p,1,255),
		'A',
		ds_email_cc_p);
commit;

/*Gera update com o conteudo long de uma tabela para outra*/

CALL COPIA_CAMPO_LONG_DE_PARA_NOVO(	'W_AGENDA_ENVIO_EMAIL',
								'DS_CONTEUDO',
								'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
								'NR_SEQUENCIA='||nr_seq_ageint_p,
								'AGEINT_LOG_ENVIO',
								'DS_EMAIL_LONG',
								'WHERE NR_SEQUENCIA = :NR_SEQUENCIA',
								'NR_SEQUENCIA='||ageint_log_envio_seq_w,
								'L',
								ie_html_p);
/*Fim - Gravacao de logs de envio do e-mail para a Agenda Integrada.*/

commit;
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_hist_log_email (nr_seq_ageint_p bigint, ds_destinatario_p text, ds_Assunto_p text, nm_usuario_p text, ie_tipo_email_p text, ds_email_cc_p text, ds_email_p text, ie_html_p text default 'N') FROM PUBLIC;
