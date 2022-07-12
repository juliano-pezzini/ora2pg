-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION des_obter_ordem_pendencia ( ie_classificacao_p text, ie_tipo_prev_p text) RETURNS bigint AS $body$
DECLARE


ie_ordem_w	smallint;


BEGIN
if (ie_classificacao_p = 'E') then
	begin
	if (ie_tipo_prev_p = 'ATR') then
		ie_ordem_w := 0;
	else
		ie_ordem_w := 1;
	end if;
	end;
elsif (ie_classificacao_p = 'D') then
	begin
	if (ie_tipo_prev_p = 'ATR') then
		ie_ordem_w := 10;
	else
		ie_ordem_w := 11;
	end if;
	end;
elsif (ie_tipo_prev_p = 'ATR') then
	ie_ordem_w	:= 20;
elsif (ie_tipo_prev_p in ('SDP','SAP','SEC')) then
	ie_ordem_w	:= 30;
else
	ie_ordem_w	:= 40;
end if;

return	ie_ordem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION des_obter_ordem_pendencia ( ie_classificacao_p text, ie_tipo_prev_p text) FROM PUBLIC;
