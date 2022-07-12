-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_perito ( nr_seq_perito_p pls_analise_perito.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

select	max(obter_nome_pf(cd_pessoa_fisica))
into STRICT	ds_retorno_w
from	pls_analise_perito
where	nr_sequencia	= nr_seq_perito_p;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_perito ( nr_seq_perito_p pls_analise_perito.nr_sequencia%type) FROM PUBLIC;

