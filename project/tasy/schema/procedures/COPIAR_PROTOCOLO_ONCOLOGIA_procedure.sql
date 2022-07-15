-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_protocolo_oncologia ( cd_protocolo_p bigint, nr_sequencia_p bigint, nr_seq_pac_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_gerar_dose_w		varchar(1) := 'N';
cd_estabelecimento_w	smallint;
qt_registro_null_w		smallint;
qt_idade_w		bigint;
cd_pessoa_fisica_w	numeric(20);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_convenio_w		bigint;
nr_seq_proc_w		bigint;
nr_seq_proc_ww		bigint;
nr_seq_material_w		bigint;
nr_seq_soluc_w		bigint;
nr_seq_solucao_ww	bigint;
ds_dias_aplicacao_w	varchar(4000);
nr_seq_mat_w		bigint;
qt_peso_w		real;
Var_gerar_material_dia_apli_w   varchar(2);
nr_atendimento_w		bigint;
ie_gerar_pend_quimio_w	varchar(1);
ds_observacao_w		material.ds_orientacao_usuario%type;
ie_considera_dose_terap_w	varchar(1);
ds_restricao_medic_onc_w	varchar(100);

c01 CURSOR FOR
	SELECT	*
	from	protocolo_medic_proc
	where	cd_protocolo = cd_protocolo_p
	and	nr_sequencia = nr_sequencia_p
	and	(ds_dias_aplicacao IS NOT NULL AND ds_dias_aplicacao::text <> '');

c01_w c01%rowtype;

c02 CURSOR FOR
	SELECT	*
	from	protocolo_medic_material
	where	cd_protocolo = cd_protocolo_p
	and	nr_sequencia = nr_sequencia_p
	and	coalesce(nr_seq_diluicao::text, '') = ''
	and	ie_agrupador = 5
	and	nr_seq_proc = nr_seq_proc_w;

c02_w c02%rowtype;

c03 CURSOR FOR
	SELECT 	*
	from	protocolo_medic_solucao
	where	cd_protocolo = cd_protocolo_p
	and	nr_sequencia = nr_sequencia_p
	and	(ds_dias_aplicacao IS NOT NULL AND ds_dias_aplicacao::text <> '')
	order by nr_seq_solucao;

c03_w c03%rowtype;

c04 CURSOR FOR
	SELECT 	nr_seq_pac_p,
		b.nr_seq_material,
		b.cd_material,
		b.qt_dose,
		b.cd_unidade_medida,
		coalesce(b.ds_dias_aplicacao, a.ds_dias_aplicacao) ds_dias_aplicacao,
		nm_usuario_p,
		b.nr_agrupamento,
		b.ds_recomendacao,
		b.ie_via_aplicacao,
		b.nr_seq_solucao,
		b.qt_minuto_aplicacao,
		b.ie_bomba_infusao,
		b.cd_intervalo,
		b.qt_hora_aplicacao,
		b.qt_dias_util,
		b.ie_se_necessario,
		b.ie_aplic_lenta,
		b.ie_urgencia,
		b.ie_aplic_bolus,
		b.ie_pre_medicacao,
		coalesce(ie_aplica_reducao,'S') ie_aplica_reducao,
		b.ie_acm,
		b.ie_local_adm
	from 	protocolo_medic_material b,
		protocolo_medic_solucao a
	where 	a.cd_protocolo = cd_protocolo_p
	  and	a.nr_sequencia = nr_sequencia_p
	  and 	a.cd_protocolo = b.cd_protocolo
	  and 	a.nr_sequencia = b.nr_sequencia
	  and 	b.nr_seq_solucao = a.nr_seq_solucao
	  and	(a.ds_dias_aplicacao IS NOT NULL AND a.ds_dias_aplicacao::text <> '')
	  and	b.nr_seq_solucao = nr_seq_solucao_ww
	  and	b.ie_agrupador in (4)
	  and	'S' = obter_permicao_conv_medic(cd_convenio_w,b.nr_sequencia,b.cd_protocolo,b.nr_seq_material);

c04_w c04%rowtype;


BEGIN

select	coalesce(max(cd_estabelecimento),0),
	max(cd_pessoa_fisica),
	coalesce(max(qt_peso),0)
into STRICT	cd_estabelecimento_w,
	cd_pessoa_fisica_w,
	qt_peso_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_pac_p;

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	atendimento_paciente
where	cd_pessoa_fisica = cd_pessoa_fisica_w
and	coalesce(dt_alta::text, '') = ''
and	coalesce(dt_cancelamento::text, '') = '';

if (cd_estabelecimento_w > 0) then
	ie_gerar_dose_w := obter_param_usuario(281, 330, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_dose_w);
	Var_gerar_material_dia_apli_w := obter_param_usuario(281, 1322, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, Var_gerar_material_dia_apli_w);
	ie_gerar_pend_quimio_w := obter_param_usuario(865, 255, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_pend_quimio_w);
	ie_considera_dose_terap_w := obter_param_usuario(281, 1543, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_considera_dose_terap_w);
end if;


select 	max(a.cd_convenio)
into STRICT	cd_convenio_w
from	paciente_setor_convenio a,
	paciente_setor b
where 	b.cd_protocolo	= cd_protocolo_p
and   	b.cd_pessoa_fisica  = cd_pessoa_fisica_w
and   	a.nr_seq_paciente = b.nr_seq_paciente
and	a.nr_seq_paciente = nr_seq_pac_p;

if (coalesce(cd_convenio_w::text, '') = '') then
	select 	max(a.cd_convenio)
	into STRICT	cd_convenio_w
	from	paciente_setor_convenio a,
		paciente_setor b
	where 	b.cd_protocolo = cd_protocolo_p
	and   	b.cd_pessoa_fisica = cd_pessoa_fisica_w
	and   	a.nr_seq_paciente = b.nr_seq_paciente;
end if;

select	count(*)
into STRICT	qt_registro_null_w
from 	protocolo_medic_material
where	cd_protocolo = cd_protocolo_p
and	nr_sequencia = nr_sequencia_p
and	coalesce(nr_seq_diluicao::text, '') = ''
and	ie_agrupador = 1
and	coalesce(ds_dias_aplicacao::text, '') = '';

if (qt_registro_null_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(176398);
end if;

qt_idade_w := (obter_idade_pf(cd_pessoa_fisica_w,clock_timestamp(),'A'));

insert into 	paciente_protocolo_medic(
		nr_seq_paciente,
		nr_seq_material,
		cd_material,
		qt_dose,
		cd_unidade_medida,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		ds_recomendacao,
		ie_via_aplicacao,
		nr_seq_diluicao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nr_seq_interno,
		ie_se_necessario,
		ie_aplic_lenta,
		ie_urgencia,
		ie_aplic_bolus,
		ie_pre_medicacao,
		ie_alerta_via_adm,
		ds_ciclos_aplicacao,
		cd_protocolo,
		nr_seq_medicacao,
		ie_aplica_reducao,
		ie_regra_diluicao_cad_mat,
		ie_local_adm,
		nr_seq_prot_med,
		ie_uso_continuo,
		ie_acm,
		qt_dias_receita,
		ds_justificativa,
		ie_objetivo,
		cd_topografia_cih,
		cd_amostra_cih,
		cd_microorganismo_cih,
		ie_origem_infeccao)
	SELECT 	nr_seq_pac_p,
		a.nr_seq_material,
		a.cd_material,
		coalesce(obter_dose_regra_protocolo(a.cd_protocolo,a.nr_seq_material,a.nr_sequencia,qt_idade_w,qt_peso_w),a.qt_dose),
		CASE WHEN ie_considera_dose_terap_w='Y' THEN  coalesce(obter_padrao_param_prescr_onc(null, a.cd_material, null, null, null, qt_idade_w, qt_peso_w , null, 'U', null, 'N'),a.cd_unidade_medida)  ELSE a.cd_unidade_medida END ,
		a.ds_dias_aplicacao,
		clock_timestamp(),
		nm_usuario_p,
		a.nr_agrupamento,
		substr(CASE WHEN coalesce(obter_orientacao_medic(a.cd_material), 'XPTO')='XPTO' THEN  a.ds_recomendacao  ELSE obter_orientacao_medic(a.cd_material) || ' - ' || a.ds_recomendacao END ,1,2000),
		a.ie_via_aplicacao,
		a.nr_seq_diluicao,
		coalesce(a.qt_minuto_aplicacao,b.qt_min_aplicacao),
		a.ie_bomba_infusao,
		a.cd_intervalo,
		a.qt_hora_aplicacao,
		a.qt_dias_util,
		nextval('paciente_protocolo_medic_seq'),
		a.ie_se_necessario,
		a.ie_aplic_lenta,
		a.ie_urgencia,
		a.ie_aplic_bolus,
		a.ie_pre_medicacao,
		a.ie_alerta_via_adm,
		a.ds_ciclos_aplicacao,
		cd_protocolo_p,
		nr_sequencia_p,
		coalesce(a.IE_APLICA_REDUCAO,'S'),
		coalesce(a.IE_REGRA_DILUICAO_CAD_MAT,'N'),
		CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(a.IE_LOCAL_ADM,'H')  ELSE coalesce(a.IE_LOCAL_ADM,'') END ,
		a.nr_seq_interno,
		a.ie_uso_continuo,
		a.ie_acm,
		qt_dias_receita,
		a.ds_justificativa,
		a.ie_objetivo,
		a.cd_topografia_cih,
		a.cd_amostra_cih,
		a.cd_microorganismo_cih,
		a.ie_origem_infeccao
from 	protocolo_medic_material a,
	material b
where	a.cd_protocolo = cd_protocolo_p
  and	a.nr_sequencia = nr_sequencia_p
  and	a.cd_material = b.cd_material
  and	coalesce(a.nr_seq_diluicao::text, '') = ''
  and	coalesce(a.nr_seq_solucao::text, '') = ''
  and	coalesce(a.nr_seq_medic_material::text, '') = ''
  and	a.ie_agrupador = 1
  and	b.ie_situacao = 'A'
  and	'S' = obter_permicao_conv_medic(cd_convenio_w,a.nr_sequencia,a.cd_protocolo,a.nr_seq_material);

insert into paciente_protocolo_medic(
		nr_seq_paciente,
		nr_seq_material,
		cd_material,
		qt_dose,
		cd_unidade_medida,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		nr_agrupamento,
		ds_recomendacao,
		ie_via_aplicacao,
		nr_seq_diluicao,
		qt_min_aplicacao,
		ie_bomba_infusao,
		cd_intervalo,
		qt_hora_aplicacao,
		qt_dias_util,
		nr_seq_interno,
		ie_se_necessario,
		ie_aplic_lenta,
		ie_urgencia,
		ie_aplic_bolus,
		ie_pre_medicacao,
		cd_protocolo,
		nr_seq_medicacao,
		ie_agrupador,
		ie_aplica_reducao,
		ie_local_adm,
		nr_seq_prot_med,
		nr_seq_medic_material,
		ie_acm)
SELECT 		nr_seq_pac_p,
		b.nr_seq_material,
		b.cd_material,
		b.qt_dose,
		b.cd_unidade_medida,
		coalesce(b.ds_dias_aplicacao, a.ds_dias_aplicacao),
		clock_timestamp(),
		nm_usuario_p,
		b.nr_agrupamento,
		substr(CASE WHEN coalesce(obter_orientacao_medic(b.cd_material), 'XPTO')='XPTO' THEN  b.ds_recomendacao  ELSE obter_orientacao_medic(b.cd_material) || ' - ' || b.ds_recomendacao END ,1,2000),
		b.ie_via_aplicacao,
		b.nr_seq_diluicao,
		coalesce(b.qt_minuto_aplicacao,c.qt_min_aplicacao),
		b.ie_bomba_infusao,
		b.cd_intervalo,
		b.qt_hora_aplicacao,
		b.qt_dias_util,
		nextval('paciente_protocolo_medic_seq'),
		b.ie_se_necessario,
		b.ie_aplic_lenta,
		b.ie_urgencia,
		b.ie_aplic_bolus,
		b.ie_pre_medicacao,
		cd_protocolo_p,
		nr_sequencia_p,
		b.ie_agrupador,
		coalesce(a.ie_aplica_reducao,'S'),
		CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(a.IE_LOCAL_ADM,'H')  ELSE coalesce(a.IE_LOCAL_ADM,'') END ,
		b.nr_seq_interno,
		b.nr_seq_medic_material,
		b.ie_acm
from 		protocolo_medic_material b,
		protocolo_medic_material a,
		material c
where 	a.cd_protocolo = cd_protocolo_p
  and	a.nr_sequencia = nr_sequencia_p
  and 	a.cd_protocolo = b.cd_protocolo
  and	a.cd_material = c.cd_material
  and 	a.nr_sequencia = b.nr_sequencia
  and 	b.nr_seq_medic_material = a.nr_seq_material
  and	b.ie_agrupador in (2)
  and	c.ie_situacao = 'A'
  and	'S' = obter_permicao_conv_medic(cd_convenio_w,b.nr_sequencia,b.cd_protocolo,b.nr_seq_material)
  and	exists (	SELECT	1
			from	paciente_protocolo_medic x
			where	x.nr_seq_paciente	= nr_seq_pac_p
			and		x.nr_seq_material	= b.nr_seq_medic_material);

if (Var_gerar_material_dia_apli_w = 'S')then
      begin

      insert into paciente_protocolo_medic(
                  nr_seq_paciente,
                  nr_seq_material,
                  cd_material,
                  qt_dose,
                  cd_unidade_medida,
                  ds_dias_aplicacao,
                  dt_atualizacao,
                  nm_usuario,
                  nr_agrupamento,
                  ds_recomendacao,
                  ie_via_aplicacao,
                  nr_seq_diluicao,
                  qt_min_aplicacao,
                  ie_bomba_infusao,
                  cd_intervalo,
                  qt_hora_aplicacao,
                  qt_dias_util,
                  nr_seq_interno,
                  ie_se_necessario,
                  ie_aplic_lenta,
                  ie_urgencia,
                  ie_aplic_bolus,
                  ie_pre_medicacao,
                  ie_alerta_via_adm,
                  ds_ciclos_aplicacao,
                  cd_protocolo,
                  nr_seq_medicacao,
                  ie_aplica_reducao,
                  ie_regra_diluicao_cad_mat,
                  ie_local_adm,
                  nr_seq_prot_med,
                  ie_uso_continuo,
		  ie_acm)
               SELECT 	nr_seq_pac_p,
                  a.nr_seq_material,
                  a.cd_material,
                  coalesce(obter_dose_regra_protocolo(a.cd_protocolo,a.nr_seq_material,a.nr_sequencia,qt_idade_w,qt_peso_w),a.qt_dose),
                  CASE WHEN ie_considera_dose_terap_w='Y' THEN  coalesce(obter_padrao_param_prescr_onc(null, a.cd_material, null, null, null, qt_idade_w, qt_peso_w , null, 'U', null, 'N'),a.cd_unidade_medida)  ELSE a.cd_unidade_medida END ,
                  a.ds_dias_aplicacao,
                  clock_timestamp(),
                  nm_usuario_p,
                  a.nr_agrupamento,
		  substr(CASE WHEN coalesce(obter_orientacao_medic(a.cd_material), 'XPTO')='XPTO' THEN  a.ds_recomendacao  ELSE obter_orientacao_medic(a.cd_material) || ' - ' || a.ds_recomendacao END ,1,2000),
                  a.ie_via_aplicacao,
                  a.nr_seq_diluicao,
                  a.qt_minuto_aplicacao,
                  a.ie_bomba_infusao,
                  a.cd_intervalo,
                  a.qt_hora_aplicacao,
                  a.qt_dias_util,
                  nextval('paciente_protocolo_medic_seq'),
                  a.ie_se_necessario,
                  a.ie_aplic_lenta,
                  a.ie_urgencia,
                  a.ie_aplic_bolus,
                  a.ie_pre_medicacao,
                  a.ie_alerta_via_adm,
                  a.ds_ciclos_aplicacao,
                  cd_protocolo_p,
                  nr_sequencia_p,
                  coalesce(a.ie_aplica_reducao,'S'),
                  coalesce(a.ie_regra_diluicao_cad_mat,'N'),
                  CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(a.IE_LOCAL_ADM,'H')  ELSE coalesce(a.IE_LOCAL_ADM,'') END ,
                  a.nr_seq_interno,
                  a.ie_uso_continuo,
		  a.ie_acm
               from protocolo_medic_material a,
			material b
               where	a.cd_protocolo = cd_protocolo_p
                 and	a.nr_sequencia = nr_sequencia_p
                 and	a.cd_material = b.cd_material
                 and	coalesce(a.nr_seq_diluicao::text, '') = ''
                 and	coalesce(a.nr_seq_solucao::text, '') = ''
                 and	coalesce(a.nr_seq_medic_material::text, '') = ''
                 and	a.ie_agrupador = 2
                 and	b.ie_situacao = 'A'
                 AND	'S' = obter_permicao_conv_medic(cd_convenio_w,a.nr_sequencia,a.cd_protocolo,a.	nr_seq_material)
                 and	coalesce(a.nr_seq_medic_material::text, '') = ''
                 and	(a.ds_dias_aplicacao IS NOT NULL AND a.ds_dias_aplicacao::text <> '');
      end;
end if;

insert into paciente_protocolo_medic(
	nr_seq_paciente,
	nr_seq_material,
	cd_material,
	qt_dose,
	cd_unidade_medida,
	ds_dias_aplicacao,
	dt_atualizacao,
	nm_usuario,
	nr_agrupamento,
	ds_recomendacao,
	ie_via_aplicacao,
	nr_seq_diluicao,
	qt_min_aplicacao,
	ie_bomba_infusao,
	cd_intervalo,
	qt_hora_aplicacao,
	qt_dias_util,
	nr_seq_interno,
	ie_se_necessario,
	ie_aplic_lenta,
	ie_urgencia,
	ie_aplic_bolus,
	ie_pre_medicacao,
	cd_protocolo,
	nr_seq_medicacao,
	ie_agrupador,
	ie_aplica_reducao,
	ie_local_adm,
	nr_seq_prot_med,
	ie_acm)
SELECT 	nr_seq_pac_p,
	b.nr_seq_material,
	b.cd_material,
	b.qt_dose,
	b.cd_unidade_medida,
	coalesce(b.ds_dias_aplicacao, a.ds_dias_aplicacao),
	clock_timestamp(),
	nm_usuario_p,
	b.nr_agrupamento,
	substr(CASE WHEN coalesce(obter_orientacao_medic(b.cd_material), 'XPTO')='XPTO' THEN  b.ds_recomendacao  ELSE obter_orientacao_medic(b.cd_material) || ' - ' || b.ds_recomendacao END ,1,2000),
	b.ie_via_aplicacao,
	b.nr_seq_diluicao,
	coalesce(obter_tempo_dil_mat(nr_seq_pac_p, a.cd_material, b.cd_material),b.qt_minuto_aplicacao),
	b.ie_bomba_infusao,
	b.cd_intervalo,
	b.qt_hora_aplicacao,
	b.qt_dias_util,
	nextval('paciente_protocolo_medic_seq'),
	b.ie_se_necessario,
	b.ie_aplic_lenta,
	b.ie_urgencia,
	b.ie_aplic_bolus,
	b.ie_pre_medicacao,
	cd_protocolo_p,
	nr_sequencia_p,
	b.ie_agrupador,
	coalesce(b.ie_aplica_reducao,'S'),
	CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(a.IE_LOCAL_ADM,'H')  ELSE coalesce(a.IE_LOCAL_ADM,'') END ,
	b.nr_seq_interno,
	b.ie_acm
from 	protocolo_medic_material b,
	protocolo_medic_material a,
	material c
where 	a.cd_protocolo = cd_protocolo_p
  and	a.nr_sequencia = nr_sequencia_p
  and	a.cd_material = c.cd_material
  and 	a.cd_protocolo = b.cd_protocolo
  and 	a.nr_sequencia = b.nr_sequencia
  and 	b.nr_seq_diluicao = a.nr_seq_material
  and	b.ie_agrupador in (3,7,9)
  and	c.ie_situacao = 'A'
  AND	'S' = obter_permicao_conv_medic(cd_convenio_w,b.nr_sequencia,b.cd_protocolo,b.nr_seq_material)
  and	exists (	SELECT	1
			from	paciente_protocolo_medic x
			where	x.nr_seq_paciente	= nr_seq_pac_p
			and	x.nr_seq_material	= b.nr_seq_diluicao);

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	cd_procedimento_w	:= c01_w.cd_procedimento;
	ie_origem_proced_w	:= c01_w.ie_origem_proced;

	if (c01_w.nr_seq_proc_interno IS NOT NULL AND c01_w.nr_seq_proc_interno::text <> '') then
		SELECT * FROM obter_proc_tab_interno(	c01_w.nr_seq_proc_interno, null, nr_atendimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

	end if;

	select	coalesce(max(nr_seq_procedimento),0) +1
	into STRICT	nr_seq_proc_ww
	from	PACIENTE_PROTOCOLO_PROC
	where	nr_seq_paciente	= NR_SEQ_PAC_P;

	insert into paciente_protocolo_proc(
		nr_seq_paciente,
		nr_seq_procedimento,
		cd_procedimento,
		ie_origem_proced,
		qt_procedimento,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		cd_intervalo,
		nm_usuario_nrec,
		nr_agrupamento,
		ie_se_necessario,
		ie_acm,
		nr_seq_proc_interno,
		ie_lado,
		cd_protocolo_adic,
		nr_seq_medicacao_adic,
		ds_ciclos_aplicacao,
		cd_kit_material,
		ie_local_adm,
		IE_URGENCIA)
	values (nr_seq_pac_p,
		nr_seq_proc_ww,
		cd_procedimento_w,
		ie_origem_proced_w,
		c01_w.qt_procedimento,
		c01_w.ds_dias_aplicacao,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		c01_w.cd_intervalo,
		nm_usuario_p,
		c01_w.nr_seq_proc,
		c01_w.ie_se_necessario,
		c01_w.ie_acm,
		c01_w.nr_seq_proc_interno,
		c01_w.ie_lado,
		cd_protocolo_p,
		nr_sequencia_p,
		c01_w.ds_ciclos_aplicacao,
		c01_w.cd_kit_material,
		CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c01_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c01_w.IE_LOCAL_ADM,'') END ,
		c01_w.IE_URGENCIA);

	nr_seq_proc_w	:= c01_w.nr_seq_proc;
	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	coalesce(max(nr_seq_material),0) + 1
		into STRICT	nr_seq_material_w
		from	paciente_protocolo_medic
		where	nr_seq_paciente = nr_seq_pac_p;

		insert into paciente_protocolo_medic(
			nr_seq_paciente,
			nr_seq_material,
			nr_seq_medicacao,
			cd_material,
			qt_dose,
			cd_unidade_medida,
			ds_dias_aplicacao,
			dt_atualizacao,
			nm_usuario,
			nr_agrupamento,
			ie_bomba_infusao,
			nr_seq_interno,
			ie_via_aplicacao,
			cd_intervalo,
			ds_recomendacao,
			nr_seq_procedimento,
			ie_agrupador,
			qt_hora_aplicacao,
			qt_min_aplicacao,
			ie_acm,
			qt_dias_receita,
			ie_local_adm)
		values (nr_seq_pac_p,
			nr_seq_material_w,
			nr_sequencia_p,
			c02_w.cd_material,
			c02_w.qt_dose,
			c02_w.cd_unidade_medida,
			c01_w.ds_dias_aplicacao,
			clock_timestamp(),
			nm_usuario_p,
			c02_w.nr_agrupamento,
			c02_w.ie_bomba_infusao,
			nextval('paciente_protocolo_medic_seq'),
			c02_w.ie_via_aplicacao,
			c02_w.cd_intervalo,
			substr(CASE WHEN coalesce(obter_orientacao_medic(c02_w.cd_material), 'XPTO')='XPTO' THEN  c02_w.ds_recomendacao  ELSE obter_orientacao_medic(c02_w.cd_material) || ' - ' || c02_w.ds_recomendacao END ,1,2000),
			nr_seq_proc_ww,
			c02_w.ie_agrupador,
			c02_w.qt_hora_aplicacao,
			c02_w.qt_minuto_aplicacao,
			c02_w.ie_acm,
			c02_w.qt_dias_receita,
			CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c02_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c02_w.IE_LOCAL_ADM,'') END );
		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

open C03;
loop
fetch C03 into
	c03_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	select	coalesce(max(nr_seq_solucao),0) + 1
	into STRICT	nr_seq_soluc_w
	from	paciente_protocolo_soluc
	where	nr_seq_paciente = nr_seq_pac_p;

	insert into paciente_protocolo_soluc(
			nr_seq_paciente,
			nr_seq_solucao,
			nr_agrupamento,
			ds_dias_aplicacao,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_tipo_dosagem,
			qt_dosagem,
			qt_solucao_total,
			qt_tempo_aplicacao,
			qt_tempo_aplicacao_min,
			nr_etapas,
			ie_bomba_infusao,
			ie_esquema_alternado,
			ie_calc_aut,
			ie_acm,
			qt_hora_fase,
			ds_solucao,
			ds_orientacao,
			ie_se_necessario,
			ie_solucao_pca,
			ie_tipo_analgesia,
			ie_pca_modo_prog,
			qt_dose_inicial_pca,
			qt_vol_infusao_pca,
			qt_bolus_pca,
			qt_intervalo_bloqueio,
			qt_limite_quatro_hora,
			qt_dose_ataque,
			ie_tipo_sol,
			ds_ciclos_aplicacao,
			cd_protocolo_adic,
			nr_seq_medicacao_adic,
			ie_pre_medicacao,
			cd_intervalo,
			ie_via_aplicacao,
			ie_local_adm)
		values (nr_seq_pac_p,
			nr_seq_soluc_w,
			c03_w.nr_agrupamento,
			c03_w.ds_dias_aplicacao,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			c03_w.ie_tipo_dosagem,
			c03_w.qt_dosagem,
			c03_w.qt_solucao_total,
			c03_w.qt_tempo_aplicacao,
			c03_w.qt_tempo_aplicacao_min,
			c03_w.nr_etapas,
			c03_w.ie_bomba_infusao,
			c03_w.ie_esquema_alternado,
			c03_w.ie_calc_aut,
			c03_w.ie_acm,
			c03_w.qt_hora_fase,
			coalesce(c03_w.ds_solucao,c03_w.ds_rotina),
			c03_w.ds_orientacao,
			c03_w.ie_se_necessario,
			c03_w.ie_solucao_pca,
			c03_w.ie_tipo_analgesia,
			c03_w.ie_pca_modo_prog,
			c03_w.qt_dose_inicial_pca,
			c03_w.qt_vol_infusao_pca,
			c03_w.qt_bolus_pca,
			c03_w.qt_intervalo_bloqueio,
			c03_w.qt_limite_quatro_hora,
			c03_w.qt_dose_ataque,
			c03_w.ie_tipo_sol,
			c03_w.ds_ciclos_aplicacao,
			cd_protocolo_p,
			nr_sequencia_p,
			c03_w.ie_pre_medicacao,
			c03_w.cd_intervalo,
			c03_w.ie_via_aplicacao,
			CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c03_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c03_w.IE_LOCAL_ADM,'') END );

			nr_seq_solucao_ww	:=	c03_w.nr_seq_solucao;

			open C04;
			loop
			fetch C04 into
				c04_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin

				select	coalesce(max(nr_seq_material),0) + 1
				into STRICT	nr_seq_mat_w
				from	paciente_protocolo_medic
				where	nr_seq_paciente = nr_seq_pac_p;

					insert into paciente_protocolo_medic(
						nr_seq_paciente,
						nr_seq_material,
						cd_material,
						qt_dose,
						cd_unidade_medida,
						ds_dias_aplicacao,
						dt_atualizacao,
						nm_usuario,
						nr_agrupamento,
						ds_recomendacao,
						ie_via_aplicacao,
						nr_seq_solucao,
						qt_min_aplicacao,
						ie_bomba_infusao,
						cd_intervalo,
						qt_hora_aplicacao,
						qt_dias_util,
						nr_seq_interno,
						ie_se_necessario,
						ie_aplic_lenta,
						ie_urgencia,
						ie_aplic_bolus,
						ie_pre_medicacao,
						ie_aplica_reducao,
						ie_acm,
						ie_local_adm)
					values (nr_seq_pac_p,
						nr_seq_mat_w,
						c04_w.cd_material,
						c04_w.qt_dose,
						c04_w.cd_unidade_medida,
						c04_w.ds_dias_aplicacao,--nvl(b.ds_dias_aplicacao, a.ds_dias_aplicacao),
						clock_timestamp(),
						nm_usuario_p,
						c04_w.nr_agrupamento,
						c04_w.ds_recomendacao,
						c04_w.ie_via_aplicacao,
						nr_seq_soluc_w,
						c04_w.qt_minuto_aplicacao,
						c04_w.ie_bomba_infusao,
						c04_w.cd_intervalo,
						c04_w.qt_hora_aplicacao,
						c04_w.qt_dias_util,
						nextval('paciente_protocolo_medic_seq'),
						c04_w.ie_se_necessario,
						c04_w.ie_aplic_lenta,
						c04_w.ie_urgencia,
						c04_w.ie_aplic_bolus,
						c04_w.ie_pre_medicacao,
						coalesce(c04_w.ie_aplica_reducao,'S'),
						c04_w.ie_acm,
						CASE WHEN ie_gerar_pend_quimio_w='S' THEN  coalesce(c04_w.IE_LOCAL_ADM,'H')  ELSE coalesce(c04_w.IE_LOCAL_ADM,'') END );

				end;
			end loop;
			close C04;
	end;
end loop;
close C03;

insert into paciente_protocolo_rec(	
		nr_sequencia,
		nr_seq_paciente,
		ds_dias_aplicacao,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_recomendacao,
		cd_recomendacao,
		cd_intervalo,
		ie_acm,
		ie_se_necessario,
		nr_seq_classif,
		ds_ciclos_aplicacao,
		cd_kit,
		ie_local_adm)
SELECT	nextval('paciente_protocolo_rec_seq'),
		nr_seq_pac_p,
		ds_dias_aplicacao,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_recomendacao,
		cd_recomendacao,
		cd_intervalo,
		ie_acm,
		ie_se_necessario,
		nr_seq_classif,
		ds_ciclos_aplicacao,
		cd_kit,
		ie_local_adm
from	protocolo_medic_rec a
where	a.cd_protocolo = cd_protocolo_p
  and	a.nr_sequencia = nr_sequencia_p
  and	(a.ds_dias_aplicacao IS NOT NULL AND a.ds_dias_aplicacao::text <> '');

CALL QT_GERAR_MEDIC_SUPORTE(	nr_seq_pac_p );

if (ie_gerar_dose_w = 'S') then
	CALL atualizar_dose_onc_protocolo(nr_seq_pac_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_protocolo_oncologia ( cd_protocolo_p bigint, nr_sequencia_p bigint, nr_seq_pac_p bigint, nm_usuario_p text) FROM PUBLIC;

