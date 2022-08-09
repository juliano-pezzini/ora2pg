-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_gerar_prescricao_item ( cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_atendimento_p bigint, cd_material_novo_p bigint, cd_material_p bigint, nr_seq_item_p bigint, cd_intervalo_p text, cd_intervalo_novo_p text, ie_acm_sn_p text, qt_dose_p bigint, ie_via_aplicacao_p text, nr_prescricoes_p text, dt_primeiro_horario_p timestamp, cd_unidade_med_p text, ds_horarios_p text, ie_susp_anterior_p text, ie_tipo_pessoa_p text, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text, ds_dose_dif_p text, qt_dose_esp_p bigint, ds_justificativa_p text, ds_observacao_subs_p text, hr_dose_especial_p text, ie_dose_especial_p text, ie_se_necessario_p text, ie_acm_p text, ie_urgencia_p text ) AS $body$
DECLARE

 
nr_prescricao_w		bigint;
nr_prescricao_ww	bigint;
nr_atendimento_w	bigint;
cd_estabelecimento_w	bigint;
qt_unitaria_w		double precision;
qt_material_w		double precision;
qt_total_dispensar_w	double precision;
qt_conversao_dose_w	double precision;
nr_ocorrencia_w		bigint;
nr_seq_item_w		integer;
NR_AGRUPAMENTO_W	integer;
cd_setor_atendimento_w	bigint;
dt_primeiro_horario_w	timestamp;
ie_regra_disp_w		varchar(255);
ds_erro_w		varchar(255);
cd_unidade_medida_consumo_w	varchar(255);
ie_gerar_kit_w			varchar(5);
ie_medico_w			varchar(5);
hr_dose_especial_w	varchar(255);
VarCalculaValidade_w		varchar(5);
cd_pessoa_fisica_w		varchar(50);
cd_medico_w			varchar(50);
nr_horas_validade_w		bigint;
VarEstenderPrescricao_w		varchar(5);
ie_mesmo_zerado_w		varchar(1);
ie_situacao_w			varchar(5);
nr_seq_alter_p     bigint:=0;

 
c01 CURSOR FOR 
SELECT	nr_prescricao, 
nr_sequencia 
from	prescr_material 
where	nr_prescricao in (nr_prescricoes_p) 
and	cd_intervalo = cd_intervalo_p 
and	cd_material = cd_material_p;


BEGIN 
 
select	coalesce(max(ie_situacao),'A') 
into STRICT	ie_situacao_w 
from	material 
where	cd_material	= cd_material_novo_p;
 
if (ie_situacao_w = 'I') then 
CALL Wheb_mensagem_pck.exibir_mensagem_abort(203614);
end if;
 
ie_gerar_kit_w := Obter_Param_Usuario(924, 5, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_gerar_kit_w);
VarCalculaValidade_w := Obter_Param_Usuario(924, 98, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, VarCalculaValidade_w);
VarEstenderPrescricao_w := Obter_Param_Usuario(924, 249, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, VarEstenderPrescricao_w);
 
if (nr_prescricao_p = 0) then 
 
select 	Obter_Max_NrPrescricao(nr_prescricoes_p) 
into STRICT	nr_prescricao_w
;
else	 
nr_prescricao_w := nr_prescricao_p;
end if;
if (nr_prescricao_w > 0) then	 
begin 
 
select nextval('prescr_medica_seq') 
into STRICT nr_prescricao_ww
;
 
select	coalesce(max(dt_primeiro_horario),clock_timestamp()), 
		max(nr_atendimento), 
		max(cd_setor_atendimento), 
		max(cd_estabelecimento) 
into STRICT		dt_primeiro_horario_w, 
		nr_atendimento_w, 
		cd_setor_atendimento_w, 
		cd_estabelecimento_w 
from		prescr_medica 
where	nr_prescricao = nr_prescricao_w;
 
if (to_char(dt_primeiro_horario_w,'hh24:mi') < to_char(clock_timestamp(),'hh24:mi')) then 
	dt_primeiro_horario_w	:= clock_timestamp();
end if;
 
if (VarCalculaValidade_w	= 'R') then 
	VarCalculaValidade_w	:= obter_se_calcula_validade(cd_setor_atendimento_w);
end if;
 
if (VarCalculaValidade_w	<> 'N') then		 
	select	max(obter_horas_validade_prescr(dt_primeiro_horario_w,nr_atendimento_w,VarEstenderPrescricao_w,'A',clock_timestamp(),nr_prescricao_w)) 
	into STRICT	nr_horas_validade_w 
	;
end if;
 
cd_pessoa_fisica_w	:= obter_pessoa_fisica_usuario(nm_usuario_p,'C');
 
select	max(Obter_se_medico(cd_pessoa_fisica_w,'M')) 
into STRICT	ie_medico_w
;
 
if (ie_medico_w = 'S') then 
	cd_medico_w	:= cd_pessoa_fisica_w;
end if;
	 
insert into prescr_medica( 
	nr_prescricao, 
	cd_pessoa_fisica, 
	nr_atendimento, 
	cd_medico, 
	dt_prescricao, 
	dt_atualizacao, 
	nm_usuario, 
	nm_usuario_original, 
	ds_observacao, 
	nr_horas_validade, 
	cd_motivo_baixa, 
	dt_baixa, 
	dt_primeiro_horario, 
	dt_liberacao, 
	dt_emissao_setor, 
	dt_emissao_farmacia, 
	cd_setor_atendimento, 
	dt_entrada_unidade, 
	ie_recem_nato, 
	ie_origem_inf, 
	nr_prescricao_anterior, 
	nr_prescricao_mae, 
	cd_protocolo, 
	nr_seq_protocolo, 
	nr_cirurgia, 
	nr_seq_agenda, 
	cd_estabelecimento, 
	ds_medicacao_uso, 
	cd_prescritor, 
	qt_altura_cm, 
	qt_peso, 
	ie_adep, 
	ie_prescr_emergencia, 
	ie_prescricao_alta, 
	ie_hemodialise, 
	ie_motivo_prescricao, 
	nr_prescricoes) 
SELECT	nr_prescricao_ww, 
	cd_pessoa_fisica, 
	CASE WHEN nr_atendimento_p=0 THEN null  ELSE nr_atendimento_p END , 
	coalesce(cd_medico_w, cd_medico), 
	clock_timestamp(), 
	clock_timestamp(), 
	nm_usuario_p, 
	nm_usuario_p, 
	ds_observacao, 
	coalesce(nr_horas_validade_w, nr_horas_validade), 
	null, 
	null, 
	dt_primeiro_horario_w, 
	null, 
	null, 
	null, 
	cd_setor_atendimento, 
	null, 
	'N', 
	ie_origem_inf, 
	nr_prescricao_w, 
	nr_prescricao_mae, 
	cd_protocolo, 
	nr_seq_protocolo, 
	nr_cirurgia, 
	null, 
	cd_estabelecimento, 
	ds_medicacao_uso, 
	coalesce(cd_pessoa_fisica_w,cd_prescritor), 
	qt_altura_cm, 
	qt_peso, 
	ie_adep, 
	'N', 
	'N', 
	ie_hemodialise, 
	ie_motivo_prescricao, 
	nr_prescricoes_p 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_w;
 
commit;
hr_dose_especial_w	:= hr_dose_especial_p;
if (hr_dose_especial_p = ' : ') then 
	hr_dose_especial_w	:= '';
end if;
 
if (nr_seq_item_p = 0) then 
	 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_item_w 
	from 	prescr_material 
	where	nr_prescricao = nr_prescricao_w	 
	and	cd_material = cd_material_p 
	and	cd_intervalo = cd_intervalo_p 
	and	obter_se_acm_sn(ie_acm, ie_se_necessario) = ie_acm_sn_p;
else 
	nr_seq_item_w := nr_seq_item_p;
end if;
 
if (nr_seq_item_w IS NOT NULL AND nr_seq_item_w::text <> '') and (nr_seq_item_w > 0) then 
	begin 
	 
	select	max(nr_horas_validade) 
	into STRICT	nr_horas_validade_w 
	from	prescr_medica 
	where	nr_prescricao	= nr_prescricao_ww;
		 
	Insert into Prescr_Material( 
		nr_prescricao, 
		nr_sequencia, 
		ie_origem_inf, 
		cd_material, 
		cd_unidade_medida, 
		qt_dose, 
		qt_unitaria, 
		qt_material, 
		dt_atualizacao, 
		nm_usuario, 
		cd_intervalo, 
		ds_horarios, 
		ds_observacao, 
		ds_observacao_enf, 
		ie_via_aplicacao, 
		nr_agrupamento, 
		ie_cobra_paciente, 
		cd_motivo_baixa, 
		dt_baixa, 
		ie_utiliza_kit, 
		cd_unidade_medida_dose, 
		qt_conversao_dose, 
		ie_urgencia, 
		nr_ocorrencia, 
		qt_total_dispensar, 
		cd_fornec_consignado, 
		nr_sequencia_solucao, 
		nr_sequencia_proc, 
		qt_solucao, 
		hr_dose_especial, 
		qt_dose_especial, 
		ds_dose_diferenciada, 
		ie_medicacao_paciente, 
		nr_sequencia_diluicao, 
		hr_prim_horario, 
		nr_sequencia_dieta, 
		ie_agrupador, 
		nr_dia_util, 
		ie_suspenso, 
		ie_se_necessario, 
		qt_min_aplicacao, 
		ie_bomba_infusao, 
		ie_aplic_bolus, 
		ie_aplic_lenta, 
		ie_acm, 
		ie_objetivo, 
		cd_topografia_cih, 
		ie_origem_infeccao, 
		cd_amostra_cih, 
		cd_microorganismo_cih, 
		ie_uso_antimicrobiano, 
		cd_protocolo, 
		nr_seq_protocolo, 
		nr_seq_mat_protocolo, 
		qt_hora_aplicacao, 
		ie_recons_diluente_fixo, 
		qt_vel_infusao, 
		ds_justificativa, 
		ie_sem_aprazamento, 
		ie_indicacao, 
		dt_proxima_dose, 
		qt_total_dias_lib, 
		nr_seq_substituto, 
		ie_lado, 
		dt_inicio_medic, 
		qt_dia_prim_hor, 
		ie_regra_disp, 
		qt_vol_adic_reconst, 
		qt_hora_intervalo, 
		qt_min_intervalo, 
		ie_permite_substituir, 
		ie_dose_espec_agora)		 
	SELECT nr_prescricao_ww, 
			nr_seq_item_w, 
		a.ie_origem_inf, 
		cd_material_novo_p, 
		a.cd_unidade_medida, 
		qt_dose_p, 
		a.qt_unitaria, 
		a.qt_material, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_intervalo_novo_p, 
		ds_horarios_p, 
		--a.ds_observacao, 
		ds_observacao_subs_p, 
		a.ds_observacao_enf, 
		ie_via_aplicacao_p, 
		a.nr_agrupamento, 
		coalesce(a.ie_cobra_paciente,'S'),		 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.cd_motivo_baixa  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  0  ELSE a.cd_motivo_baixa END  END , 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  clock_timestamp()  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  null  ELSE clock_timestamp() END  END , 
		a.ie_utiliza_kit, 
		cd_unidade_med_p, 
		a.qt_conversao_dose, 
		coalesce(ie_urgencia_p,'N'), 
		ceil(obter_ocorrencia_intervalo(cd_intervalo_novo_p,coalesce(nr_horas_validade_w,24),'O')), 
		a.qt_total_dispensar, 
		a.cd_fornec_consignado, 
		null, 
		null, 
		a.qt_solucao, 
		hr_dose_especial_w, 
		CASE WHEN qt_dose_esp_p=0 THEN  null  ELSE qt_dose_esp_p END , 
		ds_dose_dif_p, 
		a.ie_medicacao_paciente, 
		a.nr_sequencia_diluicao, 
		to_char(dt_primeiro_horario_p, 'hh24:mi'), 
		null, 
		a.ie_agrupador, 
		a.nr_dia_util, 
		CASE WHEN b.ie_situacao='A' THEN  'N'  ELSE 'S' END , 
		coalesce(ie_se_necessario_p,a.ie_se_necessario), 
		CASE WHEN a.IE_VIA_APLICACAO=ie_via_aplicacao_p THEN  a.qt_min_aplicacao  ELSE null END , 
		a.ie_bomba_infusao, 
		coalesce(a.ie_aplic_bolus,'N'), 
		coalesce(a.ie_aplic_lenta,'N'), 
		coalesce(ie_acm_p,coalesce(a.ie_acm,'N')), 
		a.ie_objetivo, 
		a.cd_topografia_cih, 
		a.ie_origem_infeccao, 
		a.cd_amostra_cih, 
		a.cd_microorganismo_cih, 
		coalesce(a.ie_uso_antimicrobiano,'N'), 
		a.cd_protocolo, 
		a.nr_seq_protocolo, 
		a.nr_seq_mat_protocolo, 
		CASE WHEN a.IE_VIA_APLICACAO=ie_via_aplicacao_p THEN  a.qt_hora_aplicacao  ELSE null END , 
		'N', 
		a.qt_vel_infusao, 
		ds_justificativa_p, 
		a.ie_sem_aprazamento, 
		a.ie_indicacao, 
		a.dt_proxima_dose, 
		a.qt_total_dias_lib, 
		a.nr_seq_substituto, 
		a.ie_lado, 
		a.dt_inicio_medic,		 
		a.qt_dia_prim_hor, 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.ie_regra_disp  ELSE null END , 
		a.qt_vol_adic_reconst, 
		a.qt_hora_intervalo, 
		a.qt_min_intervalo, 
		ie_permite_substituir, 
		coalesce(ie_dose_especial_p,'N') 
	From	Material b, 
		Prescr_Material a 
	where	a.cd_material 	= b.cd_material 
	and	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia	= nr_seq_item_w;
	 
	select	substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo 
	into STRICT	cd_unidade_medida_consumo_w 
	from	material b 
	where	b.cd_material = cd_material_novo_p;
	 
	if (cd_unidade_medida_consumo_w = cd_unidade_med_p) then 
		qt_conversao_dose_w	:= 1;
	else 
		begin 
		select	coalesce(max(qt_conversao),1) 
		into STRICT	qt_conversao_dose_w 
		from	material_conversao_unidade 
		where	cd_material		= cd_material_novo_p 
		and	cd_unidade_medida	= cd_unidade_med_p;
		exception 
			when others then 
				qt_conversao_dose_w	:= 1;
		end;
	end if;
 
	qt_unitaria_w		:= dividir(qt_dose_p,qt_conversao_dose_w);
	 
	select	max(ceil(obter_ocorrencia_intervalo(cd_intervalo_novo_p,coalesce(nr_horas_validade_w,24),'O'))) 
	into STRICT	nr_ocorrencia_w 
	;
	 
	--Alan/Edilson OS 278823 
	if (ie_acm_p = 'S') or (ie_se_necessario_p = 'S') then 
		 
		select	coalesce(max(b.qt_se_necessario),0), 
				coalesce(max(b.ie_mesmo_zerado),'N') 
		into STRICT		nr_ocorrencia_w, 
				ie_mesmo_zerado_w 
		from		intervalo_prescricao a, 
				intervalo_setor b 
		where	a.cd_intervalo 		= b.cd_intervalo 
		and		coalesce(b.cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w 
		and		coalesce(b.cd_estab, cd_estabelecimento_w)			= cd_estabelecimento_w 
		and		a.cd_intervalo 		= cd_intervalo_novo_p 
		and		((b.cd_material = cd_material_novo_p) or (coalesce(b.cd_material::text, '') = '')) 
		and		((b.ie_via_aplicacao = coalesce(ie_via_aplicacao_p,b.ie_via_aplicacao)) or (coalesce(b.ie_via_aplicacao::text, '') = '')) 
		and		((b.cd_unidade_basica = coalesce(obter_unid_atend_setor_atual(nr_atendimento_p,cd_setor_atendimento_w,'UB'),b.cd_unidade_basica)) or (coalesce(b.cd_unidade_basica::text, '') = ''));
		 
		if (coalesce(nr_ocorrencia_w,0) = 0) and (ie_mesmo_zerado_w = 'N') then 
			Select	coalesce(max(qt_se_necessario),1) 
			into STRICT	nr_ocorrencia_w 
			from	intervalo_prescricao 
			where	cd_intervalo = cd_intervalo_novo_p;
		end if;
		 
		update	prescr_material 
		set 	nr_ocorrencia		= nr_ocorrencia_w 
		where	nr_prescricao 		= nr_prescricao_ww 
		and	nr_sequencia		= nr_seq_item_w;
	end if;
	--Alan/Edilson OS 278823 
	 
	SELECT * FROM Obter_Quant_Dispensar(	cd_estabelecimento_p, cd_material_novo_p, nr_prescricao_ww, nr_seq_item_w, cd_intervalo_novo_p, ie_via_aplicacao_p, qt_unitaria_w, 0, nr_ocorrencia_w, ds_dose_dif_p, null, cd_unidade_med_p, 1, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_p, ie_acm_p) INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;
			 
	update	prescr_material 
	set 	qt_total_dispensar	= qt_total_dispensar_w, 
		qt_material		= coalesce(qt_material_w,1), 
		QT_UNITARIA		= qt_unitaria_w, 
		ie_regra_disp		= CASE WHEN coalesce(ie_regra_disp,'X')='D' THEN  ie_regra_disp  ELSE ie_regra_disp_w END  
	where	nr_prescricao 		= nr_prescricao_ww 
	and	nr_sequencia		= nr_seq_item_w;
	 
	select	max(nr_agrupamento) 
	into STRICT	nr_agrupamento_w 
	from	prescr_material a 
	where	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia	= nr_seq_item_w;
	 
	/* Inserir os itens compostos também*/
 
	Insert into Prescr_Material( 
		nr_prescricao, 
		nr_sequencia, 
		ie_origem_inf, 
		cd_material, 
		cd_unidade_medida, 
		qt_dose, 
		qt_unitaria, 
		qt_material, 
		dt_atualizacao, 
		nm_usuario, 
		cd_intervalo, 
		ds_horarios, 
		ds_observacao, 
		ds_observacao_enf, 
		ie_via_aplicacao, 
		nr_agrupamento, 
		ie_cobra_paciente, 
		cd_motivo_baixa, 
		dt_baixa, 
		ie_utiliza_kit, 
		cd_unidade_medida_dose, 
		qt_conversao_dose, 
		ie_urgencia, 
		nr_ocorrencia, 
		qt_total_dispensar, 
		cd_fornec_consignado, 
		nr_sequencia_solucao, 
		nr_sequencia_proc, 
		qt_solucao, 
		hr_dose_especial, 
		qt_dose_especial, 
		ds_dose_diferenciada, 
		ie_medicacao_paciente, 
		nr_sequencia_diluicao, 
		hr_prim_horario, 
		nr_sequencia_dieta, 
		ie_agrupador, 
		nr_dia_util, 
		ie_suspenso, 
		ie_se_necessario, 
		qt_min_aplicacao, 
		ie_bomba_infusao, 
		ie_aplic_bolus, 
		ie_aplic_lenta, 
		ie_acm, 
		ie_objetivo, 
		cd_topografia_cih, 
		ie_origem_infeccao, 
		cd_amostra_cih, 
		cd_microorganismo_cih, 
		ie_uso_antimicrobiano, 
		cd_protocolo, 
		nr_seq_protocolo, 
		nr_seq_mat_protocolo, 
		qt_hora_aplicacao, 
		ie_recons_diluente_fixo, 
		qt_vel_infusao, 
		ds_justificativa, 
		ie_sem_aprazamento, 
		ie_indicacao, 
		dt_proxima_dose, 
		qt_total_dias_lib, 
		nr_seq_substituto, 
		ie_lado, 
		dt_inicio_medic, 
		qt_dia_prim_hor, 
		ie_regra_disp, 
		qt_vol_adic_reconst, 
		qt_hora_intervalo, 
		qt_min_intervalo, 
		ie_permite_substituir, 
		ie_dose_espec_agora)		 
	SELECT nr_prescricao_ww, 
			nr_sequencia, 
		a.ie_origem_inf, 
		a.cd_material, 
		a.cd_unidade_medida, 
		a.qt_dose, 
		a.qt_unitaria, 
		coalesce(a.qt_material,1), 
		clock_timestamp(), 
		nm_usuario_p, 
		a.cd_intervalo, 
		ds_horarios_p, 
		ds_observacao_subs_p, 
		a.ds_observacao_enf, 
		a.ie_via_aplicacao, 
		a.nr_agrupamento, 
		coalesce(a.ie_cobra_paciente,'S'),		 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.cd_motivo_baixa  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  0  ELSE a.cd_motivo_baixa END  END , 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  clock_timestamp()  ELSE CASE WHEN coalesce(a.ie_cobra_paciente,'S')='S' THEN  null  ELSE clock_timestamp() END  END , 
		a.ie_utiliza_kit, 
		a.cd_unidade_medida_dose, 
		a.qt_conversao_dose, 
		coalesce(ie_urgencia_p,'N'), 
		a.nr_ocorrencia, 
		a.qt_total_dispensar, 
		a.cd_fornec_consignado, 
		null, 
		null, 
		a.qt_solucao, 
		a.hr_dose_especial, 
		a.qt_dose_especial, 
		a.ds_dose_diferenciada, 
		a.ie_medicacao_paciente, 
		a.nr_sequencia_diluicao, 
		to_char(dt_primeiro_horario_p, 'hh24:mi'), 
		null, 
		a.ie_agrupador, 
		a.nr_dia_util, 
		CASE WHEN b.ie_situacao='A' THEN  'N'  ELSE 'S' END , 
		coalesce(ie_se_necessario_p,a.ie_se_necessario), 
		a.qt_min_aplicacao, 
		a.ie_bomba_infusao, 
		coalesce(a.ie_aplic_bolus,'N'), 
		coalesce(a.ie_aplic_lenta,'N'), 
		coalesce(ie_acm_p,coalesce(a.ie_acm,'N')), 
		a.ie_objetivo, 
		a.cd_topografia_cih, 
		a.ie_origem_infeccao, 
		a.cd_amostra_cih, 
		a.cd_microorganismo_cih, 
		coalesce(a.ie_uso_antimicrobiano,'N'), 
		a.cd_protocolo, 
		a.nr_seq_protocolo, 
		a.nr_seq_mat_protocolo, 
		a.qt_hora_aplicacao, 
		'N', 
		a.qt_vel_infusao, 
		ds_justificativa_p, 
		a.ie_sem_aprazamento, 
		a.ie_indicacao, 
		a.dt_proxima_dose, 
		a.qt_total_dias_lib, 
		a.nr_seq_substituto, 
		a.ie_lado, 
		a.dt_inicio_medic,		 
		a.qt_dia_prim_hor, 
		CASE WHEN coalesce(a.ie_regra_disp,'X')='D' THEN  a.ie_regra_disp  ELSE null END , 
		a.qt_vol_adic_reconst, 
		a.qt_hora_intervalo, 
		a.qt_min_intervalo, 
		ie_permite_substituir, 
		a.ie_dose_espec_agora 
	From	Material b, 
		Prescr_Material a 
	where	a.cd_material 	= b.cd_material 
	and	a.nr_prescricao = nr_prescricao_w 
	and	a.nr_sequencia	<> nr_seq_item_w 
	and	ie_agrupador	= 1 
	and	nr_agrupamento	= nr_agrupamento_w;
	 
	 
	CALL Gerar_Reconst_Diluicao(nr_prescricao_ww, nr_seq_item_w, 'A');
	if (ie_gerar_kit_w = 'S') then 
		CALL Gerar_Kit_Medic_Prescricao(cd_estabelecimento_p, nr_prescricao_ww, nr_seq_item_w, nm_usuario_p);
	end if;
	ds_erro_w := Liberar_Prescricao(nr_prescricao_ww, nr_atendimento_p, ie_tipo_pessoa_p, cd_perfil_p, nm_usuario_p, 'N', ds_erro_w);
 
	if (ie_susp_anterior_p = 'S') then 
		begin 
		if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_w IS NOT NULL AND nr_seq_item_w::text <> '') then 
			begin 
						 
			CALL Suspender_item_Prescricao(nr_prescricao_w,nr_seq_item_w,0,NULL,'PRESCR_MATERIAL',nm_usuario_p,'S',924);
			 
			end;
		elsif (nr_prescricoes_p IS NOT NULL AND nr_prescricoes_p::text <> '') and (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then 
			begin 
			 
			open c01;
			loop 
			fetch c01 into 
				nr_prescricao_w, 
				nr_seq_item_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				CALL Suspender_item_Prescricao(nr_prescricao_w,nr_seq_item_w,0,NULL,'PRESCR_MATERIAL',nm_usuario_p,'S',924);	
			end loop;
			close c01;
			 
			end;
		end if;
		end;
	end if;	
 
	ds_erro_p := ds_erro_w;	
	 
	commit;	
	end;
end if;
 
nr_seq_alter_p := PLT_atualizar_gerar_evento('M', nr_prescricao_w, nr_seq_item_w, cd_material_p, 'SS', '', nr_seq_alter_p, nm_usuario_p);
nr_seq_alter_p := PLT_atualizar_gerar_evento('M', nr_prescricao_ww, nr_seq_item_w, cd_material_novo_p, 'IS', '', nr_seq_alter_p, nm_usuario_p);		
 
end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_prescricao_item ( cd_estabelecimento_p bigint, nr_prescricao_p bigint, nr_atendimento_p bigint, cd_material_novo_p bigint, cd_material_p bigint, nr_seq_item_p bigint, cd_intervalo_p text, cd_intervalo_novo_p text, ie_acm_sn_p text, qt_dose_p bigint, ie_via_aplicacao_p text, nr_prescricoes_p text, dt_primeiro_horario_p timestamp, cd_unidade_med_p text, ds_horarios_p text, ie_susp_anterior_p text, ie_tipo_pessoa_p text, cd_perfil_p bigint, nm_usuario_p text, ds_erro_p INOUT text, ds_dose_dif_p text, qt_dose_esp_p bigint, ds_justificativa_p text, ds_observacao_subs_p text, hr_dose_especial_p text, ie_dose_especial_p text, ie_se_necessario_p text, ie_acm_p text, ie_urgencia_p text ) FROM PUBLIC;
