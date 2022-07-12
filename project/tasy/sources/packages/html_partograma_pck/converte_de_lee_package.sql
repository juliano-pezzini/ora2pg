-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION html_partograma_pck.converte_de_lee (ie_plano_lee_p text) RETURNS varchar AS $body$
DECLARE

ie_plano_lee_w	varchar(10);

BEGIN

if (ie_plano_lee_p = '-5') then
	ie_plano_lee_w := '10';
elsif (ie_plano_lee_p = '-4') then
	ie_plano_lee_w := '9';
elsif (ie_plano_lee_p = '-3') then
	ie_plano_lee_w := '8';
elsif (ie_plano_lee_p = '-2') then
	ie_plano_lee_w := '7';
elsif (ie_plano_lee_p = '-1') then
	ie_plano_lee_w := '6';
elsif (ie_plano_lee_p = '0') then
	ie_plano_lee_w := '5';
elsif (ie_plano_lee_p = '+1') then
	ie_plano_lee_w := '4';
elsif (ie_plano_lee_p = '+2') then
	ie_plano_lee_w := '3';
elsif (ie_plano_lee_p = '+3') then
	ie_plano_lee_w := '2';
elsif (ie_plano_lee_p = '+4') then
	ie_plano_lee_w := '1';
elsif (ie_plano_lee_p = '+5') then
	ie_plano_lee_w := '0';
end if;

return ie_plano_lee_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION html_partograma_pck.converte_de_lee (ie_plano_lee_p text) FROM PUBLIC;