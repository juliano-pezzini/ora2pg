-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_subst_sug_cih (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_orig_p bigint, cd_material_p bigint) AS $body$
DECLARE

 
								  
nr_prescr_sug_w			prescr_medica.nr_prescricao%type := 0;
cd_material_sug_w		prescr_material.cd_material%type;
cd_intervalo_sug_w		prescr_material.cd_intervalo%type;
cd_unid_med_sug_w		prescr_material.cd_unidade_medida_dose%type;
ie_via_aplic_sug_w		prescr_material.ie_via_aplicacao%type;
qt_dose_sug_w			prescr_material.qt_dose%type;
qt_dias_lib_sug_w		prescr_material.qt_dias_liberado%type;
qt_dias_solic_sug_w		prescr_material.qt_dias_solicitado%type;
nr_seq_material_w		prescr_material.nr_sequencia%type;
nm_usuario_w			usuario.nm_usuario%type;
ie_concordo_sug_w		varchar(1);
ie_medic_sug_w			varchar(1) := 'N';
ie_novo_cliclo_ccih_w  prescr_material.ie_novo_ciclo_ccih%type;
ie_dias_util_medic_w	material.ie_dias_util_medic%type;	
nr_dia_util_w			prescr_material.nr_dia_util%type;
max_nr_dia_util_w		nr_dia_util_w%type;	
dt_prim_horario_w		timestamp;
dt_inicio_prescr_w		timestamp;
nr_horas_validade_w		prescr_medica.nr_horas_validade%type;
qt_hora_intervalo_w		prescr_material.qt_hora_intervalo%type;
qt_min_intervalo_w		prescr_material.qt_min_intervalo%type;
qt_operacao_w			double precision;
ds_horario_w			varchar(255);
ds_horario_ww			varchar(255);


BEGIN 
 
SELECT * FROM Obter_se_prescr_sug_cih(nr_prescricao_p, nr_seq_material_p, nr_prescr_orig_p, nr_prescr_sug_w, ie_medic_sug_w) INTO STRICT nr_prescr_sug_w, ie_medic_sug_w;
 
if (ie_medic_sug_w = 'S') and (nr_prescr_sug_w > 0) then 
	 
	select 	coalesce(max(ie_dias_util_medic),'N') 
	into STRICT	ie_dias_util_medic_w 
	from	Material 
	where	cd_material = cd_material_p;
 
	select max(cd_material_substituicao), 
		max(cd_intervalo), 
		max(cd_unidade_medida_dose), 
		max(ie_via_aplicacao), 
		max(qt_dose), 
		max(qt_dias_liberado), 
		max(qt_dias_solicitado), 
		max(ie_concordo), 
		max(nr_seq_material), 
		max(nm_usuario) 
	into STRICT	cd_material_sug_w, 
		cd_intervalo_sug_w, 
		cd_unid_med_sug_w, 
		ie_via_aplic_sug_w, 
		qt_dose_sug_w, 
		qt_dias_lib_sug_w, 
		qt_dias_solic_sug_w, 
		ie_concordo_sug_w, 
		nr_seq_material_w, 
		nm_usuario_w 
	from 	medicamento_cih_sug 
	where nr_prescricao = nr_prescr_sug_w 
	and	cd_material = cd_material_p 
	and	coalesce(ie_concordo,'N') <> 'X';
	 
	if (ie_concordo_sug_w = 'S') then 
	 
		if (cd_material_sug_w <> cd_material_p) then 
			if (ie_dias_util_medic_w = 'O') then 
				nr_dia_util_w := 0;
			elsif (ie_dias_util_medic_w = 'S') then 
				nr_dia_util_w := 1;
			end if;
			 
			ie_novo_cliclo_ccih_w 	:= 'S';
			qt_dias_solic_sug_w	 	:= qt_dias_lib_sug_w;
		else 
			 qt_dias_solic_sug_w		:= null;
			 nr_dia_util_w				:= null;
		end if;		
	elsif (ie_concordo_sug_w = 'N') then 
		if (ie_dias_util_medic_w = 'O') then 
			nr_dia_util_w := 0;
		elsif (ie_dias_util_medic_w = 'S') then 
			nr_dia_util_w := 1;
		end if;
		ie_novo_cliclo_ccih_w := 'S';
		qt_dias_solic_sug_w	 := null;
		qt_dias_lib_sug_w	 := null;
		 
	end if;
	 
	select to_date('30/12/1899' || max(a.hr_prim_horario),'dd/mm/yyyy hh24:mi'), 
		  	max(b.dt_inicio_prescr), 
			max(b.nr_horas_validade), 
			max(a.qt_hora_intervalo), 
			max(a.qt_min_intervalo) 
	into STRICT	dt_prim_horario_w, 
			dt_inicio_prescr_w, 
			nr_horas_validade_w, 
			qt_hora_intervalo_w, 
			qt_min_intervalo_w			 
	from 	prescr_material a, 
			prescr_medica b 
	where 	a.nr_prescricao 	= nr_prescricao_p 
	and		a.nr_prescricao = b.nr_prescricao 
	and		a.cd_material 	= cd_material_p 
	and		a.nr_sequencia	= nr_seq_material_p;
	 
	ds_horario_w := null;
	qt_operacao_w := null;
	 
	if (ie_concordo_sug_w = 'S') and (cd_intervalo_sug_w IS NOT NULL AND cd_intervalo_sug_w::text <> '') then 
		SELECT * FROM calcular_horario_prescricao(nr_prescricao_p, cd_intervalo_sug_w, dt_prim_horario_w, dt_inicio_prescr_w, nr_horas_validade_w, cd_material_p, qt_hora_intervalo_w, qt_min_intervalo_w, qt_operacao_w, ds_horario_w, ds_horario_ww, 'N', null) INTO STRICT qt_operacao_w, ds_horario_w, ds_horario_ww;
									 
		ds_horario_w := ds_horario_w || ds_horario_ww;
	end if;
	 
	update prescr_material 
	set	dt_atualizacao 			= clock_timestamp(), 
		cd_material	  			= CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(cd_material_sug_w,cd_material)  ELSE cd_material END , 
		cd_intervalo  			= CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(cd_intervalo_sug_w,cd_intervalo)  ELSE cd_intervalo END , 
		cd_unidade_medida_dose = CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(cd_unid_med_sug_w,cd_unidade_medida_dose)  ELSE cd_unidade_medida_dose END , 
		ie_via_aplicacao		= CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(ie_via_aplic_sug_w,ie_via_aplicacao)  ELSE ie_via_aplicacao END , 
		qt_dose					= CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(qt_dose_sug_w,qt_dose)  ELSE qt_dose END , 
		ds_justificativa		= CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(ds_justificativa,/*'Medicamento sugerido pelo infectologista e aceito pelo prescritor'*/obter_desc_expressao(781869))  ELSE PERFORM obter_desc_expressao(507350)/*'Novo Ciclo iniciado'*/ END , 
		qt_dias_liberado		= CASE WHEN cd_material=cd_material_sug_w THEN  null  ELSE coalesce(qt_dias_lib_sug_w,qt_dias_liberado) END , 
		qt_dias_solicitado		= coalesce(qt_dias_solic_sug_w,qt_dias_solicitado), 
		ie_novo_ciclo_ccih		= coalesce(ie_novo_cliclo_ccih_w,ie_novo_ciclo_ccih), 
		nr_dia_util				= coalesce(nr_dia_util_w, nr_dia_util), 
		nr_ocorrencia			= coalesce(qt_operacao_w, nr_ocorrencia), 
		ds_horarios				= coalesce(ds_horario_w, ds_horarios) 
	where 	nr_prescricao 	= nr_prescricao_p 
	and	cd_material 		= cd_material_p 
	and	nr_sequencia		= nr_seq_material_p;
	 
	if (cd_material_sug_w = cd_material_p) then 
		if (ie_concordo_sug_w = 'N') then 
			select	Obter_Max_Nr_Dia_Util(nr_prescricao, nr_sequencia, qt_dias_solicitado) 
			into STRICT	max_nr_dia_util_w 
			from 	prescr_material 
			where	nr_prescricao = nr_prescr_sug_w 
			and	nr_sequencia = nr_seq_material_w;
		else 
			max_nr_dia_util_w := 0;
		end if;	
		 
		update prescr_material 
		set		qt_dias_liberado = CASE WHEN ie_concordo_sug_w='S' THEN  coalesce(qt_dias_lib_sug_w,qt_dias_liberado)  ELSE max_nr_dia_util_w END  
		where	nr_prescricao = nr_prescr_sug_w 
		and	nr_sequencia = nr_seq_material_w;
		 
		if (qt_dias_lib_sug_w = qt_dias_solic_sug_w) then 
			CALL inserir_prescr_mat_lib_cih('T',nr_prescr_sug_w, nr_seq_material_w, null, nm_usuario_w);
		else 
			CALL inserir_prescr_mat_lib_cih('P',nr_prescr_sug_w, nr_seq_material_w, null, nm_usuario_w);
		end if;	
	end if;
	 
	if (ie_concordo_sug_w = 'N') or (cd_material_sug_w <> cd_material_p)then		 
		update prescr_material 
		set		qt_total_dias_lib = coalesce(qt_dias_solic_sug_w,0) 
		where 	nr_prescricao 	= nr_prescricao_p 
		and	nr_sequencia		= nr_seq_material_p;	
	end if;
	 
	 
	update medicamento_cih_sug 
	set	ie_concordo = 'X' 
	where nr_prescricao = nr_prescr_sug_w 
	and	cd_material = cd_material_p 
	and	ie_concordo = 'S';
	 
	commit;
	 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_subst_sug_cih (nr_prescricao_p bigint, nr_seq_material_p bigint, nr_prescr_orig_p bigint, cd_material_p bigint) FROM PUBLIC;
