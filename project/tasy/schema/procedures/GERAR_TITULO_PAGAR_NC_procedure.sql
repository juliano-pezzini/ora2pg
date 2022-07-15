-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_pagar_nc (nr_seq_nota_credito_p bigint, nm_usuario_p text, vl_titulo_p bigint, nr_titulo_p INOUT bigint, dt_vencimento_p timestamp default null) AS $body$
DECLARE


nr_seq_retorno_w		bigint;
cd_estabelecimento_w		smallint;
cd_moeda_w			smallint;
tx_juros_w			double precision;
tx_multa_w			double precision;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
nr_seq_lote_hist_w		bigint;
nr_seq_trans_financ_w		bigint;
cd_cgc_w			varchar(14);
nr_titulo_w			bigint;
vl_saldo_w			double precision;
cd_pessoa_fisica_w		varchar(10);
nr_seq_trans_baixa_tit_pagar_w	bigint;
vl_classificacao_w		double precision;
cd_centro_custo_w		integer;
nr_sequencia_w			integer;
dt_vencimento_w			timestamp;
ds_observacao_w			varchar(4000);
nr_seq_pagador_nc_w 		pls_contrato_pagador.nr_sequencia%type;
nr_seq_solic_rescisao_w		pls_solicitacao_rescisao.nr_sequencia%type;
nr_seq_tipo_lanc_w		pls_tipo_lanc_adic.nr_sequencia%type;
pr_titulo_w			double precision;
vl_devolver_w			double precision;
vl_total_classificacao_w	double precision;
qt_item_w			bigint;
qt_total_itens_w		bigint;
vl_nota_credito_w		nota_credito.vl_nota_credito%type;
ie_ultima_baixa_w		varchar(1);
vl_total_tit_classificacao_w	double precision;
nr_titulo_ant_w			titulo_pagar.nr_titulo%type;
vl_total_item_classificacao_w	double precision;

c01 CURSOR FOR
	SELECT	vl_classificacao,
		cd_centro_custo
	from	nota_credito_classif
	where	nr_seq_nota_credito = nr_seq_nota_credito_p;

C02 CURSOR(	nr_seq_nota_credito_pc	nota_credito.nr_sequencia%type) FOR
	SELECT	sum(vl_devolver) vl_devolver,
		nr_seq_segurado,
		ie_tipo_item,
		nr_seq_tipo_lanc
	from	(SELECT c.vl_devolver,
			c.nr_seq_segurado,
			c.ie_tipo_item,
			null nr_seq_tipo_lanc
		from   	pls_solic_resc_fin_venc a,
			pls_solic_rescisao_fin b,
			pls_solic_resc_fin_item c
		where  	b.nr_sequencia = a.nr_seq_solic_resc_fin
		and    	b.nr_sequencia = c.nr_seq_solic_resc_fin
		and	a.nr_seq_nota_credito = nr_seq_nota_credito_pc
		and	c.vl_devolver <> 0
		and	c.ie_tipo_item <> '20'
		
union all

		select 	c.vl_devolver,
			c.nr_seq_segurado,
			c.ie_tipo_item,
			(select	max(nr_seq_tipo_lanc)
			from	pls_mensalidade_seg_item
			where	nr_sequencia = c.nr_seq_item_mensalidade) nr_seq_tipo_lanc
		from   	pls_solic_resc_fin_venc a,
			pls_solic_rescisao_fin b,
			pls_solic_resc_fin_item c
		where  	b.nr_sequencia = a.nr_seq_solic_resc_fin
		and    	b.nr_sequencia = c.nr_seq_solic_resc_fin
		and	a.nr_seq_nota_credito = nr_seq_nota_credito_pc
		and	c.vl_devolver <> 0
		and	c.ie_tipo_item = '20') alias4
	group by
		nr_seq_segurado,
		ie_tipo_item,
		nr_seq_tipo_lanc
	order by
		vl_devolver asc;

BEGIN

select	a.cd_estabelecimento,
	a.cd_moeda,
	a.cd_tipo_taxa_juro,
	a.cd_tipo_taxa_multa,
	a.nr_seq_lote_audit_hist,
	a.nr_seq_trans_fin_contab,
	a.cd_pessoa_fisica,
	a.cd_cgc,
	coalesce(a.tx_juros,0),
	coalesce(a.tx_multa,0),
	a.vl_saldo,
	a.nr_seq_trans_baixa_tit_pagar,
	a.ds_observacao,
	a.vl_nota_credito
into STRICT	cd_estabelecimento_w,
	cd_moeda_w,
	cd_tipo_taxa_juro_w,
	cd_tipo_taxa_multa_w,
	nr_seq_lote_hist_w,
	nr_seq_trans_financ_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	tx_juros_w,
	tx_multa_w,
	vl_saldo_w,
	nr_seq_trans_baixa_tit_pagar_w,
	ds_observacao_w,
	vl_nota_credito_w
from	nota_credito a
where	a.nr_sequencia	= nr_seq_nota_credito_p;

select	max(b.nr_seq_pagador)
into STRICT	nr_seq_pagador_nc_w
from	pls_solic_resc_fin_venc a,
	pls_solic_rescisao_fin b
where	b.nr_sequencia = a.nr_seq_solic_resc_fin
and	a.nr_seq_nota_credito = nr_seq_nota_credito_p;

begin
dt_vencimento_w	:= dt_vencimento_p;

select	coalesce(cd_moeda_w,cd_moeda_padrao),
	coalesce(cd_tipo_taxa_juro_w,cd_tipo_taxa_juro),
	coalesce(cd_tipo_taxa_multa_w,cd_tipo_taxa_multa),
	coalesce(tx_juros_w,pr_juro_padrao),
	coalesce(tx_multa_w,pr_multa_padrao)
into STRICT	cd_moeda_w,
	cd_tipo_taxa_juro_w,
	cd_tipo_taxa_multa_w,
	tx_juros_w,
	tx_multa_w
from	parametros_contas_pagar a
where	a.cd_estabelecimento	= cd_estabelecimento_w;
exception
	when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(204431);
end;

select	nextval('titulo_pagar_seq')
into STRICT	nr_titulo_w
;

if (coalesce(dt_vencimento_w::text, '') = '') then
	dt_vencimento_w	:= trunc(clock_timestamp(),'dd') + 30;
end if;

insert	into	titulo_pagar(nr_titulo,
	nm_usuario,
	dt_atualizacao,
	cd_estabelecimento,
	dt_emissao,
	dt_vencimento_original,
	dt_vencimento_atual,
	vl_titulo,
	vl_saldo_titulo,
	vl_saldo_juros,
	vl_saldo_multa,
	cd_moeda,
	tx_juros,
	tx_multa,
	cd_tipo_taxa_juro,
	cd_tipo_taxa_multa,
	ie_situacao,
	ie_origem_titulo,
	ie_tipo_titulo,
	nr_seq_lote_audit_hist,
	nr_seq_trans_fin_contab,
	cd_pessoa_fisica,
	cd_cgc,
	nr_seq_nota_credito,
	nr_seq_trans_fin_baixa,
	ds_observacao_titulo,
	nr_seq_pagador)
values (nr_titulo_w,
	nm_usuario_p,
	clock_timestamp(),
	cd_estabelecimento_w,
	trunc(clock_timestamp(),'dd'),
	dt_vencimento_w,
	dt_vencimento_w,
	vl_titulo_p,
	vl_titulo_p,
	0,
	0,
	cd_moeda_w,
	tx_juros_w,
	tx_multa_w,
	cd_tipo_taxa_juro_w,
	cd_tipo_taxa_multa_w,
	'A',
	11,
	21,
	nr_seq_lote_hist_w,
	nr_seq_trans_financ_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_nota_credito_p,
	nr_seq_trans_baixa_tit_pagar_w,
	ds_observacao_w,
	nr_seq_pagador_nc_w);
	
open c01;
loop
fetch c01 into	
	vl_classificacao_w,
	cd_centro_custo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	coalesce(max(nr_sequencia_w),0)  + 1
	into STRICT	nr_sequencia_w
	from	titulo_pagar_classif
	where	nr_titulo = nr_titulo_w;
	
	insert into titulo_pagar_classif(
		nr_titulo,
		nr_sequencia,
		vl_titulo,
		dt_atualizacao,
		nm_usuario,
		cd_centro_custo)
	values (nr_titulo_w,
		nr_sequencia_w,
		vl_classificacao_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_centro_custo_w);
	end;
end loop;
close c01;
	
if (nr_seq_pagador_nc_w IS NOT NULL AND nr_seq_pagador_nc_w::text <> '') then
	select	max(b.nr_seq_solicitacao)
	into STRICT	nr_seq_solic_rescisao_w
	from	pls_solic_resc_fin_venc a,
		pls_solic_rescisao_fin b,
		pls_solicitacao_rescisao c
	where	c.nr_sequencia = b.nr_seq_solicitacao
	and	b.nr_sequencia = a.nr_seq_solic_resc_fin
	and	a.nr_seq_nota_credito = nr_seq_nota_credito_p
	and	(c.cd_banco IS NOT NULL AND c.cd_banco::text <> '');
	
	if (nr_seq_solic_rescisao_w IS NOT NULL AND nr_seq_solic_rescisao_w::text <> '') then
		insert into titulo_pagar_favorecido(nr_sequencia, nr_titulo, nm_usuario,
			nm_usuario_nrec, dt_atualizacao, dt_atualizacao_nrec,
			cd_pessoa_fisica, cd_banco, cd_agencia_bancaria,
			ie_digito_agencia, nr_conta, nr_digito_conta,
			cd_cgc)
		SELECT	nextval('titulo_pagar_favorecido_seq'), nr_titulo_w, nm_usuario_p,
			nm_usuario_p, clock_timestamp(), clock_timestamp(),
			cd_pf_devolucao, cd_banco, cd_agencia_bancaria,
			ie_digito_agencia, cd_conta, ie_digito_conta,
			cd_cgc_devolucao
		from	pls_solicitacao_rescisao
		where	nr_sequencia = nr_seq_solic_rescisao_w;
	end if;
	
	select	sum(vl_classificacao) + vl_titulo_p,
		max(b.nr_titulo)
	into STRICT	vl_total_tit_classificacao_w,
		nr_titulo_ant_w
	from	titulo_pagar_classif_ops a,
		titulo_pagar b
	where	b.nr_titulo = a.nr_titulo
	and	b.nr_seq_nota_credito = nr_seq_nota_credito_p;
	
	select	count(1)
	into STRICT	qt_total_itens_w
	from	(SELECT	nr_seq_segurado,
			ie_tipo_item,
			nr_seq_tipo_lanc
		from	(select c.vl_devolver,
				c.nr_seq_segurado,
				c.ie_tipo_item,
				null nr_seq_tipo_lanc
			from   	pls_solic_resc_fin_venc a,
				pls_solic_rescisao_fin b,
				pls_solic_resc_fin_item c
			where  	b.nr_sequencia = a.nr_seq_solic_resc_fin
			and    	b.nr_sequencia = c.nr_seq_solic_resc_fin
			and	a.nr_seq_nota_credito = nr_seq_nota_credito_p
			and	c.vl_devolver <> 0
			and	c.ie_tipo_item <> '20'
			
union all

			SELECT 	c.vl_devolver,
				c.nr_seq_segurado,
				c.ie_tipo_item,
				(select	max(nr_seq_tipo_lanc)
				from	pls_mensalidade_seg_item
				where	nr_sequencia = c.nr_seq_item_mensalidade) nr_seq_tipo_lanc
			from   	pls_solic_resc_fin_venc a,
				pls_solic_rescisao_fin b,
				pls_solic_resc_fin_item c
			where  	b.nr_sequencia = a.nr_seq_solic_resc_fin
			and    	b.nr_sequencia = c.nr_seq_solic_resc_fin
			and	a.nr_seq_nota_credito = nr_seq_nota_credito_p
			and	c.vl_devolver <> 0
			and	c.ie_tipo_item = '20') alias3
		group by
			nr_seq_segurado,
			ie_tipo_item,
			nr_seq_tipo_lanc) alias4;
	
	if	(vl_total_tit_classificacao_w = vl_nota_credito_w AND nr_titulo_ant_w IS NOT NULL AND nr_titulo_ant_w::text <> '') then
		ie_ultima_baixa_w	:= 'S';
	else
		ie_ultima_baixa_w	:= 'N';
	end if;
	
	qt_item_w	:= 0;
	vl_devolver_w	:= 0;
	
	for r_c02_w in c02(nr_seq_nota_credito_p) loop
		begin
		
		qt_item_w	:= qt_item_w + 1;
		
		nr_seq_tipo_lanc_w := null;
		
		pr_titulo_w	:= (vl_titulo_p/vl_nota_credito_w);
		
		vl_devolver_w	:= pr_titulo_w*r_c02_w.vl_devolver;
		
		if (ie_ultima_baixa_w = 'S') then
			select	coalesce(sum(a.vl_classificacao),0)
			into STRICT	vl_total_item_classificacao_w
			from	titulo_pagar_classif_ops a,
				titulo_pagar b
			where	b.nr_titulo = a.nr_titulo	
			and	b.nr_seq_nota_credito = nr_seq_nota_credito_p
			and	a.nr_seq_segurado = r_c02_w.nr_seq_segurado
			and	a.ie_tipo_item = r_c02_w.ie_tipo_item
			and	(((coalesce(r_c02_w.nr_seq_tipo_lanc::text, '') = '') and (coalesce(a.nr_seq_tipo_lanc::text, '') = '')) or (r_c02_w.nr_seq_tipo_lanc = a.nr_seq_tipo_lanc));
			
			if	(r_c02_w.vl_devolver <> (vl_total_item_classificacao_w + vl_devolver_w)) then
				vl_devolver_w	:= vl_devolver_w + (r_c02_w.vl_devolver - (vl_total_item_classificacao_w + vl_devolver_w));
			end if;
		else
			if (qt_item_w = qt_total_itens_w) then
				select	coalesce(sum(vl_classificacao),0)
				into STRICT	vl_total_classificacao_w
				from	titulo_pagar_classif_ops
				where	nr_titulo = nr_titulo_w;
				
				if	(vl_titulo_p <> (vl_total_classificacao_w + vl_devolver_w)) then
					vl_devolver_w	:= vl_devolver_w + (vl_titulo_p - (vl_total_classificacao_w + vl_devolver_w));
				end if;
			end if;
		end if;

		insert into 	titulo_pagar_classif_ops(	nr_sequencia, vl_classificacao, dt_atualizacao,
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_segurado, ie_tipo_item, nr_seq_tipo_lanc,
				nr_titulo)
		values (	nextval('titulo_pagar_classif_ops_seq'), vl_devolver_w, clock_timestamp(),
				nm_usuario_p, clock_timestamp(), nm_usuario_p,
				r_c02_w.nr_seq_segurado, r_c02_w.ie_tipo_item, nr_seq_tipo_lanc_w,
				nr_titulo_w);
		end;
	end loop;
end if;
	
CALL atualizar_inclusao_tit_pagar(nr_titulo_w, nm_usuario_p);

CALL atualizar_saldo_nota_credito(nr_seq_nota_credito_p, nm_usuario_p);

commit;

nr_titulo_p := nr_titulo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_pagar_nc (nr_seq_nota_credito_p bigint, nm_usuario_p text, vl_titulo_p bigint, nr_titulo_p INOUT bigint, dt_vencimento_p timestamp default null) FROM PUBLIC;

