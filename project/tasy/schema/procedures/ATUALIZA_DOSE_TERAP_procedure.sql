-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dose_terap ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_dose_medic_p bigint, qt_dose_medic_ml_p bigint, nr_seq_medic_p bigint, qt_dose_diluente_p bigint, qt_dose_dilu_ml_p bigint, nr_seq_diluente_p bigint, ie_bomba_p text, vel_infusao_p text, qt_tempo_p text, ie_tipo_p text, qt_volume_total_p bigint, qt_corrigido_tot_p bigint, nr_unid_terap_p text, qt_dose_sol_p bigint, nm_usuario_p text) AS $body$
BEGIN




if (nr_prescricao_p	> 0) and (nr_seq_solucao_p	> 0) then

	update	prescr_solucao
    set		ie_bomba_infusao 	 = ie_bomba_p,
			qt_dosagem			 = vel_infusao_p,
			qt_tempo_aplicacao   = qt_tempo_p,
			nr_unid_terapeutica  = nr_unid_terap_p,
			qt_solucao_total 	 = qt_volume_total_p,
			qt_volume_corrigido  = qt_corrigido_tot_p,
			qt_dose_terapeutica  = qt_dose_sol_p,
			ie_tipo_dosagem 	 = ie_tipo_p
	where 	nr_prescricao  		 = nr_prescricao_p
	and		nr_seq_solucao 		 = nr_seq_solucao_p;


	if (nr_seq_medic_p > 0) then
		update	prescr_material
		set 	qt_dose 	= trunc(qt_dose_medic_p,4),
				qt_solucao  = trunc(qt_dose_medic_p,4),
				qt_volume_corrigido = trunc(qt_dose_medic_ml_p,4),
				cd_unidade_medida_dose = obter_unid_med_usua('ml')
		where 	nr_prescricao = nr_prescricao_p
		and 	nr_sequencia_solucao = nr_seq_solucao_p
		and 	nr_sequencia = nr_seq_medic_p;
	end if;

	if (nr_seq_diluente_p > 0) then
		update	prescr_material
		set 	qt_dose 	= trunc(qt_dose_diluente_p,4),
				qt_solucao  = trunc(qt_dose_diluente_p,4),
				qt_volume_corrigido = trunc(qt_dose_dilu_ml_p,4),
				cd_unidade_medida_dose = obter_unid_med_usua('ml')
		where 	nr_prescricao = nr_prescricao_p
		and 	nr_sequencia_solucao = nr_seq_solucao_p
		and 	nr_sequencia = nr_seq_diluente_p;

	end if;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dose_terap ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, qt_dose_medic_p bigint, qt_dose_medic_ml_p bigint, nr_seq_medic_p bigint, qt_dose_diluente_p bigint, qt_dose_dilu_ml_p bigint, nr_seq_diluente_p bigint, ie_bomba_p text, vel_infusao_p text, qt_tempo_p text, ie_tipo_p text, qt_volume_total_p bigint, qt_corrigido_tot_p bigint, nr_unid_terap_p text, qt_dose_sol_p bigint, nm_usuario_p text) FROM PUBLIC;

