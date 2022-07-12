-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ehr_obter_inf_elem (nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_conteudo_p bigint, nr_seq_triagem_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);
nr_seq_elemento_w	bigint;
nr_seq_entidade_w	bigint;
ie_inf_entidade_w	varchar(1);
ie_atendimento_w	varchar(1);
ie_profissional_w	varchar(3);

C01 CURSOR FOR
	SELECT	ie_inf_entidade,
		ie_atendimento,
		coalesce(ie_profissional,'N')
	from	ehr_template_cont_inf
	where	nr_seq_temp_conteudo = nr_seq_conteudo_p;

	function retiraEspacoComeco(	ds_texto_p	text) return text is

	ds_letras_w	 varchar(4000):= 'qwertyuiopasdfghjkl'|| chr(231) ||'zxcvbnm1234567890';
	ds_retorno_w	varchar(4000);
	
BEGIN
	ds_retorno_w	:= coalesce(ds_texto_p,' ');
	for i in 1..length(ds_retorno_w) loop
		begin

		if (position(Elimina_Acentuacao(lower(substr(ds_retorno_w,i,1))) in ds_letras_w) = 0) then
			ds_retorno_w	:= substr(ds_retorno_w,i+1,4000);
		else
			return ds_retorno_w;
		end if;

		end;
	end loop;


	return ds_retorno_w;
	end;

begin
select	max(nr_seq_elemento)
into STRICT	nr_seq_elemento_w
from	ehr_template_conteudo
where	nr_sequencia	= nr_seq_conteudo_p;

select	max(nr_seq_entidade)
into STRICT	nr_seq_entidade_w
from	ehr_elemento
where	nr_sequencia	= nr_seq_elemento_w;

if (nr_seq_entidade_w IS NOT NULL AND nr_seq_entidade_w::text <> '') then

	open C01;
	loop
	fetch C01 into
		ie_inf_entidade_w,
		ie_atendimento_w,
		ie_profissional_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	

	if (ie_inf_entidade_w	is not  null) then
		if (nr_seq_entidade_w	= 4) then  --Sinal vital
			ds_retorno_w	:= ehr_ent_inf_sinal_vital(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w, nr_seq_triagem_p);
		elsif (nr_seq_entidade_w	= 6) then --Alergia / Reacoes adversas
			ds_retorno_w	:= ehr_ent_inf_paciente_alergia(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w, nr_seq_triagem_p);
		elsif (nr_seq_entidade_w	= 7) then --Cirurgias
			ds_retorno_w	:= ehr_inf_hist_saude_cirurgia(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 8) then --Acessorio/ortese e protese paciente
			ds_retorno_w	:= ehr_inf_paciente_acessorio(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 9) then --Doencas previas e atuais
			ds_retorno_w	:= ehr_inf_paciente_antec_clinico(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 10) then --Medicamentos em uso
			ds_retorno_w	:= ehr_inf_paciente_medic_uso(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 11) then --Habitos e vicios
			ds_retorno_w	:= ehr_inf_paciente_habito_vicio(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 12) then --Ocorrencias
			ds_retorno_w	:= ehr_inf_paciente_ocorrencia(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 13) then --Restricoes
			ds_retorno_w	:= ehr_inf_pac_rep_prescricao(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 14) then --Diagnostico do tumor
			ds_retorno_w	:= ehr_inf_can_loco_regional(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 16) then --Risco cardiaco para cirurgia nao-cardiaca
			ds_retorno_w	:= ehr_inf_risco_cardio_cirurg(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 17) then --Escala de risco cardiaco de Lee
			ds_retorno_w	:= ehr_inf_escala_lee(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 18) then --Escala de risco de complicacoes pulmonares pos-operatorias
			ds_retorno_w	:= ehr_inf_escala_risco_pulmonar(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 19) then --Risco de insuficiencia renal aguda
			ds_retorno_w	:= ehr_inf_esc_risco_insuf_renal(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 21) then --Risco de Delirium
			ds_retorno_w	:= ehr_inf_escala_risco_delirium(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 22) then --Risco de descompensacao hepatica (Child-Pugh score)
			ds_retorno_w	:= ehr_inf_escala_child_pugh(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 23) then --Risco de tromboembolismo venoso (TEV)
			ds_retorno_w	:= ehr_inf_escala_tev(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 24) then --Risco de tromboembolismo venoso (TEV)
			ds_retorno_w	:= EHR_INF_DIAGNOSTICO_DOENCA(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 25) then --Acoes subsequentes
			ds_retorno_w	:= ehr_inf_acao_subsequente(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w);
		elsif (nr_seq_entidade_w	= 28) then --Risco de AVC (Cincinnati CPSS)
			ds_retorno_w	:= ehr_inf_escala_cincinnati(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 29) then --Prescricao Enfermagem
			ds_retorno_w	:= ehr_inf_prescr_enfermagem(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 30) then --Fatores de risco
			ds_retorno_w	:= ehr_inf_escala_fat_risco(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 33) then --Historia familiar
			ds_retorno_w	:= ehr_inf_paciente_antec_fam(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 34) then --Digitacao de resultados
			ds_retorno_w	:= ehr_inf_digitacao_exame(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 37) then --Escala de Glasgow
			ds_retorno_w	:= EHR_INF_ATEND_ESCALA_INDICE(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 38) then --Monit Respiratoria
			ds_retorno_w	:= EHR_INF_ATENDIMENTO_MONIT_RESP(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 40) then --Cirurgias do paciente (Item cirurgias PEP)
			ds_retorno_w	:= EHR_INF_CIRURGIA(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 41) then --Escala Apfel
			ds_retorno_w	:= EHR_ESCALA_APFEL(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 42) then --Escala MIRELS
			ds_retorno_w	:= ehr_ESCALA_MIRELS(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 43) then --Escala MIF
			ds_retorno_w	:= ehr_escala_MIF(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 44) then --Escala DN4
			ds_retorno_w	:= ehr_inf_escala_dn4(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 45) then --Escala Charlson
			ds_retorno_w	:= ehr_escala_charlson(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 46) then --Escala de Mini-avaliacao Nutricional (long form)
			ds_retorno_w	:= ehr_escala_mini_aval(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 47) then --Escala Clearance de creatinina
			ds_retorno_w	:= ehr_escala_clear_creat(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 48) then --Escala de Depressao Geriatrica de Yesavage (GDS-15)
			ds_retorno_w	:= ehr_escala_depressao(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 49) then --Simplified Acute Physiology Score and Expanded (SAPS III)
			ds_retorno_w	:= ehr_escala_saps3(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 50) then --Sepsis-related Organ Failure Assessment (SOFA)
			ds_retorno_w	:= ehr_escala_sofa(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 51) then --Metodo de avaliacao de confusao em terapia intensiva (CAM-ICU)
			ds_retorno_w	:= ehr_escala_cam_icu(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 53) then --Metodo modificado de avaliacao de confusao em UTI (CAM-ICU modificada)
			ds_retorno_w	:= ehr_escala_cam_icu_mod(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 54) then --Escala de Mini-avaliacao Nutricional (short form)
			ds_retorno_w	:= ehr_escala_mini_aval_lf(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 55) then --Escala de atividades Basicas de Vida Diaria - Katz
			ds_retorno_w	:= ehr_escala_katz(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 56) then --Risco Perioperatorio (ACP)
			ds_retorno_w	:= ehr_escala_risco_cardiaco(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 57) then --Risco Perioperatorio (AHA/ACC)
			ds_retorno_w	:= ehr_escala_aha_acc(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 58) then --Escala de Acidente Vascular Cerebral do National Institute of Health (NIHSS)
			ds_retorno_w	:=    ehr_escala_NIH(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 59) then --Escala de Acidente Vascular Cerebral do National Institute of Health (NIHSS)
			ds_retorno_w	:=    ehr_tratamento_anterior(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 60) then --- Escala PIM 2 (Pediatric Index of Mortality)
			ds_retorno_w	:=    ehr_escala_PIM2(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 62) then -- Model for End-stage Liver Disease MELD
			ds_retorno_w	:=    ehr_escala_meld(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 63) then --- Internacoes  (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_historico_saude_internacao(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 64) then --- Deficiencia paciente - (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_deficiencia_paciente(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 65) then --- Exames do paciente (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_paciente_exame(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 66) then --- ETransfusoes sanguineas (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_paciente_transfusao(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 67) then --- Aspectos socio-economico-culturais do paciente (PEP - Historico de saude)
			ds_retorno_w	:=    ehr_paciente_hist_social(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 68) then --- Saude da mulher (PEP - Historico de saude)
			ds_retorno_w	:=    ehr_historico_saude_mulher(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 69) then --- Amputacoes (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_paciente_amputacao(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 71) then --- Vacinas (PEP - Historico Saude)
			ds_retorno_w	:=    ehr_paciente_vacina(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 72) then -- Escala Berg
			ds_retorno_w	:=    ehr_escala_berg(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 73) then -- Escala Piper
			ds_retorno_w	:=    ehr_escala_piper(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 74) then -- Escala Qualidade de vida SF-36
			ds_retorno_w	:=    ehr_escala_qualidade_vida(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 78) then -- Escala Nurging Activities Score (NAS ) 
			ds_retorno_w	:=    ehr_escala_nas(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 80) then -- Sexual Health Inventory for Men (SHIM)
			ds_retorno_w	:=    ehr_escala_shim(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 81) then -- Escala de classificacao das complicacoes cirurgicas (Clavien)
			ds_retorno_w	:=    ehr_escala_clavien(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);			
				
		elsif (nr_seq_entidade_w	= 83) then --  Escala da Avaliacao de Risco de Queda da NHS (EARQ)
			ds_retorno_w	:=    ehr_escala_earq(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w,nr_seq_triagem_p);			
			
		elsif (nr_seq_entidade_w 	= 84) then -- Escala Toxidade
			ds_retorno_w	:=    ehr_escala_toxidade(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
			
		elsif (nr_seq_entidade_w 	= 85) then -- Escala Flebite
			ds_retorno_w	:=    ehr_escala_flebite(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		
		elsif (nr_seq_entidade_w	= 87) then --  Previsaao de Alta
			ds_retorno_w	:=    ehr_previsao_alta(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 91) then --  Escala Fargestrom
			ds_retorno_w	:= ehr_escala_fargestrom(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);	
		
		elsif (nr_seq_entidade_w	= 92) THEN --  Escala MASCC
			ds_retorno_w	:= ehr_escala_mascc(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
			
		elsif (nr_seq_entidade_w	= 93) THEN --  Escala NRS
			ds_retorno_w	:= ehr_escala_nrs(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 94) THEN --  Escala Detsky
			ds_retorno_w	:= ehr_aval_nutric_subjetiva(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 95) THEN --  Escala ASG-PPP
			ds_retorno_w	:= ehr_escala_asg_ppp(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 96) THEN --  Avaliacacao Nutricional Objetiva
			ds_retorno_w	:= ehr_aval_nutricao(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 102) then -- Score Flex
			ds_retorno_w    := ehr_score_flex(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 103) then -- Score Flex II
			ds_retorno_w    := ehr_score_flex(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w, 'II');
		elsif (nr_seq_entidade_w = 104) then -- Escala NEWS
			ds_retorno_w    := ehr_entidade_padrao('ESCALA_NEWS',nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 108) then
			ds_retorno_w	:= ehr_atend_escala_braden(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 110) then
			ds_retorno_w	:= ehr_paciente_antec_sexuais(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 111) then
			ds_retorno_w	:= ehr_paciente_vulnerabilidade(nr_seq_conteudo_p,cd_pessoa_fisica_p, ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 112) then -- ESCALA ESAS
			ds_retorno_w	:= ehr_escala_edmonton(nr_seq_conteudo_p,cd_pessoa_fisica_p, nr_atendimento_p, ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 114) then
			ds_retorno_w	:= ehr_pedido_exame_externo(nr_seq_conteudo_p,cd_pessoa_fisica_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w = 109) then -- Escala ECOG			
			ds_retorno_w :=  ehr_escala_ecog(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p, ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		elsif (nr_seq_entidade_w	= 119) then -- Tumoral Staging
			ds_retorno_w	:= ehr_inf_can_loco_regional(nr_seq_conteudo_p,cd_pessoa_fisica_p,nr_atendimento_p,ie_inf_entidade_w,ie_atendimento_w,ie_profissional_w);
		END IF;
	end if;
end if;
if (length(ds_retorno_w)	= 1) and (ds_retorno_w	= chr(13)) then
	ds_retorno_w	:= null;
end if;

if (substr(ds_retorno_w,1,2) = chr(13)||chr(10)) then
	ds_retorno_w	:= substr(ds_retorno_w,3,4000);

end if;

return	retiraEspacoComeco(ds_retorno_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ehr_obter_inf_elem (nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_conteudo_p bigint, nr_seq_triagem_p bigint default 0) FROM PUBLIC;
