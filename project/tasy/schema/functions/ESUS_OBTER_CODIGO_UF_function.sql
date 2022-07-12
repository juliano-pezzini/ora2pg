-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION esus_obter_codigo_uf (sg_estado_p text) RETURNS varchar AS $body$
DECLARE


cd_estado_w		varchar(2);

/*
01	AC	Acre
02	AL	Alagoas
03	AP	Amapa
04	AM	Amazonas
05	BA	Bahia
06	CE	Ceara
07	DF	Distrito Federal
08	ES	Espirito Santo
10	GO	Goias
11	MA	Maranhão
12	MT	Mato Grosso
13	MS	Mato Grosso do Sul
14	MG	Minas Gerais
15	PA	Para
16	PB	Paraiba
17	PR	Parana
18	PE	Pernambuco
19	PI	Piaui
20	RJ	Rio de Janeiro
21	RN	Rio Grande do Norte
22	RS	Rio Grande do Sul
23	RO	Rondônia
09	RR	Roraima
25	SC	Santa Catarina
26	SP	Sao Paulo
27	SE	Sergipe
24	TO	Tocantins
*/
BEGIN

if (sg_estado_p = 'AC') then
	cd_estado_w := '01';
elsif (sg_estado_p = 'AL') then
	cd_estado_w := '02';
elsif (sg_estado_p = 'AP') then
	cd_estado_w := '03';
elsif (sg_estado_p = 'AM') then
	cd_estado_w := '04';
elsif (sg_estado_p = 'BA') then
	cd_estado_w := '05';
elsif (sg_estado_p = 'CE') then
	cd_estado_w := '06';
elsif (sg_estado_p = 'DF') then
	cd_estado_w := '07';
elsif (sg_estado_p = 'ES') then
	cd_estado_w := '08';
elsif (sg_estado_p = 'GO') then
	cd_estado_w := '10';
elsif (sg_estado_p = 'MA') then
	cd_estado_w := '11';
elsif (sg_estado_p = 'MT') then
	cd_estado_w := '12';
elsif (sg_estado_p = 'MS') then
	cd_estado_w := '13';
elsif (sg_estado_p = 'MG') then
	cd_estado_w := '14';
elsif (sg_estado_p = 'PA') then
	cd_estado_w := '15';
elsif (sg_estado_p = 'PB') then
	cd_estado_w := '16';
elsif (sg_estado_p = 'PR') then
	cd_estado_w := '17';
elsif (sg_estado_p = 'PE') then
	cd_estado_w := '18';
elsif (sg_estado_p = 'PI') then
	cd_estado_w := '19';
elsif (sg_estado_p = 'RJ') then
	cd_estado_w := '20';
elsif (sg_estado_p = 'RN') then
	cd_estado_w := '21';
elsif (sg_estado_p = 'RS') then
	cd_estado_w := '22';
elsif (sg_estado_p = 'RO') then
	cd_estado_w := '23';
elsif (sg_estado_p = 'RR') then
	cd_estado_w := '09';
elsif (sg_estado_p = 'SC') then
	cd_estado_w := '25';
elsif (sg_estado_p = 'SP') then
	cd_estado_w := '26';
elsif (sg_estado_p = 'SE') then
	cd_estado_w := '27';
elsif (sg_estado_p = 'TO') then
	cd_estado_w := '24';
end if;

return	cd_estado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION esus_obter_codigo_uf (sg_estado_p text) FROM PUBLIC;
