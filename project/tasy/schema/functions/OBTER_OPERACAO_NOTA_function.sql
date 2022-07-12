-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_operacao_nota ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


cd_operacao_nf_w	smallint;


BEGIN

select	coalesce(cd_operacao_nf,0)
into STRICT	cd_operacao_nf_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

return	cd_operacao_nf_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_operacao_nota ( nr_sequencia_p bigint) FROM PUBLIC;
