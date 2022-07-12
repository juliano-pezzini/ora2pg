-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_valorizacao_pck.pls_define_adic_horario ( dados_conta_proc_p pls_cta_valorizacao_pck.dados_conta_proc, dados_prestador_exec_p pls_cta_valorizacao_pck.dados_prestador_exec, dados_prestador_prot_p pls_cta_valorizacao_pck.dados_prestador_prot, dados_conta_p pls_cta_valorizacao_pck.dados_conta, dados_procedimento_p pls_cta_valorizacao_pck.dados_procedimento, dados_beneficiario_p pls_cta_valorizacao_pck.dados_beneficiario, ie_tipo_tabela_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dados_adic_horario_p INOUT pls_cta_valorizacao_pck.dados_adic_horario) AS $body$
DECLARE

					
/*
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
********* SE FOR ALTERAR ALGUMA COISA NESTA ROTINA, FAVOR VERIFICAR A pls_cta_valorizacao_pck a function pls_gerencia_regra_horario***************************************************
********* HOUVE DUPLICACAO DE CODIGO PARA MANTERMOS AS REGRAS DE HORARIO FUNCIONANDO NOS DOIS MODELOS ****************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
**************************************************************************************************************************************************************************************
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

*/

					
ie_liberado_w		varchar(1);
dia_semana_w            smallint       := 0;
ie_excecao_w		varchar(1);
ie_dt_procedimento_w	varchar(1);
dt_inicio_proc_w	pls_conta_proc.dt_inicio_proc%type;
dt_fim_proc_w		pls_conta_proc.dt_fim_proc%type;
ie_preco_prestador_w	varchar(1)	:= 'N';
ie_preco_reembolso_w	varchar(1)	:= 'N';
ie_preco_pos_estab_w	varchar(1)	:= 'N';
ie_preco_copartic_w	varchar(1)	:= 'N';
ie_preco_intercambio_w	varchar(1)	:= 'N';
ie_preco_cobr_prev_w	varchar(1)	:= 'N';
ie_tipo_regra_feriado_w	pls_parametros.ie_tipo_feriado%type;
tx_procedimento_w       pls_proc_criterio_horario.tx_procedimento%type;
tx_medico_w             pls_proc_criterio_horario.tx_medico%type;
tx_anestesista_w        pls_proc_criterio_horario.tx_anestesista%type;
tx_auxiliares_w         pls_proc_criterio_horario.tx_auxiliares%type;
tx_custo_operacional_w  pls_proc_criterio_horario.tx_custo_operacional%type;
tx_materiais_w          pls_proc_criterio_horario.tx_materiais%type;
nr_seq_regra_w		pls_proc_criterio_horario.nr_sequencia%type;
ie_preco_w		pls_plano.ie_preco%type;
sg_estado_out_w		pessoa_juridica.sg_estado%type;
sg_estado_int_w		pessoa_juridica.sg_estado%type;
sg_estado_w		pessoa_juridica.sg_estado%type;
ie_nacional_w		pls_congenere.ie_nacional%type;
ie_tipo_intercambio_w	varchar(1);
dt_vigencia_w		pls_conta_proc.dt_procedimento%type;
dia_feriado_w		varchar(1);
ie_tipo_feriado_w	feriado.ie_tipo_feriado%type;
cd_edicao_w		pls_regra_preco_proc.cd_edicao_amb%type;
dt_fim_regra_w		pls_conta_proc.dt_fim_proc%type;
dt_inicio_regra_w	pls_conta_proc.dt_inicio_proc%type;
cd_municipio_ibge_w	compl_pessoa_fisica.cd_municipio_ibge%type;
ie_tipo_congenere_w	pls_congenere.ie_tipo_congenere%type;
qt_partic_proc_w	integer;
ie_restringe_partic_w	varchar(1);
nr_seq_prest_inter_w	pls_conta_proc_v.nr_seq_prest_inter%type;
dt_procedimento_w	pls_conta_proc.dt_procedimento%type;
nr_seq_nota_cobranca_w	ptu_nota_cobranca.nr_sequencia%type;
ie_acres_urg_emer_w	pls_proc_criterio_horario.ie_acres_urg_emer%type;

C01 CURSOR FOR
        SELECT
			nr_sequencia,
            ie_prioridade,
            nr_seq_prestador,
            coalesce(tx_procedimento,1) tx_procedimento,
            coalesce(tx_medico,1) tx_medico,
            coalesce(tx_anestesista,1) tx_anestesista,
            coalesce(tx_auxiliares,1) tx_auxiliares,
            coalesce(tx_custo_operacional,1) tx_custo_operacional,
            coalesce(tx_materiais,1) tx_materiais,
            coalesce(ie_liberado,'S') ie_liberado,
			hr_final,
			hr_inicial,
			ie_hora_inicial,
			ie_hora_final,
			coalesce(ie_percentual,'S') ie_percentual,
			nr_seq_prestador_partic,
			cd_medico_executor
        from    pls_proc_criterio_horario a
        where   cd_estabelecimento	= cd_estabelecimento_p
		and     ie_situacao 		= 'A'
		and (dt_vigencia_w 		>= dt_inicio_vigencia 	or coalesce(dt_inicio_vigencia::text, '') = '')
		and (dt_vigencia_w 		<= dt_fim_vigencia 	or coalesce(dt_fim_vigencia::text, '') = '')
        and     ((coalesce(cd_procedimento::text, '') = '') 		or (cd_procedimento 	 = dados_conta_proc_p.cd_procedimento and ie_origem_proced = dados_conta_proc_p.ie_origem_proced))
        and		((coalesce(cd_area_procedimento::text, '') = '') 		or (cd_area_procedimento = dados_procedimento_p.cd_area_procedimento))
		and		((coalesce(cd_especialidade::text, '') = '')		or (cd_especialidade	 = dados_procedimento_p.cd_especialidade))
		and		((coalesce(cd_grupo_proc::text, '') = '')		or (cd_grupo_proc	 = dados_procedimento_p.cd_grupo_proc))
		and		((coalesce(cd_edicao_amb::text, '') = '')		or (cd_edicao_amb	 = cd_edicao_w))
        and     ((coalesce(nr_seq_prestador::text, '') = '') 		or (nr_seq_prestador 	 = dados_prestador_exec_p.nr_seq_prestador))
        and     ((coalesce(ie_feriado::text, '') = '') 		or (ie_feriado = 'N')	 or (ie_feriado		= dia_feriado_w))
        and     ((coalesce(ie_tipo_vinculo::text, '') = '')      		or (ie_tipo_vinculo 	 = dados_prestador_exec_p.ie_tipo_vinculo))
        and     ((coalesce(nr_seq_classificacao::text, '') = '') 		or (nr_seq_classificacao = dados_prestador_exec_p.nr_seq_classificacao))
        and     ((coalesce(ie_tipo_feriado::text, '') = '') 		or (ie_tipo_feriado 	 = coalesce(ie_tipo_feriado_w,ie_tipo_feriado)))
        and     (((coalesce(dt_dia_semana::text, '') = '') 		or (dt_dia_semana 	 = dia_semana_w)) or (dt_dia_semana = 9))
        and     ((coalesce(ie_carater_internacao::text, '') = '') 		or (ie_carater_internacao = dados_conta_p.ie_carater_internacao))
		and		((coalesce(nr_seq_grupo_rec::text, '') = '') 		or (nr_seq_grupo_rec	= dados_procedimento_p.nr_seq_grupo_rec))
		and     ((coalesce(nr_seq_tipo_prestador::text, '') = '') 		or (nr_seq_tipo_prestador = dados_prestador_exec_p.nr_seq_tipo_prestador))
		and		((coalesce(ie_preco::text, '') = '')		or (ie_preco	= ie_preco_w))
		and		((coalesce(ie_tipo_intercambio::text, '') = '')		or (ie_tipo_intercambio = 'A') or (ie_tipo_intercambio	= ie_tipo_intercambio_w))
		and		((coalesce(ie_tipo_intercambio_seg::text, '') = '')		or (ie_tipo_intercambio_seg = 'A') or (ie_tipo_intercambio	= dados_beneficiario_p.ie_tipo_intercambio))
		and		((coalesce(nr_seq_contrato::text, '') = '')		or (nr_seq_contrato	= dados_beneficiario_p.nr_seq_contrato))
		and		((coalesce(nr_seq_ops_congenere::text, '') = '')		or (nr_seq_ops_congenere= dados_conta_p.nr_seq_congenere))
		and		((coalesce(nr_seq_intercambio::text, '') = '')		or (nr_seq_intercambio	= dados_beneficiario_p.nr_seq_intercambio))
		and		((coalesce(ie_tipo_congenere::text, '') = '')		or (ie_tipo_congenere	= ie_tipo_congenere_w))
		and 	((coalesce(ie_tipo_segurado::text, '') = '')		or (ie_tipo_segurado	= dados_beneficiario_p.ie_tipo_beneficiario))
		and		((dados_conta_proc_p.ie_criterio_horario = 'S' AND ie_regra_manual = 'S') or
				((ie_regra_manual = 'N') 	or (coalesce(ie_regra_manual::text, '') = '')  and (coalesce(dados_conta_proc_p.ie_criterio_horario,'N') = 'N')))	
		and		((ie_preco_prestador_w  = 'S' and ((ie_preco_prestador   = ie_preco_prestador_w) or ( coalesce(ie_preco_prestador::text, '') = ''))) or
				(ie_preco_reembolso_w   = 'S' and ((ie_preco_reembolso   = ie_preco_reembolso_w) or ( coalesce(ie_preco_reembolso::text, '') = ''))) or
				(ie_preco_pos_estab_w   = 'S' and ((ie_preco_pos_estab   = ie_preco_pos_estab_w) or ( coalesce(ie_preco_pos_estab::text, '') = ''))) or
				(ie_preco_copartic_w    = 'S' and ((ie_preco_copartic    = ie_preco_copartic_w)  or (coalesce(ie_preco_copartic::text, '') = ''))) or
				(ie_preco_intercambio_w = 'S' and ((ie_preco_intercambio = ie_preco_intercambio_w) or (coalesce(ie_preco_intercambio::text, '') = ''))) or
				(ie_preco_cobr_prev_w 	= 'S' and ((ie_preco_cobr_prev	 = ie_preco_cobr_prev_w) or (coalesce(ie_preco_cobr_prev::text, '') = ''))))
		and		((coalesce(nr_seq_grupo_servico::text, '') = '') or (exists (SELECT	1
					from	table(pls_grupos_pck.obter_procs_grupo_servico(a.nr_seq_grupo_servico, dados_conta_proc_p.ie_origem_proced, dados_conta_proc_p.cd_procedimento)) grupo)))
		and		((ie_acres_urg_emer = 'N') or (ie_acres_urg_emer = ie_acres_urg_emer_w))
		and 	((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = dados_conta_p.ie_tipo_guia))
        order by
                coalesce(ie_prioridade,0),
				coalesce(nr_seq_classificacao,0),
				coalesce(ie_feriado,'N'),
				coalesce(cd_procedimento,0),
                coalesce(cd_grupo_proc,0),
                coalesce(cd_especialidade,0),
                coalesce(cd_area_procedimento,0), 
                coalesce(nr_seq_prestador,0),
                coalesce(cd_edicao_amb,0),
				coalesce(ie_preco,0),
				coalesce(ie_tipo_intercambio,'A'),
				coalesce(nr_seq_intercambio,0),
				coalesce(nr_seq_contrato,0),
				coalesce(nr_seq_ops_congenere,0),
				coalesce(nr_seq_intercambio,0),
				coalesce(ie_tipo_segurado,'A'),
				coalesce(nr_seq_grupo_rec, 0),
				coalesce(ie_tipo_guia, 0);
		
C03 CURSOR FOR
        SELECT
			nr_sequencia,
            ie_prioridade,
            nr_seq_prestador,
            coalesce(tx_procedimento,1) tx_procedimento,
            coalesce(tx_medico,1) tx_medico,
            coalesce(tx_anestesista,1) tx_anestesista,
            coalesce(tx_auxiliares,1) tx_auxiliares,
            coalesce(tx_custo_operacional,1) tx_custo_operacional,
            coalesce(tx_materiais,1) tx_materiais,
            coalesce(ie_liberado,'S') ie_liberado,
			hr_final,
			hr_inicial,
			ie_hora_inicial,
			ie_hora_final,
			coalesce(ie_percentual,'S') ie_percentual,
			nr_seq_prestador_partic,
			cd_medico_executor,
			coalesce(ie_acres_urg_emer,'N') ie_acres_urg_emer
        from    pls_proc_criterio_horario 	a
        where   cd_estabelecimento	= cd_estabelecimento_p
		and     ie_situacao 		= 'A'
		and (dt_vigencia_w 		>= dt_inicio_vigencia 	or coalesce(dt_inicio_vigencia::text, '') = '')
		and (dt_vigencia_w 		<= dt_fim_vigencia 	or coalesce(dt_fim_vigencia::text, '') = '')
        and     ((coalesce(cd_procedimento::text, '') = '') 		or (cd_procedimento 	 = dados_conta_proc_p.cd_procedimento and ie_origem_proced = dados_conta_proc_p.ie_origem_proced))
        and		((coalesce(cd_area_procedimento::text, '') = '') 		or (cd_area_procedimento = dados_procedimento_p.cd_area_procedimento))
		and		((coalesce(cd_especialidade::text, '') = '')		or (cd_especialidade	 = dados_procedimento_p.cd_especialidade))
		and		((coalesce(cd_grupo_proc::text, '') = '')		or (cd_grupo_proc	 = dados_procedimento_p.cd_grupo_proc))
		and		((coalesce(cd_edicao_amb::text, '') = '')		or (cd_edicao_amb	 = cd_edicao_w))
        and     ((coalesce(nr_seq_prestador::text, '') = '') 		or (nr_seq_prestador 	 = dados_prestador_exec_p.nr_seq_prestador))
        and     ((coalesce(ie_feriado::text, '') = '') 		or (ie_feriado = 'N')	 or (ie_feriado		= dia_feriado_w))
        and     ((coalesce(ie_tipo_vinculo::text, '') = '')      		or (ie_tipo_vinculo 	 = dados_prestador_exec_p.ie_tipo_vinculo))
        and     ((coalesce(nr_seq_classificacao::text, '') = '') 		or (nr_seq_classificacao = dados_prestador_exec_p.nr_seq_classificacao))
        and     ((coalesce(ie_tipo_feriado::text, '') = '') 		or (ie_tipo_feriado 	 = coalesce(ie_tipo_feriado_w,ie_tipo_feriado)))
        and     (((coalesce(dt_dia_semana::text, '') = '') 		or (dt_dia_semana 	 = dia_semana_w)) or (dt_dia_semana = 9))
        and     ((coalesce(ie_carater_internacao::text, '') = '') 		or (ie_carater_internacao = dados_conta_p.ie_carater_internacao))
		and		((coalesce(nr_seq_grupo_rec::text, '') = '') 		or (nr_seq_grupo_rec	= dados_procedimento_p.nr_seq_grupo_rec))
		and     ((coalesce(nr_seq_tipo_prestador::text, '') = '') 		or (nr_seq_tipo_prestador = dados_prestador_exec_p.nr_seq_tipo_prestador))
		and		((coalesce(ie_preco::text, '') = '')		or (ie_preco	= ie_preco_w))
		and		((coalesce(ie_tipo_intercambio::text, '') = '')		or (ie_tipo_intercambio = 'A') or (ie_tipo_intercambio	= ie_tipo_intercambio_w))
		and		((coalesce(ie_tipo_intercambio_seg::text, '') = '')		or (ie_tipo_intercambio_seg = 'A') or (ie_tipo_intercambio	= dados_beneficiario_p.ie_tipo_intercambio))
		and		((coalesce(nr_seq_contrato::text, '') = '')		or (nr_seq_contrato	= dados_beneficiario_p.nr_seq_contrato))
		and		((coalesce(nr_seq_ops_congenere::text, '') = '')		or (nr_seq_ops_congenere= dados_conta_p.nr_seq_congenere))
		and		((coalesce(nr_seq_intercambio::text, '') = '')		or (nr_seq_intercambio	= dados_beneficiario_p.nr_seq_intercambio))
		and		((coalesce(ie_tipo_congenere::text, '') = '')		or (ie_tipo_congenere	= ie_tipo_congenere_w))
		and 	((coalesce(ie_tipo_segurado::text, '') = '')		or (ie_tipo_segurado	= dados_beneficiario_p.ie_tipo_beneficiario))
		and		((dados_conta_proc_p.ie_criterio_horario = 'S' AND ie_regra_manual = 'S') or
				((ie_regra_manual = 'N') 	or (coalesce(ie_regra_manual::text, '') = '')  and (coalesce(dados_conta_proc_p.ie_criterio_horario,'N') = 'N')))	
		and		((ie_preco_prestador_w  = 'S' and ((ie_preco_prestador   = ie_preco_prestador_w) or ( coalesce(ie_preco_prestador::text, '') = ''))) or
				(ie_preco_reembolso_w   = 'S' and ((ie_preco_reembolso   = ie_preco_reembolso_w) or ( coalesce(ie_preco_reembolso::text, '') = ''))) or
				(ie_preco_pos_estab_w   = 'S' and ((ie_preco_pos_estab   = ie_preco_pos_estab_w) or ( coalesce(ie_preco_pos_estab::text, '') = ''))) or
				(ie_preco_copartic_w    = 'S' and ((ie_preco_copartic    = ie_preco_copartic_w)  or (coalesce(ie_preco_copartic::text, '') = ''))) or
				(ie_preco_intercambio_w = 'S' and ((ie_preco_intercambio = ie_preco_intercambio_w) or (coalesce(ie_preco_intercambio::text, '') = ''))) or
				(ie_preco_cobr_prev_w 	= 'S' and ((ie_preco_cobr_prev	 = ie_preco_cobr_prev_w) or (coalesce(ie_preco_cobr_prev::text, '') = ''))))
		and		((coalesce(nr_seq_grupo_servico::text, '') = '') or (exists (SELECT	1
														 from	pls_grupo_servico_tm grupo
														 where	grupo.nr_seq_grupo_servico = a.nr_seq_grupo_servico
														 and	grupo.ie_origem_proced = dados_conta_proc_p.ie_origem_proced
														 and	grupo.cd_procedimento = dados_conta_proc_p.cd_procedimento)))
		and	((ie_acres_urg_emer = 'N') or (ie_acres_urg_emer = ie_acres_urg_emer_w))
		and ((coalesce(ie_tipo_guia::text, '') = '') or (ie_tipo_guia = dados_conta_p.ie_tipo_guia))
        order by
                coalesce(ie_prioridade,0),
				coalesce(nr_seq_classificacao,0),
				coalesce(ie_feriado,'N'),
				coalesce(cd_procedimento,0),
                coalesce(cd_grupo_proc,0),
                coalesce(cd_especialidade,0),
                coalesce(cd_area_procedimento,0), 
                coalesce(nr_seq_prestador,0),
                coalesce(cd_edicao_amb,0),
				coalesce(ie_preco,0),
				coalesce(ie_tipo_intercambio,'A'),
				coalesce(nr_seq_intercambio,0),
				coalesce(nr_seq_contrato,0),
				coalesce(nr_seq_ops_congenere,0),
				coalesce(nr_seq_intercambio,0),
				coalesce(ie_tipo_segurado,0),
				coalesce(ie_tipo_guia,0);
		
C02 CURSOR(	sg_estado_pc		pls_feriado.sg_estado%type,
				cd_municipio_pc		pls_feriado.cd_municipio_ibge%type,
				cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type,
				dt_inicio_proc_pc	pls_conta_proc.dt_inicio_proc%type)FOR
	SELECT	coalesce(b.ie_liberado,'N') dia_feriado,
			a.ie_tipo_feriado
	from	pls_feriado_regra	a,
			pls_feriado		b
	where	a.ie_situacao			 = 'A'
	and		a.cd_estabelecimento  		 = cd_estabelecimento_pc
	and		b.nr_seq_regra 			 = a.nr_sequencia
	and     to_char(dt_feriado,'dd/mm/yyyy') = to_char(dt_inicio_proc_pc,'dd/mm/yyyy')
	and		((coalesce(b.sg_estado::text, '') = '') or ( b.sg_estado = sg_estado_pc))
	and		((coalesce(b.cd_municipio_ibge::text, '') = '') or ( b.cd_municipio_ibge = cd_municipio_pc));	

BEGIN
-- tratamento OS 1105917, caso seja alterado a informacao do item para nao aplicar ('X') a regra nao e processada

if (coalesce(dados_conta_proc_p.ie_criterio_horario, 'N') != 'X') then

	dt_vigencia_w	:= trunc(dados_conta_proc_p.dt_procedimento,'dd');

	select	max(dt_inicio_proc),	
		max(dt_fim_proc),
		max(dt_procedimento)
	into STRICT	dt_inicio_proc_w,
		dt_fim_proc_w,
		dt_procedimento_w
	from	pls_conta_proc
	where	nr_sequencia	= dados_conta_proc_p.nr_sequencia;
	
	select	max(nr_seq_prest_inter),
		max(nr_seq_nota_cobranca)
	into STRICT	nr_seq_prest_inter_w,
		nr_seq_nota_cobranca_w
	from	pls_conta_proc_v
	where	nr_sequencia = dados_conta_proc_p.nr_sequencia;

	/*Obter o tipo de regra que se esta restringindo*/

	if (ie_tipo_tabela_p	= 'P') then
		ie_preco_prestador_w	:= 'S';
	elsif (ie_tipo_tabela_p	= 'R') then
		ie_preco_reembolso_w	:= 'S';
	elsif (ie_tipo_tabela_p	= 'O') then
		ie_preco_pos_estab_w	:= 'S';
	elsif (ie_tipo_tabela_p	= 'CO') then
		ie_preco_copartic_w	:= 'S';
	elsif (ie_tipo_tabela_p	= 'I') then
		ie_preco_intercambio_w	:= 'S';
	elsif (ie_tipo_tabela_p	= 'CP') then
		ie_preco_cobr_prev_w	:= 'S';
	end if;

	--Obtem o dia da semana que esta sendo executada a regra

	dia_semana_w            := (to_char(dt_procedimento_w,'d'))::numeric;

	select	coalesce(ie_tipo_feriado,'E')
	into STRICT	ie_tipo_regra_feriado_w
	from	table(pls_parametros_pck.f_retorna_param(cd_estabelecimento_p));

	--Obtem a formacao de preco do beneficiario

	if (dados_beneficiario_p.nr_seq_plano IS NOT NULL AND dados_beneficiario_p.nr_seq_plano::text <> '') then
		select	max(ie_preco)
		into STRICT	ie_preco_w
		from	pls_plano
		where	nr_sequencia	= dados_beneficiario_p.nr_seq_plano;
	end if;

	/* Obter a UF da operadora  - Tasy*/


	select	coalesce(max(sg_estado),'X')
	into STRICT	sg_estado_out_w
	from	pessoa_juridica
	where	cd_cgc	=	(SELECT	max(cd_cgc_outorgante)
				from	pls_outorgante
				where	cd_estabelecimento	= cd_estabelecimento_p);
	--Busca o tipo de operadora congenere	

	select	max(ie_tipo_congenere)
	into STRICT	ie_tipo_congenere_w
	from	pls_congenere
	where	nr_sequencia	= dados_conta_p.nr_seq_congenere;
		
	/* Obter a UF da operadora do beneficiario eventual ou que enviou o protocolo*/


	select	coalesce(max(a.sg_estado),'X'),
		coalesce(max(ie_nacional), 'N')
	into STRICT	sg_estado_int_w,
		ie_nacional_w
	from	pessoa_juridica	a,
		pls_congenere	b
	where	a.cd_cgc	= b.cd_cgc
	and	b.nr_sequencia	= dados_conta_p.nr_seq_congenere;

	if (ie_nacional_w	= 'S') then
		ie_tipo_intercambio_w := 'N';	-- Nacional
	elsif (sg_estado_out_w <> 'X') and (sg_estado_int_w <> 'X') then
		if (sg_estado_out_w = sg_estado_int_w) then
			ie_tipo_intercambio_w	:= 'E';
		else
			ie_tipo_intercambio_w	:= 'N';
		end if;
	else
		ie_tipo_intercambio_w	:= 'A';
	end if;
		
	if (ie_tipo_regra_feriado_w = 'E') then
		/* Obter Feriado */


		begin
			select  'S',
				ie_tipo_feriado
			into STRICT    dia_feriado_w,
				ie_tipo_feriado_w
			from    feriado
			where   cd_estabelecimento                      = cd_estabelecimento_p
			and     to_char(dt_feriado,'dd/mm/yyyy')        = to_char(dados_conta_proc_p.dt_inicio_proc,'dd/mm/yyyy')
			group by ie_tipo_feriado;
		exception
		when others then
			dia_feriado_w           := 'N';
			ie_tipo_feriado_w       := '';
		end;
	else
		ie_tipo_feriado_w	:= null;
		dia_feriado_w		:= null;

		if (coalesce(dados_prestador_prot_p.nr_seq_prestador::text, '') = '') then
		
			select 	coalesce(max(b.ds_unidade_federacao), 'X'),
				coalesce(substr(max(a.cd_municipio_ibge),1,6),'X')
			into STRICT	sg_estado_w,
					cd_municipio_ibge_w
			from	pls_prestador_intercambio a,
					sus_municipio b
			where	a.cd_municipio_ibge = b.cd_municipio_ibge
			and		a.nr_sequencia 	= nr_seq_prest_inter_w;
			
		else
			select	coalesce(max(b.sg_estado),'X'),
				coalesce(max(b.cd_municipio_ibge),'X')
			into STRICT	sg_estado_w,
				cd_municipio_ibge_w
			from	pessoa_juridica	b,
				pls_prestador	a
			where	b.cd_cgc		= a.cd_cgc
			and	a.nr_sequencia 		= dados_prestador_prot_p.nr_seq_prestador;
		end if;
		if (sg_estado_w = 'X') and (cd_municipio_ibge_w = 'X') then
			select	coalesce(max(c.sg_estado),'X'),
				coalesce(max(c.cd_municipio_ibge),'X')
			into STRICT	sg_estado_w,
				cd_municipio_ibge_w
			from	compl_pessoa_fisica	c,
				pessoa_fisica		b,
				pls_prestador		a
			where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
			and	b.cd_pessoa_fisica	= c.cd_pessoa_fisica
			and	c.ie_tipo_complemento	= 1
			and	a.nr_sequencia 		= dados_prestador_prot_p.nr_seq_prestador;
			
		end if;
		
		for r_c02_w in C02(sg_estado_w, cd_municipio_ibge_w, cd_estabelecimento_p, dados_conta_proc_p.dt_inicio_proc) loop
			begin
			dia_feriado_w		:= r_c02_w.dia_feriado;
			ie_tipo_feriado_w	:= r_c02_w.ie_tipo_feriado;
			end;
		end loop;

		if (coalesce(dia_feriado_w::text, '') = '') then
			dia_feriado_w		:= 'N';
			ie_tipo_feriado_w 	:= '';
		end if;	
	end if;

	/* Obter edicao AMB  */


	if (dados_conta_proc_p.cd_edicao_amb IS NOT NULL AND dados_conta_proc_p.cd_edicao_amb::text <> '') then
		cd_edicao_w := dados_conta_proc_p.cd_edicao_amb;
	else
		begin
			cd_edicao_w :=	pls_obter_edicao_preco_proc(	cd_estabelecimento_p, dados_prestador_exec_p.nr_seq_prestador, dados_conta_proc_p.cd_procedimento,
									dados_conta_proc_p.ie_origem_proced, dados_conta_proc_p.dt_inicio_proc);
		exception
			when others then
			cd_edicao_w     := 0;
		end;
	end if;
	
	ie_acres_urg_emer_w := 'N';
	
	if (nr_seq_nota_cobranca_w IS NOT NULL AND nr_seq_nota_cobranca_w::text <> '') then
		select	coalesce(max(id_acres_urg_emer),'N')
		into STRICT	ie_acres_urg_emer_w
		from	ptu_nota_servico
		where	nr_seq_nota_cobr = nr_seq_nota_cobranca_w
		and	nr_seq_conta_proc = dados_conta_proc_p.nr_sequencia;
	end if;
	
	if (pls_util_cta_pck.usar_novo_agrup = 'S') then
		
		for r_c03_w in C03() loop
			begin
			qt_partic_proc_w := 0;
			ie_restringe_partic_w := 'N';

			if (r_c03_w.nr_seq_prestador_partic IS NOT NULL AND r_c03_w.nr_seq_prestador_partic::text <> '') then
				ie_restringe_partic_w := 'S';
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	nr_seq_prestador = r_c03_w.nr_seq_prestador_partic
				and	nr_seq_conta_proc = dados_conta_proc_p.nr_sequencia;
			end if;
			
			if (qt_partic_proc_w = 0 and (r_c03_w.cd_medico_executor IS NOT NULL AND r_c03_w.cd_medico_executor::text <> '')) then
				ie_restringe_partic_w := 'S';
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	cd_medico = r_c03_w.cd_medico_executor
				and	nr_seq_conta_proc = dados_conta_proc_p.nr_sequencia;
			end if;

			--Entra se a regra nao restringir nem por pertador participante e/ou medico participante, ou caso retringir e encontrar o mesmo no procedimento.

			if (qt_partic_proc_w > 0 or ie_restringe_partic_w = 'N') then
				ie_excecao_w := pls_obter_se_excecao_hor(dados_conta_proc_p.cd_procedimento, dados_conta_proc_p.ie_origem_proced, r_c03_w.nr_sequencia);

				if (coalesce(ie_excecao_w,'N') = 'N') then

					/*OS 271559 - Diego OPS - Mdoficacao realizada para que possa ser calculado o valor do horario mesmo se as horas do procedimento nao tiverem sido informadas*/


					
					/*Se a regar conter horario a variave ja inicia-se negativa para o caso de nao haver hora inicial informado no procedimento.*/
	
					if (r_c03_w.hr_final IS NOT NULL AND r_c03_w.hr_final::text <> '') and (r_c03_w.hr_inicial IS NOT NULL AND r_c03_w.hr_inicial::text <> '') then
						
						dt_inicio_regra_w := pls_manipulacao_datas_pck.obter_data_mais_hora(dt_inicio_proc_w, r_c03_w.hr_inicial);
						dt_fim_regra_w := pls_manipulacao_datas_pck.obter_data_mais_hora(dt_inicio_proc_w, r_c03_w.hr_final);
						
						/*Atencao sempre que houver a interncao de uma regra iniciar em um dia e terminar em outro devem ser criadas duas regras distintas EX. 22:01:00 ate as 05:59:59 
						devera ser criada uma regra das 22:01:00 ate as 23:59:59 e outra das 00:00:00 ate as 05:59:59 para que a aplicacao das mesmas ocorra de forma correta*/

						if (dt_inicio_regra_w >= dt_fim_regra_w) then
							dt_fim_regra_w := dt_fim_regra_w + 1;
						end if;
					
						if (dt_inicio_proc_w IS NOT NULL AND dt_inicio_proc_w::text <> '') then
							if	( (dt_inicio_proc_w >= dt_inicio_regra_w) and (dt_inicio_proc_w <= dt_fim_regra_w)
								  and (coalesce(dt_fim_proc_w::text, '') = '' )) then
									ie_dt_procedimento_w := 'S';
							elsif (dt_fim_proc_w IS NOT NULL AND dt_fim_proc_w::text <> '') then
								ie_dt_procedimento_w := pls_obter_se_regra_horario(dt_inicio_regra_w, dt_fim_regra_w, r_c03_w.ie_hora_inicial, r_c03_w.ie_hora_final, dt_inicio_proc_w, dt_fim_proc_w, r_c03_w.ie_percentual);		
							else
								ie_dt_procedimento_w := 'N';
							end if;
						else
							ie_dt_procedimento_w := 'N';
						end if;
					else
						ie_dt_procedimento_w := 'S';
					end if;
				
					if (ie_dt_procedimento_w 	= 'S') then
						nr_seq_regra_w		:= r_c03_w.nr_sequencia;
						tx_medico_w		:= r_c03_w.tx_medico;
						tx_anestesista_w	:= r_c03_w.tx_anestesista;
						tx_auxiliares_w		:= r_c03_w.tx_auxiliares;
						tx_custo_operacional_w	:= r_c03_w.tx_custo_operacional;
						tx_materiais_w		:= r_c03_w.tx_materiais;
						tx_procedimento_w	:= r_c03_w.tx_procedimento;
						ie_liberado_w		:= r_c03_w.ie_liberado;
					end if;
					
				end if;
			end if;
				
			end;
		end loop;
	else
		for r_c01_w in C01() loop
			begin
			qt_partic_proc_w := 0;
			ie_restringe_partic_w := 'N';

			if (r_c01_w.nr_seq_prestador_partic IS NOT NULL AND r_c01_w.nr_seq_prestador_partic::text <> '') then
				ie_restringe_partic_w := 'S';
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	nr_seq_prestador = r_c01_w.nr_seq_prestador_partic
				and	nr_seq_conta_proc = dados_conta_proc_p.nr_sequencia;
			end if;
			
			if (qt_partic_proc_w = 0 and (r_c01_w.cd_medico_executor IS NOT NULL AND r_c01_w.cd_medico_executor::text <> '')) then
				ie_restringe_partic_w := 'S';
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	cd_medico = r_c01_w.cd_medico_executor
				and	nr_seq_conta_proc = dados_conta_proc_p.nr_sequencia;
			end if;

			--Entra se a regra nao restringir nem por pertador participante e/ou medico participante, ou caso retringir e encontrar o mesmo no procedimento.

			if (qt_partic_proc_w > 0 or ie_restringe_partic_w = 'N') then
			
			
				ie_excecao_w := pls_obter_se_excecao_hor(dados_conta_proc_p.cd_procedimento, dados_conta_proc_p.ie_origem_proced, r_c01_w.nr_sequencia);

				if (coalesce(ie_excecao_w,'N') = 'N') then

					/*OS 271559 - Diego OPS - Mdoficacao realizada para que possa ser calculado o valor do horario mesmo se as horas do procedimento nao tiverem sido informadas*/


					
					/*Se a regar conter horario a variave ja inicia-se negativa para o caso de nao haver hora inicial informado no procedimento.*/
	
					if (r_c01_w.hr_final IS NOT NULL AND r_c01_w.hr_final::text <> '') and (r_c01_w.hr_inicial IS NOT NULL AND r_c01_w.hr_inicial::text <> '') then
						
						dt_inicio_regra_w := pls_manipulacao_datas_pck.obter_data_mais_hora(dt_inicio_proc_w, r_c01_w.hr_inicial);
						dt_fim_regra_w := pls_manipulacao_datas_pck.obter_data_mais_hora(dt_inicio_proc_w, r_c01_w.hr_final);
						
						/*Atencao sempre que houver a interncao de uma regra iniciar em um dia e terminar em outro devem ser criadas duas regras distintas EX. 22:01:00 ate as 05:59:59 
						devera ser criada uma regra das 22:01:00 ate as 23:59:59 e outra das 00:00:00 ate as 05:59:59 para que a aplicacao das mesmas ocorra de forma correta*/

						if (dt_inicio_regra_w >= dt_fim_regra_w) then
							dt_fim_regra_w := dt_fim_regra_w + 1;
						end if;
					
						if (dt_inicio_proc_w IS NOT NULL AND dt_inicio_proc_w::text <> '') then
							if	( (dt_inicio_proc_w >= dt_inicio_regra_w) and (dt_inicio_proc_w <= dt_fim_regra_w)
								  and (coalesce(dt_fim_proc_w::text, '') = '' )) then
									ie_dt_procedimento_w := 'S';
							elsif (dt_fim_proc_w IS NOT NULL AND dt_fim_proc_w::text <> '') then
								ie_dt_procedimento_w := pls_obter_se_regra_horario(dt_inicio_regra_w, dt_fim_regra_w, r_c01_w.ie_hora_inicial, r_c01_w.ie_hora_final, dt_inicio_proc_w, dt_fim_proc_w, r_c01_w.ie_percentual);		
							else
								ie_dt_procedimento_w := 'N';
							end if;
						else
							ie_dt_procedimento_w := 'N';
						end if;
					else
						ie_dt_procedimento_w := 'S';
					end if;
					
					if (ie_dt_procedimento_w 	= 'S') then
						nr_seq_regra_w		:= r_c01_w.nr_sequencia;
						tx_medico_w		:= r_c01_w.tx_medico;
						tx_anestesista_w	:= r_c01_w.tx_anestesista;
						tx_auxiliares_w		:= r_c01_w.tx_auxiliares;
						tx_custo_operacional_w	:= r_c01_w.tx_custo_operacional;
						tx_materiais_w		:= r_c01_w.tx_materiais;
						tx_procedimento_w	:= r_c01_w.tx_procedimento;
						ie_liberado_w		:= r_c01_w.ie_liberado;
					end if;
					
				end if;
			end if;
				
			end;
		end loop;
	end if;
	
	if ( ie_liberado_w = 'S') then
		dados_adic_horario_p.nr_sequencia	  := nr_seq_regra_w;
		dados_adic_horario_p.tx_medico		  := tx_medico_w;
		dados_adic_horario_p.tx_anestesista	  := tx_anestesista_w;
		dados_adic_horario_p.tx_auxiliares	  := tx_auxiliares_w;
		dados_adic_horario_p.tx_custo_operacional := tx_custo_operacional_w;
		dados_adic_horario_p.tx_materiais	  := tx_materiais_w;
		dados_adic_horario_p.tx_procedimento	  := tx_procedimento_w;
	else
		dados_adic_horario_p.nr_sequencia	  := null;
		dados_adic_horario_p.tx_medico		  := 1;
		dados_adic_horario_p.tx_anestesista	  := 1;
		dados_adic_horario_p.tx_auxiliares	  := 1;
		dados_adic_horario_p.tx_custo_operacional := 1;
		dados_adic_horario_p.tx_materiais	  := 1;
		dados_adic_horario_p.tx_procedimento	  := 1;
	end if;
else
	dados_adic_horario_p.nr_sequencia	  := null;
	dados_adic_horario_p.tx_medico		  := 1;
	dados_adic_horario_p.tx_anestesista	  := 1;
	dados_adic_horario_p.tx_auxiliares	  := 1;
	dados_adic_horario_p.tx_custo_operacional := 1;
	dados_adic_horario_p.tx_materiais	  := 1;
	dados_adic_horario_p.tx_procedimento	  := 1;
end if; -- fim tratamento OS 1105917

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_valorizacao_pck.pls_define_adic_horario ( dados_conta_proc_p pls_cta_valorizacao_pck.dados_conta_proc, dados_prestador_exec_p pls_cta_valorizacao_pck.dados_prestador_exec, dados_prestador_prot_p pls_cta_valorizacao_pck.dados_prestador_prot, dados_conta_p pls_cta_valorizacao_pck.dados_conta, dados_procedimento_p pls_cta_valorizacao_pck.dados_procedimento, dados_beneficiario_p pls_cta_valorizacao_pck.dados_beneficiario, ie_tipo_tabela_p text, nm_usuario_p text, cd_estabelecimento_p bigint, dados_adic_horario_p INOUT pls_cta_valorizacao_pck.dados_adic_horario) FROM PUBLIC;