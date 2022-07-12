-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_final_capd ( dt_horario_p text, qt_minutos_p bigint) RETURNS varchar AS $body$
DECLARE


dt_fim_w	varchar(5);


BEGIN

select	to_char(to_date(dt_horario_p,'hh24:mi') + qt_minutos_p/1440,'hh24:mi')
into STRICT	dt_fim_w
;

return	dt_fim_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_final_capd ( dt_horario_p text, qt_minutos_p bigint) FROM PUBLIC;

