-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_shortened_error_msg (ds_error_p text) RETURNS varchar AS $body$
DECLARE


ds_mensagem_w	varchar(2000);
ds_auxiliar_W	varchar(4000);
ds_erro_ora_w	varchar(10);

BEGIN

ds_auxiliar_w := ds_error_p;

while(position('ORA-20001:' in ds_auxiliar_w) > 0) loop
	ds_auxiliar_w := trim(both substr(ds_auxiliar_w, position('ORA-20001:' in ds_auxiliar_w) + 10, 4000));
end loop;

while(position('ORA-20011:' in ds_auxiliar_w) > 0) loop
	ds_auxiliar_w := trim(both substr(ds_auxiliar_w, position('ORA-20011:' in ds_auxiliar_w) + 10, 4000));
end loop;

if (position('ORA-' in ds_auxiliar_w) > 0) then

	if (position('ORA-' in ds_auxiliar_w) < 5) then
		ds_erro_ora_w := substr(ds_auxiliar_w, 1, 10);
		ds_auxiliar_w := trim(both substr(ds_auxiliar_w, 11, 4000));
		ds_auxiliar_w := trim(both substr(substr(ds_auxiliar_w, 1, position('ORA-' in ds_auxiliar_w) - 1), 1, 4000));
	else
		ds_auxiliar_w := trim(both substr(substr(ds_auxiliar_w, 1, position('ORA-' in ds_auxiliar_w) - 1), 1, 4000));
	end if;
end if;

ds_mensagem_w := substr(ds_auxiliar_w, 1, 2000);

if (position('#@#@' in ds_mensagem_w) > 0) then
	ds_mensagem_w := substr(ds_mensagem_w, 1, position('#@#@' in ds_mensagem_w) - 1);
end if;

return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_shortened_error_msg (ds_error_p text) FROM PUBLIC;
