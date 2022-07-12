-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_ds_vinc_benef_sib ( ie_vinculo_benef_p pls_retorno_sib.ie_vinculo_beneficiario%type) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);


BEGIN
	ds_retorno_w	:= null;

	if (ie_vinculo_benef_p = 1) then
			ds_retorno_w	:= 'Beneficiário titular (maior ou menor de idade)';
	elsif (ie_vinculo_benef_p = 3) then
			ds_retorno_w	:= 'Cônjuge/Companheiro';
	elsif (ie_vinculo_benef_p = 4) then
			ds_retorno_w 	:= 'Filho/Filha';
	elsif (ie_vinculo_benef_p = 6) then
			ds_retorno_w	:= 'Enteado/Enteada';
	elsif (ie_vinculo_benef_p = 8) then
			ds_retorno_w	:= 'Pai/Mãe';
	elsif (ie_vinculo_benef_p = 10) then
			ds_retorno_w	:= 'Agregado/Outros';
	end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_ds_vinc_benef_sib ( ie_vinculo_benef_p pls_retorno_sib.ie_vinculo_beneficiario%type) FROM PUBLIC;
