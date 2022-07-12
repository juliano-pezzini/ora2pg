-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_senha ( nr_seq_guia_p text, nr_seq_req_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	select	cd_senha
	into STRICT	ds_retorno_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_p;
elsif (nr_seq_req_p IS NOT NULL AND nr_seq_req_p::text <> '') then
	select	cd_senha
	into STRICT	ds_retorno_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_req_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_senha ( nr_seq_guia_p text, nr_seq_req_p text) FROM PUBLIC;
