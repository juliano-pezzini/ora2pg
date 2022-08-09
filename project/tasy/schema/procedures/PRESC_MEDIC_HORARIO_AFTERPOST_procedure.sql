-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE presc_medic_horario_afterpost ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_p bigint, nr_agrupamento_ant_p bigint, ie_item_superior_p text, ie_existe_superior_p text, ie_volta_horario_p text, nr_agrupamento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_acao_executada_p bigint, ds_erro_p INOUT bigint, qt_dia_prim_hor_p bigint, dt_inicio_medic_p timestamp) AS $body$
DECLARE


vl_parametro_w				varchar(255);
ds_erro_w					smallint;
ie_item_superior_w			varchar(1);
ds_horarios_w				varchar(255);
nr_ocorrencia_w				prescr_material.nr_ocorrencia%type;
cd_material_w				prescr_material.cd_material%type;
cd_intervalo_w				prescr_material.cd_intervalo%type;
ie_via_aplicacao_w			prescr_material.ie_via_aplicacao%type;
qt_unitaria_w				prescr_material.qt_unitaria%type;
qt_dose_especial_w			prescr_material.qt_dose_especial%type;
ie_origem_inf_w				prescr_material.ie_origem_inf%type;
cd_unidade_medida_dose_w	prescr_material.cd_unidade_medida_dose%type;
qt_material_w				prescr_material.qt_material%type;
ie_se_necessario_w			prescr_material.ie_se_necessario%type;
ie_acm_w					prescr_material.ie_acm%type;
qt_total_dispensar_w		prescr_material.qt_total_dispensar%type;
ie_regra_disp_w				prescr_material.ie_regra_disp%type;
qt_dias_util_w				prescr_material.qt_dias_util%type;
ds_erro_ww					varchar(2000);
					

BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') and (nr_prescr_p IS NOT NULL AND nr_prescr_p::text <> '') and
	--(nr_agrupamento_ant_p is not null) and

	--(ie_item_superior_p is not null) and 

	--(ie_existe_superior_p is not null) and
	(nr_agrupamento_p IS NOT NULL AND nr_agrupamento_p::text <> '') then
	--(ie_volta_horario_p is not null)then
	begin
	
	
	if (nr_agrupamento_p IS NOT NULL AND nr_agrupamento_p::text <> '') and (nr_agrupamento_ant_p IS NOT NULL AND nr_agrupamento_ant_p::text <> '') and (nr_agrupamento_ant_p <> nr_agrupamento_p) then		
		begin	
		ie_item_superior_w := ie_item_superior_p;
		ie_item_superior_w := ajustar_item_superior_agrup(nr_prescricao_p, nr_seq_material_p, nr_agrupamento_ant_p, ie_item_superior_w, 'E', ie_existe_superior_p, nm_usuario_p);
				
		ds_horarios_w := atualizar_horarios_agrup_medic(nr_prescricao_p, nr_seq_material_p, nr_agrupamento_p, nr_agrupamento_ant_p, 'F', '', '', ds_horarios_w, cd_estabelecimento_p, ie_volta_horario_p, nm_usuario_p);
		end;
		
	end if;
					
	vl_parametro_w := obter_param_usuario(7015, 18, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

	if (vl_parametro_w = 'S') and (ie_acao_executada_p <> 3)then
		begin
		
		CALL atualiza_antimicrobiano_dia(nr_prescr_p, nr_seq_material_p);
					
		ds_erro_w := consistir_prescr_material(nr_prescr_p, nr_seq_material_p, nm_usuario_p, cd_perfil_p, ds_erro_w);
					
		end;
	end if;
	
	if (coalesce(dt_inicio_medic_p::text, '') = '') or (dt_inicio_medic_p = '') then
		CALL atualiza_dia_prim_hor_assoc(nr_prescr_p, nr_seq_material_p, qt_dia_prim_hor_p, null);
	else
		CALL atualiza_dia_prim_hor_assoc(nr_prescr_p, nr_seq_material_p, qt_dia_prim_hor_p, dt_inicio_medic_p);
	end if;

	select	max(a.cd_material),
			max(a.cd_intervalo),
			max(a.ie_via_aplicacao),
			max(a.qt_unitaria),
			max(a.qt_dose_especial),
			max(obter_ocorrencias_horarios_rep(a.ds_horarios)),
			coalesce(max(a.ie_origem_inf),'1'),
			max(a.qt_dias_util),
			max(a.cd_unidade_medida_dose),
			coalesce(max(a.qt_material),0),
			coalesce(max(a.ie_acm),'N'),
			coalesce(max(a.ie_se_necessario),'N')
	into STRICT	cd_material_w,
			cd_intervalo_w,
			ie_via_aplicacao_w,
			qt_unitaria_w,
			qt_dose_especial_w,
			nr_ocorrencia_w,
			ie_origem_inf_w,
			qt_dias_util_w,
			cd_unidade_medida_dose_w,
			qt_material_w,
			ie_se_necessario_w,
			ie_acm_w
	from	prescr_material a
	where	a.nr_prescricao = nr_prescricao_p
	and		a.nr_sequencia = nr_seq_material_p;

	SELECT * FROM obter_quant_dispensar(	cd_estabelecimento_p => cd_estabelecimento_p, cd_material_p => cd_material_w, nr_prescricao_p => nr_prescricao_p, nr_sequencia_p => nr_seq_material_p, cd_intervalo_p => cd_intervalo_w, ie_via_aplicacao_p => ie_via_aplicacao_w, qt_unitaria_p => qt_unitaria_w, qt_dose_esp_p => qt_dose_especial_w, nr_ocorrencia_p => nr_ocorrencia_w, ds_dose_dif_p => null, ie_origem_inf_p => ie_origem_inf_w, cd_unid_med_dose_p => cd_unidade_medida_dose_w, qt_dias_p => qt_dias_util_w, qt_material_p => qt_material_w, qt_dispensar_p => qt_total_dispensar_w, ie_regra_disp_p => ie_regra_disp_w, ds_erro_p => ds_erro_ww, ie_se_necessario_p => ie_se_necessario_w, ie_acm_p => ie_acm_w) INTO STRICT qt_material_p => qt_material_w, qt_dispensar_p => qt_total_dispensar_w, ie_regra_disp_p => ie_regra_disp_w, ds_erro_p => ds_erro_ww;

	/*Atualizado ocorrencias e dispensacao do medicamento principal*/

	update	prescr_material
	set		nr_ocorrencia = nr_ocorrencia_w,
			qt_total_dispensar = qt_total_dispensar_w,
			qt_material = qt_material_w
	where	nr_prescricao = nr_prescricao_p
	and		nr_sequencia = nr_seq_material_p;

	CALL ajustar_prescr_material(nr_prescricao_p, nr_seq_material_p);

	ds_erro_p := ds_erro_w;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE presc_medic_horario_afterpost ( nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_p bigint, nr_agrupamento_ant_p bigint, ie_item_superior_p text, ie_existe_superior_p text, ie_volta_horario_p text, nr_agrupamento_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_acao_executada_p bigint, ds_erro_p INOUT bigint, qt_dia_prim_hor_p bigint, dt_inicio_medic_p timestamp) FROM PUBLIC;
