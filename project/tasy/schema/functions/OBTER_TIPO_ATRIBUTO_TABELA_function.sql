-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_atributo_tabela ( nm_tabela_p text, nm_atributo_p text) RETURNS varchar AS $body$
DECLARE


ds_tipo_atributo_w	varchar(15);

BEGIN

select max(a.ie_tipo_atributo)
into STRICT  ds_tipo_atributo_w
from tabela_atributo a
where a.nm_tabela = nm_tabela_p
and a.nm_atributo = nm_atributo_p;

return	ds_tipo_atributo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_atributo_tabela ( nm_tabela_p text, nm_atributo_p text) FROM PUBLIC;
