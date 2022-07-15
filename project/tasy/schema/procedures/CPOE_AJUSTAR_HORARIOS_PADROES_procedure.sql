-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_ajustar_horarios_padroes ( nr_atendimento_p bigint, cd_material_p bigint, nr_seq_proc_p bigint, cd_intervalo_p text, ds_horarios_p text, nm_usuario_p text, nr_seq_solucao_p bigint, nr_prescricao_p bigint, nr_seq_item_cpoe_p bigint default null) AS $body$
DECLARE

											
ds_horarios_w 				cpoe_material.ds_horarios%type;
hr_prim_horario_w 			cpoe_material.hr_prim_horario%type;
dt_prox_geracao_w			cpoe_material.dt_prox_geracao%type;
nr_prescricao_w				prescr_medica.nr_prescricao%type;
dt_horario_w				prescr_mat_hor.dt_horario%type;
qt_horas_ant_copia_cpoe_w	double precision;
nr_seq_mat_cpoe_w			cpoe_material.nr_sequencia%type;
cd_material_w				cpoe_material.cd_material%type;
qt_horas_interv_w 			double precision;
dt_prox_geracao_ww			cpoe_material.dt_prox_geracao%type := null;
qt_operacao_w				intervalo_prescricao.qt_operacao%type;


BEGIN
qt_horas_ant_copia_cpoe_w := get_qt_hours_after_copy_cpoe( obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo);

select	coalesce(Obter_ocorrencia_intervalo(max(cd_intervalo),24,'H'), 0),
		coalesce(max(qt_operacao),0)
into STRICT	qt_horas_interv_w,
		qt_operacao_w
from	intervalo_prescricao
where	cd_intervalo = cd_intervalo_p
and		coalesce(ie_operacao,'X') = 'H'
and		coalesce(ie_24_h, 'N') = 'S'
and		coalesce(qt_operacao,1) > 24;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND cd_material_p IS NOT NULL AND cd_material_p::text <> '') then


	if (nr_seq_item_cpoe_p IS NOT NULL AND nr_seq_item_cpoe_p::text <> '') and (qt_operacao_w > 24) then
	
		select 	max(dt_prox_geracao)
		into STRICT	dt_prox_geracao_ww
		from 	cpoe_material
		where 	nr_sequencia = nr_seq_item_cpoe_p;
	end if;

	if (coalesce(ds_horarios_p::text, '') = '') then
		select	max(a.ds_horarios_medico)
		into STRICT	ds_horarios_w
		from	prescr_material a
		where	a.cd_material = cd_material_p
		and     coalesce(a.ie_suspenso, 'N') = 'N'
		and		((a.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
		and		a.nr_prescricao = (	SELECT		min(b.nr_prescricao)
									from		prescr_material	b,
												prescr_medica c
									where		b.nr_prescricao = c.nr_prescricao
									and			c.nr_atendimento = nr_atendimento_p
									and			b.cd_material = cd_material_p
									and			((b.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0')));
	end if;
	
	select	max(b.dt_horario)
	into STRICT	dt_horario_w
	from	prescr_material a,
			prescr_mat_hor b
	where	a.nr_prescricao = b.nr_prescricao
	and     coalesce(a.ie_suspenso, 'N') = 'N'
	and		a.nr_sequencia = b.nr_seq_material
	and		a.cd_material = cd_material_p
	and		((a.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
	and		a.nr_prescricao = (	SELECT		max(b.nr_prescricao)
								from		prescr_material	b,
											prescr_medica c
								where		b.nr_prescricao = c.nr_prescricao
								and			c.nr_atendimento = nr_atendimento_p
								and			b.cd_material = cd_material_p
								and			((b.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0')));
	
	ds_horarios_w		:= cpoe_padroniza_horario(trim(both coalesce(ds_horarios_w,ds_horarios_p)));
	hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	dt_prox_geracao_w	:= trunc(to_date(to_char(dt_horario_w,'dd/mm/yyyy')||hr_prim_horario_w,'dd/mm/yyyy hh24:mi'),'hh24');
	
	CALL gravar_log_tasy(10007,
					substr('CPOE_AJUSTAR_HORARIOS_PADROES_69: '
										||'//nr_atendimento_p:'||nr_atendimento_p||'cd_material_p:'||cd_material_p
									    ||'nr_seq_proc_p:'||nr_seq_proc_p||'cd_intervalo_p'||cd_intervalo_p
									    ||'ds_horarios_p:'||ds_horarios_p||'nm_usuario_p : '||nm_usuario_p||'nr_seq_solucao_p:'||nr_seq_solucao_p
									    ||'nr_prescricao_p:'||nr_prescricao_p||'qt_horas_interv_w:'||qt_horas_interv_w||'ds_horarios_w:'||ds_horarios_w
                      ||'dt_horario_w:'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'hr_prim_horario_w:'||hr_prim_horario_w
                      ||'dt_prox_geracao_w'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prox_geracao_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'qt_horas_ant_copia_cpoe_w:'||qt_horas_ant_copia_cpoe_w
                      ,1,2000),nm_usuario_p);
	
	if (dt_horario_w >= coalesce(dt_prox_geracao_ww,dt_prox_geracao_w)) then
		dt_prox_geracao_w := dt_prox_geracao_w + 1;		
	end if;

	CALL gravar_log_tasy(10007,
				substr('CPOE_AJUSTAR_HORARIOS_PADROES_83: '
									||'//nr_atendimento_p:'||nr_atendimento_p||'cd_material_p:'||cd_material_p
									||'nr_seq_proc_p:'||nr_seq_proc_p||'cd_intervalo_p'||cd_intervalo_p
									||'ds_horarios_p:'||ds_horarios_p||'nm_usuario_p : '||nm_usuario_p||'nr_seq_solucao_p:'||nr_seq_solucao_p
									||'nr_prescricao_p:'||nr_prescricao_p||'qt_horas_interv_w:'||qt_horas_interv_w||'ds_horarios_w:'||ds_horarios_w
									||'dt_horario_w:'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'hr_prim_horario_w:'||hr_prim_horario_w
									||'dt_prox_geracao_w'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prox_geracao_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'qt_horas_ant_copia_cpoe_w:'||qt_horas_ant_copia_cpoe_w
									,1,2000),nm_usuario_p);
	
	
	dt_prox_geracao_w := (dt_prox_geracao_w + qt_horas_interv_w/24) - (qt_horas_ant_copia_cpoe_w/24);
	
	CALL gravar_log_tasy(10007,
				substr('CPOE_AJUSTAR_HORARIOS_PADROES_96: '
									||'//nr_atendimento_p:'||nr_atendimento_p||'cd_material_p:'||cd_material_p
									||'nr_seq_proc_p:'||nr_seq_proc_p||'cd_intervalo_p'||cd_intervalo_p
									||'ds_horarios_p:'||ds_horarios_p||'nm_usuario_p : '||nm_usuario_p||'nr_seq_solucao_p:'||nr_seq_solucao_p
									||'nr_prescricao_p:'||nr_prescricao_p||'qt_horas_interv_w:'||qt_horas_interv_w||'ds_horarios_w:'||ds_horarios_w
									||'dt_horario_w:'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_horario_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'hr_prim_horario_w:'||hr_prim_horario_w
									||'dt_prox_geracao_w'||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_prox_geracao_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||'qt_horas_ant_copia_cpoe_w:'||qt_horas_ant_copia_cpoe_w
									,1,2000),nm_usuario_p);

	update	cpoe_material
	set		ds_horarios = ds_horarios_w,
			hr_prim_horario = hr_prim_horario_w,
			dt_prox_geracao = dt_prox_geracao_w,
			nm_usuario = nm_usuario_p
	where	nr_atendimento = nr_atendimento_p
	and		cd_material = cd_material_p
	and		((cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
	and		((coalesce(nr_seq_item_cpoe_p::text, '') = '') or (nr_sequencia = nr_seq_item_cpoe_p))
	and		coalesce(dt_lib_suspensao::text, '') = ''
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');
		
elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '' AND nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
		
	if (coalesce(ds_horarios_p::text, '') = '') then
		select	max(a.ds_horarios)
		into STRICT	ds_horarios_w
		from	prescr_procedimento a
		where	a.nr_seq_proc_interno = nr_seq_proc_p
		and     coalesce(a.ie_suspenso, 'N') = 'N'
		and		((a.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
		and		a.nr_prescricao = (	SELECT		min(b.nr_prescricao)
									from		prescr_procedimento	b,
												prescr_medica c
									where		b.nr_prescricao = c.nr_prescricao
									and			c.nr_atendimento = nr_atendimento_p
									and			b.nr_seq_proc_interno = nr_seq_proc_p
									and			((b.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0')));
	end if;
	
	select	max(b.dt_horario)
	into STRICT	dt_horario_w
	from	prescr_procedimento a,
			prescr_proc_hor b
	where	a.nr_prescricao = b.nr_prescricao
	and 	a.nr_sequencia = b.nr_seq_procedimento
	and		a.nr_seq_proc_interno = nr_seq_proc_p
	and     coalesce(a.ie_suspenso, 'N') = 'N'
	and		((a.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
	and		a.nr_prescricao = (	SELECT		max(b.nr_prescricao)
								from		prescr_procedimento	b,
											prescr_medica c
								where		b.nr_prescricao = c.nr_prescricao
								and			c.nr_atendimento = nr_atendimento_p
								and			b.nr_seq_proc_interno = nr_seq_proc_p
								and			((b.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0')));
	
	ds_horarios_w		:= coalesce(ds_horarios_w,ds_horarios_p);
	hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	dt_prox_geracao_w	:= trunc(to_date(to_char(dt_horario_w,'dd/mm/yyyy')||hr_prim_horario_w,'dd/mm/yyyy hh24:mi'),'hh24');
	
	if (dt_horario_w >= dt_prox_geracao_w)  then
		dt_prox_geracao_w := dt_prox_geracao_w + 1;
	end if;
	
	dt_prox_geracao_w:= (dt_prox_geracao_w + qt_horas_interv_w/24) - (qt_horas_ant_copia_cpoe_w/24);
	
	update	cpoe_procedimento
	set		ds_horarios = ds_horarios_w,
			hr_prim_horario = hr_prim_horario_w,
			dt_prox_geracao = dt_prox_geracao_w,
			nm_usuario = nm_usuario_p
	where	nr_atendimento = nr_atendimento_p
	and		nr_seq_proc_interno = nr_seq_proc_p
	and		((cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
	and		coalesce(dt_lib_suspensao::text, '') = ''
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

elsif ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')) then

	select	max(nr_seq_mat_cpoe),
			max(cd_material)
	into STRICT	nr_seq_mat_cpoe_w,
			cd_material_w
	from	prescr_solucao a,
			prescr_material b
	where	a.nr_prescricao = nr_prescricao_p
	and		a.nr_seq_solucao  = nr_seq_solucao_p
	and		a.nr_prescricao = b.nr_prescricao
	and		a.nr_seq_solucao = b.nr_sequencia_solucao
	and		b.ie_agrupador = 4
	and		(b.nr_seq_mat_cpoe IS NOT NULL AND b.nr_seq_mat_cpoe::text <> '');
		
	if (coalesce(ds_horarios_p::text, '') = '') then
		
		select	cpoe_retirar_das_as(max(ds_horarios_medico))
		into STRICT	ds_horarios_w
		from	prescr_solucao a
		where	a.nr_prescricao =	(SELECT	min(nr_prescricao)
									from	prescr_material
									where	nr_seq_mat_cpoe = 	nr_seq_mat_cpoe_w);
		
	end if;

	select	max(b.dt_horario)
	into STRICT	dt_horario_w
	from	prescr_material a,
			prescr_mat_hor b,
			prescr_solucao c
	where	a.cd_material = cd_material_w
	and		((c.cd_intervalo = cd_intervalo_p) or (coalesce(cd_intervalo_p,'0') = '0'))
	and		a.nr_prescricao = 	(	SELECT	max(nr_prescricao)
									from	prescr_material x
									where	x.nr_seq_mat_cpoe = nr_seq_mat_cpoe_w
									and		(x.nr_seq_mat_cpoe IS NOT NULL AND x.nr_seq_mat_cpoe::text <> '')
									and		x.ie_agrupador = 4)
	and		a.nr_prescricao = b.nr_prescricao
	and		a.nr_sequencia = b.nr_seq_material
	AND		a.nr_prescricao = c.nr_prescricao
	AND		a.nr_sequencia_solucao = c.nr_seq_solucao
	and		a.ie_agrupador = 4
	and		(a.nr_seq_mat_cpoe IS NOT NULL AND a.nr_seq_mat_cpoe::text <> '');
	
	ds_horarios_w		:= coalesce(ds_horarios_w,ds_horarios_p);
	hr_prim_horario_w	:= obter_prim_dshorarios(ds_horarios_w);
	dt_prox_geracao_w	:= trunc(to_date(to_char(dt_horario_w,'dd/mm/yyyy')||hr_prim_horario_w,'dd/mm/yyyy hh24:mi'),'hh24');
	
	if (dt_horario_w >= dt_prox_geracao_w)  then
		dt_prox_geracao_w := dt_prox_geracao_w + 1;
	end if;
	
	dt_prox_geracao_w:= (dt_prox_geracao_w + qt_horas_interv_w/24) - (qt_horas_ant_copia_cpoe_w/24);
	
	update	cpoe_material
	set		ds_horarios = replace(ds_horarios_w, '  ', ' '),
			hr_prim_horario = hr_prim_horario_w,
			dt_prox_geracao = dt_prox_geracao_w,
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_mat_cpoe_w;
	
	commit;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_ajustar_horarios_padroes ( nr_atendimento_p bigint, cd_material_p bigint, nr_seq_proc_p bigint, cd_intervalo_p text, ds_horarios_p text, nm_usuario_p text, nr_seq_solucao_p bigint, nr_prescricao_p bigint, nr_seq_item_cpoe_p bigint default null) FROM PUBLIC;

