-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_local_direto (cd_local_estoque_p bigint) RETURNS varchar AS $body$
DECLARE


ie_direto_w		varchar(1);


BEGIN

select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
into STRICT ie_direto_w
from local_estoque
where cd_local_estoque = cd_local_estoque_p
  and ie_tipo_local = 8;

return ie_direto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_local_direto (cd_local_estoque_p bigint) FROM PUBLIC;

