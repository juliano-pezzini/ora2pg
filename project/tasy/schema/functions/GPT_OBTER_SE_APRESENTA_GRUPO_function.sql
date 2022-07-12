-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_apresenta_grupo ( cd_perfil_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_oral_diet_w						gpt_presentation_rule.ie_oral_diet%type;
ie_enteral_diet_w					gpt_presentation_rule.ie_enteral_diet%type;
ie_supplement_w						gpt_presentation_rule.ie_supplement%type;
ie_fasting_w						gpt_presentation_rule.ie_fasting%type;
ie_milk_w						gpt_presentation_rule.ie_milk%type;
ie_medicine_w						gpt_presentation_rule.ie_medicine%type;
ie_exam_w						gpt_presentation_rule.ie_exam%type;
ie_gas_w						gpt_presentation_rule.ie_gas%type;
ie_recomendation_w					gpt_presentation_rule.ie_recomendation%type;
ie_hemotherapy_w					gpt_presentation_rule.ie_hemotherapy%type;
ie_dialysis_w						gpt_presentation_rule.ie_dialysis%type;
ie_intervention_w					gpt_presentation_rule.ie_intervention%type;
ie_material_w						gpt_presentation_rule.ie_material%type;
ie_parenteral_w						gpt_presentation_rule.ie_parenteral%type;
ie_infant_parenteral_w				        gpt_presentation_rule.ie_infant_parenteral%type;
ie_anatomia_pat_w					gpt_presentation_rule.ie_anatomia_pat%type;


BEGIN

select	coalesce(max(ie_oral_diet),'S'),
		coalesce(max(ie_enteral_diet),'S'),
		coalesce(max(ie_supplement),'S'),
		coalesce(max(ie_fasting),'S'),
		coalesce(max(ie_milk),'S'),
		coalesce(max(ie_medicine),'S'),
		coalesce(max(ie_exam),'S'),
		coalesce(max(ie_gas),'S'),
		coalesce(max(ie_recomendation),'S'),
		coalesce(max(ie_hemotherapy),'S'),
		coalesce(max(ie_dialysis),'S'),
		coalesce(max(ie_intervention),'S'),
		coalesce(max(ie_material),'S'),
		coalesce(max(ie_parenteral),'S'),
		coalesce(max(ie_infant_parenteral),'S'),
		coalesce(max(ie_anatomia_pat),'S')
into STRICT	ie_oral_diet_w,
		ie_enteral_diet_w,
		ie_supplement_w,
		ie_fasting_w,
		ie_milk_w,
		ie_medicine_w,
		ie_exam_w,
		ie_gas_w,
		ie_recomendation_w,
		ie_hemotherapy_w,
		ie_dialysis_w,
		ie_intervention_w,
		ie_material_w,
		ie_parenteral_w,
		ie_infant_parenteral_w,
		ie_anatomia_pat_w
from 	gpt_presentation_rule
where 	cd_perfil = cd_perfil_p;

if (ie_opcao_p = 'D') then
	return ie_oral_diet_w;
elsif (ie_opcao_p = 'SNE') then
	return ie_enteral_diet_w;
elsif (ie_opcao_p = 'S') then
	return ie_supplement_w;
elsif (ie_opcao_p = 'J') then
	return ie_fasting_w;
elsif (ie_opcao_p = 'LD') then
	return ie_milk_w;
elsif (ie_opcao_p = 'M') then
	return ie_medicine_w;
elsif (ie_opcao_p = 'P') then
	return ie_exam_w;
elsif (ie_opcao_p = 'G') then
	return ie_gas_w;
elsif (ie_opcao_p = 'R') then
	return ie_recomendation_w;
elsif (ie_opcao_p = 'H') then
	return ie_hemotherapy_w;
elsif (ie_opcao_p = 'DIA') then
	return ie_dialysis_w;
elsif (ie_opcao_p = 'I') then
	return ie_intervention_w;
elsif (ie_opcao_p = 'MA') then
	return ie_material_w;
elsif (ie_opcao_p = 'NPTA') then
	return ie_parenteral_w;
elsif (ie_opcao_p = 'NI') then
	return ie_infant_parenteral_w;
elsif (ie_opcao_p = 'AP') then
	return ie_anatomia_pat_w;
else
	return 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_apresenta_grupo ( cd_perfil_p bigint, ie_opcao_p text) FROM PUBLIC;
