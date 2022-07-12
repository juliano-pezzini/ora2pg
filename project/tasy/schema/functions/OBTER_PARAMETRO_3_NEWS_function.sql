-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_parametro_3_news (nr_sequencia_p bigint, ie_tipo_p text default 'A', vl_param_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ie_parametro3_w  varchar(1) := 'N';
qt_reg_w		 bigint;
nr_atendimento_w bigint;


BEGIN

if (ie_tipo_p = 'FR') and (vl_param_p <= 8 or vl_param_p >= 25) then
	ie_parametro3_w := 'S';
elsif (ie_tipo_p = 'SO2') and (vl_param_p <= 91) then
	ie_parametro3_w := 'S';
elsif (ie_tipo_p = 'T') and (vl_param_p <= 35) then
	ie_parametro3_w := 'S';
elsif (ie_tipo_p = 'PA') and (vl_param_p <= 90 or vl_param_p >= 220 ) then
	ie_parametro3_w := 'S';
elsif (ie_tipo_p = 'FC') and (vl_param_p <= 40 or vl_param_p >= 131) then
	ie_parametro3_w := 'S';
elsif (ie_tipo_p = 'N') and (vl_param_p in ('1','2','3')) then
	ie_parametro3_w := 'S';
elsif (nr_sequencia_p > 0) then
	select	coalesce(max('S'),'N')
	into STRICT	ie_parametro3_w
	from 	escala_news
	where	nr_sequencia = nr_sequencia_p
	and (qt_freq_resp <= 8 or qt_freq_resp >= 25
	or 		qt_saturacao_02 <= 91
	or 		qt_temp <= 35
	or 		qt_pa_sistolica <= 90 or qt_pa_sistolica >= 220
	or 		qt_freq_cardiaca <= 40 or qt_freq_cardiaca >= 131
	or		ie_nivel_consciencia in ('1','2','3'));
end if;

return ie_parametro3_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_parametro_3_news (nr_sequencia_p bigint, ie_tipo_p text default 'A', vl_param_p bigint default 0) FROM PUBLIC;

