-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_cobr ( nr_seq_cobr_escritural_p bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE

/*
ie_opcao_p
1 = Valor Total títulos
2 = Valor diferença, Valor Total - comissão
*/
ds_retorno_w	double precision;
vl_retorno_w	double precision;
vl_comissao_w	double precision;


BEGIN

select	sum(a.vl_cobranca)
into STRICT	vl_retorno_w
from	titulo_receber_cobr	a,
	cobranca_escritural	b
where	b.nr_sequencia		= a.nr_seq_cobranca
and	a.nr_seq_cobranca	= nr_seq_cobr_escritural_p;

select	vl_comissao_empresa
into STRICT	vl_comissao_w
from	cobranca_escritural
where	nr_sequencia = nr_seq_cobr_escritural_p;

if (ie_opcao_p = 1) then
	ds_retorno_w := vl_retorno_w;
elsif (ie_opcao_p = 2) then
	ds_retorno_w := vl_retorno_w - vl_comissao_w;
end if;

return	coalesce(ds_retorno_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_cobr ( nr_seq_cobr_escritural_p bigint, ie_opcao_p bigint) FROM PUBLIC;

