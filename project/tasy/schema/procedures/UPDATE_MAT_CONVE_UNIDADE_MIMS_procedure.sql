-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_mat_conve_unidade_mims ( cd_material_p imp_material_conv_unidade.cd_material%type, cd_material_w material_conversao_unidade.cd_material%type) AS $body$
DECLARE


imp_material_w  imp_material_conv_unidade%rowtype;

c_imp_mat_con_unit_w CURSOR FOR
	SELECT *
	from   imp_material_conv_unidade a
	where  a.cd_material = cd_material_p
	and 	a.ie_dirty_check = 1;


BEGIN

/*for r_imp_mat_con_unit_w in c_imp_mat_con_unit_w loop
	if( r_imp_mat_con_unit_w.cd_material is not null ) then
		update	material_conversao_unidade a
		set		a.cd_material 			= r_imp_mat_con_unit_w.cd_material,
				a.cd_unidade_medida 	= r_imp_mat_con_unit_w.cd_unidade_medida,
				a.dt_atualizacao 		= r_imp_mat_con_unit_w.dt_atualizacao,
				a.dt_atualizacao_nrec 	= r_imp_mat_con_unit_w.dt_atualizacao_nrec,
				a.nm_usuario 			= r_imp_mat_con_unit_w.nm_usuario,
				a.nm_usuario_nrec	 	= r_imp_mat_con_unit_w.nm_usuario_nrec,
				a.ie_prioridade 		= r_imp_mat_con_unit_w.ie_prioridade,
				a.qt_conversao 			= r_imp_mat_con_unit_w.qt_conversao,
				a.ie_permite_prescr		= r_imp_mat_con_unit_w.ie_permite_prescr
		where  	a.cd_material = cd_material_w;

	end if;
end loop;*/
update	imp_material_conv_unidade a
set		a.ie_dirty_check = 0
where 	a.cd_material = cd_material_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_mat_conve_unidade_mims ( cd_material_p imp_material_conv_unidade.cd_material%type, cd_material_w material_conversao_unidade.cd_material%type) FROM PUBLIC;

