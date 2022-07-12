-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ent_verifica_periodo (hr_parametro_p text) RETURNS varchar AS $body$
DECLARE


ie_periodo_w	varchar(1);
hr_parametro_w	timestamp;


BEGIN

hr_parametro_w := to_date(hr_parametro_p,'dd/mm/yyyy hh24:mi:ss');

select	max(ie_periodo_col)
into STRICT	ie_periodo_w
from	lote_ent_turno
where	to_char(hr_parametro_w,'hh24:mi:ss') between to_char(dt_inicial,'hh24:mi:ss') and to_char(dt_final,'hh24:mi:ss');

return	ie_periodo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ent_verifica_periodo (hr_parametro_p text) FROM PUBLIC;

