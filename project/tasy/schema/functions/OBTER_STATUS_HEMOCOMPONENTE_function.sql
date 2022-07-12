-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_hemocomponente (ie_status_p text) RETURNS varchar AS $body$
BEGIN

if (ie_status_p = 'R') then
	return obter_desc_expressao(331547);--'Reservado';
elsif (ie_status_p = 'T') then
	return obter_desc_expressao(306813);--'Transfundido';
elsif (ie_status_p = 'N') then
	return obter_desc_expressao(331251);--'Nao utilizado';
elsif (ie_status_p = 'D') then
	return obter_desc_expressao(311227);--'Dispensado';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_hemocomponente (ie_status_p text) FROM PUBLIC;
