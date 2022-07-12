-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_padrao (nm_tabela_p text, nm_atributo_p text) RETURNS varchar AS $body$
DECLARE


vl_padrao_w	varchar(50);


BEGIN

select	max(vl_default)
into STRICT	vl_padrao_w
from	tabela_atributo
where	nm_tabela	= UPPER(nm_tabela_p)
and	nm_atributo	= UPPER(nm_atributo_p);

return	vl_padrao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_padrao (nm_tabela_p text, nm_atributo_p text) FROM PUBLIC;

