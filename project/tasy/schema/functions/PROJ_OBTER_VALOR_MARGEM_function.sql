-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_valor_margem ( nr_seq_projeto_p bigint, ie_tipo_valor_p text) RETURNS bigint AS $body$
DECLARE


/* IE_TIPO_VALOR_P
	O - Orçado
	R - Realizado
	RN - Realizado com despesas da Wheb
*/
vl_retorno_w			double precision	:= 0;
vl_margem_w			double precision	:= 0;
vl_despesa_w			double precision	:= 0;
ie_tipo_valor_w			varchar(2);


BEGIN

/*vl_margem_w	:= proj_obter_valor_margem(nr_seq_projeto_p, ie_tipo_valor_p);
	Conforme solicitado pelo Jair o valor da margem NÃO subtrai o valor de despesa*/
if (ie_tipo_valor_p	= 'RN') then
	ie_tipo_valor_w	:= 'R';
else
	ie_tipo_valor_w	:= ie_tipo_valor_p;
end if;

select	coalesce(sum(vl_margem),0)
into STRICT	vl_margem_w
from	proj_orcamento	b,
	proj_orc_prof	a
where	a.nr_seq_orc	= b.nr_sequencia
and	b.nr_seq_proj	= nr_seq_projeto_p
and	a.ie_tipo_valor	= ie_tipo_valor_w;

if (ie_tipo_valor_p	= 'RN') then
	vl_despesa_w	:= proj_obter_total_despesa(nr_seq_projeto_p, ie_tipo_valor_p);
end if;

vl_retorno_w	:= vl_margem_w - vl_despesa_w;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_valor_margem ( nr_seq_projeto_p bigint, ie_tipo_valor_p text) FROM PUBLIC;

