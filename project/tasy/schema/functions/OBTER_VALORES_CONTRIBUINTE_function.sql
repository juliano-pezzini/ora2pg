-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_contribuinte ( nr_seq_contribuinte_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
Opções
T - Valor Total
U - valor Utilizado
S - Valor Saldo
*/
vl_retorno_w			double precision;
vl_total_w			double precision;
vl_utilizado_w			double precision;
vl_saldo_w			double precision;


BEGIN

select	coalesce(sum(a.vl_total), 0) vl_total,
	coalesce(sum(a.vl_utilizado), 0) vl_utilizado,
	coalesce(sum(a.vl_total), 0) - coalesce(sum(a.vl_utilizado), 0) vl_saldo
into STRICT	vl_total_w,
	vl_utilizado_w,
	vl_saldo_w
from	totais_contribuinte_v a
where	a.nr_seq_contribuinte	= nr_seq_contribuinte_p;

if (ie_opcao_p = 'T') then
	vl_retorno_w := vl_total_w;
elsif (ie_opcao_p = 'U') then
	vl_retorno_w := vl_utilizado_w;
elsif (ie_opcao_p = 'S') then
	vl_retorno_w := vl_saldo_w;
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_contribuinte ( nr_seq_contribuinte_p bigint, ie_opcao_p text) FROM PUBLIC;
