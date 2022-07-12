-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_descricao_pat_bem ( cd_bem_p text) RETURNS varchar AS $body$
DECLARE


ds_bem_w		varchar(255);


BEGIN

select	max(ds_bem)
into STRICT	ds_bem_w
from	pat_bem
where	cd_bem = cd_bem_p;

return	ds_bem_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_descricao_pat_bem ( cd_bem_p text) FROM PUBLIC;

