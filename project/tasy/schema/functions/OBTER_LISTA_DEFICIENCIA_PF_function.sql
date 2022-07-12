-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_deficiencia_pf ( cd_pessoa_fisica_p text ) RETURNS varchar AS $body$
DECLARE


ds_deficiencia_w	varchar(255);
ds_lista_deficiencia_w	varchar(2000);

c01 CURSOR FOR
SELECT	ds_deficiencia
from	pf_tipo_deficiencia a,
	tipo_deficiencia b
where	a.nr_seq_tipo_def = b.nr_sequencia
and	cd_pessoa_fisica = cd_pessoa_fisica_p;


BEGIN

open c01;
loop
fetch c01 into
	ds_deficiencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ds_lista_deficiencia_w IS NOT NULL AND ds_lista_deficiencia_w::text <> '') then
		ds_lista_deficiencia_w := substr(ds_lista_deficiencia_w || ', ',1,2000);
	end if;

	ds_lista_deficiencia_w	:= substr(ds_lista_deficiencia_w || ds_deficiencia_w,1,2000);

	end;
end loop;
close c01;

return ds_lista_deficiencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_deficiencia_pf ( cd_pessoa_fisica_p text ) FROM PUBLIC;

