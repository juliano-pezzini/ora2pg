-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_totais_sla_information (dt_referencia_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opcao_p
OPENED_DEFECTS
RESPONSE_BREACHED
RESOLUTION_BREACHED
*/
qt_registro_w	bigint := 0;

BEGIN

if (ie_opcao_p = 'OPENED_DEFECTS') then

	select	count(status_sla_response)
	into STRICT	qt_registro_w
	from    sla_informations b
	where	trunc(b.extract_date,'month') = trunc(dt_referencia_p, 'month')
	and	develop_management_id 	<> 68
	and	sla_detail 		<> 'PSOTR';
	
elsif (ie_opcao_p = 'RESPONSE_BREACHED') then

	select	count(status_sla_response)
	into STRICT	qt_registro_w
	from	sla_informations c
	where   trunc(c.extract_date,'month') = trunc(dt_referencia_p, 'month')
	and     upper(status_sla_response) = upper('breached')
	and 	((so_sla = 'S') or (philips_classification = 'Defeito'))
	and	develop_management_id <> 68
	and	sla_detail <> 'PSOTR';

elsif (ie_opcao_p = 'RESOLUTION_BREACHED') then

	select	count(status_sla_resolution)
	into STRICT	qt_registro_w
	from    sla_informations d
	where	trunc(d.extract_date,'month') = trunc(dt_referencia_p, 'month')
	and     upper(status_sla_resolution) = upper('breached')
	and 	((so_sla = 'S') or (philips_classification = 'Defeito'))
	and	develop_management_id <> 68
	and	sla_detail <> 'PSOTR';

end if;

return qt_registro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_totais_sla_information (dt_referencia_p timestamp, ie_opcao_p text) FROM PUBLIC;

