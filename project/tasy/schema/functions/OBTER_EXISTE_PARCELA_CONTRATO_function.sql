-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_existe_parcela_contrato (nr_seq_contrato_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
qt_parcelas_w	bigint;


BEGIN
ds_retorno_w := 'N';
select	count(*)
into STRICT	qt_parcelas_w
from	emprest_financ_parc
where	nr_seq_contrato = nr_seq_contrato_p;

if (coalesce(qt_parcelas_w,0) > 0) then
	ds_retorno_w := 'S';
else
	ds_retorno_w := 'N';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_existe_parcela_contrato (nr_seq_contrato_p bigint) FROM PUBLIC;

