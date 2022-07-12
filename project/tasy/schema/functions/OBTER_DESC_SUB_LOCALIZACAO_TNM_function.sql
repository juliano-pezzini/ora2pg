-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_sub_localizacao_tnm ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_sub_localizacao_w	varchar(255);

BEGIN
Select	ds_sub_localizacao
into STRICT	ds_sub_localizacao_w
from	can_tnm_sub_localizacao
where	nr_sequencia = nr_sequencia_p;

return	ds_sub_localizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_sub_localizacao_tnm ( nr_sequencia_p bigint) FROM PUBLIC;
