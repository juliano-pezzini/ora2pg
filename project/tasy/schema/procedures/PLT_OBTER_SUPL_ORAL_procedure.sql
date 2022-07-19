-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_obter_supl_oral ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint) AS $body$
DECLARE


nr_seq_wadep_w			bigint;
nr_prescricao_w			bigint;
nr_seq_material_w		integer;
cd_material_w			integer;
ds_material_w			varchar(255);
ie_acm_sn_w			varchar(1);
cd_intervalo_w			varchar(7);
qt_dose_w			double precision;
ds_prescricao_w			varchar(100);
ie_status_w			varchar(1);
ie_lib_pend_rep_w		varchar(1);
ie_liberado_w			varchar(1);
cd_unid_med_qtde_w		varchar(30);
ie_via_administracao_w		varchar(5);
ds_interv_prescr_w		varchar(15);
ie_erro_w			integer;
ie_copiar_w			varchar(1);
ds_cor_titulo_w		varchar(20);

c01 CURSOR FOR
SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,
	cd_material,
	ds_material,
	ie_acm_sn,
	cd_intervalo,
	qt_dose,
	ds_prescricao,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  ie_status,
	cd_unidade_medida_dose,
	ie_via_aplicacao,
	ds_intervalo,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro
from	(
	SELECT	a.nr_prescricao,
		c.nr_seq_material,
		c.cd_material,
		y.ds_material,
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
		x.cd_intervalo,
		x.qt_dose,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
		coalesce(x.ie_suspenso,'N') ie_suspenso,
		x.cd_unidade_medida_dose,
		x.ie_via_aplicacao,
		substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo,
		substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
		CASE WHEN coalesce(coalesce(a.dt_liberacao,a.dt_liberacao_medico),a.dt_liberacao_farmacia) IS NULL THEN 'N'  ELSE 'S' END  ie_liberado,
		x.ie_erro
	from	material y,
		prescr_material x,
		prescr_mat_hor c,
		prescr_medica a
	where	y.cd_material = x.cd_material
	and	y.cd_material = c.cd_material
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_material
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	a.nr_atendimento = nr_atendimento_p
	and	coalesce(a.ie_adep,'S') = 'S'
	and	a.dt_validade_prescr > dt_validade_limite_p
	and	x.ie_agrupador = 12
	and	(((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'N') and (c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p)) or
		 ((obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) = 'S') and (obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S')))
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	c.ie_agrupador = 12
	and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
	group by
		a.nr_prescricao,
		c.nr_seq_material,
		c.cd_material,
		y.ds_material,
		x.ie_acm,
		x.ie_se_necessario,
		x.cd_intervalo,
		x.qt_dose,
		x.ie_suspenso,
		x.cd_unidade_medida_dose,
		x.ie_via_aplicacao,
		a.dt_liberacao_medico,
		a.dt_liberacao,
		a.dt_liberacao_farmacia,
		x.ie_erro
	) alias28
group by
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,
	cd_material,
	ds_material,
	ie_acm_sn,
	cd_intervalo,
	qt_dose,
	ds_prescricao,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END ,
	cd_unidade_medida_dose,
	ie_via_aplicacao,
	ds_intervalo,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro;


BEGIN

ie_copiar_w 	:= plt_obter_se_item_marcado('S', nr_seq_regra_p);
ds_cor_titulo_w	:= plt_obter_se_item_marcado('S', nr_seq_regra_p);

open c01;
loop
fetch c01 into	nr_prescricao_w,
		nr_seq_material_w,
		cd_material_w,
		ds_material_w,
		ie_acm_sn_w,
		cd_intervalo_w,
		qt_dose_w,
		ds_prescricao_w,
		ie_status_w,
		cd_unid_med_qtde_w,
		ie_via_administracao_w,
		ds_interv_prescr_w,
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
		cd_item,
		ds_item,
		ie_acm_sn,
		cd_intervalo,
		qt_item,
		ds_prescricao,
		ie_status_item,
		ie_diferenciado,
		nr_seq_proc_interno,
		nr_agrupamento,
		cd_unid_med_qtde,
		ie_via_aplicacao,
		ds_interv_prescr,
		ie_pendente_liberacao,
		ie_liberado,
		ie_erro,
		ie_copiar,
		ds_cor_titulo)
	values (
		nr_seq_wadep_w,
		nm_usuario_p,
		'S',
		nr_prescricao_w,
		nr_seq_material_w,
		cd_material_w,
		ds_material_w,
		ie_acm_sn_w,
		cd_intervalo_w,
		qt_dose_w,
		ds_prescricao_w,
		ie_status_w,
		'N',
		0,
		0,
		cd_unid_med_qtde_w,
		ie_via_administracao_w,
		ds_interv_prescr_w,
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
-- REVOKE ALL ON PROCEDURE plt_obter_supl_oral ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint) FROM PUBLIC;

