-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_atualizar_desp_interc ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_atualizacao_p pls_movimento_contabil.nr_seq_atualizacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_movimento_p INOUT integer) AS $body$
DECLARE

						
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar as informacoes contabeis das contas de intercambio conforme o
esquema contabil.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
-------------------------------------------------------------------------------------------------------------------

Referencias:
	PLS_ALTERA_STATUS_PROTOCOLO
	PLS_ATUALIZAR_CONTA_CONTABIL
	PLS_ATUALIZAR_CONTAS_CONTABEIS	
	PLS_ATUALIZAR_CONTAS_ITEM
	PLS_ATUALIZAR_CONTAS_PROTOCOLO
	PLS_ATUALIZAR_CTA_CONTAB_DESP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_classificacao_credito_w	varchar(255);
cd_classificacao_debito_w	varchar(255);
ie_tipo_w			varchar(255);
vl_fixo_w			varchar(30);
ds_mascara_w			varchar(30);
cd_classificacao_item_w		varchar(30);
cd_conta_credito_w		varchar(20);
cd_conta_debito_w		varchar(20);
cd_conta_contabil_w		varchar(20);
cd_cgc_prest_w			varchar(14);
cd_medico_executor_w		varchar(10);
cd_pessoa_fisica_prest_w	varchar(10);
dt_realizacao_w			timestamp;
ie_classif_grupo_w		varchar(5);
ie_classif_grupo_ww		varchar(5);
ie_tipo_segurado_w		varchar(3);
ie_preco_w			varchar(2);
ie_tipo_relacao_w		varchar(2);
ie_regulamentacao_w		varchar(2);
ie_tipo_contratacao_w		varchar(2);
ie_segmentacao_w		varchar(2);
ie_tipo_contrato_w		varchar(2);
ie_tipo_guia_w			varchar(2);
ie_codificacao_w		varchar(2);
ie_conta_glosa_w		varchar(2);
ie_pcmso_w			varchar(1);
ie_tipo_despesa_w		varchar(1);
ie_regime_internacao_w		varchar(1);
ie_ato_cooperado_w		varchar(1);
ie_debito_credito_w		varchar(1);
ie_proc_mat_w			varchar(1);
ie_segurado_repasse_w		varchar(1);
cd_procedimento_w		bigint;
nr_seq_grupo_ans_w		bigint;
nr_seq_grupo_superior_w		bigint;
nr_seq_grupo_ans_ww		bigint;
nr_seq_esquema_w		bigint;
cd_historico_padrao_w		bigint;
nr_seq_conta_w			bigint;
nr_seq_conta_item_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_tipo_atendimento_w	bigint;
nr_seq_conselho_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_prestador_w		bigint;
nr_seq_tipo_prestador_w		bigint;
qt_cooperado_w			bigint;
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
qt_movimento_w			bigint;
dt_referencia_w			timestamp;
dt_ref_repasse_w		timestamp;
dt_ref_original_w		timestamp;
cd_unimed_origem_w		ptu_fatura.cd_unimed_origem%type;
cd_cgc_w			pls_congenere.cd_cgc%type;
cd_empresa_w			estabelecimento.cd_empresa%type;
nr_seq_congenere_w		pls_protocolo_conta.nr_seq_congenere%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
ie_tipo_vinculo_operadora_w	pls_esquema_contabil.ie_tipo_vinculo_operadora%type;
cd_estabelecimento_setor_w	setor_atendimento.cd_estabelecimento_base%type;
nr_seq_titular_w		pls_segurado.nr_seq_titular%type;
cd_pessoa_fisica_titular_w	pls_segurado.cd_pessoa_fisica%type;
cd_pessoa_fisica_w		pls_segurado.cd_pessoa_fisica%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
ie_tipo_repasse_w		pls_esquema_contabil.ie_tipo_repasse%type;
ie_tipo_compartilhamento_w	pls_esquema_contabil.ie_tipo_compartilhamento%type;
nr_seq_plano_w                  pls_plano.nr_sequencia%type;
ie_benef_remido_w		pls_esquema_contabil.ie_benef_remido%type;
dt_repasse_w			timestamp;
dt_fim_repasse_w		timestamp;
ie_data_tipo_segurado_w		pls_parametros.ie_data_tipo_segurado%type;

c_contas CURSOR FOR
	SELECT	a.nr_sequencia,
		coalesce(p.dt_mes_competencia,b.dt_mes_competencia),
		CASE WHEN coalesce(a.nr_seq_segurado::text, '') = '' THEN  null  ELSE coalesce(coalesce(a.ie_tipo_segurado,c.ie_tipo_segurado),'B') END ,
		e.ie_preco,
		e.ie_regulamentacao,
		e.ie_tipo_contratacao,
		e.ie_segmentacao,
		f.ie_tipo_relacao,
		c.nr_seq_intercambio,
		a.ie_tipo_guia,
		a.nr_seq_tipo_atendimento,
		a.cd_medico_executor,
		a.ie_regime_internacao,
		f.cd_pessoa_fisica,
		f.cd_cgc,
		f.nr_seq_tipo_prestador,
		f.nr_sequencia,
		p.cd_unimed_origem,
		coalesce(c.ie_pcmso,'N'),
		b.nr_seq_congenere,
		c.nr_seq_contrato,		
		c.ie_tipo_vinculo_operadora,
		c.nr_seq_titular,
		c.cd_pessoa_fisica,
		c.nr_sequencia nr_seq_segurado,
		a.nr_seq_plano nr_seq_plano,
		pls_obter_se_benef_remido(c.nr_sequencia,coalesce(coalesce(a.dt_atendimento_referencia,a.dt_atendimento), coalesce(p.dt_mes_competencia,b.dt_mes_competencia))) ie_benef_remido
	FROM pls_conta a
LEFT OUTER JOIN pls_segurado c ON (a.nr_seq_segurado = c.nr_sequencia)
LEFT OUTER JOIN ptu_fatura p ON (a.nr_seq_fatura = p.nr_sequencia)
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_protocolo_conta b
LEFT OUTER JOIN pls_prestador f ON (b.nr_seq_prestador = f.nr_sequencia)
WHERE b.nr_sequencia		= a.nr_seq_protocolo     and b.nr_sequencia		= nr_seq_protocolo_p and coalesce(nr_seq_conta_p::text, '') = '' and coalesce(b.ie_tipo_protocolo,'C')  = 'I' and a.ie_status <> 'C'
	
union all

	SELECT	a.nr_sequencia,
		coalesce(p.dt_mes_competencia,b.dt_mes_competencia),
		CASE WHEN coalesce(a.nr_seq_segurado::text, '') = '' THEN  null  ELSE coalesce(coalesce(a.ie_tipo_segurado,c.ie_tipo_segurado),'B') END ,
		e.ie_preco,
		e.ie_regulamentacao,
		e.ie_tipo_contratacao,
		e.ie_segmentacao,
		f.ie_tipo_relacao,
		c.nr_seq_intercambio,
		a.ie_tipo_guia,
		a.nr_seq_tipo_atendimento,
		a.cd_medico_executor,
		a.ie_regime_internacao,
		f.cd_pessoa_fisica,
		f.cd_cgc,
		f.nr_seq_tipo_prestador,
		f.nr_sequencia,
		p.cd_unimed_origem,
		coalesce(c.ie_pcmso,'N'),
		b.nr_seq_congenere,
		c.nr_seq_contrato,		
		c.ie_tipo_vinculo_operadora,
		c.nr_seq_titular,
		c.cd_pessoa_fisica,
		c.nr_sequencia nr_seq_segurado,
		a.nr_seq_plano nr_seq_plano,
		pls_obter_se_benef_remido(c.nr_sequencia,coalesce(coalesce(a.dt_atendimento_referencia,a.dt_atendimento), coalesce(p.dt_mes_competencia,b.dt_mes_competencia))) ie_benef_remido
	FROM pls_conta a
LEFT OUTER JOIN pls_segurado c ON (a.nr_seq_segurado = c.nr_sequencia)
LEFT OUTER JOIN ptu_fatura p ON (a.nr_seq_fatura = p.nr_sequencia)
LEFT OUTER JOIN pls_plano e ON (c.nr_seq_plano = e.nr_sequencia)
, pls_protocolo_conta b
LEFT OUTER JOIN pls_prestador f ON (b.nr_seq_prestador = f.nr_sequencia)
WHERE b.nr_sequencia		= a.nr_seq_protocolo     and a.nr_sequencia		= nr_seq_conta_p and coalesce(nr_seq_protocolo_p::text, '') = '' and coalesce(b.ie_tipo_protocolo,'C')  = 'I' and a.ie_status <> 'C';

c_itens_conta CURSOR FOR
	SELECT	11, --ie_conta_glosa_w
		'P',
		c.nr_sequencia,
		c.cd_procedimento,
		c.ie_origem_proced,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(dt_procedimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_proc_p) or (coalesce(nr_seq_conta_proc_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	SELECT	11,
		'M',
		c.nr_sequencia,
		null,
		null,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_atendimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_mat_p) or (coalesce(nr_seq_conta_mat_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	12,
		'P',
		c.nr_sequencia,
		c.cd_procedimento,
		c.ie_origem_proced,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_procedimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_proc_p) or (coalesce(nr_seq_conta_proc_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	12,
		'M',
		c.nr_sequencia,
		null,
		null,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_atendimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_mat_p) or (coalesce(nr_seq_conta_mat_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	33,
		'P',
		c.nr_sequencia,
		c.cd_procedimento,
		c.ie_origem_proced,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(dt_procedimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_proc_p) or (coalesce(nr_seq_conta_proc_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	33,
		'M',
		c.nr_sequencia,
		null,
		null,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_atendimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_mat_p) or (coalesce(nr_seq_conta_mat_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	34,
		'P',
		c.nr_sequencia,
		c.cd_procedimento,
		c.ie_origem_proced,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_procedimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_proc		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta 		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_proc_p) or (coalesce(nr_seq_conta_proc_p::text, '') = ''))
	and	c.ie_status <> 'D'
	
union all

	select	34,
		'M',
		c.nr_sequencia,
		null,
		null,
		c.ie_tipo_despesa,
		c.nr_seq_grupo_ans,
		c.ie_ato_cooperado,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(c.dt_atendimento, dt_ref_original_w)  ELSE a.dt_mes_competencia END  dt_ref_repasse
	from	pls_conta_mat		c,
		pls_conta		b,
		pls_protocolo_conta	a
	where	a.nr_sequencia		= b.nr_seq_protocolo
	and	b.nr_sequencia		= c.nr_seq_conta
	and	c.nr_seq_conta		= nr_seq_conta_w
	and	((c.nr_sequencia = nr_seq_conta_mat_p) or (coalesce(nr_seq_conta_mat_p::text, '') = ''))
	and	c.ie_status <> 'D';
	
c_esquema CURSOR FOR
	SELECT	nr_sequencia,
		cd_historico_padrao
	from	pls_esquema_contabil
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_tipo_regra		= 'IC'
	and	coalesce(ie_tipo_movimentacao,11) = ie_conta_glosa_w
	and	dt_referencia_w between dt_inicio_vigencia and coalesce(dt_fim_vigencia,dt_referencia_w)
	and	((ie_tipo_segurado = ie_tipo_segurado_w) or (coalesce(ie_tipo_segurado::text, '') = ''))
	and	((ie_tipo_repasse = ie_tipo_repasse_w) or (coalesce(ie_tipo_repasse::text, '') = ''))
	and	((ie_tipo_compartilhamento = ie_tipo_compartilhamento_w) or (coalesce(ie_tipo_compartilhamento::text, '') = ''))
	and	((nr_seq_prestador = nr_seq_prestador_w) or (coalesce(nr_seq_prestador::text, '') = ''))
	and	((nr_seq_tipo_prestador = nr_seq_tipo_prestador_w) or (coalesce(nr_seq_tipo_prestador::text, '') = ''))
	and	((ie_tipo_relacao = ie_tipo_relacao_w) or (coalesce(ie_tipo_relacao::text, '') = ''))
	and	((coalesce(ie_tipo_relacao,'X') <> 'C') or (ie_tipo_relacao = 'C' AND qt_cooperado_w > 0))
	and	((coalesce(ie_pcmso,'N') = ie_pcmso_w) or (coalesce(ie_pcmso,'A') = 'A'))
	and	((nr_seq_congenere = nr_seq_congenere_w) or (coalesce(nr_seq_congenere::text, '') = ''))
	and	((nr_seq_contrato = nr_seq_contrato_w) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	((ie_tipo_vinculo_operadora = ie_tipo_vinculo_operadora_w) or (coalesce(ie_tipo_vinculo_operadora::text, '') = ''))
	and	((cd_estab_setor_pessoa = cd_estabelecimento_setor_w) or (coalesce(cd_estab_setor_pessoa::text, '') = ''))
	and	((ie_benef_remido	= ie_benef_remido_w) or (coalesce(ie_benef_remido::text, '') = ''))
	order by
		coalesce(ie_tipo_compartilhamento,0),
		coalesce(ie_tipo_repasse,' '),
		coalesce(ie_tipo_segurado,' '),
		coalesce(nr_seq_congenere,0),
		coalesce(nr_seq_contrato,0),
		coalesce(ie_tipo_vinculo_operadora,' '),
		coalesce(cd_estab_setor_pessoa,0),
		coalesce(ie_benef_remido,' '),
		coalesce(nr_seq_prestador,0),
		coalesce(nr_seq_tipo_prestador,0),
		coalesce(ie_tipo_relacao,' '),
		coalesce(ie_pcmso,' '),
		coalesce(dt_inicio_vigencia,clock_timestamp());
			
c_segmentacao CURSOR FOR
	SELECT	ie_codificacao,
		vl_fixo,
		cd_conta_contabil,
		ie_debito_credito,
		ds_mascara
	from	pls_esquema_contabil_seg
	where	nr_seq_regra_esquema	= nr_seq_esquema_w
	order by
		ie_debito_credito,
		nr_seq_apresentacao;


BEGIN
qt_movimento_w	:= qt_movimento_p;

select	max(cd_empresa)
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

select	coalesce(max(a.ie_data_tipo_segurado),'A')
into STRICT	ie_data_tipo_segurado_w
from	pls_parametros a
where	a.cd_estabelecimento = cd_estabelecimento_p;

open c_contas;
loop
fetch c_contas into
	nr_seq_conta_w,
	dt_referencia_w,
	ie_tipo_segurado_w,
	ie_preco_w,
	ie_regulamentacao_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_w,
	ie_tipo_relacao_w,
	nr_seq_intercambio_w,
	ie_tipo_guia_w,
	nr_seq_tipo_atendimento_w,
	cd_medico_executor_w,
	ie_regime_internacao_w,
	cd_pessoa_fisica_prest_w,
	cd_cgc_prest_w,
	nr_seq_tipo_prestador_w,
	nr_seq_prestador_w,
	cd_unimed_origem_w,
	ie_pcmso_w,
	nr_seq_congenere_w,
	nr_seq_contrato_w,
	ie_tipo_vinculo_operadora_w,
	nr_seq_titular_w,
	cd_pessoa_fisica_w,
	nr_seq_segurado_w,
	nr_seq_plano_w,
	ie_benef_remido_w;
EXIT WHEN NOT FOUND; /* apply on c_contas */
	begin

	dt_ref_original_w	:= dt_referencia_w;
	dt_referencia_w		:= pkg_date_utils.start_of(dt_referencia_w,'MONTH',0);
	
	if (coalesce(nr_seq_titular_w::text, '') = '') then
		cd_pessoa_fisica_titular_w	:= cd_pessoa_fisica_w;
	else
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_titular_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_titular_w;
	end if;
	
	select	max(b.cd_estabelecimento_base)
	into STRICT	cd_estabelecimento_setor_w
	from	pessoa_fisica_loc_trab	a,
		setor_atendimento	b
	where	a.cd_setor_atendimento	= b.cd_setor_atendimento
	and	a.cd_pessoa_fisica	= cd_pessoa_fisica_titular_w
	and	a.ie_local_principal	= 'S';
	
	select	count(1)
	into STRICT	qt_cooperado_w
	from	pls_cooperado
	where	((cd_cgc = cd_cgc_prest_w) or (coalesce(cd_cgc_prest_w::text, '') = ''))
	and	((cd_pessoa_fisica = cd_pessoa_fisica_prest_w) or (coalesce(cd_pessoa_fisica_prest_w::text, '') = ''))
	and	dt_referencia_w between coalesce(dt_inclusao,dt_referencia_w) and coalesce(dt_exclusao,dt_referencia_w)  LIMIT 1;
	
	if (coalesce(nr_seq_intercambio_w,0) <> 0) then
		select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_contrato_w
		from	pls_intercambio
		where	nr_sequencia	= nr_seq_intercambio_w  LIMIT 1;
	end if;
	
	open c_itens_conta;
	loop
	fetch c_itens_conta into
		ie_conta_glosa_w,
		ie_proc_mat_w,
		nr_seq_conta_item_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		ie_tipo_despesa_w,
		nr_seq_grupo_ans_w,
		ie_ato_cooperado_w,
		dt_ref_repasse_w;
	EXIT WHEN NOT FOUND; /* apply on c_itens_conta */
		begin	
		cd_classificacao_credito_w	:= null;
		cd_classificacao_debito_w	:= null;
		nr_seq_conselho_w		:= null;
		nr_seq_esquema_w		:= null;
		cd_historico_padrao_w		:= null;
	
		SELECT * FROM pls_obter_dados_repasse(	dt_ref_repasse_w, nr_seq_segurado_w, nr_seq_congenere_w, ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w) INTO STRICT ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w;
		
		open c_esquema;
		loop
		fetch c_esquema into
			nr_seq_esquema_w,
			cd_historico_padrao_w;
		EXIT WHEN NOT FOUND; /* apply on c_esquema */
		end loop;
		close c_esquema;
		
		/* GRUPO ANS */


		/*
		if	(nvl(nr_seq_grupo_ans_w,0) = 0) then
			if	(cd_medico_executor_w is not null) then
				select	max(nr_seq_conselho)
				into	nr_seq_conselho_w
				from	pessoa_fisica
				where	cd_pessoa_fisica	= cd_medico_executor_w
				and	rownum			<= 1;
			end if;
			
			select	pls_obter_grupo_ans(	cd_procedimento_w,
							ie_origem_proced_w,
							nr_seq_conselho_w, 
							nr_seq_tipo_atendimento_w,
							ie_tipo_guia_w,
							ie_regime_internacao_w, 
							ie_tipo_despesa_w,
							'G',
							nvl(cd_estabelecimento_p,0))
			into	nr_seq_grupo_ans_w
			from	dual;
		end if;
		*/

		/* 5 - Grupo ANS com base nos valores do ITAMED */

		if (coalesce(nr_seq_grupo_ans_w,0) > 0) then
			select	max(nr_seq_grupo_superior)
			into STRICT	nr_seq_grupo_superior_w
			from	ans_grupo_despesa
			where	nr_sequencia	= nr_seq_grupo_ans_w  LIMIT 1;
		end if;
		
		if (coalesce(nr_seq_grupo_superior_w,0) = 0) then
			nr_seq_grupo_ans_ww	:= nr_seq_grupo_ans_w;
		else
			nr_seq_grupo_ans_ww	:= nr_seq_grupo_superior_w;
		end if;
		
		select	max(ie_tipo_grupo_ans)
		into STRICT	nr_seq_grupo_ans_ww
		from	ans_grupo_despesa
		where	nr_sequencia	= nr_seq_grupo_ans_ww  LIMIT 1;
		
		if (nr_seq_grupo_ans_ww = 10) then /* 1 - Consultas */
			ie_classif_grupo_w	:= '1';
			ie_classif_grupo_ww	:= '0';
		elsif (nr_seq_grupo_ans_ww = 20) then /* 49 - Exames */
			ie_classif_grupo_w	:= '2';
			ie_classif_grupo_ww	:= '0';
		elsif (nr_seq_grupo_ans_ww = 30) then /* 51 - Terapias */
			ie_classif_grupo_w	:= '3';
			ie_classif_grupo_ww	:= '0';
		elsif (nr_seq_grupo_ans_ww = 41) then /* 7 - Internacao - Honorario medico */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '1';
		elsif (nr_seq_grupo_ans_ww = 42) then /* 8 - Internacao - Exames */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '2';
		elsif (nr_seq_grupo_ans_ww = 43) then /* 9 - Internacao - Terapias*/
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '3';
		elsif (nr_seq_grupo_ans_ww = 44) then /* 10 - Internacao - Materiais medicos */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '4';
		elsif (nr_seq_grupo_ans_ww = 45) then /* 11 - Internacao - Medicamentos */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '5';
		elsif (nr_seq_grupo_ans_ww = 46) then /* 11 - Internacao - Procedimentos com preco fixo */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '6';
		elsif (nr_seq_grupo_ans_ww = 49) then /* 12 - Internacao - Outras despesas */
			ie_classif_grupo_w	:= '4';
			ie_classif_grupo_ww	:= '9';
		elsif (nr_seq_grupo_ans_ww = 50) then /* 6 - Outros atendimentos - Ambulatoriais */
			ie_classif_grupo_w	:= '5';
			ie_classif_grupo_ww	:= '0';
		elsif (nr_seq_grupo_ans_ww = 60) then /* 16 - Demais despesas assistenciais */
			ie_classif_grupo_w	:= '6';
			ie_classif_grupo_ww	:= '0';
		end if;
		/* FIM GRUPO ANS */

		
		cd_conta_debito_w	:= null;
		cd_conta_credito_w	:= null;
		
		open c_segmentacao;
		loop
		fetch c_segmentacao into	
			ie_codificacao_w,
			vl_fixo_w,
			cd_conta_contabil_w,
			ie_debito_credito_w,
			ds_mascara_w;
		EXIT WHEN NOT FOUND; /* apply on c_segmentacao */
			begin
			cd_classificacao_item_w	:= null;
			
			if (ie_debito_credito_w = 'C') then /* Classificacao CReDITO */
				if (ie_codificacao_w = 'CR') then /* Codigo reduzido */
					select	max(cd_classificacao_atual)
					into STRICT	cd_classificacao_credito_w
					from	conta_contabil
					where	cd_conta_contabil	= cd_conta_contabil_w;
					
					cd_conta_credito_w	:= cd_conta_contabil_w;
				elsif (ie_codificacao_w = 'FX') then /* Fixo */
					cd_classificacao_item_w	:= vl_fixo_w;
				elsif (ie_codificacao_w = 'GA') then /* Grupo ANS */
					if (ie_classif_grupo_w IS NOT NULL AND ie_classif_grupo_w::text <> '') then
						cd_classificacao_item_w	:= ie_classif_grupo_w;
					else
						cd_classificacao_item_w	:= 'GA';
					end if;
				elsif (ie_codificacao_w = 'CG') then /* Complemento grupo ANS */
					if (ie_classif_grupo_ww IS NOT NULL AND ie_classif_grupo_ww::text <> '') then
						cd_classificacao_item_w	:= ie_classif_grupo_ww;
					else
						cd_classificacao_item_w	:= 'CG';
					end if;
				elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
					if (ie_preco_w in ('1','2','3')) then
						cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_preco_w);
					else
						cd_classificacao_item_w	:= 'FP';
					end if;
				elsif (ie_codificacao_w = 'R') then /* Regulamentacao */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_regulamentacao(ie_regulamentacao_w);
				elsif (ie_codificacao_w = 'TC') then /* Tipo de contratacao */
					if (ie_tipo_contratacao_w in ('I','CE','CA')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);
					else
						cd_classificacao_item_w	:= 'TC';
					end if;
				elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (Pessoa fisica ou Juridica) */
					if (ie_tipo_contrato_w in ('PF','PJ')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_contrato_w);
					else
						cd_classificacao_item_w	:= 'TP';
					end if;		
				elsif (ie_codificacao_w = 'S') then /* Segmentacao */
					cd_classificacao_item_w	:= lpad(ie_segmentacao_w,2,'0');
				elsif (ie_codificacao_w = 'TA') then /* Tipo de ato cooperado */
					if (ie_ato_cooperado_w in ('1','2','3')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_ato_cooperado(ie_ato_cooperado_w);
					else
						cd_classificacao_item_w	:= 'TA';
					end if;
				elsif (ie_codificacao_w = 'TR') then /* Tipo de relacao com a OPS */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_relacao(ie_tipo_relacao_w);
				elsif (ie_codificacao_w = 'RC') then /* Tipo de contratacao / Regulamentacao */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_contratacao_regulamentacao(ie_tipo_contratacao_w,ie_regulamentacao_w);
				elsif (ie_codificacao_w = 'CP') then /* Conta de pagamento cooperativa origem */
					select	max(a.cd_cgc)
					into STRICT	cd_cgc_w
					from	pls_congenere	a
					where	a.cd_cooperativa	= cd_unimed_origem_w;
					
					if (coalesce(cd_cgc_w,0) <> 0) then
						select	max(cd_conta_contabil)
						into STRICT	cd_conta_contabil_w
						from	pessoa_jur_conta_cont a
						where	a.cd_cgc	= cd_cgc_w
						and	a.cd_empresa	= cd_empresa_w
						and	a.ie_tipo_conta	= 'P'
						and	dt_referencia_w between coalesce(a.dt_inicio_vigencia,dt_referencia_w) and coalesce(a.dt_fim_vigencia,dt_referencia_w);
					end if;
					
					cd_conta_credito_w	:= cd_conta_contabil_w;
					
					select	max(cd_classificacao_atual)
					into STRICT	cd_classificacao_credito_w
					from	conta_contabil
					where	cd_conta_contabil	= cd_conta_contabil_w;
					
				elsif (ie_codificacao_w = 'TD') then
					if (ie_proc_mat_w = 'P') then
						if (ie_tipo_despesa_w IS NOT NULL AND ie_tipo_despesa_w::text <> '') then
                                        		cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_despesa(ie_tipo_despesa_w);
						else
							cd_classificacao_item_w := 'TD';
						end if;
					else
						cd_classificacao_item_w := 1;
					end if;
				end if;
				
				if (cd_classificacao_item_w IS NOT NULL AND cd_classificacao_item_w::text <> '') then
					if (ds_mascara_w = '00') then
						cd_classificacao_item_w	:= lpad(cd_classificacao_item_w,2,'0') || '.';
					elsif (ds_mascara_w = '0.0') then
						cd_classificacao_item_w	:= substr(lpad(cd_classificacao_item_w,2,'0'),1,1) ||'.'||substr(lpad(cd_classificacao_item_w,2,'0'),2,1) || '.';
					elsif (ds_mascara_w = '0_') then
						cd_classificacao_item_w	:= cd_classificacao_item_w;
					else
						cd_classificacao_item_w	:= cd_classificacao_item_w || '.';
					end if;
					
					cd_classificacao_credito_w	:= cd_classificacao_credito_w || cd_classificacao_item_w;
				end if;
			elsif (ie_debito_credito_w = 'D') then /* Classificacao DeBITO */
				if (ie_codificacao_w = 'CR') then /* Codigo reduzido */
					select	max(cd_classificacao_atual)
					into STRICT	cd_classificacao_debito_w
					from	conta_contabil
					where	cd_conta_contabil	= cd_conta_contabil_w;
					
					cd_conta_debito_w	:= cd_conta_contabil_w;
				elsif (ie_codificacao_w = 'FX') then /* Fixo */
					cd_classificacao_item_w	:= vl_fixo_w;
				elsif (ie_codificacao_w = 'GA') then /* Grupo ANS */
					if (ie_classif_grupo_w IS NOT NULL AND ie_classif_grupo_w::text <> '') then
						cd_classificacao_item_w	:= ie_classif_grupo_w;
					else
						cd_classificacao_item_w	:= 'GA';
					end if;
				elsif (ie_codificacao_w = 'CG') then /* Complemento grupo ANS */
					if (ie_classif_grupo_ww IS NOT NULL AND ie_classif_grupo_ww::text <> '') then
						cd_classificacao_item_w	:= ie_classif_grupo_ww;
					else
						cd_classificacao_item_w	:= 'CG';
					end if;
				elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
					if (ie_preco_w in ('1','2','3')) then
						cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_preco_w);
					else
						cd_classificacao_item_w	:= 'FP';
					end if;
				elsif (ie_codificacao_w = 'R') then /* Regulamentacao */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_regulamentacao(ie_regulamentacao_w);
				elsif (ie_codificacao_w = 'TC') then /* Tipo de contratacao */
					if (ie_tipo_contratacao_w in ('I','CE','CA')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);
					else
						cd_classificacao_item_w	:= 'TC';
					end if;
				elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (Pessoa fisica ou Juridica) */
					if (ie_tipo_contrato_w in ('PF','PJ')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_contrato_w);
					else
						cd_classificacao_item_w	:= 'TP';
					end if;	
				elsif (ie_codificacao_w = 'S') then /* Segmentacao */
					cd_classificacao_item_w	:= lpad(ie_segmentacao_w,2,'0');
				elsif (ie_codificacao_w = 'TA') then /* Tipo de ato cooperado */
					if (ie_ato_cooperado_w in ('1','2','3')) then
						cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_ato_cooperado(ie_ato_cooperado_w);
					else
						cd_classificacao_item_w	:= 'TA';
					end if;
				elsif (ie_codificacao_w = 'TR') then /* Tipo de relacao com a OPS */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_relacao(ie_tipo_relacao_w);
				elsif (ie_codificacao_w = 'RC') then /* Tipo de contratacao / Regulamentacao */
					cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_contratacao_regulamentacao(ie_tipo_contratacao_w,ie_regulamentacao_w);
				elsif (ie_codificacao_w = 'CP') then /* Conta de pagamento cooperativa origem */
					select	max(a.cd_cgc)
					into STRICT	cd_cgc_w
					from	pls_congenere	a
					where	a.cd_cooperativa	= cd_unimed_origem_w;
					
					if (coalesce(cd_cgc_w,0) <> 0) then
						select	max(cd_conta_contabil)
						into STRICT	cd_conta_contabil_w
						from	pessoa_jur_conta_cont a
						where	a.cd_cgc	= cd_cgc_w
						and	a.cd_empresa	= cd_empresa_w
						and	a.ie_tipo_conta	= 'P'
						and	dt_referencia_w between coalesce(a.dt_inicio_vigencia,dt_referencia_w) and coalesce(a.dt_fim_vigencia,dt_referencia_w);
					end if;
					
					cd_conta_debito_w	:= cd_conta_contabil_w;
					
					select	max(cd_classificacao_atual)
					into STRICT	cd_classificacao_debito_w
					from	conta_contabil
					where	cd_conta_contabil	= cd_conta_contabil_w;

				elsif (ie_codificacao_w = 'TD') then
					if (ie_proc_mat_w = 'P') then
						if (ie_tipo_despesa_w IS NOT NULL AND ie_tipo_despesa_w::text <> '') then
                                        		cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_tipo_despesa(ie_tipo_despesa_w);
						else
							cd_classificacao_item_w := 'TD';
						end if;
					else
						cd_classificacao_item_w := 1;
					end if;
				end if;
				
				if (cd_classificacao_item_w IS NOT NULL AND cd_classificacao_item_w::text <> '') then
					if (ds_mascara_w = '00') then
						cd_classificacao_item_w	:= lpad(cd_classificacao_item_w,2,'0') || '.';
					elsif (ds_mascara_w = '0.0') then
						cd_classificacao_item_w	:= substr(lpad(cd_classificacao_item_w,2,'0'),1,1) ||'.'||substr(lpad(cd_classificacao_item_w,2,'0'),2,1) || '.';
					elsif (ds_mascara_w = '0_') then
						cd_classificacao_item_w	:= cd_classificacao_item_w;
					else
						cd_classificacao_item_w	:= cd_classificacao_item_w || '.';
					end if;
					
					cd_classificacao_debito_w	:= cd_classificacao_debito_w || cd_classificacao_item_w;
				end if;
			end if;
			end;
		end loop;
		close c_segmentacao;
		
		/* Remover o ultimo ponto da classificacao */

		if (substr(cd_classificacao_credito_w,length(cd_classificacao_credito_w),length(cd_classificacao_credito_w)) = '.') then
			cd_classificacao_credito_w	:= substr(cd_classificacao_credito_w,1,length(cd_classificacao_credito_w)-1);
		end if;
		
		if (substr(cd_classificacao_debito_w,length(cd_classificacao_debito_w),length(cd_classificacao_debito_w)) = '.') then
			cd_classificacao_debito_w	:= substr(cd_classificacao_debito_w,1,length(cd_classificacao_debito_w)-1);
		end if;

		if (coalesce(cd_conta_credito_w::text, '') = '') then
			cd_conta_credito_w	:= ctb_obter_conta_classif(cd_classificacao_credito_w,dt_referencia_w,cd_estabelecimento_p);
		end if;

		if (coalesce(cd_conta_debito_w::text, '') = '') then
			cd_conta_debito_w	:= ctb_obter_conta_classif(cd_classificacao_debito_w,dt_referencia_w,cd_estabelecimento_p);
		end if;
		
		nr_seq_conta_proc_w	:= null;
		nr_seq_conta_mat_w	:= null;
		
		if (ie_conta_glosa_w = 11) then
			ie_tipo_w	:= 'C';
			
			if (ie_proc_mat_w = 'P') then
				nr_seq_conta_proc_w	:= nr_seq_conta_item_w;
							
				update	pls_conta_proc
				set	cd_conta_cred		= cd_conta_credito_w,
					cd_conta_deb		= cd_conta_debito_w,
					nr_seq_esquema		= nr_seq_esquema_w,
					cd_historico		= cd_historico_padrao_w,
					cd_classif_cred		= cd_classificacao_credito_w,
					cd_classif_deb		= cd_classificacao_debito_w
				where	nr_sequencia		= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
				
			elsif (ie_proc_mat_w = 'M') then
				nr_seq_conta_mat_w	:= nr_seq_conta_item_w;
	
				update	pls_conta_mat
				set	cd_conta_cred		= cd_conta_credito_w,
					cd_conta_deb		= cd_conta_debito_w,
					nr_seq_esquema		= nr_seq_esquema_w,
					cd_historico		= cd_historico_padrao_w,
					cd_classif_cred		= cd_classificacao_credito_w,
					cd_classif_deb		= cd_classificacao_debito_w
				where	nr_sequencia		= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			end if;
		elsif (ie_conta_glosa_w = 12) then
			ie_tipo_w	:= 'G';
			
			if (ie_proc_mat_w = 'P') then
				nr_seq_conta_proc_w	:= nr_seq_conta_item_w;
				
				update	pls_conta_proc
				set	cd_conta_glosa_cred	= cd_conta_credito_w,
					cd_conta_glosa_deb	= cd_conta_debito_w,
					cd_classif_glosa_cred	= cd_classificacao_credito_w,
					cd_classif_glosa_deb	= cd_classificacao_debito_w,
					nr_seq_esquema_glosa	= nr_seq_esquema_w,
					cd_historico_glosa	= cd_historico_padrao_w
				where	nr_sequencia		= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			elsif (ie_proc_mat_w = 'M') then
				nr_seq_conta_mat_w	:= nr_seq_conta_item_w;
				
				update	pls_conta_mat
				set	cd_conta_glosa_cred	= cd_conta_credito_w,
					cd_conta_glosa_deb	= cd_conta_debito_w,
					cd_classif_glosa_cred	= cd_classificacao_credito_w,
					cd_classif_glosa_deb	= cd_classificacao_debito_w,
					nr_seq_esquema_glosa	= nr_seq_esquema_w,
					cd_historico_glosa	= cd_historico_padrao_w
				where	nr_sequencia		= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			end if;
		elsif (ie_conta_glosa_w = 33) then
			ie_tipo_w	:= 'C';
			
			if (ie_proc_mat_w = 'P') then
				nr_seq_conta_proc_w	:= nr_seq_conta_item_w;
							
				update	pls_conta_proc
				set	cd_conta_cred_tx_inter_glosa		= cd_conta_credito_w,
					cd_conta_deb_tx_inter_glosa		= cd_conta_debito_w,
					nr_seq_esquema_tx_inter_glosa		= nr_seq_esquema_w,
					cd_historico_tx_inter_glosa		= cd_historico_padrao_w,
					cd_classif_tx_glosa_cred		= cd_classificacao_credito_w,
					cd_classif_tx_glosa_deb			= cd_classificacao_debito_w
				where	nr_sequencia				= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
				
			elsif (ie_proc_mat_w = 'M') then
				nr_seq_conta_mat_w	:= nr_seq_conta_item_w;
	
				update	pls_conta_mat
				set	cd_conta_cred_tx_inter_glosa		= cd_conta_credito_w,
					cd_conta_deb_tx_inter_glosa		= cd_conta_debito_w,
					nr_seq_esquema_tx_inter_glosa		= nr_seq_esquema_w,
					cd_historico_tx_inter_glosa		= cd_historico_padrao_w,
					cd_classif_tx_glosa_cred		= cd_classificacao_credito_w,
					cd_classif_tx_glosa_deb			= cd_classificacao_debito_w
				where	nr_sequencia				= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			end if;
		elsif (ie_conta_glosa_w = 34) then
			ie_tipo_w	:= 'C';
			
			if (ie_proc_mat_w = 'P') then
				nr_seq_conta_proc_w	:= nr_seq_conta_item_w;
				
				update	pls_conta_proc
				set	cd_conta_cred_tx_inter		= cd_conta_credito_w,
					cd_conta_deb_tx_inter		= cd_conta_debito_w,
					cd_classif_tx_inter_cred	= cd_classificacao_credito_w,
					cd_classif_tx_inter_deb		= cd_classificacao_debito_w,
					nr_seq_esquema_tx_inter		= nr_seq_esquema_w,
					cd_historico_tx_inter		= cd_historico_padrao_w
				where	nr_sequencia			= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			elsif (ie_proc_mat_w = 'M') then
				nr_seq_conta_mat_w	:= nr_seq_conta_item_w;
				
				update	pls_conta_mat
				set	cd_conta_cred_tx_inter		= cd_conta_credito_w,
					cd_conta_deb_tx_inter		= cd_conta_debito_w,
					cd_classif_tx_inter_cred	= cd_classificacao_credito_w,
					cd_classif_tx_inter_deb		= cd_classificacao_debito_w,
					nr_seq_esquema_tx_inter		= nr_seq_esquema_w,
					cd_historico_tx_inter		= cd_historico_padrao_w
				where	nr_sequencia			= nr_seq_conta_item_w;
				
				qt_movimento_w	:= qt_movimento_w + 1;
			end if;
		end if;
		
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p,
							1,
							null,
							nr_seq_conta_proc_w,
							nr_seq_conta_mat_w,
							ie_tipo_w,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nm_usuario_p, nr_seq_esquema_w);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p,
							2,
							null,
							nr_seq_conta_proc_w,
							nr_seq_conta_mat_w,
							ie_tipo_w,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nm_usuario_p, nr_seq_esquema_w);
                        elsif (coalesce(nr_seq_plano_w, 0) = 0) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p,
							8,
							null,
							nr_seq_conta_proc_w,
							nr_seq_conta_mat_w,
							ie_tipo_w,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nm_usuario_p, nr_seq_esquema_w);
			end if;
		end if;
		end;
	end loop;
	close c_itens_conta;
	end;
end loop;
close c_contas;

qt_movimento_p	:= qt_movimento_w;
--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_atualizar_desp_interc ( nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, nr_seq_atualizacao_p pls_movimento_contabil.nr_seq_atualizacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_movimento_p INOUT integer) FROM PUBLIC;
