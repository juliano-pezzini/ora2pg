-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_pendencia_gqa (ie_tipo_pendencia_1_p text, ie_tipo_pendencia_2_p text, ie_tipo_pendencia_3_p text, ie_tipo_pendencia_4_p text, ie_tipo_pendencia_5_p text, ie_tipo_pendencia_6_p text, ie_tipo_pendencia_7_p text, ie_tipo_pendencia_8_p text) RETURNS varchar AS $body$
DECLARE


retorno_w varchar(255);


BEGIN

if (ie_tipo_pendencia_1_p = 'S') then
	retorno_w := '1,';
end if;

if (ie_tipo_pendencia_2_p = 'S') then
	retorno_w := retorno_w || '2,';
end if;

if (ie_tipo_pendencia_3_p = 'S') then
	retorno_w := retorno_w || '3,';
end if;

if (ie_tipo_pendencia_4_p = 'S') then
	retorno_w := retorno_w || '4,';
end if;

if (ie_tipo_pendencia_5_p = 'S') then
	retorno_w := retorno_w || '5,';
end if;

if (ie_tipo_pendencia_6_p = 'S') then
	retorno_w := retorno_w || '6,';
end if;

if (ie_tipo_pendencia_7_p = 'S') then
	retorno_w := retorno_w || '7,';
end if;

if (ie_tipo_pendencia_8_p = 'S') then
	retorno_w := retorno_w || '8';
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_pendencia_gqa (ie_tipo_pendencia_1_p text, ie_tipo_pendencia_2_p text, ie_tipo_pendencia_3_p text, ie_tipo_pendencia_4_p text, ie_tipo_pendencia_5_p text, ie_tipo_pendencia_6_p text, ie_tipo_pendencia_7_p text, ie_tipo_pendencia_8_p text) FROM PUBLIC;

