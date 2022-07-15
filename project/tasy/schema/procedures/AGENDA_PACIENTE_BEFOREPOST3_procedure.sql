-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE agenda_paciente_beforepost3 ( dt_agenda_p timestamp, hr_inicio_p timestamp, dt_validade_carteira_p timestamp, dt_inicial_p timestamp, qt_peso_p bigint, cd_perfil_p bigint, cd_agenda_p bigint, cd_convenio_p bigint, nr_sequencia_p bigint, qt_tempo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_plano_p text, cd_medico_p text, ie_inserir_p text, nm_usuario_p text, nm_paciente_p text, cd_categoria_p text, ie_nao_insere_p text, ie_alt_hor_agend_p text, cd_anestesista_p text, cd_medico_exec_p text, ie_proximo_mes_p text, nr_doc_convenio_p text, cd_pessoa_fisica_p text, cd_usuario_convenio_p text, ie_lado_p text, qt_idade_p bigint, ie_consiste_idade_pac_p text, nr_minuto_duracao_p bigint, qt_proc_autor_p bigint, cd_proc_anterior_p bigint, nr_seq_horario_p bigint default null, ds_erro_p INOUT text DEFAULT NULL, ds_medico_p INOUT text DEFAULT NULL, ds_setor_vinc_p INOUT text DEFAULT NULL, ds_anestesista_p INOUT text DEFAULT NULL, ds_sexo_exclusivo_p INOUT text DEFAULT NULL, ie_msg_quest_prior_p INOUT text DEFAULT NULL, ds_data_lib_proced_p INOUT text DEFAULT NULL, ds_erro_categ_conv_p INOUT text DEFAULT NULL, ds_pergunta_anestesia_p INOUT text DEFAULT NULL, ds_consiste_prior_msg_p INOUT text DEFAULT NULL, ds_consist_categ_conv_p INOUT text DEFAULT NULL, ie_obter_se_proc_anest_p INOUT text DEFAULT NULL, ie_agenda_pac_cota_munic_p INOUT text DEFAULT NULL, ds_consiste_idade_pac_p INOUT text DEFAULT NULL) AS $body$
DECLARE


ie_dia_semana_w			bigint;			
ie_se_medico_w			varchar(1);
ie_se_setor_vinc_w			varchar(1);
ie_se_anestesista_w		varchar(1);
ie_consiste_setor_w		varchar(1);
ie_verif_cota_munic_w		varchar(1);
ie_obter_se_proc_anest_w		varchar(1) := 'N';
ie_agenda_pac_cota_munic_w	varchar(1);
ie_consiste_sexo_exclusivo_w	varchar(1);
ie_consiste_agend_duplic_w		varchar(1);
ie_bloqueio_w			varchar(1);
ie_consiste_alt_hora_agenda_w	varchar(1) := 'N';
ie_alta_gend_w			varchar(1);		
ds_erro_w			varchar(255);
ds_medico_w			varchar(255);
ds_setor_vinc_w			varchar(255);
ds_anestesista_w			varchar(255);
ds_sexo_exclusivo_w		varchar(255);
ds_data_lib_proced_w		varchar(255);
ds_pergunta_anestesia_w		varchar(255);
ie_consiste_sexo_proc_w		varchar(255);
ds_consiste_prioridade_w		varchar(255);
ie_erro_w 			varchar(1000);
dt_lib_proced_w			timestamp;
qt_dias_consistencia_w		bigint;
ie_se_cons_dur_final_turno_w	varchar(1);
qt_tempo_proc_w				bigint;
ie_permite_pac_hor_w		varchar(1);
ds_consiste_idade_pac_w		varchar(255);
ie_cancelar_proc_autor		varchar(1);


BEGIN

ie_verif_cota_munic_w	:= substr(verificar_cota_munic_agepac(cd_agenda_p, dt_agenda_p, cd_pessoa_fisica_p, cd_convenio_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, null, cd_estabelecimento_p, ie_proximo_mes_p),1,1);

if (ie_verif_cota_munic_w = 'S') or (ie_inserir_p = 'S') then
	CALL inserir_cota_munic_agepac(	nr_sequencia_p, cd_agenda_p, dt_agenda_p, cd_pessoa_fisica_p, cd_convenio_p,
					cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, cd_medico_exec_p, 'N', 
					nm_usuario_p, cd_estabelecimento_p, ie_proximo_mes_p, 0);
elsif (ie_verif_cota_munic_w = 'N') then
	ie_agenda_pac_cota_munic_w := 'S';
end if;

ds_erro_w := regra_agenda_liber_cidade(cd_pessoa_fisica_p, cd_agenda_p, ds_erro_w);

ie_consiste_sexo_proc_w := Obter_Param_Usuario(820, 107, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_sexo_proc_w);
if (ie_consiste_sexo_proc_w = 'S') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin
	ie_consiste_sexo_exclusivo_w	:= substr(consistir_sexo_exclusivo_proc(cd_pessoa_fisica_p, nr_seq_proc_interno_p, cd_procedimento_p, ie_origem_proced_p),1,1);
	if (ie_consiste_sexo_exclusivo_w = 'N') then
		ds_sexo_exclusivo_w	:= substr(obter_texto_tasy(37859, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

ie_consiste_setor_w := Obter_Param_Usuario(820, 122, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_setor_w);
if (ie_consiste_setor_w = 'S') and (nr_seq_proc_interno_p <> 0)then
	begin
	ie_se_setor_vinc_w	:= substr(obter_se_setor_vinculado_proc(ie_origem_proced_p, cd_procedimento_p, cd_setor_atendimento_p),1,1);
	if (ie_se_setor_vinc_w = 'N') then		
		ds_setor_vinc_w	:= substr(obter_texto_tasy(37860, wheb_usuario_pck.get_nr_seq_idioma),1,255);
	end if;
	end;
end if;

dt_lib_proced_w	:= obter_data_lib_proced(cd_agenda_p, cd_medico_exec_p, cd_procedimento_p, ie_origem_proced_p, cd_pessoa_fisica_p, nr_seq_proc_interno_p, nr_sequencia_p);

if (dt_lib_proced_w > hr_inicio_p) then
	ds_data_lib_proced_w	:= substr(obter_texto_tasy(37861, wheb_usuario_pck.get_nr_seq_idioma) || dt_lib_proced_w,1,255);
end if;

if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') then
	begin
	ie_se_medico_w	:= Obter_se_Medico(cd_medico_p, 'M');	
	if (ie_se_medico_w = 'N') then
		ds_medico_w	:= substr(obter_texto_tasy(49229, wheb_usuario_pck.get_nr_seq_idioma),1,255);		
	end if;
	end;
end if;

if (cd_anestesista_p IS NOT NULL AND cd_anestesista_p::text <> '') then
	begin
	ie_se_anestesista_w	:= Obter_se_Medico(cd_anestesista_p, 'M');	
	if (ie_se_anestesista_w = 'N') then
		ds_anestesista_w	:= substr(obter_texto_tasy(49233, wheb_usuario_pck.get_nr_seq_idioma),1,255);		
	end if;
	end;
end if;

if (ie_nao_insere_p = 'S') and (coalesce(nm_paciente_p::text, '') = '') then
	CALL Consistir_equip_agenda_parado(nr_sequencia_p, nm_usuario_p, cd_estabelecimento_p);
end if;

qt_dias_consistencia_w	:= obter_valor_param_usuario(820,349,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
ie_erro_w := ag_exame_se_consiste_prior(
			nr_sequencia_p,
			cd_pessoa_fisica_p,
			hr_inicio_p,
			nr_seq_proc_interno_p,
			cd_estabelecimento_p,
			qt_dias_consistencia_w);
if (ie_erro_w IS NOT NULL AND ie_erro_w::text <> '') then
	begin
	ds_consiste_prioridade_w := obter_valor_param_usuario(820,294,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
	if (ds_consiste_prioridade_w = 'B') then
		begin
		CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262328 , 'DS_MENSAGEM='||ie_erro_w);
		end;
	elsif (ds_consiste_prioridade_w = 'I') then
		begin
		ie_msg_quest_prior_p	:= 'N';
		ds_consiste_prior_msg_p := ie_erro_w;
		end;
	elsif (ds_consiste_prioridade_W = 'Q') then
		begin
		ie_msg_quest_prior_p	:= 'S';
		ds_consiste_prior_msg_p := obter_texto_dic_objeto(43229,wheb_usuario_pck.get_nr_seq_idioma,'DS_ERRO='||ie_erro_w);
		end;
	end if;
	end;
end if;

ds_erro_w := consistir_peso_proc_agenda(cd_procedimento_p, ie_origem_proced_p, qt_peso_p, ds_erro_w);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	ds_erro_p	:= ds_erro_w;
	return; -- Abort
end if;

ie_obter_se_proc_anest_w := obter_se_proc_anest(nr_seq_proc_interno_p,null,null);

ds_pergunta_anestesia_w := substr(obter_texto_tasy(80881, wheb_usuario_pck.get_nr_seq_idioma),1,255);

ie_consiste_setor_w := Obter_Param_Usuario(820, 288, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_setor_w);
if (ie_consiste_setor_w = 'S') then
	begin
	SELECT * FROM consiste_categoria_conv_agenda(
			cd_convenio_p, cd_plano_p, null, nr_doc_convenio_p, dt_validade_carteira_p, cd_usuario_convenio_p, ds_erro_categ_conv_p, ds_consist_categ_conv_p, cd_categoria_p, ie_tipo_atendimento_p, 820, cd_estabelecimento_p, nm_usuario_p) INTO STRICT ds_erro_categ_conv_p, ds_consist_categ_conv_p;
	end;
end if;

/*[295] - Ao realizar agendamento, consisitir a duracao do agendamento, em relacao aos horarios livres*/

ie_consiste_setor_w := Obter_Param_Usuario(820, 295, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_setor_w);
if (ie_consiste_setor_w = 'S') then
	begin
	CALL consistir_duracao_age_exame(
			qt_tempo_proc_p,
			nr_minuto_duracao_p,
			hr_inicio_p,
			cd_agenda_p,
			nm_usuario_p,
			cd_estabelecimento_p,
			nr_seq_horario_p);
	end;
end if;

/*[304] - Consistir agendamento em duplicidade*/

ie_consiste_agend_duplic_w := Obter_Param_Usuario(820, 304, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_agend_duplic_w);
if (ie_consiste_agend_duplic_w = 'S') then
	begin
	CALL consistir_dias_agend_duplic(
			nr_sequencia_p,
			cd_pessoa_fisica_p,
			cd_procedimento_p,
			cd_estabelecimento_p);
	end;
end if;

/*[311] - Permite alterar o horario do agendamento */

ie_consiste_alt_hora_agenda_w := Obter_Param_Usuario(820, 311, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_consiste_alt_hora_agenda_w);
if (ie_consiste_alt_hora_agenda_w = 'S') and (ie_alt_hor_agend_p = 'S') then
	begin
	CALL alterar_hor_agenda_exame(
			cd_agenda_p,
			trunc(dt_agenda_p),
			to_char(hr_inicio_p, 'dd/MM/yyyy hh24:mi:ss'),
			nr_sequencia_p);
	end;
end if;

/*[318]  - Ao trocar o procedimento, cancelar o procedimento anterior na autorizacao convenio*/

ie_cancelar_proc_autor := Obter_Param_Usuario(820, 318, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_cancelar_proc_autor);
if (qt_proc_autor_p > 0) and (ie_cancelar_proc_autor = 'S') then
	CALL cancelar_proc_autor_agenda(	
				cd_estabelecimento_p,
				nm_usuario_p,
				nr_sequencia_p,
				cd_proc_anterior_p,
				'S');
end if;


ie_alta_gend_w := Obter_Param_Usuario(820, 329, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_alta_gend_w);
if (ie_alta_gend_w = 'N') then
	begin
	ie_dia_semana_w := obter_cod_dia_semana(dt_inicial_p);
	ie_bloqueio_w := consistir_bloqueio_agenda(
			cd_agenda_p, hr_inicio_p, ie_dia_semana_w, ie_bloqueio_w);	
	if (ie_bloqueio_w = 'S' ) then
		begin
		CALL wheb_mensagem_pck.exibir_mensagem_abort(134628);
		end;
	end if;
	end;
end if;

ie_se_cons_dur_final_turno_w := Obter_Param_Usuario(820, 387, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_se_cons_dur_final_turno_w);
if (ie_se_cons_dur_final_turno_w = 'S')then
	begin
	if (qt_tempo_proc_p = 0)then
		select	obter_tempo_duracao_proced(	cd_agenda_p,
											cd_medico_exec_p,
											cd_procedimento_p,
											ie_origem_proced_p,
											cd_pessoa_fisica_p,
											nr_seq_proc_interno_p,
											ie_lado_p,
											cd_convenio_p,
											cd_categoria_p,
											cd_plano_p,
											nr_sequencia_p,
											null
											)
		into STRICT	qt_tempo_proc_w
		;	
	else
		qt_tempo_proc_w	:= qt_tempo_proc_p;	
	end if;
	
	
	ds_erro_w := Consistir_dur_marcacao_exames(	hr_inicio_p, cd_agenda_p, nm_usuario_p, qt_tempo_proc_w, nr_sequencia_p, null, 0, ds_erro_w);
									
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		ds_erro_p	:= ds_erro_w;
		return; -- Abort
	end if;								
	
	end;
end if;
ie_permite_pac_hor_w := obter_param_usuario(820, 391, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_permite_pac_hor_w);

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (ie_permite_pac_hor_w = 'N')then
	ds_erro_w := consistir_agenda_exames(	cd_agenda_p, nr_sequencia_p, hr_inicio_p, cd_pessoa_fisica_p, nm_usuario_p, cd_estabelecimento_p, ds_erro_w);
					
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		ds_erro_p	:= ds_erro_w;
		return; -- Abort
	end if;
end if;

if (ie_consiste_idade_pac_p <> 'N') then
	ds_consiste_idade_pac_w := Consiste_Idade_Pac_Agexame(	cd_agenda_p, hr_inicio_p, qt_idade_p, cd_pessoa_fisica_p, ds_consiste_idade_pac_w, nm_usuario_p);
	if (ie_consiste_idade_pac_p = 'B') then
		ds_erro_p	:= ds_consiste_idade_pac_w;
		return;
	end if;
end if;



ie_agenda_pac_cota_munic_p	:= ie_agenda_pac_cota_munic_w;
ds_erro_p					:= ds_erro_w;
ds_sexo_exclusivo_p			:= ds_sexo_exclusivo_w;
ds_setor_vinc_p				:= ds_setor_vinc_w;
ds_data_lib_proced_p		:= ds_data_lib_proced_w;
ds_medico_p					:= ds_medico_w;
ds_anestesista_p			:= ds_anestesista_w;
ie_obter_se_proc_anest_p	:= ie_obter_se_proc_anest_w;
ds_pergunta_anestesia_p		:= ds_pergunta_anestesia_w;
ds_consiste_idade_pac_p		:= ds_consiste_idade_pac_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE agenda_paciente_beforepost3 ( dt_agenda_p timestamp, hr_inicio_p timestamp, dt_validade_carteira_p timestamp, dt_inicial_p timestamp, qt_peso_p bigint, cd_perfil_p bigint, cd_agenda_p bigint, cd_convenio_p bigint, nr_sequencia_p bigint, qt_tempo_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, nr_seq_proc_interno_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_plano_p text, cd_medico_p text, ie_inserir_p text, nm_usuario_p text, nm_paciente_p text, cd_categoria_p text, ie_nao_insere_p text, ie_alt_hor_agend_p text, cd_anestesista_p text, cd_medico_exec_p text, ie_proximo_mes_p text, nr_doc_convenio_p text, cd_pessoa_fisica_p text, cd_usuario_convenio_p text, ie_lado_p text, qt_idade_p bigint, ie_consiste_idade_pac_p text, nr_minuto_duracao_p bigint, qt_proc_autor_p bigint, cd_proc_anterior_p bigint, nr_seq_horario_p bigint default null, ds_erro_p INOUT text DEFAULT NULL, ds_medico_p INOUT text DEFAULT NULL, ds_setor_vinc_p INOUT text DEFAULT NULL, ds_anestesista_p INOUT text DEFAULT NULL, ds_sexo_exclusivo_p INOUT text DEFAULT NULL, ie_msg_quest_prior_p INOUT text DEFAULT NULL, ds_data_lib_proced_p INOUT text DEFAULT NULL, ds_erro_categ_conv_p INOUT text DEFAULT NULL, ds_pergunta_anestesia_p INOUT text DEFAULT NULL, ds_consiste_prior_msg_p INOUT text DEFAULT NULL, ds_consist_categ_conv_p INOUT text DEFAULT NULL, ie_obter_se_proc_anest_p INOUT text DEFAULT NULL, ie_agenda_pac_cota_munic_p INOUT text DEFAULT NULL, ds_consiste_idade_pac_p INOUT text DEFAULT NULL) FROM PUBLIC;

