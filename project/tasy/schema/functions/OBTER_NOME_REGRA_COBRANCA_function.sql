-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_regra_cobranca ( nr_seq_regra_cobranca_p bigint) RETURNS varchar AS $body$
DECLARE

ds_regra_w	varchar(80);


BEGIN

select	max(ds_regra)
into STRICT	ds_regra_w
from	pep_regra_cobranca
where	nr_sequencia = nr_seq_regra_cobranca_p;

return	ds_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_regra_cobranca ( nr_seq_regra_cobranca_p bigint) FROM PUBLIC;
