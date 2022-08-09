-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_proc_repasse ( cd_convenio_p bigint, cd_edicao_amb_p bigint, cd_estabelecimento_p bigint, cd_medico_atend_p bigint, cd_medico_exec_p text, cd_prestador_p text, ie_funcao_p text, ie_participou_sus_p text, ie_responsavel_credito_p text, ie_tipo_atendimento_p bigint, ie_tipo_ato_sus_p bigint, ie_tipo_servico_sus_p bigint, nm_usuario_p text, nr_seq_etapa_checkup_p bigint, nr_seq_particip_p bigint, nr_seq_propaci_p bigint, cd_regra_p INOUT bigint, nr_seq_criterio_p INOUT bigint) AS $body$
DECLARE


cd_regra_w			bigint;
nr_seq_criterio_w		bigint;

cd_area_w			bigint;
ie_carater_inter_sus_w		varchar(100);

cd_categoria_w			varchar(100);
cd_equipamento_w		bigint;
cd_especialidade_medica_w	bigint;
cd_especialidade_w		bigint;
cd_estabelecimento_adic_w	smallint;
cd_estabelecimento_w		smallint;
cd_grupo_proc_aih_w		bigint;
cd_grupo_w			bigint;
cd_med_exec_proc_princ_w	varchar(255);
cd_medico_atendimento_w		varchar(100);
cd_medico_aval_w		varchar(10);
cd_medico_cir_w			varchar(100);
cd_medico_laudo_w		varchar(100);
cd_medico_prescr_w		varchar(100);
cd_medico_req_proc_w		varchar(100);
cd_medico_w			varchar(100);
cd_municipio_ibge_w		varchar(100);
cd_pessoa_func_w		varchar(255);
cd_plano_w			varchar(100);
cd_procedencia_w		bigint;
cd_procedimento_w		bigint;
cd_setor_w			bigint;
cd_situacao_glosa_w		bigint;
cd_tipo_acomodacao_w		bigint	:= 0;
cd_tipo_anestesia_w		varchar(255);
cd_tipo_pessoa_prest_w		bigint;
cd_tipo_pessoa_w		bigint;
dt_conta_w			timestamp;
dt_procedimento_w		timestamp;
ie_atend_retorno_w		varchar(100);
ie_clinica_w			bigint;
ie_med_exec_conveniado_w	varchar(100);
ie_origem_proced_w		bigint;
ie_pacote_w			varchar(100);
ie_regra_estab_atend_w		varchar(255);
ie_repassa_medico_w		varchar(100)	:= 'N';
ie_sexo_w			varchar(100);
ie_tipo_convenio_w		bigint;
nr_atendimento_w		bigint;
nr_cirurgia_w			bigint;
nr_interno_conta_w		bigint;
nr_prescricao_w			bigint;
nr_seq_classif_medico_w		bigint;
nr_seq_forma_org_w		bigint;
nr_seq_exame_w			bigint;
nr_seq_grupo_w			bigint;
nr_seq_proc_interno_w		bigint;
nr_seq_proc_princ_w		bigint;
nr_seq_subgrupo_w		bigint;
qt_porte_anestesico_w		double precision 	:= 0;
ie_via_acesso_w			varchar(1);
ie_carater_cirurgia_w		varchar(1);
tx_procedimento_w		double precision;
cd_tipo_procedimento_w		smallint;
nr_seq_categoria_w		bigint;
cd_setor_prescr_w		integer;
nr_seq_estagio_w		bigint;
ie_interno_w			varchar(2);
qt_idade_w			varchar(50);
cd_tipo_acomodacao_conv_w	bigint	:= 0;
cd_cbo_sus_w			procedimento_paciente.cd_cbo%type;
cd_setor_int_anterior_w		proc_criterio_repasse.cd_setor_int_anterior%type;
nr_seq_estagio_conta_w		conta_paciente.nr_seq_estagio_conta%type;
nr_seq_troca_medico_w		atendimento_troca_medico.nr_sequencia%type;
cd_medico_referido_w		atendimento_paciente.cd_medico_referido%type;
nr_seq_indicacao_w		tipo_indicacao.nr_sequencia%type;
cd_convenio_atend_w		convenio.cd_convenio%type;
ie_tipo_financiamento_w		proc_criterio_repasse.ie_tipo_financiamento%type;
ie_complexidade_w		proc_criterio_repasse.ie_complexidade%type;
ie_vinculo_medico_w		medico.ie_vinculo_medico%type;
nr_seq_terceiro_w		terceiro.nr_sequencia%type;
ie_obtem_regra_crit_w		varchar(1);
nr_seq_estagio_autor_w		proc_criterio_repasse.nr_seq_estagio_autor%type;
ie_cod_dia_semana_w		varchar(1);

cd_regra_repasse_c_w	regra_repasse_terceiro.cd_regra%type;
nr_seq_crit_c_w			proc_criterio_repasse.nr_sequencia%type;
nr_laudo_w				procedimento_paciente.nr_laudo%type;
cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;
cd_convenio_w			convenio.cd_convenio%type;
nr_seq_propaci_w		procedimento_paciente.nr_sequencia%type;
ie_regra_medico_w		proc_criterio_repasse.ie_regra_medico%type;
qt_minima_w				proc_criterio_repasse.qt_minima%type;
qt_maxima_w				proc_criterio_repasse.qt_maxima%type;
ie_tipo_data_w			proc_criterio_repasse.ie_tipo_data%type;
ie_tipo_restricao_w		proc_criterio_repasse.ie_tipo_restricao%type;
dt_nascimento_w			timestamp;
dt_prox_dia_util_w		timestamp;
dt_procedimento_start_w		timestamp;
ie_feriado_w			bigint;
ie_se_medico_plantao_w		bigint;
ie_se_medico_plantonista_w	varchar(1);
nr_seq_interno_w		bigint;
ie_obter_se_medico_socio_w	varchar(100);
ie_padrao_receb_w		varchar(255);
qt_dias_w			bigint;
ie_se_corpo_clinico_w		varchar(1);
ie_med_req_proc_cc_w		varchar(1);
ie_tipo_terceiro_w		proc_criterio_repasse.ie_tipo_terceiro%type;
dt_prox_dia_util_start_w	timestamp;
dt_conta_start_w		timestamp;
ie_medico_pertence_equipe_w	proc_criterio_repasse.ie_medico_pertence_equipe%type;
cd_medico_atual_w		atendimento_troca_medico.cd_medico_atual%type;
ie_pertence_equipe_w		varchar(1);
ie_cons_troca_medico_w		parametro_repasse.ie_considera_troca_medico%type;
ie_lib_laudo_proc_w		proc_criterio_repasse.ie_lib_laudo_proc%type;
qtd_laudo_proc_w			bigint;
qt_procedimento_w			bigint;

--Obter o criterio e a regra para gerar o repasse
C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.cd_regra,
		b.nr_seq_terceiro,
		b.nr_seq_estagio_autor,
		b.ie_regra_medico,
		b.ie_tipo_terceiro,
		b.ie_lib_laudo_proc,
		b.qt_minima,
		b.qt_maxima,
		b.ie_tipo_data,
		b.ie_tipo_restricao
	from 	proc_criterio_repasse b,
		regra_repasse_terceiro a
	where	1 = 1
	and (coalesce(b.nr_seq_detalhe_sus,'0') = '0' or
		exists (SELECT	1
		from	sus_detalhe_proc x
		where	x.ie_origem_proced	= ie_origem_proced_w
		and	x.cd_procedimento	= cd_procedimento_w
		and	x.nr_seq_detalhe	= b.nr_seq_detalhe_sus))
	and	coalesce(b.nr_seq_estagio_conta,coalesce(nr_seq_estagio_conta_w,0))	= coalesce(nr_seq_estagio_conta_w,0)
	and	coalesce(b.cd_medico_aval,coalesce(cd_medico_aval_w,'X'))	= coalesce(cd_medico_aval_w,'X')
	and	a.cd_estabelecimento				= cd_estabelecimento_w
	and	a.cd_regra					= b.cd_regra
	and	coalesce(b.cd_tipo_pessoa_prest,cd_tipo_pessoa_prest_w) = cd_tipo_pessoa_prest_w
	and	coalesce(to_char(b.ie_funcao),ie_funcao_p)			= ie_funcao_p
	and	coalesce(cd_tipo_pessoa, coalesce(cd_tipo_pessoa_w,-1))		= coalesce(cd_tipo_pessoa_w,-1)
	and	coalesce(cd_tipo_anestesia, coalesce(cd_tipo_anestesia_w, 'X'))	= coalesce(cd_tipo_anestesia_w, 'X')
	and	((coalesce(cd_municipio_ibge,cd_municipio_ibge_w) 	= cd_municipio_ibge_w) or (coalesce(cd_municipio_ibge::text, '') = ''))
	and 	coalesce(b.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w
	and	((coalesce(b.cd_procedimento::text, '') = '') or (coalesce(b.ie_origem_proced,ie_origem_proced_w)= ie_origem_proced_w))
	and	coalesce(b.nr_seq_proc_interno, nr_seq_proc_interno_w) = nr_seq_proc_interno_w
	and	coalesce(b.cd_grupo_proced,cd_grupo_w)		= cd_grupo_w
	and	coalesce(b.cd_situacao_glosa,cd_situacao_glosa_w) = cd_situacao_glosa_w
	and	coalesce(b.cd_especial_proced, cd_especialidade_w)	= cd_especialidade_w
	and (coalesce(b.cd_especialidade,cd_especialidade_medica_w) = cd_especialidade_medica_w or (coalesce(b.cd_especialidade::text, '') = ''))
	and	coalesce(b.cd_area_proced, cd_area_w)		= cd_area_w
	and	coalesce(b.cd_medico, coalesce(cd_medico_w,'0'))		= coalesce(cd_medico_w,'0')
	and 	((coalesce(b.cd_medico_laudo, cd_medico_laudo_w)	= cd_medico_laudo_w) or (coalesce(b.cd_medico_laudo::text, '') = ''))
	and	coalesce(b.cd_convenio, cd_convenio_p)		= cd_convenio_p
	and (coalesce(b.nr_seq_classificacao::text, '') = '' or (exists (select	1
								from	convenio_classif x
								where	x.cd_convenio	= cd_convenio_p
								and	x.nr_seq_classificacao	= b.nr_seq_classificacao)))
	and	coalesce(b.cd_categoria, coalesce(cd_categoria_w,'X'))	= coalesce(cd_categoria_w,'X')
	and	coalesce(b.ie_tipo_convenio, ie_tipo_convenio_w)	= ie_tipo_convenio_w
	and	coalesce(b.cd_setor_atendimento, cd_setor_w)	= cd_setor_w
	and	coalesce(b.ie_tipo_atendimento,ie_tipo_atendimento_p)= ie_tipo_atendimento_p
	and	((coalesce(cd_edicao_amb::text, '') = '') or (coalesce(b.cd_edicao_amb, cd_edicao_amb_p)	= cd_edicao_amb_p))
	and	((ie_pacote = 'T') or (ie_pacote = ie_pacote_w))
	and	coalesce(a.dt_limite_regra, dt_conta_w + 5)	>= dt_conta_start_w
	and	coalesce(a.dt_inicio_vigencia, dt_conta_w - 5) <= dt_conta_start_w
	and	((coalesce(cd_prestador::text, '') = '') or (cd_prestador = cd_prestador_p))
	and	((coalesce(ie_carater_inter_sus::text, '') = '') or (ie_carater_inter_sus = ie_carater_inter_sus_w))
	and	((coalesce(b.ie_honorario,'N') = 'N') or (ie_repassa_medico_w = 'S'))
	and	coalesce(b.ie_tipo_servico_sus, ie_tipo_servico_sus_p)	= ie_tipo_servico_sus_p
	and	coalesce(b.ie_tipo_ato_sus, ie_tipo_ato_sus_p)	= ie_tipo_ato_sus_p
	and	dt_conta_w between coalesce(b.dt_vigencia_inicial, dt_conta_w) and coalesce(b.dt_vigencia_final, dt_conta_w)
	and	(
		(b.ie_regra_dia = 'T') or (b.ie_regra_dia = 'U' and
			dt_prox_dia_util_start_w = dt_procedimento_start_w) or (b.ie_regra_dia = 'F' and
			dt_prox_dia_util_start_w <> dt_procedimento_start_w) or (b.ie_regra_dia = 'S' and (dt_prox_dia_util_start_w = dt_procedimento_start_w or (ie_cod_dia_semana_w = '7' and ie_feriado_w = 0))) or (b.ie_regra_dia = 'D' and (ie_cod_dia_semana_w = '1' or
			ie_feriado_w > 0)) or (b.ie_regra_dia = 'A' and
			ie_cod_dia_semana_w = '7' and ie_feriado_w = 0))
	and (coalesce(b.cd_grupo_proc_aih, cd_grupo_proc_aih_w)  = cd_grupo_proc_aih_w)
	and	(((coalesce(b.hr_inicial::text, '') = '' or coalesce(b.hr_final::text, '') = '') and (dt_procedimento_w between TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_inicial, 'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss')
				and TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_final, 'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss'))) or
		((b.hr_inicial	> b.hr_final) and (dt_procedimento_w between TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_inicial, 'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss')
				and TO_DATE(TO_CHAR(dt_procedimento_w+1,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_final, 'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss'))) or 
		((b.hr_final	> b.hr_inicial) and (dt_procedimento_w between TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_inicial, 'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss')
				and TO_DATE(TO_CHAR(dt_procedimento_w,'dd/mm/yyyy') || ' ' || coalesce(TO_CHAR(b.hr_final, 'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss'))))
	and 	((coalesce(ie_plantao,'T') = 'T') or
		((coalesce(ie_plantao,'T') = 'N') and (ie_se_medico_plantao_w = 0)) or
		((coalesce(ie_plantao,'T') = 'P') and (ie_se_medico_plantao_w = 1) 
			and	not exists (	select	1
						from	proc_crit_repasse_escala r
						where	r.nr_seq_criterio = b.nr_sequencia)) or
		((coalesce(ie_plantao,'T') = 'P') and (ie_se_medico_plantao_w = 1) 
			and	exists (select	1
					from	escala t,
						escala_diaria d
					where	t.nr_sequencia = d.nr_seq_escala
					and 	d.cd_pessoa_fisica = cd_medico_w
					and 	t.nr_sequencia in (	select	r.nr_seq_escala
									from	proc_crit_repasse_escala r
									where	r.nr_seq_criterio = b.nr_sequencia)
					and dt_procedimento_w between d.dt_inicio and d.dt_fim
									)))
	and 	((coalesce(b.ie_med_plantonista,'T') = 'T') or
		((coalesce(b.ie_med_plantonista,'T') = 'N') and (ie_se_medico_plantonista_w = 'N')) or
		((coalesce(b.ie_med_plantonista,'T') = 'S') and (ie_se_medico_plantonista_w = 'S')))
	and	((coalesce(b.cd_registro::text, '') = '') or
		 exists (select 1
			from 	sus_procedimento_registro x
			where 	x.cd_procedimento	= cd_procedimento_w
			and	x.ie_origem_proced	= ie_origem_proced_w
			and	x.cd_registro		= b.cd_registro
			and	coalesce(sus_obter_reg_proc_bpa(x.cd_procedimento,x.ie_origem_proced),x.cd_registro) = b.cd_registro))
	and	coalesce(b.nr_seq_grupo, nr_seq_grupo_w)		= nr_seq_grupo_w
	and	coalesce(b.nr_seq_subgrupo, nr_seq_subgrupo_w)	= nr_seq_subgrupo_w
	and	coalesce(b.nr_seq_forma_org, nr_seq_forma_org_w)	= nr_seq_forma_org_w
	and	((coalesce(ie_med_exec_socio, 'A') = 'A') or (ie_obter_se_medico_socio_w = ie_med_exec_socio))
	and	((coalesce(ie_cobra_pf_pj::text, '') = '') or (ie_cobra_pf_pj	= ie_padrao_receb_w))
	and	qt_dias_w between coalesce(QT_DIA_INICIAL, 0) and coalesce(QT_DIA_FINAL, 99)
	and	((ie_atend_retorno = 'S') or (ie_atend_retorno_w = 'N'))
	and	((coalesce(ie_participou_sus, 'A') = 'A') or (ie_tipo_convenio_w <> 3) or (coalesce(ie_participou_sus, 'X') = ie_participou_sus_p) or (ie_participou_sus_p = 'A'))
	and	coalesce(b.ie_clinica, coalesce(ie_clinica_w,0)) = coalesce(ie_clinica_w,0)
	and	(coalesce(b.ie_regra_medico,'X') = 'X' 
		or ((b.ie_regra_medico = '3' and cd_medico_exec_p = cd_medico_req_proc_w and (select substr(ie_se_corpo_clinico_w,1,1) ) = 'S' and substr(ie_med_req_proc_cc_w,1,1) = 'S')
		or (((cd_medico_exec_p = cd_medico_atendimento_w) and (coalesce(ie_regra_medico,'X') = '2')))
		or (b.ie_regra_medico = '4' and cd_medico_exec_p <> cd_medico_req_proc_w and substr(ie_se_corpo_clinico_w,1,1) = 'S' and substr(ie_med_req_proc_cc_w,1,1) = 'S')
		or (b.ie_regra_medico = '5' and substr(ie_se_corpo_clinico_w,1,1) = 'S' and substr(ie_med_req_proc_cc_w,1,1) = 'N')))
	and	coalesce(nr_seq_exame, coalesce(nr_seq_exame_w,0))	= coalesce(nr_seq_exame_w,0)
	and	((coalesce(ie_conveniado,'T') = 'T') or (ie_conveniado = ie_med_exec_conveniado_w))
	and (coalesce(b.cd_equipamento, coalesce(cd_equipamento_w, 0)) = coalesce(cd_equipamento_w, 0))
	and (coalesce(b.ie_situacao,'A') = 'A')
	and	coalesce(b.cd_med_exec_proc_princ, cd_med_exec_proc_princ_w) = cd_med_exec_proc_princ_w
	and	coalesce(coalesce(b.ie_via_acesso,ie_via_acesso_w),'X')			= coalesce(ie_via_acesso_w,'X')
	and	coalesce(coalesce(b.ie_carater_cirurgia,ie_carater_cirurgia_w),'X') 	= coalesce(ie_carater_cirurgia_w,'X')
	and	coalesce(b.qt_porte_anestesico, qt_porte_anestesico_w)	= qt_porte_anestesico_w
	and	coalesce(b.cd_procedencia, cd_procedencia_w)			= cd_procedencia_w
	and	coalesce(b.cd_pessoa_func, cd_pessoa_func_w)			= cd_pessoa_func_w
	and	coalesce(b.cd_medico_prescr, coalesce(cd_medico_prescr_w, 'X'))	= coalesce(cd_medico_prescr_w, 'X')
	and	coalesce(b.cd_medico_req, coalesce(cd_medico_req_proc_w, 'X'))	= coalesce(cd_medico_req_proc_w, 'X')
	and	coalesce(b.cd_plano, coalesce(cd_plano_w, '-1'))			= coalesce(cd_plano_w, '-1')
	and	coalesce(b.cd_tipo_acomodacao, coalesce(cd_tipo_acomodacao_w, -1)) = coalesce(cd_tipo_acomodacao_w, -1)
	and	coalesce(b.nr_seq_etapa_checkup, coalesce(nr_seq_etapa_checkup_p, 0))	= coalesce(nr_seq_etapa_checkup_p, 0)
	and	coalesce(b.ie_sexo, coalesce(ie_sexo_w, 'X'))				= coalesce(ie_sexo_w, 'X')
	and	tx_procedimento_w	between coalesce(b.tx_proc_minima,tx_procedimento_w) and coalesce(b.tx_proc_maxima,tx_procedimento_w)
	and	(coalesce(b.nr_seq_classif_medico, coalesce(nr_seq_classif_medico_w, 0))	= coalesce(nr_seq_classif_medico_w, 0)
		and	((coalesce(b.ie_medico_pertence_equipe,'N') = 'N')
			or (ie_medico_pertence_equipe = 'S' and ie_pertence_equipe_w = 'S')))
	and	coalesce(b.cd_tipo_procedimento,coalesce(cd_tipo_procedimento_w,0)) = coalesce(cd_tipo_procedimento_w,0)
	and	coalesce(coalesce(b.nr_seq_categoria,nr_seq_categoria_w),0)	= coalesce(nr_seq_categoria_w,0)
	and	coalesce(coalesce(b.cd_setor_proc_prescr,cd_setor_prescr_w),0)	= coalesce(cd_setor_prescr_w,0)
	and	coalesce(qt_idade_w,0) between coalesce(qt_idade_min,-1) and coalesce(qt_idade_max,999)
	and	coalesce(b.cd_cbo_sus,cd_cbo_sus_w)		= cd_cbo_sus_w
	and	coalesce(b.cd_setor_int_anterior,cd_setor_int_anterior_w)	= cd_setor_int_anterior_w
	and	coalesce(b.cd_tipo_acomod_atend, coalesce(cd_tipo_acomodacao_conv_w, -1)) = coalesce(cd_tipo_acomodacao_conv_w, -1)
	and	coalesce(b.cd_medico_cirurgia,coalesce(cd_medico_cir_w,'0'))	= coalesce(cd_medico_cir_w,'0')
	and	coalesce(b.cd_medico_atend,coalesce(cd_medico_atend_p,'0'))	= coalesce(cd_medico_atend_p,'0')
	and (coalesce(b.ie_com_material,'N') = 'N' 
		or (coalesce(b.ie_com_material,'N') = 'S' and 
			exists (	select	1
				from	material_atend_paciente x
				where	x.nr_seq_proc_princ = nr_seq_propaci_p
				and	coalesce(x.cd_motivo_exc_conta::text, '') = '')))
	and	coalesce(b.cd_medico_referido,coalesce(cd_medico_referido_w,'0'))	= coalesce(cd_medico_referido_w,'0')
	and	coalesce(b.nr_seq_indicacao,nr_seq_indicacao_w) = nr_seq_indicacao_w
	and 	coalesce(b.ie_tipo_financiamento, ie_tipo_financiamento_w)	= ie_tipo_financiamento_w
	and 	coalesce(b.ie_complexidade, ie_complexidade_w)		= ie_complexidade_w
	and	coalesce(b.cd_convenio_atend,cd_convenio_atend_w)  = cd_convenio_atend_w
	and (coalesce(b.ie_vinculo_medico::text, '') = '' or b.ie_vinculo_medico = ie_vinculo_medico_w)
	order by	coalesce(b.ie_prioridade,0),
		coalesce(b.nr_seq_estagio_conta,0),
		coalesce(CASE WHEN coalesce(b.ie_honorario_restricao, 'S')='S' THEN  b.ie_honorario  ELSE null END ,'N') desc,
		coalesce(b.cd_tipo_pessoa, 0),
		coalesce(b.cd_tipo_pessoa_prest, 0),
		coalesce(b.cd_medico, '0'),
		coalesce(b.cd_medico_prescr, 0),
		coalesce(b.cd_medico_req, 0),
		coalesce(b.cd_medico_referido,'0'),
		coalesce(b.cd_medico_laudo,'0'),
		coalesce(b.cd_med_exec_proc_princ,'0'),
		coalesce(b.cd_medico_aval,'0'),
		coalesce(b.cd_medico_cirurgia,'0'),
		coalesce(b.cd_medico_atend,'0'),
		coalesce(b.ie_funcao,0),
		coalesce(b.cd_procedimento, 0),
		coalesce(b.nr_seq_proc_interno, 0),
		coalesce(b.nr_seq_exame,0),
		coalesce(b.cd_grupo_proced, 0),
		coalesce(b.cd_especial_proced, 0),
		coalesce(b.cd_area_proced, 0),
		coalesce(b.nr_seq_forma_org, 0),
		coalesce(b.nr_seq_subgrupo, 0),
		coalesce(b.nr_seq_grupo, 0),
		coalesce(b.cd_tipo_procedimento,0),
		coalesce(b.cd_convenio, 0),
		coalesce(b.cd_categoria, '0'),
		coalesce(b.cd_convenio_atend,0),
		coalesce(b.cd_setor_atendimento, 0),
		coalesce(b.ie_tipo_atendimento, 0),
		coalesce(b.cd_edicao_amb, 0),
		coalesce(b.ie_tipo_servico_sus, 0),
		coalesce(b.ie_tipo_ato_sus, 0),
		coalesce(b.cd_grupo_proc_aih,0),
		coalesce(b.ie_carater_inter_sus, 0),
		coalesce(b.nr_seq_detalhe_sus,0),
		coalesce(b.ie_tipo_financiamento,'0'),
		coalesce(b.ie_complexidade,' '),
		coalesce(cd_cbo_sus,'0'),
		coalesce(b.cd_municipio_ibge, '0'),
		coalesce(b.cd_registro, 0),
		coalesce(b.cd_especialidade,0),
		coalesce(b.cd_equipamento, 0),
		coalesce(b.cd_plano, 0),
		coalesce(b.ie_med_plantonista,'T'),
		coalesce(b.cd_tipo_acomodacao,0),
		coalesce(b.nr_seq_classif_medico, 0),
		coalesce(b.ie_clinica, 0),
		coalesce(b.ie_via_acesso,' '),
		coalesce(b.qt_porte_anestesico,0),
		coalesce(b.ie_tipo_convenio,0),
		coalesce(b.nr_seq_classificacao, 0),
		coalesce(b.nr_seq_terceiro, 0),
		coalesce(b.ie_tipo_terceiro,' '),
		coalesce(b.cd_prestador,'0'),
		coalesce(cd_pessoa_func,'0'),
		coalesce(b.cd_tipo_anestesia,'0'),
		coalesce(b.ie_carater_cirurgia,' '),
		coalesce(b.cd_situacao_glosa,0),
		coalesce(b.cd_procedencia,0),
		coalesce(b.cd_tipo_acomod_atend,0),
		coalesce(b.nr_seq_etapa_checkup,0),
		coalesce(b.nr_seq_categoria,0),
		coalesce(b.cd_setor_proc_prescr,0),
		coalesce(b.nr_seq_estagio_autor,0),
		coalesce(b.cd_setor_int_anterior,0),
		coalesce(b.tx_proc_minima,0),
		coalesce(b.tx_proc_maxima,0),
		coalesce(b.qt_idade_min,0),
		coalesce(b.qt_idade_max,0),
		coalesce(b.ie_sexo,' '),
		coalesce(b.ie_cobra_pf_pj,' '),
		coalesce(b.ie_regra_medico,'X'),
		coalesce(b.nr_seq_indicacao,0);


BEGIN

select 	coalesce(a.dt_conta, a.dt_procedimento),
	a.cd_setor_atendimento,
	a.cd_procedimento,
	a.ie_origem_proced,
	a.nr_atendimento,
	CASE WHEN coalesce(a.nr_seq_proc_pacote::text, '') = '' THEN 'F' WHEN a.nr_seq_proc_pacote=a.nr_sequencia THEN 'P'  ELSE 'I' END ,
	a.cd_equipamento,
	c.CD_MEDICO_ATENDIMENTO,
	coalesce(a.cd_categoria, f.cd_categoria_parametro),
	a.dt_procedimento,
	e.ie_sexo,
	CASE WHEN coalesce(c.nr_atend_original::text, '') = '' THEN  'N'  ELSE 'S' END  ie_atend_retorno,
	ie_carater_inter_sus,
	a.nr_laudo,
	e.cd_pessoa_fisica,
	coalesce(a.cd_especialidade,0),
	coalesce(a.cd_situacao_glosa,0),
	a.nr_interno_conta,
	coalesce(a.nr_seq_proc_interno, 0),
	nr_seq_exame,
	coalesce(a.qt_porte_anestesico, -1),
	coalesce(c.cd_procedencia, 0),
	coalesce(a.cd_pessoa_fisica, 0),
	a.cd_medico_req,
	c.cd_estabelecimento,
	a.nr_seq_proc_princ,
	a.nr_prescricao,
	coalesce(a.nr_cirurgia,0),
	a.cd_convenio,
	c.ie_clinica,
	a.ie_via_acesso,
	a.ie_carater_cirurgia,
	coalesce(a.tx_procedimento,0),
	e.dt_nascimento,
	coalesce(a.cd_cbo,'X'),
	a.nr_sequencia,
	f.nr_seq_estagio_conta,
	c.cd_medico_referido,
	coalesce(c.nr_seq_indicacao,0),
	coalesce(d.cd_grupo_proc_aih, 0),
	d.cd_tipo_procedimento
into STRICT	dt_conta_w,
	cd_setor_w,
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_atendimento_w,
	ie_pacote_w,
	cd_equipamento_w,
	cd_medico_atendimento_w,
	cd_categoria_w,
	dt_procedimento_w,
	ie_sexo_w,
	ie_atend_retorno_w,
	ie_carater_inter_sus_w,
	nr_laudo_w,
	cd_pessoa_fisica_w,
	cd_especialidade_medica_w,
	cd_situacao_glosa_w,
	nr_interno_conta_w,
	nr_seq_proc_interno_w,
	nr_seq_exame_w,
	qt_porte_anestesico_w,
	cd_procedencia_w,
	cd_pessoa_func_w,
	cd_medico_req_proc_w,
	cd_estabelecimento_adic_w,
	nr_seq_proc_princ_w,
	nr_prescricao_w,
	nr_cirurgia_w,
	cd_convenio_w,
	ie_clinica_w,
	ie_via_acesso_w,
	ie_carater_cirurgia_w,
	tx_procedimento_w,
	dt_nascimento_w,
	cd_cbo_sus_w,
	nr_seq_propaci_w,
	nr_seq_estagio_conta_w,
	cd_medico_referido_w,
	nr_seq_indicacao_w,
	cd_grupo_proc_aih_w,
	cd_tipo_procedimento_w
from	procedimento d,
	pessoa_fisica e,
	atendimento_paciente c,
	conta_paciente f,
	procedimento_paciente a
where	a.nr_atendimento	= c.nr_atendimento
and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
and	a.nr_interno_conta	= f.nr_interno_conta
and	d.cd_procedimento	= a.cd_procedimento
and	d.ie_origem_proced 	= a.ie_origem_proced
and	a.nr_sequencia     	= nr_seq_propaci_p;

cd_medico_laudo_w	:= obter_medico_laudo_sequencia(nr_laudo_w,'C');
cd_municipio_ibge_w	:= obter_compl_pf(cd_pessoa_fisica_w,1,'CDM');
cd_tipo_acomodacao_w	:= obter_tipo_acomod_data(nr_atendimento_w, dt_procedimento_w);
cd_plano_w		:= obter_dado_atend_cat_conv(nr_atendimento_w, dt_conta_w, cd_convenio_w, cd_categoria_w, 'P');
cd_setor_int_anterior_w		:= coalesce(OBTER_ULTIMO_SETOR_INT_PROPACI(nr_seq_propaci_w),0);
qt_idade_w		:= somente_numero(substr(Obter_Idade(dt_nascimento_w,clock_timestamp(),'A'),1,50));
cd_setor_prescr_w	:=substr(obter_setor_prescricao(nr_prescricao_w,'C'),1,100);

select 	b.cd_grupo_proc,
	b.cd_especialidade,
	b.cd_area_procedimento
into STRICT 	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w
from 	estrutura_procedimento_v b
where	b.cd_procedimento 	= cd_procedimento_w
and 	b.ie_origem_proced 	= ie_origem_proced_w;

select	coalesce(max(a.cd_tipo_pessoa),-1)
into STRICT	cd_tipo_pessoa_prest_w
from	pessoa_juridica a
where	a.cd_cgc	= cd_prestador_p;

select	max(a.cd_tipo_pessoa)
into STRICT	cd_tipo_pessoa_w
from	pessoa_juridica a,
	convenio b
where	b.cd_cgc	= a.cd_cgc
and	b.cd_convenio	= cd_convenio_p;

select	coalesce(max(ie_conveniado), 'N')
into STRICT	ie_med_exec_conveniado_w
from	medico_convenio
where	cd_pessoa_fisica	= cd_medico_exec_p
and	cd_convenio		= cd_convenio_p;

select	coalesce(max(ie_repassa_medico),'N')
into STRICT	ie_repassa_medico_w
from	regra_honorario
where	cd_regra	= ie_responsavel_credito_p;

/* Obter Estrutura do procedimento SUS Unificado*/

begin
select	c.nr_seq_grupo,
	b.nr_seq_subgrupo,
	a.nr_seq_forma_org,
	coalesce(a.ie_tipo_financiamento,'X'),
	coalesce(a.ie_complexidade,'X')
into STRICT	nr_seq_grupo_w,
	nr_seq_subgrupo_w,
	nr_seq_forma_org_w,
	ie_tipo_financiamento_w,
	ie_complexidade_w
from	sus_procedimento a,
	sus_forma_organizacao b,
	sus_subgrupo c
where	b.nr_seq_subgrupo	= c.nr_sequencia
and	a.nr_seq_forma_org	= b.nr_sequencia
and	a.cd_procedimento	= cd_procedimento_w
and	a.ie_origem_proced	= ie_origem_proced_w  LIMIT 1;
exception
when others then
	nr_seq_grupo_w		:= 0;
	nr_seq_subgrupo_w	:= 0;
	nr_seq_forma_org_w	:= 0;
	ie_tipo_financiamento_w := 'X';
	ie_complexidade_w	:= 'X';
end;

cd_medico_w		:= cd_medico_exec_p;

ie_pertence_equipe_w	:= 'N';


select 	coalesce(max(ie_regra_estab_atend),'N'),
	coalesce(max(ie_considera_troca_medico), 'N')
into STRICT	ie_regra_estab_atend_w,
	ie_cons_troca_medico_w
from	parametro_repasse
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_cons_troca_medico_w = 'S') then

	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_troca_medico_w
	from	atendimento_troca_medico
	where	nr_atendimento	= nr_atendimento_w
	and	dt_conta_w	>= dt_troca;	
	
	if (coalesce(nr_seq_troca_medico_w,0) = 0) then
	
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_troca_medico_w
		from	atendimento_troca_medico
		where	nr_atendimento	= nr_atendimento_w;
		
	end if;
else
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_troca_medico_w
	from	atendimento_troca_medico
	where	nr_atendimento	= nr_atendimento_w;	
end if;


if (nr_seq_troca_medico_w > 0) then
	select	coalesce(max(nr_seq_classif_medico), 0),
		max(cd_medico_atual)
	into STRICT	nr_seq_classif_medico_w,
		cd_medico_atual_w
	from	atendimento_troca_medico
	where	nr_atendimento		= nr_atendimento_w
	and	nr_sequencia	 	= nr_seq_troca_medico_w;
	
	if (cd_medico_atual_w IS NOT NULL AND cd_medico_atual_w::text <> '') and (cd_medico_atual_w <> cd_medico_w) then
		ie_pertence_equipe_w	:= substr(Obter_se_pf_equipe_atend(cd_medico_atual_w,cd_medico_w),1,1);
	end if;	
end if;

select	max(b.cd_medico)
into STRICT	cd_medico_aval_w
from	med_avaliacao_paciente b
where	b.nr_atendimento	= nr_atendimento_w;

if (ie_regra_estab_atend_w = 'S') then -- afstringari 186033 29/12/2009
	cd_estabelecimento_w	:= cd_estabelecimento_adic_w;
else
	cd_estabelecimento_w	:= cd_estabelecimento_p;
end if;

select	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio		= cd_convenio_p;

select	max(cd_medico_cirurgiao),
	max(cd_tipo_anestesia)
into STRICT	cd_medico_cir_w,
	cd_tipo_anestesia_w
from	cirurgia
where	nr_cirurgia	= nr_cirurgia_w;

select	max(cd_medico)
into STRICT	cd_medico_prescr_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_w;

select	coalesce(max(cd_medico_executor),0)
into STRICT	cd_med_exec_proc_princ_w
from	procedimento_paciente
where	nr_sequencia	= nr_seq_proc_princ_w;

begin
select	nr_seq_categoria,
	ie_vinculo_medico
into STRICT    nr_seq_categoria_w,
	ie_vinculo_medico_w
from    medico
where   cd_pessoa_fisica = cd_medico_w;
exception
when others then
	nr_seq_categoria_w	:= null;
	ie_vinculo_medico_w	:= null;
end;

nr_seq_interno_w	:= obter_atecaco_atendimento(nr_atendimento_w);

--Obter o tipo de acomodacao e o convenio do atendimento.
select	coalesce(max(cd_tipo_acomodacao),0),
	max(cd_convenio)
into STRICT	cd_tipo_acomodacao_conv_w,
	cd_convenio_atend_w
from	atend_categoria_convenio
where	nr_atendimento	= nr_atendimento_w
and	nr_seq_interno	= nr_seq_interno_w;

if (coalesce(nr_cirurgia_w,0)	<> 0) then
	begin
	select	max(a.nr_seq_estagio)
	into STRICT	nr_seq_estagio_w
	from	autorizacao_convenio a
	where	a.nr_atendimento	= nr_atendimento_w
	and	somente_numero(obter_cirurgia_autor_convenio(a.nr_sequencia,'NR'))	= nr_cirurgia_w;
	
	if (nr_seq_estagio_w IS NOT NULL AND nr_seq_estagio_w::text <> '') then
		begin
		select	max(a.ie_interno)
		into STRICT	ie_interno_w
		from	estagio_autorizacao a
		where	a.nr_sequencia	= nr_seq_estagio_w;
		end;
	end if;
	
	end;
end if;	

dt_procedimento_start_w	:= PKG_DATE_UTILS.start_of(dt_procedimento_w,'dd',0);
ie_cod_dia_semana_w	:= OBTER_COD_DIA_SEMANA(dt_procedimento_start_w);
dt_prox_dia_util_w	:= obter_proximo_dia_util(cd_estabelecimento_w, dt_procedimento_w);
dt_conta_start_w	:= PKG_DATE_UTILS.start_of(dt_conta_w,'dd',0);
dt_prox_dia_util_start_w	:= PKG_DATE_UTILS.start_of(dt_prox_dia_util_w, 'dd', 0);
ie_feriado_w		:= obter_se_feriado(cd_estabelecimento_w, dt_procedimento_w);
ie_se_medico_plantao_w	:= obter_se_medico_plantao(cd_medico_w,dt_procedimento_w);
ie_se_medico_plantonista_w	:= obter_se_medico_plantonista(cd_estabelecimento_w,cd_medico_w,cd_convenio_p,cd_prestador_p,cd_especialidade_w);
ie_obter_se_medico_socio_w	:= OBTER_SE_MEDICO_SOCIO(cd_estabelecimento_w, cd_medico_exec_p);
begin
ie_padrao_receb_w		:= obter_dados_medico(cd_medico_exec_p, 'IERECEB');
exception
when others then
	ie_padrao_receb_w	:= null;
end;
qt_dias_w		:= PKG_DATE_UTILS.extract_field('DAY', dt_procedimento_w);
ie_se_corpo_clinico_w	:= obter_se_corpo_clinico(cd_medico_exec_p);
ie_med_req_proc_cc_w	:= obter_se_corpo_clinico(cd_medico_req_proc_w);

cd_regra_repasse_c_w	:= null;
nr_seq_crit_c_w		:= null;

--Retorna o criterio e a regra para gerar o repasse
open	C01;
loop
fetch	C01 into
	nr_seq_criterio_w,
	cd_regra_w,
	nr_seq_terceiro_w,
	nr_seq_estagio_autor_w,
	ie_regra_medico_w,
	ie_tipo_terceiro_w,
	ie_lib_laudo_proc_w,
	qt_minima_w,	
	qt_maxima_w,
	ie_tipo_data_w,
	ie_tipo_restricao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ie_obtem_regra_crit_w	:= 'S';
	
	if (coalesce(qt_minima_w, -1) <> -1 and coalesce(qt_maxima_w, 0) <> 0 and coalesce(ie_tipo_restricao_w, 'X') <> 'X' ) then
		if (coalesce(ie_tipo_restricao_w, 'X') = 'C' ) then
				select
				count(1)
				into STRICT 
				qt_procedimento_w 
				from	procedimento d,
					pessoa_fisica e,
					atendimento_paciente c,
					conta_paciente f,
					procedimento_paciente a
				where	a.nr_atendimento	= c.nr_atendimento
				and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
				and	a.nr_interno_conta	= f.nr_interno_conta
				and	d.cd_procedimento	= a.cd_procedimento
				and	d.ie_origem_proced 	= a.ie_origem_proced
				and a.nr_interno_conta	= nr_interno_conta_w
				and a.ie_origem_proced	= ie_origem_proced_w
				and  d.cd_procedimento = cd_procedimento_w
				;
		
		end if;
		
		if (coalesce(ie_tipo_restricao_w, 'X') = 'A' ) then
				select
				count(1)
				into STRICT 
				qt_procedimento_w 
				from	procedimento d,
					pessoa_fisica e,
					atendimento_paciente c,
					conta_paciente f,
					procedimento_paciente a
				where	a.nr_atendimento	= c.nr_atendimento
				and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
				and	a.nr_interno_conta	= f.nr_interno_conta
				and	d.cd_procedimento	= a.cd_procedimento
				and	d.ie_origem_proced 	= a.ie_origem_proced
				and a.nr_atendimento 	= nr_atendimento_w
				and a.ie_origem_proced	= ie_origem_proced_w
				and d.cd_procedimento 	= cd_procedimento_w;
		
		end if;
		
		if (coalesce(ie_tipo_restricao_w, 'X') = 'D' ) then
			if (coalesce(ie_tipo_data_w, 'X') = 'E' ) then
					select
					count(1)
					into STRICT 
					qt_procedimento_w 
					from	procedimento d,
						pessoa_fisica e,
						atendimento_paciente c,
						conta_paciente f,
						procedimento_paciente a
					where	a.nr_atendimento	= c.nr_atendimento
					and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
					and	a.nr_interno_conta	= f.nr_interno_conta
					and	d.cd_procedimento	= a.cd_procedimento
					and	d.ie_origem_proced 	= a.ie_origem_proced
					and a.dt_procedimento between trunc(a.dt_procedimento,'dd') and fim_dia(a.dt_procedimento);
			
			end if;
			
				if (coalesce(ie_tipo_data_w, 'X') = 'H' ) then
						select
						count(1)
						into STRICT 
						qt_procedimento_w 
						from	procedimento d,
							pessoa_fisica e,
							atendimento_paciente c,
							conta_paciente f,
							procedimento_paciente a
						where	a.nr_atendimento	= c.nr_atendimento
						and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
						and	a.nr_interno_conta	= f.nr_interno_conta
						and	d.cd_procedimento	= a.cd_procedimento
						and	d.ie_origem_proced 	= a.ie_origem_proced
						and a.dt_procedimento between trunc(clock_timestamp(),'dd') and fim_dia(clock_timestamp());
				
				end if;
			
				if (coalesce(ie_tipo_data_w, 'X') = 'M' ) then
						select
						count(1)
						into STRICT 
						qt_procedimento_w 
						from	procedimento d,
							pessoa_fisica e,
							atendimento_paciente c,
							conta_paciente f,
							procedimento_paciente a
						where	a.nr_atendimento	= c.nr_atendimento
						and	c.cd_pessoa_fisica	= e.cd_pessoa_fisica
						and	a.nr_interno_conta	= f.nr_interno_conta
						and	d.cd_procedimento	= a.cd_procedimento
						and	d.ie_origem_proced 	= a.ie_origem_proced
						and a.dt_ligacao_integracao between trunc(clock_timestamp(),'mm') and  last_day(clock_timestamp());
				
				end if;
		
		end if;
		
		
		if (qt_minima_w >= qt_procedimento_w or qt_maxima_w <= qt_procedimento_w  ) then
			ie_obtem_regra_crit_w 	:= 'N';
		end if;	
	end if;	
	
	if (nr_seq_terceiro_w IS NOT NULL AND nr_seq_terceiro_w::text <> '') then
		if (coalesce(obter_se_terceiro_pessoa(cd_medico_w,nr_seq_terceiro_w, dt_procedimento_w),'S') = 'N') then
			ie_obtem_regra_crit_w	:= 'N';
			goto final;
		end if;	
	end if;
	
	if (coalesce(OBTER_SE_PROC_CRIT_REPASSE_DIA(nr_seq_criterio_w, ie_cod_dia_semana_w),'S') = 'N') then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;	
	
	if (coalesce(obter_se_mat_repasse_valido(nr_interno_conta_w,nr_seq_criterio_w),'S') = 'N') then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;	
	
	if (coalesce(substr(obter_se_equipe_criterio(nr_seq_propaci_p,nr_seq_criterio_w),1,1),'S') = 'N') then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;
	
	if (coalesce(obter_se_regra_adic(nr_seq_criterio_w,nr_seq_propaci_p,nr_seq_particip_p),'S') = 'N') then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;
	
	if (coalesce(coalesce(substr(OBTER_ESTAGIO_AUTOR(nr_seq_estagio_autor_w,'C'),1,2),ie_interno_w),'0')	<> coalesce(ie_interno_w,'0')) then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;
	
	if (obter_se_regra_med_crit_rep(cd_medico_prescr_w, ie_regra_medico_w) = 'N') then
		ie_obtem_regra_crit_w	:= 'N';
		goto final;
	end if;
	
	if (ie_tipo_terceiro_w IS NOT NULL AND ie_tipo_terceiro_w::text <> '') then
		if (coalesce(obter_tipo_pessoa_terceiro(cd_medico_w,dt_conta_w,ie_tipo_terceiro_w),'X') <> ie_tipo_terceiro_w) then
			ie_obtem_regra_crit_w	:= 'N';
			goto final;
		end if;
	end if;
	
	if (coalesce(ie_lib_laudo_proc_w,'N') = 'S') and (nr_laudo_w IS NOT NULL AND nr_laudo_w::text <> '') then
		if (coalesce(Obter_se_laudo_liberado(nr_laudo_w),'S') = 'N') then
			ie_obtem_regra_crit_w	:= 'N';
			goto final;
		else
			select 	count(*)
			into STRICT 	qtd_laudo_proc_w
			from 	procedimento_repasse 
			where 	nr_seq_procedimento = nr_seq_propaci_p
			and	coalesce(ie_bloq_laudo_liberado,'N') = 'S';
			
			if (qtd_laudo_proc_w > 0) then
				ie_obtem_regra_crit_w	:= 'N';
				goto final;
			end if;
		end if;		
	end if;
	
	<<final>>	
	if (ie_obtem_regra_crit_w = 'S') then
		
		cd_regra_repasse_c_w := cd_regra_w;
		nr_seq_crit_c_w	:= nr_seq_criterio_w;
	end if;
	
end	loop;
close	C01;

cd_regra_p			:= cd_regra_repasse_c_w;
nr_seq_criterio_p	:= nr_seq_crit_c_w;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_proc_repasse ( cd_convenio_p bigint, cd_edicao_amb_p bigint, cd_estabelecimento_p bigint, cd_medico_atend_p bigint, cd_medico_exec_p text, cd_prestador_p text, ie_funcao_p text, ie_participou_sus_p text, ie_responsavel_credito_p text, ie_tipo_atendimento_p bigint, ie_tipo_ato_sus_p bigint, ie_tipo_servico_sus_p bigint, nm_usuario_p text, nr_seq_etapa_checkup_p bigint, nr_seq_particip_p bigint, nr_seq_propaci_p bigint, cd_regra_p INOUT bigint, nr_seq_criterio_p INOUT bigint) FROM PUBLIC;
