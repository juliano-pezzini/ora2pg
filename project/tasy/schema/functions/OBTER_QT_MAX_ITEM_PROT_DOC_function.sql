-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_max_item_prot_doc (ie_tipo_protocolo_p text) RETURNS bigint AS $body$
DECLARE


c01 CURSOR FOR
	SELECT	qt_maxima
	from	regra_qtmax_item_prot_doc
	where	ie_tipo_protocolo = ie_tipo_protocolo_p;

c01_w c01%rowtype;

ds_retorno_w regra_qtmax_item_prot_doc.qt_maxima%type;


BEGIN

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_retorno_w := c01_w.qt_maxima;
	end;
end loop;
close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_max_item_prot_doc (ie_tipo_protocolo_p text) FROM PUBLIC;
