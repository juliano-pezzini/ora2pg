-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION adep_obter_status_hemocomp (ie_status_p text) RETURNS varchar AS $body$
BEGIN

if (ie_status_p = 'R') then
	return obter_desc_expressao(331530); --Reiniciada
elsif (ie_status_p = 'T') then
	return obter_desc_expressao(331691); --Terminada
elsif (ie_status_p = 'N') then
	return obter_desc_expressao(331251);-- Não utilizado
elsif (ie_status_p = 'INT') then
	return obter_desc_expressao(331051);--Interrompido
elsif (ie_status_p = 'I') then
	return obter_desc_expressao(321253);--iniciada
else return obter_desc_expressao(331251);-- Não utilizado
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_obter_status_hemocomp (ie_status_p text) FROM PUBLIC;

