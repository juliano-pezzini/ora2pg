-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_categ_classificado (nr_seq_categoria_p bigint) RETURNS varchar AS $body$
DECLARE


ds_categoria_w	varchar(254);


BEGIN

select	ds_categoria
into STRICT	ds_categoria_w
from	categoria_classificado
where	nr_sequencia = nr_seq_categoria_p;

return	ds_categoria_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_categ_classificado (nr_seq_categoria_p bigint) FROM PUBLIC;

