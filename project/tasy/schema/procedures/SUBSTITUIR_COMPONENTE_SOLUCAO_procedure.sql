-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_componente_solucao ( nr_prescricao_p bigint, nr_seq_componente_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_componente_novo_p INOUT bigint) AS $body$
DECLARE


qt_registro_w			integer;
cd_motivo_baixa_w		varchar(3);
nr_seq_componente_w		integer;
nr_agrup_comp_w			double precision;
nr_sequencia_w			integer;
nr_seq_cpoe_ant_w		bigint;
nr_seq_cpoe_w			bigint;
nr_seq_alteracao_w		prescr_solucao_evento.nr_sequencia%type;
nr_seq_solucao_w		prescr_solucao.nr_seq_solucao%type;
ds_material_w			varchar(255);

c01 CURSOR FOR
SELECT	nr_sequencia,
		nr_seq_mat_cpoe,
		nr_sequencia_solucao
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
and		nr_sequencia		= nr_seq_componente_p
order by
		nr_sequencia;



BEGIN

begin
select	count(*)
into STRICT	qt_registro_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and		nr_sequencia	= nr_seq_componente_p
and		cd_motivo_baixa	<> 0
and		(dt_baixa IS NOT NULL AND dt_baixa::text <> '');
exception
	when others then
	qt_registro_w	:= 0;
end;

if (qt_registro_w > 0) then
	-- este medicamento já foi atendido e não pode ser substituído.
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 201232 );
	
end if;

cd_motivo_baixa_w := obter_param_usuario(924, 194, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_motivo_baixa_w);

if (coalesce(cd_motivo_baixa_w::text, '') = '') or (somente_numero(cd_motivo_baixa_w) = 0) then
	-- para poder substituir medicamentos, é necessário configurar o parâmetro 194 da função prescrição eletrônica paciente - rep.
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 201233 );
end if;

nr_seq_componente_w := null;

begin
select	substr(obter_desc_material(cd_material),1,255)
into STRICT	ds_material_w
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
and		nr_sequencia		= nr_seq_componente_p;
exception
	when others then
	ds_material_w	:= '';
end;

ds_material_w	:= substr(wheb_mensagem_pck.get_texto(1026402,null) || ': ' || ds_material_w,1,255);

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	nr_seq_cpoe_ant_w,
	nr_seq_solucao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	select	max(nr_agrupamento)+1
	into STRICT	nr_agrup_comp_w
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p;

	select	max(nr_sequencia)+1
	into STRICT	nr_seq_componente_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p;

	select	nextval('cpoe_material_seq')
	into STRICT	nr_seq_cpoe_w
	;
	
	/* insere o substituto */

	insert into prescr_material(
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
			ie_via_aplicacao,
			nr_agrupamento,
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
			nr_dia_util,
			nr_sequencia_dieta,
			ie_agrupador,
			dt_emissao_setor_atend,
			ie_suspenso,
			ds_justificativa,
			qt_dias_solicitado,
			qt_dias_liberado,
			nm_usuario_liberacao,
			dt_liberacao,
			ie_se_necessario,
			qt_min_aplicacao,
			nr_seq_lote_fornec,
			ie_status_cirurgia,
			ie_bomba_infusao,
			ie_aplic_bolus,
			ie_aplic_lenta,
			ie_acm,
			cd_material_baixa,
			nr_seq_avaliacao,
			nr_seq_ordem_prod,
			qt_baixa_especial,
			ie_objetivo,
			qt_hora_aplicacao,
			ie_erro,
			cd_topografia_cih,
			ie_origem_infeccao,
			cd_amostra_cih,
			cd_microorganismo_cih,
			ie_cultura_cih,
			ie_antibiograma,
			ie_uso_antimicrobiano,
			cd_kit_material,
			cd_local_estoque,
			nr_seq_kit,
			dt_suspensao,
			nm_usuario_susp,
			qt_vel_infusao,
			cd_protocolo,
			nr_seq_protocolo,
			nr_seq_mat_protocolo,
			dt_alteracao_local,
			nm_usuario_alt_local,
			ie_recons_diluente_fixo,
			qt_dias_util,
			dt_fim_item,
			nr_seq_atend_medic,
			nr_seq_kit_estoque,
			cd_convenio,
			cd_categoria,
			ie_sem_aprazamento,
			ie_novo_ciclo_ccih,
			nr_receita,
			dt_status,
			ie_status,
			qt_volume_adep,
			ie_supera_limite_uso,
			ie_cobra_paciente,
			ie_forma_infusao,
			ie_indicacao,
			ie_dose_espec_agora,
			ie_tipo_medic_hd,
			cd_setor_exec_inic,
			cd_setor_exec_fim,
			nr_seq_pe_proc,
			ie_intervalo_dif,
			ds_reprov_ccih,
			qt_horas_estabilidade,
			dt_proxima_dose,
			ie_administrar,
			qt_total_dias_lib,
			ie_regra_disp,
			nr_seq_substituto,
			nr_seq_mat_cpoe
	)
	SELECT	nr_prescricao,
			nr_seq_componente_w,	/* nova sequência da prescrição */
			ie_origem_inf,
			cd_material,
			cd_unidade_medida,
			qt_dose,
			qt_unitaria,
			qt_material,
			clock_timestamp(), 				/* hora de substituição */
			nm_usuario_p, 				/* usuário que substituiu */
			cd_intervalo,
			ds_horarios,
			ds_observacao,
			ie_via_aplicacao,
			nr_agrup_comp_w,			/* novo agrupamento */
			0, 					/* motivo de baixa */
			null, 					/* data da baixa */
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
			null,
			hr_prim_horario,
			nr_dia_util,
			nr_sequencia_dieta,
			ie_agrupador,
			dt_emissao_setor_atend,
			ie_suspenso,
			ds_justificativa,
			qt_dias_solicitado,
			qt_dias_liberado,
			nm_usuario_liberacao,
			dt_liberacao,
			ie_se_necessario,
			qt_min_aplicacao,
			nr_seq_lote_fornec,
			ie_status_cirurgia,
			ie_bomba_infusao,
			ie_aplic_bolus,
			ie_aplic_lenta,
			ie_acm,
			cd_material_baixa,
			nr_seq_avaliacao,
			nr_seq_ordem_prod,
			qt_baixa_especial,
			ie_objetivo,
			qt_hora_aplicacao,
			ie_erro,
			cd_topografia_cih,
			ie_origem_infeccao,
			cd_amostra_cih,
			cd_microorganismo_cih,
			ie_cultura_cih,
			ie_antibiograma,
			ie_uso_antimicrobiano,
			cd_kit_material,
			cd_local_estoque,
			nr_seq_kit,
			dt_suspensao,
			nm_usuario_susp,
			qt_vel_infusao,
			cd_protocolo,
			nr_seq_protocolo,
			nr_seq_mat_protocolo,
			dt_alteracao_local,
			nm_usuario_alt_local,
			ie_recons_diluente_fixo,
			qt_dias_util,
			dt_fim_item,
			nr_seq_atend_medic,
			nr_seq_kit_estoque,
			cd_convenio,
			cd_categoria,
			ie_sem_aprazamento,
			ie_novo_ciclo_ccih,
			nr_receita,
			dt_status,
			ie_status,
			qt_volume_adep,
			ie_supera_limite_uso,
			ie_cobra_paciente,
			ie_forma_infusao,
			ie_indicacao,
			ie_dose_espec_agora,
			ie_tipo_medic_hd,
			cd_setor_exec_inic,
			cd_setor_exec_fim,
			nr_seq_pe_proc,
			ie_intervalo_dif,
			ds_reprov_ccih,
			qt_horas_estabilidade,
			null,
			ie_administrar,
			qt_total_dias_lib,
			ie_regra_disp,
			null,
			nr_seq_cpoe_w		/* sequência do substituto */
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and		nr_sequencia		= nr_sequencia_w;

	insert into cpoe_material(
				nr_sequencia,
				nr_atendimento,
				ie_administracao,
				ie_ref_calculo,
				ie_controle_tempo,
				ie_duracao,
				dt_inicio,
				dt_fim,
				dt_liberacao,
				cd_intervalo,
				ds_horarios,
				ds_orientacao_preparo,
				ds_solucao,
				hr_prim_horario,
				ie_acm,
				ie_bomba_infusao,
				ie_fator_correcao,
				ie_pca_modo_prog,
				ie_se_necessario,
				ie_tipo_analgesia,
				ie_tipo_dosagem,
				ie_tipo_solucao,
				ie_um_bolus_pca,
				ie_um_dose_inicio_pca,
				ie_um_fluxo_pca,
				ie_um_limite_hora_pca,
				ie_um_limite_pca,
				ie_urgencia,
				ie_via_aplicacao,
				nr_etapas,
				qt_bolus_pca,
				qt_dosagem,
				qt_dose_ataque,
				qt_dose_inicial_pca,
				qt_hora_fase,
				qt_intervalo_bloqueio,
				qt_limite_quatro_hora,
				qt_limite_uma_hora,
				qt_solucao_total,
				qt_tempo_aplicacao,
				qt_vol_infusao_pca,
				qt_volume,
				cd_material,
				qt_dose,
				cd_unidade_medida,
				ds_dose_diferenciada,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				cd_perfil_ativo,
				qt_dosagem_diferenciada,
				qt_hora_fase_diferenciada,
				cd_pessoa_fisica,
				cd_funcao_origem,
				cd_setor_atendimento,
				ie_retrogrado,
				ie_oncologia,
				ie_dose_adicional,
				qt_dose_adicional,	
				hr_min_aplic_adic,	
				dt_adm_adicional,	
				cd_mat_dil,
				qt_dose_dil,
				cd_unid_med_dose_dil,
				qt_solucao_dil,
				cd_mat_red,
				qt_dose_red,
				cd_unid_med_dose_red,
				qt_solucao_red,
				cd_mat_recons,
				qt_dose_recons,
				cd_unid_med_dose_recons,
				cd_mat_comp1,
				qt_dose_comp1,
				cd_unid_med_dose_comp1,
				qt_dose_correcao1,
				ds_dose_diferenciada_comp1,
				cd_mat_comp2,
				qt_dose_comp2,
				cd_unid_med_dose_comp2,
				qt_dose_correcao2,
				ds_dose_diferenciada_comp2,
				cd_mat_comp3,
				qt_dose_comp3,
				cd_unid_med_dose_comp3,
				qt_dose_correcao3,
				ds_dose_diferenciada_comp3,
				cd_mat_comp4,
				qt_dose_comp4,
				cd_unid_med_dose_comp4,
				qt_dose_correcao4,
				ds_dose_diferenciada_comp4,
				cd_mat_comp5,
				qt_dose_comp5,
				cd_unid_med_dose_comp5,
				qt_dose_correcao5,
				ds_dose_diferenciada_comp5,
				cd_mat_comp6,
				qt_dose_comp6,
				cd_unid_med_dose_comp6,
				qt_dose_correcao6,
				ds_dose_diferenciada_comp6,
				nr_seq_cpoe_anterior,
				dt_prox_geracao,
				nr_ocorrencia)
		SELECT	nr_seq_cpoe_w,
				nr_atendimento,
				ie_administracao,
				ie_ref_calculo,
				ie_controle_tempo,
				ie_duracao,
				dt_inicio,
				dt_fim,
				clock_timestamp(),
				cd_intervalo,
				ds_horarios,
				ds_orientacao_preparo,
				ds_solucao,
				hr_prim_horario,
				ie_acm,
				ie_bomba_infusao,
				ie_fator_correcao,
				ie_pca_modo_prog,
				ie_se_necessario,
				ie_tipo_analgesia,
				ie_tipo_dosagem,
				ie_tipo_solucao,
				ie_um_bolus_pca,
				ie_um_dose_inicio_pca,
				ie_um_fluxo_pca,
				ie_um_limite_hora_pca,
				ie_um_limite_pca,
				ie_urgencia,
				ie_via_aplicacao,
				nr_etapas,
				qt_bolus_pca,
				qt_dosagem,
				qt_dose_ataque,
				qt_dose_inicial_pca,
				qt_hora_fase,
				qt_intervalo_bloqueio,
				qt_limite_quatro_hora,
				qt_limite_uma_hora,
				qt_solucao_total,
				qt_tempo_aplicacao,
				qt_vol_infusao_pca,
				qt_volume,
				cd_material,
				qt_dose,
				cd_unidade_medida,
				ds_dose_diferenciada,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario_p,
				nm_usuario_p,
				coalesce(obter_perfil_ativo, cd_perfil_ativo),
				qt_dosagem_diferenciada,
				qt_hora_fase_diferenciada,
				cd_pessoa_fisica,
				cd_funcao_origem,
				cd_setor_atendimento,
				ie_retrogrado,
				ie_oncologia,
				ie_dose_adicional,
				qt_dose_adicional,	
				hr_min_aplic_adic,	
				dt_adm_adicional,	
				cd_mat_dil,
				qt_dose_dil,
				cd_unid_med_dose_dil,
				qt_solucao_dil,
				cd_mat_red,
				qt_dose_red,
				cd_unid_med_dose_red,
				qt_solucao_red,
				cd_mat_recons,
				qt_dose_recons,
				cd_unid_med_dose_recons,
				cd_mat_comp1,
				qt_dose_comp1,
				cd_unid_med_dose_comp1,
				qt_dose_correcao1,
				ds_dose_diferenciada_comp1,
				cd_mat_comp2,
				qt_dose_comp2,
				cd_unid_med_dose_comp2,
				qt_dose_correcao2,
				ds_dose_diferenciada_comp2,
				cd_mat_comp3,
				qt_dose_comp3,
				cd_unid_med_dose_comp3,
				qt_dose_correcao3,
				ds_dose_diferenciada_comp3,
				cd_mat_comp4,
				qt_dose_comp4,
				cd_unid_med_dose_comp4,
				qt_dose_correcao4,
				ds_dose_diferenciada_comp4,
				cd_mat_comp5,
				qt_dose_comp5,
				cd_unid_med_dose_comp5,
				qt_dose_correcao5,
				ds_dose_diferenciada_comp5,
				cd_mat_comp6,
				qt_dose_comp6,
				cd_unid_med_dose_comp6,
				qt_dose_correcao6,
				ds_dose_diferenciada_comp6,
				nr_sequencia,
				dt_prox_geracao,
				nr_ocorrencia
		from	cpoe_material
		where	nr_sequencia = nr_seq_cpoe_ant_w;

	/* atualiza informações do medicamento pai */

	update	prescr_material
	set		cd_motivo_baixa		= somente_numero(cd_motivo_baixa_w),
			dt_baixa			= clock_timestamp(),
			nr_seq_substituto	= nr_seq_componente_w,
			nm_usuario			= nm_usuario_p
	where	nr_prescricao		= nr_prescricao_p
	and		nr_sequencia		= nr_sequencia_w;

	CALL suspender_item_prescricao(nr_prescricao_p,nr_sequencia_w,0,NULL,'PRESCR_MATERIAL',nm_usuario_p,924);
	end;
end loop;
close c01;

select	nextval('prescr_solucao_evento_seq')
into STRICT	nr_seq_alteracao_w
;

insert into prescr_solucao_evento(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_solucao,
				nr_seq_material,		
				ie_forma_infusao,
				qt_volume_fase,	
				ie_tipo_dosagem,
				qt_dosagem,
				qt_vol_infundido,
				qt_vol_desprezado,
				cd_pessoa_fisica,
				ie_alteracao,
				dt_alteracao,
				ie_evento_valido,
				nr_seq_motivo,
				ds_observacao,
				ie_tipo_solucao,
				qt_volume_parcial,
				qt_tempo_infusao,
				nr_seq_lote,
				nr_seq_assinatura,
				ds_justificativa,
				dt_horario,
				nr_seq_mot_lote_gedipa,
				cd_funcao)
		values (
				nr_seq_alteracao_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				nr_seq_solucao_w,
				null,
				null,
				null,		
				null,
				null,
				null,
				null,
				obter_dados_usuario_opcao(nm_usuario_p, 'C'),
				57,
				clock_timestamp(),
				'S',
				null,
				ds_material_w,
				1,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				coalesce(obter_funcao_ativa,1113));


/* reordena os medicamentos */

CALL reordenar_medicamento(nr_prescricao_p);

update	prescr_material
set		nr_seq_mat_cpoe = nr_seq_cpoe_w
where	nr_prescricao = nr_prescricao_p
and		nr_seq_mat_cpoe = nr_seq_cpoe_ant_w
and 	coalesce(dt_suspensao::text, '') = '';
/* retorna a nova sequência gerada */

nr_seq_componente_novo_p	:= nr_seq_componente_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_componente_solucao ( nr_prescricao_p bigint, nr_seq_componente_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_componente_novo_p INOUT bigint) FROM PUBLIC;

