-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_sincronizar_hemoterap ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) AS $body$
DECLARE


ds_sep_bv_w			varchar(50);
nr_prescricao_w			bigint;
nr_seq_procedimento_w		integer;
nr_seq_horario_w		bigint;
ie_status_horario_w		varchar(15);
cd_procedimento_w		bigint;
ds_procedimento_w		varchar(255);
nr_seq_proc_interno_w		bigint;
ie_acm_sn_w			varchar(1);
cd_intervalo_w			varchar(7);
qt_procedimento_w		double precision;
ds_prescricao_w			varchar(100);
ds_mat_med_assoc_w		varchar(2000);
ie_suspenso_w			varchar(1);
dt_suspensao_w			timestamp;
ds_comando_update_w		varchar(4000);
ie_lib_pend_rep_w		varchar(1);

c01 CURSOR FOR
SELECT	a.nr_prescricao,
	x.nr_sequencia,
	CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	san_derivado z,
	procedimento y,
	prescr_procedimento x,
	prescr_medica a
where	z.nr_sequencia = x.nr_seq_derivado
and	y.cd_procedimento = x.cd_procedimento
and	y.ie_origem_proced = x.ie_origem_proced
and	x.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	coalesce(x.nr_seq_proc_interno::text, '') = ''
and	coalesce(x.nr_seq_exame::text, '') = ''
and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
and	(x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '')
and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
and	x.ie_status in ('P','N')
and	coalesce(a.ie_adep,'S') = 'S'
and	trunc(x.dt_status,'mi') = dt_horario_p
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	a.nr_prescricao,
	x.nr_sequencia,
	CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia

union all

select	a.nr_prescricao,
	x.nr_sequencia,
	CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1)
from	san_derivado z,
	procedimento y,
	proc_interno w,
	prescr_procedimento x,
	prescr_medica a
where	z.nr_sequencia = x.nr_seq_derivado
and	y.cd_procedimento = x.cd_procedimento
and	y.ie_origem_proced = x.ie_origem_proced
and	w.nr_sequencia = x.nr_seq_proc_interno
and	x.nr_prescricao = a.nr_prescricao
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	w.ie_tipo <> 'G'
and	w.ie_tipo <> 'BS'
and	coalesce(w.ie_ivc,'N') <> 'S'
and	coalesce(a.ie_adep,'S') = 'S'
and	coalesce(w.ie_ctrl_glic,'NC') = 'NC'
and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
and	coalesce(x.nr_seq_prot_glic::text, '') = ''
and	coalesce(x.nr_seq_exame::text, '') = ''
and	(x.nr_seq_solic_sangue IS NOT NULL AND x.nr_seq_solic_sangue::text <> '')
and	(x.nr_seq_derivado IS NOT NULL AND x.nr_seq_derivado::text <> '')
and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
and	x.ie_status in ('P','N')
and	trunc(x.dt_status,'mi') = dt_horario_p
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
group by
	a.nr_prescricao,
	x.nr_sequencia,
	CASE WHEN x.ie_status='P' THEN  'W'  ELSE coalesce(x.ie_suspenso,'N') END ,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia;


BEGIN
ds_sep_bv_w := obter_separador_bv;
open c01;
loop
fetch c01 into	nr_prescricao_w,
		nr_seq_procedimento_w,
		ie_status_horario_w,
		ie_lib_pend_rep_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_comando_update_w	:=	' update w_rep_t ' ||
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' ||
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao) ' ||
					' where nm_usuario = :nm_usuario ' ||
					' and ie_tipo_item = :ie_tipo ' ||
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
					' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ';

	CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
								'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w ||
								'ie_tipo=HM' || ds_sep_bv_w ||
								'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||
								'nr_seq_item=' || to_char(nr_seq_procedimento_w) || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_sincronizar_hemoterap ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) FROM PUBLIC;

