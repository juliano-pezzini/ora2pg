-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ins_mat_conversao_unidade_mims ( cd_imp_material_p imp_material.cd_material%type, cd_material_p material.cd_material%type, cd_unidade_medida_p text) AS $body$
DECLARE

nr_seq_conversao_w material_conversao_unidade.cd_material%type;
cd_material_w bigint;

BEGIN

select	cd_material_tasy 
into STRICT 	cd_material_w 
from 	mims_material_tasy 
where 	cd_imp_material = cd_imp_material_p;

insert into material_conversao_unidade(cd_material, 
                cd_unidade_medida, 
                dt_atualizacao,
                dt_atualizacao_nrec,
                nm_usuario, 
                nm_usuario_nrec, 
                ie_prioridade,
                qt_conversao,
                ie_permite_prescr) 
	SELECT 	cd_material_w,
		cd_unidade_medida_p,
		dt_atualizacao, 
		dt_atualizacao_nrec, 
		nm_usuario, 
		nm_usuario_nrec, 
		ie_prioridade, 
		qt_conversao,
		ie_permite_prescr
      from   	imp_material_conv_unidade
      where  	cd_material = cd_imp_material_p
      and 	cd_unidade_medida=cd_unidade_medida_p;

      -- reset the dirty check         
      update	imp_material_conv_unidade a 
      set	a.ie_dirty_check = 0 
      where 	a.cd_material = cd_imp_material_p;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ins_mat_conversao_unidade_mims ( cd_imp_material_p imp_material.cd_material%type, cd_material_p material.cd_material%type, cd_unidade_medida_p text) FROM PUBLIC;

