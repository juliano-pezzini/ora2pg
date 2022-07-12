-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION dl_obter_desc_tipo_item (nr_seq_tipo_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_tipo_item_w	varchar(255);


BEGIN

select	obter_valor_dominio(3131,ie_tipo_item)
into STRICT	ds_tipo_item_w
from	dl_tipo_item
where	nr_sequencia = nr_seq_tipo_item_p;

return	ds_tipo_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION dl_obter_desc_tipo_item (nr_seq_tipo_item_p bigint) FROM PUBLIC;
