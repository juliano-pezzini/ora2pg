-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_visu_proj_rec_lib_usu (nr_seq_proj_rec_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
ie_permite_w	projeto_recurso_lib_usu.ie_permite%type;
qt_registro_w	integer;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	projeto_recurso_lib_usu
where	nr_seq_projeto = nr_seq_proj_rec_p;

if (qt_registro_w = 0) then
	ds_retorno_w := 'S';
else
	select	count(*)
	into STRICT	qt_registro_w
	from	projeto_recurso_lib_usu
	where	nm_usuario_lib = wheb_usuario_pck.get_nm_usuario
	and	nr_seq_projeto = nr_seq_proj_rec_p
	and	ie_permite = 'S';

	if (qt_registro_w > 0) then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_visu_proj_rec_lib_usu (nr_seq_proj_rec_p bigint) FROM PUBLIC;

