-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ponto_abemid (nm_atributo_p text) RETURNS bigint AS $body$
DECLARE


nr_pontos_w	bigint := 0;


BEGIN
nr_pontos_w := 0;
if (nm_atributo_p = 'IE_DR_DEPENDENTE') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_DR_INDEPENDENTE') then
	nr_pontos_w := 0;
elsif (nm_atributo_p = 'IE_GA_DEPEN_TOTAL') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_GA_INDEPENDENTE') then
	nr_pontos_w := 0;
elsif (nm_atributo_p = 'IE_GA_SEMI_INDEPEN') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_LV_ULCERA_GRAUI') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_LV_ULCERA_GRAUII') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_LV_ULCERA_GRAUIII') then
	nr_pontos_w := 4;
elsif (nm_atributo_p = 'IE_LV_ULCERA_GRAUIV') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_QU_INTRA_TECAL') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_QU_INTRA_VENOSA') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_QU_ORAL') then
	nr_pontos_w := 1;
elsif (nm_atributo_p = 'IE_QU_SUBCUTANEA') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_SP_ACES_VENESO_PERI') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_SP_ACES_VENOSO_CONT') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_SP_ACES_VENOSO_INTER') then
	nr_pontos_w := 4;
elsif (nm_atributo_p = 'IE_SP_ASP_AEREA_SUP') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_SP_DIALISE_DOMI') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_SP_SONDA_INTER') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_SP_SONDA_PERM') then
	nr_pontos_w := 1;
elsif (nm_atributo_p = 'IE_SP_TRAQUE_COM_ASP') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_SP_TRAQUE_SEM_ASP') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_SV_O2_CONT') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_SV_O2_INTER') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_SV_VENTI_CONTI') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_SV_VENTI_INTER') then
	nr_pontos_w := 4;
elsif (nm_atributo_p = 'IE_TN_GASTRONOMIA') then
	nr_pontos_w := 2;
elsif (nm_atributo_p = 'IE_TN_JEJUNO') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_TN_NUTRICAO') then
	nr_pontos_w := 5;
elsif (nm_atributo_p = 'IE_TN_SNE') then
	nr_pontos_w := 3;
elsif (nm_atributo_p = 'IE_TN_SUPLE_ORAL') then
	nr_pontos_w := 1;
end if;


return	nr_pontos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ponto_abemid (nm_atributo_p text) FROM PUBLIC;

