-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_if_item_allowed ( cd_perfil_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE


ie_oral_diet_w		cpoe_presentation_rule.ie_oral_diet%type;
ie_enteral_diet_w	cpoe_presentation_rule.ie_enteral_diet%type;
ie_supplement_w		cpoe_presentation_rule.ie_supplement%type;
ie_fasting_w		cpoe_presentation_rule.ie_fasting%type;
ie_milk_w			cpoe_presentation_rule.ie_milk%type;
ie_parenteral_w		cpoe_presentation_rule.ie_parenteral%type;
ie_infant_parenteral_w	cpoe_presentation_rule.ie_infant_parenteral%type;
ie_medicine_w		cpoe_presentation_rule.ie_medicine%type;
ie_exam_w			cpoe_presentation_rule.ie_exam%type;
ie_gas_w			cpoe_presentation_rule.ie_gas%type;
ie_recomendation_w	cpoe_presentation_rule.ie_recomendation%type;
ie_hemotherapy_w	cpoe_presentation_rule.ie_hemotherapy%type;
ie_dialysis_w		cpoe_presentation_rule.ie_dialysis%type;
ie_material_w		cpoe_presentation_rule.ie_material%type;
nr_sequencia_w		cpoe_presentation_rule.nr_sequencia%type;
ie_anatomia_pat_w	cpoe_presentation_rule.ie_anatomia_pat%type;
ie_exibe_diluicao_w	cpoe_presentation_rule.ie_exibe_diluicao%type;
ds_retorno_w		varchar(1) := 'S';

/*	IE_TIPO_P	= Opções disponíveis
DO	=	Dieta Oral
DE	=	Dieta Enteral
DS	=	Dieta Suplementar
DJ	=	Jejum
DL	=	Leites e Fórmulas Infantis
DP	=	Dieta Parenteral
DPI	=	Dieta Parenteral Infantil
M	=	Medicamento
S	=	Solução
P	=	Procedimento
EX	=	Exame não Laboratorial
ES	=	Exame Especial
G	=	Gasoterapia
R	=	Recomendação
H	=	Hemoterapia
DI	=	Diálises
MA	=	Material
AP  =   Anatomia patológica
N	= 	Nutrição
TR	=	Terapia respiratória
*/
BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_sequencia_w
from (SELECT 	nr_sequencia
	from	cpoe_presentation_rule
	where 	coalesce(cd_perfil, coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
	and	coalesce(cd_estabelecimento, coalesce(wheb_usuario_pck.get_cd_estabelecimento,0)) = coalesce(wheb_usuario_pck.get_cd_estabelecimento,0)
	order by 	cd_perfil, cd_estabelecimento) alias8 LIMIT 1;

if (nr_sequencia_w > 0) then
	select	coalesce(ie_oral_diet,'S'),
		coalesce(ie_enteral_diet,'S'),
		coalesce(ie_supplement,'S'),
		coalesce(ie_fasting,'S'),
		coalesce(ie_milk,'S'),
		coalesce(ie_parenteral,'S'),
		coalesce(ie_infant_parenteral,'S'),
		coalesce(ie_medicine,'S'),
		coalesce(ie_exam,'S'),
		coalesce(ie_gas,'S'),
		coalesce(ie_recomendation,'S'),
		coalesce(ie_hemotherapy,'S'),
		coalesce(ie_dialysis,'S'),
		coalesce(ie_material,'S'),
		coalesce(ie_anatomia_pat,'N'),
		coalesce(ie_exibe_diluicao,'S')
	into STRICT	ie_oral_diet_w,
		ie_enteral_diet_w,
		ie_supplement_w,
		ie_fasting_w,
		ie_milk_w,
		ie_parenteral_w,
		ie_infant_parenteral_w,
		ie_medicine_w,
		ie_exam_w,
		ie_gas_w,
		ie_recomendation_w,
		ie_hemotherapy_w,
		ie_dialysis_w,
		ie_material_w,
		ie_anatomia_pat_w,
		ie_exibe_diluicao_w
	from	cpoe_presentation_rule
	where	nr_sequencia = nr_sequencia_w;

	if (ie_tipo_p = 'DO') then
		return ie_oral_diet_w;
	elsif (ie_tipo_p = 'DE') then
		return	ie_enteral_diet_w;
	elsif (ie_tipo_p = 'DS') then
		return	ie_supplement_w;
	elsif (ie_tipo_p = 'DJ') then
		return	ie_fasting_w;
	elsif (ie_tipo_p = 'DR') then
		return	ie_exibe_diluicao_w;
	elsif (ie_tipo_p = 'DL') then
		return	ie_milk_w;
	elsif (ie_tipo_p = 'DP') then
		return	ie_parenteral_w;
	elsif (ie_tipo_p = 'DPI') then
		return	ie_infant_parenteral_w;
	elsif (ie_tipo_p = 'M' or ie_tipo_p = 'S') then
		return	ie_medicine_w;
	elsif (ie_tipo_p = 'P' or ie_tipo_p = 'EX' or ie_tipo_p = 'ES' or ie_tipo_p = 'TR') then
		return	ie_exam_w;
	elsif (ie_tipo_p = 'G') then
		return	ie_gas_w;
	elsif (ie_tipo_p = 'R') then
		return	ie_recomendation_w;
	elsif (ie_tipo_p = 'H') then
		return	ie_hemotherapy_w;
	elsif (ie_tipo_p = 'DI') then
		return	ie_dialysis_w;
	elsif (ie_tipo_p = 'MA') then
		return	ie_material_w;
	elsif (ie_tipo_p = 'N') then
		if (ie_oral_diet_w = 'S'
			or ie_enteral_diet_w = 'S'
			or ie_supplement_w = 'S'
			or ie_fasting_w = 'S'
			or ie_milk_w = 'S'
			or ie_parenteral_w = 'S'
			or ie_infant_parenteral_w = 'S') then
			return 'S';
		else
			return 'N';
		end if;
	end if;
end if;
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_if_item_allowed ( cd_perfil_p bigint, ie_tipo_p text) FROM PUBLIC;

