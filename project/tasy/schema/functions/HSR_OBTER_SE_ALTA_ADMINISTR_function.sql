-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsr_obter_se_alta_administr (dt_alta_p timestamp, dt_periodo_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1):= 'N';


BEGIN

if (dt_periodo_final_p < coalesce(dt_alta_p, clock_timestamp())) then
	ie_retorno_w:= 'S';
else
	ie_retorno_w:= 'N';
end if;

return ie_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsr_obter_se_alta_administr (dt_alta_p timestamp, dt_periodo_final_p timestamp) FROM PUBLIC;

