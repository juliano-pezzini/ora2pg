-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_nivel_atencao_dest (ie_nivel_atencao_p text) RETURNS varchar AS $body$
BEGIN
	if (ie_nivel_atencao_p IS NOT NULL AND ie_nivel_atencao_p::text <> '') then

		case ie_nivel_atencao_p
			when 'P' then
				return substr(obter_desc_expressao(767118),0,255); --Atenção primária
			when 'S' then
				return substr(obter_desc_expressao(495227),0,255); --Consultório
			when 'T' then
				return substr(obter_desc_expressao(792007),0,255); --Hospital, clínica e ambulatório
			when 'E' then
				return substr(obter_desc_expressao(298549),0,255); --Sistema externo
			else
				return '';
		end case;

	end if;

  return '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_nivel_atencao_dest (ie_nivel_atencao_p text) FROM PUBLIC;

