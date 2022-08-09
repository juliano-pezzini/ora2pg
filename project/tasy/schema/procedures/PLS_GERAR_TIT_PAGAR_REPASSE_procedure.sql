-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tit_pagar_repasse ( nr_seq_repasse_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_vend_venc_w		bigint;
nr_titulo_w			bigint;
cd_moeda_w			smallint;
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
vl_vencimento_w			double precision;
dt_vencimento_w			timestamp;
nr_seq_trans_fin_baixa_vend_w	bigint;
cd_conta_financ_w		bigint;
nr_seq_classif_w		bigint;
ie_mes_fechado_w		varchar(2);
cd_conta_financ_regra_w		bigint	:= null;
ie_gerou_cassif_w		varchar(1);
nr_seq_canal_venda_w		pls_vendedor.nr_sequencia%type;
dt_referencia_w			pls_repasse_vend.dt_referencia%type;
ie_gerar_nota_fiscal_w		pls_vendedor.ie_gerar_nota_fiscal%type;
vl_repasse_w			pls_repasse_mens.vl_repasse%type;
cd_conta_cred_w			pls_repasse_mens.cd_conta_cred%type;
ie_concil_contab_w		pls_visible_false.ie_concil_contab%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_repasse_vend_venc
	where	nr_seq_repasse	= nr_seq_repasse_p;
	
C02 CURSOR FOR
	SELECT	vl_repasse,
		cd_conta_cred
	from	pls_repasse_mens
	where	nr_seq_repasse	= nr_seq_repasse_p;	


BEGIN

select	a.cd_pessoa_fisica,
	a.cd_cgc,
	a.nr_sequencia,
	b.dt_referencia,
	a.ie_gerar_nota_fiscal
into STRICT	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_canal_venda_w,
	dt_referencia_w,
	ie_gerar_nota_fiscal_w
from	pls_vendedor a,
	pls_repasse_vend b
where	a.nr_sequencia	= b.nr_seq_vendedor
and	b.nr_sequencia 	= nr_seq_repasse_p;

ie_mes_fechado_w	:= pls_obter_se_mes_fechado(dt_referencia_w, 'T', cd_estabelecimento_p);

if (ie_mes_fechado_w	= 'S') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 267305, null ); /* O mês de competência ou contabilidade do mês está fechado. Verifique! */
end if;

select	max(nr_seq_trans_fin_baixa_vend),
	max(cd_conta_financ)
into STRICT	nr_seq_trans_fin_baixa_vend_w,
	cd_conta_financ_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

cd_conta_financ_regra_w := pls_obter_conta_financ_regra(	'CV', null, cd_estabelecimento_p, null, null, null, null, null, null, null, nr_seq_repasse_p, null, null, null, null, null, null, cd_conta_financ_regra_w);
open C01;
loop
fetch C01 into
	nr_seq_vend_venc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_moeda_w := 1;
	ie_gerou_cassif_w := 'N';
	
	select	dt_vencimento,
		vl_vencimento
	into STRICT	dt_vencimento_w,
		vl_vencimento_w
	from	pls_repasse_vend_venc
	where	nr_sequencia	= nr_seq_vend_venc_w;
	
	select	nextval('titulo_pagar_seq')
	into STRICT	nr_titulo_w
	;
	
	insert into titulo_pagar(nr_titulo, cd_estabelecimento, dt_atualizacao,
		nm_usuario, dt_emissao, dt_vencimento_original,
		dt_vencimento_atual, vl_titulo, vl_saldo_titulo,
		vl_saldo_juros, vl_saldo_multa, cd_moeda,
		tx_juros, tx_multa, cd_tipo_taxa_juro,
		cd_tipo_taxa_multa, ie_situacao, ie_origem_titulo,
		ie_tipo_titulo, cd_pessoa_fisica, cd_cgc,
		nr_seq_trans_fin_baixa, dt_contabil)
	values (	nr_titulo_w, cd_estabelecimento_p, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), dt_vencimento_w,
		dt_vencimento_w, vl_vencimento_w, vl_vencimento_w,
		0, 0, cd_moeda_w,
		0, 0, 1,
		1, 'A', '8',
		10, cd_pessoa_fisica_w, cd_cgc_w,
		nr_seq_trans_fin_baixa_vend_w, dt_vencimento_w);
	
	CALL atualizar_inclusao_tit_pagar(nr_titulo_w,nm_usuario_p);	
	
	open C02;
	loop
	fetch C02 into
		vl_repasse_w,
		cd_conta_cred_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */	
	begin	
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_seq_classif_w
		from	titulo_pagar_classif
		where	nr_titulo	= nr_titulo_w;
		
		insert into titulo_pagar_classif(nr_titulo,
			nr_sequencia, 
			vl_titulo,
			dt_atualizacao, 
			nm_usuario, 
			cd_conta_contabil,
			cd_centro_custo, 
			nr_seq_conta_financ, 
			nr_seq_trans_fin,
			nr_contrato, 
			vl_desconto, 
			vl_original,
			vl_acrescimo)
		values (nr_titulo_w, 
			nr_seq_classif_w, 
			vl_repasse_w,
			clock_timestamp(), 
			nm_usuario_p, 
			cd_conta_cred_w,
			null, 
			coalesce(cd_conta_financ_regra_w, cd_conta_financ_w), 
			null,
			null, 
			null, 
			null,
			null);	
	
		ie_gerou_cassif_w := 'S';
	end;	
	end loop;
	close C02;		
	
	if ((coalesce(coalesce(cd_conta_financ_regra_w,cd_conta_financ_w),0) <> 0) and (ie_gerou_cassif_w = 'N')) then
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_seq_classif_w
		from	titulo_pagar_classif
		where	nr_titulo	= nr_titulo_w;
		
		insert into titulo_pagar_classif(nr_titulo,
			nr_sequencia, 
			vl_titulo,
			dt_atualizacao, 
			nm_usuario, 
			cd_conta_contabil,
			cd_centro_custo, 
			nr_seq_conta_financ, 
			nr_seq_trans_fin,
			nr_contrato, 
			vl_desconto, 
			vl_original,
			vl_acrescimo)
		values (nr_titulo_w, 
			nr_seq_classif_w, 
			vl_vencimento_w,
			clock_timestamp(), 
			nm_usuario_p, 
			null,
			null, 
			coalesce(cd_conta_financ_regra_w, cd_conta_financ_w), 
			null,
			null, 
			null, 
			null,
			null);
	end if;
	
	CALL Gerar_Tributo_Titulo(nr_titulo_w, nm_usuario_p, 'N', null, null, null, null, null, cd_estabelecimento_p, null);
	
	update	pls_repasse_vend_venc
	set	nr_titulo	= nr_titulo_w
	where	nr_sequencia	= nr_seq_vend_venc_w;
	
	if (coalesce(ie_gerar_nota_fiscal_w,'N') = 'S') then
		CALL pls_gerar_nota_fisc_repasse(nr_seq_vend_venc_w, dt_vencimento_w, nm_usuario_p, cd_estabelecimento_p);
	end if;
	
	CALL pls_baixar_adiant_pago_vend(nr_titulo_w, nr_seq_repasse_p, null, nm_usuario_p, cd_estabelecimento_p);
	end;
end loop;
close C01;

CALL ctb_pls_atualizar_repasse(nr_seq_repasse_p, nm_usuario_p, cd_estabelecimento_p);

select 	coalesce(max(ie_concil_contab), 'N')
into STRICT	ie_concil_contab_w
from	pls_visible_false
where 	cd_estabelecimento = cd_estabelecimento_p;

if (ie_concil_contab_w = 'S') then
	CALL pls_ctb_onl_gravar_movto_pck.gravar_movto_gerar_tit_repasse(nr_seq_repasse_p, cd_estabelecimento_p, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tit_pagar_repasse ( nr_seq_repasse_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
