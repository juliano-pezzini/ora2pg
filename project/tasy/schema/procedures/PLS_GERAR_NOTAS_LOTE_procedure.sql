-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_notas_lote ( nr_seq_lote_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, dt_emissao_p timestamp, cd_natureza_operacao_p bigint, ds_observacao_p text, ds_complemento_p text, dt_base_venc_p timestamp, nr_nota_fiscal_p text, nm_usuario_p text, ie_somente_nota_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

/* 
Criado o parâmetro ie_somente_nota_p para os casos onde foi gerado somente o título e deseja-se criar uma nota_fiscal para vincular ao título gerado 
OS 108368 - 01/10/2008 - Paulo 
*/
 
cd_estabelecimento_w		smallint;
nr_seq_trans_fin_baixa_conta_w	bigint;
nr_seq_prestador_w		bigint;
vl_resumo_w			double precision;
nr_nota_fiscal_w		varchar(255);
qt_notas_w			integer	:= 0;
cd_pf_prestador_w		varchar(10);
cd_cgc_prestador_w		varchar(14);
cd_condicao_pagamento_w		bigint;
ie_geracao_nota_titulo_w	varchar(2);
ie_tipo_nota_w			varchar(3);
nr_seq_nota_fiscal_w		bigint;
nr_sequencia_nf_w		bigint	:= 9;
vl_mercadoria_w			double precision;
vl_total_nota_w			double precision;
vl_unitario_item_w		double precision;
vl_total_item_w			double precision;
cd_cgc_estabelecimento_w	varchar(14);
ie_tipo_item_w			varchar(1);
ie_tipo_despesa_w		varchar(1);
vl_liberado_w			double precision;
ds_tipo_despesa_w		varchar(255);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_conta_financ_w		bigint;
cd_material_w			integer;
nr_item_nf_w			integer;
ie_forma_pagamento_w		smallint;
vl_liquido_nota_w		double precision;
nr_titulo_w			bigint;
qt_dia_vencimento_w		bigint;
dt_base_venc_w			timestamp;
cd_conta_cred_w			varchar(20);
cd_tributo_w			bigint;
nr_seq_tributo_lote_w		bigint;
ie_gerou_tributo_w		varchar(1)	:= 'N';
pr_tributo_w			double precision;
qt_existe_w			bigint;
vl_imposto_w			double precision;
vl_reducao_base_w		double precision;
vl_trib_nao_retido_w		double precision;
vl_base_nao_retido_w		double precision;
vl_trib_adic_w			double precision;
vl_base_adic_w			double precision;
vl_tot_nota_w			double precision;
dt_entrada_saida_w		timestamp;
nr_seq_tipo_desp_proc_w		pls_tipo_desp_proc.nr_sequencia%type;

C01 CURSOR FOR 
	SELECT	'P' ie_tipo_item, 
		c.ie_tipo_despesa, 
		sum(c.vl_liberado) vl_liberado, 
		CASE WHEN c.ie_tipo_despesa=1 THEN 'Procedimentos' WHEN c.ie_tipo_despesa=2 THEN 'Taxas' WHEN c.ie_tipo_despesa=3 THEN 'Diárias' WHEN c.ie_tipo_despesa=4 THEN 'Pacotes'  ELSE '' END  ds_tipo_despesa, 
		c.cd_conta_cred 
	from	pls_conta_proc		c, 
		pls_conta		b, 
		pls_protocolo_conta	a, 
		pls_prot_conta_titulo 	p 
	where	a.nr_sequencia		= b.nr_seq_protocolo 
	and	b.nr_sequencia		= c.nr_seq_conta 
	and	p.nr_seq_protocolo	= a.nr_sequencia 
	and	p.nr_seq_lote		= nr_seq_lote_p 
	and	coalesce(b.nr_seq_prestador_exec, a.nr_seq_prestador) = nr_seq_prestador_w 
	group by c.ie_tipo_despesa, 
		c.cd_conta_cred 
	
union
 
	SELECT	'M' ie_tipo_item, 
		c.ie_tipo_despesa, 
		sum(c.vl_liberado) vl_liberado, 
		CASE WHEN c.ie_tipo_despesa='1' THEN 'Gases Medicinais' WHEN c.ie_tipo_despesa='2' THEN 'Medicamentos' WHEN c.ie_tipo_despesa='3' THEN 'Materiais' WHEN c.ie_tipo_despesa='7' THEN 'OPM'  ELSE '' END  ds_tipo_despesa, 
		c.cd_conta_cred 
	from	pls_conta_mat		c, 
		pls_conta		b, 
		pls_protocolo_conta	a, 
		pls_prot_conta_titulo 	p 
	where	a.nr_sequencia		= b.nr_seq_protocolo 
	and	b.nr_sequencia		= c.nr_seq_conta 
	and	p.nr_seq_protocolo	= a.nr_sequencia 
	and	p.nr_seq_lote		= nr_seq_lote_p 
	and	coalesce(b.nr_seq_prestador_exec, a.nr_seq_prestador) = nr_seq_prestador_w 
	group by c.ie_tipo_despesa, 
		c.cd_conta_cred;

C02 CURSOR FOR 
	SELECT	nr_titulo 
	from	titulo_pagar 
	where	nr_seq_lote_res_pls	= nr_seq_lote_p 
	and	ie_somente_nota_p	= 'N';

c03 CURSOR FOR 
	SELECT	a.cd_tributo 
	from	pls_lote_protocolo_venc b, 
		pls_lote_prot_venc_trib a 
	where	a.nr_seq_lote_venc	= b.nr_sequencia 
	and	b.nr_seq_lote		= nr_seq_lote_p 
	group by 
		a.cd_tributo;


BEGIN 
 
if (dt_emissao_p IS NOT NULL AND dt_emissao_p::text <> '') then 
	dt_entrada_saida_w	:= to_date(to_char(dt_emissao_p, 'dd/mm/yyyy') || ' ' || to_char(clock_timestamp(),'hh24:mi:ss') ,'dd/mm/yyyy hh24:mi:ss');
end if;
 
/* Obter dados do lote */
 
select	nr_seq_prestador, 
	pls_obter_valor_lote_resumo(nr_sequencia), 
	nr_nota_fiscal, 
	cd_estabelecimento 
into STRICT	nr_seq_prestador_w, 
	vl_resumo_w, 
	nr_nota_fiscal_w, 
	cd_estabelecimento_w 
from	pls_lote_protocolo 
where	nr_sequencia	= nr_seq_lote_p;
 
/* Felipe - 11/11/2010 - OS 251944 */
 
if (coalesce(nr_nota_fiscal_p,'0') <> '0') then 
	nr_nota_fiscal_w	:= nr_nota_fiscal_p;
 
	update	pls_lote_protocolo 
	set	nr_nota_fiscal	= nr_nota_fiscal_p 
	where	nr_sequencia	= nr_seq_lote_p;
end if;
 
cd_cgc_estabelecimento_w	:= obter_cgc_estabelecimento(cd_estabelecimento_w);
 
select	nr_seq_trans_fin_baixa_conta 
into STRICT	nr_seq_trans_fin_baixa_conta_w 
from	pls_parametros 
where	cd_estabelecimento	= cd_estabelecimento_w;
 
select	count(*) 
into STRICT	qt_notas_w 
from	nota_fiscal 
where	nr_seq_lote_res_pls	= nr_seq_lote_p 
and	ie_situacao	= '1';
 
if (qt_notas_w > 0) then 
	--20011,'Já foram geradas notas para este item.#@#@'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(206623);
end if;
 
if (coalesce(nr_nota_fiscal_w::text, '') = '') then 
	--20011,'Não foi informado o número da Nota Fiscal no resumo de pagamento. Verifique!#@#@'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(206624);
end if;
 
select	cd_pessoa_fisica, 
	cd_cgc 
into STRICT	cd_pf_prestador_w, 
	cd_cgc_prestador_w 
from	pls_prestador 
where	nr_sequencia	= nr_seq_prestador_w;
 
select	max(cd_condicao_pagamento), 
	max(ie_geracao_nota_titulo), 
	max(qt_dia_vencimento) 
into STRICT	cd_condicao_pagamento_w, 
	ie_geracao_nota_titulo_w, 
	qt_dia_vencimento_w 
from	pls_prestador_pagto 
where	nr_seq_prestador	= nr_seq_prestador_w;
 
if (coalesce(cd_condicao_pagamento_w,0) = 0) then 
	--20011,'Não foi informada a condição de pagamento do prestador. Verifique!#@#@'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(206625);
end if;
 
if (coalesce(qt_dia_vencimento_w,0) = 0) then 
	qt_dia_vencimento_w	:= to_char(dt_base_venc_p,'dd');
end if;
 
dt_base_venc_w	:= to_date(lpad(to_char(qt_dia_vencimento_w),2,0) || to_char(dt_base_venc_p,'mm/yyyy'),'dd/mm/yyyy');
 
if (coalesce(cd_pf_prestador_w::text, '') = '') then 
	ie_tipo_nota_w := 'EN';
else 
	ie_tipo_nota_w := 'EF';
end if;
 
/* Gerar a nota e o título */
 
if (ie_geracao_nota_titulo_w = 'NT') or (ie_somente_nota_p = 'S') then 
	select	nextval('nota_fiscal_seq') 
	into STRICT	nr_seq_nota_fiscal_w 
	;
	 
	select	coalesce(max(nr_sequencia_nf),0) + 1 
	into STRICT	nr_sequencia_nf_w 
	from	nota_fiscal 
	where	nr_nota_fiscal	= nr_nota_fiscal_w;
	 
	vl_mercadoria_w		:= vl_resumo_w;
	vl_total_nota_w		:= vl_resumo_w;
	vl_unitario_item_w	:= vl_resumo_w;
	vl_total_item_w		:= vl_resumo_w;
	 
	insert into nota_fiscal(nr_sequencia, cd_estabelecimento, cd_cgc_emitente, 
		cd_serie_nf, nr_nota_fiscal, nr_sequencia_nf, 
		cd_operacao_nf, dt_emissao, dt_entrada_saida, 
		ie_acao_nf, ie_emissao_nf, ie_tipo_frete, 
		vl_mercadoria, vl_total_nota, qt_peso_bruto, 
		qt_peso_liquido, dt_atualizacao, nm_usuario, 
		ie_tipo_nota, cd_condicao_pagamento, cd_natureza_operacao, 
		nr_seq_classif_fiscal, ds_observacao, vl_ipi, 
		vl_descontos, vl_frete, vl_seguro, 
		vl_despesa_acessoria, cd_pessoa_fisica, cd_cgc, 
		nr_seq_lote_res_pls, ie_situacao, nr_lote_contabil, 
		ie_entregue_bloqueto) 
	values (nr_seq_nota_fiscal_w, cd_estabelecimento_w, cd_cgc_prestador_w, 
		cd_serie_nf_p, nr_nota_fiscal_w, nr_sequencia_nf_w, 
		cd_operacao_nf_p, trunc(dt_emissao_p,'dd'), dt_entrada_saida_w, 
		'1', '0', '0', 
		vl_mercadoria_w, vl_total_nota_w, 0, 
		0, clock_timestamp(), nm_usuario_p, 
		ie_tipo_nota_w, cd_condicao_pagamento_w, cd_natureza_operacao_p, 
		null, ds_observacao_p, 0, 
		0, 0, 0, 
		0, cd_pf_prestador_w, cd_cgc_prestador_w, 
		nr_seq_lote_p, '1', 0, 
		'N');
		 
	/* Obter itens da conta */
 
	open C01;
	loop 
	fetch C01 into 
		ie_tipo_item_w, 
		ie_tipo_despesa_w, 
		vl_liberado_w, 
		ds_tipo_despesa_w, 
		cd_conta_cred_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		if (ie_tipo_despesa_w IS NOT NULL AND ie_tipo_despesa_w::text <> '') then 
			if (ie_tipo_item_w	= 'P') then 
			 
				select	max(nr_sequencia) 
				into STRICT	nr_seq_tipo_desp_proc_w 
				from	pls_tipo_desp_proc 
				where	ie_tipo_despesa	= ie_tipo_despesa_w 
				and	cd_estabelecimento = cd_estabelecimento_w;
				 
				select	cd_procedimento, 
					ie_origem_proced 
				into STRICT	cd_procedimento_w, 
					ie_origem_proced_w 
				from	pls_tipo_desp_proc 
				where	nr_sequencia = nr_seq_tipo_desp_proc_w;
				 
				if (cd_procedimento_w = 0) then 
					--20011,'Não foi cadastrado um procedimento para o tipo de despesa ' 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(206629);
				end if;
				 
				/* obter primeiro a conta financeira do plano */
 
				cd_conta_financ_w := pls_obter_conta_financ_regra(	'PP', null, cd_estabelecimento_w, null, null, null, null, nr_seq_prestador_w, null, null, null, null, null, null, null, null, null, cd_conta_financ_w);
								 
				if (coalesce(cd_conta_financ_w::text, '') = '') then 
					cd_conta_financ_w := obter_conta_financeira('S', cd_estabelecimento_w, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, null, cd_conta_financ_w, null, cd_operacao_nf_p, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
				end if;
			elsif (ie_tipo_item_w	= 'M') then 
				cd_material_w := null;
				select	b.cd_material 
				into STRICT	cd_material_w 
				from	pls_tipo_desp_mat	a, 
					pls_material 		b 
				where	a.nr_seq_material	= b.nr_sequencia 
				and	a.ie_tipo_despesa 	= ie_tipo_despesa_w 
				and	a.cd_estabelecimento	= cd_estabelecimento_w  LIMIT 1;
				 
				if (coalesce(cd_material_w::text, '') = '') then 
					--20011,'Não foi cadastrado material para o tipo de despesa ' 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(206632);
				end if;
				 
				/* obter primeiro a conta financeira do plano */
 
				cd_conta_financ_w := pls_obter_conta_financ_regra(	'PP', null, cd_estabelecimento_w, null, null, null, null, nr_seq_prestador_w, null, null, null, null, null, null, null, null, null, cd_conta_financ_w);
								 
				if (coalesce(cd_conta_financ_w::text, '') = '') then 
					cd_conta_financ_w := obter_conta_financeira('S', cd_estabelecimento_w, cd_material_w, null, null, null, null, null, null, cd_conta_financ_w, null, cd_operacao_nf_p, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
				end if;
			end if;
			 
			select	coalesce(max(nr_item_nf),0) + 1 
			into STRICT	nr_item_nf_w 
			from	nota_fiscal_item 
			where	nr_sequencia = nr_seq_nota_fiscal_w;
			 
			insert into nota_fiscal_item(nr_sequencia, cd_estabelecimento, cd_cgc_emitente, 
				cd_serie_nf, nr_nota_fiscal, nr_sequencia_nf, 
				nr_item_nf, cd_natureza_operacao, qt_item_nf, 
				vl_unitario_item_nf, vl_total_item_nf, vl_liquido, 
				vl_frete, vl_desconto, vl_despesa_acessoria, 
				vl_desconto_rateio, vl_seguro, nm_usuario, 
				dt_atualizacao, ds_complemento, cd_procedimento, 
				ie_origem_proced, nr_seq_conta_financ, cd_material, 
				cd_conta_contabil) 
			values (nr_seq_nota_fiscal_w, cd_estabelecimento_w, cd_cgc_prestador_w, 
				cd_serie_nf_p, nr_nota_fiscal_w, nr_sequencia_nf_w, 
				nr_item_nf_w, cd_natureza_operacao_p, 1, 
				vl_liberado_w, vl_liberado_w, vl_liberado_w, 
				0, 0, 0, 
				0, 0, nm_usuario_p, 
				clock_timestamp(), ds_complemento_p, CASE WHEN ie_tipo_item_w='P' THEN cd_procedimento_w  ELSE null END , 
				CASE WHEN ie_tipo_item_w='P' THEN ie_origem_proced_w  ELSE null END , CASE WHEN cd_conta_financ_w=0 THEN null  ELSE cd_conta_financ_w END , CASE WHEN ie_tipo_item_w='M' THEN cd_material_w  ELSE null END , 
				cd_conta_cred_w);
			end if;
		end;
	end loop;
	close C01;
	 
	/* Francisco - OS 222072 - Gerar tributos conforme o lote de pagamento */
 
	open c03;
	loop 
	fetch c03 into 
		cd_tributo_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin 
		ie_gerou_tributo_w	:= 'S';
		 
		select	sum(pr_tributo), 
			sum(vl_imposto), 
			sum(vl_reducao), 
			sum(vl_nao_retido), 
			sum(vl_base_nao_retido), 
			sum(vl_trib_adic), 
			sum(vl_base_adic) 
		into STRICT	pr_tributo_w, 
			vl_imposto_w, 
			vl_reducao_base_w, 
			vl_trib_nao_retido_w, 
			vl_base_nao_retido_w, 
			vl_trib_adic_w, 
			vl_base_adic_w 
		from	pls_lote_prot_venc_trib a, 
			pls_lote_protocolo_venc b 
		where	a.nr_seq_lote_venc	= b.nr_sequencia 
		and	b.nr_seq_lote		= nr_seq_lote_p 
		and	a.cd_tributo		= cd_tributo_w;
		 
		select	count(*) 
		into STRICT	qt_existe_w 
		from	nota_fiscal_trib 
		where	nr_sequencia	= nr_seq_nota_fiscal_w 
		and	cd_tributo	= cd_tributo_w;
		 
		if (qt_existe_w = 0) then 
			insert into nota_fiscal_trib(nr_sequencia, 
					cd_tributo, 
					vl_tributo, 
					dt_atualizacao, 
					nm_usuario, 
					vl_base_calculo, 
					tx_tributo, 
					vl_reducao_base, 
					vl_trib_nao_retido, 
					vl_base_nao_retido, 
					vl_trib_adic, 
					vl_base_adic, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					ie_origem_trib, 
					nr_seq_interno) 
				values (nr_seq_nota_fiscal_w, 
					cd_tributo_w, 
					vl_imposto_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					vl_liberado_w, 
					pr_tributo_w, 
					vl_reducao_base_w, 
					vl_trib_nao_retido_w, 
					vl_base_nao_retido_w, 
					vl_trib_adic_w, 
					vl_base_adic_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					'LP', 
					nextval('nota_fiscal_trib_seq'));
		end if;
		end;
	end loop;
	close c03;
	 
	/* Francisco - OS 222072 - Alterei para só gerar os tributos através da procedure abaixo quando não obter pelo lote */
 
	if (ie_gerou_tributo_w = 'N') then 
		CALL gerar_tributos_fornecedor(nr_seq_nota_fiscal_w, null, nm_usuario_p, dt_emissao_p);
	end if;
	 
	--gerar_imposto_nf(nr_seq_nota_fiscal_w, nm_usuario_p, null, null); 
	CALL atualiza_total_nota_fiscal(nr_seq_nota_fiscal_w, nm_usuario_p);
	 
	select	coalesce(max(ie_forma_pagamento),0) 
	into STRICT	ie_forma_pagamento_w 
	from	condicao_pagamento 
	where	cd_condicao_pagamento	= cd_condicao_pagamento_w;
	 
	/* Conforme vencimentos */
 
	if (ie_forma_pagamento_w = 10) then 
		select	coalesce(vl_total_nota,0) 
		into STRICT	vl_liquido_nota_w 
		from	nota_fiscal 
		where	nr_sequencia	= nr_seq_nota_fiscal_w;
		 
		insert into nota_fiscal_venc(nr_sequencia, nm_usuario, dt_atualizacao, 
			cd_estabelecimento, cd_cgc_emitente, cd_serie_nf, 
			nr_nota_fiscal, nr_sequencia_nf, dt_vencimento, 
			vl_vencimento, ie_origem) 
		values (nr_seq_nota_fiscal_w, nm_usuario_p, clock_timestamp(), 
			cd_estabelecimento_w, cd_cgc_prestador_w, cd_serie_nf_p, 
			nr_nota_fiscal_w, 1, dt_base_venc_w, 
			vl_liquido_nota_w,'N');
	else 
		CALL gerar_nota_fiscal_venc(nr_seq_nota_fiscal_w, coalesce(dt_base_venc_p,dt_base_venc_w));
	end if;
	 
	update	nota_fiscal 
	set	dt_atualizacao_estoque = clock_timestamp() 
	where	nr_sequencia = nr_seq_nota_fiscal_w;
	 
	if (ie_somente_nota_p = 'N') then 
		select	max(nr_titulo) 
		into STRICT	nr_titulo_w 
		from	titulo_pagar 
		where	nr_seq_prot_conta	= nr_seq_lote_p;
		 
		/* Se ainda não tem título gerado */
 
		if (coalesce(nr_titulo_w,0) = 0) then 
			CALL gerar_titulo_pagar_nf(nr_seq_nota_fiscal_w, nm_usuario_p);
			 
			select	max(nr_titulo) 
			into STRICT	nr_titulo_w 
			from	titulo_pagar 
			where	nr_seq_prot_conta	= nr_seq_lote_p;
			 
			if (coalesce(nr_titulo_w,0) > 0) then 
				CALL gerar_bloqueto_tit_rec(nr_titulo_w, 'OPSMS');
			end if;
		else 
			update	titulo_pagar 
			set	nr_seq_nota_fiscal	= nr_seq_nota_fiscal_w 
			where	nr_titulo		= nr_titulo_w;
		end if;
	end if;
else 
	/* gerar somente o título para pessoa física */
 
	CALL pls_gerar_titulo_lote(nr_seq_lote_p, nm_usuario_p);
end if;
 
open C02;
loop 
fetch C02 into 
	nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	update	titulo_pagar 
	set	nr_seq_trans_fin_baixa	= nr_seq_trans_fin_baixa_conta_w 
	where	nr_titulo 		= nr_titulo_w;
	end;
end loop;
close C02;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_notas_lote ( nr_seq_lote_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, dt_emissao_p timestamp, cd_natureza_operacao_p bigint, ds_observacao_p text, ds_complemento_p text, dt_base_venc_p timestamp, nr_nota_fiscal_p text, nm_usuario_p text, ie_somente_nota_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

