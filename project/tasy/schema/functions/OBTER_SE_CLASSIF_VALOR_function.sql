-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_classif_valor (nr_titulo_p bigint, nr_seq_nota_fiscal_p bigint, nr_repasse_terceiro_p bigint, vl_titulo_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


-- ATENÇÃO !!! não pode fazer select da TITULO_PAGAR nesta function, pois ela é chamada no update da TITULO_PAGAR
vl_titulo_w			double precision;
IE_TRIB_ATUALIZA_SALDO_w	varchar(3);
vl_tributo_w			double precision;
vl_classificacao_w		double precision;
ds_retorno_w			varchar(3);
vl_alteracao_w			titulo_pagar_alt_valor.vl_alteracao%type;

/*Alterado*/

c02 CURSOR FOR
SELECT	coalesce(sum(vl_alteracao - vl_anterior),0)
from	titulo_pagar_alt_valor
where	nr_titulo	= nr_titulo_p
order	by dt_alteracao,
	dt_atualizacao;


BEGIN

vl_titulo_w		:= vl_titulo_p;
open c02;
loop
fetch c02 into
	vl_alteracao_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
end loop;
close c02;

select	b.IE_TRIB_ATUALIZA_SALDO
into STRICT	IE_TRIB_ATUALIZA_SALDO_w
from	parametros_contas_pagar b
where	b.cd_estabelecimento	= cd_estabelecimento_p;

select	coalesce(sum(b.vl_imposto), 0)
into STRICT	vl_tributo_w
from	tributo a,
	titulo_pagar_imposto b
where	b.nr_titulo	= nr_titulo_p
and	b.ie_pago_prev	= 'V'
and	coalesce(nr_seq_nota_fiscal_p,0)	= 0
and	coalesce(nr_repasse_terceiro_p,0)	= 0
and	b.cd_tributo			= a.cd_tributo
and	coalesce(a.IE_SALDO_TIT_PAGAR, 'S')	= 'S';

select	coalesce(sum(vl_titulo),0)
into STRICT	vl_classificacao_w
from	titulo_pagar_classif
where	nr_titulo	= nr_titulo_p;

vl_titulo_w	:= vl_titulo_w - vl_tributo_w + coalesce(vl_alteracao_w,0);

ds_retorno_w		:= 'N';
if (vl_classificacao_w = vl_titulo_w) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_classif_valor (nr_titulo_p bigint, nr_seq_nota_fiscal_p bigint, nr_repasse_terceiro_p bigint, vl_titulo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

