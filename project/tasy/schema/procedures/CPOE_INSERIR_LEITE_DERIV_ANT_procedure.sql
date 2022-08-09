-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_inserir_leite_deriv_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_perfil_p perfil.cd_perfil%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_item_gerado_p INOUT text, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_p text default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE

						
-- Duplicata da procedure CPOE_REP_GERAR_LEITE_DERIV
nr_sequencia_w				cpoe_dieta.nr_sequencia%type;
nr_sequencia_vinculo_w		cpoe_dieta.nr_seq_cpoe_vinculo%type;
ie_acm_w					cpoe_dieta.ie_acm%type;
ie_administracao_w			cpoe_dieta.ie_administracao%type;
dt_prim_horario_w			cpoe_dieta.dt_inicio%type;
qt_porcentagem_w			cpoe_dieta.qt_porcentagem_adic1%type;
ie_urgencia_w				cpoe_dieta.ie_urgencia%type:='';
ie_duracao_w				cpoe_dieta.ie_duracao%type := 'P';
ds_horarios_aux_w			cpoe_material.ds_horarios%type:='';

nr_seq_leite_deriv_w		prescr_leite_deriv.nr_sequencia%type;
nr_seq_leite_w				prescr_leite_deriv.nr_sequencia%type;
cd_intervalo_w				prescr_leite_deriv.cd_intervalo%type;
ie_se_necessario_w			prescr_leite_deriv.ie_se_necessario%type;
ie_se_necessario_aux_w		prescr_leite_deriv.ie_se_necessario%type;
ds_horarios_w				prescr_leite_deriv.ds_horarios%type;
hr_prim_horario_w			prescr_leite_deriv.hr_prim_horario%type;
hr_prim_horario_ww			prescr_leite_deriv.hr_prim_horario%type;
ie_via_aplicacao_w			prescr_leite_deriv.ie_via_aplicacao%type;
qt_volume_oral_w			prescr_leite_deriv.qt_volume_oral%type;
qt_volume_sonda_w			prescr_leite_deriv.qt_volume_sonda%type;
qt_vel_infusao_w			prescr_leite_deriv.qt_vel_infusao%type;
qt_volume_total_w			prescr_leite_deriv.qt_volume_total%type;
qt_volume_aux_w				prescr_leite_deriv.qt_volume_total%type;
qt_volume_total_aux_w		prescr_leite_deriv.qt_volume_total%type;
nr_seq_disp_succao_w		prescr_leite_deriv.nr_seq_disp_succao%type;
ie_leite_materno_w			prescr_leite_deriv.ie_leite_materno%type;

nr_seq_material_w			prescr_material.nr_sequencia%type;
cd_material_w				prescr_material.cd_material%type;
cd_material_adic_w			prescr_material.cd_material%type;
qt_dose_w					prescr_material.qt_dose%type;
qt_dose_aux_w				prescr_material.qt_dose%type;
qt_dose_mat_adic_w			prescr_material.qt_dose%type;
cd_unidade_medida_dose_w	prescr_material.cd_unidade_medida_dose%type;
ie_via_leite_w				prescr_material.ie_via_leite%type;
ie_via_leite_aux_w			prescr_material.ie_via_leite%type;
ie_regra_volume_leite_w		prescr_material.ie_regra_volume_leite%type;
nr_ocorrencia_w				prescr_material.nr_ocorrencia%type;

qt_min_intervalo_w 		intervalo_prescricao.qt_min_intervalo%type;

ie_prescr_alta_agora_w		varchar(1);
ie_regra_isolado_w			varchar(1);
ds_restricao_w				varchar(255):='';
ds_restricao_q_w			varchar(255):='';
sql_w						varchar(4000);
ds_sep_bv_w					varchar(10);
ds_parametros_w				varchar(2000);
count_mat_w					bigint := 1;
count_prod_w				bigint := 0;
count_reg_w					bigint := 0;
nr_registros_w				bigint := 1;
qt_porcent_w				double precision;
dt_fim_w					timestamp := null;
ie_via_aplicacao_ww			cpoe_dieta.ie_via_leite1%type;

C01 CURSOR FOR
SELECT	nr_sequencia,
	cd_intervalo,
	ie_se_necessario,
	ds_horarios,
	hr_prim_horario,
	CASE WHEN ie_via_aplicacao='S' THEN obter_via_usuario('Ent') WHEN ie_via_aplicacao='O' THEN upper(obter_via_usuario('VO'))  ELSE upper(obter_via_usuario('OS')) END ,
	qt_volume_oral,
	qt_volume_sonda,
	qt_vel_infusao,
	qt_volume_total,
	nr_seq_disp_succao,
	ie_leite_materno	
from	prescr_leite_deriv
where	nr_prescricao = nr_prescricao_p
and nr_sequencia = nr_seq_leite_w
order by	nr_sequencia;

C02 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	qt_dose,
	CASE WHEN ie_via_leite='S' THEN obter_via_usuario('Ent') WHEN ie_via_leite='O' THEN upper(obter_via_usuario('VO'))  ELSE upper(obter_via_usuario('OS')) END ,
	ie_regra_volume_leite
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	nr_seq_leite_deriv = nr_seq_leite_deriv_w
and	nr_sequencia = nr_sequencia_p
and	ie_agrupador = 16
order by	nr_sequencia;

C03 CURSOR FOR
SELECT	cd_material,
	qt_dose,
	cd_unidade_medida_dose,
	qt_porcentagem
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia_diluicao = nr_seq_material_w
and	ie_agrupador = 17
order by	nr_sequencia LIMIT 4;


BEGIN
ie_prescr_alta_agora_w := obter_param_usuario(924, 409, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_prescr_alta_agora_w);

select	max(nr_seq_leite_deriv)
into STRICT	nr_seq_leite_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia = nr_sequencia_p;

open C01;
loop
fetch C01 into	
	nr_seq_leite_deriv_w,
	cd_intervalo_w,
	ie_se_necessario_w,
	ds_horarios_w,
	hr_prim_horario_w,
	ie_via_aplicacao_w,
	qt_volume_oral_w,
	qt_volume_sonda_w,
	qt_vel_infusao_w,
	qt_volume_total_w,
	nr_seq_disp_succao_w,
	ie_leite_materno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	ie_acm_w := 'N';
	ie_administracao_w := 'P';
	ie_regra_isolado_w := 'N';
	ie_se_necessario_aux_w := ie_se_necessario_w;
	count_reg_w := 0;
	
	if (coalesce(ie_prescr_alta_agora_w,'N') = 'S') and (coalesce(ie_item_alta_p,'N') = 'S')	then
	
		ie_urgencia_w := 0;
		
		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, null, clock_timestamp(), 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
		
		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
	
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
		dt_prim_horario_w	:= to_date(to_char(clock_timestamp(),'dd/mm/yyyy ') || hr_prim_horario_w, 'dd/mm/yyyy hh24:mi');
	
		if (dt_prim_horario_w < clock_timestamp()) then
			dt_prim_horario_w := dt_prim_horario_w + 1;
		end if;
	else
		ie_urgencia_w := '';
		SELECT * FROM cpoe_atualizar_periodo_vig_ant(ds_horarios_w, hr_prim_horario_w, dt_prim_horario_w) INTO STRICT ds_horarios_w, hr_prim_horario_w, dt_prim_horario_w;
	end if;
	
	if (ie_retrogrado_p = 'S' or ie_futuro_p = 'S') then -- retrograde/backward item
		dt_prim_horario_w := dt_inicio_p;
		dt_fim_w := (dt_prim_horario_w + 1) - 1/1440;
		ie_duracao_w := 'P';
		ie_urgencia_w := null;
		nr_ocorrencia_w := 0;
		ds_horarios_w := '';
		ds_horarios_aux_w := '';
		
		select	max(qt_min_intervalo)
		into STRICT	qt_min_intervalo_w
		from	intervalo_prescricao
		where	cd_intervalo = cd_intervalo_w;

		SELECT * FROM cpoe_calcular_horario_prescr(nr_atendimento_p, cd_intervalo_w, null, dt_prim_horario_w, 0, qt_min_intervalo_w, nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w, nm_usuario_p, cd_estabelecimento_p, cd_perfil_p, null) INTO STRICT nr_ocorrencia_w, ds_horarios_w, ds_horarios_aux_w;
		
		ds_horarios_w	:= ds_horarios_w || ds_horarios_aux_w;
		hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	end if;

	select	nextval('cpoe_dieta_seq')
	into STRICT	nr_sequencia_w
	;

	insert into cpoe_dieta(
				nr_sequencia,
				nr_atendimento,
				ie_tipo_dieta,
				ie_leite_materno,
				cd_intervalo,
				qt_vel_infusao,
				ie_tipo_dosagem,
				nr_seq_disp_succao,
				ie_administracao,
				dt_inicio,
				dt_fim,
				hr_prim_horario,
				ds_horarios,
				ie_acm,
				ie_se_necessario,
				ie_duracao,	
				nm_usuario,
				nm_usuario_nrec,
				dt_atualizacao,
				dt_atualizacao_nrec,
				cd_pessoa_fisica,
				cd_funcao_origem,
				nr_seq_transcricao,
				ie_urgencia,
				ie_item_alta,
				ie_prescritor_aux,
				cd_medico,
				ie_retrogrado,
				nr_seq_pepo,
				nr_cirurgia,
				nr_cirurgia_patologia,
				nr_seq_agenda,
				nr_seq_conclusao_apae,
				ie_futuro,
				nr_seq_cpoe_order_unit)
			values (
				nr_sequencia_w,
				nr_atendimento_p,
				'L',
				ie_leite_materno_w,
				cd_intervalo_w,
				qt_vel_infusao_w,
				'mlh',
				nr_seq_disp_succao_w,
				ie_administracao_w,
				dt_prim_horario_w,
				(dt_prim_horario_w + 1) - 1/1440,
				hr_prim_horario_w,
				ds_horarios_w,
				ie_acm_w,
				ie_se_necessario_aux_w,
				ie_duracao_w,
				nm_usuario_p,
				nm_usuario_p,
				clock_timestamp(),
				clock_timestamp(),
				obter_cd_paciente_prescricao(nr_prescricao_p),
				2314,
				nr_seq_transcricao_p,
				ie_urgencia_w,
				ie_item_alta_p,
				ie_prescritor_aux_p,
				cd_medico_p,
				ie_retrogrado_p,
				nr_seq_pepo_p,
				nr_cirurgia_p,
				nr_cirurgia_patologia_p,
				nr_seq_agenda_p,
				nr_seq_conclusao_apae_p,
				ie_futuro_p,
				nr_seq_cpoe_order_unit_p);
	
	commit;	
	
	
	ds_sep_bv_w	:= obter_separador_bv;	
	count_mat_w := 0;
	ie_via_aplicacao_ww := null;
	
	if (coalesce(nr_seq_cpoe_p,0) > 0) then
	
		select 	max(ie_via_leite1)
		into STRICT	ie_via_aplicacao_ww
		from 	cpoe_dieta
		where	nr_sequencia = nr_seq_cpoe_p;
	end if;
	
	open C02;
	loop
	fetch C02 into	
		nr_seq_material_w,
		cd_material_w,
		qt_dose_w,
		ie_via_leite_w,
		ie_regra_volume_leite_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin		

		count_reg_w := count_reg_w + 1;		
		count_prod_w := count_prod_w +1;
		
		if (upper(ie_via_leite_w) = upper(obter_via_usuario('OS'))) then
			if (count_reg_w = 1) then
				ie_via_leite_aux_w := coalesce(ie_via_aplicacao_ww,upper(obter_via_usuario('VO')));
				qt_dose_aux_w := qt_volume_oral_w;
				qt_volume_aux_w := qt_volume_oral_w;
				nr_sequencia_vinculo_w := nr_sequencia_w;
				nr_seq_item_gerado_p := nr_sequencia_w;
			else
				ie_via_leite_aux_w := coalesce(ie_via_aplicacao_ww,obter_via_usuario('Ent'));
				qt_dose_aux_w := qt_volume_sonda_w;
				qt_volume_aux_w := qt_volume_sonda_w;
				nr_seq_item_gerado_p := nr_seq_item_gerado_p || ';' || nr_sequencia_w;
			end if;
		else
			ie_via_leite_aux_w := coalesce(ie_via_aplicacao_ww,ie_via_leite_w);
			qt_dose_aux_w := qt_dose_w;
			qt_volume_aux_w := qt_volume_total_w;
			nr_seq_item_gerado_p := nr_sequencia_w;
		end if;
		
		qt_volume_total_aux_w := qt_volume_aux_w;	
		
		if (count_reg_w = 1) then
			ds_restricao_w 	:=  'ie_via_leite=' || ie_via_leite_aux_w || ds_sep_bv_w;
			ds_restricao_q_w := 'ie_via_leite'||count_prod_w||' = :ie_via_leite,';
		end if;
		
		ds_parametros_w	:= 	'cd_material=' || cd_material_w || ds_sep_bv_w||
					'qt_dose=' || qt_dose_aux_w || ds_sep_bv_w||
					ds_restricao_w ||
					'nr_sequencia=' || nr_sequencia_w || ds_sep_bv_w;
					
		sql_w :='	update	cpoe_dieta '||
				'	set		cd_mat_prod'||count_prod_w||' = :cd_material,'||
				'			cd_unid_med_prod'||count_prod_w||'	= '''||obter_unid_med_usua('ml')||''','||
				ds_restricao_q_w ||
				'			qt_dose_prod'||count_prod_w||' = :qt_dose'||				
				'  where	nr_sequencia = :nr_sequencia';
		
		CALL exec_sql_dinamico_bv('', sql_w, ds_parametros_w);				

		
		open C03;
		loop
		fetch C03 into	
			cd_material_adic_w,
			qt_dose_mat_adic_w,
			cd_unidade_medida_dose_w,
			qt_porcentagem_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			count_mat_w := count_mat_w + 1;

			if (upper(ie_via_leite_w) = upper(obter_via_usuario('OS'))) then
				if (count_reg_w = 1) then
					qt_porcent_w := (qt_volume_oral_w * 100) / qt_volume_total_w;
					qt_dose_mat_adic_w := qt_dose_mat_adic_w * (qt_porcent_w/100);
				else
					qt_porcent_w := (qt_volume_sonda_w * 100) / qt_volume_total_w;
					qt_dose_mat_adic_w := qt_dose_mat_adic_w * (qt_porcent_w/100);
				end if;				
			end if;
			
			if (upper(cd_unidade_medida_dose_w) = upper(obter_unid_med_usua('ml'))) then
				qt_volume_total_aux_w := qt_volume_total_aux_w + qt_dose_mat_adic_w;
			end if;
			
			
			ds_parametros_w	:= 	'cd_material=' || cd_material_adic_w || ds_sep_bv_w||
						'qt_dose=' || qt_dose_mat_adic_w || ds_sep_bv_w||
						'cd_unidade_medida_dose=' || cd_unidade_medida_dose_w || ds_sep_bv_w ||
						'qt_porcentagem_adic=' || qt_porcentagem_w || ds_sep_bv_w ||
						'nr_sequencia=' || nr_sequencia_w || ds_sep_bv_w;
				
			sql_w :='	update	cpoe_dieta '||
					'	set		cd_mat_prod_adic'||count_mat_w||' = :cd_material,'||
					'			cd_unid_med_prod_adic'||count_mat_w||'	= :cd_unidade_medida_dose,'||
					'			qt_dose_prod_adic'||count_mat_w||' = :qt_dose,'||
					'			qt_porcentagem_adic'||count_mat_w||' = :qt_porcentagem_adic'||
					'  where	nr_sequencia = :nr_sequencia';

			CALL exec_sql_dinamico_bv('', sql_w, ds_parametros_w);
			
			end;
		end loop;
		close C03; 			
				
		if (ie_regra_volume_leite_w = 'I') then
			ie_regra_isolado_w := 'S';
		else
			ie_regra_isolado_w := 'N';
		end if;
		
		if (ie_regra_isolado_w = 'S') then
			ie_se_necessario_aux_w := 'S';
		else
			ie_se_necessario_aux_w := ie_se_necessario_w;
		end if;

		if (ie_se_necessario_aux_w = 'S') then
			ie_administracao_w	:= 'N';
			ds_horarios_w		:= '';
			hr_prim_horario_w	:= '';
		end if;		

		
		ds_parametros_w	:= 	'qt_volume_total=' || qt_volume_total_aux_w || ds_sep_bv_w||
							'ie_administracao=' || ie_administracao_w || ds_sep_bv_w||
							'ds_horarios=' || ds_horarios_w || ds_sep_bv_w||
							'hr_prim_horario=' || hr_prim_horario_w || ds_sep_bv_w||
							'ie_se_necessario=' || ie_se_necessario_aux_w || ds_sep_bv_w||
							'nr_sequencia=' || nr_sequencia_w || ds_sep_bv_w;
					
		sql_w :='	update	cpoe_dieta '||
				'	set		qt_volume = :qt_volume_total,'||
				'			ie_administracao = :ie_administracao,'||
				'			ds_horarios = :ds_horarios,'||
				'			hr_prim_horario = :hr_prim_horario,'||
				'			ie_se_necessario = :ie_se_necessario'||
				'  where	nr_sequencia = :nr_sequencia';

		CALL exec_sql_dinamico_bv('', sql_w, ds_parametros_w);
		
		if (ie_via_leite_w = 'OS') and (count_reg_w = 2) then
			ds_parametros_w	:= 	'nr_sequencia_vinculo=' || nr_sequencia_vinculo_w || ds_sep_bv_w||
								'nr_sequencia=' || nr_sequencia_w || ds_sep_bv_w;
						
			sql_w :='	update	cpoe_dieta '||
					'	set		nr_seq_cpoe_vinculo = :nr_sequencia_vinculo'||
					'  where	nr_sequencia = :nr_sequencia';

			CALL exec_sql_dinamico_bv('', sql_w, ds_parametros_w);
		end if;
		
		update	prescr_material
		set		nr_seq_dieta_cpoe = nr_sequencia_w
		where	nr_sequencia = nr_seq_material_w
		and		nr_prescricao = nr_prescricao_p;
		
		end;
	end loop;
	close C02;
	
	
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_inserir_leite_deriv_ant ( nr_atendimento_p prescr_medica.nr_atendimento%type, nr_atendimento_ant_p prescr_medica.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p prescr_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_perfil_p perfil.cd_perfil%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_item_gerado_p INOUT text, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, nr_seq_conclusao_apae_p bigint default null, ie_futuro_p text default 'N', nr_seq_cpoe_p text default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;
