-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_ipe_global ( cd_material_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_executor_p text) RETURNS varchar AS $body$
DECLARE

cd_material_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ie_classif_w		varchar(2);
cd_area_procedimento_w	integer;


BEGIN

cd_material_w		:= cd_material_p;
cd_procedimento_w	:= cd_procedimento_p;
ie_origem_proced_w	:= ie_origem_proced_p;

/* Para os casos que possuem código de material igual de procedimentos cadastrados (IPE) */

if (cd_material_w IS NOT NULL AND cd_material_w::text <> '')		and (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '')	then
	begin
	if (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
		cd_material_w		:= null;
	else
		cd_procedimento_w	:= null;
	end if;
	end;
end if;

if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
	select ie_tipo_material
	into STRICT ie_classif_w
	from material
	where cd_material = cd_material_w;
elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
	begin
	/* Incluído o tipo de atendimento 8 no IF abaixo OS 78744 - Hosp. Bruno Born*/

	if (ie_tipo_atendimento_p	in (1,8)) then
		begin
		select ie_classificacao
		into STRICT ie_classif_w
		from procedimento
		where cd_procedimento = cd_procedimento_w
	  	and ie_origem_proced = ie_origem_proced_w;

		if (ie_classif_w = '1') then
			ie_classif_w:= '30';
		elsif (ie_classif_w = '2') then
			ie_classif_w:= '20';
		elsif (ie_classif_w = '3') then
			ie_classif_w:= '10';
		end if;

		end;
	else
		begin
		select 	coalesce(max(cd_area_procedimento),1)
		into STRICT	cd_area_procedimento_w
		from	estrutura_procedimento_v
		where	cd_procedimento	= cd_procedimento_w
	  	and 	ie_origem_proced = ie_origem_proced_w;
		if (cd_area_procedimento_w = 1) then
			ie_classif_w	:= '1';
		elsif (cd_area_procedimento_w = 2) then
			ie_classif_w	:= '3';
		elsif (cd_area_procedimento_w = 3) then
			ie_classif_w	:= '4';
		elsif (cd_area_procedimento_w = 4) then
			begin
			ie_classif_w	:= '5';
/*
			if 	(cd_medico_executor_p is null) then
				ie_classif_w	:= '2';
			else
				ie_classif_w	:= '5';
			end if; */
			end;
		else	ie_classif_w	:= '5';
		end if;
		end;
	end if;
	end;


end if;

return ie_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_ipe_global ( cd_material_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_atendimento_p bigint, cd_medico_executor_p text) FROM PUBLIC;
