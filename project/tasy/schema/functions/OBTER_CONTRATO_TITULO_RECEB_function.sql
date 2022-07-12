-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_contrato_titulo_receb (nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_contrato_w	bigint;


BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	begin

	select 	max(a.nr_contrato)
	into STRICT 	nr_contrato_w
	from 	pls_lote_mensalidade a,
		pls_mensalidade b,
		titulo_receber c
	where  	a.nr_sequencia = b.nr_seq_lote
	and 	b.nr_sequencia = c.nr_seq_mensalidade
	and 	c.nr_titulo = nr_titulo_p;


	exception when others then
		nr_contrato_w := null;
	end;

end if;

return	substr(coalesce(nr_contrato_w,0),1,50);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_contrato_titulo_receb (nr_titulo_p bigint) FROM PUBLIC;

