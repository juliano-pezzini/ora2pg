-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_overview_itens_data_v (nr_sequencia, nr_atendimento, ie_tipo_item, dt_inicio, dt_fim, dt_suspensao, dt_horario, ie_status, ds_horarios, cd_intervalo, nr_prescricao, nr_seq_item_prescr, nr_seq_prescr_hor) AS select	a.nr_sequencia,
	a.nr_atendimento,
	'M' ie_tipo_item,
	a.dt_inicio,
	coalesce(a.dt_fim_cih,a.dt_fim) dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'M',
					c.dt_recusa,
					c.dt_suspensao,
					c.dt_inicio_horario,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
FROM	cpoe_material a,
	prescr_material b,
	prescr_mat_hor c
where	a.nr_sequencia 		= b.nr_seq_mat_cpoe
and	b.nr_prescricao 	= c.nr_prescricao
and	b.nr_sequencia 		= c.nr_seq_material
and	a.dt_liberacao is not null
and	a.ie_controle_tempo = 'N'
and 	c.ie_agrupador = 1
and	coalesce(a.ie_material,'N') = 'N'
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'MAT' ie_tipo_item,
	a.dt_inicio,
	coalesce(a.dt_fim_cih,a.dt_fim) dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'M',
					c.dt_recusa,
					c.dt_suspensao,
					c.dt_inicio_horario,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_material a,
	prescr_material b,
	prescr_mat_hor c
where	a.nr_sequencia 		= b.nr_seq_mat_cpoe
and	b.nr_prescricao 	= c.nr_prescricao
and	b.nr_sequencia 		= c.nr_seq_material
and	a.dt_liberacao is not null
and	a.ie_controle_tempo = 'N'
and 	c.ie_agrupador = 5
and	coalesce(a.ie_material,'N') = 'N'
and 	c.ie_horario_especial = 'N'

union all

select	distinct
	a.nr_sequencia,
	a.nr_atendimento,
	'SOL' ie_tipo_item,
	a.dt_inicio,
	coalesce(a.dt_fim_cih,a.dt_fim) dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'SOL',
					c.dt_recusa,
					c.dt_suspensao,
					c.dt_inicio_horario,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	x.nr_seq_solucao nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_material a,
	prescr_material b,
	prescr_mat_hor c,
	prescr_solucao x
where	a.nr_sequencia 		= b.nr_seq_mat_cpoe
and	b.nr_prescricao 	= c.nr_prescricao
and	b.nr_sequencia 		= c.nr_seq_material
and	x.nr_prescricao		= b.nr_prescricao
and	x.nr_seq_solucao	= b.nr_sequencia_solucao
and	a.dt_liberacao is not null
and	a.ie_controle_tempo = 'S'
and 	b.ie_agrupador = 4
and	coalesce(a.ie_material,'N') = 'N'
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'R' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'R',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_recomendacao a,
	prescr_recomendacao b,
	prescr_rec_hor c
where	a.nr_sequencia  	= b.NR_SEQ_REC_CPOE
and	b.nr_prescricao		= c.nr_prescricao
and	b.NR_SEQUENCIA		= c.NR_SEQ_RECOMENDACAO
and	a.dt_liberacao is not null
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'P' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'P',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_procedimento a,
	prescr_procedimento b,
	prescr_proc_hor c
where	a.nr_sequencia  	= b.NR_SEQ_proc_CPOE
and	b.nr_prescricao		= c.nr_prescricao
and	b.NR_SEQUENCIA		= c.nr_seq_procedimento
and	a.dt_liberacao is not null
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'AP' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'AP',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_anatomia_patologica a,
	prescr_procedimento b,
	prescr_proc_hor c
where	a.nr_sequencia  	= b.NR_SEQ_proc_CPOE
and	b.nr_prescricao		= c.nr_prescricao
and	b.NR_SEQUENCIA		= c.nr_seq_procedimento
and	a.dt_liberacao is not null
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'G' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'G',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	Padroniza_horario_prescr(b.ds_horarios,coalesce(b.dt_prev_execucao,d.dt_inicio_prescr)) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_gasoterapia a,
	prescr_gasoterapia b,
	prescr_gasoterapia_hor c,
	prescr_medica d
where	a.nr_sequencia   	= b.NR_SEQ_GAS_CPOE
and	b.nr_prescricao  	= c.nr_prescricao
and	b.nr_prescricao	  	= d.nr_prescricao
and	b.nr_sequencia 	 	= c.NR_SEQ_GASOTERAPIA
and	a.dt_liberacao is not null
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'HM' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'HM',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_inicio,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_inicio,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_hemoterapia a,
	prescr_procedimento b,
	prescr_proc_hor c
where	a.nr_sequencia  	= b.NR_SEQ_proc_CPOE
and	b.nr_prescricao		= c.nr_prescricao
and	b.NR_SEQUENCIA		= c.nr_seq_procedimento
and	a.dt_liberacao is not null
and 	c.ie_horario_especial = 'N'

union all

select	distinct
	a.nr_sequencia,
	a.nr_atendimento,
	'DI' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	h.dt_horario,
	cpoe_overview_obter_status(	'DI',
					h.dt_recusa,
					h.dt_suspensao,
					h.dt_inicio_horario,
					h.dt_fim_horario) ie_status,
	padroniza_horario_prescr(x.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_inicio,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_inicio,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	m.cd_intervalo,
	m.nr_prescricao,
	m.nr_sequencia nr_seq_item_prescr,
	h.nr_sequencia nr_seq_prescr_hor
from	cpoe_dialise a,
	prescr_mat_hor h,
	prescr_material m,
	hd_prescricao b,
	prescr_solucao x,
	prescr_medica y
where	a.nr_sequencia = b.nr_seq_dialise_cpoe
and	x.nr_prescricao = y.nr_prescricao
and     b.nr_sequencia  = x.nr_seq_dialise
and	x.nr_seq_solucao = m.nr_sequencia_solucao
and	x.nr_prescricao = m.nr_prescricao
and	m.nr_sequencia = h.nr_seq_material
and	m.nr_prescricao = h.nr_prescricao
and     b.ie_tipo_dialise in ('H','P')
and	x.nr_seq_dialise is not null
and 	h.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'D' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'D',
					null,
					c.dt_suspensao,
					null,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_inicio,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_inicio,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_dieta a,
	prescr_dieta b,
	prescr_dieta_hor c
where	a.nr_sequencia  	= b.nr_seq_dieta_cpoe
and	b.nr_prescricao		= c.nr_prescricao
and	b.NR_SEQUENCIA		= c.nr_seq_dieta
and	a.dt_liberacao is not null
and	a.ie_tipo_dieta = 'O'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'D' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	b.dt_inicio dt_horario,
	cpoe_overview_obter_status(	'D',
					null,
					a.dt_suspensao,
					null,
					null) ie_status,
	padroniza_horario_prescr(a.ds_horarios, CASE WHEN 0=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_inicio,null),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_inicio,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	a.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	null nr_seq_prescr_hor
from	cpoe_dieta a,
	rep_jejum b
where	a.nr_sequencia  	= b.nr_seq_dieta_cpoe
and	a.dt_liberacao is not null
and	a.ie_tipo_dieta = 'J'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'D' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'D',
					c.dt_recusa,
					c.dt_suspensao,
					c.dt_inicio_horario,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_dieta a,
	prescr_material b,
	prescr_mat_hor c
where	a.nr_sequencia 		= b.nr_seq_dieta_cpoe
and	b.nr_prescricao 	= c.nr_prescricao
and	b.nr_sequencia 		= c.nr_seq_material
and	a.dt_liberacao is not null
and	a.ie_tipo_dieta = 'S'
and 	c.ie_agrupador = 12
and 	c.ie_horario_especial = 'N'

union all

select	a.nr_sequencia,
	a.nr_atendimento,
	'D' ie_tipo_item,
	a.dt_inicio,
	a.dt_fim,
	a.dt_lib_suspensao dt_suspensao,
	c.dt_horario,
	cpoe_overview_obter_status(	'D',
					c.dt_recusa,
					c.dt_suspensao,
					c.dt_inicio_horario,
					c.dt_fim_horario) ie_status,
	padroniza_horario_prescr(b.ds_horarios, CASE WHEN coalesce(b.qt_dia_prim_hor,0)=0 THEN CASE WHEN substr(Obter_Se_horario_hoje(a.dt_inicio,a.dt_prim_horario,b.hr_prim_horario),1,1)='N' THEN '01/01/2000 23:59:59'  ELSE to_char(coalesce(a.dt_prim_horario,a.dt_inicio),'dd/mm/yyyy hh24:mi:ss') END   ELSE '01/01/2000 23:59:59' END ) ds_horarios,
	b.cd_intervalo,
	b.nr_prescricao,
	b.nr_sequencia nr_seq_item_prescr,
	c.nr_sequencia nr_seq_prescr_hor
from	cpoe_dieta a,
	prescr_material b,
	prescr_mat_hor c
where	a.nr_sequencia 		= b.nr_seq_dieta_cpoe
and	b.nr_prescricao 	= c.nr_prescricao
and	b.nr_sequencia 		= c.nr_seq_material
and	a.dt_liberacao is not null
and	a.ie_tipo_dieta = 'E'
and 	c.ie_agrupador = 8
and 	c.ie_horario_especial = 'N';

