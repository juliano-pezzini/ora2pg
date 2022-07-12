-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_item_result (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_resultado_w	varchar(2);


BEGIN

select	ie_resultado
into STRICT	ie_resultado_w
from	med_item_avaliar
where	nr_sequencia	= nr_sequencia_p;

return	ie_resultado_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_item_result (nr_sequencia_p bigint) FROM PUBLIC;

