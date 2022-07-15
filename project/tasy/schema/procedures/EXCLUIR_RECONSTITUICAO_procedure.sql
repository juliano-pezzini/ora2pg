-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_reconstituicao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_mat_cpoe_w 			prescr_material.nr_seq_mat_cpoe%type;
cd_material_w 				prescr_material.cd_material%type;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	
	select 	max(nr_seq_mat_cpoe),
			max(cd_material)
	into STRICT	nr_seq_mat_cpoe_w,
			cd_material_w
	from	prescr_material
	where	nr_prescricao 			= nr_prescricao_p
	and		nr_sequencia_diluicao 	= nr_sequencia_p
	and		ie_agrupador 			= 9;
	
	if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
		begin
		
		delete	FROM prescr_material
		where	nr_prescricao 			= nr_prescricao_p 
		and		nr_sequencia_diluicao 	= nr_sequencia_p
		and		ie_agrupador 			= 9;
					
		CALL atualizar_reconstituicao( 	nr_prescricao_p,
									nr_sequencia_p,
									cd_material_w,
									wheb_usuario_pck.get_cd_perfil,
									wheb_usuario_pck.get_cd_estabelecimento,
									nm_usuario_p	);
		
		update 	cpoe_material
		set 	cd_mat_recons 			 = NULL,
				cd_unid_med_dose_recons  = NULL,
				qt_dose_recons			 = NULL,
				ds_orientacao_preparo	= substr(Obter_Diluicao_Medic(nr_sequencia_p, nr_prescricao_p),1,2000)
		where 	nr_sequencia 			= nr_seq_mat_cpoe_w;
		
		end;
	end if;	
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_reconstituicao ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text ) FROM PUBLIC;

