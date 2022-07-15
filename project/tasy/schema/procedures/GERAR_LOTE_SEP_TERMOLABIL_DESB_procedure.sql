-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_sep_termolabil_desb ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_horario_p bigint, ie_so_aprazado_p text, nm_usuario_p text, ie_origem_lote_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;	
cd_material_w		bigint;
nr_seq_mat_hor_w		bigint;
cd_unidade_medida_w	varchar(30);
qt_dispensar_w		double precision;
qt_dispensar_hor_w		double precision;
nr_seq_turno_w		bigint;
nr_seq_turno_ant_w	bigint	:= 0;
cd_setor_atendimento_w	integer;
dt_horario_w		timestamp;
dt_horario_ant_w		timestamp;
hr_inicio_turno_w		varchar(5);
hr_hora_w		varchar(5);
dt_atend_lote_w		timestamp;
dt_inicio_turno_w		timestamp;
cd_estabelecimento_w	smallint;
ie_urgente_w		varchar(1);
ds_maq_user_w 		varchar(80);
cd_perfil_ativo_w		integer;
nr_seq_classif_w		bigint;
nr_seq_classif_ant_w	bigint	:= 0;
ds_erro_w		varchar(2000);

qt_min_antes_atend_w	bigint;
qt_min_receb_setor_w	bigint;
qt_min_entr_setor_w	bigint;
qt_min_disp_farm_w	bigint;
qt_min_atend_farm_w	bigint;
qt_min_inicio_atend_w	bigint;

cd_tipo_baixa_w		smallint;
ie_conta_paciente_w	varchar(1);
ie_atualiza_estoque_w	varchar(1);
cd_local_estoque_w	smallint;
cd_local_estoque_ant_w	smallint	:= 0;
ie_hora_antes_w		varchar(1);
ie_classif_nao_padrao_w	varchar(15);
qt_prioridade_w		smallint;

ie_lote_acm_sn_w		varchar(1);
ie_gerar_acm_w		varchar(1);
ie_gerar_sn_w		varchar(1);
ie_acm_w		varchar(1);
ie_se_necessario_w	varchar(1);
ie_gera_lote_orig_w		varchar(1);
ie_gera_lote_medic_pac_w	varchar(1);
ie_gerar_novo_lote_turno_dia_w	varchar(15);
ie_gerar_lote_area_w		varchar(1);
ie_gerar_solucao_separado_w	varchar(1);

ie_termolabil_w		varchar(1);
ie_alto_risco_w		varchar(1);
ie_novo_lote_dia_w		varchar(1);
cd_material_ww		bigint;
nr_seq_prescr_mat_w	bigint;
ie_gera_novo_lote_w	varchar(1);
ie_gerar_lote_null_w	varchar(3);
ie_motivo_prescricao_w	varchar(5);
ie_quimio_w		varchar(1);	
nr_atendimento_w	prescr_medica.nr_atendimento%type;

C01 CURSOR FOR
	SELECT  b.cd_material,
		b.nr_sequencia,
		c.nr_sequencia,
		b.cd_unidade_medida,
		b.qt_dispensar,
		b.qt_dispensar_hor,
		coalesce(b.nr_seq_turno,-1),
		a.cd_setor_atendimento,
		b.dt_horario,
		to_char(b.dt_horario,'hh24:mi'),
		coalesce(a.cd_estabelecimento,1),
		b.ie_urgente,
		b.nr_seq_classif,
		coalesce(b.cd_local_estoque,coalesce(c.cd_local_estoque,a.cd_local_estoque)) cd_local
	from	material x,
		prescr_mat_hor  b,
		prescr_material c,
		prescr_medica   a
	where	a.nr_prescricao = b.nr_prescricao
	and	x.cd_material	= c.cd_material
	and	a.nr_prescricao	= c.nr_prescricao
	and	c.nr_sequencia	= b.nr_seq_material
	and	a.nr_prescricao = nr_prescricao_p
	and	((coalesce(nr_sequencia_p, 0) = 0) or (c.nr_sequencia = nr_sequencia_p))
	and	((coalesce(nr_seq_horario_p, 0) = 0) or (b.nr_sequencia = nr_seq_horario_p))
	and	((coalesce(ie_so_aprazado_p, 'N') = 'N') or (coalesce(ie_so_aprazado_p, 'N') = ie_aprazado))
	and	coalesce(b.ie_situacao,'A') <> 'I'
	and	coalesce(c.ie_suspenso,'N') <> 'S'
	and	coalesce(x.ie_gerar_lote,'S') = 'S'
	and	coalesce(a.dt_suspensao::text, '') = ''
	and	coalesce(c.cd_motivo_baixa,0) = 0
	and	coalesce(c.dt_baixa::text, '') = ''
	and	(b.nr_seq_turno IS NOT NULL AND b.nr_seq_turno::text <> '')
	and	coalesce(b.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.ie_gerar_lote,'S') = 'S'
	and	coalesce(b.qt_dispensar_hor,0) > 0
	and	coalesce(c.nr_sequencia_solucao::text, '') = ''
	and	coalesce(b.nr_seq_lote::text, '') = ''
	and	coalesce(x.ie_termolabil,'N') = 'S'
	and	(( ie_gerar_lote_null_w = 'S') or (c.ds_horarios IS NOT NULL AND c.ds_horarios::text <> '') or (ie_origem_lote_p = 'AIP'))
	and	((ie_gerar_acm_w = 'S') or (ie_gerar_acm_w = 'N' and coalesce(c.ie_acm, 'N') = 'N'))
	and	((ie_gerar_sn_w = 'S') or (ie_gerar_sn_w = 'N' and coalesce(c.ie_se_necessario, 'N') = 'N'))
	and	((ie_gera_lote_orig_w = 'N') or ((ie_origem_lote_p <> 'AIP') or (coalesce(b.ie_aprazado,'N') =

'S')))
	and	((ie_gera_lote_medic_pac_w = 'S') or ((ie_gera_lote_medic_pac_w = 'N') and (coalesce(ie_medicacao_paciente,'N') = 'N')))
	and	((ie_gerar_lote_area_w = 'S') or (coalesce(b.nr_seq_area_prep::text, '') = ''))
	and	((ie_origem_lote_p <> 'AIS') or ((ie_origem_lote_p = 'AIS') and exists (	SELECT	1
												

from	prescr_mat_hor d
												

where	d.nr_prescricao   = c.nr_prescricao						
												

and	d.nr_seq_material = c.nr_seq_kit
												

and	d.ie_agrupador = 4)))
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	and	((exists (	select	1
				from	prescr_material y
				where	y.nr_prescricao = c.nr_prescricao
				and	y.nr_sequencia_diluicao = c.nr_sequencia))
	or (exists (	select	1
				from	prescr_material p
				where	p.nr_prescricao = c.nr_prescricao
				and	p.nr_seq_kit	= c.nr_sequencia)))
	order by cd_local,
		 nr_seq_classif,
		 dt_horario;	
		
c10 CURSOR FOR
	SELECT  b.cd_material,
		b.nr_sequencia,
		b.cd_unidade_medida,
		b.qt_dispensar,
		b.qt_dispensar_hor,
		coalesce(b.nr_seq_turno,-1),
		a.cd_setor_atendimento,
		b.dt_horario,
		to_char(b.dt_horario,'hh24:mi'),
		coalesce(a.cd_estabelecimento,1),
		b.ie_urgente,
		b.nr_seq_classif,
		coalesce(b.cd_local_estoque,coalesce(c.cd_local_estoque,a.cd_local_estoque)) cd_local
	from	material x,
		prescr_mat_hor  b,
		prescr_material c,
		prescr_medica   a
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_prescricao	= c.nr_prescricao
	and	c.nr_sequencia	= b.nr_seq_material
	and	a.nr_prescricao = nr_prescricao_p
	and	x.cd_material	= c.cd_material
	and	coalesce(x.ie_gerar_lote,'S') = 'S'
	and	coalesce(nr_seq_prescr_mat_w, 0) > 0
	and	coalesce(b.nr_seq_lote::text, '') = ''
	and	coalesce(c.nr_sequencia_solucao::text, '') = ''
 	and	b.nr_seq_superior = nr_seq_prescr_mat_w
	and	coalesce(c.nr_seq_kit,0) <> nr_seq_prescr_mat_w
	and	c.cd_motivo_baixa = 0
	and	coalesce(b.ie_horario_especial, 'N') = 'N'
	and	coalesce(b.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.ie_gerar_lote,'S') = 'S'
	and	coalesce(b.qt_dispensar_hor,0) > 0
	and	coalesce(c.dt_baixa::text, '') = ''
	and	(b.nr_seq_turno IS NOT NULL AND b.nr_seq_turno::text <> '')
	and	b.nr_seq_turno = nr_seq_turno_w
	and	((ie_gerar_lote_null_w = 'S') or (c.ds_horarios IS NOT NULL AND c.ds_horarios::text <> '') or (ie_origem_lote_p = 'AIP'))
	and	((ie_gerar_acm_w = 'S') or (ie_gerar_acm_w = 'N' and coalesce(c.ie_acm, 'N') = 'N'))
	and	((ie_gerar_sn_w = 'S') or (ie_gerar_sn_w = 'N' and coalesce(c.ie_se_necessario, 'N') = 'N'))
	and	((ie_origem_lote_p <> 'AIS') or	(ie_origem_lote_p = 'AIS' AND b.ie_aprazado = 

'S'))
	and	((ie_gera_lote_orig_w = 'N') or ((ie_origem_lote_p <> 'AIP') or (coalesce(b.ie_aprazado,'N') = 

'S')))
	and	((ie_gera_lote_medic_pac_w = 'S') or ((ie_gera_lote_medic_pac_w = 'N') and (coalesce(ie_medicacao_paciente,'N') = 'N')))
	and	((ie_gerar_lote_area_w = 'S') or (coalesce(b.nr_seq_area_prep::text, '') = ''))
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	
union all

	SELECT  b.cd_material,
		b.nr_sequencia,
		b.cd_unidade_medida,
		b.qt_dispensar,
		b.qt_dispensar_hor,
		coalesce(b.nr_seq_turno,-1),
		a.cd_setor_atendimento,
		b.dt_horario,
		to_char(b.dt_horario,'hh24:mi'),
		coalesce(a.cd_estabelecimento,1),
		b.ie_urgente,
		b.nr_seq_classif,
		coalesce(b.cd_local_estoque,coalesce(c.cd_local_estoque,a.cd_local_estoque)) cd_local
	from	material x,
		prescr_mat_hor  b,
		prescr_material c,
		prescr_medica   a
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_prescricao	= c.nr_prescricao
	and	c.nr_sequencia	= b.nr_seq_material
	and	x.cd_material	= c.cd_material
	and	coalesce(x.ie_gerar_lote,'S') = 'S'
	and	a.nr_prescricao = nr_prescricao_p
	and	coalesce(nr_seq_prescr_mat_w, 0) > 0
	and	coalesce(b.nr_seq_lote::text, '') = ''
	and	coalesce(c.nr_sequencia_solucao::text, '') = ''
	and	coalesce(c.nr_seq_kit,0)	= nr_seq_prescr_mat_w
	and	c.cd_motivo_baixa = 0
	and	coalesce(b.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.ie_gerar_lote,'S') = 'S'
	and	coalesce(b.ie_horario_especial, 'N') = 'N'
	and	coalesce(c.dt_baixa::text, '') = ''
	and	coalesce(b.qt_dispensar_hor,0) > 0
	and	(b.nr_seq_turno IS NOT NULL AND b.nr_seq_turno::text <> '')
	and	b.nr_seq_turno = nr_seq_turno_w	
	and	((ie_gerar_lote_null_w = 'S') or (c.ds_horarios IS NOT NULL AND c.ds_horarios::text <> '') or (ie_origem_lote_p = 'AIP'))
	and	((ie_gerar_acm_w = 'S') or (ie_gerar_acm_w = 'N' and coalesce(c.ie_acm, 'N') = 'N'))
	and	((ie_gerar_sn_w = 'S') or (ie_gerar_sn_w = 'N' and coalesce(c.ie_se_necessario, 'N') = 'N'))
	and	((ie_origem_lote_p <> 'AIS') or	(ie_origem_lote_p = 'AIS' AND b.ie_aprazado = 

'S'))
	and	((ie_gera_lote_orig_w = 'N') or ((ie_origem_lote_p <> 'AIP') or (coalesce(b.ie_aprazado,'N') = 

'S')))
	and	((ie_gera_lote_medic_pac_w = 'S') or ((ie_gera_lote_medic_pac_w = 'N') and (coalesce(ie_medicacao_paciente,'N') = 'N')))
	and	((ie_gerar_lote_area_w = 'S') or (coalesce(b.nr_seq_area_prep::text, '') = ''))
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	and	((coalesce(ie_termolabil_w,'N') = 'N') or ((coalesce(ie_termolabil_w,'N') = 'S') and (coalesce(x.ie_termolabil,'N') = 'N')))
	and	((coalesce(ie_alto_risco_w,'N') = 'N') or ((coalesce(ie_alto_risco_w,'N') = 'S') and (obter_se_material_risco(a.cd_setor_atendimento,b.cd_material) = 'N')))
	
union all

	select  b.cd_material,
		b.nr_sequencia,
		b.cd_unidade_medida,
		b.qt_dispensar,
		b.qt_dispensar_hor,
		coalesce(b.nr_seq_turno,-1),
		a.cd_setor_atendimento,
		b.dt_horario,
		to_char(b.dt_horario,'hh24:mi'),
		coalesce(a.cd_estabelecimento,1),
		b.ie_urgente,
		b.nr_seq_classif,
		coalesce(b.cd_local_estoque,coalesce(c.cd_local_estoque,a.cd_local_estoque)) cd_local
	from	material x,
		prescr_mat_hor  b,
		prescr_material c,
		prescr_solucao d,
		prescr_medica   a
	where	a.nr_prescricao = b.nr_prescricao
	and	a.nr_prescricao	= c.nr_prescricao
	and	c.nr_sequencia	= b.nr_seq_material
	and	c.nr_prescricao = d.nr_prescricao
	and	x.cd_material	= c.cd_material
	and	coalesce(x.ie_gerar_lote,'S') = 'S'
	and	c.nr_sequencia_solucao = d.nr_seq_solucao
	and	a.nr_prescricao = nr_prescricao_p
	and	coalesce(b.nr_seq_lote::text, '') = ''
	and	c.ie_agrupador = 4
	and	(c.nr_sequencia_solucao IS NOT NULL AND c.nr_sequencia_solucao::text <> '') 
	and	coalesce(c.cd_motivo_baixa,0) = 0
	and	coalesce(b.qt_dispensar_hor,0) > 0
	and	coalesce(b.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.dt_baixa::text, '') = ''
	and	(b.nr_seq_turno IS NOT NULL AND b.nr_seq_turno::text <> '')
	and	b.nr_seq_turno = nr_seq_turno_w
	and	((ie_gerar_lote_null_w = 'S') or (c.ds_horarios IS NOT NULL AND c.ds_horarios::text <> '') or (ie_origem_lote_p = 'AIP'))
	and	((coalesce(d.ie_acm,'N') = 'N') or (coalesce(d.ie_acm,'N') = 'S' and ie_gerar_acm_w = 'S'))
	and	((coalesce(d.ie_se_necessario,'N') = 'N') or (coalesce(d.ie_se_necessario,'N') = 'S' and ie_gerar_sn_w 

= 'S'))
	and	((ie_origem_lote_p <> 'AIS') or	(ie_origem_lote_p = 'AIS' AND b.ie_aprazado = 

'S'))
	and	((ie_origem_lote_p <> 'AIP') or	(ie_origem_lote_p = 'AIP' AND b.ie_aprazado = 

'S'))
	and	((ie_gera_lote_orig_w = 'N') or ((ie_origem_lote_p <> 'AIP') or (coalesce(b.ie_aprazado,'N') = 

'S')))
	and	((ie_gerar_lote_area_w = 'S') or (coalesce(b.nr_seq_area_prep::text, '') = ''))
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	and 	ie_gerar_solucao_separado_w = 'N'
	and	((coalesce(ie_termolabil_w,'N') = 'N') or ((coalesce(ie_termolabil_w,'N') = 'S') and (coalesce(x.ie_termolabil,'N') = 'N')))
	and	((coalesce(ie_alto_risco_w,'N') = 'N') or ((coalesce(ie_alto_risco_w,'N') = 'S') and (obter_se_material_risco(a.cd_setor_atendimento,b.cd_material) = 'N')))
	order by cd_local,
		 nr_seq_classif,
		 dt_horario;	
C11 CURSOR FOR
	SELECT  b.cd_material,
		b.nr_sequencia,
		c.nr_sequencia,
		b.cd_unidade_medida,
		b.qt_dispensar,
		b.qt_dispensar_hor,
		coalesce(b.nr_seq_turno,-1),
		a.cd_setor_atendimento,
		b.dt_horario,
		to_char(b.dt_horario,'hh24:mi'),
		coalesce(a.cd_estabelecimento,1),
		b.ie_urgente,
		b.nr_seq_classif,
		coalesce(b.cd_local_estoque,coalesce(c.cd_local_estoque,a.cd_local_estoque)) cd_local
	from	material x,
		prescr_mat_hor  b,
		prescr_material c,
		prescr_medica   a
	where	a.nr_prescricao = b.nr_prescricao
	and	x.cd_material	= c.cd_material
	and	a.nr_prescricao	= c.nr_prescricao
	and	c.nr_sequencia	= b.nr_seq_material
	and	a.nr_prescricao = nr_prescricao_p
	and	((coalesce(nr_sequencia_p, 0) = 0) or (c.nr_sequencia = nr_sequencia_p))
	and	((coalesce(nr_seq_horario_p, 0) = 0) or (b.nr_sequencia = nr_seq_horario_p))
	and	((coalesce(ie_so_aprazado_p, 'N') = 'N') or (coalesce(ie_so_aprazado_p, 'N') = ie_aprazado))
	and	coalesce(b.ie_situacao,'A') <> 'I'
	and	coalesce(c.ie_suspenso,'N') <> 'S'
	and	coalesce(x.ie_gerar_lote,'S') = 'S'
	and	coalesce(a.dt_suspensao::text, '') = ''
	and	coalesce(c.cd_motivo_baixa,0) = 0
	and	coalesce(c.dt_baixa::text, '') = ''
	and	(b.nr_seq_turno IS NOT NULL AND b.nr_seq_turno::text <> '')
	and	coalesce(b.ie_gerar_lote,'S') = 'S'
	and	coalesce(c.ie_gerar_lote,'S') = 'S'
	and	coalesce(b.qt_dispensar_hor,0) > 0
	and	coalesce(c.nr_sequencia_solucao::text, '') = ''
	and	coalesce(b.nr_seq_superior::text, '') = ''
	and	coalesce(b.nr_seq_lote::text, '') = ''	
	and	coalesce(ie_termolabil_w,'N') = 'S'
	and	((ie_gerar_lote_null_w = 'S') or (c.ds_horarios IS NOT NULL AND c.ds_horarios::text <> '') or (ie_origem_lote_p = 'AIP'))
	and	((ie_gerar_acm_w = 'S') or (ie_gerar_acm_w = 'N' and coalesce(c.ie_acm, 'N') = 'N'))
	and	((ie_gerar_sn_w = 'S') or (ie_gerar_sn_w = 'N' and coalesce(c.ie_se_necessario, 'N') = 'N'))
	and	((ie_gera_lote_orig_w = 'N') or ((ie_origem_lote_p <> 'AIP') or (coalesce(b.ie_aprazado,'N') =

'S')))
	and	((ie_gera_lote_medic_pac_w = 'S') or ((ie_gera_lote_medic_pac_w = 'N') and (coalesce(ie_medicacao_paciente,'N') = 'N')))
	and	((ie_gerar_lote_area_w = 'S') or (coalesce(b.nr_seq_area_prep::text, '') = ''))
	and	((ie_origem_lote_p <> 'AIS') or ((ie_origem_lote_p = 'AIS') and exists (	SELECT	1
												

from	prescr_mat_hor d
												

where	d.nr_prescricao   = c.nr_prescricao						
												

and	d.nr_seq_material = c.nr_seq_kit
												

and	d.ie_agrupador = 4)))
	and	Obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S'
	and	((not exists (	select	1
				from	prescr_material y
				where	y.nr_prescricao = c.nr_prescricao
				and	y.nr_sequencia_diluicao = c.nr_sequencia))
	and (not exists (	select	1
				from	prescr_material p
				where	p.nr_prescricao = c.nr_prescricao
				and	p.nr_seq_kit	= c.nr_sequencia)))
	order by cd_local,
		 nr_seq_classif,
		 dt_horario;	

	
C02 CURSOR FOR
	SELECT	to_char(b.hr_inicial,'hh24:mi')
	from	regra_turno_disp_param b,
		regra_turno_disp a
	where	a.nr_sequencia		= b.nr_seq_turno
	and	a.cd_estabelecimento	= cd_estabelecimento_w
	and	a.nr_sequencia		= nr_seq_turno_w
	and (coalesce(b.cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w)
	order by coalesce(b.cd_setor_atendimento,0),
		to_char(b.hr_inicial,'hh24:mi');
	
C03 CURSOR FOR
	SELECT	cd_setor_atendimento,
		nr_seq_turno,
		nr_seq_classif,
		qt_min_antes_atend,
		qt_min_receb_setor,
		qt_min_entr_setor,
		qt_min_disp_farm,
		qt_min_atend_farm,
		qt_min_inicio_atend,
		coalesce(ie_hora_antes,'H')
	from	regra_tempo_disp
	where	cd_estabelecimento	= cd_estabelecimento_w
	and	coalesce(ie_situacao, 'A')	= 'A'
	order by coalesce(nr_seq_classif,0), 
		coalesce(nr_seq_turno,0),
		coalesce(cd_setor_atendimento,0);

C20 CURSOR FOR
	SELECT	cd_tipo_baixa
	from	regra_disp_lote_farm
	where	((ie_motivo_prescricao = ie_motivo_prescricao_w) or (coalesce(ie_motivo_prescricao::text, '') = ''))
	and		clock_timestamp() between to_date(to_char(clock_timestamp(),'dd/mm/yyyy')||' '||to_char(coalesce(dt_hora_inicio,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') and
							to_date(to_char(clock_timestamp(),'dd/mm/yyyy')||' '||to_char(coalesce(dt_hora_fim,clock_timestamp()),'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss')
	and		trunc(clock_timestamp()) between trunc(dt_inicio_vigencia) and trunc(coalesce(dt_fim_vigencia,clock_timestamp()))
	and		coalesce(cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w
	and		coalesce(cd_estabelecimento,cd_estabelecimento_w)	= cd_estabelecimento_w
	and		coalesce(ie_situacao,'A') = 'A'
	and 	((ie_quimio_w <> 'S' and coalesce(ie_quimioterapicas,'N') <> 'S') or (ie_quimio_w = 'S'))
	order by CASE WHEN ie_quimio_w='S' THEN  coalesce(ie_quimioterapicas, 'Z')  ELSE coalesce(ie_quimioterapicas, 'A') END ,
	coalesce(cd_setor_atendimento,0), coalesce(ie_motivo_prescricao,0);
	
	


BEGIN

select 	coalesce(max('S'),'N')
into STRICT	ie_quimio_w
from	paciente_atendimento
where	nr_prescricao = nr_prescricao_p;

begin

select	substr(obter_inf_sessao(0) ||' - ' || obter_inf_sessao(1),1,80)
into STRICT	ds_maq_user_w	
;

cd_perfil_ativo_w	:= obter_perfil_ativo;

select	max(cd_setor_atendimento),
		max(cd_estabelecimento),
		max(ie_motivo_prescricao),
		max(nr_atendimento)
into STRICT	cd_setor_atendimento_w,
		cd_estabelecimento_w,
		ie_motivo_prescricao_w,
		nr_atendimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	max(ie_classif_urgencia),
	coalesce(max(ie_gerar_acm_lote), 'S'),
	coalesce(max(ie_gerar_sn_lote), 'S'),
	coalesce(max(ie_gerar_novo_lote_turno_dia),'S'),
	coalesce(max(ie_gerar_lote_area),'S'),
	coalesce(max(ie_gerar_solucao_separado),'S'),
	coalesce(max(ie_gerar_termo_separado),'S'),
	coalesce(max(ie_gerar_alto_risco_sep),'S'),
	coalesce(max(ie_novo_lote_dia),'N')
into STRICT	ie_classif_nao_padrao_w,
	ie_gerar_acm_w,
	ie_gerar_sn_w,
	ie_gerar_novo_lote_turno_dia_w,
	ie_gerar_lote_area_w,
	ie_gerar_solucao_separado_w,
	ie_termolabil_w,
	ie_alto_risco_w,
	ie_novo_lote_dia_w
from	parametros_farmacia
where	cd_estabelecimento	= cd_estabelecimento_w;


ie_gera_lote_orig_w := coalesce(obter_valor_param_usuario(1113, 138, Obter_perfil_ativo, nm_usuario_p,

cd_estabelecimento_w),'N'); /* Virgilio 26/05/2009*/
ie_gera_lote_medic_pac_w := coalesce(obter_valor_param_usuario(924, 389, Obter_perfil_ativo, nm_usuario_p,

cd_estabelecimento_w),'N'); /* Virgílio 06/08/2009*/
ie_gerar_lote_null_w	:= coalesce(obter_valor_param_usuario(924, 873, Obter_perfil_ativo, nm_usuario_p, 

cd_estabelecimento_w),'S');

/*Fabio e Jonas - Para que busque a parametrização do ADEP e caso for D(Depende da regra) ai então é 

verificado nos parametros da farmácia*/
if (ie_origem_lote_p in ('AIP','GAI', 'AIS')) then
	begin
	ie_lote_acm_sn_w	:= coalesce(obter_valor_param_usuario(1113, 107, Obter_perfil_ativo, nm_usuario_p,

cd_estabelecimento_w),'S');	
	if (ie_lote_acm_sn_w = 'S') or (ie_lote_acm_sn_w = 'N') then
		ie_gerar_acm_w	:= ie_lote_acm_sn_w;
		ie_gerar_sn_w	:= ie_lote_acm_sn_w;
	end if;
	end;
end if;

open C20;
loop
fetch C20 into	
	cd_tipo_baixa_w;
EXIT WHEN NOT FOUND; /* apply on C20 */
	begin
	cd_tipo_baixa_w	:= cd_tipo_baixa_w;
	end;
end loop;
close C20;

if (cd_tipo_baixa_w IS NOT NULL AND cd_tipo_baixa_w::text <> '') then
	select	max(ie_conta_paciente),
		max(ie_atualiza_estoque)
	into STRICT	ie_conta_paciente_w,
		ie_atualiza_estoque_w
	from	tipo_baixa_prescricao
	where	cd_tipo_baixa		= cd_tipo_baixa_w
	and	ie_prescricao_devolucao = 'P';
end if;

ie_gera_novo_lote_w := 'N';
open C01;
loop
fetch C01 into	
	cd_material_w,
	nr_seq_mat_hor_w,
	nr_seq_prescr_mat_w,
	cd_unidade_medida_w,
	qt_dispensar_w,
	qt_dispensar_hor_w,
	nr_seq_turno_w,
	cd_setor_atendimento_w,
	dt_horario_w,
	hr_hora_w,
	cd_estabelecimento_w,
	ie_urgente_w,
	nr_seq_classif_w,
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_gera_novo_lote_w := 'N';
	if (nr_seq_turno_w <> nr_seq_turno_ant_w) or (nr_seq_classif_w <> nr_seq_classif_ant_w) or
		((trunc(dt_horario_w,'dd') <> trunc(dt_horario_ant_w,'dd')) and (ie_gerar_novo_lote_turno_dia_w = 'S')) or
		(((dt_horario_w - dt_inicio_turno_w) > 1) and (ie_novo_lote_dia_w = 'S')) or (cd_local_estoque_w <> cd_local_estoque_ant_w) or (ie_gera_novo_lote_w = 'S') then
		begin

		OPEN C02;
		LOOP
			FETCH C02 INTO
				hr_inicio_turno_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			hr_inicio_turno_w	:= hr_inicio_turno_w;
			end;
		END LOOP;
		CLOSE C02;
		
		select	coalesce(max(qt_prioridade),999)
		into STRICT	qt_prioridade_w
		from	classif_lote_disp_far
		where	nr_sequencia	= nr_seq_classif_w;

		if (hr_hora_w < hr_inicio_turno_w) then
			dt_inicio_turno_w	:= to_date(to_char(dt_horario_w - 1,'dd/mm/yyyy')||' '||

replace(hr_inicio_turno_w,'24:','00:') ||':00','dd/mm/yyyy hh24:mi:ss');
		else
			dt_inicio_turno_w	:= to_date(to_char(dt_horario_w,'dd/mm/yyyy')||' '||replace(hr_inicio_turno_w,'24:','00:') ||':00','dd/mm/yyyy hh24:mi:ss');
		end if;
		
		select	nextval('ap_lote_seq')
		into STRICT	nr_sequencia_w
		;
		
		insert into ap_lote(
			nr_sequencia,
			dt_inicio_turno,
			dt_prim_horario,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_geracao_lote,
			nr_prescricao,
			nr_seq_turno,
			ie_status_lote,
			cd_setor_atendimento,
			nr_seq_classif,
			nm_usuario_geracao,
			ds_maquina_geracao,
			cd_perfil_geracao,
			qt_min_atraso_inicio_atend,
			qt_min_atraso_atend,
			qt_min_atraso_disp,
			qt_min_atraso_entrega,
			qt_min_atraso_receb,
			cd_tipo_baixa,
			ie_conta_paciente,
			ie_atualiza_estoque,
			cd_local_estoque,
			qt_prioridade,
			ie_origem_lote,
			nr_seq_local_geracao,
			nr_atendimento)
		values ( nr_sequencia_w,
			dt_inicio_turno_w,
			dt_horario_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_prescricao_p,
			nr_seq_turno_w,
			'G',
			cd_setor_atendimento_w,
			nr_seq_classif_w,
			nm_usuario_p,
			ds_maq_user_w,
			cd_perfil_ativo_w,
			0,
			0,
			0,
			0,
			0,
			cd_tipo_baixa_w,
			ie_conta_paciente_w,
			ie_atualiza_estoque_w,
			cd_local_estoque_w,
			qt_prioridade_w,
			ie_origem_lote_p,
			'TL',
			nr_atendimento_w);
		ie_gera_novo_lote_w := 'N';
		end;
	end if;
	
	nr_seq_turno_ant_w	:= nr_seq_turno_w;
	nr_seq_classif_ant_w	:= nr_seq_classif_w;
	cd_local_estoque_ant_w	:= cd_local_estoque_w;
	dt_horario_ant_w	:= dt_horario_w;
		
	insert into ap_lote_item(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote,
		nr_seq_mat_hor,
		ie_prescrito,
		qt_dispensar,
		qt_total_dispensar,
		cd_material,
		cd_unidade_medida,
		ie_urgente)
	values (nextval('ap_lote_item_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_w,
		nr_seq_mat_hor_w,
		'S',
		coalesce(qt_dispensar_hor_w,0),
		qt_dispensar_w,
		cd_material_w,
		cd_unidade_medida_w,
		ie_urgente_w);
			
	update	prescr_mat_hor
	set	nr_seq_lote	= nr_sequencia_w
	where	nr_sequencia	= nr_seq_mat_hor_w;	
	
	open C10;
	loop
	fetch C10 into	
		cd_material_ww,
		nr_seq_mat_hor_w,
		cd_unidade_medida_w,
		qt_dispensar_w,
		qt_dispensar_hor_w,
		nr_seq_turno_w,
		cd_setor_atendimento_w,
		dt_horario_w,
		hr_hora_w,
		cd_estabelecimento_w,
		ie_urgente_w,
		nr_seq_classif_w,
		cd_local_estoque_w;
		EXIT WHEN NOT FOUND; /* apply on C10 */
			begin				
			insert into ap_lote_item(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_lote,
				nr_seq_mat_hor,
				ie_prescrito,
				qt_dispensar,
				qt_total_dispensar,
				cd_material,
				cd_unidade_medida,
				ie_urgente)
			values (nextval('ap_lote_item_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_sequencia_w,
				nr_seq_mat_hor_w,
				'S',
				coalesce(qt_dispensar_hor_w,0),
				qt_dispensar_w,
				cd_material_ww,
				cd_unidade_medida_w,
				ie_urgente_w);			
			update	prescr_mat_hor
			set	nr_seq_lote	= nr_sequencia_w
			where	nr_sequencia	= nr_seq_mat_hor_w;
			
			ie_gera_novo_lote_w := 'S';
			end;
		end loop;
		close C10;
	end;
end loop;
close C01;


open C11;
loop
fetch C11 into	
	cd_material_w,
	nr_seq_mat_hor_w,
	nr_seq_prescr_mat_w,
	cd_unidade_medida_w,
	qt_dispensar_w,
	qt_dispensar_hor_w,
	nr_seq_turno_w,
	cd_setor_atendimento_w,
	dt_horario_w,
	hr_hora_w,
	cd_estabelecimento_w,
	ie_urgente_w,
	nr_seq_classif_w,
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C11 */
	begin
	if (nr_seq_turno_w <> nr_seq_turno_ant_w) or (nr_seq_classif_w <> nr_seq_classif_ant_w) or
		((trunc(dt_horario_w,'dd') <> trunc(dt_horario_ant_w,'dd')) and (ie_gerar_novo_lote_turno_dia_w = 'S')) or
		(((dt_horario_w - dt_inicio_turno_w) > 1) and (ie_novo_lote_dia_w = 'S')) or (cd_local_estoque_w <> cd_local_estoque_ant_w) then
		begin

		OPEN C02;
		LOOP
			FETCH C02 INTO
				hr_inicio_turno_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			hr_inicio_turno_w	:= hr_inicio_turno_w;
			end;
		END LOOP;
		CLOSE C02;
		
		select	coalesce(max(qt_prioridade),999)
		into STRICT	qt_prioridade_w
		from	classif_lote_disp_far
		where	nr_sequencia	= nr_seq_classif_w;

		if (hr_hora_w < hr_inicio_turno_w) then
			dt_inicio_turno_w	:= to_date(to_char(dt_horario_w - 1,'dd/mm/yyyy')||' '||

replace(hr_inicio_turno_w,'24:','00:') ||':00','dd/mm/yyyy hh24:mi:ss');
		else
			dt_inicio_turno_w	:= to_date(to_char(dt_horario_w,'dd/mm/yyyy')||' '||replace(hr_inicio_turno_w,'24:','00:') ||':00','dd/mm/yyyy hh24:mi:ss');
		end if;
		
		select	nextval('ap_lote_seq')
		into STRICT	nr_sequencia_w
		;
		
		insert into ap_lote(
			nr_sequencia,
			dt_inicio_turno,
			dt_prim_horario,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			dt_geracao_lote,
			nr_prescricao,
			nr_seq_turno,
			ie_status_lote,
			cd_setor_atendimento,
			nr_seq_classif,
			nm_usuario_geracao,
			ds_maquina_geracao,
			cd_perfil_geracao,
			qt_min_atraso_inicio_atend,
			qt_min_atraso_atend,
			qt_min_atraso_disp,
			qt_min_atraso_entrega,
			qt_min_atraso_receb,
			cd_tipo_baixa,
			ie_conta_paciente,
			ie_atualiza_estoque,
			cd_local_estoque,
			qt_prioridade,
			ie_origem_lote)
		values ( nr_sequencia_w,
			dt_inicio_turno_w,
			dt_horario_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nr_prescricao_p,
			nr_seq_turno_w,
			'G',
			cd_setor_atendimento_w,
			nr_seq_classif_w,
			nm_usuario_p,
			ds_maq_user_w,
			cd_perfil_ativo_w,
			0,
			0,
			0,
			0,
			0,
			cd_tipo_baixa_w,
			ie_conta_paciente_w,
			ie_atualiza_estoque_w,
			cd_local_estoque_w,
			qt_prioridade_w,
			ie_origem_lote_p);
		ie_gera_novo_lote_w := 'N';
		end;
	end if;
	
	nr_seq_turno_ant_w	:= nr_seq_turno_w;
	nr_seq_classif_ant_w	:= nr_seq_classif_w;
	cd_local_estoque_ant_w	:= cd_local_estoque_w;
	dt_horario_ant_w	:= dt_horario_w;
		
	insert into ap_lote_item(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote,
		nr_seq_mat_hor,
		ie_prescrito,
		qt_dispensar,
		qt_total_dispensar,
		cd_material,
		cd_unidade_medida,
		ie_urgente)
	values (nextval('ap_lote_item_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_sequencia_w,
		nr_seq_mat_hor_w,
		'S',
		coalesce(qt_dispensar_hor_w,0),
		qt_dispensar_w,
		cd_material_w,
		cd_unidade_medida_w,
		ie_urgente_w);
			
	update	prescr_mat_hor
	set	nr_seq_lote	= nr_sequencia_w
	where	nr_sequencia	= nr_seq_mat_hor_w;	
	
	end;
end loop;
close C11;


open C03;
loop
fetch C03 into	
	cd_setor_atendimento_w,
	nr_seq_turno_w,
	nr_seq_classif_w,
	qt_min_antes_atend_w,
	qt_min_receb_setor_w,
	qt_min_entr_setor_w,
	qt_min_disp_farm_w,
	qt_min_atend_farm_w,
	qt_min_inicio_atend_w,
	ie_hora_antes_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	if (ie_hora_antes_w = 'H') then
		begin
		update	ap_lote
		set	dt_atend_lote		= round(dt_prim_horario - dividir(qt_min_antes_atend_w,1440),'mi'),
			dt_limite_inicio_atend	= round(dt_prim_horario - dividir(qt_min_inicio_atend_w,1440),'mi'),
			dt_limite_atend		= round(dt_prim_horario - dividir(qt_min_atend_farm_w,1440),'mi'),
			dt_limite_disp_farm	= round(dt_prim_horario - dividir(qt_min_disp_farm_w,1440),'mi'),
			dt_limite_entrega_setor	= round(dt_prim_horario - dividir(qt_min_entr_setor_w,1440),'mi'),
			dt_limite_receb_setor	= round(dt_prim_horario - dividir(qt_min_receb_setor_w,1440),'mi')
		where	nr_prescricao		= nr_prescricao_p
		and	((coalesce(cd_setor_atendimento_w::text, '') = '') or (cd_setor_atendimento_w = cd_setor_atendimento))
		and	((coalesce(nr_seq_turno_w::text, '') = '') or (nr_seq_turno_w = nr_seq_turno))
		and	((coalesce(nr_seq_classif_w::text, '') = '') or (nr_seq_classif_w = nr_seq_classif));
		end;
	elsif (ie_hora_antes_w = 'I') then
		begin
		update	ap_lote
		set	dt_atend_lote		= round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi'),
			dt_limite_inicio_atend	= round(dt_prim_horario - dividir(qt_min_inicio_atend_w,1440),'mi'),
			dt_limite_atend		= round(dt_prim_horario - dividir(qt_min_atend_farm_w,1440),'mi'),
			dt_limite_disp_farm	= round(dt_prim_horario - dividir(qt_min_disp_farm_w,1440),'mi'),
			dt_limite_entrega_setor	= round(dt_prim_horario - dividir(qt_min_entr_setor_w,1440),'mi'),
			dt_limite_receb_setor	= round(dt_prim_horario - dividir(qt_min_receb_setor_w,1440),'mi')
		where	nr_prescricao		= nr_prescricao_p
		and	((coalesce(cd_setor_atendimento_w::text, '') = '') or (cd_setor_atendimento_w = cd_setor_atendimento))
		and	((coalesce(nr_seq_turno_w::text, '') = '') or (nr_seq_turno_w = nr_seq_turno))
		and	((coalesce(nr_seq_classif_w::text, '') = '') or (nr_seq_classif_w = nr_seq_classif));
		end;
	elsif (ie_hora_antes_w = 'T') then
		begin
		update	ap_lote
		set	dt_atend_lote		= CASE WHEN to_char(round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi'), 'hh24:mi:ss')='00:00:00' THEN  --OS186690
			round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi') + 1/86400  ELSE round(dt_inicio_turno - dividir(qt_min_antes_atend_w,1440),'mi') END ,
			dt_limite_inicio_atend	= CASE WHEN to_char(round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi'), 'hh24:mi:ss')='00:00:00' THEN			round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi') + 1/86400  ELSE round(dt_inicio_turno - dividir(qt_min_inicio_atend_w,1440),'mi') END , 
			dt_limite_atend		= round(dt_inicio_turno - dividir(qt_min_atend_farm_w,1440),'mi'),
			dt_limite_disp_farm	= round(dt_inicio_turno - dividir(qt_min_disp_farm_w,1440),'mi'),
			dt_limite_entrega_setor	= round(dt_inicio_turno - dividir(qt_min_entr_setor_w,1440),'mi'),
			dt_limite_receb_setor	= round(dt_inicio_turno - dividir(qt_min_receb_setor_w,1440),'mi')
		where	nr_prescricao		= nr_prescricao_p
		and	((coalesce(cd_setor_atendimento_w::text, '') = '') or (cd_setor_atendimento_w = cd_setor_atendimento))
		and	((coalesce(nr_seq_turno_w::text, '') = '') or (nr_seq_turno_w = nr_seq_turno))
		and	((coalesce(nr_seq_classif_w::text, '') = '') or (nr_seq_classif_w = nr_seq_classif));
		end;
	end if;
	end;
end loop;
close C03;

exception
when others then
	ds_erro_w	:= substr(SQLERRM(SQLSTATE),1,2000);
	/* insert into log_xxtasy(
		dt_atualizacao,
		nm_usuario,
		cd_log,
		ds_log)
	values(	sysdate,
		nm_usuario_p,
		4141,
		ds_erro_w);
	commit; */
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_sep_termolabil_desb ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_horario_p bigint, ie_so_aprazado_p text, nm_usuario_p text, ie_origem_lote_p text) FROM PUBLIC;

