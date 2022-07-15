-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_liberacao_med_naopadrao ( qt_dias_tratamento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_prescricao_p timestamp, qt_dose_diaria_p bigint, nm_usuario_p text, ds_justificativa_p text, nr_prescricao_p bigint, nr_seq_material_p bigint, ie_urgente_p text DEFAULT 'N', cd_intervalo_p text DEFAULT NULL) AS $body$
DECLARE


nr_sequencia_w	bigint;
nr_atendimento_w	bigint;
nr_seq_lib_mat_pac_w	bigint;


BEGIN

select	max(nr_seq_lib_mat_pac)
into STRICT	nr_seq_lib_mat_pac_w
from	prescr_material
where	cd_material	= cd_material_p
and	nr_prescricao	= nr_prescricao_p;

if (coalesce(nr_seq_lib_mat_pac_w::text, '') = '') then
	select	max(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	prescr_medica
	where	nr_prescricao	= nr_prescricao_p;

	select	nextval('lib_material_paciente_seq')
	into STRICT	nr_sequencia_w
	;

	insert into lib_material_paciente(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		cd_pessoa_fisica,
		cd_material,
		qt_dose_diaria,
		qt_dias_tratamento,
		dt_inicio_validade,
		ds_justificativa,
		nr_prescricao,
		nr_seq_material,
		nr_atendimento,
		ie_urgente,
		cd_intervalo)
	values (nr_sequencia_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		cd_pessoa_fisica_p,
		cd_material_p,
		qt_dose_diaria_p,
		qt_dias_tratamento_p,
		dt_prescricao_p,
		ds_justificativa_p,
		nr_prescricao_p,
		nr_seq_material_p,
		nr_atendimento_w,
		ie_urgente_p,
		cd_intervalo_p);

	update	prescr_material
	set	nr_seq_lib_mat_pac	= nr_sequencia_w,
		qt_dias_tratamento	= qt_dias_tratamento_p,
		ds_justificativa	= ds_justificativa_p
	where	nr_prescricao	= nr_prescricao_p
	and	nr_sequencia		= nr_seq_material_p;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_liberacao_med_naopadrao ( qt_dias_tratamento_p bigint, cd_pessoa_fisica_p text, cd_material_p bigint, dt_prescricao_p timestamp, qt_dose_diaria_p bigint, nm_usuario_p text, ds_justificativa_p text, nr_prescricao_p bigint, nr_seq_material_p bigint, ie_urgente_p text DEFAULT 'N', cd_intervalo_p text DEFAULT NULL) FROM PUBLIC;

