-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_obter_recon_redil_prot ( nr_seq_diluicao_p bigint, cd_protocolo_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint, cd_unidade_medida text, qt_dose_p bigint, qt_unitaria_p bigint, ie_se_necessario_p text, ie_acm_p text, qt_solucao_dil_p INOUT bigint, cd_mat_dil_p INOUT bigint, qt_dose_dil_p INOUT bigint, cd_unid_med_dose_dil_p INOUT text, qt_solucao_red_p INOUT bigint, qt_dose_red_p INOUT bigint, cd_mat_red_p INOUT bigint, cd_unid_med_dose_red_p INOUT text, cd_mat_recons_p INOUT bigint, cd_unid_med_dose_recons_p INOUT text, qt_dose_recons_p INOUT bigint, qt_minuto_aplicacao_p INOUT bigint, ds_dose_diferenciada_dil_p INOUT text, ds_dose_diferenciada_rec_p INOUT text, ds_dose_diferenciada_red_p INOUT text) AS $body$
DECLARE

						
cd_material_w						protocolo_medic_material.cd_material%type;
nr_seq_material_w					protocolo_medic_material.nr_seq_material%type;
cd_unidade_medida_w					protocolo_medic_material.cd_unidade_medida%type;
qt_dose_w							protocolo_medic_material.qt_dose%type;
ie_agrupador_w						protocolo_medic_material.ie_agrupador%type;
qt_minuto_aplicacao_w				protocolo_medic_material.qt_minuto_aplicacao%type;
qt_solucao_dil_w					cpoe_material.qt_solucao_dil%type;
cd_mat_dil_w						cpoe_material.cd_mat_dil%type;
qt_dose_dil_w						cpoe_material.qt_dose_dil%type;
cd_unid_med_dose_dil_w				cpoe_material.cd_unid_med_dose_dil%type;
qt_solucao_red_w					cpoe_material.qt_solucao_red%type;
qt_dose_red_w						cpoe_material.qt_dose_red%type;
cd_mat_red_w						cpoe_material.cd_mat_red%type;
cd_unid_med_dose_red_w				cpoe_material.cd_unid_med_dose_red%type;
cd_mat_recons_w						cpoe_material.cd_mat_recons%type;
cd_unid_med_dose_recons_w			cpoe_material.cd_unid_med_dose_recons%type;
qt_dose_recons_w					cpoe_material.qt_dose_recons%type;
qt_solucao_w						cpoe_material.qt_solucao_dil%type;
ds_dose_diferenciada_w				protocolo_medic_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_dil_w			protocolo_medic_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_red_w			protocolo_medic_material.ds_dose_diferenciada%type;
ds_dose_diferenciada_rec_w			protocolo_medic_material.ds_dose_diferenciada%type;																			
c01 CURSOR FOR
SELECT	a.cd_material,
		a.cd_unidade_medida,
		a.qt_dose,
		CASE WHEN b.ie_tipo_material=1 THEN  2  ELSE a.ie_agrupador END  ie_agrupador,
		a.qt_solucao,
		qt_minuto_aplicacao,
		a.ds_dose_diferenciada						  
from 	material b,
		protocolo_medic_material a
where	a.cd_protocolo = cd_protocolo_p
and		a.nr_sequencia = nr_sequencia_p
and		a.cd_material = b.cd_material
and		CASE WHEN b.ie_tipo_material=1 THEN  2  ELSE a.ie_agrupador END  in (3,7,9)
and		a.nr_seq_diluicao	= nr_seq_diluicao_p		
order by 
		nr_seq_material;
		

BEGIN



open c01;
loop
fetch c01 into	cd_material_w,
				cd_unidade_medida_w,
				qt_dose_w,
				ie_agrupador_w,
				qt_solucao_w,
				qt_minuto_aplicacao_w,
				ds_dose_diferenciada_w;						
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	if (ie_agrupador_w = 3) then
		qt_solucao_dil_w := qt_solucao_w;
		cd_mat_dil_w := cd_material_w;
		qt_dose_dil_w := qt_dose_w;
		cd_unid_med_dose_dil_w := cd_unidade_medida_w;
		qt_minuto_aplicacao_p := qt_minuto_aplicacao_w;		
		ds_dose_diferenciada_dil_w := ds_dose_diferenciada_w;											
	elsif (ie_agrupador_w = 7) then
		qt_solucao_red_w := qt_solucao_w;
		qt_dose_red_w := qt_dose_w;
		cd_mat_red_w := cd_material_w;
		cd_unid_med_dose_red_w := cd_unidade_medida_w;
		ds_dose_diferenciada_red_w := ds_dose_diferenciada_w;											
	elsif (ie_agrupador_w = 9) then
		cd_mat_recons_w := cd_material_w;
		cd_unid_med_dose_recons_w := cd_unidade_medida_w;
		qt_dose_recons_w := qt_dose_w;
		ds_dose_diferenciada_rec_w := ds_dose_diferenciada_w;											
	end if;
	end;
end loop;
close c01;

qt_solucao_dil_p := qt_solucao_dil_w;
cd_mat_dil_p := cd_mat_dil_w;
qt_dose_dil_p := qt_dose_dil_w;
cd_unid_med_dose_dil_p := cd_unid_med_dose_dil_w;
qt_solucao_red_p := qt_solucao_red_w;
qt_dose_red_p := qt_dose_red_w;
cd_mat_red_p := cd_mat_red_w;
cd_unid_med_dose_red_p := cd_unid_med_dose_red_w;
cd_mat_recons_p := cd_mat_recons_w;
cd_unid_med_dose_recons_p := cd_unid_med_dose_recons_w;
qt_dose_recons_p := qt_dose_recons_w;
ds_dose_diferenciada_dil_p := ds_dose_diferenciada_dil_w;
ds_dose_diferenciada_red_p := ds_dose_diferenciada_red_w;
ds_dose_diferenciada_rec_p := ds_dose_diferenciada_rec_w;													

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_obter_recon_redil_prot ( nr_seq_diluicao_p bigint, cd_protocolo_p bigint, nr_sequencia_p bigint, cd_estabelecimento_p bigint, cd_material_p bigint, cd_unidade_medida text, qt_dose_p bigint, qt_unitaria_p bigint, ie_se_necessario_p text, ie_acm_p text, qt_solucao_dil_p INOUT bigint, cd_mat_dil_p INOUT bigint, qt_dose_dil_p INOUT bigint, cd_unid_med_dose_dil_p INOUT text, qt_solucao_red_p INOUT bigint, qt_dose_red_p INOUT bigint, cd_mat_red_p INOUT bigint, cd_unid_med_dose_red_p INOUT text, cd_mat_recons_p INOUT bigint, cd_unid_med_dose_recons_p INOUT text, qt_dose_recons_p INOUT bigint, qt_minuto_aplicacao_p INOUT bigint, ds_dose_diferenciada_dil_p INOUT text, ds_dose_diferenciada_rec_p INOUT text, ds_dose_diferenciada_red_p INOUT text) FROM PUBLIC;

