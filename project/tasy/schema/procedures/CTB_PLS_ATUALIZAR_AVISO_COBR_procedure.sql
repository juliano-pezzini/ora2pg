-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_atualizar_aviso_cobr ( nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type, nr_seq_arquivo_p ptu_aviso_arquivo.nr_sequencia%type, nr_seq_aviso_proc_p ptu_aviso_procedimento.nr_sequencia%type, nr_seq_aviso_mat_p ptu_aviso_material.nr_sequencia%type, nr_seq_aviso_proc_item_p ptu_aviso_proc_item.nr_sequencia%type, nr_seq_aviso_mat_item_p ptu_aviso_mat_item.nr_sequencia%type, nr_seq_lote_faturamento_p pls_lote_faturamento.nr_sequencia%type, nr_seq_ptu_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_nota_servico_p ptu_nota_servico.nr_sequencia%type, nr_seq_atualizacao_p pls_movimento_contabil.nr_seq_atualizacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_movimento_p INOUT integer) AS $body$
DECLARE

						
qt_movimento_w			bigint	:= 0;
i				bigint;
qt_registros_w 			bigint;
qt_cooperado_w			bigint;
ie_tipo_contrato_w		varchar(2);
ie_classif_grupo_w		varchar(5);
ie_classif_grupo_ww		varchar(5);
cd_classificacao_item_w		varchar(30);
dt_mesano_ref_w			timestamp;
cd_empresa_w			empresa.cd_empresa%type;
nr_seq_esquema_w		pls_esquema_contabil.nr_sequencia%type;
cd_historico_padrao_w		pls_esquema_contabil.cd_historico_padrao%type;
nr_seq_esquema_ww		pls_esquema_contabil.nr_sequencia%type;
cd_historico_padrao_ww		pls_esquema_contabil.cd_historico_padrao%type;
cd_conta_credito_w		conta_contabil.cd_conta_contabil%type;
cd_conta_debito_w		conta_contabil.cd_conta_contabil%type;
cd_classificacao_credito_w	conta_contabil.cd_classificacao%type;
cd_classificacao_debito_w	conta_contabil.cd_classificacao%type;
nr_seq_grupo_ans_w		ans_grupo_despesa.nr_seq_grupo_superior%type;
nr_seq_grupo_superior_w		ans_grupo_despesa.nr_seq_grupo_superior%type;
ie_grupo_despesa_ans_w		ans_grupo_despesa.ie_tipo_grupo_ans%type;
ie_tipo_repasse_w		pls_segurado_repasse.ie_tipo_repasse%type;
ie_tipo_prestador_w		pls_tipo_prestador.ie_tipo_ptu%type;
ie_codificacao_w		pls_esquema_contabil_seg.ie_codificacao%type;
vl_fixo_w			pls_esquema_contabil_seg.vl_fixo%type;
cd_conta_contabil_w		pls_esquema_contabil_seg.cd_conta_contabil%type;
ie_debito_credito_w		pls_esquema_contabil_seg.ie_debito_credito%type;
ds_mascara_w			pls_esquema_contabil_seg.ds_mascara%type;
cd_cgc_w			pls_congenere.cd_cgc%type;
cd_pessoa_fisica_prest_w	pls_prestador.cd_pessoa_fisica%type;
cd_cgc_prest_w			pls_prestador.cd_cgc%type;
ie_tipo_relacao_w		pls_prestador.ie_tipo_relacao%type;
nr_seq_tipo_prestador_w		pls_prestador.nr_seq_tipo_prestador%type;
ie_prestador_codificacao_w	pls_esquema_contabil.ie_prestador_codificacao%type;
ie_tipo_compartilhamento_w	pls_esquema_contabil.ie_tipo_compartilhamento%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
dt_repasse_w			timestamp;
dt_fim_repasse_w		timestamp;
ie_data_tipo_segurado_w		pls_parametros.ie_data_tipo_segurado%type;

c_itens CURSOR FOR
	SELECT	'A500' ie_tipo_processo,
		'E' ie_tipo_movimento,
		'P' ie_proc_mat,
		a.oid nr_id,
		pp.nr_sequencia nr_seq_conta_proc,
		null nr_seq_conta_mat,
		pp.nr_seq_grupo_ans nr_seq_grupo_ans,
		pp.ie_ato_cooperado ie_ato_cooperado,
		null nr_seq_aviso_proc,
		null nr_seq_aviso_mat,
		null nr_seq_aviso_proc_item,
		null nr_seq_aviso_mat_item,
		p.ie_tipo_contratacao ie_tipo_contratacao,
		p.ie_preco ie_preco,
		p.ie_segmentacao ie_segmentacao,
		p.ie_regulamentacao ie_regulamentacao,
		g.dt_mesano_referencia dt_referencia,
		coalesce(coalesce(c.ie_tipo_segurado,s.ie_tipo_segurado),'B') ie_tipo_segurado,
		s.ie_tipo_vinculo_operadora ie_tipo_vinculo_operadora,
		s.nr_seq_contrato nr_seq_contrato,
		s.nr_seq_intercambio nr_seq_intercambio,
		s.nr_sequencia nr_seq_segurado,
		obter_estabelecimento_base(s.cd_pessoa_fisica) cd_estabelecimento_setor,
		CASE WHEN ie_prestador_codificacao_w='E' THEN c.nr_seq_prestador_exec WHEN ie_prestador_codificacao_w='S' THEN c.nr_seq_prestador  ELSE t.nr_seq_prestador END  nr_seq_prestador,
		coalesce(s.ie_pcmso,'N') ie_pcmso,
		t.nr_seq_congenere nr_seq_congenere,
		pls_obter_se_benef_remido(s.nr_sequencia,g.dt_mesano_referencia) ie_benef_remido,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  pp.dt_procedimento  ELSE t.dt_mes_competencia END  dt_ref_repasse,
		p.nr_seq_classificacao nr_seq_classif_sca,
		null cd_usuario_plano
	from 	pls_conta c,
		pls_segurado s,
		pls_plano p,
		pls_protocolo_conta t,
		pls_conta_proc pp,
		ptu_nota_servico a,
		ptu_nota_cobranca b,
		ptu_fatura f,
		pls_lote_faturamento g,
		pls_fatura h
	where	a.nr_seq_nota_cobr 		= b.nr_sequencia
	and	b.nr_seq_fatura 		= f.nr_sequencia
	and	pp.nr_seq_conta 		= c.nr_sequencia
	and	c.nr_seq_segurado 		= s.nr_sequencia
	and	s.nr_seq_plano 			= p.nr_sequencia
	and	pp.nr_sequencia 		= a.nr_seq_conta_proc
	and	f.nr_seq_pls_fatura		= h.nr_sequencia
	and	h.nr_seq_lote			= g.nr_sequencia
	and	t.nr_sequencia			= c.nr_seq_protocolo
	and	f.ie_tipo_cobranca_fatura 	= 'A'
	and	f.ie_operacao			= 'E'
	and (
			a.nr_sequencia 		= nr_seq_nota_servico_p
			or
			coalesce(nr_seq_nota_servico_p::text, '') = ''
		)
	and	g.nr_sequencia 			= nr_seq_lote_faturamento_p
	and	coalesce(a.nr_lote_contabil, 0)	= 0
	
union all

	SELECT	'A500' ie_tipo_processo,
		'E' ie_tipo_movimento,
		'M' ie_proc_mat,
		a.oid nr_id,
		null nr_seq_conta_proc,
		mm.nr_sequencia nr_seq_conta_mat,
		mm.nr_seq_grupo_ans nr_seq_grupo_ans,
		mm.ie_ato_cooperado ie_ato_cooperado,
		null nr_seq_aviso_proc,
		null nr_seq_aviso_mat,
		null nr_seq_aviso_proc_item,
		null nr_seq_aviso_mat_item,
		p.ie_tipo_contratacao ie_tipo_contratacao,
		p.ie_preco ie_preco,
		p.ie_segmentacao ie_segmentacao,
		p.ie_regulamentacao ie_regulamentacao,
		g.dt_mesano_referencia dt_referencia,
		coalesce(coalesce(c.ie_tipo_segurado,s.ie_tipo_segurado),'B') ie_tipo_segurado,
		s.ie_tipo_vinculo_operadora ie_tipo_vinculo_operadora,
		s.nr_seq_contrato nr_seq_contrato,
		s.nr_seq_intercambio nr_seq_intercambio,
		s.nr_sequencia nr_seq_segurado,
		obter_estabelecimento_base(s.cd_pessoa_fisica) cd_estabelecimento_setor,
		CASE WHEN ie_prestador_codificacao_w='E' THEN c.nr_seq_prestador_exec WHEN ie_prestador_codificacao_w='S' THEN c.nr_seq_prestador  ELSE t.nr_seq_prestador END  nr_seq_prestador,
		coalesce(s.ie_pcmso,'N') ie_pcmso,
		t.nr_seq_congenere nr_seq_congenere,
		pls_obter_se_benef_remido(s.nr_sequencia,g.dt_mesano_referencia) ie_benef_remido,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  mm.dt_atendimento  ELSE t.dt_mes_competencia END  dt_ref_repasse,
		p.nr_seq_classificacao nr_seq_classif_sca,
		null cd_usuario_plano
	from 	pls_conta c,
		pls_segurado s,
		pls_plano p,
		pls_protocolo_conta t,
		pls_conta_mat mm,
		ptu_nota_servico a,
		ptu_nota_cobranca b,
		ptu_fatura f,
		pls_lote_faturamento g,
		pls_fatura h
	where	a.nr_seq_nota_cobr 		= b.nr_sequencia
	and	b.nr_seq_fatura 		= f.nr_sequencia
	and	mm.nr_seq_conta 		= c.nr_sequencia
	and	c.nr_seq_segurado 		= s.nr_sequencia
	and	s.nr_seq_plano 			= p.nr_sequencia
	and	mm.nr_sequencia 		= a.nr_seq_conta_mat
	and	f.nr_seq_pls_fatura		= h.nr_sequencia
	and	h.nr_seq_lote			= g.nr_sequencia
	and	t.nr_sequencia			= c.nr_seq_protocolo
	and	f.ie_tipo_cobranca_fatura 	= 'A'
	and	f.ie_operacao			= 'E'
	and (
			a.nr_sequencia 		= nr_seq_nota_servico_p
			or
			coalesce(nr_seq_nota_servico_p::text, '') = ''
		)
	and	g.nr_sequencia 			= nr_seq_lote_faturamento_p
	and	coalesce(a.nr_lote_contabil, 0)	= 0
	
union all

	select	'A500' ie_tipo_processo,
		'R' ie_tipo_movimento,
		'P' ie_proc_mat,
		a.oid nr_id,
		null nr_seq_conta_proc,
		null nr_seq_conta_mat,
		null nr_seq_grupo_ans,
		null ie_ato_cooperado,
		null nr_seq_aviso_proc,
		null nr_seq_aviso_mat,
		null nr_seq_aviso_proc_item,
		null nr_seq_aviso_mat_item,
		null ie_tipo_contratacao,
		null ie_preco,
		null ie_segmentacao,
		null ie_regulamentacao,
		f.dt_mes_competencia dt_referencia,
		null ie_tipo_segurado,
		null ie_tipo_vinculo_operadora,
		null nr_seq_contrato,
		null nr_seq_intercambio,
		null nr_seq_segurado,
		null cd_estabelecimento_setor,
		null nr_seq_prestador,
		null ie_pcmso,
		null nr_seq_congenere,
		null ie_benef_remido,
		a.dt_procedimento dt_ref_repasse,
		null nr_seq_classif_sca,
		b.cd_usuario_plano cd_usuario_plano
	from 	ptu_nota_servico a,
		ptu_nota_cobranca b,
		ptu_fatura f
	where	a.nr_seq_nota_cobr 		= b.nr_sequencia
	and	b.nr_seq_fatura 		= f.nr_sequencia
	and	f.ie_tipo_cobranca_fatura 	= 'A'
	and	f.ie_operacao			= 'R'
	and (
			a.nr_sequencia 		= nr_seq_nota_servico_p
			or
			coalesce(nr_seq_nota_servico_p::text, '') = ''
		)
	and	f.nr_sequencia 			= nr_seq_ptu_fatura_p
	and	coalesce(a.nr_lote_contabil, 0)	= 0
	
union all

	select	'A520' ie_tipo_processo,
		'E' ie_tipo_movimento,
		x.ie_proc_mat,
		x.nr_id,		
		x.nr_seq_conta_proc,
		x.nr_seq_conta_mat,
		x.nr_seq_grupo_ans,
		x.ie_ato_cooperado,
		x.nr_seq_aviso_proc,
		x.nr_seq_aviso_mat,
		x.nr_seq_aviso_proc_item,
		x.nr_seq_aviso_mat_item,
		d.ie_tipo_contratacao,
		d.ie_preco,
		d.ie_segmentacao,
		d.ie_regulamentacao,
		a.dt_competencia dt_referencia,
		coalesce(coalesce(c.ie_tipo_segurado,s.ie_tipo_segurado),'B') ie_tipo_segurado,
		s.ie_tipo_vinculo_operadora,
		s.nr_seq_contrato,
		s.nr_seq_intercambio,
		s.nr_sequencia nr_seq_segurado,
		obter_estabelecimento_base(s.cd_pessoa_fisica) cd_estabelecimento_setor,
		CASE WHEN ie_prestador_codificacao_w='E' THEN c.nr_seq_prestador_exec WHEN ie_prestador_codificacao_w='S' THEN c.nr_seq_prestador  ELSE p.nr_seq_prestador END  nr_seq_prestador,
		coalesce(s.ie_pcmso,'N') ie_pcmso,
		p.nr_seq_congenere,
		pls_obter_se_benef_remido(s.nr_sequencia,l.dt_referencia_inicio) ie_benef_remido,
		CASE WHEN ie_data_tipo_segurado_w='A' THEN  coalesce(x.dt_ref_repasse, a.dt_competencia)  ELSE p.dt_mes_competencia END  dt_ref_repasse,
		d.nr_seq_classificacao nr_seq_classif_sca,
		null cd_usuario_plano
	FROM (select	'P' ie_proc_mat,
			i.oid nr_id,
			b.nr_seq_conta_proc,
			null nr_seq_conta_mat,
			b.nr_seq_aviso_conta,
			(select	max(cp.nr_seq_grupo_ans)
			from	pls_conta_proc	cp
			where	cp.nr_sequencia  = b.nr_seq_conta_proc) nr_seq_grupo_ans,
			(select	max(cp.ie_ato_cooperado)
			from	pls_conta_proc	cp
			where	cp.nr_sequencia	= b.nr_seq_conta_proc) ie_ato_cooperado,
			b.nr_sequencia nr_seq_aviso_proc,
			null nr_seq_aviso_mat,
			i.nr_sequencia nr_seq_aviso_proc_item,
			null nr_seq_aviso_mat_item,
			(select y.dt_procedimento
			from    pls_conta_proc y
			where   b.nr_seq_conta_proc = y.nr_sequencia) dt_ref_repasse
		from	ptu_aviso_procedimento	b,
			ptu_aviso_proc_item	i
		where	b.nr_sequencia		= i.nr_seq_aviso_procedimento
		and	((i.nr_sequencia = nr_seq_aviso_proc_item_p) or (coalesce(nr_seq_aviso_proc_item_p::text, '') = ''))
		
union all

		select	'M' ie_proc_mat,
			i.oid nr_id,
			null nr_seq_conta_proc,
			b.nr_seq_conta_mat,
			b.nr_seq_aviso_conta,
			(select	max(cm.nr_seq_grupo_ans)
			from	pls_conta_mat	cm
			where	cm.nr_sequencia	= b.nr_seq_conta_mat) nr_seq_grupo_ans,
			(select	max(cm.ie_ato_cooperado)
			from	pls_conta_proc	cm
			where	cm.nr_sequencia	= b.nr_seq_conta_mat) ie_ato_cooperado,
			null nr_seq_aviso_proc,
			b.nr_sequencia nr_seq_aviso_mat,
			null nr_seq_aviso_proc_item,
			i.nr_sequencia nr_seq_aviso_mat_item,
			(select  y.dt_atendimento
			from    pls_conta_mat y
			where   b.nr_seq_conta_mat = y.nr_sequencia) dt_ref_repasse
		from	ptu_aviso_material	b,
			ptu_aviso_mat_item	i
		where	b.nr_sequencia		= i.nr_seq_aviso_material
		and	((i.nr_sequencia = nr_seq_aviso_mat_item_p) or (coalesce(nr_seq_aviso_mat_item_p::text, '') = ''))) x, pls_protocolo_conta p, ptu_lote_aviso l, ptu_aviso_protocolo ap, ptu_aviso_conta ac, ptu_aviso_arquivo a, pls_conta c
LEFT OUTER JOIN pls_segurado s ON (c.nr_seq_segurado = s.nr_sequencia)
LEFT OUTER JOIN pls_plano d ON (c.nr_seq_plano = d.nr_sequencia)
WHERE l.nr_sequencia		= a.nr_seq_lote and a.nr_sequencia		= ap.nr_seq_arquivo and ap.nr_sequencia		= ac.nr_seq_aviso_protocolo and ac.nr_sequencia		= x.nr_seq_aviso_conta and p.nr_sequencia		= ap.nr_seq_protocolo and c.nr_sequencia		= ac.nr_seq_conta   and l.ie_tipo_lote		= 'E' and l.nr_sequencia		= nr_seq_lote_p and a.nr_sequencia		= nr_seq_arquivo_p
	
union all

	select	'A520' ie_tipo_processo,
		'R' ie_tipo_movimento,
		x.ie_proc_mat,
		x.nr_id,
		null nr_seq_conta_proc,
		null nr_seq_conta_mat,
		x.nr_seq_grupo_ans,
		x.ie_ato_cooperado,
		x.nr_seq_aviso_proc,
		x.nr_seq_aviso_mat,
		null nr_seq_aviso_proc_item,
		null nr_seq_aviso_mat_item,
		d.ie_tipo_contratacao,
		d.ie_preco,
		d.ie_segmentacao,
		d.ie_regulamentacao,
		a.dt_transacao dt_referencia,
		coalesce(s.ie_tipo_segurado,'B') ie_tipo_segurado,
		null ie_tipo_vinculo_operadora,
		null nr_seq_contrato,
		null nr_seq_intercambio,
		s.nr_sequencia nr_seq_segurado,
		null cd_estabelecimento_setor,
		null nr_seq_prestador,
		null ie_pcmso,
		null nr_seq_congenere,
		pls_obter_se_benef_remido(s.nr_sequencia,l.dt_referencia_inicio) ie_benef_remido,
		coalesce(x.dt_execucao, a.dt_transacao) dt_ref_repasse,
		d.nr_seq_classificacao nr_seq_classif_sca,
		null cd_usuario_plano
	FROM (select	'P' ie_proc_mat,
			b.oid nr_id,
			b.nr_seq_aviso_conta,
			b.nr_sequencia nr_seq_aviso_proc,
			null nr_seq_aviso_mat,
			b.dt_execucao,
			b.ie_ato_cooperado,
			b.nr_seq_grupo_ans
		from	ptu_aviso_procedimento	b
		where	((b.nr_sequencia = nr_seq_aviso_proc_p) or (coalesce(nr_seq_aviso_proc_p::text, '') = ''))
		
union all

		select	'M' ie_proc_mat,
			b.oid nr_id,
			b.nr_seq_aviso_conta,
			null nr_seq_aviso_proc,
			b.nr_sequencia nr_seq_aviso_mat,
			b.dt_execucao,
			b.ie_ato_cooperado,
			b.nr_seq_grupo_ans
		from	ptu_aviso_material	b
		where	((b.nr_sequencia = nr_seq_aviso_mat_p) or (coalesce(nr_seq_aviso_mat_p::text, '') = ''))) x, ptu_lote_aviso l, ptu_aviso_protocolo ap, ptu_aviso_arquivo a, ptu_aviso_conta ac
LEFT OUTER JOIN pls_segurado s ON (ac.nr_seq_segurado = s.nr_sequencia)
LEFT OUTER JOIN pls_plano d ON (s.nr_seq_plano = d.nr_sequencia)
WHERE l.nr_sequencia		= a.nr_seq_lote and a.nr_sequencia		= ap.nr_seq_arquivo and ap.nr_sequencia		= ac.nr_seq_aviso_protocolo and ac.nr_sequencia		= x.nr_seq_aviso_conta   and l.ie_tipo_lote		= 'R' and l.nr_sequencia		= nr_seq_lote_p and a.nr_sequencia		= nr_seq_arquivo_p;

c_itens_w	c_itens%rowtype;

c_esquema CURSOR FOR
	SELECT	nr_sequencia,
		cd_historico_padrao
	from	pls_esquema_contabil
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	ie_tipo_regra		= 'AC'
	and	ie_tipo_movimentacao	= c_itens_w.ie_tipo_movimento
	and	c_itens_w.dt_referencia between dt_inicio_vigencia and coalesce(dt_fim_vigencia,c_itens_w.dt_referencia)
	and	((ie_tipo_segurado = c_itens_w.ie_tipo_segurado) or (coalesce(ie_tipo_segurado::text, '') = ''))
	and	((nr_seq_prestador = c_itens_w.nr_seq_prestador) or (coalesce(nr_seq_prestador::text, '') = ''))
	and	((nr_seq_tipo_prestador = nr_seq_tipo_prestador_w) or (coalesce(nr_seq_tipo_prestador::text, '') = ''))
	and	((ie_tipo_relacao = ie_tipo_relacao_w) or (coalesce(ie_tipo_relacao::text, '') = ''))
	and	((coalesce(ie_tipo_relacao,'X') <> 'C') or (ie_tipo_relacao = 'C' AND qt_cooperado_w > 0))
	and	((coalesce(ie_pcmso,'N') = c_itens_w.ie_pcmso) or (coalesce(ie_pcmso,'A') = 'A'))
	and	((nr_seq_congenere = c_itens_w.nr_seq_congenere) or (coalesce(nr_seq_congenere::text, '') = ''))
	and	((nr_seq_contrato = c_itens_w.nr_seq_contrato) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	((ie_tipo_vinculo_operadora = c_itens_w.ie_tipo_vinculo_operadora) or (coalesce(ie_tipo_vinculo_operadora::text, '') = ''))
	and	((cd_estab_setor_pessoa = c_itens_w.cd_estabelecimento_setor) or (coalesce(cd_estab_setor_pessoa::text, '') = ''))
	and	((ie_tipo_repasse = ie_tipo_repasse_w) or (coalesce(ie_tipo_repasse::text, '') = ''))
	and	((ie_tipo_compartilhamento = ie_tipo_compartilhamento_w) or (coalesce(ie_tipo_compartilhamento::text, '') = ''))
	and	((ie_benef_remido	= c_itens_w.ie_benef_remido) or (coalesce(ie_benef_remido::text, '') = ''))
	and	((nr_seq_classif_sca	= c_itens_w.nr_seq_classif_sca) or (coalesce(nr_seq_classif_sca::text, '') = ''))
	order by
		coalesce(ie_tipo_repasse,' '),
		coalesce(ie_pcmso,' '),
		coalesce(nr_seq_congenere,0),
		coalesce(nr_seq_contrato,0),
		coalesce(ie_tipo_vinculo_operadora,' '),
		coalesce(cd_estab_setor_pessoa,0),
		coalesce(ie_tipo_relacao,' '),
		coalesce(nr_seq_tipo_prestador,0),
		coalesce(nr_seq_prestador,0),
		coalesce(ie_tipo_segurado,' '),
		coalesce(ie_tipo_compartilhamento,0),
		coalesce(ie_benef_remido,' '),
		coalesce(dt_inicio_vigencia,clock_timestamp());

c_segmentacao CURSOR FOR
	SELECT	ie_codificacao,
		vl_fixo,
		cd_conta_contabil,
		ie_debito_credito,
		ds_mascara
	from	pls_esquema_contabil_seg
	where	nr_seq_regra_esquema = nr_seq_esquema_w
	order by	ie_debito_credito,
			nr_seq_apresentacao;


BEGIN

qt_movimento_w	:= qt_movimento_p;

select	max(cd_empresa)
into STRICT	cd_empresa_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

select	max(pkg_date_utils.start_of(l.dt_geracao, 'MONTH', 0))
into STRICT	dt_mesano_ref_w
from	ptu_lote_aviso	l
where	l.nr_sequencia	= nr_seq_lote_p;

select	max(a.ie_prestador_codificacao)
into STRICT	ie_prestador_codificacao_w
from	pls_esquema_contabil	a
where	a.ie_tipo_regra		= 'AC'
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	dt_mesano_ref_w between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia,dt_mesano_ref_w);

select	coalesce(max(a.ie_data_tipo_segurado),'A')
into STRICT	ie_data_tipo_segurado_w
from	pls_parametros a
where	a.cd_estabelecimento = cd_estabelecimento_p;

open c_itens;
loop
fetch c_itens into
	c_itens_w;
EXIT WHEN NOT FOUND; /* apply on c_itens */
	begin
	nr_seq_esquema_w		:= null;
	cd_conta_credito_w		:= null;
	cd_conta_debito_w		:= null;
	cd_historico_padrao_w		:= null;
	cd_classificacao_credito_w	:= null;
	cd_classificacao_debito_w	:= null;
	nr_seq_grupo_ans_w		:= null;
	nr_seq_grupo_superior_w		:= null;
	
	-- Quando eh recebimento do processo do A500, pode haver mais de um registro vinculado ao cd_usuario_plano, portanto o select eh feito fora do cursor
	if (c_itens_w.cd_usuario_plano IS NOT NULL AND c_itens_w.cd_usuario_plano::text <> '') then

		select	max(nr_seq_segurado)
		into STRICT	nr_seq_segurado_w
		from	pls_segurado_carteira
		where	cd_usuario_plano = c_itens_w.cd_usuario_plano;

		if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
			begin
			select	s.ie_tipo_segurado	ie_tipo_segurado,
				s.nr_sequencia 		nr_seq_segurado,
				p.ie_tipo_contratacao 	ie_tipo_contratacao,
				p.ie_preco 		ie_preco,
				p.ie_segmentacao 	ie_segmentacao,
				p.ie_regulamentacao 	ie_regulamentacao,
				pls_obter_se_benef_remido(s.nr_sequencia, c_itens_w.dt_referencia) ie_benef_remido,
				p.nr_seq_classificacao nr_seq_classif_sca
			into STRICT	c_itens_w.ie_tipo_segurado,
				c_itens_w.nr_seq_segurado,
				c_itens_w.ie_tipo_contratacao,
				c_itens_w.ie_preco,
				c_itens_w.ie_segmentacao,
				c_itens_w.ie_regulamentacao,
				c_itens_w.ie_benef_remido,
				c_itens_w.nr_seq_classif_sca
			FROM pls_segurado s
LEFT OUTER JOIN pls_plano p ON (s.nr_seq_plano = p.nr_sequencia)
WHERE s.nr_sequencia		= nr_seq_segurado_w;
			exception when no_data_found then
				c_itens_w.ie_tipo_segurado 	:= null;
				c_itens_w.nr_seq_segurado 	:= null;
				c_itens_w.ie_tipo_contratacao 	:= null;
				c_itens_w.ie_preco 		:= null;
				c_itens_w.ie_segmentacao 	:= null;
				c_itens_w.ie_regulamentacao 	:= null;
				c_itens_w.ie_benef_remido 	:= null;
				c_itens_w.nr_seq_classif_sca 	:= null;
			end;
		end if;
	
	end if;
	if (c_itens_w.nr_seq_prestador IS NOT NULL AND c_itens_w.nr_seq_prestador::text <> '') then
		select	ie_tipo_relacao,
			nr_seq_tipo_prestador,
			cd_pessoa_fisica,
			cd_cgc
		into STRICT	ie_tipo_relacao_w,
			nr_seq_tipo_prestador_w,
			cd_pessoa_fisica_prest_w,
			cd_cgc_prest_w
		from	pls_prestador
		where	nr_sequencia	= c_itens_w.nr_seq_prestador  LIMIT 1;

		if (nr_seq_tipo_prestador_w IS NOT NULL AND nr_seq_tipo_prestador_w::text <> '') then
			select	max(ie_tipo_ptu)
			into STRICT	ie_tipo_prestador_w
			from	pls_tipo_prestador
			where	nr_sequencia	= nr_seq_tipo_prestador_w  LIMIT 1;
		end if;
	end if;
	
	select	count(1)
	into STRICT	qt_cooperado_w
	from	pls_cooperado
	where	((cd_cgc = cd_cgc_prest_w) or (coalesce(cd_cgc_prest_w::text, '') = ''))
	and	((cd_pessoa_fisica = cd_pessoa_fisica_prest_w) or (coalesce(cd_pessoa_fisica_prest_w::text, '') = ''))
	and	c_itens_w.dt_referencia between coalesce(dt_inclusao,c_itens_w.dt_referencia) and coalesce(dt_exclusao,c_itens_w.dt_referencia)  LIMIT 1;

	SELECT * FROM pls_obter_dados_repasse(	c_itens_w.dt_ref_repasse, c_itens_w.nr_seq_segurado, c_itens_w.nr_seq_congenere, ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w) INTO STRICT ie_tipo_repasse_w, ie_tipo_compartilhamento_w, dt_repasse_w, dt_fim_repasse_w;

	if (coalesce(c_itens_w.nr_seq_contrato,0) <> 0) then
		select	CASE WHEN coalesce(cd_pf_estipulante::text, '') = '' THEN  'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_contrato_w
		from	pls_contrato
		where	nr_sequencia	= c_itens_w.nr_seq_contrato  LIMIT 1;
		
	elsif (coalesce(c_itens_w.nr_seq_intercambio,0) <> 0) then
		select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN  'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_contrato_w
		from	pls_intercambio
		where	nr_sequencia	= c_itens_w.nr_seq_intercambio  LIMIT 1;
	end if;
		
	open c_esquema;
	loop
	fetch c_esquema into	
		nr_seq_esquema_ww,
		cd_historico_padrao_ww;
	EXIT WHEN NOT FOUND; /* apply on c_esquema */
		begin
		nr_seq_esquema_w                 := nr_seq_esquema_ww;
		cd_historico_padrao_w            := cd_historico_padrao_ww;
		
		end;
	end loop;
	close c_esquema;

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

		if (ie_codificacao_w in ('GA','CG')) then
			if (coalesce(c_itens_w.nr_seq_grupo_ans,0) > 0) then
				select	max(nr_seq_grupo_superior)
				into STRICT	nr_seq_grupo_superior_w
				from	ans_grupo_despesa
				where	nr_sequencia	= c_itens_w.nr_seq_grupo_ans;
			end if;

			if (coalesce(nr_seq_grupo_superior_w,0) = 0) then
				nr_seq_grupo_ans_w	:= c_itens_w.nr_seq_grupo_ans;
			else
				nr_seq_grupo_ans_w	:= nr_seq_grupo_superior_w;
			end if;
		
			select	max(ie_tipo_grupo_ans)
			into STRICT	ie_grupo_despesa_ans_w
			from	ans_grupo_despesa
			where	nr_sequencia	= nr_seq_grupo_ans_w  LIMIT 1;

			if (ie_grupo_despesa_ans_w = 10) then /* 1 - Consultas */
				ie_classif_grupo_w	:= '1';
				ie_classif_grupo_ww	:= '0';
			elsif (ie_grupo_despesa_ans_w = 20) then /* 49 - Exames */
				ie_classif_grupo_w	:= '2';
				ie_classif_grupo_ww	:= '0';
			elsif (ie_grupo_despesa_ans_w = 30) then /* 51 - Terapias */
				ie_classif_grupo_w	:= '3';
				ie_classif_grupo_ww	:= '0';
			elsif (ie_grupo_despesa_ans_w = 41) then /* 7 - Internacao - Honorario medico */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '1';
			elsif (ie_grupo_despesa_ans_w = 42) then /* 8 - Internacao - Exames */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '2';
			elsif (ie_grupo_despesa_ans_w = 43) then /* 9 - Internacao - Terapias*/
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '3';
			elsif (ie_grupo_despesa_ans_w = 44) then /* 10 - Internacao - Materiais medicos */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '4';
			elsif (ie_grupo_despesa_ans_w = 45) then /* 11 - Internacao - Medicamentos */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '5';
			elsif (ie_grupo_despesa_ans_w = 46) then /* 11 - Internacao - Procedimentos com preco fixo */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '6';
			elsif (ie_grupo_despesa_ans_w = 49) then /* 12 - Internacao - Outras despesas */
				ie_classif_grupo_w	:= '4';
				ie_classif_grupo_ww	:= '9';
			elsif (ie_grupo_despesa_ans_w = 50) then /* 6 - Outros atendimentos - Ambulatoriais */
				ie_classif_grupo_w	:= '5';
				ie_classif_grupo_ww	:= '0';
			elsif (ie_grupo_despesa_ans_w = 60) then /* 16 - Demais despesas assistenciais */
				ie_classif_grupo_w	:= '6';
				ie_classif_grupo_ww	:= '0';
			elsif (ie_grupo_despesa_ans_w = 70) then /* 70 - Demais despesas assistenciais */
				ie_classif_grupo_w	:= '7';
				ie_classif_grupo_ww	:= '0';
			end if;
		end if;

		if (ie_debito_credito_w = 'C') then /* Classificacao CREDITO */
			if (ie_codificacao_w = 'CR') then /* Codigo reduzido */
				select	max(cd_classificacao_atual)
				into STRICT	cd_classificacao_credito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;

				cd_conta_credito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_preco in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(c_itens_w.ie_preco);
				else
					cd_classificacao_item_w	:= 'FP';
				end if;
			elsif (ie_codificacao_w = 'R') then /* Regulamentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w := pls_atualizar_codificacao_pck.get_regulamentacao(c_itens_w.ie_regulamentacao);
			elsif (ie_codificacao_w = 'TC') then /* Tipo de contratacao - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_tipo_contratacao in ('I','CE','CA')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(c_itens_w.ie_tipo_contratacao);
				else
					cd_classificacao_item_w	:= 'TC';
				end if;
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (Pessoa fisica ou Juridica)  -  Obs: Apenas regra de Envio */
				if (ie_tipo_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_contrato_w);
				else
					cd_classificacao_item_w	:= 'TP';
				end if;
			elsif (ie_codificacao_w = 'S') then /* Segmentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= lpad(c_itens_w.ie_segmentacao,2,'0');
			elsif (ie_codificacao_w = 'TA') then /* Tipo de ato cooperado - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_ato_cooperado in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_ato_cooperado(c_itens_w.ie_ato_cooperado);
				else
					cd_classificacao_item_w	:= 'TA';
				end if;
			elsif (ie_codificacao_w = 'TR') then /* Tipo de relacao com a OPS */
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_relacao(ie_tipo_relacao_w);
			elsif (ie_codificacao_w = 'RC') then /* Tipo de contratacao / Regulamentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_contratacao_regulamentacao(c_itens_w.ie_tipo_contratacao,c_itens_w.ie_regulamentacao);
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
			elsif (ie_codificacao_w = 'CP') then /* Conta de pagamento cooperativa origem */
				select	max(a.cd_cgc)
				into STRICT	cd_cgc_w
				from	pls_congenere	a
				where	a.cd_cooperativa	= c_itens_w.nr_seq_congenere;
				
				if (coalesce(cd_cgc_w,0) <> 0) then
					select	max(cd_conta_contabil)
					into STRICT	cd_conta_contabil_w
					from	pessoa_jur_conta_cont a
					where	a.cd_cgc	= cd_cgc_w
					and	a.cd_empresa	= cd_empresa_w
					and	a.ie_tipo_conta	= 'P'
					and	c_itens_w.dt_referencia between coalesce(a.dt_inicio_vigencia,c_itens_w.dt_referencia) and coalesce(a.dt_fim_vigencia,c_itens_w.dt_referencia);
				end if;
				
				cd_conta_credito_w	:= cd_conta_contabil_w;
				
				select	max(cd_classificacao_atual)
				into STRICT	cd_classificacao_credito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
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
		elsif (ie_debito_credito_w = 'D') then /* Classificacao DEBITO */
			if (ie_codificacao_w = 'CR') then /* Codigo reduzido */
				select	max(cd_classificacao_atual)
				into STRICT	cd_classificacao_debito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;

				cd_conta_debito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_preco in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(c_itens_w.ie_preco);
				else
					cd_classificacao_item_w	:= 'FP';
				end if;
			elsif (ie_codificacao_w = 'R') then /* Regulamentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_regulamentacao(c_itens_w.ie_regulamentacao);
			elsif (ie_codificacao_w = 'TC') then /* Tipo de contratacao - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_tipo_contratacao in ('I','CE','CA')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(c_itens_w.ie_tipo_contratacao);
				else
					cd_classificacao_item_w	:= 'TC';
				end if;
			elsif (ie_codificacao_w = 'S') then /* Segmentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= lpad(c_itens_w.ie_segmentacao,2,'0');
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (Pessoa fisica ou Juridica)  -  Obs: Apenas regra de Envio */
				if (ie_tipo_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_contrato_w);
				else
					cd_classificacao_item_w	:= 'TP';
				end if;
			elsif (ie_codificacao_w = 'TA') then /* Tipo de ato cooperado - Obs: Apenas regra de Envio */
				if (c_itens_w.ie_ato_cooperado in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_ato_cooperado(c_itens_w.ie_ato_cooperado);
				else
					cd_classificacao_item_w	:= 'TA';
				end if;
			elsif (ie_codificacao_w = 'TR') then /* Tipo de relacao com a OPS - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_relacao(ie_tipo_relacao_w);
			elsif (ie_codificacao_w = 'RC') then /* Tipo de contratacao / Regulamentacao - Obs: Apenas regra de Envio */
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_contratacao_regulamentacao(c_itens_w.ie_tipo_contratacao,c_itens_w.ie_regulamentacao);
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
			elsif (ie_codificacao_w = 'CP') then /* Conta de pagamento cooperativa origem */
				select	max(a.cd_cgc)
				into STRICT	cd_cgc_w
				from	pls_congenere	a
				where	a.cd_cooperativa	= c_itens_w.nr_seq_congenere;
				
				if (coalesce(cd_cgc_w,0) <> 0) then
					select	max(cd_conta_contabil)
					into STRICT	cd_conta_contabil_w
					from	pessoa_jur_conta_cont a
					where	a.cd_cgc	= cd_cgc_w
					and	a.cd_empresa	= cd_empresa_w
					and	a.ie_tipo_conta	= 'P'
					and	c_itens_w.dt_referencia between coalesce(a.dt_inicio_vigencia,c_itens_w.dt_referencia) and coalesce(a.dt_fim_vigencia,c_itens_w.dt_referencia);
				end if;
				
				cd_conta_credito_w	:= cd_conta_contabil_w;
				
				select	max(cd_classificacao_atual)
				into STRICT	cd_classificacao_credito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
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
		cd_conta_credito_w	:= ctb_obter_conta_classif(cd_classificacao_credito_w,c_itens_w.dt_referencia,cd_estabelecimento_p);
	end if;

	if (coalesce(cd_conta_debito_w::text, '') = '') then
		cd_conta_debito_w	:= ctb_obter_conta_classif(cd_classificacao_debito_w,c_itens_w.dt_referencia,cd_estabelecimento_p);
	end if;

	if 	(((c_itens_w.nr_seq_conta_proc IS NOT NULL AND c_itens_w.nr_seq_conta_proc::text <> '') or (c_itens_w.nr_seq_conta_mat IS NOT NULL AND c_itens_w.nr_seq_conta_mat::text <> '')) or
		((c_itens_w.nr_seq_aviso_proc IS NOT NULL AND c_itens_w.nr_seq_aviso_proc::text <> '') or (c_itens_w.nr_seq_aviso_mat IS NOT NULL AND c_itens_w.nr_seq_aviso_mat::text <> ''))) then
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(	nr_seq_atualizacao_p,
								1,
								null,
								c_itens_w.nr_seq_conta_proc,
								c_itens_w.nr_seq_conta_mat,
								'C',
								null, null, null, null, null, null, null, null, null, null, null,
								nm_usuario_p,
								nr_seq_esquema_w,
								null, null, null, null, null, null, null,
								c_itens_w.nr_seq_aviso_proc,
								c_itens_w.nr_seq_aviso_mat,
								c_itens_w.nr_seq_aviso_proc_item,
								c_itens_w.nr_seq_aviso_mat_item);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(	nr_seq_atualizacao_p,
								2,
								null,
								c_itens_w.nr_seq_conta_proc,
								c_itens_w.nr_seq_conta_mat,
								'C',
								null, null, null, null, null, null, null, null, null, null, null,
								nm_usuario_p,
								nr_seq_esquema_w,
								null, null, null, null, null, null, null,
								c_itens_w.nr_seq_aviso_proc,
								c_itens_w.nr_seq_aviso_mat,
								c_itens_w.nr_seq_aviso_proc_item,
								c_itens_w.nr_seq_aviso_mat_item);
			end if;
		end if;
	end if;

	if (c_itens_w.ie_tipo_processo = 'A520') then
		if (c_itens_w.ie_tipo_movimento = 'E') then
			--insert into knoch_log (ds_valor) values ();
			if (c_itens_w.ie_proc_mat = 'P') then
				update	ptu_aviso_proc_item
				set	cd_conta_debito			= cd_conta_debito_w,
					cd_conta_credito		= cd_conta_credito_w,
					cd_classif_debito		= cd_classificacao_debito_w,
					cd_classif_credito		= cd_classificacao_credito_w,
					nr_seq_esquema			= nr_seq_esquema_w,
					cd_historico	       		= cd_historico_padrao_w
				where	rowid				= c_itens_w.nr_id;
			
			elsif (c_itens_w.ie_proc_mat = 'M') then
				update	ptu_aviso_mat_item
				set	cd_conta_debito			= cd_conta_debito_w,
					cd_conta_credito		= cd_conta_credito_w,
					cd_classif_debito		= cd_classificacao_debito_w,
					cd_classif_credito		= cd_classificacao_credito_w,
					nr_seq_esquema			= nr_seq_esquema_w,
					cd_historico	       		= cd_historico_padrao_w
				where	rowid				= c_itens_w.nr_id;
			end if;
		elsif (c_itens_w.ie_tipo_movimento = 'R') then
			
			if (c_itens_w.ie_proc_mat = 'P') then
				update	ptu_aviso_procedimento
				set	cd_conta_debito			= cd_conta_debito_w,
					cd_conta_credito		= cd_conta_credito_w,
					cd_classif_debito		= cd_classificacao_debito_w,
					cd_classif_credito		= cd_classificacao_credito_w,
					nr_seq_esquema			= nr_seq_esquema_w,
					cd_historico	       		= cd_historico_padrao_w
				where	rowid				= c_itens_w.nr_id;
			
			elsif (c_itens_w.ie_proc_mat = 'M') then
				update	ptu_aviso_material
				set	cd_conta_debito			= cd_conta_debito_w,
					cd_conta_credito		= cd_conta_credito_w,
					cd_classif_debito		= cd_classificacao_debito_w,
					cd_classif_credito		= cd_classificacao_credito_w,
					nr_seq_esquema			= nr_seq_esquema_w,
					cd_historico	       		= cd_historico_padrao_w
				where	rowid				= c_itens_w.nr_id;
			end if;
		end if;

	elsif (c_itens_w.ie_tipo_processo = 'A500') then
		update	ptu_nota_servico
		set	cd_conta_deb			= cd_conta_debito_w,
			cd_conta_cred			= cd_conta_credito_w,
			cd_classif_deb			= cd_classificacao_debito_w,
			cd_classif_cred			= cd_classificacao_credito_w,
			nr_seq_esquema			= nr_seq_esquema_w,
			cd_historico	       		= cd_historico_padrao_w
		where	rowid				= c_itens_w.nr_id;
	end if;
	
	qt_movimento_w	:= qt_movimento_w + 1;
	
	if (mod(i,1000) = 0) then
		commit;
	end if;
	
	end;
end loop;
close c_itens;

commit;

qt_movimento_p	:= qt_movimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_atualizar_aviso_cobr ( nr_seq_lote_p ptu_lote_aviso.nr_sequencia%type, nr_seq_arquivo_p ptu_aviso_arquivo.nr_sequencia%type, nr_seq_aviso_proc_p ptu_aviso_procedimento.nr_sequencia%type, nr_seq_aviso_mat_p ptu_aviso_material.nr_sequencia%type, nr_seq_aviso_proc_item_p ptu_aviso_proc_item.nr_sequencia%type, nr_seq_aviso_mat_item_p ptu_aviso_mat_item.nr_sequencia%type, nr_seq_lote_faturamento_p pls_lote_faturamento.nr_sequencia%type, nr_seq_ptu_fatura_p ptu_fatura.nr_sequencia%type, nr_seq_nota_servico_p ptu_nota_servico.nr_sequencia%type, nr_seq_atualizacao_p pls_movimento_contabil.nr_seq_atualizacao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, qt_movimento_p INOUT integer) FROM PUBLIC;

