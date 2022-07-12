-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_validade_amostra (dt_parametro_p timestamp) RETURNS timestamp AS $body$
DECLARE

qt_horas_w	integer;
dt_retorno_w	timestamp;

BEGIN
if (dt_parametro_p IS NOT NULL AND dt_parametro_p::text <> '') then
	select 	max(qt_validade_solic_reserva)
	into STRICT	qt_horas_w
	from 	san_parametro
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
end if;

if (qt_horas_w IS NOT NULL AND qt_horas_w::text <> '') and (qt_horas_w > 0) then
	select  	dt_parametro_p + (qt_horas_w / 24)
	into STRICT	dt_retorno_w
	;

end if;


return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_validade_amostra (dt_parametro_p timestamp) FROM PUBLIC;
