-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE int_inserir_dieta_oral ( cd_dieta_p bigint, cd_intervalo_p text, cd_motivo_baixa_p bigint, cd_perfil_ativo_p bigint, ds_horarios_p text, ds_justificativa_p text, ds_motivo_susp_p text, ds_observacao_p text, dt_atualizacao_p timestamp, dt_suspensao_p timestamp, hr_dose_especial_p text, hr_prim_horario_p text, ie_dose_espec_agora_p text, ie_suspenso_p text, ie_urgencia_p text, ie_via_aplicacao_p text, nm_usuario_p text, nm_usuario_susp_p text, nr_dia_util_p bigint, nr_prescricao_p bigint, nr_seq_interno_p bigint, nr_seq_motivo_susp_p bigint, qt_horas_jejum_p bigint, qt_parametro_p bigint, nr_sequencia_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_sequencia_w		bigint;


BEGIN

begin

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_sequencia_w
from	prescr_dieta
where	nr_prescricao	= nr_prescricao_p;

insert into prescr_dieta(
		cd_dieta                ,
		cd_intervalo            ,
		cd_motivo_baixa         ,
		cd_perfil_ativo         ,
		ds_horarios             ,
		ds_justificativa        ,
		ds_motivo_susp          ,
		ds_observacao           ,
		dt_atualizacao          ,
		dt_suspensao            ,
		hr_dose_especial        ,
		hr_prim_horario         ,
		ie_dose_espec_agora     ,
		ie_suspenso             ,
		ie_urgencia             ,
		ie_via_aplicacao        ,
		nm_usuario              ,
		nm_usuario_susp         ,
		nr_dia_util             ,
		nr_prescricao           ,
		nr_seq_interno          ,
		nr_seq_motivo_susp      ,
		qt_horas_jejum          ,
		qt_parametro,
		nr_sequencia)
		values (
		cd_dieta_p                ,
		cd_intervalo_p            ,
		cd_motivo_baixa_p         ,
		cd_perfil_ativo_p         ,
		ds_horarios_p             ,
		ds_justificativa_p        ,
		ds_motivo_susp_p          ,
		ds_observacao_p           ,
		dt_atualizacao_p          ,
		dt_suspensao_p            ,
		hr_dose_especial_p        ,
		hr_prim_horario_p         ,
		ie_dose_espec_agora_p     ,
		ie_suspenso_p             ,
		ie_urgencia_p             ,
		ie_via_aplicacao_p        ,
		nm_usuario_p              ,
		nm_usuario_susp_p         ,
		nr_dia_util_p             ,
		nr_prescricao_p           ,
		nr_seq_interno_p          ,
		nr_seq_motivo_susp_p      ,
		qt_horas_jejum_p          ,
		qt_parametro_p,
		nr_sequencia_w);

	commit;

nr_sequencia_p		:= 	nr_sequencia_w;

exception
when others then
	ds_erro_p	:= substr(SQLERRM,1,255);
end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE int_inserir_dieta_oral ( cd_dieta_p bigint, cd_intervalo_p text, cd_motivo_baixa_p bigint, cd_perfil_ativo_p bigint, ds_horarios_p text, ds_justificativa_p text, ds_motivo_susp_p text, ds_observacao_p text, dt_atualizacao_p timestamp, dt_suspensao_p timestamp, hr_dose_especial_p text, hr_prim_horario_p text, ie_dose_espec_agora_p text, ie_suspenso_p text, ie_urgencia_p text, ie_via_aplicacao_p text, nm_usuario_p text, nm_usuario_susp_p text, nr_dia_util_p bigint, nr_prescricao_p bigint, nr_seq_interno_p bigint, nr_seq_motivo_susp_p bigint, qt_horas_jejum_p bigint, qt_parametro_p bigint, nr_sequencia_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
