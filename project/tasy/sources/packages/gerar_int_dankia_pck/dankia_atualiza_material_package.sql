-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_int_dankia_pck.dankia_atualiza_material ( cd_material_p bigint, cd_material_generico_p bigint, cd_unidade_medida_p text, ie_tipo_material_p text, ie_situacao_p text, ds_material_P text, nm_usuario_p text) AS $body$
BEGIN
	if (get_ie_int_dankia = 'S') then
		
		select	count(1)
		into STRICT	current_setting('gerar_int_dankia_pck.qt_existe_w')::bigint
		from	padrao_estoque_local a
		where	a.cd_material = cd_material_p
		and 	exists (SELECT 	1
						from 	local_estoque l
						where 	a.cd_local_estoque  = l.cd_local_estoque
						and 	l.ie_tipo_local = '11')
		and 	exists (select	1
						from 	dankia_disp_material d
						where 	d.cd_material = cd_material_p
						and 	d.ie_operacao <> 'E');
		
		if (current_setting('gerar_int_dankia_pck.qt_existe_w')::bigint > 0) then
			
			insert into gerar_int_dankia_pck.dankia_disp_material(
					nr_sequencia,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_lido_dankia,
					cd_material,
					cd_material_generico,
					ie_situacao,
					ds_material,
					ds_unidade_medida,
					cd_unidade_medida,
					ie_tipo_material,
					ie_operacao,
					ie_processado,
					ie_controlado,
					ds_processado_observacao,
					ds_stack)
			values (	nextval('dankia_disp_material_seq'),
					wheb_usuario_pck.get_cd_estabelecimento,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					null,
					cd_material_p,
					coalesce(cd_material_generico_p,cd_material_p),
					ie_situacao_p,
					substr(ds_material_P,1,255),
					substr(obter_desc_unidade_medida(cd_unidade_medida_p),1,40),
					cd_unidade_medida_p,
					ie_tipo_material_p,
					'A',
					'N',
					substr(obter_se_medic_controlado(cd_material_p),1,1),
					null,
					substr(dbms_utility.format_call_stack,1,2000));
			
		end if;
	end if;
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_dankia_pck.dankia_atualiza_material ( cd_material_p bigint, cd_material_generico_p bigint, cd_unidade_medida_p text, ie_tipo_material_p text, ie_situacao_p text, ds_material_P text, nm_usuario_p text) FROM PUBLIC;
