-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_repasse_esp_terceiro (nr_seq_terceiro_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(5);
qt_regra_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	regra_esp_repasse
where	ie_situacao 	= 'A'
and	nr_seq_terceiro	= nr_seq_terceiro_p;

if (qt_regra_w > 0) then
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
-- REVOKE ALL ON FUNCTION obter_se_repasse_esp_terceiro (nr_seq_terceiro_p text) FROM PUBLIC;

