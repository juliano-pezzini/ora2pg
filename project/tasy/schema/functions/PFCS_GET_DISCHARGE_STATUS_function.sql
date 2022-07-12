-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_discharge_status ( encounter_p text, cd_estabelecimento_p text ) RETURNS varchar AS $body$
DECLARE


pfcs_flag_settings					    smallint := 1;
total                                   smallint;
ie_active 							    smallint := 1;
ie_telemetria 						    varchar(5) :='S';
ie_rec_status 						    varchar(5) :='S';
ds_monitor_dev_type 					varchar(10) := 'Monitor';
ds_active_status						varchar(15) := 'ACTIVE';
ds_planned_status						varchar(15) := 'PLANNED';
ds_arrived_status						varchar(15) := 'ARRIVED';
ds_service_requested					varchar(10) := 'E0403';


BEGIN
    select ie_table_origin into STRICT pfcs_flag_settings from pfcs_general_rule where (ie_table_origin IS NOT NULL AND ie_table_origin::text <> '')  LIMIT 1;

    if (pfcs_flag_settings = 1 OR pfcs_flag_settings = 2) then
        select
            count(*) into STRICT total
        from
            pfcs_service_request sr,
            pfcs_encounter enc,
            pfcs_patient pat,
            pfcs_encounter_identifier eid,
            pfcs_device pd,
            pfcs_organization org
        where
            sr.si_status = ds_active_status
            and sr.cd_service = ds_service_requested
            and sr.nr_seq_encounter = enc.nr_sequencia
            and enc.si_status in (ds_planned_status, ds_arrived_status)
            and eid.nr_seq_encounter = enc.nr_sequencia
            and enc.nr_seq_patient = pat.nr_sequencia
            and pat.ie_active = ie_active
            and pat.nr_seq_organization = org.nr_sequencia
            and org.cd_estabelecimento = (cd_estabelecimento_p)::numeric
            and pat.nr_sequencia = pd.nr_seq_patient
            and pd.si_status = ds_active_status
            and pd.ds_device_type = ds_monitor_dev_type
            and enc.id_encounter = encounter_p;
    end if;

if (pfcs_flag_settings = 0 OR pfcs_flag_settings = 2) then
   select count(*) into STRICT total
      from atendimento_paciente ap,
      cpoe_recomendacao cr,
      tipo_recomendacao tr,
      atendimento_paciente_v apv,
      atend_paciente_unidade apu
    where cr.nr_atendimento = ap.nr_atendimento
    and ap.nr_atendimento = apv.nr_atendimento
    and apu.nr_atendimento = cr.nr_atendimento
    and ap.nr_atendimento = apu.nr_atendimento
    and apu.nr_seq_interno = obter_atepacu_paciente(apu.nr_atendimento, 'A')
    and cr.cd_recomendacao = tr.cd_tipo_recomendacao
    and tr.ie_telemetria = ie_telemetria
    and coalesce(ap.dt_cancelamento::text, '') = ''
    and (ap.dt_alta_medico IS NOT NULL AND ap.dt_alta_medico::text <> '')
    and pfcs_get_recommendation_status(cr.nr_sequencia) = ie_rec_status
    and coalesce(ap.dt_alta::text, '') = ''
    and coalesce(cr.dt_suspensao::text, '') = ''
    and ap.cd_estabelecimento = (cd_estabelecimento_p)::numeric
    and ap.nr_atendimento = (encounter_p)::numeric;

end if;

if total > 0 then
  return 'S';
else
  return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_discharge_status ( encounter_p text, cd_estabelecimento_p text ) FROM PUBLIC;
