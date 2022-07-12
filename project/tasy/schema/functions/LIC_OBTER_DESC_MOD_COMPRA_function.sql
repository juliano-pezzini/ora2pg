-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_desc_mod_compra (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_modalidade_w			varchar(255);


BEGIN

select	ds_modalidade
into STRICT	ds_modalidade_w
from	reg_lic_mod_compra
where	nr_sequencia = nr_sequencia_p;

return	ds_modalidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_desc_mod_compra (nr_sequencia_p bigint) FROM PUBLIC;
