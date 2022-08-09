-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_email_conf_agenda ( nr_seq_agendamento_p bigint, cd_tipo_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE


					
cd_pessoa_fisica_w	varchar(10);

ds_destinatario_w	varchar(100);
ds_remetente_w		varchar(100);
ds_mensagem_w		varchar(2000);

dt_agenda_w		timestamp;
ds_hora_w		varchar(10);
cd_medico_agenda_w	varchar(10);
nm_paciente_w		varchar(80);
nm_medico_agenda_w	varchar(80);
ds_orientacao_w		varchar(4000);
ds_orientacao_proced_w	varchar(4000);
ds_setor_agenda_w	setor_atendimento.ds_setor_atendimento%TYPE;
cd_agenda_w		bigint;
cd_estabelecimento_w	smallint;
	
ds_titulo_w		varchar(60);
	

BEGIN

if ((nr_seq_agendamento_p > 0) and (cd_tipo_agenda_p in (2,3,4))) then

	if (cd_tipo_agenda_p  in (3,4)) then
			
			
		ds_titulo_w := wheb_mensagem_pck.get_texto(307513); -- Confirmacao de Consulta
			
		select 	max(cd_pessoa_fisica),
			max(dt_agenda),
			max(obter_nome_pf(obter_medico_agecons(cd_agenda,'C'))),
			max(nm_paciente),
			max(cd_agenda),
			max(to_char(dt_agenda,'hh24:mi')),
			max(substr(Obter_Orientacao_Agenda(cd_agenda),1,4000))
		into STRICT	cd_pessoa_fisica_w,
			dt_agenda_w,
			nm_medico_agenda_w,
			nm_paciente_w,
			cd_agenda_w,
			ds_hora_w,
			ds_orientacao_w
		from	agenda_consulta
		where	nr_sequencia = nr_seq_agendamento_p;
			
			
		select 	max(cd_estabelecimento), max(obter_ds_setor_atendimento(coalesce(cd_setor_exclusivo, cd_setor_agenda)))
		into STRICT 	cd_estabelecimento_w, ds_setor_agenda_w
		from 	agenda
		where	cd_agenda = cd_agenda_w;
			
			
		ds_remetente_w := obter_param_usuario(821, 77, obter_perfil_ativo, nm_usuario_p, 0, ds_remetente_w);
				
				
		select 	max(ds_texto_confir_agenda)
		into STRICT	ds_mensagem_w
		from 	parametro_agenda
		where 	cd_estabelecimento = cd_estabelecimento_w;		
				
				
	elsif (cd_tipo_agenda_p = 2) then
		
		ds_titulo_w := wheb_mensagem_pck.get_texto(307514); -- Confirmacao do Exame
		
		select 	max(cd_pessoa_fisica),
			max(dt_agenda),
			max(obter_nome_pf(obter_medico_agecons(cd_agenda,'C'))),
			max(nm_paciente),
			max(cd_agenda),
			max(to_char(hr_inicio,'hh24:mi')),
			max(substr(obter_orient_procedimento(cd_procedimento, ie_origem_proced),1,4000))
		into STRICT	cd_pessoa_fisica_w,
			dt_agenda_w,
			nm_medico_agenda_w,
			nm_paciente_w,
			cd_agenda_w,
			ds_hora_w,
			ds_orientacao_proced_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agendamento_p;
			
			
		select 	max(cd_estabelecimento),
				max(obter_ds_setor_atendimento(cd_setor_exclusivo))
		into STRICT 	cd_estabelecimento_w,
				ds_setor_agenda_w
		from 	agenda
		where	cd_agenda = cd_agenda_w;
			
			
		ds_remetente_w := obter_param_usuario(820, 110, obter_perfil_ativo, nm_usuario_p, 0, ds_remetente_w);
		
		select 	max(ds_texto_agenda_exame )
		into STRICT	ds_mensagem_w
		from 	parametro_agenda
		where 	cd_estabelecimento = cd_estabelecimento_w;
		
			
	end if;
			
		
	select 	max(a.ds_email)
	into STRICT	ds_destinatario_w
	from	compl_pessoa_fisica a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_w
	and	a.ie_tipo_complemento = 1;
		
		
	if (ds_mensagem_w IS NOT NULL AND ds_mensagem_w::text <> '')	then
				
		select 	replace_macro(ds_mensagem_w, '@Paciente', nm_paciente_w )
		into STRICT	ds_mensagem_w
		;
			
		select 	replace_macro(ds_mensagem_w, '@Medico', nm_medico_agenda_w )
		into STRICT	ds_mensagem_w
		;
			
		select 	replace_macro(ds_mensagem_w, '@Dia', dt_agenda_w)
		into STRICT	ds_mensagem_w
		;
			
		select 	replace_macro(ds_mensagem_w, '@Hora', ds_hora_w)
		into STRICT	ds_mensagem_w
		;
		
		select 	replace_macro(ds_mensagem_w, '@Orientacao', ds_orientacao_w)
		into STRICT	ds_mensagem_w
		;
		
		select 	replace_macro(ds_mensagem_w, '@Orientacao_proc', ds_orientacao_proced_w)
		into STRICT	ds_mensagem_w
		;

		select 	replace_macro(ds_mensagem_w, '@Setor', ds_setor_agenda_w)
		into STRICT	ds_mensagem_w
		;
		
	end if;

	if (ds_remetente_w IS NOT NULL AND ds_remetente_w::text <> '') and (ds_destinatario_w IS NOT NULL AND ds_destinatario_w::text <> '') and (position('@' in ds_destinatario_w) > 0) then
			
		begin		
		CALL enviar_email(ds_titulo_w,
			     ds_mensagem_w,
			     ds_remetente_w,
			     ds_destinatario_w,
			     nm_usuario_p,
			     'M');
		exception
		when others then
			CALL gravar_log_tasy(730,'gerar_email_conf_agenda='||nr_seq_agendamento_p,nm_usuario_p);
		end;		
			
	end if;	
			

	commit;		
			
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_email_conf_agenda ( nr_seq_agendamento_p bigint, cd_tipo_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;
