-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_entrega_medic (nr_seq_entrega_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(1);

BEGIN

SELECT 	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
FROM   	fa_entrega_medicacao_item
WHERE  	nr_seq_fa_entrega = nr_seq_entrega_p
AND	qt_dispensar 	 > 0;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_entrega_medic (nr_seq_entrega_p bigint) FROM PUBLIC;
