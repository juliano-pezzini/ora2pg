-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_profissional_usuario (nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


ie_profissional_w  varchar(15);
ie_dominio_profissional_w bigint;


BEGIN

select max(ie_profissional)
into STRICT ie_profissional_w
from usuario
where nm_usuario  = nm_usuario_p;

	if (ie_profissional_w = 'M') or (obter_se_usuario_medico(nm_usuario_p) = 'S') then
		ie_dominio_profissional_w := 1;
	elsif (coalesce(ie_profissional_w::text, '') = '') then
		ie_dominio_profissional_w := null;
	elsif (ie_profissional_w = 'F') then
		ie_dominio_profissional_w := 8;
	elsif (ie_profissional_w = 'FI') then
		ie_dominio_profissional_w := 10;
	elsif (ie_profissional_w = 'N') then
		ie_dominio_profissional_w := 4;
	elsif (ie_profissional_w = 'E') then	
		ie_dominio_profissional_w := 3;
	elsif (ie_profissional_w = 'O') then	
		ie_dominio_profissional_w := 12;
	elsif (ie_profissional_w = 'TE') then
		ie_dominio_profissional_w := 13;
	else
		ie_dominio_profissional_w := 0;
	end if;
	
return ie_dominio_profissional_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_profissional_usuario (nm_usuario_p text) FROM PUBLIC;

