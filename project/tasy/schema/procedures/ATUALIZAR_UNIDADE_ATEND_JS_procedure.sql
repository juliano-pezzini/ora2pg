-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_unidade_atend_js ( ie_status_unidade_p text, cd_paciente_reserva_p text, nm_usuario_reserva_p text, ds_observacao_p text, cd_convenio_reserva_p bigint, nr_seq_motivo_reserva_p bigint, ie_tipo_reserva_p text, ie_necessita_isol_reserva_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint, nm_usuario_p text, dt_start_p timestamp default null, dt_end_p timestamp default null) AS $body$
BEGIN
if (coalesce(cd_setor_atendimento_p, 0) <> 0)  and (coalesce(cd_unidade_basica_P, 'X') <> 'X') and (coalesce(cd_unidade_compl_p, 'X') <> 'X') then

  update  unidade_atendimento
  set  ie_status_unidade    = coalesce(ie_status_unidade_p,ie_status_unidade),
    cd_paciente_reserva  = cd_paciente_reserva_p,
    nm_usuario_reserva    = nm_usuario_reserva_p,
    nm_usuario    = nm_usuario_reserva_p,
    ds_observacao    = ds_observacao_p,
    cd_convenio_reserva  = cd_convenio_reserva_p,
    nr_seq_motivo_reserva  = nr_seq_motivo_reserva_p,
    ie_tipo_reserva    = ie_tipo_reserva_p,
    ie_necessita_isol_reserva  = ie_necessita_isol_reserva_p,
    dt_start_reservation = dt_start_p,
    dt_end_reservation = dt_end_p
  where  cd_unidade_basica    = cd_unidade_basica_P
  and  cd_unidade_compl    = cd_unidade_compl_p
  and  cd_setor_atendimento  = cd_setor_atendimento_p;

end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_unidade_atend_js ( ie_status_unidade_p text, cd_paciente_reserva_p text, nm_usuario_reserva_p text, ds_observacao_p text, cd_convenio_reserva_p bigint, nr_seq_motivo_reserva_p bigint, ie_tipo_reserva_p text, ie_necessita_isol_reserva_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint, nm_usuario_p text, dt_start_p timestamp default null, dt_end_p timestamp default null) FROM PUBLIC;

