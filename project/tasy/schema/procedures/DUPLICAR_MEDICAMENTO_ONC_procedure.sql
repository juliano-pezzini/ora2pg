-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_medicamento_onc ( nr_seq_paciente_p bigint, nr_seq_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_agrupamento_w	integer;
nr_seq_material_dilu_w  integer;
nr_seq_material_w	integer;

C01 CURSOR FOR
	SELECT	cd_material,
		ie_via_aplicacao,
		cd_unidade_medida,
		qt_dose,
		ie_se_necessario,
		cd_intervalo,
		qt_dias_util,
		cd_unid_med_prescr,
		qt_dose_prescr,
		ds_dias_aplicacao,
		ie_urgencia,
		ie_aplic_lenta,
		ie_aplic_bolus,
		qt_hora_aplicacao,
		qt_min_aplicacao,
		ie_pre_medicacao,
		ie_bomba_infusao,
		ie_tipo_dosagem,
		qt_dosagem,
		ds_ciclos_aplicacao,
		ie_gerar_solucao,
		ds_recomendacao,
		ds_observacao,
		ie_aplica_reducao
	from	paciente_protocolo_medic
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_seq_material = nr_seq_material_p;

C02 CURSOR FOR
	SELECT	cd_material,
		cd_unidade_medida,
		qt_dose,
		ds_dias_aplicacao
	from	paciente_protocolo_medic
	where	nr_seq_paciente = nr_seq_paciente_p
	and	nr_seq_diluicao = nr_seq_material_p;

c01_w	c01%rowtype;
c02_w	c02%rowtype;


BEGIN

if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select (max(nr_agrupamento) + 1)
		into STRICT	nr_agrupamento_w
		from	paciente_protocolo_medic
		where	nr_seq_paciente = nr_seq_paciente_p;

		select (max(nr_Seq_material) + 1)
		into STRICT	nr_seq_material_w
		from	paciente_protocolo_medic
		where	nr_seq_paciente = nr_seq_paciente_p;

			insert into paciente_protocolo_medic(	cd_material,
								ie_via_aplicacao,
								cd_unidade_medida,
								qt_dose,
								ie_se_necessario,
								cd_intervalo,
								qt_dias_util,
								cd_unid_med_prescr,
								qt_dose_prescr,
								ds_dias_aplicacao,
								ie_urgencia,
								ie_aplic_lenta,
								ie_aplic_bolus,
								qt_hora_aplicacao,
								qt_min_aplicacao,
								ie_pre_medicacao,
								ie_bomba_infusao,
								ie_tipo_dosagem,
								qt_dosagem,
								ds_ciclos_aplicacao,
								ie_gerar_solucao,
								ds_recomendacao,
								ds_observacao,
								ie_aplica_reducao,
								nm_usuario,
								nr_seq_interno,
								nr_seq_paciente,
								nr_agrupamento,
								dt_atualizacao,
								nr_seq_material)
							values (	c01_w.cd_material,
								c01_w.ie_via_aplicacao,
								c01_w.cd_unidade_medida,
								c01_w.qt_dose,
								c01_w.ie_se_necessario,
								c01_w.cd_intervalo,
								c01_w.qt_dias_util,
								c01_w.cd_unid_med_prescr,
								c01_w.qt_dose_prescr,
								c01_w.ds_dias_aplicacao,
								c01_w.ie_urgencia,
								c01_w.ie_aplic_lenta,
								c01_w.ie_aplic_bolus,
								c01_w.qt_hora_aplicacao,
								c01_w.qt_min_aplicacao,
								c01_w.ie_pre_medicacao,
								c01_w.ie_bomba_infusao,
								c01_w.ie_tipo_dosagem,
								c01_w.qt_dosagem,
								c01_w.ds_ciclos_aplicacao,
								c01_w.ie_gerar_solucao,
								c01_w.ds_recomendacao,
								c01_w.ds_observacao,
								c01_w.ie_aplica_reducao,
								nm_usuario_p,
								nextval('paciente_protocolo_medic_seq'),
								nr_seq_paciente_p,
								nr_agrupamento_w,
								clock_timestamp(),
								nr_seq_material_w
								);
	commit;

	open C02;
	loop
	fetch C02 into
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select (max(nr_agrupamento) + 1)
		into STRICT	nr_agrupamento_w
		from	paciente_protocolo_medic
		where	nr_seq_paciente = nr_seq_paciente_p;

		select (max(nr_Seq_material) + 1)
		into STRICT	nr_seq_material_dilu_w
		from	paciente_protocolo_medic
		where	nr_seq_paciente = nr_seq_paciente_p;

		insert into paciente_protocolo_medic(	nr_seq_paciente,
							nr_seq_diluicao,
							nr_seq_interno,
							cd_material,
							cd_unidade_medida,
							qt_dose,
							ds_dias_aplicacao,
							nr_seq_material,
							nr_agrupamento,
							nm_usuario,
							dt_atualizacao,
							ie_bomba_infusao
							)
						values (	nr_seq_paciente_p,
							nr_seq_material_w,
							nextval('paciente_protocolo_medic_seq'),
							c02_w.cd_material,
							c02_w.cd_unidade_medida,
							c02_w.qt_dose,
							c02_w.ds_dias_aplicacao,
							nr_seq_material_dilu_w,
							nr_agrupamento_w,
							nm_usuario_p,
							clock_timestamp(),
							'N'
							);

		end;
	end loop;
	close C02;
		end;
	end loop;
	close C01;



end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_medicamento_onc ( nr_seq_paciente_p bigint, nr_seq_material_p bigint, nm_usuario_p text) FROM PUBLIC;
