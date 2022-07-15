-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_atualizar_ppsc ( nr_seq_lote_p bigint, nr_seq_movimento_p bigint, nr_seq_movimento_item_p bigint, nr_seq_atualizacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


cd_classificacao_credito_w	varchar(255);
cd_classificacao_debito_w	varchar(255);
vl_fixo_w			varchar(30);
cd_conta_contabil_w		varchar(20);
cd_conta_credito_w		varchar(20);
cd_conta_debito_w		varchar(20);
ie_tipo_outorgante_w		varchar(3);
ie_segmentacao_w		varchar(3);
ie_tipo_beneficiario_w		varchar(3);
ie_tipo_benef_select_w		varchar(3);
ie_codificacao_w		varchar(2);
ie_tipo_item_w			varchar(2);
ie_tipo_pessoa_contrato_w	varchar(2);
ie_formacao_preco_w		varchar(2);
ie_debito_credito_w		varchar(1);
nr_seq_esquema_w		bigint;
nr_seq_movimento_w		bigint;
cd_historico_w			bigint;
nr_seq_movimento_item_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_sca_w			bigint;
nr_seq_plano_select_w		bigint;
nr_seq_sca_select_w		bigint;
nr_titulo_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_tipo_lanc_w		bigint;
dt_lote_w			timestamp;
nr_seq_tipo_acrescimo_w		bigint;
nr_seq_cheque_w			pls_ppsc_movimento.nr_seq_cheque%type;
cd_estab_cheque_w		cheque_cr.cd_estabelecimento%type;
ie_tipo_contratacao_w		pls_plano.ie_tipo_contratacao%type;
ds_mascara_w			varchar(30);
cd_classificacao_item_w		varchar(30);
cd_empresa_w			empresa.cd_empresa%type;

c_movimentacao CURSOR FOR
	SELECT	a.nr_sequencia,
		null,
		null,
		null,
		null,
		null,
		a.nr_seq_titulo,
		null nr_seq_tipo_acrescimo,
		a.nr_seq_cheque
	from	pls_ppsc_movimento	a,
		pls_ppsc_lote		b
	where	b.nr_sequencia	= a.nr_seq_lote
	and	b.nr_sequencia	= nr_seq_lote_p
	and	((a.nr_sequencia = nr_seq_movimento_p) or (coalesce(nr_seq_movimento_p::text, '') = ''))
	and	not exists (	SELECT	1
				from	pls_ppsc_movimento_item x
				where	x.nr_seq_movimento	= a.nr_sequencia)
	and	coalesce(nr_seq_movimento_item_p::text, '') = ''
	
union	all

	select	a.nr_sequencia,
		c.nr_sequencia,
		c.nr_seq_plano,
		c.nr_seq_plano_sca,
		c.ie_tipo_item,
		c.nr_seq_tipo_lancamento,
		a.nr_seq_titulo,
		c.nr_seq_tipo_acrescimo,
		null nr_seq_cheque
	from	pls_ppsc_movimento	a,
		pls_ppsc_lote		b,
		pls_ppsc_movimento_item	c
	where	b.nr_sequencia	= a.nr_seq_lote
	and	a.nr_sequencia	= c.nr_seq_movimento
	and	b.nr_sequencia	= nr_seq_lote_p
	and	((a.nr_sequencia = nr_seq_movimento_p) or (coalesce(nr_seq_movimento_p::text, '') = ''))
	and	((c.nr_sequencia = nr_seq_movimento_item_p) or (coalesce(nr_seq_movimento_item_p::text, '') = ''));

c_esquema CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_historico_padrao,
		coalesce(a.nr_seq_plano,0),
		coalesce(a.nr_seq_sca,0),
		coalesce(a.ie_tipo_beneficiario,' ')
	from	pls_esquema_contabil	a
	where	a.ie_tipo_regra	= 'PT'
	and	a.ie_tipo_movimentacao	in ('5','8')
	and	trunc(dt_lote_w,'dd') between trunc(a.dt_inicio_vigencia,'dd') and coalesce(trunc(a.dt_fim_vigencia,'dd'),trunc(dt_lote_w,'dd'))
	and	((a.nr_seq_plano = nr_seq_plano_w) or (coalesce(a.nr_seq_plano::text, '') = ''))
	and	((a.nr_seq_sca = nr_seq_sca_w) or (coalesce(a.nr_seq_sca::text, '') = ''))
	and	((a.ie_tipo_outorgante = ie_tipo_outorgante_w) or (coalesce(a.ie_tipo_outorgante::text, '') = ''))
	and	((a.ie_tipo_beneficiario = ie_tipo_beneficiario_w) or (coalesce(a.ie_tipo_beneficiario::text, '') = ''))
	and	((a.cd_estab_cheque = cd_estab_cheque_w) or (coalesce(a.cd_estab_cheque::text, '') = ''))
	and	((exists (SELECT	1
				from	pls_grupo_seg_item	l,
					pls_grupo_segmentacao	k
				where	k.nr_sequencia		= a.nr_seq_grupo_segmentacao
				and	l.nr_seq_grupo		= k.nr_sequencia
				and	l.ie_segmentacao	= ie_segmentacao_w)) or (coalesce(a.nr_seq_grupo_segmentacao::text, '') = ''))
	and	((exists (select	1
				from	pls_contab_mov_mens		y,
					pls_contab_mov_mens_lote	x
				where	y.nr_seq_lote	= x.nr_sequencia
				and	x.nr_sequencia	= a.nr_seq_movimentacao
				and	y.ie_tipo_item	= ie_tipo_item_w
				and (coalesce(y.nr_seq_tipo_lancamento,coalesce(nr_seq_tipo_lanc_w,0))	= coalesce(nr_seq_tipo_lanc_w,0))
				and (coalesce(y.nr_seq_tipo_acrescimo,coalesce(nr_seq_tipo_acrescimo_w,0))	= coalesce(nr_seq_tipo_acrescimo_w,0)))) or (coalesce(ie_tipo_item_w::text, '') = ''))
	order	by
		coalesce(a.nr_seq_plano,0),
		coalesce(a.nr_seq_sca,0),
		--nvl(a.nr_seq_grupo_contrato,0),

		--nvl(a.nr_seq_contrato,0),
		coalesce(a.ie_tipo_outorgante,' '),
		coalesce(a.nr_seq_movimentacao,0),
		coalesce(a.nr_seq_grupo_segmentacao,0),
		coalesce(a.ie_tipo_beneficiario,' '),
		coalesce(a.cd_estab_cheque,0),
		coalesce(a.dt_inicio_vigencia,clock_timestamp());

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

c_esquema_rev CURSOR FOR	/* Reversao da Provisao */
	SELECT	a.nr_sequencia,
		a.cd_historico_padrao,
		coalesce(a.nr_seq_plano,0) nr_seq_plano,
		coalesce(a.nr_seq_sca,0) nr_seq_sca,
		coalesce(a.ie_tipo_beneficiario,' ') ie_tipo_beneficiario
	from	pls_esquema_contabil	a
	where	a.ie_tipo_regra = 'PT'
	and	a.ie_tipo_movimentacao	in ('9','10')
	and	trunc(dt_lote_w,'dd') between trunc(a.dt_inicio_vigencia,'dd') and coalesce(trunc(a.dt_fim_vigencia,'dd'),trunc(dt_lote_w,'dd'))
	and	((a.nr_seq_plano = nr_seq_plano_w) or (coalesce(a.nr_seq_plano::text, '') = ''))
	and	((a.nr_seq_sca = nr_seq_sca_w) or (coalesce(a.nr_seq_sca::text, '') = ''))
	and	((a.ie_tipo_beneficiario = ie_tipo_beneficiario_w) or (coalesce(a.ie_tipo_beneficiario::text, '') = ''))
	and	((a.cd_estab_cheque = cd_estab_cheque_w) or (coalesce(a.cd_estab_cheque::text, '') = ''))
	and	((exists (SELECT	1
				from	pls_grupo_seg_item	l,
					pls_grupo_segmentacao	k
				where	k.nr_sequencia		= a.nr_seq_grupo_segmentacao
				and	l.nr_seq_grupo		= k.nr_sequencia
				and	l.ie_segmentacao	= ie_segmentacao_w)) or (coalesce(a.nr_seq_grupo_segmentacao::text, '') = ''))
	and	((exists (select	1
				from	pls_contab_mov_mens		y,
					pls_contab_mov_mens_lote	x
				where	y.nr_seq_lote	= x.nr_sequencia
				and	x.nr_sequencia	= a.nr_seq_movimentacao
				and	y.ie_tipo_item	= ie_tipo_item_w
				and (coalesce(y.nr_seq_tipo_lancamento,coalesce(nr_seq_tipo_lanc_w,0))	= coalesce(nr_seq_tipo_lanc_w,0)))) or (coalesce(ie_tipo_item_w::text, '') = ''))
	order	by
		coalesce(a.nr_seq_plano,0),
		coalesce(a.nr_seq_sca,0),
		--nvl(a.nr_seq_grupo_contrato,0),

		--nvl(a.nr_seq_contrato,0),
		coalesce(a.ie_tipo_outorgante,' '),
		coalesce(a.nr_seq_movimentacao,0),
		coalesce(a.nr_seq_grupo_segmentacao,0),
		coalesce(a.ie_tipo_beneficiario,' '),
		coalesce(a.cd_estab_cheque,0),
		coalesce(a.dt_inicio_vigencia,clock_timestamp());


BEGIN
select	dt_lote
into STRICT	dt_lote_w
from	pls_ppsc_lote
where	nr_sequencia	= nr_seq_lote_p;

select	max(ie_tipo_outorgante)
into STRICT	ie_tipo_outorgante_w
from	pls_outorgante
where	cd_estabelecimento	= cd_estabelecimento_p;

select	max(a.cd_empresa)
into STRICT	cd_empresa_w
from	estabelecimento a
where	a.cd_estabelecimento = cd_estabelecimento_p;

open c_movimentacao;
loop
fetch c_movimentacao into	
	nr_seq_movimento_w,
	nr_seq_movimento_item_w,
	nr_seq_plano_w,
	nr_seq_sca_w,
	ie_tipo_item_w,
	nr_seq_tipo_lanc_w,
	nr_titulo_w,
	nr_seq_tipo_acrescimo_w,
	nr_seq_cheque_w;
EXIT WHEN NOT FOUND; /* apply on c_movimentacao */
	begin
	nr_seq_esquema_w	:= null;
	cd_historico_w		:= null;
	cd_estab_cheque_w	:= null;
	ie_tipo_beneficiario_w	:= null;
	ie_segmentacao_w	:= null;
	
	select	max(c.nr_seq_contrato),
		max(c.nr_seq_pagador_intercambio)
	into STRICT	nr_seq_contrato_w,
		nr_seq_intercambio_w
	from	titulo_receber		a,
		pls_mensalidade		b,
		pls_contrato_pagador	c
	where	b.nr_sequencia	= a.nr_seq_mensalidade
	and	c.nr_sequencia	= b.nr_seq_pagador
	and	a.nr_titulo	= nr_titulo_w;
	
	if (nr_seq_cheque_w IS NOT NULL AND nr_seq_cheque_w::text <> '') then
		select	max(a.cd_estabelecimento)
		into STRICT	cd_estab_cheque_w
		from	cheque_cr	a
		where	nr_seq_cheque	= nr_seq_cheque_w;
	end if;
	
	if (coalesce(nr_seq_plano_w,0) <> 0) then
		select	max(ie_segmentacao),
			max(ie_tipo_contratacao)
		into STRICT	ie_segmentacao_w,
			ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_plano_w;
	elsif (coalesce(nr_seq_sca_w,0) <> 0) then
		select	max(ie_segmentacao),
			max(ie_tipo_contratacao)
		into STRICT	ie_segmentacao_w,
			ie_tipo_contratacao_w
		from	pls_plano
		where	nr_sequencia	= nr_seq_sca_w;
	end if;
	
	if (coalesce(nr_seq_contrato_w,0) <> 0) then
		select	CASE WHEN coalesce(max(cd_pf_estipulante)::text, '') = '' THEN 'PJ'  ELSE 'PF' END ,
			max(coalesce(ie_tipo_beneficiario,'BE'))
		into STRICT	ie_tipo_pessoa_contrato_w,
			ie_tipo_beneficiario_w
		from	pls_contrato
		where	nr_sequencia	= nr_seq_contrato_w;
		
		select	max(c.ie_preco)
		into STRICT	ie_formacao_preco_w
		from	pls_contrato		a,
			pls_contrato_plano	b,
			pls_plano		c
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	b.nr_seq_plano		= c.nr_sequencia
		and	b.ie_situacao		= 'A'
		and	a.nr_sequencia		= nr_seq_contrato_w;
	elsif (coalesce(nr_seq_intercambio_w,0) <> 0) then
		select	CASE WHEN coalesce(max(cd_pessoa_fisica)::text, '') = '' THEN 'PJ'  ELSE 'PF' END
		into STRICT	ie_tipo_pessoa_contrato_w
		from	pls_intercambio
		where	nr_sequencia	= nr_seq_intercambio_w;
		
		select	max(c.ie_preco)
		into STRICT	ie_formacao_preco_w
		from	pls_intercambio		a,
			pls_intercambio_plano	b,
			pls_plano		c
		where	a.nr_sequencia	= b.nr_seq_intercambio
		and	c.nr_sequencia	= b.nr_seq_plano
		and	a.nr_sequencia	= nr_seq_intercambio_w;
	end if;
	
	open c_esquema;
	loop
	fetch c_esquema into	
		nr_seq_esquema_w,
		cd_historico_w,
		nr_seq_plano_select_w,
		nr_seq_sca_select_w,
		ie_tipo_benef_select_w;
	EXIT WHEN NOT FOUND; /* apply on c_esquema */
	end loop;
	close c_esquema;
	
	cd_conta_credito_w		:= null;
	cd_conta_debito_w		:= null;
	cd_classificacao_credito_w	:= null;
	cd_classificacao_debito_w	:= null;
	
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
		
		if (ie_debito_credito_w = 'C') then
			if (ie_codificacao_w = 'CR') then /* Codigo Reduzido */
				select	cd_classificacao
				into STRICT	cd_classificacao_credito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
				
				cd_conta_credito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Codigo Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (PF ou PJ)*/
				if (ie_tipo_pessoa_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_pessoa_contrato_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
				if (ie_formacao_preco_w in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_formacao_preco_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'TC') then
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);
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
		elsif (ie_debito_credito_w = 'D') then
			if (ie_codificacao_w = 'CR') then /* Codigo Reduzido */
				select	cd_classificacao
				into STRICT	cd_classificacao_debito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
				
				cd_conta_debito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Codigo Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (PF ou PJ)*/
				if (ie_tipo_pessoa_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_pessoa_contrato_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
				if (ie_formacao_preco_w in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_formacao_preco_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'TC') then
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);
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
		select	max(a.cd_conta_contabil)
		into STRICT	cd_conta_credito_w
		from	conta_contabil		a,
			conta_contabil_classif	b
		where	a.cd_conta_contabil	= b.cd_conta_contabil
		and	b.cd_classificacao	= cd_classificacao_credito_w
		and	a.ie_tipo		= 'A'
		and	a.cd_empresa		= cd_empresa_w
		and	dt_lote_w between coalesce(a.dt_inicio_vigencia,dt_lote_w) and coalesce(a.dt_fim_vigencia,dt_lote_w)
		and	dt_lote_w between coalesce(b.dt_inicio_vigencia,dt_lote_w) and coalesce(b.dt_fim_vigencia,dt_lote_w);
		
		if (coalesce(cd_conta_credito_w::text, '') = '') then
			cd_conta_credito_w	:= ctb_obter_conta_classif(cd_classificacao_credito_w,dt_lote_w,cd_estabelecimento_p);
		end if;
	end if;
	
	if (coalesce(cd_conta_debito_w::text, '') = '') then
		select	max(a.cd_conta_contabil)
		into STRICT	cd_conta_debito_w
		from	conta_contabil		a,
			conta_contabil_classif	b
		where	a.cd_conta_contabil	= b.cd_conta_contabil
		and	b.cd_classificacao	= cd_classificacao_debito_w
		and	a.ie_tipo		= 'A'
		and	a.cd_empresa		= cd_empresa_w
		and	dt_lote_w between coalesce(a.dt_inicio_vigencia,dt_lote_w) and coalesce(a.dt_fim_vigencia,dt_lote_w)
		and	dt_lote_w between coalesce(b.dt_inicio_vigencia,dt_lote_w) and coalesce(b.dt_fim_vigencia,dt_lote_w);
		
		if (coalesce(cd_conta_debito_w::text, '') = '') then
			begin
			cd_conta_debito_w	:= ctb_obter_conta_classif(cd_classificacao_debito_w,dt_lote_w,cd_estabelecimento_p);
			exception
			when others then
				cd_conta_debito_w	:= null;
			end;
		end if;
	end if;
	
	if (coalesce(nr_seq_movimento_item_w,0) = 0) then
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 1, null, null, null, 'M', null, null, null, null, nr_seq_movimento_w, null, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 2, null, null, null, 'M', null, null, null, null, nr_seq_movimento_w, null, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			end if;
		end if;
		
		update	pls_ppsc_movimento
		set	cd_conta_debito		= cd_conta_debito_w,
			cd_conta_credito	= cd_conta_credito_w,
			cd_classif_deb		= cd_classificacao_debito_w,
			cd_classif_cred		= cd_classificacao_credito_w,
			cd_historico		= cd_historico_w,
			nr_seq_regra_contabil	= nr_seq_esquema_w
		where	nr_sequencia		= nr_seq_movimento_w;
	else
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 1, null, null, null, 'M', null, null, null, null, null, nr_seq_movimento_item_w, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 2, null, null, null, 'M', null, null, null, null, null, nr_seq_movimento_item_w, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			end if;
		end if;
		
		update	pls_ppsc_movimento_item
		set	cd_conta_deb		= cd_conta_debito_w,
			cd_conta_cred		= cd_conta_credito_w,
			cd_classif_deb		= cd_classificacao_debito_w,
			cd_classif_cred		= cd_classificacao_credito_w,
			cd_historico		= cd_historico_w,
			nr_seq_regra_contabil	= nr_seq_esquema_w
		where	nr_sequencia		= nr_seq_movimento_item_w;
	end if;
	
	/* ---------------------------------------------- REVERSAO -------------------------------------------------------- */

	nr_seq_esquema_w := null;

	open c_esquema_rev;
	loop
	fetch c_esquema_rev into	
		nr_seq_esquema_w,
		cd_historico_w,
		nr_seq_plano_select_w,
		nr_seq_sca_select_w,
		ie_tipo_benef_select_w;
	EXIT WHEN NOT FOUND; /* apply on c_esquema_rev */
	end loop;
	close c_esquema_rev;
	
	cd_conta_credito_w		:= null;
	cd_conta_debito_w		:= null;
	cd_classificacao_credito_w	:= null;
	cd_classificacao_debito_w	:= null;
	
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
		
		if (ie_debito_credito_w = 'C') then
			if (ie_codificacao_w = 'CR') then /* Codigo Reduzido */
				select	cd_classificacao
				into STRICT	cd_classificacao_credito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
				
				cd_conta_credito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Codigo Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (PF ou PJ)*/
				if (ie_tipo_pessoa_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_pessoa_contrato_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
				if (ie_formacao_preco_w in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_formacao_preco_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'TC') then
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);	
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
		elsif (ie_debito_credito_w = 'D') then
			if (ie_codificacao_w = 'CR') then /* Codigo Reduzido */
				select	cd_classificacao
				into STRICT	cd_classificacao_debito_w
				from	conta_contabil
				where	cd_conta_contabil	= cd_conta_contabil_w;
				
				cd_conta_debito_w	:= cd_conta_contabil_w;
			elsif (ie_codificacao_w = 'FX') then /* Codigo Fixo */
				cd_classificacao_item_w	:= vl_fixo_w;
			elsif (ie_codificacao_w = 'TP') then /* Tipo de Contrato (PF ou PJ)*/
				if (ie_tipo_pessoa_contrato_w in ('PF','PJ')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_pessoa_contrato(ie_tipo_pessoa_contrato_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'FP') then /* Formacao de Preco */
				if (ie_formacao_preco_w in ('1','2','3')) then
					cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_formacao_preco(ie_formacao_preco_w);
				else
					cd_classificacao_item_w	:= 'X';
				end if;
			elsif (ie_codificacao_w = 'TC') then
				cd_classificacao_item_w	:= pls_atualizar_codificacao_pck.get_tipo_contratacao(ie_tipo_contratacao_w);	
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
		select	max(a.cd_conta_contabil)
		into STRICT	cd_conta_credito_w
		from	conta_contabil		a,
			conta_contabil_classif	b
		where	a.cd_conta_contabil	= b.cd_conta_contabil
		and	b.cd_classificacao	= cd_classificacao_credito_w
		and	a.ie_tipo			= 'A'
		and	dt_lote_w between coalesce(a.dt_inicio_vigencia,dt_lote_w) and coalesce(a.dt_fim_vigencia,dt_lote_w)
		and	dt_lote_w between coalesce(b.dt_inicio_vigencia,dt_lote_w) and coalesce(b.dt_fim_vigencia,dt_lote_w);
		
		if (coalesce(cd_conta_credito_w::text, '') = '') then
			begin
			select	cd_conta_contabil
			into STRICT	cd_conta_credito_w
			from	conta_contabil
			where	cd_classificacao_atual	= cd_classificacao_credito_w
			and	ie_tipo			= 'A'
			and	dt_lote_w between coalesce(dt_inicio_vigencia,dt_lote_w) and coalesce(dt_fim_vigencia,dt_lote_w);
			exception
			when others then
				cd_conta_credito_w	:= null;
			end;
		end if;
	end if;
	
	if (coalesce(cd_conta_debito_w::text, '') = '') then
		select	max(a.cd_conta_contabil)
		into STRICT	cd_conta_debito_w
		from	conta_contabil		a,
			conta_contabil_classif	b
		where	a.cd_conta_contabil	= b.cd_conta_contabil
		and	b.cd_classificacao	= cd_classificacao_debito_w
		and	a.ie_tipo			= 'A'
		and	dt_lote_w between coalesce(a.dt_inicio_vigencia,dt_lote_w) and coalesce(a.dt_fim_vigencia,dt_lote_w)
		and	dt_lote_w between coalesce(b.dt_inicio_vigencia,dt_lote_w) and coalesce(b.dt_fim_vigencia,dt_lote_w);
		
		if (coalesce(cd_conta_debito_w::text, '') = '') then
			begin
			select	cd_conta_contabil
			into STRICT	cd_conta_debito_w
			from	conta_contabil
			where	cd_classificacao_atual	= cd_classificacao_debito_w
			and	ie_tipo			= 'A'
			and	dt_lote_w between coalesce(dt_inicio_vigencia,dt_lote_w) and coalesce(dt_fim_vigencia,dt_lote_w);
			exception
			when others then
				cd_conta_debito_w	:= null;
			end;
		end if;
	end if;
	
	if (coalesce(nr_seq_movimento_item_w,0) = 0) then
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 1, null, null, null, 'R', null, null, null, null, nr_seq_movimento_w, null, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 2, null, null, null, 'R', null, null, null, null, nr_seq_movimento_w, null, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			end if;
		end if;
		
		update	pls_ppsc_movimento
		set	cd_conta_deb_reversao		= cd_conta_debito_w,
			cd_conta_cred_reversao		= cd_conta_credito_w,
			cd_classif_deb_reversao		= cd_classificacao_debito_w,
			cd_classif_cred_reversao	= cd_classificacao_credito_w,
			cd_historico_reversao		= cd_historico_w,
			nr_seq_regra_cont_reversao	= nr_seq_esquema_w
		where	nr_sequencia			= nr_seq_movimento_w;
	else
		if (nr_seq_atualizacao_p IS NOT NULL AND nr_seq_atualizacao_p::text <> '') then
			if (coalesce(nr_seq_esquema_w::text, '') = '') then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 1, null, null, null, 'R', null, null, null, null, null, nr_seq_movimento_item_w, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			elsif	((coalesce(cd_conta_credito_w::text, '') = '') or (coalesce(cd_conta_debito_w::text, '') = '')) then
				CALL pls_gravar_mov_contabil(nr_seq_atualizacao_p, 2, null, null, null, 'R', null, null, null, null, null, nr_seq_movimento_item_w, null, null,null, null, null, nm_usuario_p, nr_seq_esquema_w);
			end if;
		end if;
		
		update	pls_ppsc_movimento_item
		set	cd_conta_deb_reversao		= cd_conta_debito_w,
			cd_conta_cred_reversao		= cd_conta_credito_w,
			cd_classif_deb_reversao		= cd_classificacao_debito_w,
			cd_classif_cred_reversao	= cd_classificacao_credito_w,
			cd_historico_reversao		= cd_historico_w,
			nr_seq_regra_cont_reversao	= nr_seq_esquema_w
		where	nr_sequencia			= nr_seq_movimento_item_w;
	end if;
	end;
end loop;
close c_movimentacao;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_atualizar_ppsc ( nr_seq_lote_p bigint, nr_seq_movimento_p bigint, nr_seq_movimento_item_p bigint, nr_seq_atualizacao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

