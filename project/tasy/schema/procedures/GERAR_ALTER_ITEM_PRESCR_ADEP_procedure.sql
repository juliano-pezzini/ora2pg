-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alter_item_prescr_adep ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, ie_alteracao_p bigint, ds_justificativa_p text, nm_usuario_p text, nr_seq_motivo_susp_p bigint, ds_observacao_p text) AS $body$
DECLARE


nr_seq_alter_w			bigint;
dt_atualizacao_w		timestamp := clock_timestamp();
ie_acm_sn_w			varchar(1);
ie_gerar_evento_w		varchar(1);
ds_motivo_susp_w		varchar(255);
nr_seq_proc_interno_w		bigint;
nr_seq_prot_glic_w			bigint;
qt_dose_w					prescr_material.qt_dose%type;

cd_unid_med_dose_recons_w cpoe_material.cd_unid_med_dose_recons%type;
nr_seq_mat_rediluicao_w cpoe_material.nr_seq_mat_rediluicao%type;
cd_unid_med_dose_dil_w cpoe_material.cd_unid_med_dose_dil%type;
nr_seq_mat_diluicao_w cpoe_material.nr_seq_mat_diluicao%type;
nr_seq_mat_reconst_w cpoe_material.nr_seq_mat_reconst%type;
qt_tempo_aplicacao_w cpoe_material.qt_tempo_aplicacao%type;
ie_controle_tempo_w cpoe_material.ie_controle_tempo%type;
ie_fator_correcao_w cpoe_material.ie_fator_correcao%type;
cd_unidade_medida_w cpoe_material.cd_unidade_medida%type;
cd_pessoa_fisica_w cpoe_material.cd_pessoa_fisica%type;
hr_min_aplicacao_w cpoe_material.hr_min_aplicacao%type;
ie_administracao_w cpoe_material.ie_administracao%type;
ie_bomba_infusao_w cpoe_material.ie_bomba_infusao%type;
ie_via_aplicacao_w cpoe_material.ie_via_aplicacao%type;
hr_prim_horario_w cpoe_material.hr_prim_horario%type;
ie_tipo_dosagem_w cpoe_material.ie_tipo_dosagem%type;
qt_dose_recons_w cpoe_material.qt_dose_recons%type;
nr_atendimento_w cpoe_material.nr_atendimento%type;
cd_mat_recons_w cpoe_material.cd_mat_recons%type;
cd_intervalo_w cpoe_material.cd_intervalo%type;
ds_horarios_w cpoe_material.ds_horarios%type;
qt_dose_dil_w cpoe_material.qt_dose_dil%type;
cd_material_w cpoe_material.cd_material%type;
qt_dosagem_w cpoe_material.qt_dosagem%type;
cd_mat_dil_w cpoe_material.cd_mat_dil%type;
ie_change_volume_w varchar(1);
qt_volume_w cpoe_material.qt_volume%type;
nr_etapas_w cpoe_material.nr_etapas%type;
qt_dose_ww cpoe_material.qt_dose%type;
qt_velocidade_infusao_w cpoe_material.qt_volume%type;
qt_solucao_total_w cpoe_material.qt_solucao_total%type;

ds_orientacao_preparo_ww	varchar(4000);
qt_vel_infusao_ww	double precision;
ie_tipo_dosagem_ww	varchar(255);
ds_min_aplic_med_ww	varchar(30);

c01 CURSOR FOR
SELECT
CD_UNID_MED_DOSE_RECONS,NR_SEQ_MAT_REDILUICAO,CD_UNID_MED_DOSE_DIL,NR_SEQ_MAT_DILUICAO,
NR_SEQ_MAT_RECONST,QT_TEMPO_APLICACAO,IE_CONTROLE_TEMPO,IE_FATOR_CORRECAO,CD_UNIDADE_MEDIDA,
CD_PESSOA_FISICA,HR_MIN_APLICACAO,IE_ADMINISTRACAO,IE_BOMBA_INFUSAO,IE_VIA_APLICACAO,
HR_PRIM_HORARIO,IE_TIPO_DOSAGEM,QT_DOSE_RECONS,NR_ATENDIMENTO,CD_MAT_RECONS,CD_INTERVALO,
DS_HORARIOS,QT_DOSE_DIL,CD_MATERIAL,QT_DOSAGEM,CD_MAT_DIL,'S',QT_VOLUME,NR_ETAPAS,QT_DOSE, QT_SOLUCAO_TOTAL
from cpoe_material a
where nr_sequencia = nr_seq_item_p and nr_atendimento = nr_atendimento_p;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') and
	((cd_item_p IS NOT NULL AND cd_item_p::text <> '') or (ie_tipo_item_p = 'R')) and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (ie_alteracao_p IS NOT NULL AND ie_alteracao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	
	if (ie_tipo_item_p in ('S','M','MAT','LD')) then
	
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_evento_w
		from	prescr_mat_hor
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_material	= nr_seq_item_p;
		--and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
		
		if (ie_gerar_evento_w = 'S') then
		
			select	max(CASE WHEN ie_acm='N' THEN CASE WHEN ie_se_necessario='S' THEN 'S' END   ELSE 'S' END ),
					max(qt_dose)
			into STRICT	ie_acm_sn_w,
					qt_dose_w
			from	prescr_material
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_item_p;
			
			select	max(ds_motivo_susp)
			into STRICT	ds_motivo_susp_w
			from	prescr_medica
			where	nr_prescricao	= nr_prescricao_p;
		
			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alter_w
			;

			insert into prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_prescricao,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								nr_atendimento,
								cd_item,
								nr_seq_motivo_susp,
								ie_acm_sn,
								ds_observacao,
								qt_dose_original
								)
							values (
								nr_seq_alter_w,
								dt_atualizacao_w,
								nm_usuario_p,
								dt_atualizacao_w,
								nm_usuario_p,
								nr_prescricao_p,
								nr_seq_item_p,
								dt_atualizacao_w,
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								ie_alteracao_p,
								coalesce(ds_justificativa_p, ds_motivo_susp_w),
								ie_tipo_item_p,
								nr_atendimento_p,
								cd_item_p,
								CASE WHEN nr_seq_motivo_susp_p=0 THEN null  ELSE nr_seq_motivo_susp_p END ,
								ie_acm_sn_w,
								ds_observacao_p,
								qt_dose_w);
								
					if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			if (ie_tipo_item_p = 'M') and (ie_alteracao_p in (13,14)) then
				if (ie_alteracao_p = 13) then
					CALL gerar_susp_adep_processo_item(nr_prescricao_p, nr_seq_item_p, '6', nm_usuario_p);
				else
					CALL gerar_susp_adep_processo_item(nr_prescricao_p, nr_seq_item_p, '7', nm_usuario_p);
				end if;
			end if;
			
		end if;

    OPEN c01;
    loop
    FETCH c01
      INTO
      cd_unid_med_dose_recons_w, nr_seq_mat_rediluicao_w, cd_unid_med_dose_dil_w,
      nr_seq_mat_diluicao_w, nr_seq_mat_reconst_w, qt_tempo_aplicacao_w,
      ie_controle_tempo_w, ie_fator_correcao_w, cd_unidade_medida_w,
      cd_pessoa_fisica_w, hr_min_aplicacao_w, ie_administracao_w,
      ie_bomba_infusao_w, ie_via_aplicacao_w, hr_prim_horario_w,
      ie_tipo_dosagem_w, qt_dose_recons_w, nr_atendimento_w,
      cd_mat_recons_w, cd_intervalo_w, ds_horarios_w,
      qt_dose_dil_w, cd_material_w, qt_dosagem_w, cd_mat_dil_w,
      ie_change_volume_w, qt_volume_w, nr_etapas_w, qt_dose_ww, qt_solucao_total_w;
      EXIT WHEN NOT FOUND; /* apply on c01 */
      begin
        qt_velocidade_infusao_w := cpoe_obter_volume_total(
          cd_material_w, qt_dose_ww, cd_unidade_medida_w, cd_mat_dil_w,
          qt_dose_dil_w, cd_unid_med_dose_dil_w,
          null, null, null, null, null, null, null, null, null, null, null, null, 
          null, null, null, null, null, null, null, null, null, null, null, null, null,
          nr_seq_mat_diluicao_w, cd_pessoa_fisica_w, nr_atendimento_w, ie_via_aplicacao_w
        );

        SELECT * FROM CPOE_GERAR_ORIENTACAO_PREPARO(
          nr_atendimento_w, cd_pessoa_fisica_w, wheb_usuario_pck.get_nm_usuario, ie_controle_tempo_w, ie_via_aplicacao_w, cd_intervalo_w, nr_etapas_w, ie_administracao_w, hr_prim_horario_w, ds_horarios_w, null, qt_solucao_total_w, hr_min_aplicacao_w, null, qt_tempo_aplicacao_w, ie_bomba_infusao_w, null, ie_fator_correcao_w, qt_dosagem_w, null, null, null, ie_tipo_dosagem_w, qt_velocidade_infusao_w, null, cd_material_w, qt_dose_ww, null, cd_unidade_medida_w, nr_seq_mat_reconst_w, cd_mat_recons_w, qt_dose_recons_w, null, cd_unid_med_dose_recons_w, nr_seq_mat_diluicao_w, cd_mat_dil_w, qt_dose_dil_w, null, null, cd_unid_med_dose_dil_w, nr_seq_mat_rediluicao_w, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null) INTO STRICT ds_orientacao_preparo_ww, qt_vel_infusao_ww, ie_tipo_dosagem_ww, ds_min_aplic_med_ww;

        update cpoe_material
        set
          dt_atualizacao = clock_timestamp(),
          nm_usuario = wheb_usuario_pck.get_nm_usuario,
          qt_dosagem = qt_vel_infusao_ww,
          ds_orientacao_preparo = ds_orientacao_preparo_ww,
          ie_tipo_dosagem = ie_tipo_dosagem_ww,
          hr_min_aplicacao = ds_min_aplic_med_ww
        where nr_sequencia = nr_seq_item_p and nr_atendimento = nr_atendimento_p;
      end;
    end loop;
    CLOSE c01;

	elsif (ie_tipo_item_p in ('P','G','C','I')) then
	
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_evento_w
		from	prescr_proc_hor
		where	nr_prescricao		= nr_prescricao_p
		and	nr_seq_procedimento	= nr_seq_item_p;
		--and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
		
		if (ie_gerar_evento_w = 'S') then	

			select	max(nr_seq_proc_interno),
					max(nr_seq_prot_glic)
			into STRICT	nr_seq_proc_interno_w,
					nr_seq_prot_glic_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_p
			and	nr_sequencia	= nr_seq_item_p;
		
			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alter_w
			;

			insert into prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_procedimento,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								nr_atendimento,
								cd_item,
								nr_seq_motivo_susp,
								nr_seq_proc_interno,
								ds_observacao,
								nr_seq_prot_glic
								)
							values (
								nr_seq_alter_w,
								dt_atualizacao_w,
								nm_usuario_p,
								dt_atualizacao_w,
								nm_usuario_p,
								nr_prescricao_p,
								nr_seq_item_p,
								dt_atualizacao_w,
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								ie_alteracao_p,
								ds_justificativa_p,
								ie_tipo_item_p,
								nr_atendimento_p,
								cd_item_p,
								CASE WHEN nr_seq_motivo_susp_p=0 THEN null  ELSE nr_seq_motivo_susp_p END ,
								nr_seq_proc_interno_w,
								ds_observacao_p,
								nr_seq_prot_glic_w);
								
		end if;

	elsif (ie_tipo_item_p = 'R') then
	
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_evento_w
		from	prescr_rec_hor
		where	nr_prescricao		= nr_prescricao_p
		and	nr_seq_recomendacao	= nr_seq_item_p;
		--and	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';
		
		if (ie_gerar_evento_w = 'S') then		
	
			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alter_w
			;

			insert into prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_recomendacao,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								nr_atendimento,
								cd_item,
								nr_seq_motivo_susp,
								ds_observacao
								)
							values (
								nr_seq_alter_w,
								dt_atualizacao_w,
								nm_usuario_p,
								dt_atualizacao_w,
								nm_usuario_p,
								nr_prescricao_p,
								nr_seq_item_p,
								dt_atualizacao_w,
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								ie_alteracao_p,
								ds_justificativa_p,
								ie_tipo_item_p,
								nr_atendimento_p,
								cd_item_p,
								CASE WHEN nr_seq_motivo_susp_p=0 THEN null  ELSE nr_seq_motivo_susp_p END ,
								ds_observacao_p
								);
								
		end if;

	elsif (ie_tipo_item_p = 'E') then
	
		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_gerar_evento_w
		from	pe_prescr_proc_hor
		where	nr_seq_pe_prescr	= nr_prescricao_p
		and	nr_seq_pe_proc		= nr_seq_item_p;
		
		if (ie_gerar_evento_w = 'S') then		
	
			select	nextval('prescr_mat_alteracao_seq')
			into STRICT	nr_seq_alter_w
			;

			insert into prescr_mat_alteracao(
								nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_prescricao,
								nr_seq_item_sae,
								dt_alteracao,
								cd_pessoa_fisica,
								ie_alteracao,
								ds_justificativa,
								ie_tipo_item,
								nr_atendimento,
								cd_item,
								nr_seq_motivo_susp,
								ds_observacao
								)
							values (
								nr_seq_alter_w,
								dt_atualizacao_w,
								nm_usuario_p,
								dt_atualizacao_w,
								nm_usuario_p,
								nr_prescricao_p,
								nr_seq_item_p,
								dt_atualizacao_w,
								obter_dados_usuario_opcao(nm_usuario_p,'C'),
								ie_alteracao_p,
								ds_justificativa_p,
								ie_tipo_item_p,
								nr_atendimento_p,
								cd_item_p,
								CASE WHEN nr_seq_motivo_susp_p=0 THEN null  ELSE nr_seq_motivo_susp_p END ,
								ds_observacao_p
								);
								
		end if;
	
	elsif (ie_tipo_item_p = 'J') then
	
		select	nextval('prescr_mat_alteracao_seq')
		into STRICT	nr_seq_alter_w
		;	
		
		insert into prescr_mat_alteracao(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_prescricao,
			nr_seq_prescricao,
			nr_seq_horario,
			dt_alteracao,
			cd_pessoa_fisica,
			ie_alteracao,
			ds_justificativa,
			ie_tipo_item,
			dt_horario,
			nr_atendimento,
			cd_item,
			qt_dose_adm,
			cd_um_dose_adm,
			qt_dose_original,
			nr_agrupamento,
			cd_medico_solic,
			ds_observacao,
			nr_seq_motivo_susp
			)
		values (
			nr_seq_alter_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_prescricao_p,
			null,
			null,
			clock_timestamp(),
			obter_dados_usuario_opcao(nm_usuario_p,'C'),
			ie_alteracao_p,
			ds_justificativa_p,
			'J',
			clock_timestamp(),
			nr_atendimento_p,
			cd_item_p,
			null,
			null,
			null,
			null,
			null,
			ds_observacao_p,
			CASE WHEN nr_seq_motivo_susp_p=0 THEN null  ELSE nr_seq_motivo_susp_p END
			);
	
	end if;
	
	/* definir setor execucao adep */

	if (ie_gerar_evento_w = 'S') then
		CALL definir_setor_exec_adep(nr_atendimento_p,ie_tipo_item_p,nr_prescricao_p,nr_seq_item_p,null,null);
	end if;
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alter_item_prescr_adep ( nr_atendimento_p bigint, ie_tipo_item_p text, cd_item_p text, nr_prescricao_p bigint, nr_seq_item_p bigint, ie_alteracao_p bigint, ds_justificativa_p text, nm_usuario_p text, nr_seq_motivo_susp_p bigint, ds_observacao_p text) FROM PUBLIC;
