-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_sincronizar_rec ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w			varchar(50);
nr_prescricao_w			bigint;
nr_seq_recomendacao_w		integer;
nr_seq_horario_w		bigint;
ie_status_horario_w		varchar(1);
cd_recomendacao_w		varchar(255);
ds_recomendacao_w		varchar(4000);
ie_acm_sn_w			varchar(1);
cd_intervalo_w			varchar(7);
qt_recomendacao_w		double precision;
ds_intervalo_w			varchar(100);
ds_comando_update_w		varchar(4000);
ie_lib_pend_rep_w		varchar(1);

c01 CURSOR FOR
SELECT	a.nr_prescricao,
	c.nr_seq_recomendacao,
	c.nr_sequencia,
	SUBSTR(plt_obter_status_hor_rec_lib(c.dt_fim_horario,c.dt_suspensao,c.dt_lib_horario),1,1),
	coalesce(to_char(x.cd_recomendacao),x.ds_recomendacao) cd_recomendacao,
	coalesce(y.ds_tipo_recomendacao,x.ds_recomendacao) ds_recomendacao,
	obter_se_acm_sn_rec(x.ds_horarios, x.ie_se_necessario) ie_acm_sn,
	x.cd_intervalo,
	x.qt_recomendacao,
	w.ds_prescricao ds_prescricao,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
FROM prescr_rec_hor c, prescr_medica a, prescr_recomendacao x
LEFT OUTER JOIN intervalo_prescricao w ON (x.cd_intervalo = w.cd_intervalo)
LEFT OUTER JOIN tipo_recomendacao y ON (x.cd_recomendacao = y.cd_tipo_recomendacao)
WHERE x.nr_prescricao = c.nr_prescricao and x.nr_sequencia = c.nr_seq_recomendacao and x.nr_prescricao = a.nr_prescricao and c.nr_prescricao = a.nr_prescricao and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and coalesce(c.ie_situacao,'A') = 'A' and coalesce(a.ie_adep,'S') = 'S' and ((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) and c.dt_horario = dt_horario_p and ((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p)) group by
	a.nr_prescricao,
	c.nr_seq_recomendacao,
	c.nr_sequencia,
	c.dt_fim_horario,
	c.dt_suspensao,
	coalesce(to_char(x.cd_recomendacao),x.ds_recomendacao),
	coalesce(y.ds_tipo_recomendacao,x.ds_recomendacao),
	obter_se_acm_sn_rec(x.ds_horarios, x.ie_se_necessario),
	x.cd_intervalo,
	x.qt_recomendacao,
	w.ds_prescricao,
	c.dt_lib_horario,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia
order by
	c.dt_suspensao;


BEGIN
ds_sep_bv_w := obter_separador_bv;

open c01;
loop
fetch c01 into	nr_prescricao_w,
		nr_seq_recomendacao_w,
		nr_seq_horario_w,
		ie_status_horario_w,
		cd_recomendacao_w,
		ds_recomendacao_w,
		ie_acm_sn_w,
		cd_intervalo_w,
		qt_recomendacao_w,
		ds_intervalo_w,
		ie_lib_pend_rep_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_comando_update_w	:=	' update w_rep_t ' ||
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
					' where nm_usuario = :nm_usuario ' ||
					' and ie_tipo_item = :ie_tipo ' ||
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||
					' and cd_item = :cd_item ' ||
					' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
					' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
					' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
					' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';

	CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
								'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
								'ie_tipo=R' || ds_sep_bv_w ||
								'nr_seq_item='|| to_char(nr_seq_recomendacao_w) || ds_sep_bv_w ||
								'cd_item=' || to_char(cd_recomendacao_w) || ds_sep_bv_w ||
								'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
								'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
								'qt_item=' || to_char(qt_recomendacao_w) || ds_sep_bv_w ||
								'ds_prescricao=' || ds_intervalo_w || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_sincronizar_rec ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) FROM PUBLIC;

