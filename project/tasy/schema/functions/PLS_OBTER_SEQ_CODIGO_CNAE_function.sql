-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_codigo_cnae ( nr_seq_cnae_p text, cd_cnae_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

if (nr_seq_cnae_p IS NOT NULL AND nr_seq_cnae_p::text <> '') then
	select	cd_cnae
	into STRICT	ds_retorno_w
	from	pls_cnae
	where	nr_sequencia	= nr_seq_cnae_p;

elsif (cd_cnae_p IS NOT NULL AND cd_cnae_p::text <> '') then
	select	nr_sequencia
	into STRICT	ds_retorno_w
	from	pls_cnae
	where	cd_cnae	= cd_cnae_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_codigo_cnae ( nr_seq_cnae_p text, cd_cnae_p text) FROM PUBLIC;

