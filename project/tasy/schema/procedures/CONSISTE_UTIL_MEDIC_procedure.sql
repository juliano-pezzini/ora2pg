-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_util_medic ( nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint, qt_dias_util_medic_p INOUT bigint, qt_dias_liberado_p INOUT bigint, ie_controle_medico_p INOUT bigint, qt_dias_lib_atend_p INOUT bigint) AS $body$
DECLARE


ds_erro_w	varchar(2000);
cd_material_generico_w		integer;
ie_dias_util_medic_w		varchar(1);
ie_data_antimicrobiano_w	varchar(1);
ie_conta_liberados_w		varchar(1);
ie_dias_validade_w			varchar(1);
ie_controle_medico_w		smallint;
qt_dias_util_medic_w		bigint := -1;
nr_dia_util_w				bigint;
qt_dias_Liberado_w			integer;
qt_dia_liberado_w			bigint := 0;
qt_dia_liberado_ww			bigint;
qt_Notificacao_w			integer;
qt_nao_Liberado_w			integer;
dt_validade_prescr_w		timestamp;
dt_anterior_w				timestamp;
dt_dia_parametro_w			timestamp;
dt_validade_fim_w			timestamp;
dt_validade_ini_w			timestamp;
qt_dias_sem_antibiotico_w	smallint;
cd_estabelecimento_w		smallint;
qt_dias_lib_atend_w			bigint;
nr_seq_ficha_tecnica_w		bigint;
ie_consiste_medic_ficha_w	varchar(10);
cd_pessoa_fisica_w			varchar(50);
ie_atb_pessoa_w				varchar(10);
ie_considera_rep_hoje_w		varchar(1);
ie_somar_dias_atb_w			varchar(1);
qt_dia_max_util_w			smallint;
dt_inicio_prescr_w			timestamp;
qt_dia_interv_profilaxia_w	bigint;
ie_objetivo_w				varchar(1);
nr_sequencia_w				integer;
qt_material_w				bigint;
dt_liberacao_prescr_w 		timestamp;
cd_funcao_origem_w			bigint;
cd_intervalo_w				prescr_material.cd_intervalo%type;
ie_operacao_w				intervalo_prescricao.ie_operacao%type;
ie_24_h_w					intervalo_prescricao.ie_24_h%type;
nr_seq_mat_cpoe_w			prescr_material.nr_seq_mat_cpoe%type;
dt_ultimo_horario_w			prescr_mat_hor.dt_horario%type;
count_w						bigint;
dt_prox_geracao_w			cpoe_material.dt_prox_geracao%type;
qt_operacao_w				intervalo_prescricao.qt_operacao%type;
qt_dias_util_medic_ww		bigint := -1;

ie_rastre_prescr_ua_w	varchar(1);
ds_rastre_prescr_ua_w	varchar(2000);


BEGIN
qt_dias_util_Medic_w	:= 0;
qt_dias_Liberado_w		:= 0;
qt_dias_lib_atend_w		:= 0;
qt_dias_util_medic_ww	:= null;

-- Log Utilizacao Antimicrobianos/Antibioticos
ie_rastre_prescr_ua_w := obter_se_info_rastre_prescr('UA', wheb_usuario_pck.get_nm_usuario, obter_perfil_ativo, wheb_usuario_pck.get_cd_estabelecimento);

if (ie_rastre_prescr_ua_w = 'S') then
	ds_rastre_prescr_ua_w := substr('Rastreabilidade Utilizacao Antimicrobianos/Antibioticos consiste_util_medic ' || pls_util_pck.enter_w
		|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
		|| 'nr_prescricao_p:' || nr_prescricao_p || pls_util_pck.enter_w
		|| 'nr_atendimento_p:' || nr_atendimento_p || pls_util_pck.enter_w
		|| 'dt_prescricao_p:' ||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prescricao_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
		|| 'cd_material_p:' || cd_material_p, 1, 2000);
end if;

if (coalesce(cd_material_p,0) <> 0) and (coalesce(nr_prescricao_p,0) <> 0) then

	select	max(dt_validade_prescr),
			max(dt_inicio_prescr),
			max(cd_pessoa_fisica),
			max(cd_estabelecimento),
			max(coalesce(dt_liberacao_medico, dt_liberacao)),
			max(cd_funcao_origem)
	into STRICT	dt_validade_prescr_w,
			dt_inicio_prescr_w,
			cd_pessoa_fisica_w,
			cd_estabelecimento_w,
			dt_liberacao_prescr_w,
			cd_funcao_origem_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	select	count(*)
	into STRICT	qt_material_w
	from	prescr_material a
	where	a.nr_prescricao 	= nr_prescricao_p
	and		a.cd_material 		= cd_material_p;

	/*select	nvl(max(qt_total_dias_lib),0),nr_sequencia_w
				max(ie_objetivo)
		into	qt_dia_liberado_w,
				ie_objetivo_w
		from	prescr_material a
		where	nr_prescricao = nr_prescricao_p
		and		cd_material = cd_material_p;*/
		
	cd_intervalo_w := null;

	if (qt_material_w > 1) then
		select	coalesce(max(qt_total_dias_lib),0),
				max(ie_objetivo),
				max(cd_intervalo),
				max(nr_seq_mat_cpoe)
		into STRICT	qt_dia_liberado_w,
				ie_objetivo_w,
				cd_intervalo_w,
				nr_seq_mat_cpoe_w
		from	prescr_material a
		where	nr_prescricao = nr_prescricao_p
		and		cd_material = cd_material_p;
	else
		begin
		select	a.nr_sequencia
		into STRICT	nr_sequencia_w
		from	prescr_material a
		where	nr_prescricao 	= nr_prescricao_p
		and		cd_material 	= cd_material_p;
		
		exception when others then
			nr_sequencia_w := 0;
		end;

		if (nr_sequencia_w > 0) then
			select	coalesce(a.qt_total_dias_lib,0),
					a.ie_objetivo,
					a.cd_intervalo,
					a.nr_seq_mat_cpoe
			into STRICT	qt_dia_liberado_w,
					ie_objetivo_w,
					cd_intervalo_w,
					nr_seq_mat_cpoe_w
			from	prescr_material a
			where	a.nr_prescricao = nr_prescricao_p
			and		a.nr_sequencia 	= nr_sequencia_w;
		end if;
	end if;
	
	if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		select 	max(ie_operacao),
				max(ie_24_h),
				max(qt_operacao)
		into STRICT 	ie_operacao_w,
				ie_24_h_w,
				qt_operacao_w
		from 	intervalo_prescricao
		where 	cd_intervalo = cd_intervalo_w;
	end if;

	if (coalesce(nr_atendimento_p,0) > 0) then
		select	max(cd_estabelecimento),
				max(cd_pessoa_fisica)
		into STRICT	cd_estabelecimento_w,
				cd_pessoa_fisica_w
		from	atendimento_paciente
		where	nr_atendimento	= nr_atendimento_p;
	end if;

	select	coalesce(max(qt_dias_antibiotico),1),
			coalesce(max(ie_consiste_medic_ficha),'N'),
			coalesce(max(ie_data_antimicrobiano),'M'),
			coalesce(max(ie_atb_pessoa),'N'),
			coalesce(max(ie_considera_rep_hoje),'N'),
			coalesce(max(ie_somar_dias_atb),'N'),
			coalesce(max(ie_conta_liberados),'S'),
			coalesce(max(ie_dias_validade),'S')	
	into STRICT	qt_dias_sem_antibiotico_w,
			ie_consiste_medic_ficha_w,
			ie_data_antimicrobiano_w,
			ie_atb_pessoa_w,
			ie_considera_rep_hoje_w,
			ie_somar_dias_atb_w,
			ie_conta_liberados_w,
			ie_dias_validade_w
	from	parametro_medico
	where	cd_estabelecimento	= cd_estabelecimento_w;

	select	coalesce(max(cd_material_generico), max(cd_material)),
			coalesce(max(ie_dias_util_medic),'N'),
			coalesce(max(obter_controle_medic(cd_material,wheb_usuario_pck.get_cd_estabelecimento,ie_controle_medico,null,null,null)),0),
			coalesce(max(nr_seq_ficha_tecnica),0),
			coalesce(max(qt_max_dia_aplic),100),
			coalesce(max(QT_DIA_INTERV_PROFILAXIA),0)
	into STRICT	cd_material_generico_w,
			ie_dias_util_medic_w,
			ie_controle_medico_w,
			nr_seq_ficha_tecnica_w,
			qt_dia_max_util_w,
			qt_dia_interv_profilaxia_w
	from	material
	where	cd_material	= cd_material_P;

	if (ie_consiste_medic_ficha_w	= 'N') then
		nr_seq_ficha_tecnica_w	:= 0;
	end if;
	
	
	if (ie_rastre_prescr_ua_w = 'S') then
		ds_rastre_prescr_ua_w := substr(ds_rastre_prescr_ua_w || pls_util_pck.enter_w
			|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
			|| 'cd_estabelecimento_w:' || cd_estabelecimento_w || pls_util_pck.enter_w
			|| 'cd_funcao_origem_w:' || cd_funcao_origem_w || pls_util_pck.enter_w
			|| 'cd_intervalo_w:' || cd_intervalo_w || pls_util_pck.enter_w
			|| 'cd_material_generico_w:' || cd_material_generico_w || pls_util_pck.enter_w
			|| 'cd_pessoa_fisica_w:' || cd_pessoa_fisica_w || pls_util_pck.enter_w
			|| 'dt_inicio_prescr_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_prescr_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
			|| 'dt_liberacao_prescr_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_liberacao_prescr_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
			|| 'dt_validade_prescr_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_validade_prescr_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
			|| 'ie_24_h_w:' || ie_24_h_w || pls_util_pck.enter_w
			|| 'ie_atb_pessoa_w:' || ie_atb_pessoa_w || pls_util_pck.enter_w
			|| 'ie_considera_rep_hoje_w:' || ie_considera_rep_hoje_w || pls_util_pck.enter_w
			|| 'ie_consiste_medic_ficha_w:' || ie_consiste_medic_ficha_w || pls_util_pck.enter_w
			|| 'ie_conta_liberados_w:' || ie_conta_liberados_w || pls_util_pck.enter_w
			|| 'ie_controle_medico_w:' || ie_controle_medico_w || pls_util_pck.enter_w
			|| 'ie_data_antimicrobiano_w:' || ie_data_antimicrobiano_w || pls_util_pck.enter_w
			|| 'ie_dias_util_medic_w:' || ie_dias_util_medic_w || pls_util_pck.enter_w
			|| 'ie_dias_validade_w:' || ie_dias_validade_w || pls_util_pck.enter_w
			|| 'ie_objetivo_w:' || ie_objetivo_w || pls_util_pck.enter_w
			|| 'ie_operacao_w:' || ie_operacao_w || pls_util_pck.enter_w
			|| 'ie_somar_dias_atb_w:' || ie_somar_dias_atb_w || pls_util_pck.enter_w
			|| 'nr_seq_ficha_tecnica_w:' || nr_seq_ficha_tecnica_w || pls_util_pck.enter_w
			|| 'nr_seq_mat_cpoe_w:' || nr_seq_mat_cpoe_w || pls_util_pck.enter_w
			|| 'nr_sequencia_w:' || nr_sequencia_w || pls_util_pck.enter_w
			|| 'qt_dia_interv_profilaxia_w:' || qt_dia_interv_profilaxia_w || pls_util_pck.enter_w
			|| 'qt_dia_liberado_w:' || qt_dia_liberado_w || pls_util_pck.enter_w
			|| 'qt_dia_max_util_w:' || qt_dia_max_util_w || pls_util_pck.enter_w
			|| 'qt_dias_sem_antibiotico_w:' || qt_dias_sem_antibiotico_w || pls_util_pck.enter_w
			|| 'qt_material_w:' || qt_material_w || pls_util_pck.enter_w
			|| 'qt_operacao_w:' || qt_operacao_w, 1, 2000);
	end if;
	
	/*    Indica que o sistema var retornar o numero de dias da utilizacao do med */

	if (ie_dias_util_medic_w = 'S') or (ie_dias_util_medic_w = 'O') or (ie_controle_medico_w = 2) then
		begin
		
		if	((ie_considera_rep_hoje_w = 'N') or (cd_funcao_origem_w = 2314)) then
			dt_anterior_w			:= (trunc(dt_prescricao_p,'dd') - 1) + 86399/86400;
		else
			dt_anterior_w			:= (trunc(dt_prescricao_p,'dd')) + 86399/86400;
		end if;
		
		select 	count(a.nr_sequencia)
		into STRICT	count_w
		from 	prescr_mat_hor a,
				prescr_material b
		where	b.nr_prescricao = a.nr_prescricao
		and 	b.nr_sequencia = a.nr_seq_material
		and		b.nr_seq_mat_cpoe = nr_seq_mat_cpoe_w
		and 	a.dt_horario > clock_timestamp() - interval '30 days'
		and 	(a.dt_lib_horario IS NOT NULL AND a.dt_lib_horario::text <> '')
		and 	coalesce(a.dt_suspensao::text, '') = '';
		
		if 	((coalesce(ie_operacao_w,'XPTO') = 'D') or
			 ((coalesce(qt_operacao_w,0) > 24) and (coalesce(ie_operacao_w,'XPTO') = 'H'))) and (coalesce(ie_24_h_w,'N') = 'S') and (coalesce(nr_seq_mat_cpoe_w,0) > 0) and (count_w > 0) then
			
			select 	max(a.dt_horario)
			into STRICT	dt_ultimo_horario_w
			from 	prescr_mat_hor a,
					prescr_material b
			where	b.nr_prescricao = a.nr_prescricao
			and 	b.nr_sequencia = a.nr_seq_material
			and		b.nr_seq_mat_cpoe = nr_seq_mat_cpoe_w
			and 	a.dt_horario > clock_timestamp() - interval '7 days'
			and 	(a.dt_lib_horario IS NOT NULL AND a.dt_lib_horario::text <> '')
			and 	coalesce(a.dt_suspensao::text, '') = '';
			
			select 	max(dt_prox_geracao)
			into STRICT	dt_prox_geracao_w
			from	cpoe_material
			where	nr_sequencia = nr_seq_mat_cpoe_w;
			
			count_w := abs(dt_ultimo_horario_w - dt_prox_geracao_w);
			
			qt_dia_liberado_ww := (coalesce(count_w,0) + coalesce(qt_dias_sem_antibiotico_w,0));
			
		elsif (ie_conta_liberados_w = 'S') then
			qt_dia_liberado_ww := (qt_dia_liberado_w + coalesce(qt_dias_sem_antibiotico_w,0));	
		else
			qt_dia_liberado_ww := coalesce(qt_dias_sem_antibiotico_w,0);
		end if;
		
		if (ie_objetivo_w	in ('F','P','C')) and (coalesce(qt_dia_interv_profilaxia_w,0)	> 0) then
			qt_dia_liberado_ww := qt_dia_interv_profilaxia_w; --qt_dia_liberado_ww - nvl(qt_dias_sem_antibiotico_w,0);		
		end if;	

		dt_dia_parametro_w		:= trunc(dt_prescricao_p,'dd') - qt_dia_liberado_ww;
			
		if (ie_rastre_prescr_ua_w = 'S') then
			ds_rastre_prescr_ua_w := substr(ds_rastre_prescr_ua_w || pls_util_pck.enter_w
				|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
				|| 'count_w:' || count_w || pls_util_pck.enter_w
				|| 'dt_anterior_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_anterior_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
				|| 'dt_dia_parametro_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_dia_parametro_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
				|| 'dt_prox_geracao_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prox_geracao_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
				|| 'dt_ultimo_horario_w:' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_ultimo_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)|| pls_util_pck.enter_w
				|| 'qt_dia_liberado_ww:' || qt_dia_liberado_ww, 1, 2000);
		end if;
		
		if (ie_atb_pessoa_w = 'N') then
			begin
			select	max(a.nr_dia_util),
					coalesce(max(a.qt_total_dias_lib),0)
			into STRICT	qt_dias_util_Medic_w,
					qt_dias_lib_atend_w
			from 	prescr_material a,
					prescr_medica b
			where 	a.nr_prescricao	= b.nr_prescricao
			and		a.ie_suspenso	<> 'S'
			and		a.cd_material in (	SELECT	cd_material_generico_w
										
										
union

										SELECT	cd_material_p
										
										
union

										select	cd_material
										from 	material
										where 	cd_material_generico	= cd_material_generico_w
										
union

										select	cd_material
										from	material
										where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w)
			and		((b.dt_validade_prescr <> dt_validade_prescr_w) or (coalesce(ie_dias_validade_w,'S') = 'S'))
			and		(((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
			and		(((ie_data_antimicrobiano_w = 'M') and ((coalesce(b.dt_liberacao_medico, b.dt_liberacao) IS NOT NULL AND (coalesce(b.dt_liberacao_medico, b.dt_liberacao))::text <> ''))) or
					 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
			and     coalesce(ie_ciclo_reprov,'N') = 'N'		
			and		b.nr_atendimento	= nr_atendimento_p;
				
			
			if (ie_somar_dias_atb_w = 'S') then
				select	coalesce(sum(a.qt_dias_liberado),qt_dias_lib_atend_w)
				into STRICT	qt_dias_lib_atend_w
				from 	prescr_material a,
						prescr_medica b
				where 	a.nr_prescricao	= b.nr_prescricao
				and		a.ie_suspenso	<> 'S'
				and		(a.qt_dias_liberado IS NOT NULL AND a.qt_dias_liberado::text <> '')
				and		(((ie_data_antimicrobiano_w = 'M') and ((coalesce(b.dt_liberacao_medico, b.dt_liberacao) IS NOT NULL AND (coalesce(b.dt_liberacao_medico, b.dt_liberacao))::text <> ''))) or
						 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
				and		a.cd_material in (	SELECT	cd_material_generico_w
											
											
union

											SELECT	cd_material_p
											
											
union

											select	cd_material
											from 	material
											where 	cd_material_generico	= cd_material_generico_w
											
union

											select	cd_material
											from	material
											where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w)
				and		(((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
				and     coalesce(ie_ciclo_reprov,'N') = 'N'	
				and		b.nr_atendimento	= nr_atendimento_p;
			
			end if;

			exception
				when others then
					qt_dias_util_Medic_w	:= 0;
			end;
		else
			begin
			select	max(a.nr_dia_util),
					coalesce(max(a.qt_total_dias_lib),0)
			into STRICT	qt_dias_util_Medic_w,
					qt_dias_lib_atend_w
			from 	prescr_material a,
					prescr_medica b
			where a.nr_prescricao	= b.nr_prescricao
			  and b.cd_pessoa_fisica	= cd_pessoa_fisica_w
			  and a.ie_suspenso	<> 'S'
			  and     coalesce(ie_ciclo_reprov,'N') = 'N'	
			  and	((b.dt_validade_prescr <> dt_validade_prescr_w) or (coalesce(ie_dias_validade_w,'S') = 'S'))
			  and		(((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
			  and	(((ie_data_antimicrobiano_w = 'M') and ((coalesce(b.dt_liberacao_medico, b.dt_liberacao) IS NOT NULL AND (coalesce(b.dt_liberacao_medico, b.dt_liberacao))::text <> ''))) or
					 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
			  and a.cd_material	in (	SELECT	cd_material_generico_w
							
							
union

							SELECT	cd_material_p
							
							
union

							select	cd_material
							from 	material
							where 	cd_material_generico	= cd_material_generico_w
							
union

							select	cd_material
							from	material
							where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w);
							
			if (ie_somar_dias_atb_w = 'S') then
				select	coalesce(max(a.qt_dias_liberado),qt_dias_lib_atend_w)
				into STRICT	qt_dias_lib_atend_w
				from 	prescr_material a,
						prescr_medica b
				where a.nr_prescricao	= b.nr_prescricao
				  and b.cd_pessoa_fisica	= cd_pessoa_fisica_w
				  and a.ie_suspenso	<> 'S'
				  and  coalesce(ie_ciclo_reprov,'N') = 'N'	
				  and	(a.qt_dias_liberado IS NOT NULL AND a.qt_dias_liberado::text <> '')
				  and	(((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
				  and	(((ie_data_antimicrobiano_w = 'M') and ((coalesce(b.dt_liberacao_medico, b.dt_liberacao) IS NOT NULL AND (coalesce(b.dt_liberacao_medico, b.dt_liberacao))::text <> ''))) or
						 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
				  and a.cd_material	in (	SELECT	cd_material_generico_w
								
								
union

								SELECT	cd_material_p
								
								
union

								select	cd_material
								from 	material
								where 	cd_material_generico	= cd_material_generico_w
								
union

								select	cd_material
								from	material
								where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w);
			end if;
			
			exception
				when others then
					qt_dias_util_Medic_w	:= 0;
			end;
		end if;
		
		if (ie_rastre_prescr_ua_w = 'S') then
			ds_rastre_prescr_ua_w := substr(ds_rastre_prescr_ua_w || pls_util_pck.enter_w
				|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
				|| 'qt_dias_lib_atend_w:' || qt_dias_lib_atend_w || pls_util_pck.enter_w
				|| 'qt_dias_util_Medic_w:' || qt_dias_util_Medic_w, 1, 2000);
		end if;
		
		if (coalesce(qt_dias_util_Medic_w::text, '') = '') and (ie_dias_util_medic_w = 'O')then
			qt_dias_util_medic_w	:= 0;
		elsif (coalesce(qt_dias_util_Medic_w::text, '') = '') and (ie_dias_util_medic_w = 'S')then
			qt_dias_util_medic_w	:= 1;
		else	
			select coalesce(max(b.nr_dia_util),0)
			into STRICT   nr_dia_util_w
			from   prescr_medica a,
				  prescr_material b
			where a.nr_atendimento = nr_atendimento_p
			and	  a.nr_prescricao <> nr_prescricao_p
			and	  b.nr_prescricao  = a.nr_prescricao
			and   b.cd_material in ( SELECT cd_material_generico_w
											
											
union

											SELECT	cd_material_p
											
											
union

											select	cd_material
											from 	material
											where 	cd_material_generico	= cd_material_generico_w
											
union

											select	cd_material
											from	material
											where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w)
			and  coalesce(b.ie_ciclo_reprov,'N') = 'N'	
			and	 coalesce(b.ie_suspenso,'N') <> 'S'
			and  dt_validade_prescr = dt_validade_prescr_w;
						
			if (nr_dia_util_w <> 0) then
				qt_dias_util_medic_w  	:= nr_dia_util_w;
			else
				if (coalesce(dt_liberacao_prescr_w::text, '') = '') then
					if (ie_dias_util_medic_w = 'O' AND ie_data_antimicrobiano_w = 'M') then
						qt_dias_util_medic_ww	:= qt_dias_util_medic_w;
					end if;
					qt_dias_util_medic_w	:= qt_dias_util_medic_w + 1;
				end if;
			end if;	
			
		end if;
		
		if (ie_rastre_prescr_ua_w = 'S') then
			ds_rastre_prescr_ua_w := substr(ds_rastre_prescr_ua_w || pls_util_pck.enter_w
				|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
				|| 'nr_dia_util_w:' || nr_dia_util_w || pls_util_pck.enter_w
				|| 'qt_dias_util_medic_w:' || qt_dias_util_medic_w || pls_util_pck.enter_w
				|| 'qt_dias_util_medic_ww:' || qt_dias_util_medic_ww, 1, 2000);
		end if;		
		
		end;
	end if;
		
	/*    Indica que o medico deve Justificar a utilizacao do Mesmo */

	if (ie_controle_medico_w = 1) then
		begin
		if (ie_atb_pessoa_w = 'N') then
			begin
			select count(*)
			into STRICT	qt_Notificacao_w
			from 	prescr_material a,
				prescr_medica b
			where a.nr_prescricao	= b.nr_prescricao
			  and b.nr_atendimento	= nr_atendimento_p
			  and a.ie_suspenso	<> 'S'	
			  and coalesce(ie_ciclo_reprov,'N') = 'N'	
			  and (((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
			/*	  and a.ds_justificativa is not null */

			  and a.cd_material	in (	SELECT	cd_material_generico_w
							
							
union

							SELECT	cd_material_p
							
							
union

							select	cd_material
							from 	material
							where 	cd_material_generico	= cd_material_generico_w
							
union

							select	cd_material
							from	material
							where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w);
			exception
				when others then
					qt_Notificacao_w		:= 0;
			end;
		else
			begin
			select count(*)
			into STRICT	qt_Notificacao_w
			from 	prescr_material a,
				prescr_medica b
			where a.nr_prescricao	= b.nr_prescricao
			  and b.cd_pessoa_fisica	= cd_pessoa_fisica_w
			  and     coalesce(ie_ciclo_reprov,'N') = 'N'	
			  and a.ie_suspenso	<> 'S'
			  and (((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or ((cd_funcao_origem_w <> 2314) and ((b.dt_inicio_prescr between dt_dia_parametro_w and dt_anterior_w) or (b.dt_prescricao between dt_dia_parametro_w and dt_anterior_w))))
			/*	  and a.ds_justificativa is not null */

			  and a.cd_material	in (	SELECT	cd_material_generico_w
							
							
union

							SELECT	cd_material_p
							
							
union

							select	cd_material
							from 	material
							where 	cd_material_generico	= cd_material_generico_w
							
union

							select	cd_material
							from	material
							where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w);
			exception
				when others then
					qt_Notificacao_w		:= 0;
			end;
		end if;
		
		if (qt_Notificacao_w	> 0) then
			ie_controle_medico_w		:= 0;
		end if;
		end;
	end if;

	/*    Indica que o medico deve Justificar a utilizacao do Mesmo */

	if (cd_funcao_origem_w = 2314) then
		dt_validade_ini_w	:= establishment_timezone_utils.startofday(dt_prescricao_p) - qt_dia_max_util_w;
		dt_validade_fim_w	:= dt_prescricao_p + 1;
	else
		dt_validade_ini_w	:= establishment_timezone_utils.startofday(dt_inicio_prescr_w) - qt_dia_max_util_w;
		dt_validade_fim_w	:= coalesce(dt_validade_prescr_w, dt_inicio_prescr_w+1);
	end if;

	if (ie_atb_pessoa_w = 'N') then
		begin
		select	coalesce(sum(qt_dias_liberado),0)
		into STRICT	qt_dias_liberado_w
		from 	prescr_material a,
				prescr_medica b
		where 	a.nr_prescricao	= b.nr_prescricao
		and     coalesce(ie_ciclo_reprov,'N') = 'N'	
		and		a.ie_suspenso	<> 'S'
		and		((ie_data_antimicrobiano_w = 'M' AND b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> '') or
				 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
		and		a.cd_material in (	SELECT	cd_material_generico_w
									
									
union

									SELECT	cd_material_p
									
									
union

									select	cd_material
									from 	material
									where 	cd_material_generico	= cd_material_generico_w
									
union

									select	cd_material
									from	material
									where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w)
		and (((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or (cd_funcao_origem_w <> 2314 AND b.dt_inicio_prescr between dt_validade_ini_w and dt_validade_fim_w))
		and		b.nr_atendimento	= nr_atendimento_p;
		exception
			when others then
				qt_dias_liberado_w	:= 0;
		end;
	else

		begin
		select	coalesce(sum(qt_dias_liberado),0)
		into STRICT	qt_dias_liberado_w
		from 	prescr_material a,
				prescr_medica b
		where	a.nr_prescricao		= b.nr_prescricao
		and     coalesce(ie_ciclo_reprov,'N') = 'N'	
		and		a.ie_suspenso	<> 'S'
		and		((ie_data_antimicrobiano_w = 'M' AND b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> '') or
				 (ie_data_antimicrobiano_w = 'E' AND b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> ''))
		and		a.cd_material in (	SELECT	cd_material_generico_w
									
									
union

									SELECT	cd_material_p
									
									
union

									select	cd_material
									from 	material
									where 	cd_material_generico	= cd_material_generico_w
									
union

									select	cd_material
									from	material
									where	nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w)
		and (((cd_funcao_origem_w = 2314) and (cpoe_obter_se_atb_vigente(b.nr_prescricao, a.nr_sequencia, dt_dia_parametro_w, dt_anterior_w) = 'S'))
						or (cd_funcao_origem_w <> 2314 AND b.dt_inicio_prescr between dt_validade_ini_w and dt_validade_fim_w))
		and		b.cd_pessoa_fisica	= cd_pessoa_fisica_w;
		exception
			when others then
				qt_dias_liberado_w	:= 0;
		end;

	end if;

	if (ie_dias_util_medic_w = 'O') and (qt_dias_liberado_w > 0) then
		qt_dias_liberado_w	:= qt_dias_liberado_w - 1;
	end if;

	/*    O numero de dias de utilizacao ultrapassou o liberado */

	if (ie_controle_medico_w <> 0) and (qt_dias_lib_atend_w > 0) and
		(((ie_dias_util_medic_w = 'O') and (coalesce(qt_dias_util_medic_ww,qt_dias_util_medic_w) = qt_dias_lib_atend_w)) or
		 ((ie_dias_util_medic_w = 'S') and (coalesce(qt_dias_util_medic_ww,qt_dias_util_medic_w) > qt_dias_lib_atend_w) and ((coalesce(qt_dias_util_medic_ww,qt_dias_util_medic_w) - qt_dias_lib_atend_w) < 2))) then
		ie_controle_medico_w		:= 9;
		if (ie_dias_util_medic_w = 'O') then
			qt_dias_liberado_w	:= qt_dias_lib_atend_w - 1;
		end if;
	end if;

	/*    O Medicamento esta liberado */

	if (ie_controle_medico_w <> 9) and (qt_dias_util_medic_w	<= qt_dias_liberado_w) and (qt_dias_liberado_w 	> 0) then
		ie_controle_medico_w		:= 0;
	end if;

	/* Indica se medicamento exige uma avaliacao */

	if (ie_controle_medico_w = 3) then
		ie_controle_medico_w := 3;
	end if;
	
	ie_controle_medico_p		:= ie_controle_medico_w;
	qt_dias_util_medic_p		:= qt_dias_util_medic_w;
	qt_dias_liberado_p			:= qt_dias_liberado_w;
	qt_dias_lib_atend_p			:= qt_dias_lib_atend_w;
end if;

if (ie_rastre_prescr_ua_w = 'S') then
	-- Parametros out
	ds_rastre_prescr_ua_w := substr(ds_rastre_prescr_ua_w || pls_util_pck.enter_w
		|| $$plsql_unit || ':' || $$plsql_line  || pls_util_pck.enter_w
		|| 'qt_dias_util_medic_p:' || qt_dias_util_medic_p || pls_util_pck.enter_w
		|| 'qt_dias_liberado_p:' || qt_dias_liberado_p || pls_util_pck.enter_w
		|| 'ie_controle_medico_p:' || ie_controle_medico_p || pls_util_pck.enter_w
		|| 'qt_dias_lib_atend_p:' || qt_dias_lib_atend_p, 1, 2000);
		
	CALL gerar_log_prescricao(
		nr_prescricao_p		=> nr_prescricao_p,
		nr_seq_item_p		=> null,
		ie_agrupador_p		=> null,
		nr_seq_horario_p	=> null,
		ie_tipo_item_p		=> null,
		ds_log_p			=> ds_rastre_prescr_ua_w,
		nm_usuario_p		=> wheb_usuario_pck.get_nm_usuario,
		nr_seq_objeto_p		=> 706,
		ie_commit_p			=> 'N'
	);
end if;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_util_medic ( nr_prescricao_p bigint, nr_atendimento_p bigint, dt_prescricao_p timestamp, cd_material_p bigint, qt_dias_util_medic_p INOUT bigint, qt_dias_liberado_p INOUT bigint, ie_controle_medico_p INOUT bigint, qt_dias_lib_atend_p INOUT bigint) FROM PUBLIC;

