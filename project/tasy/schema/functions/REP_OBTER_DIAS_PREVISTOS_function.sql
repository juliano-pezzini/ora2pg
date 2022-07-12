-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rep_obter_dias_previstos ( nr_atendimento_p bigint, cd_material_p text, ie_objetivo_p text, cd_topografia_cih_p bigint) RETURNS bigint AS $body$
DECLARE


--cd_diagn_doenca_w	number(10) := 0;   estava gerando erro no java
cd_diagn_doenca_w	varchar(10) := '0';
ie_controle_w		smallint := 0;
qt_dias_prev_anti_w	smallint := 0;

BEGIN

	select	coalesce(obter_cod_diagnostico_atend(nr_atendimento_p), 0)
	into STRICT	cd_diagn_doenca_w
	;

	select	max(obter_controle_medic(cd_material,wheb_usuario_pck.get_cd_estabelecimento,ie_controle_medico,null,null,null))
	into STRICT		ie_controle_w
	from		material
	where	cd_material = cd_material_p;

	select	coalesce(obter_dias_previsto(ie_objetivo_p, cd_topografia_cih_p, cd_diagn_doenca_w, cd_material_p, ie_controle_w), 0)
	into STRICT	qt_dias_prev_anti_w
	;

return	qt_dias_prev_anti_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_obter_dias_previstos ( nr_atendimento_p bigint, cd_material_p text, ie_objetivo_p text, cd_topografia_cih_p bigint) FROM PUBLIC;
