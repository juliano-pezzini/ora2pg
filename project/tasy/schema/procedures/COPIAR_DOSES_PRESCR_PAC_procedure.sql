-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_doses_prescr_pac ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_atend_anterior_w		bigint;
qt_dose_prescricao_w		double precision;
cd_unid_med_prescr_w		varchar(30);
cd_material_w			bigint;
nr_seq_material_w		bigint;
ds_observacao_w			varchar(255);

C01 CURSOR FOR
	SELECT	nr_seq_atendimento
	from	paciente_atendimento
	where	nr_seq_paciente	 = nr_seq_paciente_p
	and	(nr_prescricao IS NOT NULL AND nr_prescricao::text <> '')
	order by nr_prescricao;


c02 CURSOR FOR
	SELECT	cd_material,
		cd_unid_med_prescr,
		qt_dose_prescricao,
		nr_seq_material,
		ds_observacao
	from	paciente_atend_medic
	where	nr_seq_atendimento	= nr_seq_atend_anterior_w;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_atend_anterior_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (nr_seq_atend_anterior_w IS NOT NULL AND nr_seq_atend_anterior_w::text <> '') then
	open C02;
	loop
	fetch C02 into
		cd_material_w,
		cd_unid_med_prescr_w,
		qt_dose_prescricao_w,
		nr_seq_material_w,
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		update	paciente_atend_medic
		set	qt_dose_prescricao	= qt_dose_prescricao_w,
			cd_unid_med_prescr	= cd_unid_med_prescr_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp(),
			ds_observacao		= ds_observacao_w
		where	nr_seq_atendimento	= nr_seq_atendimento_p
		and	nr_seq_material		= nr_seq_material_w
		and	cd_material		= cd_material_w;

		end;
	end loop;
	close C02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_doses_prescr_pac ( nr_seq_atendimento_p bigint, nr_seq_paciente_p bigint, nm_usuario_p text) FROM PUBLIC;

