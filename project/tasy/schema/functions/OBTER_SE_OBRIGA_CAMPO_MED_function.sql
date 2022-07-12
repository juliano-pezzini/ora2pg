-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_campo_med ( nr_prescricao_p bigint, cd_material_p bigint, cd_perfil_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
D=Dias previstos para utilização
*/
ie_obrigar_w			varchar(1) := 'N';
cd_convenio_w			integer;


BEGIN

select	max(obter_convenio_atendimento(nr_atendimento))
into STRICT	cd_convenio_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

select	CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_obrigar_w
from	regra_obriga_campo_med
where	coalesce(cd_perfil,cd_perfil_p)		= cd_perfil_p
and		coalesce(cd_convenio,cd_convenio_w)	= cd_convenio_w
and		coalesce(cd_material,cd_material_p)	= cd_material_p
and		ie_campo						= ie_opcao_p;

return	ie_obrigar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_campo_med ( nr_prescricao_p bigint, cd_material_p bigint, cd_perfil_p bigint, ie_opcao_p text) FROM PUBLIC;
