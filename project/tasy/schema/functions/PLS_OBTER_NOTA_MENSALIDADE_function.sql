-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nota_mensalidade (nr_seq_mensalidade_p bigint) RETURNS bigint AS $body$
DECLARE

nr_seq_nota_fiscal_w	bigint;


BEGIN

if (nr_seq_mensalidade_p IS NOT NULL AND nr_seq_mensalidade_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_nota_fiscal_w
	from	nota_fiscal
	where	nr_seq_mensalidade	= nr_seq_mensalidade_p;
end if;

return nr_seq_nota_fiscal_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nota_mensalidade (nr_seq_mensalidade_p bigint) FROM PUBLIC;

