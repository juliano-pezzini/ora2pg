-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION converte_fracao_dose ( cd_unidade_medida_p text, qt_dose_p bigint) RETURNS varchar AS $body$
DECLARE


vl_inteiro_w 		varchar(50);
vl_fracao_w 		double precision;
Resultado_w 		varchar(50);
ie_fracao_dose_w	varchar(1);


BEGIN

select	coalesce(max(ie_fracao_dose),'N')
into STRICT	ie_fracao_dose_w
from	unidade_medida
where	cd_unidade_medida	= cd_unidade_medida_p;

if 	((qt_dose_p IS NOT NULL AND qt_dose_p::text <> '') and (ie_fracao_dose_w = 'S') or (cd_unidade_medida_p = 'Cp')   or (cd_unidade_medida_p  = 'cp')   or (cd_unidade_medida_p  = 'Drg')  or (cd_unidade_medida_p  = 'drg')) then
	begin
	vl_inteiro_w		:= to_char(trunc(qt_dose_p));
	vl_fracao_w		:= (qt_dose_p - trunc(qt_dose_p)) * 100;
	if (vl_inteiro_w = '0') then
           	vl_inteiro_w    := '';
	end if;
	if (vl_fracao_w = 25) then
		Resultado_w	:= vl_inteiro_w || chr(188); /* ' ¼' */
	elsif (vl_fracao_w = 50) then
		Resultado_w	:= vl_inteiro_w || chr(189); /* ' ½' */
	elsif (vl_fracao_w = 75) then
		Resultado_w	:= vl_inteiro_w || chr(190); /* ' ¾' */
	else
		Resultado_w	:= to_char(qt_dose_p);
	end if;
	end;
else
	if (trunc(qt_dose_p) = 0) then
	   	Resultado_w	:= '0' || to_char(qt_dose_p - trunc(qt_dose_p));
	else
		Resultado_w 	:= to_char(qt_dose_p);
	end if;
end if;

RETURN Resultado_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION converte_fracao_dose ( cd_unidade_medida_p text, qt_dose_p bigint) FROM PUBLIC;
