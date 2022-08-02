-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_sincronizar_solucao ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_formato_solucoes_p text, ie_prescr_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w			varchar(50);
nr_prescricao_w			bigint;
nr_seq_solucao_w		integer;
nr_seq_horario_w		bigint;
ie_status_horario_w		varchar(15);
ds_comando_update_w		varchar(4000);
dt_etapa_prev_w			timestamp;
ie_lib_pend_rep_w		varchar(1);

c01 CURSOR FOR
SELECT	a.nr_prescricao,
	x.nr_seq_solucao,
	CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_hor_sol_processo(a.nr_prescricao,x.nr_seq_solucao,1),1,15) END ,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	prescr_solucao x,
	prescr_medica a
where	x.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	coalesce(x.nr_seq_dialise::text, '') = ''
and	x.ie_status in ('P','N')
and	x.dt_status = dt_horario_p
and	coalesce(a.ie_adep,'S') = 'S'
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	a.nr_prescricao,
	x.nr_seq_solucao,
	x.ie_status,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia;

c02 CURSOR FOR
SELECT	a.nr_prescricao,
	x.nr_seq_solucao,
	SUBSTR(plt_obter_status_hor_sol_lib(c.dt_inicio_horario,c.dt_fim_horario,c.dt_suspensao,c.dt_interrupcao, c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,c.dt_lib_horario),1,15),
	c.dt_prev_fim_horario,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	prescr_solucao x,
	prescr_mat_hor c,
	prescr_medica a
where	x.nr_prescricao = c.nr_prescricao
and	x.nr_seq_solucao = c.nr_seq_solucao
and	x.nr_prescricao = a.nr_prescricao
and	c.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
--and	a.dt_validade_prescr > dt_validade_limite_p
and	coalesce(x.nr_seq_dialise::text, '') = ''
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(a.ie_adep,'S') = 'S'
and	c.ie_agrupador = 4
--and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
and	adep_obter_se_gerar_sol_hor(c.dt_horario, c.dt_inicio_horario, c.dt_fim_horario, c.dt_suspensao, dt_inicial_horarios_p, dt_final_horarios_p) = 'S'
--and	((nvl(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario is not null))
and	c.dt_horario = dt_horario_p
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	a.nr_prescricao,
	x.nr_seq_solucao,
	c.dt_inicio_horario,
	c.dt_interrupcao,
	c.dt_fim_horario,
	c.dt_suspensao,
	c.ie_dose_especial,
	c.nr_seq_processo,
	c.nr_seq_area_prep,
	c.dt_lib_horario,
	c.dt_prev_fim_horario,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia;


BEGIN
ds_sep_bv_w	:= obter_separador_bv;

if (ie_formato_solucoes_p = 'I') then
	begin
	open c01;
	loop
	fetch c01 into	nr_prescricao_w,
			nr_seq_solucao_w,
			ie_status_horario_w,
			ie_lib_pend_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_comando_update_w	:=	' update w_rep_t ' ||
						' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
						' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
						' where nm_usuario = :nm_usuario ' ||
						' and ie_tipo_item = :ie_tipo ' ||
						' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
						' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
						' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

		CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
									'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
									'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
									'ie_tipo=SOL' || ds_sep_bv_w ||
									'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
									'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w );
		end;
	end loop;
	close c01;
	end;
elsif (ie_formato_solucoes_p = 'H') then
	begin
	open c02;
	loop
	fetch c02 into	nr_prescricao_w,
			nr_seq_solucao_w,
			ie_status_horario_w,
			dt_etapa_prev_w,
			ie_lib_pend_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		if (coalesce(dt_etapa_prev_w::text, '') = '') then
			ds_comando_update_w	:=	' update w_rep_t ' ||
							' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' dt_prev_term =  null ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

			CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
										'ie_tipo=SOL' || ds_sep_bv_w ||
										'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w );
		else
			ds_comando_update_w	:=	' update w_rep_t ' ||
							' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' dt_prev_term =  :dt_prev_term ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

			CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
										'dt_prev_term=' || to_char(dt_etapa_prev_w, 'dd/mm/yyyy hh24:mi:ss') || ds_sep_bv_w ||
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
										'ie_tipo=SOL' || ds_sep_bv_w ||
										'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
										'nr_seq_item=' || to_char(nr_seq_solucao_w) || ds_sep_bv_w );
		end if;

		end;
	end loop;
	close c02;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_sincronizar_solucao ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_formato_solucoes_p text, ie_prescr_usuario_p text) FROM PUBLIC;

