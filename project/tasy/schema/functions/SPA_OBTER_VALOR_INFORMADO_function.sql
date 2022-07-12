-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION spa_obter_valor_informado ( nr_seq_spa_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


vl_negociado_w		double precision	:= 0;
qt_negociada_w		double precision	:= 0;

/* ie_opcao_p:
V - Valor negociado.
Q - Quantidade negociada.
*/
BEGIN

if (nr_seq_spa_p IS NOT NULL AND nr_seq_spa_p::text <> '') then

	select	coalesce(sum(vl_negociado),0),
		coalesce(sum(qt_negociado),0)
	into STRICT	vl_negociado_w,
		qt_negociada_w
	from	spa_movimento a,
		spa_movimento_item b
	where	a.nr_sequencia = b.nr_seq_movimento
	and	a.nr_seq_spa = nr_seq_spa_p
	and	a.cd_classificacao = 2;

end if;

if (ie_opcao_p = 'V') then
	return	vl_negociado_w;
elsif (ie_opcao_p = 'Q') then
	return	qt_negociada_w;
else
	return	0;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION spa_obter_valor_informado ( nr_seq_spa_p bigint, ie_opcao_p text) FROM PUBLIC;
