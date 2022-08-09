-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE substituir_componente_kit ( cd_kit_material_p bigint, cd_material_p bigint, cd_material_novo_p bigint, ie_todos_p text, ie_restringe_tipo_p text, ie_deleta_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE



nr_sequencia_w		integer;
nr_sequencia_ww		integer;
cd_kit_material_w		integer;
ie_via_aplicacao_w		varchar(5);
ie_tipo_paciente_w		varchar(3);
qt_material_w		double precision;
qt_volume_min_w		real;
qt_volume_max_w		real;
ie_baixa_estoque_w	varchar(1);
cd_medico_w		varchar(10);
cd_convenio_w		integer;
ie_tipo_convenio_w	smallint;
ie_dispensavel_w		varchar(1);
ie_video_w		varchar(1);
cd_fornecedor_w		varchar(14);
qt_idade_minima_w		smallint;
qt_idade_maxima_w	smallint;
ie_calcula_preco_w		varchar(1);
ie_entra_conta_w		varchar(1);
cd_intervalo_w		varchar(7);
ie_duplica_prescr_w	varchar(1);
ie_multiplica_dose_w	varchar(1);
ie_duplica_req_w	varchar(1);
qt_material_existe_w	bigint;
qt_material_existe_novo_w	bigint;
qt_material_ativo_w		bigint;
cd_estabelecimento_w	smallint;
ie_restringe_estab_w	varchar(1);
ie_tipo_w		varchar(1);

C01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_kit_material,
	a.ie_via_aplicacao,
	a.ie_tipo_paciente,
	a.qt_material,
	a.qt_volume_min,
	a.qt_volume_max,
	a.ie_baixa_estoque,
	a.cd_medico,
	a.cd_convenio,
	a.ie_tipo_convenio,
	a.ie_dispensavel,
	a.ie_video,
	a.cd_fornecedor,
	a.qt_idade_minima,
	a.qt_idade_maxima,
	a.ie_calcula_preco,
	a.ie_entra_conta,
	a.cd_intervalo,
	a.ie_duplica_prescr,
	a.ie_multiplica_dose,
	a.ie_duplica_req
from	componente_kit a
where	a.cd_material = cd_material_p
and	a.ie_situacao = 'A'
and (ie_restringe_estab_w <> 'E' or (select coalesce(cd_estab_exclusivo,cd_estabelecimento_p) from kit_material where cd_kit_material = a.cd_kit_material) = cd_estabelecimento_p)
and (ie_restringe_tipo_p <> 'S' or (select coalesce(ie_tipo,'0') from kit_material where cd_kit_material = a.cd_kit_material) = ie_tipo_w)
and	((coalesce(a.cd_estab_regra::text, '') = '') or (a.cd_estab_regra = cd_estabelecimento_w))
and	((ie_todos_p = 'S') or
	(a.cd_kit_material = cd_kit_material_p AND ie_todos_p = 'N'));


BEGIN

ie_restringe_estab_w := Obter_Param_Usuario(143, 281, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_restringe_estab_w);

select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

select	count(*)
into STRICT	qt_material_ativo_w
from	componente_kit
where	cd_kit_material	= cd_kit_material_p
and	cd_material	= cd_material_p
and	ie_situacao	= 'A';

select	count(*)
into STRICT	qt_material_existe_w
from	material
where	cd_material = cd_material_p;

select	coalesce(max(ie_tipo),'0')
into STRICT	ie_tipo_w
from	kit_material
where	cd_kit_material = cd_kit_material_p;

if (qt_material_existe_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(194101,	'CD_MATERIAL='||cd_material_p);
end if;

if (cd_material_novo_p > 0) then

	select	count(*)
	into STRICT	qt_material_existe_novo_w
	from	material
	where	cd_material = cd_material_novo_p;

	if (qt_material_existe_novo_w = 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(194101,	'CD_MATERIAL='||cd_material_novo_p);
	end if;
end if;

open C01;
loop
fetch C01 into
	nr_sequencia_ww,
	cd_kit_material_w,
	ie_via_aplicacao_w,
	ie_tipo_paciente_w,
	qt_material_w,
	qt_volume_min_w,
	qt_volume_max_w,
	ie_baixa_estoque_w,
	cd_medico_w,
	cd_convenio_w,
	ie_tipo_convenio_w,
	ie_dispensavel_w,
	ie_video_w,
	cd_fornecedor_w,
	qt_idade_minima_w,
	qt_idade_maxima_w,
	ie_calcula_preco_w,
	ie_entra_conta_w,
	cd_intervalo_w,
	ie_duplica_prescr_w,
	ie_multiplica_dose_w,
	ie_duplica_req_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (cd_material_novo_p > 0) then
		select	coalesce(max(nr_sequencia), 0) + 1
		into STRICT	nr_sequencia_w
		from	componente_kit
		where	cd_kit_material = cd_kit_material_w;

		insert into componente_kit(
			cd_kit_material,
			nr_sequencia,
			cd_material,
			ie_via_aplicacao,
			ie_tipo_paciente,
			qt_material,
			ie_situacao,
			dt_atualizacao,
			nm_usuario,
			qt_volume_min,
			qt_volume_max,
			ie_baixa_estoque,
			cd_medico,
			cd_convenio,
			ie_tipo_convenio,
			ie_dispensavel,
			ie_video,
			cd_fornecedor,
			qt_idade_minima,
			qt_idade_maxima,
			ie_calcula_preco,
			ie_entra_conta,
			cd_intervalo,
			ie_duplica_prescr,
			ie_multiplica_dose,
			ie_duplica_req,
			cd_material_original)
		values (	cd_kit_material_w,
			nr_sequencia_w,
			cd_material_novo_p,
			ie_via_aplicacao_w,
			ie_tipo_paciente_w,
			qt_material_w,
			'A',
			clock_timestamp(),
			nm_usuario_p,
			qt_volume_min_w,
			qt_volume_max_w,
			ie_baixa_estoque_w,
			cd_medico_w,
			cd_convenio_w,
			ie_tipo_convenio_w,
			ie_dispensavel_w,
			ie_video_w,
			cd_fornecedor_w,
			qt_idade_minima_w,
			qt_idade_maxima_w,
			ie_calcula_preco_w,
			ie_entra_conta_w,
			cd_intervalo_w,
			ie_duplica_prescr_w,
			ie_multiplica_dose_w,
			ie_duplica_req_w,
			cd_material_p);
	end if;

	if (ie_deleta_item_p = '0') then
		update	componente_kit
		set	ie_situacao = 'I'
		where	cd_kit_material = cd_kit_material_w
		and	nr_sequencia = nr_sequencia_ww;
	elsif (ie_deleta_item_p = '1') then
		delete from componente_kit
		where	cd_kit_material = cd_kit_material_w
		and	nr_sequencia = nr_sequencia_ww;
	end if;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE substituir_componente_kit ( cd_kit_material_p bigint, cd_material_p bigint, cd_material_novo_p bigint, ie_todos_p text, ie_restringe_tipo_p text, ie_deleta_item_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
