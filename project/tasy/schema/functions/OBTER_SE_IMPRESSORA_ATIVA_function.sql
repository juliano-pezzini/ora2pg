-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_impressora_ativa (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_situacao_w	varchar(1);


BEGIN

select	ie_situacao
into STRICT	ie_situacao_w
from	impressora
where	nr_sequencia = nr_sequencia_p;

if (ie_situacao_w = 'A') then
	return	'S';
else
	return	'N';
end	if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_impressora_ativa (nr_sequencia_p bigint) FROM PUBLIC;
