-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION autocomplete_style ( ds_desc_princ_p text, ds_desc_secun_p text) RETURNS varchar AS $body$
BEGIN
	if (ds_desc_princ_p IS NOT NULL AND ds_desc_princ_p::text <> '') and (ds_desc_secun_p IS NOT NULL AND ds_desc_secun_p::text <> '') then
			return ds_desc_princ_p || '<br><span style="color:#808080 100%; opacity: 100%; font-size:12px; font-family:''CentraleSansCndBook''; character:0.2px; top:8px;">'|| ds_desc_secun_p ||'</span>';
	else
		return ds_desc_princ_p;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION autocomplete_style ( ds_desc_princ_p text, ds_desc_secun_p text) FROM PUBLIC;
