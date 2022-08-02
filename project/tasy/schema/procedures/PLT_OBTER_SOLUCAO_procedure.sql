-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_obter_solucao ( cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint) AS $body$
DECLARE


nr_seq_wadep_w			bigint;
nr_prescricao_w			bigint;
nr_seq_solucao_w		integer;
ds_solucao_w			varchar(255);
ie_acm_sn_w			varchar(1);
ds_prescricao_w			varchar(240);
ds_componentes_w		varchar(240);
ie_status_solucao_w		varchar(15);
ie_suspensa_w			varchar(1);
dt_prev_prox_etapa_w		timestamp;
ie_lib_pend_rep_w		varchar(1);
ie_liberado_w			varchar(1);
cd_unid_med_qtde_w		varchar(30);
ie_via_administracao_w		varchar(5);
qt_solucao_total_w		double precision;
ds_intervalo_w			varchar(240);
ie_proximo_plano_w		varchar(1);
ie_erro_w			integer;
ie_copiar_w			varchar(1);
ds_cor_titulo_w		varchar(20);

c01 CURSOR FOR
SELECT	nr_prescricao,
	nr_seq_solucao,
	ds_solucao,
	ie_acm_sn,
	ds_prescricao,
	ds_componentes,
	ie_status_solucao,
	null,
	dt_prev_prox_etapa,
	ie_tipo_dosagem,
	ie_via_aplicacao,
	qt_solucao_total,
	ds_intervalo,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_solucao, 'S')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END ,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro
from	(
	SELECT	a.nr_prescricao,
		x.nr_seq_solucao,
		substr(coalesce(x.ds_solucao,obter_prim_comp_sol(a.nr_prescricao,x.nr_seq_solucao)),1,240) ds_solucao,
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
		substr(obter_desc_vol_etapa_adep2(a.nr_prescricao,x.nr_seq_solucao,x.ie_acm,x.ie_se_necessario),1,240) ds_prescricao,
		substr(obter_componentes_solucao(a.nr_prescricao,x.nr_seq_solucao,'S',nm_usuario_p,cd_estabelecimento_p),1,240) ds_componentes,
		CASE WHEN x.ie_status='P' THEN  'W'  ELSE substr(obter_status_solucao_prescr(1,a.nr_prescricao,x.nr_seq_solucao),1,3) END  ie_status_solucao,
		coalesce(x.ie_suspenso,'N') ie_suspenso,
		x.dt_prev_prox_etapa,
		x.ie_tipo_dosagem,
		x.ie_via_aplicacao,
		x.qt_solucao_total,
		substr(obter_interv_solucao_vipe(x.ie_acm,x.ie_se_necessario,x.ie_urgencia,x.nr_etapas,x.qt_hora_fase),1,240) ds_intervalo,
		substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
		CASE WHEN coalesce(coalesce(a.dt_liberacao,a.dt_liberacao_medico),a.dt_liberacao_farmacia) IS NULL THEN 'N'  ELSE 'S' END  ie_liberado,
		x.ie_erro
	from	prescr_solucao x,
		prescr_medica a
	where	x.nr_prescricao = a.nr_prescricao
	and	a.nr_atendimento = nr_atendimento_p
	and	coalesce(x.nr_seq_dialise::text, '') = ''
	and	coalesce(x.ie_hemodialise, 'N') = 'N'
	and	coalesce(a.ie_adep,'S') = 'S'
	and	((x.ie_status in ('I','INT')) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (x.dt_status between dt_inicial_horarios_p and dt_final_horarios_p)) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
	and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
	and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
	group by
		a.nr_prescricao,
		x.nr_seq_solucao,
		x.ds_solucao,
		x.ie_acm,
		x.ie_se_necessario,
		nm_usuario_p,
		cd_estabelecimento_p,
		x.ie_suspenso,
		x.dt_prev_prox_etapa,
		x.ie_tipo_dosagem,
		x.ie_via_aplicacao,
		x.qt_solucao_total,
		x.ie_urgencia,
		x.nr_etapas,
		x.qt_hora_fase,
		x.ie_status,
		a.dt_liberacao_medico,
		a.dt_liberacao,
		a.dt_liberacao_farmacia,
		x.ie_erro
	) alias37
group by
	nr_prescricao,
	nr_seq_solucao,
	ds_solucao,
	ie_acm_sn,
	ds_prescricao,
	ds_componentes,
	ie_status_solucao,
	null,
	dt_prev_prox_etapa,
	ie_tipo_dosagem,
	ie_via_aplicacao,
	qt_solucao_total,
	ds_intervalo,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_solucao, 'S')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END ,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro;


BEGIN

ie_copiar_w 	:= plt_obter_se_item_marcado('SOL', nr_seq_regra_p);
ds_cor_titulo_w	:= plt_obter_se_item_marcado('SQL', nr_seq_regra_p);

open c01;
loop
fetch c01 into	nr_prescricao_w,
		nr_seq_solucao_w,
		ds_solucao_w,
		ie_acm_sn_w,
		ds_prescricao_w,
		ds_componentes_w,
		ie_status_solucao_w,
		ie_suspensa_w,
		dt_prev_prox_etapa_w,
		cd_unid_med_qtde_w,
		ie_via_administracao_w,
		qt_solucao_total_w,
		ds_intervalo_w,
		ie_proximo_plano_w,
		ie_lib_pend_rep_w,
		ie_liberado_w,
		ie_erro_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	nextval('w_rep_t_seq')
	into STRICT	nr_seq_wadep_w
	;

	insert into w_rep_t(
		nr_sequencia,
		nm_usuario,
		ie_tipo_item,
		nr_prescricao,
		nr_seq_item,
		ds_item,
		ie_acm_sn,
		ds_prescricao,
		ds_diluicao,
		ie_status_item,
		ie_suspenso,
		dt_prev_term,
		nr_seq_proc_interno,
		nr_agrupamento,
		ie_diferenciado,
		nr_prescricoes,
		cd_item,
		cd_unid_med_qtde,
		ie_via_aplicacao,
		qt_item,
		ds_interv_prescr,
		ie_proximo_plano,
		ie_pendente_liberacao,
		ie_liberado,
		ie_erro,
		ie_copiar,
		ds_cor_titulo)
	values (
		nr_seq_wadep_w,
		nm_usuario_p,
		'SOL',
		nr_prescricao_w,
		nr_seq_solucao_w,
		ds_solucao_w,
		ie_acm_sn_w,
		ds_prescricao_w,
		ds_componentes_w,
		ie_status_solucao_w,
		ie_suspensa_w,
		dt_prev_prox_etapa_w,
		0,
		0,
		'N',
		nr_prescricao_w,
		0,
		cd_unid_med_qtde_w,
		ie_via_administracao_w,
		qt_solucao_total_w,
		ds_intervalo_w,
		ie_proximo_plano_w,
		ie_lib_pend_rep_w,
		ie_liberado_w,
		ie_erro_w,
		ie_copiar_w,
		ds_cor_titulo_w);
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_obter_solucao ( cd_estabelecimento_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, ie_prescr_usuario_p text, nr_seq_regra_p bigint) FROM PUBLIC;

