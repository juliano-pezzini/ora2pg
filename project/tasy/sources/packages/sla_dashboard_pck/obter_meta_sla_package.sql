-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	--###################################################################################################




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_meta_sla (dt_referencia_p timestamp, ie_tipo_sla_p text) RETURNS bigint AS $body$
DECLARE


	qt_meta_w		double precision;

	
BEGIN

	if (ie_tipo_sla_p = 'SWP') then
		qt_meta_w := obter_meta_bsc_sla(2627,dt_referencia_p);
	elsif (ie_tipo_sla_p = 'SWC') then
		qt_meta_w := obter_meta_bsc_sla(2628,dt_referencia_p);
	elsif (ie_tipo_sla_p = 'OBI') then
		qt_meta_w := obter_meta_bsc_sla(852,dt_referencia_p);
	elsif (ie_tipo_sla_p = 'ALLDEF') then
		qt_meta_w := obter_meta_bsc_sla(2637,dt_referencia_p);
	end if;

	return qt_meta_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_meta_sla (dt_referencia_p timestamp, ie_tipo_sla_p text) FROM PUBLIC;