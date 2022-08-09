-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eme_nota_fiscal (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_fatura_p bigint, cd_setor_atendimento_p bigint, ie_gerar_titulo_p text default 'S', nr_nota_fiscal_p bigint DEFAULT NULL) AS $body$
DECLARE


nr_nota_fiscal_w		varchar(255);
nr_seq_nota_w			bigint;
cd_cgc_estabelecimento_w	varchar(14);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
vl_fatura_w			double precision;
vl_item_w			double precision;
cd_operacao_w			smallint;
cd_natureza_w			smallint;
cd_procedimento_w		bigint;
nr_sequencia_nf_w		bigint;
ie_origem_proced_w		bigint;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
nr_seq_contrato_w		bigint;
nr_item_nf_w			bigint;
vl_total_nota_w			double precision;
dt_emissao_w			timestamp;
ie_tipo_nota_w			varchar(10);
cd_convenio_w			bigint;
cd_condicao_pagamento_w		bigint;
ie_base_calculo_w		varchar(1);
qt_item_w			bigint;
cd_conta_contabil_w		varchar(20);
cd_centro_custo_w	  	integer;
ie_tipo_convenio_w		smallint;
ie_regra_calcula_nf_w		varchar(1);
ie_calcula_nf_w			varchar(1);
ie_calcula_nf_conv_w		varchar(1);
ie_estab_serie_nf_w		parametro_compras.ie_estab_serie_nf%type;
cd_cgc_emitente_w		estabelecimento.cd_cgc%type;


C01 CURSOR FOR
	SELECT	coalesce(Obter_eme_valor_fatura(a.nr_sequencia,b.dt_competencia, nr_seq_fatura_p, 'F'),0),
		a.cd_procedimento,
		a.ie_origem_proced,
		1
	from	eme_contrato a,
		eme_faturamento b
	where	a.nr_sequencia	= b.nr_seq_contrato
	and	b.nr_sequencia	= nr_seq_fatura_p
	and	ie_base_calculo_w <> 'A'
	
union

	SELECT	coalesce(c.vl_preco,0),
		c.cd_procedimento,
		c.ie_origem_proced,
		1
	from	eme_preco_adic c,
		eme_contrato a,
		eme_faturamento b
	where	a.nr_sequencia	= b.nr_seq_contrato
	and	a.nr_sequencia	= c.nr_seq_contrato
	and	b.nr_sequencia	= nr_seq_fatura_p
	and	ie_base_calculo_w <> 'A'
	
union

	select	coalesce(Obter_eme_valor_fatura(a.nr_sequencia,b.dt_competencia, nr_seq_fatura_p, 'F'),0),
		a.cd_procedimento,
		a.ie_origem_proced,
		1
	from	eme_contrato a,
		eme_faturamento b
	where	a.nr_sequencia	= b.nr_seq_contrato
	and	b.nr_sequencia	= nr_seq_fatura_p
	and	ie_base_calculo_w = 'A'
	
union

	select	f.vl_custo_unit,
		f.cd_procedimento,
		f.ie_origem_proced,
		c.qt_km_cobrar
	from eme_contrato a,
		eme_faturamento b,
		eme_chamado c,
		eme_regra_preco d,
		eme_veiculo e,
		eme_custo_km_veiculo f
	where	a.nr_sequencia = b.nr_seq_contrato
	and		c.nr_seq_contrato    = a.nr_sequencia
	and		c.nr_seq_faturamento = b.nr_sequencia
	and		a.nr_seq_regra_preco = d.nr_sequencia
	and		c.nr_seq_veiculo     = e.nr_sequencia
	and		e.nr_sequencia	     = f.nr_seq_veiculo
	and            ((c.nr_seq_custo_km    = f.nr_sequencia) or (coalesce(c.nr_seq_custo_km::text, '') = ''))
	and		b.nr_sequencia	     = nr_seq_fatura_p
	and		d.ie_cobranca_km     = 'S'
	and	    c.qt_km_cobrar > 0
	
union

	select	CASE WHEN coalesce(c.vl_preco,0)=0 THEN coalesce(eme_obter_preco_proced(a.cd_estabelecimento,				coalesce(e.nr_atendimento,0),				d.cd_procedimento,				d.ie_origem_proced,				coalesce(e.cd_convenio, a.cd_convenio),				coalesce(e.cd_categoria, a.cd_categoria)),0)  ELSE c.vl_preco END ,
		d.cd_procedimento,
		d.ie_origem_proced,
		count(*)
	from	eme_contrato a,
		eme_faturamento b,
		eme_preco_adic c,
		eme_proced_chamado d,
		eme_chamado e
	where	a.nr_sequencia		= b.nr_seq_contrato
	and	a.nr_sequencia		= c.nr_seq_contrato
	and	a.nr_sequencia		= e.nr_seq_contrato
	and	e.nr_seq_faturamento 	= b.nr_sequencia
	and	e.nr_sequencia		= d.nr_seq_chamado
	and	b.nr_sequencia		= nr_seq_fatura_p
	and	c.cd_procedimento	= d.cd_procedimento
	and	c.ie_origem_proced	= d.ie_origem_proced
	and	ie_base_calculo_w	= 'A'
	group by c.vl_preco, eme_obter_preco_proced(a.cd_estabelecimento,
				coalesce(e.nr_atendimento,0),
				d.cd_procedimento,
				d.ie_origem_proced,
				coalesce(e.cd_convenio, a.cd_convenio),
				coalesce(e.cd_categoria, a.cd_categoria)), d.cd_procedimento, d.ie_origem_proced;

BEGIN

select	max(cd_cgc)
into STRICT	cd_cgc_emitente_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

/* obter se será considerado estabelecimento no parâmetro de compras */

select	coalesce(max(ie_estab_serie_nf),'N')
into STRICT	ie_estab_serie_nf_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

select	dt_emissao
into STRICT	dt_emissao_w
from	eme_faturamento
where	nr_sequencia	= nr_seq_fatura_p;

select	cd_cgc
into STRICT	cd_cgc_estabelecimento_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_p;

select	CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN  a.cd_cgc  ELSE null END ,
	a.cd_pessoa_fisica,
	a.cd_operacao_nf,
	a.cd_serie_nf,
	CASE WHEN coalesce(a.cd_pessoa_fisica::text, '') = '' THEN  'SE'  ELSE 'SF' END
into STRICT	cd_cgc_w,
	cd_pessoa_fisica_w,
	cd_operacao_w,
	cd_serie_nf_w,
	ie_tipo_nota_w
from	eme_contrato a,
	eme_faturamento b
where	a.nr_sequencia	= b.nr_seq_contrato
and	b.nr_sequencia	= nr_seq_fatura_p;

select	max(a.cd_convenio)
into STRICT	cd_convenio_w
from	eme_contrato a,
	eme_faturamento b
where	a.nr_sequencia	= b.nr_seq_contrato
and	b.nr_sequencia	= nr_seq_fatura_p;

select	coalesce(max(ie_calcula_nf),'N')
into STRICT	ie_calcula_nf_w
from	parametro_faturamento
where	cd_estabelecimento = cd_estabelecimento_p;

select	coalesce(max(ie_calcular_nf),'N')
into STRICT	ie_calcula_nf_conv_w
from	convenio_estabelecimento
where	cd_convenio = cd_convenio_w
and	cd_estabelecimento = cd_estabelecimento_p;

ie_regra_calcula_nf_w := obter_param_usuario(929, 40, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_regra_calcula_nf_w);


select 	obter_centro_custo_setor(obter_setor_usuario(nm_usuario_p), 'C')
into STRICT	cd_centro_custo_w
;

if (cd_operacao_w IS NOT NULL AND cd_operacao_w::text <> '') then
	select	cd_natureza_operacao
	into STRICT	cd_natureza_w
	from	operacao_nota
	where	cd_operacao_nf = cd_operacao_w;
end if;

if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') then
	select	max(cd_condicao_pagamento)
	into STRICT	cd_condicao_pagamento_w
	from	parametro_nfs
	where	cd_convenio		= cd_convenio_w
	and	cd_estabelecimento	= cd_estabelecimento_p;

	select	max(ie_tipo_convenio)
	into STRICT	ie_tipo_convenio_w
	from	convenio
	where	cd_convenio		= cd_convenio_w;
end if;

if (coalesce(cd_condicao_pagamento_w::text, '') = '') then
	select	max(cd_condicao_pagamento_padrao)
	into STRICT	cd_condicao_pagamento_w
	from	parametro_compras
	where	cd_estabelecimento = cd_estabelecimento_p;
end if;

if (cd_serie_nf_w IS NOT NULL AND cd_serie_nf_w::text <> '') and (cd_natureza_w IS NOT NULL AND cd_natureza_w::text <> '') then
	begin
	select	nextval('nota_fiscal_seq')
	into STRICT	nr_seq_nota_w
	;

	select (coalesce(max(nr_ultima_nf),0) + 1)
	into STRICT 	nr_nota_fiscal_w
	from	serie_nota_fiscal
	where	cd_serie_nf 		= cd_serie_nf_w
	and 	cd_estabelecimento 	= cd_estabelecimento_p;

	if (coalesce(nr_nota_fiscal_p,0) > 0) then
		nr_nota_fiscal_w	:= nr_nota_fiscal_p;
	end if;

	if (coalesce(ie_estab_serie_nf_w,'N') = 'S') then
		update	serie_nota_fiscal
		set	nr_ultima_nf 		= nr_nota_fiscal_w
		where	cd_serie_nf 		= cd_serie_nf_w
		and	cd_estabelecimento in (SELECT	z.cd_estabelecimento
						from	estabelecimento z
						where	z.cd_cgc = cd_cgc_emitente_w);
	else
		update	serie_nota_fiscal
		set	nr_ultima_nf 		= nr_nota_fiscal_w
		where	cd_serie_nf 		= cd_serie_nf_w
		and	cd_estabelecimento 	= cd_estabelecimento_p;
	end if;

	select (coalesce(max(nr_sequencia_nf),0)+1)
	into STRICT 	nr_sequencia_nf_w
	from 	nota_fiscal
	where 	cd_estabelecimento = cd_estabelecimento_p
	and 	cd_cgc_emitente    = cd_cgc_estabelecimento_w
	and 	nr_nota_fiscal     = nr_nota_fiscal_w
	and 	cd_serie_nf        = cd_serie_nf_w;

	insert into nota_fiscal(
		nr_nota_fiscal,
		nr_sequencia,
		cd_estabelecimento,
		cd_cgc_emitente,
		cd_cgc,
		cd_pessoa_fisica,
		cd_serie_nf,
		nr_sequencia_nf,
		cd_operacao_nf,
		dt_emissao,
		dt_entrada_saida,
		ie_acao_nf,
		ie_emissao_nf,
		ie_tipo_frete,
		ie_situacao,
		vl_mercadoria,
		vl_total_nota,
		vl_frete,
		vl_despesa_acessoria,
		vl_seguro,
		vl_descontos,
		vl_ipi,
		vl_desconto_rateio,
		qt_peso_bruto,
		qt_peso_liquido,
		cd_natureza_operacao,
		dt_atualizacao,
		nm_usuario,
		ie_tipo_nota,
		cd_setor_digitacao,
		cd_condicao_pagamento,
		nr_seq_eme_fatura)
	values (	nr_nota_fiscal_w,
		nr_seq_nota_w,
		cd_estabelecimento_p,
		cd_cgc_estabelecimento_w,
		cd_cgc_w,
		cd_pessoa_fisica_w,
		cd_serie_nf_w,
		nr_sequencia_nf_w,
		cd_operacao_w,
		trunc(dt_emissao_w),
		clock_timestamp(),
		1,
		0,
		'0',
		1,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		cd_natureza_w,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_nota_w,
		cd_setor_atendimento_p,
		cd_condicao_pagamento_w,
		nr_seq_fatura_p);
	select	max(a.ie_base_calculo)
	into STRICT	ie_base_calculo_w
	from	eme_regra_preco a,
		eme_contrato b,
		eme_faturamento c
	where	b.nr_seq_regra_preco	= a.nr_sequencia
	and	c.nr_sequencia		= nr_seq_fatura_p
	and	c.nr_seq_contrato	= b.nr_sequencia;

	OPEN C01;
	LOOP
	FETCH C01 INTO
		vl_fatura_w,
		cd_procedimento_w,
		ie_origem_proced_w,
		qt_item_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
			begin

			SELECT * FROM Define_Conta_Procedimento(cd_estabelecimento_p, cd_procedimento_w, ie_origem_proced_w, 1, null, cd_setor_atendimento_p, '', 0, ie_tipo_convenio_w, cd_convenio_w, '', clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, '') INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
			

			select (coalesce(max(nr_item_nf),0)+1)
 			into STRICT	nr_item_nf_w
			from	nota_fiscal_item
			where	nr_sequencia	= nr_seq_nota_w;
			insert into nota_fiscal_item(
				cd_cgc_emitente,
				cd_serie_nf,
				nr_nota_fiscal,
				nr_sequencia_nf,
				nr_item_nf,
				nr_sequencia,
				vl_desconto_rateio,
				cd_natureza_operacao,
				vl_despesa_acessoria,
				nm_usuario,
				dt_atualizacao,
				vl_liquido,
				cd_estabelecimento,
				qt_item_nf,
				vl_total_item_nf,
				vl_seguro,
				vl_unitario_item_nf,
				vl_frete,
				vl_desconto,
				cd_procedimento,
				ie_origem_proced,
				cd_conta_contabil,
				cd_centro_custo,
				cd_sequencia_parametro)
			values (	cd_cgc_estabelecimento_w,
				cd_serie_nf_w,
				nr_nota_fiscal_w,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				nr_seq_nota_w,
				0,
				cd_natureza_w,
				0,
				nm_usuario_p,
				clock_timestamp(),
				coalesce(vl_fatura_w,0)*qt_item_w,
				cd_estabelecimento_p,
				qt_item_w,
				coalesce(vl_fatura_w,0)*qt_item_w,
				0,
				coalesce(vl_fatura_w,0),
				0,
				0,
				cd_procedimento_w,
				ie_origem_proced_w,
				cd_conta_contabil_w,
				cd_centro_custo_w,
				philips_contabil_pck.get_parametro_conta_contabil);
			end;
		end if;
		end;
	END LOOP;
	CLOSE C01;

	select	coalesce(sum(vl_total_item_nf),0)
	into STRICT	vl_total_nota_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_seq_nota_w;

	update	nota_fiscal
	set	vl_mercadoria	= vl_total_nota_w,
		vl_total_nota	= vl_total_nota_w
	where	nr_sequencia	= nr_seq_nota_w;

	update	eme_faturamento
	set	nr_seq_nota_fiscal = nr_seq_nota_w
	where	nr_sequencia	= nr_seq_fatura_p;

	CALL Gerar_Imposto_NF(nr_seq_nota_w,nm_usuario_p,null,null);

	/*Gerar Titulo*/

	if (ie_gerar_titulo_p = 'S') then
		CALL Gerar_eme_titulo(
				nr_seq_nota_w,
				nm_usuario_p,
				cd_estabelecimento_p,
				nr_seq_fatura_p,
				'S'); -- ALTERADO
	end if;

	/*Gerar Nota Calculada*/

	if	((coalesce(ie_regra_calcula_nf_w,'D') = 'S') or
		((coalesce(ie_regra_calcula_nf_w,'D') = 'D') and (ie_calcula_nf_w = 'S')) or
		((coalesce(ie_regra_calcula_nf_w,'D') = 'C') and (ie_calcula_nf_conv_w = 'S'))) then


		CALL atualiza_total_nota_fiscal(nr_seq_nota_w,nm_usuario_p);

		CALL gerar_nota_fiscal_venc(nr_seq_nota_w,trunc(dt_emissao_w));

		update nota_fiscal
		set dt_atualizacao_estoque = clock_timestamp()
		where nr_sequencia = nr_seq_nota_w;

		CALL gerar_historico_nota_fiscal(
			nr_seq_nota_w,
			nm_usuario_p,
			60,
			WHEB_MENSAGEM_PCK.get_texto(334720,'NR_SEQ_NOTA='|| nr_seq_nota_w));


	end if;

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eme_nota_fiscal (nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_fatura_p bigint, cd_setor_atendimento_p bigint, ie_gerar_titulo_p text default 'S', nr_nota_fiscal_p bigint DEFAULT NULL) FROM PUBLIC;
