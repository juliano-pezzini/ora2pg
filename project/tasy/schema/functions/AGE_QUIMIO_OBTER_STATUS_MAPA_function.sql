-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION age_quimio_obter_status_mapa ( ie_status_quimio_p text) RETURNS varchar AS $body$
DECLARE




ds_retorno_w	varchar(80);
qt_regra_status_w	bigint;
ie_status_quimio_w	varchar(80);




BEGIN

	begin
	select	 count(*),
		 a.ie_status_quimio
	into STRICT	 qt_regra_status_w,
		 ie_status_quimio_w
	from	 qt_status_mapa_ocupado a
	where	 a.ie_status_quimio   = ie_status_quimio_p
	and	 a.ie_situacao = 'A'
	group by a.ie_status_quimio;


	if (qt_regra_status_w > 0) then
		ds_retorno_w		:= ie_status_quimio_w;
	end if;
	end;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION age_quimio_obter_status_mapa ( ie_status_quimio_p text) FROM PUBLIC;
