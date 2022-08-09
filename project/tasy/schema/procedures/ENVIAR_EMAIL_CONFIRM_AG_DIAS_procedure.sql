-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_confirm_ag_dias (qt_dias_p bigint) AS $body$
DECLARE


ds_texto_agenda_exame_w		varchar(2000);	
ds_texto_agenda_cons_w		varchar(2000);			
ds_mensagem_w		varchar(4000);
nm_paciente_w		varchar(255);
dt_agenda_w		timestamp;
hr_agenda_w		timestamp;
cd_estabelecimento_w	smallint;
nm_medico_w		varchar(255);
cd_pessoa_fisica_w	varchar(10);	
ds_email_destino_w	varchar(255);
ds_procedimento_w	varchar(255);
cd_agenda_w		bigint;
ie_erro_w		varchar(1);
ds_tit_email_confirm_w	varchar(255);
ds_rem_email_confirm_w	varchar(255);
nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;
ds_orientacao_w		varchar(4000);
ds_orientacao_proced_w	varchar(4000);
ds_exp_envio_conf_w 	varchar(255);
ds_exp_agenda_w 	varchar(255);
ds_exp_sequencia_w 	varchar(255);
ds_exp_paciente_w 	varchar(255);
ds_exp_data_agendamento_w 	varchar(255);
ds_log_mov_w 		varchar(4000);
ds_setor_agenda_w	setor_atendimento.ds_setor_atendimento%TYPE;
	
C01 CURSOR FOR
	SELECT	b.nm_paciente,
		b.hr_inicio,
		substr(obter_nome_medico(cd_medico_exec,'N'),1,255) nm_medico,
		trunc(hr_inicio),
		a.cd_estabelecimento,
		b.cd_pessoa_fisica,
		substr(obter_exame_agenda(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno),1,240),
		a.cd_agenda,
		substr(obter_orient_procedimento(b.cd_procedimento, b.ie_origem_proced),1,4000),
		b.nr_sequencia
	from	agenda a,
		agenda_paciente b
	where	a.cd_agenda = b.cd_agenda
	and	a.cd_tipo_agenda = 2
	and	coalesce(a.ie_enviar_email_confirmacao,'N') = 'S'
	and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
	and	b.ie_status_agenda <> 'C'
	and	b.dt_agenda between 	trunc(clock_timestamp()+qt_dias_p) and trunc(clock_timestamp()+qt_dias_p) + 86399/86400;
	

c02 CURSOR FOR	
SELECT 	substr(obter_nome_pf(b.cd_pessoa_fisica),1,255),
	b.dt_agenda,
	trunc(b.dt_agenda),
	a.cd_estabelecimento,
	b.cd_pessoa_fisica,
	a.cd_agenda,
	b.nr_sequencia,
	substr(obter_nome_medico(a.cd_pessoa_fisica,'N'),1,255),
	substr(Obter_Orientacao_Agenda(a.cd_agenda),1,4000)
from    agenda_consulta_v2 b,
	agenda a,
	agenda_classif c
where   a.cd_agenda = b.cd_agenda
and	 b.ie_classif_agenda = c.cd_classificacao
and	(b.cd_pessoa_fisica IS NOT NULL AND b.cd_pessoa_fisica::text <> '')
and	b.ie_status_agenda <> 'C'
and	coalesce(a.ie_enviar_email_confirmacao,'N') = 'S'
and	coalesce(c.ie_email_confirmacao,'N') = 'S'
and	b.dt_agenda between trunc(clock_timestamp()+qt_dias_p) and trunc(clock_timestamp()+qt_dias_p) + 86399/86400;
		

BEGIN

ds_exp_envio_conf_w := wheb_mensagem_pck.get_texto(331605) ||' '|| Lower(wheb_mensagem_pck.get_texto(802562));
ds_exp_agenda_w := wheb_mensagem_pck.get_texto(799621);
ds_exp_sequencia_w := wheb_mensagem_pck.get_texto(795194);
ds_exp_paciente_w := wheb_mensagem_pck.get_texto(791350);
ds_exp_data_agendamento_w := wheb_mensagem_pck.get_texto(767027);

open C01;
loop
fetch C01 into	
	nm_paciente_w,
	hr_agenda_w,
	nm_medico_w,
	dt_agenda_w,
	cd_estabelecimento_w,
	cd_pessoa_fisica_w,
	ds_procedimento_w,
	cd_agenda_w,
	ds_orientacao_proced_w,
	nr_seq_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_email_destino_w	:= '';	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then	
		select	max(b.ds_email)
		into STRICT	ds_email_destino_w
		from	pessoa_fisica a,
			compl_pessoa_fisica b
		where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
		and	b.ie_tipo_complemento 	= 1
		and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
	
	select	max(ds_remetente_email_confirm),
			max(obter_ds_setor_atendimento(cd_setor_exclusivo))
	into STRICT	ds_rem_email_confirm_w,
			ds_setor_agenda_w
	from	agenda
	where	cd_agenda = cd_agenda_w;
	
	if (coalesce(ds_rem_email_confirm_w::text, '') = '') then
		select	max(ds_rem_email_confirm)
		into STRICT	ds_rem_email_confirm_w
		from	parametro_agenda
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;
			
	select	max(ds_texto_agenda_exame),
		max(ds_tit_email_confirm)
	into STRICT	ds_texto_agenda_exame_w,
		ds_tit_email_confirm_w
	from	parametro_agenda
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ds_texto_agenda_exame_w IS NOT NULL AND ds_texto_agenda_exame_w::text <> '') then
	
		ds_mensagem_w 	:= ds_texto_agenda_exame_w;
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Medico', nm_medico_w),1,4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Procedimento', ds_procedimento_w),1,4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Paciente', nm_paciente_w),1,4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Dia', to_char(dt_agenda_w,'dd/mm/yyyy')),1,4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Hora', to_char(hr_agenda_w,'hh24:mi')),1,4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@Orientacao_proc', ds_orientacao_proced_w),1,4000);
		ds_mensagem_w 	:= substr(replace_macro(ds_mensagem_w, '@Setor', ds_setor_agenda_w), 1, 32000);
	
	end if;
	
	if (position('@' in ds_email_destino_w) > 0) and (ds_tit_email_confirm_w IS NOT NULL AND ds_tit_email_confirm_w::text <> '') and (ds_rem_email_confirm_w IS NOT NULL AND ds_rem_email_confirm_w::text <> '') then
		
		begin
		
		ds_log_mov_w := ds_exp_envio_conf_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_agenda_w || ': ' || cd_agenda_w;
		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_sequencia_w || ': ' || nr_seq_agenda_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_paciente_w || ': ' || cd_pessoa_fisica_w || ' - ' || nm_paciente_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_data_agendamento_w || ': ' || hr_agenda_w;
		ds_log_mov_w := SubStr(ds_log_mov_w || ' ' || Dbms_Utility.format_call_stack,1,4000);
  
  		INSERT INTO LOG_MOV(
  		  CD_LOG, 
  		  DS_LOG, 
  		  DT_ATUALIZACAO, 
  		  NM_USUARIO) 
  		VALUES (
  		  2195763, 
  		  ds_log_mov_w,
  		  clock_timestamp(),
  		  coalesce(wheb_usuario_pck.get_nm_usuario,'Tasy'));

		COMMIT;	
		
		CALL enviar_email(ds_tit_email_confirm_w, ds_mensagem_w, ds_rem_email_confirm_w, ds_email_destino_w, 'Tasy', 'A');
		exception
		when others then
		ie_erro_w	:= 'S';	
		end;
			
	end if;
	
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into	
	nm_paciente_w,
	hr_agenda_w,
	dt_agenda_w,
	cd_estabelecimento_w,
	cd_pessoa_fisica_w,
	cd_agenda_w,
	nr_seq_agenda_w,
	nm_medico_w,
	ds_orientacao_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ds_email_destino_w	:= '';	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then	
		select	max(b.ds_email)
		into STRICT	ds_email_destino_w
		from	pessoa_fisica a,
			compl_pessoa_fisica b
		where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
		and	b.ie_tipo_complemento 	= 1
		and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
	
	select	max(ds_remetente_email_confirm), max(obter_ds_setor_atendimento(coalesce(cd_setor_exclusivo, cd_setor_agenda)))
	into STRICT	ds_rem_email_confirm_w, ds_setor_agenda_w
	from	agenda
	where	cd_agenda = cd_agenda_w;
	
	if (coalesce(ds_rem_email_confirm_w::text, '') = '') then
		select	max(ds_rem_email_confirm)
		into STRICT	ds_rem_email_confirm_w
		from	parametro_agenda
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;
				
	select	max(DS_TEXTO_CONFIR_AGENDA),
		max(ds_tit_email_confirm)
	into STRICT	ds_texto_agenda_cons_w,
		ds_tit_email_confirm_w
	from	parametro_agenda
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ds_texto_agenda_cons_w IS NOT NULL AND ds_texto_agenda_cons_w::text <> '') then
	
		ds_mensagem_w 	:= ds_texto_agenda_cons_w;
		ds_mensagem_w	:= subStr(replace_macro(ds_mensagem_w, '@Paciente', nm_paciente_w),1,4000);
		ds_mensagem_w	:= subStr(replace_macro(ds_mensagem_w, '@Dia', to_char(dt_agenda_w,'dd/mm/yyyy')),1,4000);
		ds_mensagem_w	:= subStr(replace_macro(ds_mensagem_w, '@Hora', to_char(hr_agenda_w,'hh24:mi')),1,4000);
		ds_mensagem_w	:= subStr(replace_macro(ds_mensagem_w, '@Medico', nm_medico_w),1,4000);
		ds_mensagem_w	:= subStr(replace_macro(ds_mensagem_w, '@Orientacao', ds_orientacao_w),1,4000);
		ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@Setor', ds_setor_agenda_w), 1, 32000);
		
	end if;
	
	if (position('@' in ds_email_destino_w) > 0) and (ds_tit_email_confirm_w IS NOT NULL AND ds_tit_email_confirm_w::text <> '') and (ds_rem_email_confirm_w IS NOT NULL AND ds_rem_email_confirm_w::text <> '') and (ds_texto_agenda_cons_w IS NOT NULL AND ds_texto_agenda_cons_w::text <> '') then
		
		begin
		
		ds_log_mov_w := ds_exp_envio_conf_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_agenda_w || ': ' || cd_agenda_w;
		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_sequencia_w || ': ' || nr_seq_agenda_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_paciente_w || ': ' || cd_pessoa_fisica_w || ' - ' || nm_paciente_w;
  		ds_log_mov_w := ds_log_mov_w || ' - ' || ds_exp_data_agendamento_w || ': ' || hr_agenda_w;
		ds_log_mov_w := SubStr(ds_log_mov_w || ' ' || Dbms_Utility.format_call_stack,1,4000);
  
  		INSERT INTO LOG_MOV(
  		  CD_LOG, 
  		  DS_LOG, 
  		  DT_ATUALIZACAO, 
  		  NM_USUARIO) 
  		VALUES (
  		  2195763, 
  		  ds_log_mov_w,
  		  clock_timestamp(),
  		  coalesce(wheb_usuario_pck.get_nm_usuario,'Tasy'));

		COMMIT;
		
		CALL enviar_email(ds_tit_email_confirm_w, ds_mensagem_w, ds_rem_email_confirm_w, ds_email_destino_w, 'Tasy', 'A');
		CALL Inserir_historico_envio_email(cd_agenda_w, nr_seq_agenda_w, 'Tasy', cd_pessoa_fisica_w, nm_paciente_w, hr_agenda_w);
		exception
		when others then
		ie_erro_w	:= 'S';	
		end;
			
	end if;
	
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_confirm_ag_dias (qt_dias_p bigint) FROM PUBLIC;
