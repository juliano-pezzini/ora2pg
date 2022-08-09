-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_sincronizar_dieta_oral ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_horarios_dietas_orais_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w			varchar(50);

nr_prescricao_w			bigint;
nr_seq_horario_w		bigint;
ie_status_horario_w		varchar(15);
cd_refeicao_w			varchar(15);
ds_informacoes_w		varchar(255);
ds_observacoes_w		varchar(255);
ds_informacoes_ww		varchar(2000);
ds_comando_update_w		varchar(4000);
ie_lib_pend_rep_w		varchar(1);

c01 CURSOR FOR
SELECT	c.nr_prescricao,
	c.nr_sequencia,
	SUBSTR(plt_obter_status_hor_dieta_lib(c.dt_fim_horario,c.dt_suspensao,c.dt_lib_horario),1,1),
	c.cd_refeicao,
	obter_inf_dieta_adep(c.nr_prescricao,null,'DI') ds_informacoes,
	c.ds_observacao,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	valor_dominio x,
	prescr_dieta d,
	prescr_dieta_hor c,
	prescr_medica a
where	x.vl_dominio = c.cd_refeicao
and	d.nr_prescricao = c.nr_prescricao
and	d.nr_prescricao = a.nr_prescricao
and	c.nr_prescricao = a.nr_prescricao
and	x.cd_dominio = 99
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(a.ie_adep,'S') = 'S'
and	c.dt_horario = dt_horario_p
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	c.nr_prescricao,
	c.nr_sequencia,
	c.dt_fim_horario,
	c.dt_suspensao,
	c.cd_refeicao,
	c.ds_observacao,
	c.dt_lib_horario,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia
order by
	c.dt_suspensao;

c02 CURSOR FOR
SELECT	c.nr_prescricao,
	c.nr_sequencia,
	SUBSTR(plt_obter_status_hor_dieta_lib(c.dt_fim_horario,c.dt_suspensao,c.dt_lib_horario),1,1),
	to_char(d.cd_dieta),
	obter_inf_dieta_adep(c.nr_prescricao,null,'DI') ds_informacoes,
	c.ds_observacao,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	prescr_dieta d,
	prescr_dieta_hor c,
	prescr_medica a
where	d.nr_prescricao = c.nr_prescricao
and	d.nr_prescricao = a.nr_prescricao
and	c.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
and	coalesce(c.ie_situacao,'A') = 'A'
and	coalesce(a.ie_adep,'S') = 'S'
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	c.nr_prescricao,
	c.nr_sequencia,
	c.dt_fim_horario,
	c.dt_suspensao,
	d.cd_dieta,
	c.ds_observacao,
	c.dt_lib_horario,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia
order by
	c.dt_suspensao;


BEGIN
ds_sep_bv_w	:= obter_separador_bv;

if (ie_horarios_dietas_orais_p <> 'N') then
	begin
	open c01;
	loop
	fetch c01 into	nr_prescricao_w,
			nr_seq_horario_w,
			ie_status_horario_w,
			cd_refeicao_w,
			ds_informacoes_w,
			ds_observacoes_w,
			ie_lib_pend_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_informacoes_ww	:= substr(ds_informacoes_w || ' - Obs: ' || ds_observacoes_w,1,2000);

		ds_comando_update_w	:=	' update w_rep_t ' ||
						' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
						' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
						' ds_diluicao = :ds_informacoes ' ||
						' where nm_usuario = :nm_usuario ' ||
						' and ie_tipo_item = :ie_tipo ' ||
						' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
						' and cd_item = :cd_item ';

		CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
									'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
									'ds_informacoes=' || ds_informacoes_ww || ds_sep_bv_w ||
									'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
									'ie_tipo=D' || ds_sep_bv_w ||
									'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
									'cd_item=' || cd_refeicao_w || ds_sep_bv_w );
		end;
	end loop;
	close c01;
	end;
else
	begin
	open c02;
	loop
	fetch c02 into	nr_prescricao_w,
			nr_seq_horario_w,
			ie_status_horario_w,
			cd_refeicao_w,
			ds_informacoes_w,
			ds_observacoes_w,
			ie_lib_pend_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		ds_informacoes_ww	:= substr(ds_informacoes_w || ' - Obs: ' || ds_observacoes_w,1,2000);

		ds_comando_update_w	:=	' update w_rep_t ' ||
						' set nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
						' ds_diluicao = :ds_informacoes ' ||
						' where nm_usuario = :nm_usuario ' ||
						' and ie_tipo_item = :ie_tipo ' ||
						' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
						' and cd_item = :cd_item ';

		CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
									'ds_informacoes=' || ds_informacoes_ww || ds_sep_bv_w ||
									'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
									'ie_tipo=D' || ds_sep_bv_w ||
									'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
									'cd_item=' || cd_refeicao_w || ds_sep_bv_w );
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
-- REVOKE ALL ON PROCEDURE plt_sincronizar_dieta_oral ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_horarios_dietas_orais_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) FROM PUBLIC;
