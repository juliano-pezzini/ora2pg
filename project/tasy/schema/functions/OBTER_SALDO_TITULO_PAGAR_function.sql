-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_titulo_pagar ( nr_titulo_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


dt_referencia_w			timestamp;
vl_titulo_w			double precision;
vl_saldo_data_w			double precision;
vl_baixa_w			double precision;
vl_alteracao_w			double precision;
vl_adiantamento_w		double precision;
ie_situacao_w			varchar(10);
ie_trib_atualiza_saldo_w	varchar(5);
ie_trib_saldo_tit_nf_w	varchar(5);
vl_tributo_w			double precision;
cd_funcao_ativa_w		bigint;
ie_forma_saldo_w		varchar(1);
qt_trib_nf_w			integer;
nr_seq_nota_fiscal_w		nota_fiscal_trib.nr_sequencia%type;
nr_repasse_terceiro_w		titulo_pagar.nr_repasse_terceiro%type;
qt_trib_repasse_w			integer;


BEGIN

ie_forma_saldo_w	:= 'C';
cd_funcao_ativa_w 	:= obter_funcao_ativa;
	
if (cd_funcao_ativa_w = 5512) then
	ie_forma_saldo_w := substr(coalesce(obter_valor_param_usuario(5512, 10, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo),'C'),1,1);
end if;

dt_referencia_w		:= trunc(dt_referencia_p,'dd') + 86399/86400;

select		max(b.ie_trib_atualiza_saldo), coalesce(max(b.ie_trib_saldo_tit_nf),'N')
into STRICT		ie_trib_atualiza_saldo_w, ie_trib_saldo_tit_nf_w
from		parametros_contas_pagar b,
			titulo_pagar a
where		b.cd_estabelecimento	= a.cd_estabelecimento
and			a.nr_titulo		= nr_titulo_p;

begin
select		vl_titulo,
		ie_situacao,
		nr_repasse_terceiro,
		nr_seq_nota_fiscal,
		vl_saldo_titulo
into STRICT		vl_titulo_w,
		ie_situacao_w,
		nr_repasse_terceiro_w,
		nr_seq_nota_fiscal_w,
		vl_saldo_data_w
from		titulo_pagar
where		nr_titulo	= nr_titulo_p;
exception
    	when others then
	begin
	vl_titulo_w		:= 0;
	vl_saldo_data_w		:= 0;
	end;
end;

if (ie_forma_saldo_w <> 'A') then
	begin
	/* francisco - os 168616 - 24/12/2009 - tratei o vl cotacao */

	select 	coalesce(sum(dividir_sem_round(vl_baixa,CASE WHEN coalesce(vl_cotacao_moeda,0)=0 THEN 1 WHEN coalesce(vl_cotacao_moeda,0)=vl_cotacao_moeda THEN 1 END )),0)
	into STRICT	vl_baixa_w
	from 	titulo_pagar_baixa
	where	nr_titulo	= nr_titulo_p
	and 	dt_baixa	<= dt_referencia_w;

	select 	coalesce(sum(vl_adiantamento),0)
	into STRICT	vl_adiantamento_w
	from 	titulo_pagar_adiant
	where	nr_titulo	= nr_titulo_p
	and 	trunc(coalesce(dt_contabil, dt_atualizacao), 'dd')	<= dt_referencia_w;

	select 	coalesce(sum(vl_alteracao - vl_anterior),0)
	into STRICT	vl_alteracao_w
	from 	titulo_pagar_alt_valor
	where	nr_titulo	= nr_titulo_p
	and	dt_alteracao	<= dt_referencia_w;
	
	vl_tributo_w	:= 0;

	if (ie_trib_atualiza_saldo_w = 'S') then
		select	count(*)
		into STRICT	qt_trib_nf_w
		from	nota_fiscal_trib a
		where	a.nr_sequencia	= nr_seq_nota_fiscal_w;

		if (qt_trib_nf_w = 0) then
			select	count(*)
			into STRICT	qt_trib_nf_w
			from	nota_fiscal_item_trib a
			where	nr_sequencia	= nr_seq_nota_fiscal_w;
		end if;

		if (qt_trib_nf_w = 0) then
			select	count(*)
			into STRICT	qt_trib_nf_w
			from	nota_fiscal_venc_trib b,
				nota_fiscal_venc a
			where	a.nr_sequencia	= nr_seq_nota_fiscal_w
			and	a.nr_sequencia	= b.nr_sequencia;
		end if;
	
		select  coalesce(max(1),0)
		into STRICT    qt_trib_repasse_w
		from    repasse_terceiro_venc    b,
			repasse_terc_venc_trib   a
		where   a.nr_seq_rep_venc = b.nr_sequencia
		and     b.nr_repasse_terceiro = nr_repasse_terceiro_w;

		if (coalesce(nr_seq_nota_fiscal_w,0) = 0 or qt_trib_nf_w = 0)then

			select	coalesce(sum(a.vl_imposto),0)
			into STRICT	vl_tributo_w
			from	titulo_pagar_imposto a,
				titulo_pagar b,
				tributo c,
				titulo_pagar d
			where	b.nr_titulo			= nr_titulo_p
			and	a.nr_titulo			= b.nr_titulo
			and	a.cd_tributo			= c.cd_tributo
			and     Obter_Titulo_Imposto(a.nr_sequencia)	= d.nr_titulo
			and (coalesce(b.nr_repasse_terceiro::text, '') = '' or qt_trib_repasse_w = 0)
			and (coalesce(b.nr_seq_nota_fiscal::text, '') = '' or
				not exists (SELECT	1
				from	nota_fiscal_trib x
				where	x.cd_tributo	= a.cd_tributo
				and	x.nr_sequencia	= b.nr_seq_nota_fiscal))
			and	coalesce(b.ie_pls, 'N')		= 'N'
			and	a.ie_pago_prev			= 'V'
			and	ie_trib_atualiza_saldo_w	= 'S'
			and	coalesce(c.ie_saldo_tit_pagar,'S')	= 'S'
			and	d.dt_emissao                   <= fim_dia(dt_referencia_w);

		else

			if (ie_trib_saldo_tit_nf_w = 'N') then
				select	coalesce(sum(a.vl_imposto),0)
				into STRICT	vl_tributo_w
				from	titulo_pagar_imposto a,
					titulo_pagar b,
					tributo c,
					titulo_pagar d
				where	b.nr_titulo			= nr_titulo_p
				and	a.nr_titulo			= b.nr_titulo
				and	a.cd_tributo			= c.cd_tributo
				and     Obter_Titulo_Imposto(a.nr_sequencia)	= d.nr_titulo
				and (coalesce(b.nr_repasse_terceiro::text, '') = '' or qt_trib_repasse_w = 0)
				and	coalesce(b.ie_pls, 'N')		= 'N'
				and	a.ie_pago_prev			= 'V'
				and	coalesce(c.ie_saldo_tit_pagar,'S')	= 'S'
				and	(a.nr_seq_baixa IS NOT NULL AND a.nr_seq_baixa::text <> '')
				and	d.dt_emissao                   <= dt_referencia_w;
			else
				select	coalesce(sum(a.vl_imposto),0)
				into STRICT	vl_tributo_w
				from	titulo_pagar_imposto a,
					titulo_pagar b,
					tributo c,
					titulo_pagar d
				where	b.nr_titulo			= nr_titulo_p
				and	a.nr_titulo			= b.nr_titulo
				and	a.cd_tributo			= c.cd_tributo
				and     Obter_Titulo_Imposto(a.nr_sequencia)	= d.nr_titulo
				and (coalesce(b.nr_repasse_terceiro::text, '') = '' or qt_trib_repasse_w = 0)
				and	coalesce(b.ie_pls, 'N')		= 'N'
				and	a.ie_pago_prev			= 'V'
				and	coalesce(c.ie_saldo_tit_pagar,'S')	= 'S'
				and	d.dt_emissao                   <= dt_referencia_w;
			end if;
		end if;
	end if;

	if (ie_situacao_w <> 'D') then /* quando o titulo for desdobrado trazer zero, pois o titulo fia sem baixa */
		vl_saldo_data_w	:= vl_titulo_w - vl_baixa_w + vl_alteracao_w - vl_adiantamento_w - coalesce(vl_tributo_w,0);
	else
		vl_saldo_data_w	:= 0;
	end if;
	end;
end if;

return coalesce(vl_saldo_data_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_titulo_pagar ( nr_titulo_p bigint, dt_referencia_p timestamp) FROM PUBLIC;

