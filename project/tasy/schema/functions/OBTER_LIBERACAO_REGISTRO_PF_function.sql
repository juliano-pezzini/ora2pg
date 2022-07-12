-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_liberacao_registro_pf ( ie_liberacao_p text, cd_pessoa_p text, dt_liberacao_registro_p timestamp, cd_pessoa_registro_p text) RETURNS varchar AS $body$
DECLARE


ie_liberacao_w	varchar(1) := 'S';


BEGIN
if (ie_liberacao_p = 'S') then
	begin
	if (dt_liberacao_registro_p IS NOT NULL AND dt_liberacao_registro_p::text <> '') or (cd_pessoa_p = cd_pessoa_registro_p) then
		begin
		ie_liberacao_w := 'S';
		end;
	else
		begin
		ie_liberacao_w := 'N';
		end;
	end if;
	end;
end if;
return ie_liberacao_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_liberacao_registro_pf ( ie_liberacao_p text, cd_pessoa_p text, dt_liberacao_registro_p timestamp, cd_pessoa_registro_p text) FROM PUBLIC;

