-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_tributo_tit_adiant (nr_titulo_p bigint, nr_seq_tit_adiant_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_imposto_w			double precision	:= 0;
nr_seq_imposto_w		bigint	:= 0;
nr_adiantamento_w		bigint	:= 0;
ie_baixa_contab_w		varchar(50);
ie_gerar_titulo_pagar_w		varchar(50);
dt_contabil_w			timestamp;
nr_seq_tit_pagar_imposto_w	bigint	:= 0;
vl_saldo_titulo_w		double precision;
vl_adiantamento_w			double precision;
ie_gerar_trib_ao_liquidar_w	varchar(1)	:= 'S';
cd_estabelecimento_w		smallint;
/* Projeto Multimoeda - Variáveis */

vl_adto_estrang_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.vl_imposto,
	b.ie_gerar_titulo_pagar
from	tributo b,
	w_titulo_pagar_imposto a
where	coalesce(a.nr_seq_baixa::text, '') = ''
and	coalesce(a.nr_seq_escrit::text, '') = ''
and	coalesce(a.nr_bordero::text, '') = ''
and	a.cd_tributo		= b.cd_tributo
and	a.nr_titulo		= nr_titulo_p
and	a.nr_adiantamento	= nr_adiantamento_w;


BEGIN

select	max(vl_saldo_titulo),
	max(cd_estabelecimento)
into STRICT	vl_saldo_titulo_w,
	cd_estabelecimento_w
from	titulo_pagar
where	nr_titulo	= nr_titulo_p;

ie_gerar_trib_ao_liquidar_w := obter_param_usuario(851, 72, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_trib_ao_liquidar_w);

select	max(vl_adiantamento),
	max(nr_adiantamento),
	max(vl_adto_estrang),
	max(vl_cotacao)
into STRICT	vl_adiantamento_w,
	nr_adiantamento_w,
	vl_adto_estrang_w,
	vl_cotacao_w
from	titulo_pagar_adiant
where	nr_titulo	= nr_titulo_p
and	nr_sequencia	= nr_seq_tit_adiant_p;

if (vl_adiantamento_w	= vl_saldo_titulo_w) or (coalesce(ie_gerar_trib_ao_liquidar_w,'S') = 'N') then

	update	w_titulo_pagar_imposto
	set	nr_adiantamento	= nr_adiantamento_w
	where	nr_titulo	= nr_titulo_p
	and	coalesce(nr_seq_baixa::text, '') = ''
	and	coalesce(nr_seq_escrit::text, '') = ''
	and	coalesce(nr_bordero::text, '') = '';
end if;

open c01;
loop
fetch c01 into
	nr_seq_imposto_w,
	vl_imposto_w,
	ie_gerar_titulo_pagar_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	select	nextval('titulo_pagar_imposto_seq')
	into STRICT	nr_seq_tit_pagar_imposto_w
	;

	insert into titulo_pagar_imposto(nr_sequencia,
		nr_titulo,
		cd_tributo,
		ie_pago_prev,
		dt_atualizacao,
		nm_usuario,
		dt_imposto,
		vl_base_calculo,
		vl_imposto,
		ds_emp_retencao,
		pr_imposto,
		cd_beneficiario,
		cd_conta_financ,
		nr_seq_trans_reg,
		nr_seq_trans_baixa,
		vl_nao_retido,
		ie_vencimento,
		VL_BASE_NAO_RETIDO,
		VL_TRIB_ADIC,
		VL_BASE_ADIC,
		vl_reducao,
		vl_desc_base,
		cd_darf,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_variacao,
		ie_periodicidade,
		nr_seq_baixa,
		nr_seq_tit_adiant)
	SELECT	nr_seq_tit_pagar_imposto_w,
		nr_titulo,
		cd_tributo,
		'V',
		clock_timestamp(),
		nm_usuario_p,
		dt_imposto,
		vl_base_calculo,
		vl_imposto,
		null,
		pr_imposto,
		cd_beneficiario,
		cd_conta_financ,
		nr_seq_trans_reg,
		nr_seq_trans_baixa,
		vl_nao_retido,
		ie_vencimento,
		VL_BASE_NAO_RETIDO,
		VL_TRIB_ADIC,
		VL_BASE_ADIC,
		vl_reducao,
		vl_desc_base,
		cd_darf,
		clock_timestamp(),
		nm_usuario_p,
		cd_variacao,
		ie_periodicidade,
		nr_seq_baixa,
		nr_seq_tit_adiant_p
	from	w_titulo_pagar_imposto
	where	nr_sequencia		= nr_seq_imposto_w;

	update	titulo_pagar_adiant
	set	vl_adiantamento	= coalesce(vl_adiantamento, 0) - vl_imposto_w,
		vl_imposto	= coalesce(vl_imposto, 0) + vl_imposto_w
	where	nr_titulo	= nr_titulo_p
	and	nr_sequencia	= nr_seq_tit_adiant_p;


	/* Projeto Multimoeda - Verifica se o adiantamento é em moeda estrangeira, caso positivo atualiza o valor do adiantamento
		em moeda estrangeira deduzindo o imposto convertido pela cotação do adiantamento. */
	if (coalesce(vl_adto_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		update	titulo_pagar_adiant
		set	vl_adto_estrang	= vl_adto_estrang - (vl_imposto_w / vl_cotacao),
			vl_complemento	= vl_adiantamento - (vl_adto_estrang - (vl_imposto_w / vl_cotacao))
		where	nr_titulo = nr_titulo_p
		  and	nr_sequencia = nr_seq_tit_adiant_p;
	end if;

	if (ie_gerar_titulo_pagar_w = 'S') then
		CALL Gerar_titulo_tributo(nr_seq_tit_pagar_imposto_w, nm_usuario_p);
	end if;

end loop;
close c01;

if (coalesce(philips_param_pck.get_cd_pais,1) = 2) then -- Se for México
	CALL atualiza_tributo_adiant_mx(nr_titulo_p, nr_seq_tit_adiant_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_tributo_tit_adiant (nr_titulo_p bigint, nr_seq_tit_adiant_p bigint, nm_usuario_p text) FROM PUBLIC;
