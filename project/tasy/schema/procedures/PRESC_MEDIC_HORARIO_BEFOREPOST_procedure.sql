-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE presc_medic_horario_beforepost ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_hora_inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ie_solucao_p text, cd_estabelecimento_p bigint, nr_prescr_p bigint, nr_sequencia_p bigint, ie_via_aplicacao_p text, qt_unitaria_p bigint, qt_dose_esp_p bigint, nr_ocorrencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_dose_dif_p text, ie_origem_inf_p text, cd_unid_med_dose_p text, qt_dias_p bigint, nr_agrupamento_old_p bigint, nr_agrupamento_new_p bigint, nr_seq_interno_p bigint, ds_dose_diferenciada_p text, hr_prim_horario_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, qt_material_p INOUT bigint, ds_horarios2_p INOUT text, qt_dispensar_p INOUT bigint, ds_hor_p INOUT text, ie_regra_disp_p INOUT text, ie_existe_superior_p INOUT text, ie_volta_horario_p INOUT text, ds_inconsistencia_p INOUT text) AS $body$
DECLARE


nr_intervalo_w			smallint := 0;	
ds_horarios_w			varchar(2000) := '';	
qt_material_w			double precision := 0;
ds_horarios2_w			varchar(15) := '';						
qt_dispensar_w			double precision := 0;
ie_regra_disp_w			varchar(1) := '';
ds_erro_w			varchar(255) := '';	
vl_parametro_w			varchar(1) := '';
ie_existe_superior_w		varchar(1) := '';
ie_volta_horario_w		varchar(1) := '';
ie_consistir_horarios_w		varchar(1) := '';
ie_intervalo_correto_w		varchar(1) := '';
ds_texto_w			varchar(255) := '';
ds_hor_w			varchar(2000) := '';
qt_dose_total_mod_item_w 	bigint := 0;
ds_horar_w			varchar(255) := '';
ds_mensagem_w			varchar(255) := '';
qt_operacao_w			intervalo_prescricao.qt_operacao%type := 0;
ie_sn_w				varchar(1);
ie_acm_w				varchar(1);
nr_ocorrencia_w			prescr_material.nr_ocorrencia%type;
					

BEGIN

nr_intervalo_w := nr_intervalo_p;
ds_horarios_w := ds_horarios_p;
SELECT * FROM calcular_horario_prescricao(nr_prescricao_p, cd_intervalo_p, dt_prim_horario_presc_p, dt_Hora_Inicio_p, nr_hora_validade_p, cd_material_p, qt_hora_intervalo_p, qt_min_intervalo_p, nr_intervalo_w, ds_horarios_w, ds_horarios2_w, ie_Solucao_p, '') INTO STRICT nr_intervalo_w, ds_horarios_w, ds_horarios2_w;	

qt_material_w := qt_material_p;	
select 	coalesce(max(ie_se_necessario),'N'),
		coalesce(max(ie_acm),'N')
into STRICT	ie_sn_w,
		ie_acm_w
from 	prescr_material
where	nr_prescricao = nr_prescr_p
and	nr_sequencia  = nr_sequencia_p;

nr_ocorrencia_w	:= obter_ocorrencias_horarios_rep(ds_horarios_w||ds_horarios2_w);

if (coalesce(nr_ocorrencia_w,0) = 0) then
	nr_ocorrencia_w	:= nr_ocorrencia_p;
	nr_intervalo_w := nr_ocorrencia_w;
end if;

if (ie_sn_w = 'S') or (ie_acm_w = 'S') then
	nr_intervalo_w := nr_ocorrencia_p;
	nr_ocorrencia_w := nr_ocorrencia_p;
end if;

SELECT * FROM obter_quant_dispensar(cd_estabelecimento_p, cd_material_p, nr_prescr_p, nr_sequencia_p, cd_intervalo_p, ie_via_aplicacao_p, qt_unitaria_p, qt_dose_esp_p, nr_ocorrencia_w, ds_dose_dif_p, ie_origem_inf_p, cd_unid_med_dose_p, qt_dias_p, qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_sn_w, ie_acm_w) INTO STRICT qt_material_w, qt_dispensar_w, ie_regra_disp_w, ds_erro_w;		
vl_parametro_w := obter_param_usuario(7015, 16, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, vl_parametro_w);

if (vl_parametro_w = 'S') and (nr_agrupamento_old_p <> nr_agrupamento_new_p) then
	begin
			
	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END  ie_existe_superior
	into STRICT	ie_existe_superior_w
	from    prescr_material a
	where	nr_prescricao = nr_prescricao_p
	and	nr_agrupamento = nr_agrupamento_new_p
	and     nr_sequencia <> nr_sequencia_p
	and	ie_item_superior = 'S';
			
	select	 CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  ie_volta_horario
	into STRICT	 ie_volta_horario_w
	from     prescr_material
	where	 nr_prescricao = nr_prescricao_p
	and	 nr_agrupamento	= nr_agrupamento_new_p
	and	 obter_classif_material_proced(cd_material, null,null) <> 1
	and	 coalesce(nr_sequencia_solucao::text, '') = ''
	and	 coalesce(nr_sequencia_proc::text, '') = ''
	and	 ie_agrupador = 1
	and	 coalesce(ie_suspenso,'N') <> 'S'
	and	 coalesce(ie_administrar,'S') = 'S'
	and	 coalesce(nr_sequencia_diluicao::text, '') = ''
	and      nr_sequencia <> nr_sequencia_p;
			
	end;
end if;
		
if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') and (ds_horarios_p IS NOT NULL AND ds_horarios_p::text <> '')then
	begin
			
	select	coalesce(max(ie_consistir_horarios),'N') intervalo_prescricao
	into STRICT	ie_consistir_horarios_w
	from 	intervalo_prescricao
	where 	cd_intervalo = cd_intervalo_p;
			
	ie_intervalo_correto_w := substr(obter_se_intervalo_correto(ds_horarios_p, cd_intervalo_p),1,1);
			
	if (ie_consistir_horarios_w = 'S') and (ie_intervalo_correto_w = 'N')then
		begin
		ds_texto_w 	       := substr(obter_texto_tasy(27302, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		end;
	end if;
			
	end;
end if;

if (coalesce(ds_texto_w::text, '') = '')then
	begin
		if (ds_dose_diferenciada_p = 'S')then

		SELECT * FROM vipe_gerar_hor_dif(ds_dose_diferenciada_p, '', '', cd_intervalo_p, hr_prim_horario_p, nr_prescr_p, 0, qt_dose_total_mod_item_w, ds_horar_w, ds_mensagem_w, qt_operacao_w) INTO STRICT qt_dose_total_mod_item_w, ds_horar_w, ds_mensagem_w, qt_operacao_w;
			
		end if;

		if (nr_seq_interno_p IS NOT NULL AND nr_seq_interno_p::text <> '')then
		
		select 	ds_horarios ds_horarios
		into STRICT	ds_hor_w
		from   	prescr_material
		where  	nr_seq_interno = nr_seq_interno_p;	
		
		end if;
	end;
end if;
	

nr_intervalo_p			:= nr_intervalo_w;
ds_horarios_p			:= ds_horarios_w;
qt_material_p			:= qt_material_w;		
ds_horarios2_p 			:= ds_horarios2_w;
qt_dispensar_p 			:= qt_dispensar_w;
ie_regra_disp_p 		:= ie_regra_disp_w;
ie_existe_superior_p 	:= ie_existe_superior_w;
ie_volta_horario_p		:= ie_volta_horario_w;
ds_hor_p				:= ds_hor_w;
ds_inconsistencia_p		:= ds_texto_w;
	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE presc_medic_horario_beforepost ( nr_prescricao_p bigint, cd_intervalo_p text, dt_prim_horario_presc_p timestamp, dt_hora_inicio_p timestamp, nr_hora_validade_p bigint, cd_material_p bigint, qt_hora_intervalo_p bigint, qt_min_intervalo_p bigint, ie_solucao_p text, cd_estabelecimento_p bigint, nr_prescr_p bigint, nr_sequencia_p bigint, ie_via_aplicacao_p text, qt_unitaria_p bigint, qt_dose_esp_p bigint, nr_ocorrencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, ds_dose_dif_p text, ie_origem_inf_p text, cd_unid_med_dose_p text, qt_dias_p bigint, nr_agrupamento_old_p bigint, nr_agrupamento_new_p bigint, nr_seq_interno_p bigint, ds_dose_diferenciada_p text, hr_prim_horario_p text, nr_intervalo_p INOUT bigint, ds_horarios_p INOUT text, qt_material_p INOUT bigint, ds_horarios2_p INOUT text, qt_dispensar_p INOUT bigint, ds_hor_p INOUT text, ie_regra_disp_p INOUT text, ie_existe_superior_p INOUT text, ie_volta_horario_p INOUT text, ds_inconsistencia_p INOUT text) FROM PUBLIC;

