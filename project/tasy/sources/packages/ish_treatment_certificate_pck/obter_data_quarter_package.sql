-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_treatment_certificate_pck.obter_data_quarter (dt_referencia_p timestamp, ie_tipo_p text) RETURNS timestamp AS $body$
DECLARE

	
dt_retorno_w	timestamp;
	

BEGIN
if (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') then
		begin
	if ((to_char(dt_referencia_p,'mm'))::numeric  <= 3) then
		begin
		if (ie_tipo_p = 'I') then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/01/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif (ie_tipo_p = 'F') then
			dt_retorno_w := PKG_DATE_UTILS.end_of(to_date('01/03/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		end if;		
		end;
	elsif ((to_char(dt_referencia_p,'mm'))::numeric  <= 6) then
		begin
		if (ie_tipo_p = 'I') then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/04/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif (ie_tipo_p = 'F') then
			dt_retorno_w := PKG_DATE_UTILS.end_of(to_date('01/06/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		end if;
		end;
	elsif ((to_char(dt_referencia_p,'mm'))::numeric  <= 9) then
		begin
		if (ie_tipo_p = 'I') then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/07/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif (ie_tipo_p = 'F') then
			dt_retorno_w := PKG_DATE_UTILS.end_of(to_date('01/09/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		end if;
		end;			
	else
		begin
		if (ie_tipo_p = 'I') then
			dt_retorno_w := PKG_DATE_UTILS.start_of(to_date('01/10/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		elsif (ie_tipo_p = 'F') then
			dt_retorno_w := PKG_DATE_UTILS.end_of(to_date('01/12/'||to_char(clock_timestamp(),'yyyy'),'dd/mm/yyyy'),'MONTH');
		end if;
		end;
	end if;
	end;
end if;

return dt_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_treatment_certificate_pck.obter_data_quarter (dt_referencia_p timestamp, ie_tipo_p text) FROM PUBLIC;
