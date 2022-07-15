-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_baixa_prescr_mat_esp ( cd_tipo_baixa_p bigint, qt_baixa_especial_p bigint, nr_prescricao_p bigint, nr_seq_kit_p bigint, nr_sequencia_p bigint, qt_prescr_mat bigint, nm_usuario_p text) AS $body$
BEGIN
if (cd_tipo_baixa_p IS NOT NULL AND cd_tipo_baixa_p::text <> '') and (qt_baixa_especial_p IS NOT NULL AND qt_baixa_especial_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_kit_p IS NOT NULL AND nr_seq_kit_p::text <> '') then
	begin
	if (qt_prescr_mat > 0) then
		begin
		update 	prescr_material
		set    	dt_baixa          = clock_timestamp(),
			dt_atualizacao    = clock_timestamp(),
			nm_usuario        = nm_usuario_p,
			cd_motivo_baixa   = cd_tipo_baixa_p,
			qt_baixa_especial = qt_baixa_especial_p
		where  	nr_prescricao     = nr_prescricao_p
		and    	nr_seq_kit        = nr_seq_kit_p;
		end;
	end if;

	update 	prescr_material
	set    	dt_baixa          = clock_timestamp(),
		dt_atualizacao    = clock_timestamp(),
		nm_usuario        = nm_usuario_p,
		cd_motivo_baixa   = cd_tipo_baixa_p,
		qt_baixa_especial = qt_baixa_especial_p
	where  	nr_prescricao     = nr_prescricao_p
	and    	nr_sequencia      = nr_sequencia_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_baixa_prescr_mat_esp ( cd_tipo_baixa_p bigint, qt_baixa_especial_p bigint, nr_prescricao_p bigint, nr_seq_kit_p bigint, nr_sequencia_p bigint, qt_prescr_mat bigint, nm_usuario_p text) FROM PUBLIC;

