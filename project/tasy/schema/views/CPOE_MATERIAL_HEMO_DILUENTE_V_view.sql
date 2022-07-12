-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_material_hemo_diluente_v (nr_sequencia, cd_mat_dil, cd_unid_med_dose_dil, qt_dose_dil) AS select NR_SEQUENCIA,CD_MAT_DIL,CD_UNID_MED_DOSE_DIL,QT_DOSE_DIL
	FROM ( 
 
		select	nr_sequencia nr_sequencia, 
				cd_mat_dil1 cd_mat_dil, 
				cd_unid_med_dose_dil1 cd_unid_med_dose_dil, 
				qt_dose_dil1 qt_dose_dil 
		from	CPOE_HEMOTERAPIA 
		where	cd_mat_dil1 is not null 
		
union all
 
		select	nr_sequencia nr_sequencia, 
				cd_mat_dil2 cd_mat_dil, 
				cd_unid_med_dose_dil2 cd_unid_med_dose_dil, 
				qt_dose_dil2 qt_dose_dil 
		from	CPOE_HEMOTERAPIA 
		where	cd_mat_dil2 is not null 
		
union all
 
		select	nr_sequencia nr_sequencia, 
				cd_mat_dil3 cd_mat_dil, 
				cd_unid_med_dose_dil3 cd_unid_med_dose_dil, 
				qt_dose_dil3 qt_dose_dil 
		from	CPOE_HEMOTERAPIA 
		where	cd_mat_dil3 is not null 
		
union all
 
		select	nr_sequencia nr_sequencia, 
				cd_mat_dil4 cd_mat_dil, 
				cd_unid_med_dose_dil4 cd_unid_med_dose_dil, 
				qt_dose_dil4 qt_dose_dil 
		from	CPOE_HEMOTERAPIA 
		where	cd_mat_dil4 is not null 
		
union all
 
		select	nr_sequencia nr_sequencia, 
				cd_mat_dil5 cd_mat_dil, 
				cd_unid_med_dose_dil5 cd_unid_med_dose_dil, 
				qt_dose_dil5 qt_dose_dil 
		from	CPOE_HEMOTERAPIA 
		where	cd_mat_dil5 is not null 
	) alias0order by nr_sequencia;
