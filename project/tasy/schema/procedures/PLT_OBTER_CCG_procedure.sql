-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_obter_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint) AS $body$
DECLARE


nr_seq_wadep_w			bigint;
nr_prescricao_w			bigint;
nr_seq_procedimento_w		integer;
cd_procedimento_w		bigint;
ds_procedimento_w		varchar(255);
ie_acm_sn_w			varchar(1);
cd_intervalo_w			varchar(7);
qt_procedimento_w		double precision;
ds_prescricao_w			varchar(100);
ie_status_w			varchar(1);
nr_seq_proc_interno_w		bigint;
ie_classif_adep_w		varchar(15);
ie_lib_pend_rep_w		varchar(1);
ie_liberado_w			varchar(1);
nr_seq_prot_glic_w		bigint;
ds_interv_prescr_w		varchar(15);
ie_origem_proced_w		bigint;
ie_erro_w			integer;
ie_copiar_w			varchar(1);
ds_cor_titulo_w			varchar(20);

c01 CURSOR FOR
SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_procedimento  ELSE null END   ELSE null END ,
	cd_procedimento,
	ds_procedimento,
	ie_acm_sn,
	cd_intervalo,
	qt_procedimento,
	ds_prescricao,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  ie_status,
	nr_seq_proc_interno,
	nr_seq_prot_glic,
	ds_intervalo,
	ie_origem_proced,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro
from	(
	SELECT	a.nr_prescricao,
		c.nr_seq_procedimento,
		c.cd_procedimento,
		z.ds_protocolo ds_procedimento,
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,
		x.cd_intervalo,
		x.qt_procedimento,
		substr(adep_obter_dados_prescr_proc(a.nr_prescricao,c.nr_seq_procedimento,'QIL','S',x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
		coalesce(x.ie_suspenso,'N') ie_suspenso,
		c.nr_seq_proc_interno,
		x.nr_seq_prot_glic,
		substr(obter_desc_intervalo_prescr(x.cd_intervalo),1,15) ds_intervalo,
		x.ie_origem_proced,
		substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
		CASE WHEN coalesce(coalesce(a.dt_liberacao,a.dt_liberacao_medico),a.dt_liberacao_farmacia) IS NULL THEN 'N'  ELSE 'S' END  ie_liberado,
		x.ie_erro
	from	pep_protocolo_glicemia z,
		procedimento y,
		proc_interno w,
		prescr_procedimento x,
		prescr_proc_hor c,
		prescr_medica a
	where	z.nr_sequencia = x.nr_seq_prot_glic
	and	y.cd_procedimento = x.cd_procedimento
	and	y.ie_origem_proced = x.ie_origem_proced
	and	y.cd_procedimento = c.cd_procedimento
	and	y.ie_origem_proced = c.ie_origem_proced
	and	w.nr_sequencia = x.nr_seq_proc_interno
	and	w.nr_sequencia = c.nr_seq_proc_interno
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_procedimento
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao
	and	a.nr_atendimento = nr_atendimento_p
	and	a.dt_validade_prescr > dt_validade_limite_p
	and	w.ie_tipo <> 'G'
	and	w.ie_tipo <> 'BS'
	and	coalesce(w.ie_ivc,'N') <> 'S'
	and	w.ie_ctrl_glic = 'CCG'
	and	(x.nr_seq_proc_interno IS NOT NULL AND x.nr_seq_proc_interno::text <> '')
	and	(x.nr_seq_prot_glic IS NOT NULL AND x.nr_seq_prot_glic::text <> '')
	and	coalesce(x.nr_seq_exame::text, '') = ''
	and	coalesce(x.nr_seq_solic_sangue::text, '') = ''
	and	coalesce(x.nr_seq_derivado::text, '') = ''
	and	coalesce(x.nr_seq_exame_sangue::text, '') = ''
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	coalesce(a.ie_adep,'S') = 'S'
	and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p))
	group by
		a.nr_prescricao,
		c.nr_seq_procedimento,
		c.cd_procedimento,
		z.ds_protocolo,
		x.ie_acm,
		x.ie_se_necessario,
		x.cd_intervalo,
		x.qt_procedimento,
		x.ie_suspenso,
		c.nr_seq_proc_interno,
		x.nr_seq_prot_glic,
		x.ie_origem_proced,
		a.dt_liberacao_medico,
		a.dt_liberacao,
		a.dt_liberacao_farmacia,
		x.ie_erro
	) alias25
group by
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_procedimento  ELSE null END   ELSE null END ,
	cd_procedimento,
	ds_procedimento,
	ie_acm_sn,
	cd_intervalo,
	qt_procedimento,
	ds_prescricao,
	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_procedimento,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END ,
	nr_seq_proc_interno,
	nr_seq_prot_glic,
	ds_intervalo,
	ie_origem_proced,
	ie_lib_pend_rep,
	ie_liberado,
	ie_erro;


BEGIN

ie_copiar_w 	:= plt_obter_se_item_marcado('G', nr_seq_regra_p);
ds_cor_titulo_w	:= plt_obter_se_item_marcado('G', nr_seq_regra_p);

open c01;
loop
fetch c01 into	nr_prescricao_w,
		nr_seq_procedimento_w,
		cd_procedimento_w,
		ds_procedimento_w,
		ie_acm_sn_w,
		cd_intervalo_w,
		qt_procedimento_w,
		ds_prescricao_w,
		ie_status_w,
		nr_seq_proc_interno_w,
		nr_seq_prot_glic_w,
		ds_interv_prescr_w,
		ie_origem_proced_w,
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
		nr_seq_proc_interno,
		nr_agrupamento,
		ie_diferenciado,
		nr_seq_prot_glic,
		ds_interv_prescr,
		ie_origem_proced,
		ie_pendente_liberacao,
		ie_liberado,
		ie_erro,
		ie_copiar,
		ds_cor_titulo)
	values (
		nr_seq_wadep_w,
		nm_usuario_p,
		'G',
		nr_prescricao_w,
		nr_seq_procedimento_w,
		cd_procedimento_w,
		ds_procedimento_w,
		ie_acm_sn_w,
		cd_intervalo_w,
		qt_procedimento_w,
		ds_prescricao_w,
		ie_status_w,
		nr_seq_proc_interno_w,
		0,
		'N',
		nr_seq_prot_glic_w,
		ds_interv_prescr_w,
		ie_origem_proced_w,
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
-- REVOKE ALL ON PROCEDURE plt_obter_ccg ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint) FROM PUBLIC;

