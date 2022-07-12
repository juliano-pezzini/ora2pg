-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_ciclos_aplicacao (ds_ciclos_aplicacao_p text) RETURNS bigint AS $body$
DECLARE


qt_ciclos_aplicacao_w	bigint;
i			bigint;
qt_aux_w		bigint;


BEGIN


qt_aux_w:= 0;

if (ds_ciclos_aplicacao_p IS NOT NULL AND ds_ciclos_aplicacao_p::text <> '') then
	for i in 1..length(ds_ciclos_aplicacao_p) loop
		begin

		if (substr(ds_ciclos_aplicacao_p,i,1) = 'C') then
			qt_aux_w:= qt_aux_w + 1;
		end if;

		end;
	end loop;
end if;

if (qt_aux_w = 0) then
	qt_aux_w:= 1;
end if;

qt_ciclos_aplicacao_w:= qt_aux_w;

return	qt_ciclos_aplicacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_ciclos_aplicacao (ds_ciclos_aplicacao_p text) FROM PUBLIC;
