-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_alerta_pac_med ( ie_tipo_alerta_p text) RETURNS varchar AS $body$
DECLARE


ds_alerta_w		varchar(255) := '';


BEGIN

if (ie_tipo_alerta_p IS NOT NULL AND ie_tipo_alerta_p::text <> '') then

	if (ie_tipo_alerta_p = 'B') then

		ds_alerta_w:= OBTER_DESC_EXPRESSAO(724698,'Burocrático');

	elsif (ie_tipo_alerta_p = 'M') then

		ds_alerta_w:= OBTER_DESC_EXPRESSAO(293090,'Médico' );

	end if;

end if;

return	ds_alerta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_alerta_pac_med ( ie_tipo_alerta_p text) FROM PUBLIC;
