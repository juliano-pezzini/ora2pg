-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_item_cobertura ( ie_item_p text) RETURNS varchar AS $body$
DECLARE


ds_item_cobertura_w	varchar(255);


BEGIN

if (ie_item_p = '001') then
	ds_item_cobertura_w := 'Consultas médicas';
elsif (ie_item_p = '002') then
	ds_item_cobertura_w := 'Exames complementares';
elsif (ie_item_p = '003') then
	ds_item_cobertura_w := 'Terapias';
elsif (ie_item_p = '004') then
	ds_item_cobertura_w := 'Outros atendimentos ambulatoriais';
elsif (ie_item_p = '005') then
	ds_item_cobertura_w := 'Internações';
elsif (ie_item_p = '006') then
	ds_item_cobertura_w := 'Consultas odontológicos iniciais';
elsif (ie_item_p = '007') then
	ds_item_cobertura_w := 'Exames odontológicos complementares';
elsif (ie_item_p = '008') then
	ds_item_cobertura_w := 'Procedimentos odontológicos preventivos';
elsif (ie_item_p = '009') then
	ds_item_cobertura_w := 'Procedimentos de periodontia';
elsif (ie_item_p = '010') then
	ds_item_cobertura_w := 'Procedimentos de dentistica';
elsif (ie_item_p = '011') then
	ds_item_cobertura_w := 'Procedimentos de cirurgia odontológica ambulatorial';
elsif (ie_item_p = '012') then
	ds_item_cobertura_w := 'Exodontias';
elsif (ie_item_p = '013') then
	ds_item_cobertura_w := 'Procedimentos de endodontia';
elsif (ie_item_p = '014') then
	ds_item_cobertura_w := 'Outros procedimentos odontológicos';
elsif (ie_item_p = '015') then
	ds_item_cobertura_w := 'Demais despesas assistenciais';
else
	ds_item_cobertura_w := 'Outros';
end if;

return	ds_item_cobertura_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_item_cobertura ( ie_item_p text) FROM PUBLIC;

