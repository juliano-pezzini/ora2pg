-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_valor_med_exec (nr_seq_procedimento_p bigint, ie_honorario_p text) RETURNS bigint AS $body$
DECLARE


/* Rafael Caldas. 09/01/2008.
   Para o convênio Sulamérica nos casos onde deve gerar um procedimento para cada participante
   estava gerando o procedimento do médico executor com o valor do procedimento, consequentemente duplicando o valor
   pois os valores dos participantes também são gerados. */
vl_participantes_w	double precision;
vl_medico_w		double precision;
vl_procedimento_w	double precision;
vl_retorno_w		double precision;
vl_anestesista_w	double precision;
vl_auxiliares_w		double precision;
vl_custo_operacional_w	double precision;
vl_materiais_w		double precision;
vl_custos_w		double precision;
vl_partic_w		double precision;
cd_setor_entrada_w	bigint;
nr_atendimento_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

cd_convenio_w		bigint;
cd_estabelecimento_w	bigint;
ie_resp_credito_w	varchar(10);
ie_tipo_atendimento_w	bigint;
ie_tiss_tipo_guia_honor_w varchar(10);
ie_regra_valor_w	varchar(10);
ie_tiss_tipo_guia_w	varchar(10);
ie_funcao_medico_w	varchar(10);
cd_cgc_prestador_w	varchar(100);
ie_valor_informado_w	varchar(2);
cd_plano_convenio_w	varchar(10);
dt_procedimento_w	timestamp;


BEGIN

if (coalesce(nr_seq_procedimento_p,0) > 0) then
	select	sum(coalesce(a.vl_conta,0)),
		max(ie_funcao)
	into STRICT	vl_participantes_w,
		ie_funcao_medico_w
	from	procedimento_participante a
	where	a.nr_sequencia	= nr_seq_procedimento_p;

	select	sum(coalesce(a.vl_anestesista, 0)),
		sum(coalesce(a.vl_auxiliares, 0)),
		sum(coalesce(a.vl_custo_operacional, 0)),
		sum(coalesce(a.vl_materiais, 0)),
		sum(CASE WHEN a.ie_tiss_tipo_guia_honor='6' THEN  0  ELSE coalesce(a.vl_medico, 0) END ),
		sum(coalesce(a.vl_procedimento,0)),
		sum(coalesce(obter_valor_participante(a.nr_sequencia),0))
	into STRICT	vl_anestesista_w,
		vl_auxiliares_w,
		vl_custo_operacional_w,
		vl_materiais_w,
		vl_medico_w,
		vl_procedimento_w,
		vl_partic_w
	from	procedimento_paciente a
	where	a.nr_sequencia			= nr_seq_procedimento_p;

	select	max(a.cd_convenio_parametro),
		max(a.cd_estabelecimento),
		max(b.ie_responsavel_credito),
		max(c.ie_tipo_atendimento),
		max(b.ie_tiss_tipo_guia_honor),
		max(a.nr_atendimento),
		max(b.ie_tiss_tipo_guia),
		coalesce(max(b.cd_cgc_prestador_tiss), max(b.cd_cgc_prestador)),
		max(b.cd_procedimento),
		max(b.ie_origem_proced),
		coalesce(max(b.ie_valor_informado),'N'),
		max(b.dt_procedimento)
	into STRICT	cd_convenio_w,
		cd_estabelecimento_w,
		ie_resp_credito_w,
		ie_tipo_atendimento_w,
		ie_tiss_tipo_guia_honor_w,
		nr_atendimento_w,
		ie_tiss_tipo_guia_w,
		cd_cgc_prestador_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		ie_valor_informado_w,
		dt_procedimento_w
	from	atendimento_paciente c,
		conta_paciente a,
		procedimento_paciente b
	where	c.nr_atendimento	= a.nr_atendimento
	and	a.nr_interno_conta	= b.nr_interno_conta
	and	b.nr_sequencia		= nr_seq_procedimento_p;

	select	max(OBTER_SETOR_ATENDIMENTO(nr_atendimento_w))
	into STRICT	cd_setor_entrada_w
	;

	select	b.cd_plano_convenio
	into STRICT	cd_plano_convenio_w
	from	atend_categoria_convenio b,
		atendimento_paciente a
	where	a.nr_atendimento	= b.nr_atendimento
	and	b.nr_seq_interno	= obter_atecaco_atendimento(a.nr_atendimento)
	and	a.nr_atendimento	= nr_atendimento_w;

	/*OS88871 - se for honorário de SP/SADT, gerar a guia do hospital com vl_procedimento pois ele soma o valor do médico ao vl_custos_w */

	if (tiss_obter_se_honor_spsadt(cd_convenio_w,
					cd_estabelecimento_w,
					ie_resp_credito_w,
					ie_tipo_atendimento_w,
					cd_setor_entrada_w,
					'S') = 'S') and (ie_honorario_p		   = 'N') and (ie_tiss_tipo_guia_honor_w = '4') then
		vl_medico_w		:= 0;
	end if;

	/* OS83905 - 25/02/2008 - O valor do custo operacional lista na conta pq possui este valor na tabela, mas não soma ao total da conta!*/

	if (vl_procedimento_w = 0) then
		vl_custo_operacional_w	:= 0;
	end if;

	SELECT * FROM tiss_obter_regra_valor_proc(cd_estabelecimento_w, cd_convenio_w, ie_tiss_tipo_guia_w, cd_cgc_prestador_w, ie_resp_credito_w, cd_procedimento_w, ie_origem_proced_w, vl_medico_w, vl_custo_operacional_w, vl_materiais_w, vl_procedimento_w, ie_regra_valor_w, 0, null, vl_partic_w, ie_honorario_p, null, cd_plano_convenio_w, dt_procedimento_w, null) INTO STRICT vl_procedimento_w, ie_regra_valor_w;

-- incluso o if. OS: 117796, deve busca primeiro a regra de valor.
	if (coalesce(vl_procedimento_w,0) <> 0) and (coalesce(ie_regra_valor_w,'X') <> 'X') then
		vl_custos_w	:= vl_procedimento_w;
	else
		vl_custos_w	:= vl_anestesista_w + vl_auxiliares_w + vl_custo_operacional_w + vl_materiais_w + vl_medico_w;
		/*
		if	(ie_valor_informado_w	= 'S') then
			vl_custos_w	:= vl_procedimento_w;
		end if; */
	end if;

	if (coalesce(vl_custos_w, 0) > 0) then
		if (vl_custos_w = coalesce(vl_procedimento_w, 0) + 0.01) then  --lhalves/dsantos 02/03/2010, estava gerando diferença de 0,01 centavo na guia.
			vl_retorno_w	:= coalesce(vl_procedimento_w, 0);
		else
			vl_retorno_w	:= vl_custos_w;
		end if;
	else
		vl_retorno_w	:= coalesce(vl_procedimento_w, 0) - coalesce(vl_participantes_w, 0);
	end if;

end if;

return vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_valor_med_exec (nr_seq_procedimento_p bigint, ie_honorario_p text) FROM PUBLIC;

