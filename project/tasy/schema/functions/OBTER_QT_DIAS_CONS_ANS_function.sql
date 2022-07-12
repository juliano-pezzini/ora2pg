-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dias_cons_ans (cd_especialidade_p bigint) RETURNS bigint AS $body$
DECLARE

qt_dias_cons_ans_w especialidade_medica.qt_dias_cons_ans%type := 0;


BEGIN
if (cd_especialidade_p IS NOT NULL AND cd_especialidade_p::text <> '') then

	select 	max(coalesce(qt_dias_cons_ans,0))
	into STRICT 	qt_dias_cons_ans_w
	from 	especialidade_medica
	where	cd_especialidade = cd_especialidade_p;
else
	qt_dias_cons_ans_w	:= 0;
end if;

return	qt_dias_cons_ans_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dias_cons_ans (cd_especialidade_p bigint) FROM PUBLIC;
