-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regra_onc ( nr_seq_atendimento_p bigint, nm_usuario_p text, cd_material_p bigint default null, cd_unid_med_prescr_p text default null, qt_dose_prescricao_p bigint default null, ie_via_aplicacao_p text default null, ds_observacao_p text default null, nr_seq_material_p bigint default null, ie_uso_continuo_p text default null, ie_local_adm_p text default null, qt_dias_util_p bigint default null, nr_seq_interno_p bigint default null, cd_intervalo_p text default null, nr_seq_diluicao_p bigint default null, ds_dose_diferenciada_p text default null, qt_dose_p bigint default null, cd_unid_med_dose_p text default null) AS $body$
DECLARE



nr_seq_material_w		bigint;
is_paciente_medic_update_w varchar(1) := 'N';



C01 CURSOR FOR
	SELECT	nr_seq_material
	from	paciente_atend_medic
	where	nr_seq_atendimento = nr_seq_atendimento_p;


BEGIN

open C01;
loop
fetch C01 into
  nr_seq_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
  begin

  if (nr_seq_material_p = nr_seq_material_w) then
    is_paciente_medic_update_w := 'S';
  else
        is_paciente_medic_update_w := 'N';
  end if;

  CALL CONSISTIR_REGRA_ATEND_MEDIC(nr_seq_atendimento_p,
          nr_seq_material_w,
          nm_usuario_p,
          0,
          cd_material_p,
          cd_unid_med_prescr_p, 
          qt_dose_prescricao_p,
          ie_via_aplicacao_p,
          ds_observacao_p,
          is_paciente_medic_update_w,
          ie_uso_continuo_p,
          ie_local_adm_p,
          qt_dias_util_p,
          nr_seq_interno_p,
          cd_intervalo_p,
          nr_seq_diluicao_p,
          ds_dose_diferenciada_p,
          qt_dose_p,
          cd_unid_med_dose_p
          );

  end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_regra_onc ( nr_seq_atendimento_p bigint, nm_usuario_p text, cd_material_p bigint default null, cd_unid_med_prescr_p text default null, qt_dose_prescricao_p bigint default null, ie_via_aplicacao_p text default null, ds_observacao_p text default null, nr_seq_material_p bigint default null, ie_uso_continuo_p text default null, ie_local_adm_p text default null, qt_dias_util_p bigint default null, nr_seq_interno_p bigint default null, cd_intervalo_p text default null, nr_seq_diluicao_p bigint default null, ds_dose_diferenciada_p text default null, qt_dose_p bigint default null, cd_unid_med_dose_p text default null) FROM PUBLIC;
