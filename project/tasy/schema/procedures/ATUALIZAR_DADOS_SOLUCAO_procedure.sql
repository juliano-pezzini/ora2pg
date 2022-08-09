-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_dados_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_volume_p bigint, nr_seq_mat_padrao_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_calc_aut_w				varchar(5);
ie_esquema_Alternado_w		varchar(5);
nr_etapas_w					bigint;
qt_solucao_total_w			double precision;
ie_tipo_dosagem_w			varchar(5);
ie_bomba_elatomerica_w		bigint;
nr_seq_w					bigint;
qt_dosagem_final_w			double precision;
qt_dosagem_w				double precision;
qt_soro_w					double precision;
ds_erro_w					varchar(255);
qt_solucao_w				double precision;
qt_volume_w					double precision;
varManterSoroSeDoseZero_w	varchar(1);
cd_intervalo_w				varchar(7);
VarIntervaloSolucao			varchar(1);
ie_se_necessario_w			varchar(2);
ie_bomba_infusao_w			varchar(200);
hr_prim_horario_w			varchar(200);
ie_urgencia_w				varchar(1);
ie_check_intervalo_w		varchar(1);
cd_intervalo_sol_w			varchar(7);
ie_se_necessario_sol_w		varchar(2);
hr_prim_horario_sol_w		varchar(200);
ie_urgencia_sol_w			varchar(1);
ie_acm_sol_w				varchar(1);
ie_agora_acm_sn_w			varchar(10);
qt_hora_fase_w				double precision;
qt_tempo_aplicacao_w		double precision;
ie_arredondar_etapa_w		varchar(1);
ie_etapa_especial_w			varchar(1);
nr_intervalos_w				bigint;
ds_horarios_w				varchar(2000);
ds_horarios_ww				varchar(2000);
ie_horario_solucao_w		varchar(1);
ie_calcula_hor_sol_acm_w	varchar(1);
ie_calcula_hor_sol_w		varchar(1);
ie_interv_agora_w			varchar(1);
ie_vel_conforme_etapa_w	 	varchar(1);
CalcVolTotalSemCalcAut		varchar(1);
ie_arredonda_vel_inf_w		varchar(1);
cd_funcao_origem_w			prescr_medica.cd_funcao_origem%type;
qt_tempo_aplicacao_ww		prescr_solucao.qt_tempo_aplicacao%type;



BEGIN

select 	max(cd_funcao_origem)
into STRICT	cd_funcao_origem_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

ie_horario_solucao_w := Obter_Param_Usuario(924, 284, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_horario_solucao_w);
ie_calcula_hor_sol_w := Obter_Param_Usuario(924, 302, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_calcula_hor_sol_w);
ie_interv_agora_w := Obter_Param_Usuario(924, 548, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_interv_agora_w);
ie_arredonda_vel_inf_w := Obter_Param_Usuario(924, 560, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_arredonda_vel_inf_w);
ie_arredondar_etapa_w := Obter_Param_Usuario(924, 742, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_arredondar_etapa_w);
ie_calcula_hor_sol_acm_w := Obter_Param_Usuario(924, 744, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_calcula_hor_sol_acm_w);
ie_check_intervalo_w := Obter_Param_Usuario(924, 809, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_check_intervalo_w);
varManterSoroSeDoseZero_w := Obter_Param_Usuario(924, 874, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, varManterSoroSeDoseZero_w);
ie_vel_conforme_etapa_w := Obter_Param_Usuario(924, 855, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_vel_conforme_etapa_w);
CalcVolTotalSemCalcAut := Obter_Param_Usuario(924, 805, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, CalcVolTotalSemCalcAut);

if (coalesce(cd_funcao_origem_w,924) = 950) then
	VarIntervaloSolucao := Obter_Param_Usuario(950, 42, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, VarIntervaloSolucao);
else
	VarIntervaloSolucao := Obter_Param_Usuario(924, 590, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, VarIntervaloSolucao);
end if;

select	max(cd_intervalo),
	coalesce(max(ie_se_necessario),'N'),
	max(hr_prim_horario),
	max(ie_urgencia),
	max(ie_acm),
	max(qt_hora_fase),
	max(ie_calc_aut),
	coalesce(max(ie_esquema_Alternado),'N'),
	max(nr_etapas),
	max(ie_tipo_dosagem),
	max(qt_tempo_aplicacao),
	max(ie_bomba_elastomerica),
	max(ie_etapa_especial),
	max(ds_horarios),
	coalesce(max(ie_bomba_infusao),'N')
into STRICT	cd_intervalo_sol_w,
	ie_se_necessario_sol_w,
	hr_prim_horario_sol_w,
	ie_urgencia_sol_w,
	ie_acm_sol_w,
	qt_hora_fase_w,
	ie_calc_aut_w,
	ie_esquema_Alternado_w,
	nr_etapas_w,
	ie_tipo_dosagem_w,
	qt_tempo_aplicacao_w,
	ie_bomba_elatomerica_w,
	ie_etapa_especial_w,
	ds_horarios_w,
	ie_bomba_infusao_w
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p;

if (coalesce(nr_seq_mat_padrao_p,0) > 0) then

	if (VarIntervaloSolucao = 'S') then
		cd_intervalo_w		:= Obter_Padrao_Param_Sol(nr_prescricao_p,nr_seq_mat_padrao_p,'I');
		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then

			select	max(cd_intervalo)
			into STRICT	cd_intervalo_w
			from	intervalo_prescricao
			where	cd_intervalo	= cd_intervalo_w
			and	ie_situacao	= 'A'
			and	Obter_se_intervalo(cd_intervalo, 15) = 'S'
			--and	nvl(ie_se_farmacia_amb,'N') = 'N'
			and	((ie_interv_agora_w = 'S') or (ie_agora <> 'S'))
			and	((coalesce(cd_estabelecimento::text, '') = '') or (cd_estabelecimento = cd_estabelecimento_p))
			and	obter_se_exibe_intervalo(nr_prescricao_p,cd_intervalo, null) = 'S';

		end if;

	end if;

	ie_se_necessario_w	:= Obter_Padrao_Param_Sol(nr_prescricao_p,nr_seq_mat_padrao_p,'SN');
	hr_prim_horario_w	:= Obter_Padrao_Param_Sol(nr_prescricao_p,nr_seq_mat_padrao_p,'H');
	ie_urgencia_w		:= Obter_Padrao_Param_Sol(nr_prescricao_p,nr_seq_mat_padrao_p,'A');

	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		ie_agora_acm_sn_w	:= obter_se_interv_agora_acm_sn(cd_intervalo_w);
		if (ie_check_intervalo_w	= 'S') and (ie_agora_acm_sn_w	<> '') then
			ie_acm_sol_w		:= 'N';
			ie_urgencia_sol_w	:= 'N';
			ie_se_necessario_sol_w	:= 'N';
			if (ie_agora_acm_sn_w	= 'AGORA') then
				ie_urgencia_w		:= 'S';
			elsif (ie_agora_acm_sn_w	= 'SN') then
				ie_se_necessario_w	:= 'S';
			elsif (ie_agora_acm_sn_w	= 'ACM') then
				ie_acm_sol_w		:= 'S';
			end if;
		end if;
		SELECT * FROM Calcular_etapas_interv_solucao(cd_intervalo_w, qt_tempo_aplicacao_w, ie_arredondar_etapa_w, qt_hora_fase_w, nr_etapas_w, null, null) INTO STRICT qt_hora_fase_w, nr_etapas_w;
		CALL Ajustar_valores_item_sol(nr_etapas_w,nr_prescricao_p, nr_seq_solucao_p, cd_intervalo_w, nm_usuario_p);
	end if;

	cd_intervalo_sol_w	:= coalesce(cd_intervalo_w,cd_intervalo_sol_w);
	ie_se_necessario_sol_w	:= coalesce(ie_se_necessario_w,ie_se_necessario_sol_w);
	hr_prim_horario_sol_w	:= coalesce(hr_prim_horario_w,hr_prim_horario_sol_w);
	ie_urgencia_sol_w	:= coalesce(ie_urgencia_w,ie_urgencia_sol_w);

	if (ie_calc_aut_w	= 'S') then
		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then

			if (coalesce(nr_etapas_w,0) 		> 0) and (coalesce(qt_tempo_aplicacao_w,0)	> 0) then
				if (ie_etapa_especial_w	= 'S') then
					nr_intervalos_w	:= nr_etapas_w	+ 1;
				else
					nr_intervalos_w	:= nr_etapas_w;
				end if;
			elsif (ie_etapa_especial_w		= 'S') and
				((ie_se_necessario_sol_w	= 'S') or (ie_acm_sol_w			= 'S')) then
				if	((ie_calcula_hor_sol_acm_w	= 'S' AND ie_acm_sol_w			= 'S') or
					 (ie_calcula_hor_sol_w		= 'S' AND ie_se_necessario_sol_w	= 'S'))  then
					nr_intervalos_w	:= coalesce(nr_etapas_w,0) + 1;
				else
					nr_intervalos_w	:= 1;
				end if;
			end if;

			qt_tempo_aplicacao_ww := null;

			if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') and (coalesce(qt_hora_fase_w,0) > 0) and (coalesce(nr_etapas_w,0) > 0) and (coalesce(VarIntervaloSolucao,'N') = 'S') and (coalesce(ie_arredondar_etapa_w,'N') = 'S') and (coalesce(ie_horario_solucao_w,'N') = 'N') then

			   qt_tempo_aplicacao_ww := qt_hora_fase_w * nr_etapas_w;
			end if;

			SELECT * FROM calcula_horarios_etapas(pkg_date_utils.get_time(clock_timestamp(),hr_prim_horario_sol_w,0), nr_intervalos_w, qt_hora_fase_w, nm_usuario_p, ie_horario_solucao_w, coalesce(qt_tempo_aplicacao_ww,qt_tempo_aplicacao_w), ds_horarios_w, ds_horarios_ww, null, 'N') INTO STRICT ds_horarios_w, ds_horarios_ww;
		end if;
	end if;

end if;

if (ie_bomba_infusao_w = 'N') then
	select	coalesce(max(Obter_Padrao_Param_Sol(nr_prescricao, nr_sequencia, 'DI')),'N')
	into STRICT	ie_bomba_infusao_w
	from	prescr_material
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia_solucao	= nr_seq_solucao_p
	and	(Obter_Padrao_Param_Sol(nr_prescricao, nr_sequencia, 'DI') IS NOT NULL AND (Obter_Padrao_Param_Sol(nr_prescricao, nr_sequencia, 'DI'))::text <> '');
end if;

update	prescr_solucao
set	ie_bomba_elastomerica	= ie_bomba_elastomerica,
	cd_intervalo		= cd_intervalo_sol_w,
	ie_se_necessario	= ie_se_necessario_sol_w,
	hr_prim_horario		= hr_prim_horario_sol_w,
	ie_urgencia		= ie_urgencia_sol_w,
	ie_acm			= ie_acm_sol_w,
	qt_hora_fase		= qt_hora_fase_w,
	nr_etapas		= nr_etapas_w,
	ds_horarios		= ds_horarios_w,
	ie_bomba_infusao	= ie_bomba_infusao_w
where	nr_prescricao		= nr_prescricao_p
and	nr_seq_solucao		= nr_seq_solucao_p;

commit;

if (ie_calc_aut_w = 'S') or (CalcVolTotalSemCalcAut = 'S')then
	if (ie_esquema_Alternado_w <> 'S') then
		qt_solucao_total_w	:= qt_volume_p * nr_etapas_w;
	else
		qt_solucao_total_w	:= qt_volume_p;
	end if;

	qt_dosagem_final_w := Calcular_volume_total_solucao(upper(ie_tipo_dosagem_w), qt_tempo_aplicacao_w, qt_solucao_total_w, qt_dosagem_w, nr_prescricao_p, nr_seq_solucao_p, 1, qt_dosagem_final_w, ie_arredonda_vel_inf_w, nr_etapas_w, ie_vel_conforme_etapa_w, qt_hora_fase_w);


	update	prescr_solucao
	set	qt_solucao_total	= qt_solucao_total_w,
		qt_volume		= qt_volume_p,
		qt_dosagem		= qt_dosagem_final_w
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_solucao		= nr_seq_solucao_p;
else
	update	prescr_solucao
	set	qt_volume		= qt_volume_p
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_solucao		= nr_seq_solucao_p;
end if;

commit;

select	max(a.nr_sequencia)
into STRICT	nr_seq_w
from	prescr_material a,
	material b
where	a.cd_material	= b.cd_material
and	a.nr_prescricao	= nr_prescricao_p
and	a.nr_sequencia_solucao = nr_seq_solucao_p
and	coalesce(b.ie_ancora_solucao,'N') = 'N';

select	sum(a.qt_solucao)
into STRICT	qt_solucao_w
from	prescr_material a,
	material b
where	a.cd_material	= b.cd_material
and	a.nr_prescricao	= nr_prescricao_p
and	a.nr_sequencia_solucao = nr_seq_solucao_p
and	coalesce(b.ie_ancora_solucao,'N') = 'S';

select	max(qt_solucao_total)
into STRICT	qt_solucao_total_w
from	prescr_solucao
where	nr_prescricao		= nr_prescricao_p
and	nr_seq_solucao		= nr_seq_solucao_p;

qt_soro_w	:= qt_solucao_total_w - qt_solucao_w;

if (nr_seq_w > 0) and (ie_bomba_elatomerica_w IS NOT NULL AND ie_bomba_elatomerica_w::text <> '')  then


	if (coalesce(qt_soro_w,0) > 0) or (varManterSoroSeDoseZero_w = 'S') then
		update	prescr_material
		set	qt_dose			= qt_soro_w,
			qt_solucao 		= qt_soro_w,
			cd_unidade_medida_dose 	= (OBTER_UNID_MED_USUA('ml'))
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia_solucao	= nr_seq_solucao_p
		and	nr_sequencia		= nr_seq_w;
	elsif (varManterSoroSeDoseZero_w = 'N') and (coalesce(qt_soro_w,-1) = 0) then

		delete	from prescr_material
		where	nr_prescricao	= nr_prescricao_p
		and	nr_sequencia_solucao	= nr_seq_solucao_p
		and	nr_sequencia	= nr_seq_w;

	end if;

	select	sum(coalesce(qt_solucao,0))
	into STRICT	qt_volume_w
	from	prescr_material
	where	nr_prescricao		= nr_prescricao_p
	and	nr_sequencia_solucao	= nr_seq_solucao_p;

	update	prescr_solucao
	set	qt_volume		= qt_volume_w
	where	nr_prescricao		= nr_prescricao_p
	and	nr_seq_solucao		= nr_seq_solucao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_dados_solucao ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_volume_p bigint, nr_seq_mat_padrao_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
