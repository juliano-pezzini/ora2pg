-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agexame_inserir_email_env_conv ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;
dt_agenda_w		timestamp;
dt_agendamento_w	timestamp;
ie_status_w		varchar(3);
cd_pessoa_fisica_w	varchar(10);
cd_convenio_w		integer;
cd_procedimento_w	bigint;
nr_seq_proc_interno_w	bigint;
ie_origem_proced_w	bigint;
cd_agenda_w		bigint;
nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;
nm_paciente_w		varchar(60);
						

c01 CURSOR FOR
	SELECT	a.hr_inicio,
		a.dt_agendamento,
		a.ie_status_agenda,
		a.cd_pessoa_fisica,
		a.cd_convenio,
		a.cd_procedimento,
		a.nr_seq_proc_interno,
		a.ie_origem_proced,
		a.cd_agenda,
		a.nr_sequencia,
		a.nm_paciente
	from	agenda_paciente a
	where	a.nr_sequencia = nr_sequencia_p;	

BEGIN	

SELECT	nextval('agenda_email_convenio_seq')
INTO STRICT	nr_sequencia_w
;

open C01;
loop
fetch C01 into	
	dt_agenda_w,
	dt_agendamento_w,
	ie_status_w,
	cd_pessoa_fisica_w,
	cd_convenio_w,
	cd_procedimento_w,
	nr_seq_proc_interno_w,
	ie_origem_proced_w,
	cd_agenda_w,
	nr_seq_agenda_w,
	nm_paciente_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin	
	
	insert into	agenda_email_convenio(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_proc_interno,
						cd_pessoa_fisica,
						cd_procedimento,
						ie_origem_proced,
						cd_agenda,
						dt_agenda,
						dt_agendamento,
						ie_status_agenda,
						cd_convenio,
						dt_envio,
						nr_seq_agenda,
						nm_paciente
						)
					values (
						nr_sequencia_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_proc_interno_w,
						cd_pessoa_fisica_w,
						cd_procedimento_w,
						ie_origem_proced_w,
						cd_agenda_w,
						dt_agenda_w,
						dt_agendamento_w,
						ie_status_w,
						cd_convenio_w,
						clock_timestamp(),
						nr_seq_agenda_w,
						nm_paciente_w
						);
	end;
	
end loop;
close C01;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agexame_inserir_email_env_conv ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
