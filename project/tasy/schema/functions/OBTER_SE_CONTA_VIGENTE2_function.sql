-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conta_vigente2 ( cd_conta_contabil_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE



ie_vigente_w		varchar(1)	:= 'S';
qt_vigencia_w		smallint;
dt_inicio_vigencia_w	timestamp;
dt_fim_vigencia_w	timestamp;
dt_vigencia_w		timestamp;


BEGIN

dt_inicio_vigencia_w	:= trunc(dt_inicio_vigencia_p);
dt_fim_vigencia_w	:= trunc(dt_fim_vigencia_p);
dt_vigencia_w		:= trunc(dt_vigencia_p);

if	(dt_inicio_vigencia_w IS NOT NULL AND dt_inicio_vigencia_w::text <> '' AND dt_vigencia_w < dt_inicio_vigencia_w) or
	(dt_fim_vigencia_w IS NOT NULL AND dt_fim_vigencia_w::text <> '' AND dt_vigencia_w > dt_fim_vigencia_w) then
	ie_vigente_w	:= 'N';
end if;	

return	ie_vigente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conta_vigente2 ( cd_conta_contabil_p text, dt_inicio_vigencia_p timestamp, dt_fim_vigencia_p timestamp, dt_vigencia_p timestamp) FROM PUBLIC;

