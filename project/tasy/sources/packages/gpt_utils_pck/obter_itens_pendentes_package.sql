-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE t_r_itens AS (
		qt_medic	bigint := 0,
		qt_mat		bigint := 0,
		qt_sne		bigint := 0,
		qt_supl		bigint := 0,
		qt_proc_lab	bigint := 0,
		qt_anat		bigint := 0,
		qt_sol		bigint := 0,
		qt_sol_hd	bigint := 0,
		qt_sol_dp	bigint := 0,
		qt_dieta	bigint := 0,
		qt_jejum	bigint := 0,
		qt_rec		bigint := 0,
		qt_nptnp	bigint := 0,
		qt_npta		bigint := 0,
		qt_sangue	bigint := 0,
		qt_leite	bigint := 0,
		qt_gas		bigint := 0
	);


CREATE OR REPLACE FUNCTION gpt_utils_pck.obter_itens_pendentes (nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, ie_tipo_usuario_p text default null, qt_horas_quimio_p bigint default 0) RETURNS varchar AS $body$
DECLARE


	r_itens_w			t_r_itens;
	ie_tipo_usuario_w	varchar(1);
	ds_result_w			varchar(500);

	
BEGIN

	ie_tipo_usuario_w := ie_tipo_usuario_p;

	if coalesce(ie_tipo_usuario_w::text, '') = '' then
		ie_tipo_usuario_w := coalesce(substr(obter_valor_param_usuario(252, 1, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, 0), 1, 1), 'N');
	end if;
		
	select	
		sum(CASE WHEN a.ie_material='S' THEN  1  ELSE 0 END ),
		sum(CASE WHEN a.ie_material='S' THEN  0  ELSE CASE WHEN a.ie_controle_tempo='S' THEN  1  ELSE 0 END  END ),
		sum(CASE WHEN a.ie_material='S' THEN  0  ELSE CASE WHEN a.ie_controle_tempo='N' THEN  1  ELSE 0 END  END )
	into STRICT	
		r_itens_w.qt_mat,
		r_itens_w.qt_sol,
		r_itens_w.qt_medic
	from 	cpoe_material a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(a.dt_lib_suspensao::text, '') = ''
	and not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_material = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and (
		a.cd_funcao_origem in (2314, 916)
		or pkg_date_utils.start_of(a.dt_inicio, 'mi') < pkg_date_utils.end_of(clock_timestamp(), 'DAY')
		or (
			cpoe_obter_se_item_oncologia(a.nr_sequencia, 'SOL') = 'S' 
		)
	)
	and		exists (SELECT 1 from prescr_material x where x.nr_seq_mat_cpoe = a.nr_sequencia)
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  coalesce(a.dt_fim_cih,a.dt_fim)  ELSE coalesce(a.dt_suspensao, coalesce(a.dt_fim_cih, a.dt_fim)) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S';
		
	select	
		sum(CASE WHEN ie_tipo_dieta='O' THEN  1  ELSE 0 END ),	-- Dietas orais
		sum(CASE WHEN ie_tipo_dieta='J' THEN  1  ELSE 0 END ),	-- Jejum
		sum(CASE WHEN ie_tipo_dieta='E' THEN  1  ELSE 0 END ),	-- Dietas enterais
		sum(CASE WHEN ie_tipo_dieta='L' THEN  1  ELSE 0 END ),	-- Leites e formulas infantis
		sum(CASE WHEN ie_tipo_dieta='S' THEN  1  ELSE 0 END ),	-- Suplementos
		sum(CASE WHEN ie_tipo_dieta='P' THEN  1  ELSE 0 END ),	-- Parenteral
		sum(CASE WHEN ie_tipo_dieta='I' THEN  1  ELSE 0 END )	-- Parenteral Infantil
	into STRICT	
		r_itens_w.qt_dieta,	
		r_itens_w.qt_jejum,	
		r_itens_w.qt_sne,
		r_itens_w.qt_leite,
		r_itens_w.qt_supl,
		r_itens_w.qt_npta,
		r_itens_w.qt_nptnp
	from 	cpoe_dieta a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)	
	and		coalesce(a.dt_lib_suspensao::text, '') = ''
	and not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_dieta = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and ((a.cd_funcao_origem in (2314, 916)) OR pkg_date_utils.start_of(a.dt_inicio, 'mi') < pkg_date_utils.end_of(clock_timestamp(), 'DAY'))
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and (exists (SELECT 1 from prescr_dieta x where x.nr_seq_dieta_cpoe = a.nr_sequencia) or 
			exists (select 1 from prescr_material x where x.nr_seq_dieta_cpoe = a.nr_sequencia) or
			exists (select 1 from prescr_leite_deriv x where x.nr_seq_dieta_cpoe = a.nr_sequencia) or
			exists (select 1 from rep_jejum x where x.nr_seq_dieta_cpoe = a.nr_sequencia) or
			exists (select 1 from nut_pac x where x.nr_seq_npt_cpoe = a.nr_sequencia));
	
	-- Exames e Procedimentos

	select	count(*)
	into STRICT	r_itens_w.qt_proc_lab
	from 	cpoe_procedimento a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(a.dt_lib_suspensao::text, '') = ''
	and		not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_procedimento = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and		((a.cd_funcao_origem in (2314, 916)) OR pkg_date_utils.start_of(a.dt_inicio, 'mi') < pkg_date_utils.end_of(clock_timestamp(), 'DAY'))
	and		exists (SELECT 1 from prescr_procedimento x where x.nr_seq_proc_cpoe = a.nr_sequencia)
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S';

	-- Exames anatomia patologica

	select	count(*)
	into STRICT	r_itens_w.qt_anat
	from 	cpoe_anatomia_patologica a
	where (
		nr_atendimento = nr_atendimento_p
		or (
			cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (dt_liberacao_enf IS NOT NULL AND dt_liberacao_enf::text <> '') and coalesce(dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(dt_lib_suspensao::text, '') = ''
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and		exists (SELECT 1 from prescr_procedimento x where x.nr_seq_proc_cpoe = a.nr_sequencia);

	-- Gasoterapia

	select	count(*)
	into STRICT	r_itens_w.qt_gas
	from 	cpoe_gasoterapia a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(a.dt_lib_suspensao::text, '') = ''	
	and		not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_procedimento = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and		exists (SELECT 1 from prescr_gasoterapia x where x.nr_seq_gas_cpoe = a.nr_sequencia);

	-- Recomendacoes

	select	count(*)
	into STRICT	r_itens_w.qt_rec
	from 	cpoe_recomendacao a
	where (
		nr_atendimento = nr_atendimento_p
		or (
			cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (dt_liberacao_enf IS NOT NULL AND dt_liberacao_enf::text <> '') and coalesce(dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(dt_lib_suspensao::text, '') = ''
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and		exists (SELECT 1 from prescr_recomendacao x where x.nr_seq_rec_cpoe = a.nr_sequencia);
	
	-- Hemoterapia

	select	count(*)
	into STRICT	r_itens_w.qt_sangue
	from 	cpoe_hemoterapia a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(a.dt_lib_suspensao::text, '') = ''
	and		not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_hemoterapia = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and		((a.cd_funcao_origem in (2314, 916)) OR pkg_date_utils.start_of(a.dt_inicio, 'mi') < pkg_date_utils.end_of(clock_timestamp(), 'DAY'))
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and		exists (SELECT 1 from prescr_procedimento x where x.nr_seq_proc_cpoe = a.nr_sequencia);
	
	-- Dialise

	select	
		sum(CASE WHEN a.ie_tipo_dialise ='DI' THEN  1  ELSE 0 END ),	-- Hemodialise
		sum(CASE WHEN a.ie_tipo_dialise ='DP' THEN  1  ELSE 0 END )	-- Dialise peritoneal
	into STRICT	
		r_itens_w.qt_sol_hd,
		r_itens_w.qt_sol_dp
	from 	cpoe_dialise a
	where (
		a.nr_atendimento = nr_atendimento_p
		or (
			a.cd_pessoa_fisica = cd_pessoa_fisica_p
			and coalesce(nr_atendimento_p::text, '') = ''
		)
	)
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		(
		(ie_tipo_usuario_w = 'E' and coalesce(a.dt_liberacao_enf::text, '') = '') or (ie_tipo_usuario_w = 'F' and (a.dt_liberacao_enf IS NOT NULL AND a.dt_liberacao_enf::text <> '') and coalesce(a.dt_liberacao_farm::text, '') = '')
	)
	and		coalesce(a.dt_lib_suspensao::text, '') = ''
	and		not exists (
		SELECT	1
		from	cpoe_item_gestao_analise x
		where	x.nr_seq_dialise = a.nr_sequencia
		and		x.ie_tipo_usuario = ie_tipo_usuario_w
		and		x.ie_situacao = 'A'
	 LIMIT 1)
	and		((a.cd_funcao_origem in (2314, 916)) OR pkg_date_utils.start_of(a.dt_inicio, 'mi') < pkg_date_utils.end_of(clock_timestamp(), 'DAY'))
	and		cpoe_reg_valido_ativacao(CASE WHEN coalesce(a.dt_lib_suspensao::text, '') = '' THEN  a.dt_fim  ELSE coalesce(a.dt_suspensao, a.dt_fim) END , a.dt_inicio, clock_timestamp(), a.cd_funcao_origem, null, null, null, null, null, null, qt_horas_quimio_p) = 'S'
	and		exists (SELECT 1 from prescr_solucao x where x.nr_seq_dialise_cpoe = a.nr_sequencia);	

	if (r_itens_w.qt_medic > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309525) || ' ' || r_itens_w.qt_medic, 1, 500);	-- Medic
	end if;

	if (r_itens_w.qt_mat > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309562) || ' ' || r_itens_w.qt_mat, 1, 500);		-- Mat
	end if;

	if (r_itens_w.qt_sne > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309526) || ' ' || r_itens_w.qt_sne, 1, 500);		-- SNE
	end if;

	if (r_itens_w.qt_supl > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309528) || ' ' || r_itens_w.qt_supl, 1, 500);	-- Supl
	end if;

	if (r_itens_w.qt_proc_lab > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309515) || '/' || wheb_mensagem_pck.get_texto(309524) || ' ' || r_itens_w.qt_proc_lab, 1, 500);	-- Proc/Lab
	end if;

	if (r_itens_w.qt_anat > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309523) || ' ' || r_itens_w.qt_anat, 1, 500);	-- Anat
	end if;

	if (r_itens_w.qt_sol > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309531) || ' ' || r_itens_w.qt_sol, 1, 500);		-- Sol
	end if;

	if (r_itens_w.qt_sol_hd > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309534) || ' ' || r_itens_w.qt_sol_hd, 1, 500);	-- Sol HD
	end if;

	if (r_itens_w.qt_sol_dp > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309538) || ' ' || r_itens_w.qt_sol_dp, 1, 500);	-- Sol DP
	end if;

	if (r_itens_w.qt_dieta > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309539) || ' ' || r_itens_w.qt_dieta, 1, 500);	-- Dieta
	end if;

	if (r_itens_w.qt_jejum > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309541) || ' ' || r_itens_w.qt_jejum, 1, 500);	-- Jejum
	end if;

	if (r_itens_w.qt_rec > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309544) || ' ' || r_itens_w.qt_rec, 1, 500);		-- Rec
	end if;

	if (r_itens_w.qt_nptnp > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309545) || '/' || wheb_mensagem_pck.get_texto(309546) || ' ' || r_itens_w.qt_nptnp, 1, 500);	-- NPTN/NPTP
	end if;

	if (r_itens_w.qt_npta > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309545) || ' ' || r_itens_w.qt_npta, 1, 500);	-- NPTA
	end if;
	if (r_itens_w.qt_sangue > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309547) || ' ' || r_itens_w.qt_sangue, 1, 500);	-- Sangue
	end if;

	if (r_itens_w.qt_leite > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309548) || ' ' || r_itens_w.qt_leite, 1, 500);	-- Leite
	end if;

	if (r_itens_w.qt_gas > 0) then
		ds_result_w	:= substr(ds_result_w || ' ' || wheb_mensagem_pck.get_texto(309550) || ' ' || r_itens_w.qt_gas, 1, 500);		-- Gas
	end if;

	if (substr(ds_result_w, 1, 1) = ' ') then
		ds_result_w	:= substr(ds_result_w, 2, length(ds_result_w));
	end if;

	return ds_result_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_utils_pck.obter_itens_pendentes (nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, ie_tipo_usuario_p text default null, qt_horas_quimio_p bigint default 0) FROM PUBLIC;
