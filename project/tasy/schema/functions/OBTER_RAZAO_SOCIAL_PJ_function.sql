-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_razao_social_pj (nr_seq_uni_exec_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(255);

BEGIN

if (nr_seq_uni_exec_p IS NOT NULL AND nr_seq_uni_exec_p::text <> '')then

	select	substr(y.cd_cgc,1,255)
	into STRICT 	ds_retorno_w
	from 	pessoa_juridica y,
			pls_congenere x 
	where 	x.cd_cgc = y.cd_cgc 
	and 	x.nr_sequencia = nr_seq_uni_exec_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_razao_social_pj (nr_seq_uni_exec_p bigint) FROM PUBLIC;

