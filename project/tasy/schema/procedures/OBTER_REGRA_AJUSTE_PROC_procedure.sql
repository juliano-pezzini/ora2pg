-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_regra_ajuste_proc ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_video_p text, dt_vigencia_p timestamp, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_funcao_medico_p bigint, qt_idade_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_usuario_convenio_p text, cd_plano_p text, ie_clinica_p bigint, cd_empresa_ref_p bigint, ie_sexo_p text, tx_ajuste_p INOUT bigint, tx_ajuste_custo_oper_p INOUT bigint, tx_ajuste_medico_p INOUT bigint, tx_ajuste_partic_p INOUT bigint, tx_ajuste_filme_p INOUT bigint, vl_negociado_p INOUT bigint, ie_preco_informado_p INOUT text, ie_glosa_p INOUT text, cd_procedimento_esp_p INOUT bigint, nr_seq_regra_preco_p INOUT bigint, cd_edicao_ajuste_p INOUT bigint, vl_medico_p INOUT bigint, vl_custo_operacional_p INOUT bigint, qt_filme_p INOUT bigint, nr_auxiliares_p INOUT bigint, qt_porte_anestesico_p INOUT bigint, pr_glosa_p INOUT bigint, vl_glosa_p INOUT bigint, cd_motivo_exc_conta_p INOUT bigint, ie_atend_retorno_p text, qt_dias_internacao_p bigint, ie_autor_particular_p INOUT text, cd_convenio_glosa_p INOUT bigint, cd_categoria_glosa_p INOUT text, nr_sequencia_p INOUT bigint, ie_tipo_atend_bpa_p bigint, cd_procedencia_p bigint, ie_beira_leito_p text, ie_spect_p text, cd_cgc_prestador_p text, cd_equipamento_p bigint, nr_seq_tipo_acidente_p bigint, cd_especialidade_medica_p bigint, vl_filme_p INOUT bigint, nr_seq_cobertura_p bigint, cd_setor_atend_prescr_p bigint, nr_seq_classif_atend_p bigint, cd_medico_resp_p text, ie_carater_inter_sus_p text, cd_dependente_p bigint, nr_seq_grupo_rec_p bigint, nr_seq_origem_p bigint, ie_paciente_deficiente_p text, nr_seq_classif_medico_p bigint, ie_estrangeiro_p text default null) AS $body$
DECLARE


qt_pontos_w			preco_amb.qt_pontuacao%type;
cd_procedimento_esp_w		bigint		:= 0;
nr_seq_regra_preco_w		bigint		:= 0;
ie_preco_informado_w   		varchar(1)		:= null;
ie_glosa_w   			varchar(1)		:= null;
dt_inicio_vigencia_w		timestamp;
tx_ajuste_w			double precision		:= 1;
vl_negociado_w			double precision		:= null;
cd_edicao_amb_w			integer		:= 0;
cd_edicao_ajuste_w		integer		:= 0;
nr_sequencia_w         		bigint		:= 0;
cd_grupo_w			bigint		:= 0;
cd_especialidade_w		bigint		:= 0;
cd_area_w			bigint		:= 0;
tx_ajuste_geral_w			double precision		:= 1;

vl_ch_honorarios_w		double precision := 1;
vl_ch_custo_oper_w	double precision := 1;
vl_m2_filme_w		double precision := 0;
tx_ajuste_proc_w		double precision := 0;


vl_medico_w		double precision		:= null;
vl_custo_operacional_w	double precision		:= null;
qt_filme_w		double precision		:= null;
nr_auxiliares_w		smallint		:= null;
qt_porte_anestesico_w	smallint		:= null;

tx_ajuste_custo_oper_w	double precision		:= 1;
tx_ajuste_medico_w	double precision		:= 1;
tx_ajuste_partic_w		double precision	:= 1;
tx_ajuste_filme_w		double precision		:= 1;
ie_credenciado_w		varchar(01);
pr_glosa_w		double precision		:= 0;
vl_glosa_w		double precision		:= 0;
qt_idade_w		bigint;
qt_reg_w			bigint;
ie_origem_proced_w	bigint;
cd_motivo_exc_conta_w	bigint;
ie_prioridade_ajuste_proc_w	varchar(01);
qt_dias_internacao_w	bigint;
dt_vigencia_w		timestamp;

ie_classificacao_w		varchar(01);
ie_autor_particular_w	varchar(1)	:= 'N';
cd_convenio_glosa_w	integer;
cd_categoria_glosa_w	varchar(10);
ie_edicao_convenio_w	varchar(1);
tx_ajuste_tabela_serv_w	double precision;
nr_seq_grupo_w		bigint	:= 0;
nr_seq_subgrupo_w	bigint	:= 0;
nr_seq_forma_org_w	bigint	:= 0;
nr_seq_cbhpm_edicao_w	bigint;
ie_vinculo_medico_w	smallint;
vl_filme_neg_w		double precision;
ie_complexidade_sus_w	varchar(2);
nr_seq_grupo_lab_w	bigint;
nr_seq_classif_w	bigint;
nr_seq_area_int_w	bigint;
nr_seq_espec_int_w	bigint;
nr_seq_grupo_int_w	bigint;
tx_regra_w		double precision;
ie_tx_edicao_amb_regra_w varchar(1);	
qt_regra_edicao_conv_w	bigint;
ie_order_estrangeiro_w	smallint;
nr_seq_estrutura_w	regra_ajuste_proc.nr_seq_estrutura%type;

c01 CURSOR FOR
SELECT 	coalesce(ie_preco_informado,'N'),
	coalesce(ie_glosa,'L'),
	cd_procedimento_esp,
	CASE WHEN coalesce(IE_CONSISTE_EDICAO_PRIOR,'N')='S' THEN  CASE WHEN obter_se_proced_edicao(cd_procedimento_p, ie_origem_proced_w, cd_edicao_amb, ie_prior_edicao_ajuste)='S' THEN  cd_edicao_amb  ELSE cd_edicao_amb_w END   ELSE coalesce(cd_edicao_amb,cd_edicao_amb_w) END ,
	nr_seq_regra_preco,
	coalesce(tx_ajuste, tx_ajuste_geral_w),
	coalesce(vl_proc_ajustado,0),
	vl_medico,
	vl_custo_operacional,
	qt_filme,
	nr_auxiliares,
	qt_porte_anestesico,
	nr_sequencia,
	tx_ajuste_custo_oper,
	tx_ajuste_medico,
	coalesce(tx_ajuste_partic, tx_ajuste_medico),
	tx_ajuste_filme,
	CASE WHEN ie_glosa='P' THEN pr_glosa WHEN ie_glosa='D' THEN pr_glosa WHEN ie_glosa='1' THEN  pr_glosa  ELSE 0 END ,
	CASE WHEN ie_glosa='R' THEN vl_glosa WHEN ie_glosa='4' THEN vl_glosa  ELSE 0 END ,
	cd_motivo_exc_conta,
	ie_autor_particular,
	coalesce(cd_convenio_glosa,0),
	cd_categoria_glosa,
	vl_filme,
	tx_ajuste,
	coalesce(ie_tx_edicao_amb_regra,'N'),	
	CASE WHEN coalesce(ie_estrangeiro,'N')='R' THEN 4 WHEN coalesce(ie_estrangeiro,'N')='E' THEN 3 WHEN coalesce(ie_estrangeiro,'N')='A' THEN 2 WHEN coalesce(ie_estrangeiro,'N')='N' THEN 1 END  ie_order_estrangeiro
from 	regra_ajuste_proc
where	cd_estabelecimento				= cd_estabelecimento_p
and	cd_convenio				= cd_convenio_p
and	((coalesce(cd_categoria::text, '') = '') or (cd_categoria = cd_categoria_p))
and	((coalesce(cd_procedimento::text, '') = '') or (cd_procedimento = cd_procedimento_p))
and	((coalesce(ie_origem_proced::text, '') = '') or (ie_origem_proced = ie_origem_proced_w))
and	((coalesce(cd_grupo_proc::text, '') = '') or (cd_grupo_proc = cd_grupo_w))
and	((coalesce(cd_especialidade::text, '') = '') or (cd_especialidade = cd_especialidade_w))
and	((coalesce(cd_area_procedimento::text, '') = '') or (cd_area_procedimento = cd_area_w))
and	((coalesce(cd_tipo_acomodacao::text, '') = '') or (cd_tipo_acomodacao = cd_tipo_acomodacao_p))
and	((coalesce(ie_tipo_atendimento::text, '') = '') or (ie_tipo_atendimento = ie_tipo_atendimento_p))
and	((coalesce(cd_setor_atendimento::text, '') = '') or (cd_setor_atendimento = cd_setor_atendimento_p))
and	((coalesce(cd_setor_atend_prescr::text, '') = '') or (cd_setor_atend_prescr = cd_setor_atend_prescr_p))
and	ie_situacao         					= 'A'
and	((ie_credenciado = 'N') or (ie_credenciado_w = 'S'))
and 	dt_vigencia_p between ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_inicio_vigencia) and
				ESTABLISHMENT_TIMEZONE_UTILS.endOfDay(coalesce(dt_final_vigencia,dt_vigencia_w))
and	qt_idade_w between coalesce(qt_idade_min, qt_idade_w) and coalesce(qt_idade_max, qt_idade_w)
and	((coalesce(nr_seq_proc_interno::text, '') = '') or (nr_seq_proc_interno = nr_seq_proc_interno_p))
and	((coalesce(nr_seq_exame::text, '') = '') or (nr_seq_exame = nr_seq_exame_lab_p))
and	((coalesce(cd_plano::text, '') = '') or (cd_plano = coalesce(cd_plano_p, 0)))
and	((coalesce(nr_seq_estrutura::text, '') = '') or (nr_seq_estrutura = nr_seq_estrutura_w))
and	((coalesce(ie_clinica::text, '') = '') or (ie_clinica = ie_clinica_p))
and	((coalesce(cd_empresa_ref::text, '') = '') or (cd_empresa_ref = cd_empresa_ref_p))
and	((coalesce(ie_sexo::text, '') = '') or (ie_sexo = ie_sexo_p))
and	((coalesce(cd_medico::text, '') = '') or (cd_medico = cd_medico_p))
and	((ie_prioridade_ajuste_proc_w = 'N') or ((ie_prior_edicao_ajuste  = 'N') or (coalesce(cd_edicao_amb,cd_edicao_amb_w)  = cd_edicao_amb_w)))
--and 	((cd_edicao_amb is null) or (obter_se_proc_edicao2(cd_procedimento_p, ie_origem_proced_p, cd_edicao_amb) = 'S'))
and	((coalesce(ie_atend_retorno_p::text, '') = '') or (coalesce(ie_atend_retorno,'A') = 'A') or (ie_atend_retorno = ie_atend_retorno_p))
and	qt_dias_internacao_w between coalesce(qt_dias_inter_inicio, qt_dias_internacao_w) and coalesce(qt_dias_inter_final, qt_dias_internacao_w)
--and	((ie_video_p is null) or (ie_utiliza_video is null) or (nvl(ie_utiliza_video, 'N')	= ie_video_p))
and	((coalesce(ie_utiliza_video,'N') = 'N') or ((ie_utiliza_video = 'S')	and (coalesce(ie_video_p,'N') = 'S')))
and 	((coalesce(cd_edicao_amb::text, '') = '') or (obter_se_edicao_ativa(cd_edicao_amb) = 'A'))
and 	((coalesce(ie_edicao_convenio,'N') = 'N') or (ie_edicao_convenio = 'S' AND ie_edicao_convenio_w = 'N'))
and	coalesce(nr_seq_grupo,nr_seq_grupo_w)		= nr_seq_grupo_w
and	coalesce(nr_seq_subgrupo,nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
and	coalesce(nr_seq_forma_org,nr_seq_forma_org_w)	= nr_seq_forma_org_w
and	((coalesce(ie_beira_leito,'A') = 'A') or (coalesce(ie_beira_leito,'A') = coalesce(ie_beira_leito_p,'A')))
and	((coalesce(ie_tipo_atend_bpa::text, '') = '') or (ie_tipo_atend_bpa = coalesce(ie_tipo_atend_bpa_p,0))) --Foi alterado NVL para zero pois estava encontrando a regra para atendimentos sem tipo BPA informado OS 898512 - Geliard e Heckmann
and	((coalesce(cd_procedencia::text, '') = '') or (cd_procedencia = coalesce(cd_procedencia_p,cd_procedencia)))
and	((coalesce(ie_spect,'N') = 'N') or ((ie_spect = 'S')	and (coalesce(ie_spect_p,'N') = 'S')))
and	((coalesce(cd_cgc_prestador::text, '') = '') or (cd_cgc_prestador = coalesce(cd_cgc_prestador_p, cd_cgc_prestador)))
and	((coalesce(ie_vinculo_medico::text, '') = '') or (ie_vinculo_medico = coalesce(ie_vinculo_medico_w, ie_vinculo_medico)))
and	((coalesce(cd_equipamento::text, '') = '') or (cd_equipamento = coalesce(cd_equipamento_p, 0)))
and	((coalesce(nr_seq_tipo_acidente::text, '') = '') or (nr_seq_tipo_acidente = coalesce(nr_seq_tipo_acidente_p, 0)))
and	((coalesce(cd_especialidade_medica::text, '') = '') or (cd_especialidade_medica = coalesce(cd_especialidade_medica_p, 0)))
and 	((coalesce(nr_seq_equipe::text, '') = '') or (obter_se_medico_equipe(nr_seq_equipe, cd_medico_p) = 'S'))
and (coalesce(ie_complexidade_sus,coalesce(ie_complexidade_sus_w,'X')) = coalesce(ie_complexidade_sus_w,'X'))
and	((coalesce(nr_seq_grupo_lab::text, '') = '') or (nr_seq_grupo_lab = coalesce(nr_seq_grupo_lab_w,0)))
and	((coalesce(nr_seq_cobertura::text, '') = '') or (nr_seq_cobertura = coalesce(nr_seq_cobertura_p,0)))
and	((coalesce(nr_seq_classif::text, '') = '') or (nr_seq_classif = coalesce(nr_seq_classif_w,0)))
and	((coalesce(nr_seq_classificacao::text, '') = '') or (nr_seq_classificacao = coalesce(nr_seq_classif_atend_p,0)))
and	((coalesce(cd_usuario_convenio::text, '') = '') or (cd_usuario_convenio = substr(cd_usuario_convenio_p, qt_pos_inicial, qt_pos_final)))
and	((coalesce(nr_seq_area_int::text, '') = '') or (nr_seq_area_int = nr_seq_area_int_w))
and	((coalesce(nr_seq_espec_int::text, '') = '') or (nr_seq_espec_int = nr_seq_espec_int_w))
and	((coalesce(nr_seq_grupo_int::text, '') = '') or (nr_seq_grupo_int = nr_seq_grupo_int_w))
and (coalesce(cd_medico_resp, coalesce(cd_medico_resp_p,'0')) = coalesce(cd_medico_resp_p,'0'))
and	coalesce(cd_dependente, coalesce(cd_dependente_p, 0)) = coalesce(cd_dependente_p, 0)
and	coalesce(nr_seq_grupo_rec, coalesce(nr_seq_grupo_rec_p,0)) = coalesce(nr_seq_grupo_rec_p,0)
and	coalesce(nr_seq_origem, coalesce(nr_seq_origem_p,0)) = coalesce(nr_seq_origem_p,0)
and	((coalesce(ie_paciente_deficiente,'S') = 'S') or ((coalesce(ie_paciente_deficiente,'S') = 'N') and (coalesce(ie_paciente_deficiente_p,'N') = 'N')))
and ((coalesce(ie_estrangeiro,'N') = 'N')
	or ((coalesce(ie_estrangeiro,'N') = 'A') and (coalesce(ie_estrangeiro_p,'N') in ('R','E')))
	or (coalesce(ie_estrangeiro,'N') = coalesce(ie_estrangeiro_p,'N') ))
and	coalesce(nr_seq_classif_medico, coalesce(nr_seq_classif_medico_p,0)) = coalesce(nr_seq_classif_medico_p,0)
and	coalesce(ie_carater_inter_sus,coalesce(ie_carater_inter_sus_p,0)) = coalesce(ie_carater_inter_sus_p,0)
order by
	coalesce(cd_medico,'0'),
	coalesce(nr_seq_proc_interno,0),
	coalesce(nr_seq_exame,0),
	coalesce(cd_procedimento, 0),
	coalesce(nr_seq_estrutura, 0),	
	coalesce(cd_grupo_proc, 0),
	coalesce(cd_especialidade, 0),
	coalesce(cd_area_procedimento, 0),
	coalesce(nr_seq_grupo_lab,0),
	coalesce(nr_seq_classif,0),
	coalesce(cd_tipo_acomodacao, 0),
	coalesce(ie_tipo_atendimento, 0),
	coalesce(cd_setor_atendimento, 0),
	coalesce(cd_empresa_ref,0),
	coalesce(ie_clinica,'0'),
	coalesce(cd_plano,' '),
	coalesce(cd_usuario_convenio, 0),
	ie_credenciado,
	dt_inicio_vigencia,
	coalesce(cd_proc_referencia,0),
	coalesce(qt_idade_min,0),
	coalesce(nr_seq_proc_interno,0),
	coalesce(cd_categoria,'0'),
	coalesce(cd_procedencia,0),
	coalesce(cd_cgc_prestador,'0'),
	coalesce(ie_vinculo_medico, 0),
	coalesce(ie_utiliza_video,'N'),
	coalesce(ie_spect,'N'),
	coalesce(cd_equipamento,0),
	coalesce(nr_seq_equipe,0),
	coalesce(nr_seq_cobertura,0),
	coalesce(cd_especialidade_medica,0),
	coalesce(nr_seq_classificacao,0),
	coalesce(nr_seq_grupo_int, 0),
	coalesce(nr_seq_espec_int, 0),
	coalesce(nr_seq_area_int, 0),
	coalesce(cd_medico_resp, '0'),
	coalesce(cd_dependente, 0),
	coalesce(nr_seq_grupo_rec,0),
	coalesce(nr_seq_origem,0),
	coalesce(nr_seq_classif_medico,0),
	ie_order_estrangeiro,
	coalesce(ie_carater_inter_sus,0);

c02 CURSOR FOR
	SELECT	coalesce(tx_ajuste_geral,1)
	from	preco_servico a,
		convenio_servico b
	where	a.cd_tabela_servico	= b.cd_tabela_servico
	and	b.cd_convenio		= cd_convenio_p
	and	b.cd_estabelecimento = cd_estabelecimento_p
	and	b.cd_categoria		= cd_categoria_p
	--and	b.dt_liberacao_tabela	<= dt_vigencia_p
	and	PKG_DATE_UTILS.start_of(dt_vigencia_p,'dd',0)	between b.dt_liberacao_tabela and coalesce(b.dt_termino, dt_vigencia_p)
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_procedimento		= cd_procedimento_p
	and	dt_vigencia_p between a.dt_inicio_vigencia and coalesce(a.dt_vigencia_final, dt_vigencia_p)
	and 	coalesce(b.ie_situacao,'A')	= 'A'
	and (coalesce(a.dt_inativacao::text, '') = '' or a.dt_inativacao > dt_vigencia_p)
	order by coalesce(b.nr_prioridade,1),
			a.dt_inicio_vigencia desc,
			a.vl_servico desc;

BEGIN

dt_vigencia_w	:= clock_timestamp();

if (dt_vigencia_p > clock_timestamp()) then
	dt_vigencia_w	:= dt_vigencia_p;
end if;

select	coalesce(max(ie_prioridade_ajuste_proc), 'N')
into STRICT	ie_prioridade_ajuste_proc_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

ie_origem_proced_w	:= ie_origem_proced_p;
qt_idade_w		:= coalesce(qt_idade_p,0);
qt_dias_internacao_w	:= coalesce(qt_dias_internacao_p, 0);

/* Trocado pela function abaixo. OS 334552 - aaheckler.
select	max(ie_vinculo_medico)
into	ie_vinculo_medico_w
from	medico
where	cd_pessoa_fisica = cd_medico_p;*/
ie_vinculo_medico_w	:= coalesce(obter_vinculo_medico(cd_medico_p, cd_estabelecimento_p),0);

/* obter estrutura do procedimento */

select 		coalesce(max(cd_grupo_proc),0),
		coalesce(max(cd_especialidade),0),
		coalesce(max(cd_area_procedimento),0),
		max(ie_classificacao)
into STRICT		cd_grupo_w,
		cd_especialidade_w,
		cd_area_w,
		ie_classificacao_w
from		estrutura_procedimento_v
where		cd_procedimento 	= cd_procedimento_p
and		ie_origem_proced	= ie_origem_proced_w;

nr_seq_area_int_w	:= 0;
nr_seq_espec_int_w	:= 0;
nr_seq_grupo_int_w	:= 0;

nr_seq_grupo_lab_w 	:= 0;
if (nr_seq_exame_lab_p IS NOT NULL AND nr_seq_exame_lab_p::text <> '') then
	begin
	select	nr_seq_grupo,
		nr_seq_grupo_int
	into STRICT	nr_seq_grupo_lab_w,
		nr_seq_grupo_int_w
	from	exame_laboratorio
	where	nr_seq_exame = nr_seq_exame_lab_p;
	exception
		when others then
			nr_seq_grupo_lab_w := 0;
			nr_seq_grupo_int_w := 0;
	end;
	
	--Estrutura Interna (Exame Lab)
	if (coalesce(nr_seq_grupo_int_w,0) > 0) then
		begin
		select 	nr_seq_especialidade,
			nr_seq_area
		into STRICT	nr_seq_espec_int_w,
			nr_seq_area_int_w
		from 	estrutura_interna_v
		where	nr_seq_grupo = nr_seq_grupo_int_w;
		exception
		when others then
			nr_seq_area_int_w	:= 0;
			nr_seq_espec_int_w	:= 0;
			nr_seq_grupo_int_w	:= 0;
		end;
	end if;
	
end if;	

nr_seq_classif_w := 0;
if (coalesce(nr_seq_proc_interno_p,0) > 0) then
	select	coalesce(max(nr_seq_classif),0),
		coalesce(max(nr_seq_grupo_int),0)
	into STRICT	nr_seq_classif_w,
		nr_seq_grupo_int_w
	from	proc_interno
	where	nr_sequencia = nr_seq_proc_interno_p;
	
	--Estrutura Interna (Proc Interno)
	if (coalesce(nr_seq_grupo_int_w,0) > 0) then
		begin
		select 	nr_seq_especialidade,
			nr_seq_area
		into STRICT	nr_seq_espec_int_w,
			nr_seq_area_int_w
		from 	estrutura_interna_v
		where	nr_seq_grupo = nr_seq_grupo_int_w;
		exception
		when others then
			nr_seq_area_int_w	:= 0;
			nr_seq_espec_int_w	:= 0;
			nr_seq_grupo_int_w	:= 0;
		end;
	end if;
end if;


if (ie_origem_proced_p	= 7) then

	begin
	select	nr_seq_grupo,
		nr_seq_subgrupo,
		nr_seq_forma_org
	into STRICT	nr_seq_grupo_w,
		nr_seq_subgrupo_w,
		nr_seq_forma_org_w
	from	sus_estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced	= ie_origem_proced_p;
	exception
		when others then
		nr_seq_grupo_w		:= 0;		/* felipe martini e almir os135256 */
		nr_seq_subgrupo_w	:= 0;
		nr_seq_forma_org_w	:= 0;
	end;

end if;
/* trocar origem proced qdo cbhpm com ajuste amb ou invertido */


/* precisa incluir origem na chamada da define preco procedimento para eliminar */

if (cd_grupo_w		= 0)	and (cd_especialidade_w	= 0)	and (cd_area_w		= 0)	then
	begin
	select count(*)
	into STRICT	 qt_reg_w
	from	 procedimento where		cd_procedimento	= cd_procedimento_p
	and		ie_origem_proced	= ie_origem_proced_w LIMIT 1;
	
	if (qt_reg_w	= 0) then
		 begin
		 if (ie_origem_proced_w = 1) then
			ie_origem_proced_w := 5;
		 elsif (ie_origem_proced_w = 5) then
			ie_origem_proced_w := 1;
		 end if;
		 /* obter estrutura do procedimento */

		 select coalesce(max(cd_grupo_proc),0),
			  coalesce(max(cd_especialidade),0),
			  coalesce(max(cd_area_procedimento),0)
		 into STRICT	  cd_grupo_w,
			  cd_especialidade_w,
			  cd_area_w
		 from	  estrutura_procedimento_v
		 where    cd_procedimento 	= cd_procedimento_p
		 and	  ie_origem_proced	= ie_origem_proced_w;
		 end;
	end if;
	end;
end if;

/*      	obter edicao da amb  */

if (ie_prioridade_ajuste_proc_w		= 'N') then
	select	coalesce(max(cd_edicao_amb),0),
		coalesce(max(tx_ajuste_geral),1)
	into STRICT	cd_edicao_amb_w,
		tx_ajuste_geral_w
	from	convenio_amb
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_convenio		= cd_convenio_p
	and	coalesce(ie_situacao,'A')	= 'A'
	and	cd_categoria		= cd_categoria_p
	and	dt_inicio_vigencia	=
		(SELECT max(dt_inicio_vigencia)
		from		convenio_amb a
		where		a.cd_estabelecimento	= cd_estabelecimento_p
		and		coalesce(a.ie_situacao,'A')	= 'A'
		and		a.cd_convenio		= cd_convenio_p
		and		a.cd_categoria		= cd_categoria_p
		and		a.dt_inicio_vigencia 	<= dt_vigencia_p);
else
	SELECT * FROM obter_edicao_proc_conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_vigencia_p, cd_procedimento_p, cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w, ie_origem_proced_p) INTO STRICT cd_edicao_amb_w, vl_ch_honorarios_w, vl_ch_custo_oper_w, vl_m2_filme_w, dt_inicio_vigencia_w, tx_ajuste_geral_w, nr_seq_cbhpm_edicao_w;
end if;


if (ie_classificacao_w <> '1') then

	/*felipe martini os109691 em 23/09/2008  inicio*/

	open c02;
	loop
	fetch c02 into
		tx_ajuste_tabela_serv_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		exit;
		end;
	end loop;
	close c02;
	if (coalesce(tx_ajuste_tabela_serv_w::text, '') = '') then
		tx_ajuste_tabela_serv_w	:= 1;
	end if;

	tx_ajuste_w			:= tx_ajuste_tabela_serv_w;
	tx_ajuste_custo_oper_w		:= tx_ajuste_tabela_serv_w;
	tx_ajuste_medico_w		:= tx_ajuste_tabela_serv_w;
	tx_ajuste_partic_w		:= tx_ajuste_tabela_serv_w;
	tx_ajuste_filme_w		:= tx_ajuste_tabela_serv_w;
	tx_ajuste_geral_w		:= tx_ajuste_tabela_serv_w;
	/*felipe martini os109691 em 23/09/2008  fim*/

else
	tx_ajuste_w			:= tx_ajuste_geral_w;
	tx_ajuste_custo_oper_w		:= tx_ajuste_geral_w;
	tx_ajuste_medico_w		:= tx_ajuste_geral_w;
	tx_ajuste_partic_w		:= tx_ajuste_medico_w;
	tx_ajuste_filme_w		:= tx_ajuste_geral_w;
end if;

ie_credenciado_w	:= obter_se_medico_credenciado(cd_estabelecimento_p, cd_medico_p, cd_convenio_p, null, null, cd_categoria_p,cd_setor_atendimento_p, cd_plano_p, dt_vigencia_p, null, to_char(cd_funcao_medico_p), null);
ie_complexidade_sus_w	:= sus_obter_complexidade_proced(cd_procedimento_p,ie_origem_proced_w, 'C');

ie_edicao_convenio_w:= 'N';

select 	count(1)
into STRICT	qt_regra_edicao_conv_w
from 	regra_ajuste_proc where	ie_situacao = 'A'
and 	cd_convenio = cd_convenio_p
and 	cd_estabelecimento = cd_estabelecimento_p
and 	ie_edicao_convenio = 'S' LIMIT 1;

if (qt_regra_edicao_conv_w > 0) then
	ie_edicao_convenio_w	:= coalesce(verifica_se_proc_conv(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, dt_vigencia_p, cd_procedimento_p, ie_origem_proced_p, nr_seq_proc_interno_p, ie_tipo_atendimento_p),'N');	
end if;

if (coalesce(cd_edicao_amb_w::text, '') = '') then
	cd_edicao_amb_w	:= 0;
end if;

select	coalesce(max(nr_seq_estrutura),0)
into STRICT	nr_seq_estrutura_w
from	pi_estrutura_cad
where	nr_seq_proc_int = nr_seq_proc_interno_p;

open c01;
loop
fetch c01 into
		ie_preco_informado_w,
		ie_glosa_w,
		cd_procedimento_esp_w,
		cd_edicao_ajuste_w,
		nr_seq_regra_preco_w,
		tx_ajuste_w,
		vl_negociado_w,
		vl_medico_w,
		vl_custo_operacional_w,
		qt_filme_w,
		nr_auxiliares_w,
		qt_porte_anestesico_w,
		nr_sequencia_w,
		tx_ajuste_custo_oper_w,
		tx_ajuste_medico_w,
		tx_ajuste_partic_w,
		tx_ajuste_filme_w,
		pr_glosa_w,
		vl_glosa_w,
		cd_motivo_exc_conta_w,
		ie_autor_particular_w,
		cd_convenio_glosa_w,
		cd_categoria_glosa_w,
		vl_filme_neg_w,
		tx_regra_w,
		ie_tx_edicao_amb_regra_w,
		ie_order_estrangeiro_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		tx_ajuste_w			:= tx_ajuste_w;		
		end;
end loop;
close c01;

if (coalesce(ie_tx_edicao_amb_regra_w,'N') = 'S') and (coalesce(tx_regra_w,0) <> 0) then
	tx_ajuste_w:= tx_ajuste_w * tx_ajuste_geral_w;
end if;

tx_ajuste_p		:= tx_ajuste_w;
tx_ajuste_custo_oper_p	:= coalesce(tx_ajuste_custo_oper_w, tx_ajuste_w);
tx_ajuste_medico_p	:= coalesce(tx_ajuste_medico_w, tx_ajuste_w);
tx_ajuste_partic_p	:= coalesce(tx_ajuste_partic_w, tx_ajuste_w);
tx_ajuste_filme_p	:= coalesce(tx_ajuste_filme_w, tx_ajuste_w);
ie_preco_informado_p	:= ie_preco_informado_w;
ie_glosa_p		:= ie_glosa_w;
cd_procedimento_esp_p	:= cd_procedimento_esp_w;
nr_seq_regra_preco_p	:= nr_seq_regra_preco_w;
cd_edicao_ajuste_p	:= cd_edicao_ajuste_w;
vl_negociado_p		:= vl_negociado_w;
vl_custo_operacional_p	:= vl_custo_operacional_w;
vl_medico_p		:= vl_medico_w;
qt_filme_p		:= qt_filme_w;
nr_auxiliares_p		:= nr_auxiliares_w;
qt_porte_anestesico_p	:= qt_porte_anestesico_w;
pr_glosa_p		:= pr_glosa_w;
vl_glosa_p		:= vl_glosa_w;
ie_autor_particular_p	:= ie_autor_particular_w;
cd_convenio_glosa_p	:= cd_convenio_glosa_w;
cd_categoria_glosa_p	:= cd_categoria_glosa_w;
nr_sequencia_p		:= nr_sequencia_w;
vl_filme_p   		:= vl_filme_neg_w;

cd_motivo_exc_conta_p	:= cd_motivo_exc_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_regra_ajuste_proc ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_categoria_p text, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_video_p text, dt_vigencia_p timestamp, cd_tipo_acomodacao_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_medico_p text, cd_funcao_medico_p bigint, qt_idade_p bigint, nr_seq_exame_lab_p bigint, nr_seq_proc_interno_p bigint, cd_usuario_convenio_p text, cd_plano_p text, ie_clinica_p bigint, cd_empresa_ref_p bigint, ie_sexo_p text, tx_ajuste_p INOUT bigint, tx_ajuste_custo_oper_p INOUT bigint, tx_ajuste_medico_p INOUT bigint, tx_ajuste_partic_p INOUT bigint, tx_ajuste_filme_p INOUT bigint, vl_negociado_p INOUT bigint, ie_preco_informado_p INOUT text, ie_glosa_p INOUT text, cd_procedimento_esp_p INOUT bigint, nr_seq_regra_preco_p INOUT bigint, cd_edicao_ajuste_p INOUT bigint, vl_medico_p INOUT bigint, vl_custo_operacional_p INOUT bigint, qt_filme_p INOUT bigint, nr_auxiliares_p INOUT bigint, qt_porte_anestesico_p INOUT bigint, pr_glosa_p INOUT bigint, vl_glosa_p INOUT bigint, cd_motivo_exc_conta_p INOUT bigint, ie_atend_retorno_p text, qt_dias_internacao_p bigint, ie_autor_particular_p INOUT text, cd_convenio_glosa_p INOUT bigint, cd_categoria_glosa_p INOUT text, nr_sequencia_p INOUT bigint, ie_tipo_atend_bpa_p bigint, cd_procedencia_p bigint, ie_beira_leito_p text, ie_spect_p text, cd_cgc_prestador_p text, cd_equipamento_p bigint, nr_seq_tipo_acidente_p bigint, cd_especialidade_medica_p bigint, vl_filme_p INOUT bigint, nr_seq_cobertura_p bigint, cd_setor_atend_prescr_p bigint, nr_seq_classif_atend_p bigint, cd_medico_resp_p text, ie_carater_inter_sus_p text, cd_dependente_p bigint, nr_seq_grupo_rec_p bigint, nr_seq_origem_p bigint, ie_paciente_deficiente_p text, nr_seq_classif_medico_p bigint, ie_estrangeiro_p text default null) FROM PUBLIC;

