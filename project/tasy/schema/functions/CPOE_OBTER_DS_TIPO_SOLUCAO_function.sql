-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_ds_tipo_solucao (ie_tipo_solucao_p text) RETURNS varchar AS $body$
DECLARE


ds_tipo_solucao_w		varchar(255);


BEGIN

if (ie_tipo_solucao_p	= 'C') then
	ds_tipo_solucao_w	:= substr(obter_desc_expressao(608174),1,254);
elsif (ie_tipo_solucao_p	= 'I') then
	ds_tipo_solucao_w	:= substr(obter_desc_expressao(292175),1,254);
elsif (ie_tipo_solucao_p	= 'V') then
	ds_tipo_solucao_w	:= substr(obter_desc_expressao(342109),1,254);
elsif (ie_tipo_solucao_p	= 'P') then
	ds_tipo_solucao_w	:= substr(obter_desc_expressao(295360),1,254);
end if;

return	ds_tipo_solucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_ds_tipo_solucao (ie_tipo_solucao_p text) FROM PUBLIC;
