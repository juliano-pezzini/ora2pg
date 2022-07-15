-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_medic_nova_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_prescritor_p text, cd_motivo_p bigint, ds_motivo_p text, nm_usuario_p text, nr_nova_prescricao_p INOUT bigint) AS $body$
DECLARE

 
cd_pessoa_fisica_w	varchar(20);
ie_medico_w		varchar(20);
nr_atendimento_w	bigint;
nr_prescricao_w		bigint;
nr_seq_acum_w		bigint;
nr_seq_diluente_w	bigint;
nr_seq_kit_w		bigint;
cd_motivo_baixa_prescr_w bigint;
cd_estabelecimento_w	bigint;
ds_erro_w		varchar(2000);
ie_cancelar_itens_w	varchar(10);


BEGIN 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	prescr_medica 
where	nr_prescricao	= nr_prescricao_p;
 
ie_cancelar_itens_w := obter_param_usuario(7010, 17, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cancelar_itens_w);
 
select	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	prescr_medica 
where	nr_prescricao	= nr_prescricao_p;
 
if (coalesce(nr_nova_prescricao_p,0) = 0) then 
	Select	nextval('prescr_medica_seq') 
	into STRICT	nr_prescricao_w 
	;
 
	insert into prescr_medica( 
 		NR_PRESCRICAO, 
	 	CD_PESSOA_FISICA, 
		NR_ATENDIMENTO, 
		CD_MEDICO, 
		DT_PRESCRICAO, 
		DT_ATUALIZACAO, 
		NM_USUARIO, 
		NM_USUARIO_ORIGINAL, 
		DS_OBSERVACAO, 
		NR_HORAS_VALIDADE, 
		CD_MOTIVO_BAIXA, 
		DT_BAIXA, 
		DT_PRIMEIRO_HORARIO, 
		DT_LIBERACAO, 
		DT_EMISSAO_SETOR, 
		DT_EMISSAO_FARMACIA, 
		CD_SETOR_ATENDIMENTO, 
		DT_ENTRADA_UNIDADE, 
		IE_RECEM_NATO, 
		IE_ORIGEM_INF, 
		NR_PRESCRICAO_ANTERIOR, 
		NR_PRESCRICAO_MAE, 
		CD_PROTOCOLO, 
		NR_SEQ_PROTOCOLO, 
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
		dt_liberacao_medico, 
		ie_lib_farm, 
		nr_prescricao_original, 
		nr_seq_transcricao, 
		cd_local_estoque) 
	SELECT	nr_prescricao_w, 
		cd_pessoa_fisica, 
		CASE WHEN nr_atendimento_w=0 THEN null  ELSE nr_atendimento_w END , 
		CD_MEDICO, 
		dt_prescricao, 
		clock_timestamp(), 
		NM_USUARIO_P, 
		NM_USUARIO_original, 
		ds_observacao, 
		nr_horas_validade, 
		null, 
		null, 
		dt_primeiro_horario, 
		dt_liberacao, 
		null, 
		null, 
		cd_setor_atendimento, 
		null, 
		'N', 
		ie_origem_inf, 
		nr_prescricao_p, 
		NR_PRESCRICAO_MAE, 
		CD_PROTOCOLO, 
		NR_SEQ_PROTOCOLO, 
		nr_cirurgia, 
		nr_seq_agenda, 
		cd_estabelecimento, 
		ds_medicacao_uso, 
		cd_prescritor_p, 
		obter_sinal_vital(nr_atendimento_w,'Altura'), 
		obter_sinal_vital(nr_atendimento_w,'Peso'), 
		ie_adep, 
		'N', 
		'N', 
		ie_hemodialise, 
		dt_liberacao_medico, 
		ie_lib_farm, 
		nr_prescricao_p, 
		nr_seq_transcricao, 
		cd_local_estoque 
	from	prescr_medica 
	where	nr_prescricao = NR_PRESCRICAO_P;
 
	commit;
 
end if;
 
select	coalesce(max(nr_sequencia),0) + 1 
into STRICT	nr_seq_acum_w 
from	prescr_material 
where	nr_prescricao = CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END;
 
Insert into Prescr_Material( 
	NR_PRESCRICAO, 
	NR_SEQUENCIA, 
	IE_ORIGEM_INF, 
	CD_MATERIAL, 
	CD_UNIDADE_MEDIDA, 
	QT_DOSE, 
	QT_UNITARIA, 
	QT_MATERIAL, 
	DT_ATUALIZACAO, 
	NM_USUARIO, 
	CD_INTERVALO, 
	DS_HORARIOS, 
	DS_OBSERVACAO, 
	DS_OBSERVACAO_ENF, 
	IE_VIA_APLICACAO, 
	NR_AGRUPAMENTO, 
	ie_cobra_paciente, 
	CD_MOTIVO_BAIXA, 
	DT_BAIXA, 
	IE_UTILIZA_KIT, 
	CD_UNIDADE_MEDIDA_DOSE, 
	QT_CONVERSAO_DOSE, 
	IE_URGENCIA, 
	NR_OCORRENCIA, 
	QT_TOTAL_DISPENSAR, 
	CD_FORNEC_CONSIGNADO, 
	QT_SOLUCAO, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	DS_DOSE_DIFERENCIADA, 
	IE_MEDICACAO_PACIENTE, 
	HR_PRIM_HORARIO, 
	IE_AGRUPADOR, 
	nr_dia_util, 
	IE_SUSPENSO, 
	IE_SE_NECESSARIO, 
	qt_min_aplicacao, 
	ie_bomba_infusao, 
	IE_APLIC_BOLUS, 
	IE_APLIC_LENTA, 
	ie_acm, 
	IE_OBJETIVO, 
	CD_TOPOGRAFIA_CIH, 
	IE_ORIGEM_INFECCAO, 
	CD_AMOSTRA_CIH, 
	CD_MICROORGANISMO_CIH, 
	IE_USO_ANTIMICROBIANO, 
	CD_PROTOCOLO, 
	NR_SEQ_PROTOCOLO, 
	NR_SEQ_MAT_PROTOCOLO, 
	QT_HORA_APLICACAO, 
	IE_RECONS_DILUENTE_FIXO, 
	QT_VEL_INFUSAO, 
	DS_JUSTIFICATIVA, 
	IE_SEM_APRAZAMENTO, 
	IE_INDICACAO, 
	DT_PROXIMA_DOSE, 
	QT_TOTAL_DIAS_LIB, 
	NR_SEQ_SUBSTITUTO, 
	IE_LADO, 
	dt_inicio_medic, 
	qt_dia_prim_hor, 
	ie_regra_disp, 
	qt_vol_adic_reconst, 
	qt_hora_intervalo, 
	qt_min_intervalo, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far) 
SELECT CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END , 
   	--nr_seq_acum_w, 
	coalesce(NR_SEQUENCIA,0), 
 	a.IE_ORIGEM_INF, 
	a.CD_MATERIAL, 
 	a.CD_UNIDADE_MEDIDA, 
 	a.QT_DOSE, 
 	a.QT_UNITARIA, 
 	a.qt_material, 
	clock_timestamp(), 
	NM_USUARIO_P, 
 	a.CD_INTERVALO, 
 	a.DS_HORARIOS, 
	a.DS_OBSERVACAO, 
	A.DS_OBSERVACAO_ENF, 
 	a.IE_VIA_APLICACAO, 
	a.NR_AGRUPAMENTO, 
	coalesce(a.ie_cobra_paciente,'S'), 
	a.cd_motivo_baixa, 
	a.dt_baixa, 
	a.IE_UTILIZA_KIT, 
	a.CD_UNIDADE_MEDIDA_DOSE, 
	a.QT_CONVERSAO_DOSE, 
	ie_urgencia, 
	a.NR_OCORRENCIA, 
	a.qt_total_dispensar, 
	a.CD_FORNEC_CONSIGNADO, 
	a.qt_solucao, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	a.ds_dose_diferenciada, 
	a.ie_medicacao_paciente, 
	HR_PRIM_HORARIO, 
	a.IE_AGRUPADOR, 
	a.nr_dia_util, 
	IE_SUSPENSO, 
	a.ie_se_necessario, 
	a.qt_min_aplicacao, 
	a.ie_bomba_infusao, 
	coalesce(a.IE_APLIC_BOLUS,'N'), 
	coalesce(a.IE_APLIC_LENTA,'N'), 
	coalesce(a.ie_acm,'N'), 
	a.IE_OBJETIVO, 
	a.CD_TOPOGRAFIA_CIH, 
	a.IE_ORIGEM_INFECCAO, 
	a.CD_AMOSTRA_CIH, 
	a.CD_MICROORGANISMO_CIH, 
	coalesce(a.IE_USO_ANTIMICROBIANO,'N'), 
	A.CD_PROTOCOLO, 
	A.NR_SEQ_PROTOCOLO, 
	A.NR_SEQ_MAT_PROTOCOLO, 
	A.QT_HORA_APLICACAO, 
	a.IE_RECONS_DILUENTE_FIXO, 
	A.QT_VEL_INFUSAO, 
	a.DS_JUSTIFICATIVA, 
	A.IE_SEM_APRAZAMENTO, 
	A.IE_INDICACAO, 
	A.DT_PROXIMA_DOSE, 
	a.QT_TOTAL_DIAS_LIB, 
	A.NR_SEQ_SUBSTITUTO, 
	A.IE_LADO, 
	a.dt_inicio_medic, 
	a.qt_dia_prim_hor, 
	ie_regra_disp, 
	a.qt_vol_adic_reconst, 
	a.qt_hora_intervalo, 
	a.qt_min_intervalo, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far 
From	Material b, 
	Prescr_Material a 
where	b.cd_material	= a.cd_material 
and	a.nr_prescricao = nr_prescricao_p 
and	a.nr_sequencia	= nr_sequencia_p 
and	a.ie_suspenso 	<> 'S';
 
commit;
 
/* Gerar diluentes e reconstituentes */
 
select	coalesce(max(nr_sequencia),0) +1 
into STRICT	nr_seq_diluente_w 
from	prescr_material 
where	nr_prescricao = CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END;
 
Insert into Prescr_Material( 
	NR_PRESCRICAO, 
	NR_SEQUENCIA, 
	IE_ORIGEM_INF, 
	CD_MATERIAL, 
	CD_UNIDADE_MEDIDA, 
	QT_DOSE, 
	QT_UNITARIA, 
	QT_MATERIAL, 
	DT_ATUALIZACAO, 
	NM_USUARIO, 
	CD_INTERVALO, 
	DS_HORARIOS, 
	DS_OBSERVACAO, 
	DS_OBSERVACAO_ENF, 
	IE_VIA_APLICACAO, 
	NR_AGRUPAMENTO, 
	ie_cobra_paciente, 
	CD_MOTIVO_BAIXA, 
	DT_BAIXA, 
	IE_UTILIZA_KIT, 
	CD_UNIDADE_MEDIDA_DOSE, 
	QT_CONVERSAO_DOSE, 
	IE_URGENCIA, 
	NR_OCORRENCIA, 
	QT_TOTAL_DISPENSAR, 
	CD_FORNEC_CONSIGNADO, 
	QT_SOLUCAO, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	DS_DOSE_DIFERENCIADA, 
	IE_MEDICACAO_PACIENTE, 
	HR_PRIM_HORARIO, 
	IE_AGRUPADOR, 
	nr_dia_util, 
	IE_SUSPENSO, 
	IE_SE_NECESSARIO, 
	qt_min_aplicacao, 
	ie_bomba_infusao, 
	IE_APLIC_BOLUS, 
	IE_APLIC_LENTA, 
	ie_acm, 
	IE_OBJETIVO, 
	CD_TOPOGRAFIA_CIH, 
	IE_ORIGEM_INFECCAO, 
	CD_AMOSTRA_CIH, 
	CD_MICROORGANISMO_CIH, 
	IE_USO_ANTIMICROBIANO, 
	CD_PROTOCOLO, 
	NR_SEQ_PROTOCOLO, 
	NR_SEQ_MAT_PROTOCOLO, 
	QT_HORA_APLICACAO, 
	IE_RECONS_DILUENTE_FIXO, 
	QT_VEL_INFUSAO, 
	DS_JUSTIFICATIVA, 
	IE_SEM_APRAZAMENTO, 
	IE_INDICACAO, 
	DT_PROXIMA_DOSE, 
	QT_TOTAL_DIAS_LIB, 
	NR_SEQ_SUBSTITUTO, 
	IE_LADO, 
	dt_inicio_medic, 
	qt_dia_prim_hor, 
	ie_regra_disp, 
	qt_vol_adic_reconst, 
	qt_hora_intervalo, 
	qt_min_intervalo, 
	nr_sequencia_diluicao, 
	CD_KIT_MATERIAL, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far)		 
SELECT CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END , 
   	coalesce(nr_sequencia,0), 
 	a.IE_ORIGEM_INF, 
	a.CD_MATERIAL, 
 	a.CD_UNIDADE_MEDIDA, 
 	a.QT_DOSE, 
 	a.QT_UNITARIA, 
 	a.qt_material, 
	clock_timestamp(), 
	NM_USUARIO_P, 
 	a.CD_INTERVALO, 
 	a.DS_HORARIOS, 
	a.DS_OBSERVACAO, 
	A.DS_OBSERVACAO_ENF, 
 	a.IE_VIA_APLICACAO, 
	a.NR_AGRUPAMENTO, 
	coalesce(a.ie_cobra_paciente,'S'), 
	a.cd_motivo_baixa, 
	a.dt_baixa, 
	a.IE_UTILIZA_KIT, 
	a.CD_UNIDADE_MEDIDA_DOSE, 
	a.QT_CONVERSAO_DOSE, 
	ie_urgencia, 
	a.NR_OCORRENCIA, 
	a.qt_total_dispensar, 
	a.CD_FORNEC_CONSIGNADO, 
	a.qt_solucao, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	a.ds_dose_diferenciada, 
	a.ie_medicacao_paciente, 
	HR_PRIM_HORARIO, 
	a.IE_AGRUPADOR, 
	a.nr_dia_util, 
	IE_SUSPENSO, 
	a.ie_se_necessario, 
	a.qt_min_aplicacao, 
	a.ie_bomba_infusao, 
	coalesce(a.IE_APLIC_BOLUS,'N'), 
	coalesce(a.IE_APLIC_LENTA,'N'), 
	coalesce(a.ie_acm,'N'), 
	a.IE_OBJETIVO, 
	a.CD_TOPOGRAFIA_CIH, 
	a.IE_ORIGEM_INFECCAO, 
	a.CD_AMOSTRA_CIH, 
	a.CD_MICROORGANISMO_CIH, 
	coalesce(a.IE_USO_ANTIMICROBIANO,'N'), 
	A.CD_PROTOCOLO, 
	A.NR_SEQ_PROTOCOLO, 
	A.NR_SEQ_MAT_PROTOCOLO, 
	A.QT_HORA_APLICACAO, 
	a.IE_RECONS_DILUENTE_FIXO, 
	A.QT_VEL_INFUSAO, 
	a.DS_JUSTIFICATIVA, 
	A.IE_SEM_APRAZAMENTO, 
	A.IE_INDICACAO, 
	A.DT_PROXIMA_DOSE, 
	a.QT_TOTAL_DIAS_LIB, 
	A.NR_SEQ_SUBSTITUTO, 
	A.IE_LADO, 
	a.dt_inicio_medic, 
	a.qt_dia_prim_hor, 
	ie_regra_disp, 
	a.qt_vol_adic_reconst, 
	a.qt_hora_intervalo, 
	a.qt_min_intervalo, 
	a.nr_sequencia_diluicao, 
	a.CD_KIT_MATERIAL, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far 
From	Material b, 
	Prescr_Material a 
where	b.cd_material		= a.cd_material 
and	a.nr_prescricao 	= nr_prescricao_p 
and	a.nr_sequencia_diluicao	= nr_sequencia_p 
and	a.ie_suspenso 		<> 'S';
 
commit;
 
/* Gerar kit */
 
select	coalesce(max(nr_sequencia),0) +1 
into STRICT	nr_seq_kit_w 
from	prescr_material 
where	nr_prescricao = CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END;
 
Insert into Prescr_Material( 
	NR_PRESCRICAO, 
	NR_SEQUENCIA, 
	IE_ORIGEM_INF, 
	CD_MATERIAL, 
	CD_UNIDADE_MEDIDA, 
	QT_DOSE, 
	QT_UNITARIA, 
	QT_MATERIAL, 
	DT_ATUALIZACAO, 
	NM_USUARIO, 
	CD_INTERVALO, 
	DS_HORARIOS, 
	DS_OBSERVACAO, 
	DS_OBSERVACAO_ENF, 
	IE_VIA_APLICACAO, 
	NR_AGRUPAMENTO, 
	ie_cobra_paciente, 
	CD_MOTIVO_BAIXA, 
	DT_BAIXA, 
	IE_UTILIZA_KIT, 
	CD_UNIDADE_MEDIDA_DOSE, 
	QT_CONVERSAO_DOSE, 
	IE_URGENCIA, 
	NR_OCORRENCIA, 
	QT_TOTAL_DISPENSAR, 
	CD_FORNEC_CONSIGNADO, 
	QT_SOLUCAO, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	DS_DOSE_DIFERENCIADA, 
	IE_MEDICACAO_PACIENTE, 
	HR_PRIM_HORARIO, 
	IE_AGRUPADOR, 
	nr_dia_util, 
	IE_SUSPENSO, 
	IE_SE_NECESSARIO, 
	qt_min_aplicacao, 
	ie_bomba_infusao, 
	IE_APLIC_BOLUS, 
	IE_APLIC_LENTA, 
	ie_acm, 
	IE_OBJETIVO, 
	CD_TOPOGRAFIA_CIH, 
	IE_ORIGEM_INFECCAO, 
	CD_AMOSTRA_CIH, 
	CD_MICROORGANISMO_CIH, 
	IE_USO_ANTIMICROBIANO, 
	CD_PROTOCOLO, 
	NR_SEQ_PROTOCOLO, 
	NR_SEQ_MAT_PROTOCOLO, 
	QT_HORA_APLICACAO, 
	IE_RECONS_DILUENTE_FIXO, 
	QT_VEL_INFUSAO, 
	DS_JUSTIFICATIVA, 
	IE_SEM_APRAZAMENTO, 
	IE_INDICACAO, 
	DT_PROXIMA_DOSE, 
	QT_TOTAL_DIAS_LIB, 
	NR_SEQ_SUBSTITUTO, 
	IE_LADO, 
	dt_inicio_medic, 
	qt_dia_prim_hor, 
	ie_regra_disp, 
	qt_vol_adic_reconst, 
	qt_hora_intervalo, 
	qt_min_intervalo, 
	nr_sequencia_diluicao, 
	nr_seq_kit, 
	nr_seq_kit_estoque, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far)		 
SELECT CASE WHEN coalesce(nr_nova_prescricao_p,0)=0 THEN  nr_prescricao_w  ELSE nr_nova_prescricao_p END , 
   	--nr_seq_kit_w, 
	coalesce(NR_SEQUENCIA,0), 
 	a.IE_ORIGEM_INF, 
	a.CD_MATERIAL, 
 	a.CD_UNIDADE_MEDIDA, 
 	a.QT_DOSE, 
 	a.QT_UNITARIA, 
 	a.qt_material, 
	clock_timestamp(), 
	NM_USUARIO_P, 
 	a.CD_INTERVALO, 
 	a.DS_HORARIOS, 
	a.DS_OBSERVACAO, 
	A.DS_OBSERVACAO_ENF, 
 	a.IE_VIA_APLICACAO, 
	a.NR_AGRUPAMENTO, 
	coalesce(a.ie_cobra_paciente,'S'), 
	a.cd_motivo_baixa, 
	a.dt_baixa, 
	a.IE_UTILIZA_KIT, 
	a.CD_UNIDADE_MEDIDA_DOSE, 
	a.QT_CONVERSAO_DOSE, 
	ie_urgencia, 
	a.NR_OCORRENCIA, 
	a.qt_total_dispensar, 
	a.CD_FORNEC_CONSIGNADO, 
	a.qt_solucao, 
	HR_DOSE_ESPECIAL, 
	QT_DOSE_ESPECIAL, 
	a.ds_dose_diferenciada, 
	a.ie_medicacao_paciente, 
	HR_PRIM_HORARIO, 
	a.IE_AGRUPADOR, 
	a.nr_dia_util, 
	IE_SUSPENSO, 
	a.ie_se_necessario, 
	a.qt_min_aplicacao, 
	a.ie_bomba_infusao, 
	coalesce(a.IE_APLIC_BOLUS,'N'), 
	coalesce(a.IE_APLIC_LENTA,'N'), 
	coalesce(a.ie_acm,'N'), 
	a.IE_OBJETIVO, 
	a.CD_TOPOGRAFIA_CIH, 
	a.IE_ORIGEM_INFECCAO, 
	a.CD_AMOSTRA_CIH, 
	a.CD_MICROORGANISMO_CIH, 
	coalesce(a.IE_USO_ANTIMICROBIANO,'N'), 
	A.CD_PROTOCOLO, 
	A.NR_SEQ_PROTOCOLO, 
	A.NR_SEQ_MAT_PROTOCOLO, 
	A.QT_HORA_APLICACAO, 
	a.IE_RECONS_DILUENTE_FIXO, 
	A.QT_VEL_INFUSAO, 
	a.DS_JUSTIFICATIVA, 
	A.IE_SEM_APRAZAMENTO, 
	A.IE_INDICACAO, 
	A.DT_PROXIMA_DOSE, 
	a.QT_TOTAL_DIAS_LIB, 
	A.NR_SEQ_SUBSTITUTO, 
	A.IE_LADO, 
	a.dt_inicio_medic, 
	a.qt_dia_prim_hor, 
	ie_regra_disp, 
	a.qt_vol_adic_reconst, 
	a.qt_hora_intervalo, 
	a.qt_min_intervalo, 
	a.NR_SEQUENCIA_DILUICAO, 
	a.nr_seq_kit, 
	a.nr_seq_kit_estoque, 
	nr_seq_atendimento, 
	nr_seq_material, 
	CD_MAT_SEM_APRESENT, 
	CD_LOCAL_ESTOQUE, 
	ds_observacao_far 
From	Material b, 
	Prescr_Material a 
where	b.cd_material		= a.cd_material 
and	a.nr_prescricao 	= nr_prescricao_p 
and	a.nr_seq_kit		= nr_sequencia_p 
and	a.ie_suspenso 		<> 'S';
commit;
 
select	max(cd_motivo_baixa_prescr) 
into STRICT	cd_motivo_baixa_prescr_w 
from	parametros_farmacia 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
if (cd_motivo_baixa_prescr_w IS NOT NULL AND cd_motivo_baixa_prescr_w::text <> '') and (ie_cancelar_itens_w	= 'N') then 
	 
	update	prescr_material 
	set	nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		ie_gerar_horario	= 'N', 
		cd_motivo_baixa		= cd_motivo_baixa_prescr_w, 
		dt_baixa		= clock_timestamp() 
	where	nr_prescricao	= nr_prescricao_p 
	and	nr_sequencia	= nr_sequencia_p;
 
	/*Diluentes de reconstituentes*/
 
	update	prescr_material 
	set	nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		ie_gerar_horario	= 'N', 
		cd_motivo_baixa		= cd_motivo_baixa_prescr_w, 
		dt_baixa		= clock_timestamp() 
	where	nr_prescricao		= nr_prescricao_p 
	and	nr_sequencia_diluicao	= nr_sequencia_p;
 
	/* Kit */
 
	update	prescr_material 
	set	nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		ie_gerar_horario	= 'N', 
		cd_motivo_baixa		= cd_motivo_baixa_prescr_w, 
		dt_baixa		= clock_timestamp() 
	where	nr_prescricao		= nr_prescricao_p 
	and	nr_seq_kit		= nr_sequencia_p;
 
else 
	update	prescr_material 
	set	ie_suspenso	= 'S', 
		nm_usuario	= nm_usuario_p, 
		dt_atualizacao	= clock_timestamp(), 
		dt_suspensao	= clock_timestamp(), 
		nm_usuario_susp	= nm_usuario_p, 
		ds_motivo_susp = ds_motivo_p, 
		nr_seq_motivo_susp = CASE WHEN cd_motivo_p=0 THEN  null  ELSE cd_motivo_p END  
	where	nr_prescricao	= nr_prescricao_p 
	and	nr_sequencia	= nr_sequencia_p;
 
	/*Diluentes de reconstituentes*/
 
	update	prescr_material 
	set	ie_suspenso		= 'S', 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		dt_suspensao		= clock_timestamp(), 
		nm_usuario_susp		= nm_usuario_p, 
		ds_motivo_susp 	= ds_motivo_p, 
		nr_seq_motivo_susp 	= CASE WHEN cd_motivo_p=0 THEN  null  ELSE cd_motivo_p END  
	where	nr_prescricao		= nr_prescricao_p 
	and	nr_sequencia_diluicao	= nr_sequencia_p;
 
	/* Kit */
 
	update	prescr_material 
	set	ie_suspenso		= 'S', 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp(), 
		dt_suspensao		= clock_timestamp(), 
		nm_usuario_susp		= nm_usuario_p, 
		ds_motivo_susp 	= ds_motivo_p, 
		nr_seq_motivo_susp 	= CASE WHEN cd_motivo_p=0 THEN  null  ELSE cd_motivo_p END  
	where	nr_prescricao		= nr_prescricao_p 
	and	nr_seq_kit		= nr_sequencia_p;
end if;
 
commit;
 
nr_nova_prescricao_p	:= coalesce(nr_prescricao_w, nr_nova_prescricao_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_medic_nova_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_prescritor_p text, cd_motivo_p bigint, ds_motivo_p text, nm_usuario_p text, nr_nova_prescricao_p INOUT bigint) FROM PUBLIC;

