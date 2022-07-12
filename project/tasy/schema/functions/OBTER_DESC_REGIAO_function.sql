-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_regiao ( nr_seq_regiao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w		varchar(80);


BEGIN
select	ds_regiao
into STRICT	ds_resultado_w
from	regiao_sindrome
where	nr_sequencia = nr_seq_regiao_p;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_regiao ( nr_seq_regiao_p bigint) FROM PUBLIC;
