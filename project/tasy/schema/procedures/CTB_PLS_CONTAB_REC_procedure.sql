-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_pls_contab_rec ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


dt_referencia_w			timestamp;
cd_estabelecimento_w		smallint;
cd_conta_contabil_w		varchar(20);
ie_debito_credito_w		varchar(20);
vl_contabil_w			double precision;
vl_retorno_w			varchar(2000);
dt_referencia_mens_w		timestamp;
nr_seq_w_movto_cont_w		bigint;
cd_historico_w			bigint;
nr_seq_mensalidade_w		bigint;
nr_seq_nota_fiscal_w		bigint;
pr_imposto_w			double precision;
cd_tributo_w			smallint;
vl_imposto_w			double precision;
pr_imposto_total_w		double precision;
cd_conta_imposto_w		varchar(20);
cd_centro_custo_w		integer;
ie_centro_custo_w		varchar(1);
nr_seq_item_w			bigint;
ds_item_w			varchar(255);
nr_lote_contabil_w		bigint;
ie_tipo_valor_w			varchar(2);
nr_seq_pagador_w		bigint;
ie_tipo_pagador_w		varchar(2);
cd_historico_imposto_cred_w	bigint;
cd_historico_imposto_deb_w	bigint;
cd_historico_antecip_w		bigint;
ie_cancelamento_w		varchar(1);
nr_seq_regra_w			bigint;
ie_tipo_item_w			varchar(2);
nr_lote_contab_antecip_w	bigint;
ie_tipo_conta_w			varchar(2);
nr_nota_fiscal_w		varchar(255);
nr_titulo_w			bigint;
cd_cgc_pagador_w		varchar(14);
cd_pf_pagador_w			varchar(10);
ie_compl_hist_w			varchar(1);
ds_conteudo_w			varchar(4000);
ds_compl_historico_w		varchar(255);
ds_compl_historico_ww		varchar(255);
ds_compl_hist_imposto_cred_w	varchar(255);
ds_compl_hist_imposto_cred_ww	varchar(255);
ds_compl_hist_imposto_deb_w	varchar(255);
ds_compl_hist_imposto_deb_ww	varchar(255);
cd_conta_imposto_cred_w		varchar(20);
cd_conta_imposto_deb_w		varchar(20);
ie_tipo_segurado_w		varchar(3);
ie_tipo_contratacao_w		varchar(2);
nr_seq_copartic_w		bigint;
nm_pagador_w			varchar(255);
nr_seq_regra_cc_w		bigint;
nr_seq_segurado_w		bigint;
dt_referencia_trunc_w		timestamp;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.dt_referencia,
		d.nr_sequencia nr_seq_nota_fiscal,
		b.nr_seq_pagador,
		b.ie_cancelamento,
		a.nr_lote_contab_antecip,
		c.nr_titulo
	FROM pls_lote_mensalidade a, pls_mensalidade b
LEFT OUTER JOIN titulo_receber c ON (b.nr_sequencia = c.nr_seq_mensalidade)
LEFT OUTER JOIN nota_fiscal d ON (b.nr_sequencia = d.nr_seq_mensalidade)
WHERE a.nr_sequencia	= b.nr_seq_lote and (a.nr_lote_contabil		= nr_lote_contabil_p
	or (a.nr_lote_contab_antecip	= nr_lote_contabil_p and coalesce(b.ie_cancelamento::text, '') = ''));

C02 CURSOR FOR
	SELECT	'D',
		'N',
		CASE WHEN ie_tipo_conta_w='DA' THEN  a.cd_conta_deb_antecip  ELSE a.cd_conta_deb END ,
		coalesce(a.vl_item,0),
		coalesce(a.cd_historico,1),
		a.nr_sequencia,
		(	SELECT	substr(ds_valor_dominio,1,254)
			from	valor_dominio_v
			where	cd_dominio	= 1930
			and	vl_dominio	= a.ie_tipo_item) ds_item,
		a.nr_seq_regra_ctb_mensal_deb,
		a.ie_tipo_item,
		c.ie_tipo_segurado,
		e.ie_tipo_contratacao,
		CASE WHEN a.ie_tipo_item='13' THEN CASE WHEN coalesce(ie_cancelamento::text, '') = '' THEN 1  ELSE d.nr_sequencia END   ELSE 0 END ,
		c.nr_sequencia
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado b,
		pls_segurado		c,
		pls_mensalidade		d,
		pls_plano		e
	where	b.nr_sequencia		= a.nr_seq_mensalidade_seg
	and	b.nr_seq_segurado	= c.nr_sequencia
	and	d.nr_sequencia		= b.nr_seq_mensalidade
	and	c.nr_seq_plano		= e.nr_sequencia
	and	b.nr_seq_mensalidade	= nr_seq_mensalidade_w
	and	a.ie_tipo_item <> '3'
	
union all

	select	'C',
		'N',
		CASE WHEN ie_tipo_conta_w='CA' THEN  a.cd_conta_rec_antecip  ELSE a.cd_conta_rec END ,
		coalesce(a.vl_item,0),
		coalesce(a.cd_historico,1),
		a.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,254)
			from	valor_dominio_v
			where	cd_dominio	= 1930
			and	vl_dominio	= a.ie_tipo_item) ds_item,
		a.nr_seq_regra_ctb_mensal,
		a.ie_tipo_item,
		c.ie_tipo_segurado,
		e.ie_tipo_contratacao,
		CASE WHEN a.ie_tipo_item='13' THEN CASE WHEN coalesce(ie_cancelamento::text, '') = '' THEN 1  ELSE d.nr_sequencia END   ELSE 0 END ,
		c.nr_sequencia
	from	pls_mensalidade_seg_item a,
		pls_mensalidade_segurado b,
		pls_segurado		c,
		pls_mensalidade		d,
		pls_plano		e
	where	b.nr_seq_segurado	= c.nr_sequencia
	and	c.nr_seq_plano		= e.nr_sequencia
	and	d.nr_sequencia		= b.nr_seq_mensalidade
	and	b.nr_sequencia		= a.nr_seq_mensalidade_seg
	and	b.nr_seq_mensalidade	= nr_seq_mensalidade_w
	and	a.ie_tipo_item <> '3'
	
union all

	select	'D',
		'C',
		CASE WHEN ie_tipo_conta_w='DA' THEN f.cd_conta_deb_antecip  ELSE f.cd_conta_deb END ,
		coalesce(f.vl_copartic_mens, f.vl_coparticipacao) vl_coparticipacao,
		coalesce(f.cd_historico,1),
		c.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,254)
			from	valor_dominio_v
			where	cd_dominio	= 1930
			and	vl_dominio	= c.ie_tipo_item) ds_item,
		f.nr_seq_regra_ctb_deb,
		c.ie_tipo_item,
		g.ie_tipo_segurado,
		h.ie_tipo_contratacao,
		f.nr_sequencia,
		g.nr_sequencia
	from	pls_mensalidade a,
		pls_mensalidade_segurado b,
		pls_mensalidade_seg_item c,
		pls_conta		d,
		pls_conta_coparticipacao f,
		pls_segurado		g,
		pls_plano		h
	where	a.nr_sequencia	= b.nr_seq_mensalidade
	and	b.nr_sequencia	= c.nr_seq_mensalidade_seg
	and	c.nr_seq_conta	= d.nr_sequencia
	and	d.nr_sequencia	= f.nr_seq_conta
	and	g.nr_sequencia	= b.nr_seq_segurado
	and	h.nr_sequencia	= g.nr_seq_plano
	and	a.nr_sequencia	= nr_seq_mensalidade_w
	and	c.ie_tipo_item = '3'
	
union all

	select	'C',
		'C',
		CASE WHEN ie_tipo_conta_w='CA' THEN f.cd_conta_cred_antecip  ELSE f.cd_conta_cred END ,
		coalesce(f.vl_copartic_mens, f.vl_coparticipacao) vl_coparticipacao,
		coalesce(f.cd_historico,1),
		c.nr_sequencia,
		(	select	substr(ds_valor_dominio,1,254)
			from	valor_dominio_v
			where	cd_dominio	= 1930
			and	vl_dominio	= c.ie_tipo_item) ds_item,
		f.nr_seq_regra_ctb_cred,
		c.ie_tipo_item,
		g.ie_tipo_segurado,
		h.ie_tipo_contratacao,
		f.nr_sequencia,
		g.nr_sequencia
	from	pls_mensalidade 		a,
		pls_mensalidade_segurado 	b,
		pls_mensalidade_seg_item	c,
		pls_conta 			d,
		pls_conta_coparticipacao	f,
		pls_segurado			g,
		pls_plano			h
	where	a.nr_sequencia	= b.nr_seq_mensalidade
	and	b.nr_sequencia	= c.nr_seq_mensalidade_seg
	and	c.nr_seq_conta	= d.nr_sequencia
	and	d.nr_sequencia	= f.nr_seq_conta
	and	g.nr_sequencia	= b.nr_seq_segurado
	and	h.nr_sequencia	= g.nr_seq_plano	
	and	a.nr_sequencia	= nr_seq_mensalidade_w
	and	c.ie_tipo_item	= '3';


BEGIN

select	dt_referencia,
	trunc(dt_referencia,'month'),
	cd_estabelecimento,
	nr_lote_contabil
into STRICT 	dt_referencia_w,
	dt_referencia_trunc_w,
	cd_estabelecimento_w,
	nr_lote_contabil_w
from 	lote_contabil
where 	nr_lote_contabil 	= nr_lote_contabil_p;

select	obter_se_compl_tipo_lote(cd_estabelecimento_w, 21)
into STRICT	ie_compl_hist_w
;

delete	from	w_pls_movimento_sem_conta
where	ie_tipo_item = 'M';

if (ie_exclusao_p = 'S') then
	begin
	delete from movimento_contabil
	where  nr_lote_contabil		= nr_lote_contabil_p;

	Update	lote_contabil
	set	vl_credito 		= 0,
		vl_debito  		= 0
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	update	pls_lote_mensalidade
	set	nr_lote_contabil	 = NULL
	where	trunc(dt_mesano_referencia,'month') = dt_referencia_trunc_w
	and	ie_status	= 2
	and	cd_estabelecimento	= cd_estabelecimento_w;
	
	update	pls_lote_mensalidade
	set	nr_lote_contab_antecip	 = NULL
	where	trunc(dt_contabilizacao,'month') = dt_referencia_trunc_w
	and	ie_status	= 2
	and	cd_estabelecimento	= cd_estabelecimento_w;
	end;
else
	begin
	delete	FROM w_movimento_contabil
	where	nr_lote_contabil	= nr_lote_contabil_p;
	
	update	pls_lote_mensalidade
	set	nr_lote_contabil	= nr_lote_contabil_p
	where	coalesce(nr_lote_contabil,0)	= 0
  	and	trunc(dt_mesano_referencia,'month') = dt_referencia_trunc_w
	and	ie_status	= 2
	and	cd_estabelecimento	= cd_estabelecimento_w;
	
	update	pls_lote_mensalidade
	set	nr_lote_contab_antecip	= nr_lote_contabil_p
	where	coalesce(nr_lote_contab_antecip,0)	= 0
	and	trunc(dt_contabilizacao,'month') = dt_referencia_trunc_w
	and	ie_status	= 2
	and	cd_estabelecimento	= cd_estabelecimento_w;
	
	OPEN C01;
	LOOP
	FETCH C01 into
		nr_seq_mensalidade_w,
		dt_referencia_mens_w,
		nr_seq_nota_fiscal_w,
		nr_seq_pagador_w,
		ie_cancelamento_w,
		nr_lote_contab_antecip_w,
		nr_titulo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN 'PJ'  ELSE 'PF' END ,
			a.cd_cgc,
			a.cd_pessoa_fisica,
			(	select x.nm_pessoa_fisica
				from	pessoa_fisica x
				where	x.cd_pessoa_fisica = a.cd_pessoa_fisica
				
UNION ALL

				select	y.ds_razao_social
				from	pessoa_juridica y
				where	y.cd_cgc	= a.cd_cgc) nm_pagador
		into STRICT	ie_tipo_pagador_w,
			cd_cgc_pagador_w,
			cd_pf_pagador_w,
			nm_pagador_w
		from	pls_contrato_pagador	a
		where	a.nr_sequencia = nr_seq_pagador_w;
		
		/* Obter o valor total dos impostos */

		select	coalesce(sum(vl_tributo),0)
		into STRICT	vl_imposto_w
		from	nota_fiscal_trib
		where	nr_sequencia = nr_seq_nota_fiscal_w;
		
		/* Obter a conta de crédito do imposto */

		select	max(cd_conta_contabil),
			max(cd_historico)
		into STRICT	cd_conta_imposto_cred_w,
			cd_historico_imposto_cred_w
		from	pls_conta_contabil_imposto
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	trunc(clock_timestamp(),'dd') between trunc(dt_vigencia_inicial,'dd') and trunc(coalesce(dt_vigencia_final,clock_timestamp()),'dd')
		and	coalesce(ie_debito_credito,'C') = 'C'
		and	((ie_tipo_pessoa = ie_tipo_pagador_w) or (ie_tipo_pessoa = 'A'));
		
		if (coalesce(cd_conta_imposto_cred_w,'0') <> '0') and (vl_imposto_w > 0) then
			if (ie_compl_hist_w = 'S') then
				select	obter_compl_historico(21, cd_historico_imposto_cred_w, ds_conteudo_w)
				into STRICT	ds_compl_hist_imposto_cred_ww
				;
				ds_compl_hist_imposto_cred_w	:= substr(coalesce(ds_compl_hist_imposto_cred_ww, ds_compl_hist_imposto_cred_w),1,255);
			end if;
			
			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_seq_w_movto_cont_w
			from	w_movimento_contabil;
			
			insert into w_movimento_contabil(nr_lote_contabil, nr_sequencia, cd_conta_contabil,
				ie_debito_credito, cd_historico, dt_movimento,
				vl_movimento, cd_estabelecimento, cd_centro_custo,
				ds_compl_historico)
			values (	nr_lote_contabil_p, nr_seq_w_movto_cont_w, cd_conta_imposto_cred_w,
				'C', cd_historico_imposto_cred_w, dt_referencia_w,
				vl_imposto_w, cd_estabelecimento_w, null,
				ds_compl_hist_imposto_cred_w);
		end if;
		
		/* Obter a conta de crédito do imposto */

		select	max(cd_conta_contabil),
			max(cd_historico)
		into STRICT	cd_conta_imposto_deb_w,
			cd_historico_imposto_deb_w
		from	pls_conta_contabil_imposto
		where	cd_estabelecimento	= cd_estabelecimento_w
		and	trunc(clock_timestamp(),'dd') between trunc(dt_vigencia_inicial,'dd') and trunc(coalesce(dt_vigencia_final,clock_timestamp()),'dd')
		and	coalesce(ie_debito_credito,'D') = 'D'
		and	((ie_tipo_pessoa = ie_tipo_pagador_w) or (ie_tipo_pessoa = 'A'));
		
		if (coalesce(cd_conta_imposto_deb_w,'0') <> '0') and (vl_imposto_w > 0) then
			if (ie_compl_hist_w = 'S') then
				select	obter_compl_historico(21, cd_historico_imposto_deb_w, ds_conteudo_w)
				into STRICT	ds_compl_hist_imposto_deb_ww
				;
				ds_compl_hist_imposto_deb_w	:= substr(coalesce(ds_compl_hist_imposto_deb_ww, ds_compl_hist_imposto_deb_w),1,255);
			end if;
			
			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_seq_w_movto_cont_w
			from	w_movimento_contabil;
			
			insert into w_movimento_contabil(nr_lote_contabil, nr_sequencia, cd_conta_contabil,
				ie_debito_credito, cd_historico, dt_movimento,
				vl_movimento, cd_estabelecimento, cd_centro_custo,
				ds_compl_historico)
			values (	nr_lote_contabil_p, nr_seq_w_movto_cont_w, cd_conta_imposto_deb_w,
				'D', cd_historico_imposto_deb_w, dt_referencia_w,
				vl_imposto_w, cd_estabelecimento_w, null,
				ds_compl_hist_imposto_deb_w);
		end if;
		
		if (coalesce(nr_lote_contab_antecip_w,0) <> 0) then
			if (nr_lote_contab_antecip_w = nr_lote_contabil_p) then
				ie_tipo_conta_w := 'CA'; /* Crédito antecipação */
			elsif (nr_lote_contab_antecip_w <> nr_lote_contabil_p) then
				ie_tipo_conta_w := 'DA'; /* Débito antecipação */
			end if;
		else
			ie_tipo_conta_w := 'N'; /* Normal */
		end if;
		
		OPEN C02;
		LOOP
		FETCH C02 into
			ie_debito_credito_w,
			ie_tipo_valor_w,
			cd_conta_contabil_w,
			vl_contabil_w,
			cd_historico_w,
			nr_seq_item_w,
			ds_item_w,
			nr_seq_regra_w,
			ie_tipo_item_w,
			ie_tipo_segurado_w,
			ie_tipo_contratacao_w,
			nr_seq_copartic_w,
			nr_seq_segurado_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			cd_centro_custo_w := null;
			
			begin
			select	max(cd_historico)
			into STRICT	cd_historico_antecip_w
			from	pls_conta_receita_futura
			where	cd_estabelecimento	= cd_estabelecimento_w
			and	trunc(clock_timestamp()) between trunc(dt_vigencia_inicial) and fim_dia(coalesce(dt_vigencia_final,clock_timestamp()))
			and	coalesce(ie_tipo_contratacao,coalesce(ie_tipo_contratacao_w,'0'))	= coalesce(ie_tipo_contratacao_w,'0')
			and	ie_tipo_segurado	= ie_tipo_segurado_w;
			exception
			when others then
				CALL wheb_mensagem_pck.exibir_mensagem_abort( 267257, null );
				/* Não foi realizado o cadastro da conta financeira de antecipação. ' || chr(13) || '(Shift + F11 -> Plano de Saúde -> OPS - Contabilidade -> Regra contábil de receitas antecipação mensalidade) */

			end;
			
			if (ie_debito_credito_w	= 'C') then				
				select	CASE WHEN ie_tipo_conta_w='CA' THEN  cd_historico_antecip_w  ELSE cd_historico_w END
				into STRICT	cd_historico_w
				;
			elsif (ie_debito_credito_w	= 'D') then
				select	CASE WHEN ie_tipo_conta_w='DA' THEN  cd_historico_antecip_w  ELSE cd_historico_w END
				into STRICT	cd_historico_w
				;
			end if;
			
			if (ie_cancelamento_w = 'E') then /* Segundo contato com Adriano em 26/08/2008, o estorno deve ser contabilizado ao contrário se coparticipação*/
				select	max(cd_conta_estorno),
					max(cd_historico_estorno)
				into STRICT	cd_conta_contabil_w,
					cd_historico_w
				from	pls_regra_ctb_mensal
				where	nr_sequencia	= nr_seq_regra_w;
				
				if (ie_tipo_valor_w = 'C' and ie_debito_credito_w = 'C') then
					ie_debito_credito_w := 'D';
				elsif (ie_tipo_valor_w = 'C' and ie_debito_credito_w = 'D') then
					ie_debito_credito_w := 'C';
				end if;
			end if;
			
			if (coalesce(cd_conta_contabil_w::text, '') = '') then
				insert into w_pls_movimento_sem_conta(	
					nr_sequencia, cd_item, ds_item,
					ie_tipo_item, dt_atualizacao, nm_usuario,
					vl_item, dt_referencia, nr_lote_contabil,
					ie_proc_mat_item, ie_deb_cred, ds_observacao)
				values (	nextval('w_pls_movimento_sem_conta_seq'), nr_seq_item_w, ds_item_w,
					'M', clock_timestamp(), nm_usuario_p,
					vl_contabil_w, dt_referencia_w, nr_lote_contabil_w,
					null, ie_debito_credito_w, CASE WHEN ie_tipo_valor_w='C' THEN obter_desc_expressao(286241)  ELSE '' END );
			else
				select	ie_centro_custo
				into STRICT	ie_centro_custo_w
				from	conta_contabil
				where	cd_conta_contabil = cd_conta_contabil_w;
				
				if (ie_centro_custo_w = 'S') then
					SELECT * FROM pls_obter_centro_custo('R', null, cd_estabelecimento_w, '', '', '', nr_seq_segurado_w, ie_tipo_item_w, cd_centro_custo_w, nr_seq_regra_cc_w) INTO STRICT cd_centro_custo_w, nr_seq_regra_cc_w;
				end if;
				
				if (ie_compl_hist_w = 'S') then
					/* Felipe 10/10/2008 - OS 111091 */

					select	max(nr_nota_fiscal)
					into STRICT	nr_nota_fiscal_w
					from	nota_fiscal
					where	nr_sequencia	= nr_seq_nota_fiscal_w;
					
					nr_nota_fiscal_w	:= somente_numero(nr_nota_fiscal_w);
					
					ds_conteudo_w	:= substr(nr_nota_fiscal_w	|| '#@' ||
								cd_cgc_pagador_w 	|| '#@' ||
								cd_pf_pagador_w		|| '#@' ||
								nr_titulo_w		|| '#@' ||
								nm_pagador_w,1,4000);
					
					select	obter_compl_historico(21, cd_historico_w, ds_conteudo_w)
					into STRICT	ds_compl_historico_ww
					;
					ds_compl_historico_w	:= substr(ds_compl_historico_ww,1,255);--substr(nvl(ds_compl_historico_ww, ds_compl_historico_w),1,255);
				end if;
				/* Felipe - Fim da alteração */

				
				select	coalesce(max(nr_sequencia),0) + 1
				into STRICT	nr_seq_w_movto_cont_w
				from	w_movimento_contabil;
				
				insert into w_movimento_contabil(nr_lote_contabil,
					nr_sequencia,
					cd_conta_contabil,
					ie_debito_credito,
					cd_historico,
					dt_movimento,
					vl_movimento,
					cd_estabelecimento,
					cd_centro_custo,
					ds_compl_historico,
					nr_seq_agrupamento)
				values (nr_lote_contabil_p,
					nr_seq_w_movto_cont_w,
					cd_conta_contabil_w,
					ie_debito_credito_w,
					cd_historico_w,
					dt_referencia_w,
					vl_contabil_w,
					cd_estabelecimento_w,
					cd_centro_custo_w,
					ds_compl_historico_w,
					nr_seq_copartic_w);
			end if;
			end;
		end loop;
		close C02;
		end;
	end loop;
	close c01;
	CALL Agrupa_Movimento_Contabil(nr_lote_contabil_p, nm_usuario_p);
	end;
end if;

if (coalesce(ds_retorno_p::text, '') = '') then
	begin
	update lote_contabil
	set	ie_situacao = 'A'
	where	nr_lote_contabil 	= nr_lote_contabil_p;

	if (ie_exclusao_p = 'S') then
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(165188);
	else
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(165187);
	end if;

	commit;
	end;
else
	rollback;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_pls_contab_rec ( nr_lote_contabil_p bigint, nm_usuario_p text, ie_exclusao_p text, ds_retorno_p INOUT text) FROM PUBLIC;
