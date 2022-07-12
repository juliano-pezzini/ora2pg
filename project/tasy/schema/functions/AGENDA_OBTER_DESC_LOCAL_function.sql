-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION agenda_obter_desc_local (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_local_w			varchar(255);


BEGIN

select	max(coalesce(ds_local,''))
into STRICT	ds_local_w
from	maquina_local_painel
where	upper(nm_usuario_regra)	= upper(nm_usuario_p);

return ds_local_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION agenda_obter_desc_local (nm_usuario_p text) FROM PUBLIC;
