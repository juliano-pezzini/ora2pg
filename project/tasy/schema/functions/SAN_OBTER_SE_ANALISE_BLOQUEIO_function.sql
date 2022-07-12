-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_analise_bloqueio ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);
qt_valida_w	bigint;


BEGIN
ie_retorno_w := 'N';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_opcao_p = 'P') then
	select	count(*)
	into STRICT	qt_valida_w
	from	san_prod_analise_critica a,
		san_analise_critica b
	where	a.nr_seq_producao = nr_sequencia_p
	and	a.nr_seq_analise_critica = b.nr_sequencia
	and	coalesce(b.ie_bloquear,'N') = 'S'
	and	(a.nr_seq_producao IS NOT NULL AND a.nr_seq_producao::text <> '');

	if (qt_valida_w > 0) then
		ie_retorno_w := 'S';
	end if;
elsif (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_opcao_p = 'D') then
	select	count(*)
	into STRICT	qt_valida_w
	from	san_prod_analise_critica a,
		san_analise_critica b
	where	a.nr_seq_doacao = nr_sequencia_p
	and	a.nr_seq_analise_critica = b.nr_sequencia
	and	coalesce(b.ie_bloquear,'N') = 'S'
	and	coalesce(a.nr_seq_producao::text, '') = '';

	if (qt_valida_w > 0) then
		ie_retorno_w := 'S';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_analise_bloqueio ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;
