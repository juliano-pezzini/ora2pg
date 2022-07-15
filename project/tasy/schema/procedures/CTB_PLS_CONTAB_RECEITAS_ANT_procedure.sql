-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_contab_receitas_ant ( nr_lote_contabil_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_referencia_w			timestamp;
cd_estabelecimento_w		smallint;
cd_conta_contabil_w		varchar(20);
nr_seq_pagador_w		bigint;
ie_debito_credito_w		varchar(20);
nr_lote_contab_antecip_w	bigint;
vl_contabil_w			double precision;
nr_seq_w_movto_cont_w		bigint;
cd_historico_w			bigint;
nr_seq_mensalidade_w		bigint;
nr_seq_nota_fiscal_w		bigint;
cd_centro_custo_w		integer;
ie_centro_custo_w		varchar(1);
nr_seq_item_w			bigint;
ds_item_w			varchar(255);
nr_lote_contabil_w		bigint;
ie_tipo_valor_w			varchar(2);
ie_tipo_conta_w			varchar(2);
nr_nota_fiscal_w		varchar(255);
nr_titulo_w			bigint;
cd_cgc_pagador_w		varchar(14);
cd_pf_pagador_w			varchar(10);
ds_conteudo_w			varchar(4000);
ds_compl_historico_w		varchar(255);
ds_compl_historico_ww		varchar(255);
ie_tipo_segurado_w		varchar(3);
ie_tipo_contratacao_w		varchar(2);
nr_seq_copartic_w		bigint;
nm_pagador_w			varchar(255);
nr_seq_regra_cc_w		bigint;
cd_conta_ato_coop_w		varchar(20);
cd_conta_ato_aux_w		varchar(20);
cd_conta_ato_nao_coop_w		varchar(20);
vl_ato_cooperado_princ_w	double precision;
vl_ato_cooperado_aux_w		double precision;
vl_ato_nao_cooperado_w		double precision;
nr_seq_lote_mensalidade_w	bigint;
qt_compl_hist_w			bigint;
ie_tipo_item_w			varchar(2);
nr_seq_segurado_w		bigint;
ie_regulamentacao_w		varchar(2);
ie_cancelamento_w		varchar(1);
ie_recebimento_antec_passivo_w	varchar(1);
ie_contab_antec_copartic_w	varchar(1);
ie_contab_rec_antec_w		varchar(1);
qt_baixas_titulo_w		bigint;
nr_seq_vinculo_sca_w		bigint;
ds_classif_sca_w		varchar(255);
nr_seq_esquema_w		bigint;
ds_grupo_w			varchar(255);
dt_referencia_mov_w		timestamp;
dt_antecipacao_w		timestamp;
dt_mesano_referencia_w		timestamp;
nr_seq_regra_w			bigint	:= null;
dt_referencia_lote_w		timestamp;
nr_seq_mov_sem_conta_w		bigint;
nm_agrupador_w			varchar(255);
nr_seq_agrupamento_w		bigint;
dt_liquidacao_titulo_w		timestamp;
nr_seq_info_ctb_w		informacao_contabil.nr_sequencia%type;
nm_tabela_w			w_movimento_contabil.nm_tabela%type;
nm_atributo_w			w_movimento_contabil.nm_atributo%type;
nr_seq_tab_orig_w		w_movimento_contabil.nr_seq_tab_orig%type;
nr_seq_tab_compl_w		w_movimento_contabil.nr_seq_tab_compl%type;
nr_seq_pagador_ant_w		pls_contrato_pagador.nr_sequencia%type;
nr_seq_item_cancel_w		pls_mensalidade_seg_item.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.nr_lote_contab_antecip,
		b.nr_seq_pagador,
		c.nr_titulo,
		a.nr_sequencia,
		a.dt_contabilizacao,
		a.dt_mesano_referencia,
		c.dt_liquidacao
	from	titulo_receber		c,
		pls_mensalidade		b,
		pls_lote_mensalidade	a
	where	b.nr_sequencia	= c.nr_seq_mensalidade
	and	a.nr_sequencia	= b.nr_seq_lote
	and	((a.nr_lote_contabil		= nr_lote_contabil_p and (a.nr_lote_contab_antecip IS NOT NULL AND a.nr_lote_contab_antecip::text <> '') and coalesce(b.ie_cancelamento::text, '') = '')
	or (a.nr_lote_contab_antecip	= nr_lote_contabil_p and coalesce(b.ie_cancelamento::text, '') = ''))
	
union all
 /* Lepinski - OS 396869 - Contabilizar mensalidades futuras canceladas */
	SELECT	b.nr_sequencia,
		a.nr_lote_contab_antecip,
		b.nr_seq_pagador,
		c.nr_titulo,
		a.nr_sequencia,
		a.dt_contabilizacao,
		a.dt_mesano_referencia,
		c.dt_liquidacao
	from	titulo_receber		c,
		pls_mensalidade		b,
		pls_lote_mensalidade	a
	where	b.nr_sequencia	= c.nr_seq_mensalidade
	and	a.nr_sequencia	= b.nr_seq_lote
	and	b.ie_cancelamento = 'C'
	and	a.nr_lote_contab_antecip	= nr_lote_contabil_p
	
union all

	select	b.nr_sequencia,
		a.nr_lote_contab_antecip,
		b.nr_seq_pagador,
		null,
		a.nr_sequencia,
		a.dt_contabilizacao,
		a.dt_mesano_referencia,
		null dt_liquidacao
	from	pls_mensalidade		b,
		pls_lote_mensalidade	a
	where	a.nr_sequencia	= b.nr_seq_lote
	and	b.ie_cancelamento = 'E'
	and	exists (	select	1
				from	titulo_receber	z,
					pls_mensalidade x
				where	z.nr_seq_mensalidade	= x.nr_sequencia
				and	x.nr_seq_lote		= a.nr_sequencia
				and	x.nr_seq_pagador	= b.nr_seq_pagador
				and	x.ie_cancelamento	= 'C')
	and	a.nr_lote_contab_antecip	= nr_lote_contabil_p
	order by nr_seq_pagador;

C02 CURSOR FOR
	SELECT	'D',
		'N',
		CASE WHEN ie_tipo_conta_w='DA' THEN  CASE WHEN ie_contab_rec_antec_w='S' THEN a.cd_conta_contabil_rec_antec  ELSE a.cd_conta_deb_antecip END   ELSE a.cd_conta_deb END ,
		CASE WHEN ie_tipo_conta_w='DA' THEN coalesce(coalesce(a.vl_pro_rata_dia,a.vl_item),0)  ELSE coalesce(a.vl_item,0) END , /* Lepinski - OS 281940 - conforme histórico do dia 28/01/2011 */
		CASE WHEN ie_tipo_conta_w='DA' THEN  coalesce(CASE WHEN ie_contab_rec_antec_w='S' THEN a.cd_historico_rev_rec_antec  ELSE a.cd_historico_rev_antec END ,a.cd_historico_antec)  ELSE a.cd_historico END ,
		a.nr_sequencia,
		(	SELECT	substr(ds_valor_dominio,1,255)
			from	valor_dominio
			where	cd_dominio = 1930
			and	vl_dominio = a.ie_tipo_item), --substr(obter_valor_dominio(1930,a.ie_tipo_item),1,255),
		c.ie_tipo_segurado,
		d.ie_tipo_contratacao,
		CASE WHEN a.ie_tipo_item='13' THEN CASE WHEN coalesce(ie_cancelamento::text, '') = '' THEN 1  ELSE e.nr_sequencia END   ELSE 0 END ,
		null cd_conta_ato_cooperado,
		null cd_conta_ato_auxiliar,
		null cd_conta_ato_nao_coop,
		null vl_ato_cooperado,
		null vl_ato_auxiliar,
		null vl_ato_nao_cooperado,
		f.nr_sequencia,
		a.ie_tipo_item,
		a.cd_centro_custo,
		c.nr_sequencia,
		d.ie_regulamentacao,
		e.ie_cancelamento,
		f.dt_mesano_referencia dt_referencia_lote,
		a.nr_seq_vinculo_sca,
		a.nr_seq_esquema,
		'PLS_MENSALIDADE_SEG_ITEM' nm_tabela,
		CASE WHEN ie_tipo_conta_w='DA' THEN CASE WHEN coalesce(a.vl_pro_rata_dia::text, '') = '' THEN 'VL_ITEM'  ELSE 'VL_PRO_RATA_DIA' END   ELSE 'VL_ITEM' END  nm_atributo,
		56 nr_seq_info_ctb,
		a.nr_seq_item_cancel
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado b,
		pls_segurado		c,
		pls_mensalidade		e,
		pls_plano		d,
		pls_lote_mensalidade	f
	where	b.nr_sequencia		= a.nr_seq_mensalidade_seg
	and	b.nr_seq_segurado	= c.nr_sequencia
	and	e.nr_sequencia		= b.nr_seq_mensalidade
	and	c.nr_seq_plano		= d.nr_sequencia
	and	f.nr_sequencia		= e.nr_seq_lote
	and	b.nr_seq_mensalidade	= nr_seq_mensalidade_w
	and	a.ie_tipo_item <> '3'
	
union all

	select	'C',
		'N',
		CASE WHEN ie_tipo_conta_w='CA' THEN  a.cd_conta_rec_antecip  ELSE a.cd_conta_rec END ,
		CASE WHEN ie_tipo_conta_w='DA' THEN coalesce(coalesce(a.vl_pro_rata_dia,a.vl_item),0)  ELSE coalesce(a.vl_item,0) END , /* Lepinski - OS 281940 - conforme histórico do dia 28/01/2011 */
		CASE WHEN ie_tipo_conta_w='CA' THEN  a.cd_historico_antec  ELSE a.cd_historico END ,
		a.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,255)
			from	valor_dominio
			where	cd_dominio = 1930
			and	vl_dominio = a.ie_tipo_item), --substr(obter_valor_dominio(1930,a.ie_tipo_item),1,255),
		c.ie_tipo_segurado,
		d.ie_tipo_contratacao,
		CASE WHEN a.ie_tipo_item='13' THEN CASE WHEN coalesce(ie_cancelamento::text, '') = '' THEN 1  ELSE e.nr_sequencia END   ELSE 0 END ,
		cd_conta_ato_cooperado,
		cd_conta_ato_auxiliar,
		cd_conta_ato_nao_coop,
		vl_ato_cooperado,
		vl_ato_auxiliar,
		vl_ato_nao_cooperado,
		f.nr_sequencia,
		a.ie_tipo_item,
		a.cd_centro_custo,
		c.nr_sequencia,
		d.ie_regulamentacao,
		e.ie_cancelamento,
		f.dt_mesano_referencia dt_referencia_lote,
		a.nr_seq_vinculo_sca,
		a.nr_seq_esquema,
		'PLS_MENSALIDADE_SEG_ITEM' nm_tabela,
		CASE WHEN ie_tipo_conta_w='DA' THEN CASE WHEN coalesce(a.vl_pro_rata_dia::text, '') = '' THEN 'VL_ITEM'  ELSE 'VL_PRO_RATA_DIA' END   ELSE 'VL_ITEM' END  nm_atributo,
		56 nr_seq_info_ctb,
		a.nr_seq_item_cancel
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado x,
		pls_segurado		c,
		pls_mensalidade		e,
		pls_plano		d,
		pls_lote_mensalidade	f
	where	x.nr_sequencia		= a.nr_seq_mensalidade_seg
	and	x.nr_seq_segurado	= c.nr_sequencia
	and	e.nr_sequencia		= x.nr_seq_mensalidade
	and	c.nr_seq_plano		= d.nr_sequencia
	and	f.nr_sequencia		= e.nr_seq_lote
	and	e.nr_sequencia		= nr_seq_mensalidade_w
	and	a.ie_tipo_item <> '3'
	
union all

	select	'D',
		'C',
		CASE WHEN ie_tipo_conta_w='DA' THEN  CASE WHEN ie_contab_antec_copartic_w='N' THEN  f.cd_conta_deb  ELSE f.cd_conta_deb_antecip END   ELSE f.cd_conta_deb END ,
		coalesce(f.vl_copartic_mens,f.vl_coparticipacao) vl_coparticipacao,
		f.cd_historico,
		c.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,255)
			from	valor_dominio
			where	cd_dominio = 1930
			and	vl_dominio = c.ie_tipo_item), --substr(obter_valor_dominio(1930,c.ie_tipo_item),1,255),
		g.ie_tipo_segurado,
		h.ie_tipo_contratacao,
		f.nr_sequencia,
		null cd_conta_ato_cooperado,
		null cd_conta_ato_auxiliar,
		null cd_conta_ato_nao_coop,
		null vl_ato_cooperado,
		null vl_ato_auxiliar,
		null vl_ato_nao_cooperado,
		e.nr_sequencia,
		c.ie_tipo_item,
		c.cd_centro_custo,
		g.nr_sequencia,
		h.ie_regulamentacao,
		a.ie_cancelamento,
		e.dt_mesano_referencia dt_referencia_lote,
		c.nr_seq_vinculo_sca,
		c.nr_seq_esquema,
		'PLS_CONTA_COPARTICIPACAO' nm_tabela,
		'VL_COPARTICIPACAO' nm_atributo,
		57 nr_seq_info_ctb,
		c.nr_seq_item_cancel
	from	pls_mensalidade			a,
		pls_mensalidade_segurado	b,
		pls_mensalidade_seg_item	c,
		pls_conta			d,
		pls_lote_mensalidade		e,
		pls_conta_coparticipacao	f,
		pls_segurado			g,
		pls_plano			h
	where	a.nr_sequencia	= b.nr_seq_mensalidade
	and	b.nr_sequencia	= c.nr_seq_mensalidade_seg
	and	c.nr_seq_conta	= d.nr_sequencia
	and	d.nr_sequencia	= f.nr_seq_conta
	and	g.nr_sequencia	= b.nr_seq_segurado
	and	h.nr_sequencia	= g.nr_seq_plano
	and	e.nr_sequencia 	= a.nr_seq_lote
	and	a.nr_sequencia	= nr_seq_mensalidade_w
	and	c.ie_tipo_item	= '3'
	
union all

	select	'C',
		'C',
		CASE WHEN ie_tipo_conta_w='CA' THEN f.cd_conta_cred_antecip  ELSE f.cd_conta_cred END ,
		coalesce(f.vl_copartic_mens,f.vl_coparticipacao) vl_coparticipacao,
		f.cd_historico,
		c.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,255)
			from	valor_dominio
			where	cd_dominio = 1930
			and	vl_dominio = c.ie_tipo_item), --substr(obter_valor_dominio(1930,c.ie_tipo_item),1,255),
		g.ie_tipo_segurado,
		h.ie_tipo_contratacao,
		f.nr_sequencia,
		null cd_conta_ato_cooperado,
		null cd_conta_ato_auxiliar,
		null cd_conta_ato_nao_coop,
		null vl_ato_cooperado,
		null vl_ato_auxiliar,
		null vl_ato_nao_cooperado,
		e.nr_sequencia,
		c.ie_tipo_item,
		c.cd_centro_custo,
		g.nr_sequencia,
		h.ie_regulamentacao,
		a.ie_cancelamento,
		e.dt_mesano_referencia dt_referencia_lote,
		c.nr_seq_vinculo_sca,
		c.nr_seq_esquema,
		'PLS_CONTA_COPARTICIPACAO' nm_tabela,
		'VL_COPARTICIPACAO' nm_atributo,
		57 nr_seq_info_ctb,
		c.nr_seq_item_cancel
	from	pls_mensalidade			a,
		pls_mensalidade_segurado	b,
		pls_mensalidade_seg_item	c,
		pls_conta			d,
		pls_lote_mensalidade		e,
		pls_conta_coparticipacao	f,
		pls_segurado			g,
		pls_plano			h
	where	a.nr_sequencia	= b.nr_seq_mensalidade
	and	b.nr_sequencia	= c.nr_seq_mensalidade_seg
	and	c.nr_seq_conta	= d.nr_sequencia
	and	d.nr_sequencia	= f.nr_seq_conta
	and	g.nr_sequencia	= b.nr_seq_segurado
	and	h.nr_sequencia	= g.nr_seq_plano
	and	e.nr_sequencia	= a.nr_seq_lote
	and	a.nr_sequencia	= nr_seq_mensalidade_w
	and	c.ie_tipo_item	= '3';

nr_vetor_w			bigint	:= 0;
type registro is table of w_movimento_contabil%RowType index by integer;
w_movto_contabil_w		registro;


BEGIN
select	dt_referencia,
	cd_estabelecimento,
	nr_lote_contabil
into STRICT 	dt_referencia_w,
	cd_estabelecimento_w,
	nr_lote_contabil_w
from 	lote_contabil
where 	nr_lote_contabil 	= nr_lote_contabil_p;

begin
select	coalesce(ie_recebimento_antec_passivo,'N'),
	coalesce(ie_contab_antec_copartic,'S')
into STRICT	ie_recebimento_antec_passivo_w,
	ie_contab_antec_copartic_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_w;
exception
when others then
	ie_recebimento_antec_passivo_w	:= 'N';
	ie_contab_antec_copartic_w	:= 'S';
end;

nr_seq_w_movto_cont_w	:= 0;

nm_agrupador_w	:= trim(both obter_agrupador_contabil(21));
nr_seq_pagador_ant_w	:= null;

open C01;
loop
fetch C01 into
	nr_seq_mensalidade_w,
	nr_lote_contab_antecip_w,
	nr_seq_pagador_w,
	nr_titulo_w,
	nr_seq_lote_mensalidade_w,
	dt_antecipacao_w,
	dt_mesano_referencia_w,
	dt_liquidacao_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ie_contab_rec_antec_w	:= 'N';

	if (coalesce(nr_lote_contab_antecip_w,0) <> 0) then
		if (nr_lote_contab_antecip_w = nr_lote_contabil_p) then
			ie_tipo_conta_w := 'CA'; /* Crédito antecipação */
			dt_referencia_mov_w := dt_antecipacao_w;
		elsif (nr_lote_contab_antecip_w <> nr_lote_contabil_p) then
			ie_tipo_conta_w := 'DA'; /* Débito antecipação */
			dt_referencia_mov_w := dt_mesano_referencia_w;
		end if;
	else
		ie_tipo_conta_w := 'N'; /* Normal */
		dt_referencia_mov_w := dt_mesano_referencia_w;
	end if;

	if (ie_recebimento_antec_passivo_w = 'S') then
		select	count(1)
		into STRICT	qt_baixas_titulo_w
		from	titulo_receber_liq
		where	nr_titulo	= nr_titulo_w;

		if	((qt_baixas_titulo_w > 0) and (dt_liquidacao_titulo_w IS NOT NULL AND dt_liquidacao_titulo_w::text <> '') and (dt_liquidacao_titulo_w < dt_mesano_referencia_w)) then
			ie_contab_rec_antec_w	:= 'S';
		else
			ie_contab_rec_antec_w	:= 'N';
		end if;
	end if;

	if (nr_seq_pagador_ant_w != nr_seq_pagador_w) or (coalesce(nr_seq_pagador_ant_w::text, '') = '') then
		select	a.cd_cgc,
			a.cd_pessoa_fisica
		into STRICT	cd_cgc_pagador_w,
			cd_pf_pagador_w
		from	pls_contrato_pagador	a
		where	a.nr_sequencia = nr_seq_pagador_w;

		nm_pagador_w	:= null;

		if (cd_pf_pagador_w IS NOT NULL AND cd_pf_pagador_w::text <> '') then
			select	x.nm_pessoa_fisica
			into STRICT	nm_pagador_w
			from	pessoa_fisica x
			where	x.cd_pessoa_fisica	= cd_pf_pagador_w;
		elsif (cd_cgc_pagador_w IS NOT NULL AND cd_cgc_pagador_w::text <> '') then
			select	y.ds_razao_social
			into STRICT	nm_pagador_w
			from	pessoa_juridica y
			where	y.cd_cgc	= cd_cgc_pagador_w;
		end if;
	end if;

	nr_seq_pagador_ant_w	:= nr_seq_pagador_w;

	open C02;
	loop
	fetch C02 into
		ie_debito_credito_w,
		ie_tipo_valor_w,
		cd_conta_contabil_w,
		vl_contabil_w,
		cd_historico_w,
		nr_seq_item_w,
		ds_item_w,
		ie_tipo_segurado_w,
		ie_tipo_contratacao_w,
		nr_seq_copartic_w,
		cd_conta_ato_coop_w,
		cd_conta_ato_aux_w,
		cd_conta_ato_nao_coop_w,
		vl_ato_cooperado_princ_w,
		vl_ato_cooperado_aux_w,
		vl_ato_nao_cooperado_w,
		nr_seq_lote_mensalidade_w,
		ie_tipo_item_w,
		cd_centro_custo_w,
		nr_seq_segurado_w,
		ie_regulamentacao_w,
		ie_cancelamento_w,
		dt_referencia_lote_w,
		nr_seq_vinculo_sca_w,
		nr_seq_esquema_w,
		nm_tabela_w,
		nm_atributo_w,
		nr_seq_info_ctb_w,
		nr_seq_item_cancel_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		ds_compl_historico_w	:= null;
		/* Lepinski - Comentei porque a inversão para o cancelamento já é realizada na rotina agrupa_movimento_contabil
		if	(ie_cancelamento_w = 'E') then
			Lepinski - OS 396869 - Inverter as contas no estorno
			if	(ie_debito_credito_w = 'D') then
				ie_debito_credito_w	:= 'C';
			else
				ie_debito_credito_w	:= 'D';
			end if;
		end if; */
		if (coalesce(cd_historico_w::text, '') = '') then
			/*begin
			select	max(cd_historico)
			into	cd_historico_w
			from	pls_conta_receita_futura
			where	cd_estabelecimento	= cd_estabelecimento_w
			and	trunc(sysdate) between trunc(dt_vigencia_inicial) and fim_dia(nvl(dt_vigencia_final,sysdate))
			and	nvl(ie_tipo_contratacao,nvl(ie_tipo_contratacao_w,'0'))	= nvl(ie_tipo_contratacao_w,'0')
			and	ie_tipo_segurado	= ie_tipo_segurado_w;
			exception
			when others then
				wheb_mensagem_pck.exibir_mensagem_abort( 185390, null);

			end;*/
			--if	(cd_historico_w is null) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort( 185389, 'NR_SEQ_PAGADOR='|| nr_seq_pagador_w ||';'||'NR_SEQ_LOTE='||nr_seq_lote_mensalidade_w);
			--end if;
		end if;

		if (coalesce(nr_titulo_w::text, '') = '') then
			begin

			select	max(d.nr_titulo)
			into STRICT	nr_titulo_w
			from	titulo_receber d,
				pls_mensalidade c,
				pls_mensalidade_segurado b,
				pls_mensalidade_seg_item a
			where	d.nr_seq_mensalidade = c.nr_sequencia
			and	c.nr_sequencia = b.nr_seq_mensalidade
			and	b.nr_sequencia = a.nr_seq_mensalidade_seg
			and	a.nr_seq_item_cancel = nr_seq_item_w;

			end;
		end if;

		/* Lepinski - OS 456905 - Definir o agrupador contábil */

		if (nm_agrupador_w = 'NR_SEQ_LOTE') then
			nr_seq_agrupamento_w	:= nr_seq_lote_mensalidade_w;
		elsif (nm_agrupador_w = 'NR_SEQ_PAGADOR') then
			nr_seq_agrupamento_w	:= nr_seq_pagador_w;
		elsif (nm_agrupador_w = 'NR_TITULO') then
			nr_seq_agrupamento_w	:= nr_titulo_w;
		elsif (nm_agrupador_w = 'IE_TIPO_ITEM') then
			nr_seq_agrupamento_w	:= ie_tipo_item_w;
		else
			nr_seq_agrupamento_w	:= nr_seq_copartic_w;
		end if;

		if not(	(ie_tipo_item_w = '3') and (ie_contab_antec_copartic_w = 'N') and (ie_tipo_conta_w = 'CA')) then /* OS 479500 - sideker - A coparticipação não poderá ser contabilizada no mês de antecipação se o IE_CONTAB_ANTEC_COPARTIC_W for igual a 'N' */
			begin
			if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then
				select	ie_centro_custo
				into STRICT	ie_centro_custo_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;

				if (ie_centro_custo_w = 'N') then
					cd_centro_custo_w	:= null;
				elsif	((ie_centro_custo_w = 'S') and (coalesce(cd_centro_custo_w::text, '') = '')) then
					SELECT * FROM pls_obter_centro_custo(	'R', null, cd_estabelecimento_w, '', ie_tipo_contratacao_w, ie_regulamentacao_w, nr_seq_segurado_w, ie_tipo_item_w, cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
				end if;

				select	count(1)
				into STRICT	qt_compl_hist_w
				from	historico_padrao_atributo
				where	cd_tipo_lote_contabil = 21
				and	cd_historico	= cd_historico_w  LIMIT 1;

				if (qt_compl_hist_w > 0) then
					select	max(nr_nota_fiscal)
					into STRICT	nr_nota_fiscal_w
					from	nota_fiscal
					where	nr_sequencia	= nr_seq_nota_fiscal_w;

					nr_nota_fiscal_w	:= somente_numero(nr_nota_fiscal_w);

					if (coalesce(nr_seq_vinculo_sca_w,0) > 0) then
						select	max(c.ds_classificacao)
						into STRICT	ds_classif_sca_w
						from	pls_sca_classificacao	c,
							pls_sca_vinculo		b,
							pls_plano 		a
						where	a.nr_sequencia	= b.nr_seq_plano
						and	c.nr_sequencia	= a.nr_seq_classificacao
						and	b.nr_sequencia	= nr_seq_vinculo_sca_w;
					end if;

					if (coalesce(nr_seq_esquema_w,0) > 0) then
						select	max(b.ds_grupo)
						into STRICT	ds_grupo_w
						from	pls_contab_mov_mens_lote	b,
							pls_esquema_contabil		a
						where	b.nr_sequencia	= a.nr_seq_movimentacao
						and	a.nr_sequencia	= nr_seq_esquema_w;
					end if;

					ds_conteudo_w	:= substr(	nr_nota_fiscal_w		||'#@'||
									cd_cgc_pagador_w		||'#@'||
									cd_pf_pagador_w			||'#@'||
									nr_titulo_w			||'#@'||
									nm_pagador_w			||'#@'||
									nr_seq_lote_mensalidade_w	||'#@'||
									nr_seq_regra_w			||'#@'||
									dt_referencia_lote_w		||'#@'||
									ds_item_w			||'#@'||
									ds_classif_sca_w		||'#@'||
									ds_grupo_w,1,4000);

					/*select	obter_compl_historico(21, cd_historico_w, ds_conteudo_w)
					into	ds_compl_historico_ww
					from	dual;*/
					begin
					ds_compl_historico_ww	:= obter_compl_historico(21, cd_historico_w, ds_conteudo_w);
					exception
					when others then
						ds_compl_historico_ww	:= null;
					end;

					ds_compl_historico_w	:= substr(ds_compl_historico_ww,1,255);--substr(nvl(ds_compl_historico_ww, ds_compl_historico_w),1,255);
				end if;

				nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

				nr_vetor_w		:= nr_vetor_w + 1;
				w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
				w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
				w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_contabil_w;
				w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= ie_debito_credito_w;
				w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_w;
				w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
				w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_contabil_w;
				w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
				w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= cd_centro_custo_w;
				w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_historico_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
				w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_item_w;
				w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
				w_movto_contabil_w[nr_vetor_w].nm_atributo		:= nm_atributo_w;
			elsif	((ie_debito_credito_w = 'C') and (ie_tipo_valor_w = 'N') and
				((cd_conta_ato_coop_w IS NOT NULL AND cd_conta_ato_coop_w::text <> '') or (cd_conta_ato_aux_w IS NOT NULL AND cd_conta_ato_aux_w::text <> '') or (cd_conta_ato_nao_coop_w IS NOT NULL AND cd_conta_ato_nao_coop_w::text <> ''))) then
				/*Lepinski - OS 320998 */

				select	count(*)
				into STRICT	qt_compl_hist_w
				from	historico_padrao_atributo
				where	cd_tipo_lote_contabil	= 21
				and	cd_historico		= cd_historico_w;

				if (qt_compl_hist_w > 0) then
					select	max(nr_nota_fiscal)
					into STRICT	nr_nota_fiscal_w
					from	nota_fiscal
					where	nr_sequencia	= nr_seq_nota_fiscal_w;

					nr_nota_fiscal_w	:= somente_numero(nr_nota_fiscal_w);

					if (coalesce(nr_seq_vinculo_sca_w,0) > 0) then
						select	max(c.ds_classificacao)
						into STRICT	ds_classif_sca_w
						from	pls_sca_classificacao	c,
							pls_sca_vinculo 	b,
							pls_plano 		a
						where	a.nr_sequencia	= b.nr_seq_plano
						and	c.nr_sequencia	= a.nr_seq_classificacao
						and	b.nr_sequencia	= nr_seq_vinculo_sca_w;
					end if;

					if (coalesce(nr_seq_esquema_w,0) > 0) then
						select	max(b.ds_grupo)
						into STRICT	ds_grupo_w
						from	pls_contab_mov_mens_lote	b,
							pls_esquema_contabil 		a
						where	b.nr_sequencia	= a.nr_seq_movimentacao
						and	a.nr_sequencia	= nr_seq_esquema_w;
					end if;

					ds_conteudo_w	:= substr(	nr_nota_fiscal_w		||'#@'||
									cd_cgc_pagador_w 		||'#@'||
									cd_pf_pagador_w			||'#@'||
									nr_titulo_w			||'#@'||
									nm_pagador_w			||'#@'||
									nr_seq_lote_mensalidade_w 	||'#@'||
									nr_seq_regra_w			||'#@'||
									dt_referencia_lote_w		||'#@'||
									ds_item_w			||'#@'||
									ds_classif_sca_w		||'#@'||
									ds_grupo_w,1,4000);

					begin
					ds_compl_historico_ww	:= obter_compl_historico(21, cd_historico_w, ds_conteudo_w);
					exception
					when others then
						ds_compl_historico_ww	:= null;
					end;

					ds_compl_historico_w	:= substr(ds_compl_historico_ww,1,255);--substr(nvl(ds_compl_historico_ww, ds_compl_historico_w),1,255);
				end if;

				/*		ATO  COOPERADO		*/

				if (vl_ato_cooperado_princ_w <> 0) then
					if (cd_conta_ato_coop_w IS NOT NULL AND cd_conta_ato_coop_w::text <> '') then
						select	ie_centro_custo
						into STRICT	ie_centro_custo_w
						from	conta_contabil
						where	cd_conta_contabil = cd_conta_ato_coop_w;

						if (ie_centro_custo_w = 'N') then
							cd_centro_custo_w	:= null;
						elsif 	((ie_centro_custo_w = 'S') and (coalesce(cd_centro_custo_w::text, '') = '')) then
							SELECT * FROM pls_obter_centro_custo(	'R', null, cd_estabelecimento_w, '', ie_tipo_contratacao_w, ie_regulamentacao_w, nr_seq_segurado_w, ie_tipo_item_w, cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
						end if;

						nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

						nr_vetor_w		:= nr_vetor_w + 1;
						w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
						w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
						w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_ato_coop_w;
						w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= ie_debito_credito_w;
						w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_w;
						w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
						w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_ato_cooperado_princ_w;
						w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
						w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= cd_centro_custo_w;
						w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_historico_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
						w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_item_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
						w_movto_contabil_w[nr_vetor_w].nm_atributo		:= 'VL_ATO_COOPERADO';
					else
						select	nextval('w_pls_movimento_sem_conta_seq')
						into STRICT	nr_seq_mov_sem_conta_w
						;

						insert into w_pls_movimento_sem_conta(nr_sequencia,
							cd_item,
							ds_item,
							ie_tipo_item,
							dt_atualizacao,
							nm_usuario,
							vl_item,
							dt_referencia,
							nr_lote_contabil,
							ie_proc_mat_item,
							ie_deb_cred,
							ds_observacao,
							ie_tipo_ato_cooperado,
							cd_tipo_lote_contabil)
						values (nr_seq_mov_sem_conta_w,
							nr_seq_item_w,
							ds_item_w,
							'M',
							clock_timestamp(),
							nm_usuario_p,
							vl_ato_cooperado_princ_w,
							dt_referencia_w,
							nr_lote_contabil_w,
							null,
							ie_debito_credito_w,
							wheb_mensagem_pck.get_texto(300647),
							'1',
							21);
					end if;
				end if;

				/*		ATO  AUXILIAR		*/

				if (vl_ato_cooperado_aux_w <> 0) then
					if (cd_conta_ato_aux_w IS NOT NULL AND cd_conta_ato_aux_w::text <> '') then
						select	ie_centro_custo
						into STRICT	ie_centro_custo_w
						from	conta_contabil
						where	cd_conta_contabil = cd_conta_ato_aux_w;

						if (ie_centro_custo_w = 'N') then
							cd_centro_custo_w	:= null;
						elsif 	((ie_centro_custo_w = 'S') and (coalesce(cd_centro_custo_w::text, '') = '')) then
							SELECT * FROM pls_obter_centro_custo(	'R', null, cd_estabelecimento_w, '', ie_tipo_contratacao_w, ie_regulamentacao_w, nr_seq_segurado_w, ie_tipo_item_w, cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
						end if;

						nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

						nr_vetor_w		:= nr_vetor_w + 1;
						w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
						w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
						w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_ato_aux_w;
						w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= ie_debito_credito_w;
						w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_w;
						w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
						w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_ato_cooperado_aux_w;
						w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
						w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= cd_centro_custo_w;
						w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_historico_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
						w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_item_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
						w_movto_contabil_w[nr_vetor_w].nm_atributo		:= 'VL_ATO_AUXILIAR';
					else
						select	nextval('w_pls_movimento_sem_conta_seq')
						into STRICT	nr_seq_mov_sem_conta_w
						;

						insert into w_pls_movimento_sem_conta(nr_sequencia,
							cd_item,
							ds_item,
							ie_tipo_item,
							dt_atualizacao,
							nm_usuario,
							vl_item,
							dt_referencia,
							nr_lote_contabil,
							ie_proc_mat_item,
							ie_deb_cred,
							ds_observacao,
							ie_tipo_ato_cooperado,
							cd_tipo_lote_contabil)
						values (nr_seq_mov_sem_conta_w,
							nr_seq_item_w,
							ds_item_w,
							'M',
							clock_timestamp(),
							nm_usuario_p,
							vl_ato_cooperado_aux_w,
							dt_referencia_w,
							nr_lote_contabil_w,
							null,
							ie_debito_credito_w,
							wheb_mensagem_pck.get_texto(299465),
							'2',
							21);
					end if;
				end if;

				/*		ATO  NÂO COOPERADO		*/

				if (vl_ato_nao_cooperado_w <> 0) then
					if (cd_conta_ato_nao_coop_w IS NOT NULL AND cd_conta_ato_nao_coop_w::text <> '') then
						select	ie_centro_custo
						into STRICT	ie_centro_custo_w
						from	conta_contabil
						where	cd_conta_contabil = cd_conta_ato_nao_coop_w;

						if (ie_centro_custo_w = 'N') then
							cd_centro_custo_w	:= null;
						elsif 	((ie_centro_custo_w = 'S') and (coalesce(cd_centro_custo_w::text, '') = '')) then
							SELECT * FROM pls_obter_centro_custo(	'R', null, cd_estabelecimento_w, '', ie_tipo_contratacao_w, ie_regulamentacao_w, nr_seq_segurado_w, ie_tipo_item_w, cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
						end if;

						nr_seq_w_movto_cont_w	:= nr_seq_w_movto_cont_w + 1;

						nr_vetor_w		:= nr_vetor_w + 1;
						w_movto_contabil_w[nr_vetor_w].nr_lote_contabil		:= nr_lote_contabil_p;
						w_movto_contabil_w[nr_vetor_w].nr_sequencia		:= nr_seq_w_movto_cont_w;
						w_movto_contabil_w[nr_vetor_w].cd_conta_contabil	:= cd_conta_ato_nao_coop_w;
						w_movto_contabil_w[nr_vetor_w].ie_debito_credito	:= ie_debito_credito_w;
						w_movto_contabil_w[nr_vetor_w].cd_historico		:= cd_historico_w;
						w_movto_contabil_w[nr_vetor_w].dt_movimento		:= dt_referencia_mov_w;
						w_movto_contabil_w[nr_vetor_w].vl_movimento		:= vl_ato_nao_cooperado_w;
						w_movto_contabil_w[nr_vetor_w].cd_estabelecimento	:= cd_estabelecimento_w;
						w_movto_contabil_w[nr_vetor_w].cd_centro_custo		:= cd_centro_custo_w;
						w_movto_contabil_w[nr_vetor_w].ds_compl_historico	:= ds_compl_historico_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
						w_movto_contabil_w[nr_vetor_w].nm_tabela		:= nm_tabela_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_tab_orig		:= nr_seq_item_w;
						w_movto_contabil_w[nr_vetor_w].nr_seq_info		:= nr_seq_info_ctb_w;
						w_movto_contabil_w[nr_vetor_w].nm_atributo		:= 'VL_ATO_NAO_COOPERADO';
					else
						select	nextval('w_pls_movimento_sem_conta_seq')
						into STRICT	nr_seq_mov_sem_conta_w
						;

						insert into w_pls_movimento_sem_conta(nr_sequencia,
							cd_item,
							ds_item,
							ie_tipo_item,
							dt_atualizacao,
							nm_usuario,
							vl_item,
							dt_referencia,
							nr_lote_contabil,
							ie_proc_mat_item,
							ie_deb_cred,
							ds_observacao,
							ie_tipo_ato_cooperado,
							cd_tipo_lote_contabil)
						values (nr_seq_mov_sem_conta_w,
							nr_seq_item_w,
							ds_item_w,
							'M',
							clock_timestamp(),
							nm_usuario_p,
							vl_ato_nao_cooperado_w,
							dt_referencia_w,
							nr_lote_contabil_w,
							null,
							ie_debito_credito_w,
							wheb_mensagem_pck.get_texto(299467),
							'3',
							21);
					end if;
				end if;
			else
				select	nextval('w_pls_movimento_sem_conta_seq')
				into STRICT	nr_seq_mov_sem_conta_w
				;

				insert into w_pls_movimento_sem_conta(nr_sequencia,
					cd_item,
					ds_item,
					ie_tipo_item,
					dt_atualizacao,
					nm_usuario,
					vl_item,
					dt_referencia,
					nr_lote_contabil,
					ie_proc_mat_item,
					ie_deb_cred,
					ds_observacao,
					ie_tipo_ato_cooperado,
					cd_tipo_lote_contabil)
				values (nr_seq_mov_sem_conta_w,
					nr_seq_item_w,
					ds_item_w,
					'M',
					clock_timestamp(),
					nm_usuario_p,
					vl_contabil_w,
					dt_referencia_w,
					nr_lote_contabil_w,
					null,
					ie_debito_credito_w,
					CASE WHEN ie_tipo_valor_w='C' THEN wheb_mensagem_pck.get_texto(300648)  ELSE wheb_mensagem_pck.get_texto(300649) END ,
					null,
					21);
			end if;
			end;
		end if;

		if (nr_vetor_w >= 1000) then
			forall m in w_movto_contabil_w.first..w_movto_contabil_w.last
				insert into w_movimento_contabil values w_movto_contabil_w(m);

			nr_vetor_w	:= 0;
			w_movto_contabil_w.delete;

			commit;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

if (nr_vetor_w > 0) then
	forall m in w_movto_contabil_w.first..w_movto_contabil_w.last
		insert into w_movimento_contabil values w_movto_contabil_w(m);

	nr_vetor_w	:= 0;
	w_movto_contabil_w.delete;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_contab_receitas_ant ( nr_lote_contabil_p bigint, nm_usuario_p text) FROM PUBLIC;

