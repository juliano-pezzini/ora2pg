-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atendimento_cirurgico ( nr_seq_agenda_p bigint, ds_questiona_aval_pre_p INOUT text, nr_prescricao_p INOUT bigint) AS $body$
DECLARE

												
cd_estabelecimento_w				integer;
cd_perfil_w							integer;
nm_usuario_w						varchar(15);
nr_atendimento_w					bigint;
cd_pf_usuario_w					varchar(10);
ie_gera_data_prev_alta_w		varchar(15);
ie_status_painel_w				varchar(15);
ie_executa_evento_w				varchar(15);
ie_atualiza_ged_w					varchar(15);
ie_gera_oftalmo_w					varchar(15);
nr_prescr_aval_pre_w				bigint;
ie_pf_nula_prescr_w				varchar(15);
nr_cirurgia_w						bigint;
cd_medico_w							varchar(10);
cd_procedimento_w					bigint;
cd_pessoa_fisica_w				varchar(10);
nr_seq_atend_futuro_w			bigint;
nr_seq_pepo_w						bigint;
ie_gerar_cirurgia_w				varchar(15);
cd_setor_atendimento_w			integer;
cd_setor_cirurgia_w				integer;
ie_vincula_atend_cirurgia_w	varchar(15);
ie_integracao_w					varchar(15);
ie_estrutura_pepo_w				varchar(15);
ie_origem_proced_w				agenda_paciente.ie_origem_proced%type;




BEGIN
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w				:= wheb_usuario_pck.get_cd_perfil;
nm_usuario_w			:= wheb_usuario_pck.get_nm_usuario;

select	max(obter_pf_usuario(nm_usuario_w,'C'))
into STRICT		cd_pf_usuario_w
;

ie_gerar_cirurgia_w := Obter_Param_Usuario(871, 144, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_gerar_cirurgia_w);
cd_setor_cirurgia_w := Obter_Param_Usuario(871, 154, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, cd_setor_cirurgia_w);
ie_integracao_w := Obter_Param_Usuario(871, 257, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_integracao_w);
ie_vincula_atend_cirurgia_w := Obter_Param_Usuario(871, 327, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_vincula_atend_cirurgia_w);
ie_gera_data_prev_alta_w := Obter_Param_Usuario(871, 441, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_gera_data_prev_alta_w);
ie_status_painel_w := Obter_Param_Usuario(871, 528, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_status_painel_w);
ie_atualiza_ged_w := Obter_Param_Usuario(871, 657, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_atualiza_ged_w);
ie_gera_oftalmo_w := Obter_Param_Usuario(871, 688, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_gera_oftalmo_w);
ie_estrutura_pepo_w := Obter_Param_Usuario(872, 158, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_estrutura_pepo_w);

select	coalesce(max(nr_atendimento),0)
into STRICT		nr_atendimento_w
from		agenda_paciente
where		nr_sequencia = nr_seq_agenda_p;

if (nr_atendimento_w > 0) then
	CALL gerar_evento_internacao_opme(nr_seq_agenda_p,nm_usuario_w,cd_estabelecimento_w);
	CALL gerar_evento_gerar_atendimento(nr_seq_agenda_p,nm_usuario_w,cd_estabelecimento_w);

	if (ie_gera_data_prev_alta_w = 'S') then
		CALL atualiza_data_previsao_alta(nr_seq_agenda_p);
	end if;

	if (ie_status_painel_w IS NOT NULL AND ie_status_painel_w::text <> '') then
		CALL gerar_dados_painel_cirurgia(ie_status_painel_w,nr_seq_agenda_p,'A',nm_usuario_w,'S');
	end if;

	select	max(obter_se_existe_evento_agenda(cd_estabelecimento_w,'AGA','CI'))
	into STRICT		ie_executa_evento_w
	;

	if (ie_executa_evento_w = 'S') then
		CALL executar_evento_agenda('AGA','CI',nr_seq_agenda_p,cd_estabelecimento_w,nm_usuario_w,null,null);
	end if;

	if (ie_atualiza_ged_w = 'S') then
		CALL exportar_anexo_agenda_ged(nm_usuario_w,cd_pf_usuario_w,nr_seq_agenda_p);
	end if;	

	if (ie_gera_oftalmo_w = 'S') then
		CALL gerar_consulta_oft_agenda(null,nr_seq_agenda_p,nm_usuario_w,cd_estabelecimento_w);
	end if;

	select	coalesce(max(b.nr_prescricao),0)
	into STRICT		nr_prescr_aval_pre_w
	from 		conclusao_recom_apae b,
				aval_pre_anestesica a
	where		a.nr_sequencia 	= b.nr_seq_aval_pre
	and		a.nr_seq_agenda 	= nr_seq_agenda_p;

	if (nr_prescr_aval_pre_w > 0) then
		ds_questiona_aval_pre_p	:= substr(obter_texto_tasy(88840, wheb_usuario_pck.get_nr_seq_idioma),1,255); --Deseja vincular o atendimento á prescrição da avaliação pré-anestésica?
		nr_prescricao_p := nr_prescr_aval_pre_w;
	end if;

	select	nullable
	into STRICT		ie_pf_nula_prescr_w
	from   	user_tab_columns
	where  	table_name 		= 'PRESCR_MEDICA'
	and    	column_name 	= 'CD_PESSOA_FISICA';


	select	max(nr_atendimento),
				max(nr_cirurgia),
				max(cd_medico),
				max(cd_procedimento),
				max(cd_pessoa_fisica),
				max(ie_origem_proced),
				max(nr_seq_atend_futuro)
	into STRICT		nr_atendimento_w,
				nr_cirurgia_w,
				cd_medico_w,
				cd_procedimento_w,
				cd_pessoa_fisica_w,
				ie_origem_proced_w,
				nr_seq_atend_futuro_w
	from		agenda_paciente
	where		nr_sequencia = nr_seq_agenda_p;

	if (ie_estrutura_pepo_w = 'S') then
		select	max(nr_seq_pepo)
		into STRICT		nr_seq_pepo_w
		from		cirurgia
		where		nr_cirurgia = nr_cirurgia_w;
	end if;

	CALL vinc_atendimento_cirurgia(nr_seq_agenda_p,nr_atendimento_w,nm_usuario_w);

	CALL enviar_email_regra(nr_seq_agenda_p,'SA',nm_usuario_w,cd_estabelecimento_w);

	if (ie_gerar_cirurgia_w = 'S') and (coalesce(nr_cirurgia_w::text, '') = '') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') and (cd_medico_w IS NOT NULL AND cd_medico_w::text <> '') and
		((ie_pf_nula_prescr_w = 'Y') or (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')) and (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
		if (cd_setor_cirurgia_w IS NOT NULL AND cd_setor_cirurgia_w::text <> '') then
			cd_setor_atendimento_w := cd_setor_cirurgia_w;
		else	
			select	coalesce(max(cd_setor_atendimento),wheb_usuario_pck.get_cd_setor_atendimento)
			into STRICT		cd_setor_atendimento_w
			from 		atend_paciente_unidade
			where 	nr_seq_interno = obter_atepacu_paciente(nr_atendimento_w, 'A');
		end if;	
		CALL Gerar_Cirurgia_Agenda(cd_estabelecimento_w,nr_seq_agenda_p,nm_usuario_w,cd_setor_atendimento_w);
	end if;	

	CALL atualizar_dados_atend_futuro(nr_seq_atend_futuro_w,nr_atendimento_w,nm_usuario_w);

	if (ie_vincula_atend_cirurgia_w = 'S') and (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') then
		if (nr_seq_pepo_w IS NOT NULL AND nr_seq_pepo_w::text <> '') then
			CALL vincular_atend_cirurgia(nr_atendimento_w,nr_cirurgia_w,nm_usuario_w,nr_seq_pepo_w);
		else
			CALL vincular_atend_cirurgia(nr_atendimento_w,nr_cirurgia_w,nm_usuario_w,null);
		end if;
	end if;

	if (ie_integracao_w <> 'N') then
		CALL vincula_atend_agend_opme(nr_seq_agenda_p,'V',nm_usuario_w);
	end if;	
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atendimento_cirurgico ( nr_seq_agenda_p bigint, ds_questiona_aval_pre_p INOUT text, nr_prescricao_p INOUT bigint) FROM PUBLIC;

