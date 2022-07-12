-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_receita_hc ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_w					varchar(1) := 'N';

cd_material_ambulatorial_w  hc_paciente_material.cd_material%type;
	

BEGIN

select max(cd_material)
into STRICT cd_material_ambulatorial_w
from hc_paciente_material
where (qt_material IS NOT NULL AND qt_material::text <> '')
and (cd_unidade_medida IS NOT NULL AND cd_unidade_medida::text <> '')
and (cd_intervalo IS NOT NULL AND cd_intervalo::text <> '')
and (ie_via_aplicacao IS NOT NULL AND ie_via_aplicacao::text <> '')
and nr_sequencia = nr_sequencia_p;


if (cd_material_ambulatorial_w IS NOT NULL AND cd_material_ambulatorial_w::text <> '') then 

	select coalesce(max('S'),'N')
	into STRICT ie_existe_w
	from fa_medic_farmacia_amb
	where cd_material = cd_material_ambulatorial_w
	and ie_situacao  = 'A';
	
end if;	


return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_receita_hc ( nr_sequencia_p bigint) FROM PUBLIC;

