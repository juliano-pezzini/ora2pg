-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nr_id_origem_ptu (nr_seq_contestacao_p bigint, nr_nota_p bigint, ds_versao_p text, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;


BEGIN

if (ds_versao_p = '3.8') then

	select	count(*)
	into STRICT	nr_retorno_w
	from	ptu_questionamento
	where	nr_sequencia	<= nr_sequencia_p
	and	nr_nota	= nr_nota_p
	and	nr_seq_contestacao = nr_seq_contestacao_p;

elsif (ds_versao_p = '3.4') then

	select	count(*)
	into STRICT	nr_retorno_w
	from	ptu_questionamento_codigo	a,
		ptu_questionamento		b
	where	a.nr_seq_registro	= b.nr_sequencia
	and	b.nr_nota		= nr_nota_p
	and	a.nr_sequencia		<= nr_sequencia_p;

end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nr_id_origem_ptu (nr_seq_contestacao_p bigint, nr_nota_p bigint, ds_versao_p text, nr_sequencia_p bigint) FROM PUBLIC;

