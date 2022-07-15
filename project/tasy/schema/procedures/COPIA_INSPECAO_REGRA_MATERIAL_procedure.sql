-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_inspecao_regra_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into inspecao_regra_material(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	cd_material,
	ie_validade,
	qt_dias_validade,
	ie_temperatura,
	qt_temperatura_min,
	qt_temperatura_max,
	ie_abrigo_luz,
	ie_aspecto,
	qt_temp_min_transp,
	qt_temp_max_transp)
SELECT	nextval('inspecao_regra_material_seq'),
	cd_estabelecimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	cd_material_novo_p,
	ie_validade,
	qt_dias_validade,
	ie_temperatura,
	qt_temperatura_min,
	qt_temperatura_max,
	ie_abrigo_luz,
	ie_aspecto,
	qt_temp_min_transp,
	qt_temp_max_transp
from	inspecao_regra_material
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_inspecao_regra_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

