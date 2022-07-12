-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_main_and_addit_data_surg ( type_p text, nr_surgery_p cirurgia.nr_cirurgia%type, nr_attention_p atendimento_paciente.nr_atendimento%type ) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Goal: This routine aims to get main, or additional, data from the records in the "CIRURGIA" table.
----------------------------------------------------------------------------------------------------
Direct call locations:
[   ] Dictionary objects [   ] Tasy (Delphi/Java/HTML5) [   ] Portal [    ] Reports [ X ] Others: 
Called within the EXEC_SCHED_SURG_BY_DEPARTMENTS.VW routine.
---------------------------------------------------------------------------------------------------
Attention points: 
---------------------------------------------------------------------------------------------------
Obs: The "type_p" variable is used to choose what information you are looking for. Follows value
options to set in the variable:
        - CDSS: Code of the department that scheduled the surgery;
        - DDSS: Description of the department that scheduled the surgery;
        - CDPS: Code of the department that performed the surgery;
        - DDPS: Description of the department that performed the surgery;
        - GPN: Get patient's name;
        - GFSSD: Get formatted scheduled surgery date;
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/data_to_return_w	varchar(4000) := '';
cd_departm_schd_surg_w  agenda_paciente_auxiliar.cd_depto_medico%type;
ds_departm_schd_surg_w  departamento_medico.ds_departamento%type;
cd_departm_perf_surg_w  atend_paciente_unidade.cd_departamento%type;
ds_departm_perf_surg_w  departamento_medico.ds_departamento%type;
nm_patient_w	        varchar(4000) := '';
dt_sch_forma_surgery_w  varchar(4000) := '';


BEGIN

-- FILL IN THE VARIABLES
if (type_p = 'CDSS' or type_p = 'DDSS') then
        select  max(a.cd_depto_medico)
        into STRICT    cd_departm_schd_surg_w
        from    agenda_paciente_auxiliar a,
                agenda_paciente b,
                cirurgia c
        where   a.nr_seq_agenda = b.nr_sequencia
        and     b.nr_sequencia = c.nr_seq_agenda
        and     c.nr_cirurgia = nr_surgery_p;

        if ( (cd_departm_schd_surg_w IS NOT NULL AND cd_departm_schd_surg_w::text <> '') and type_p = 'DDSS' ) then
                select  a.ds_departamento
                into STRICT    ds_departm_schd_surg_w
                from    departamento_medico a
                where   a.cd_departamento = cd_departm_schd_surg_w;
        end if;
elsif (type_p = 'CDPS' or type_p = 'DDPS') then
        select  max(a.cd_departamento)
        into STRICT    cd_departm_perf_surg_w
        from    atend_paciente_unidade a,
                atendimento_paciente b,
                cirurgia c
        where   a.nr_atendimento = b.nr_atendimento
        and     b.nr_atendimento = c.nr_atendimento
        and     (a.cd_departamento IS NOT NULL AND a.cd_departamento::text <> '')
        and     c.dt_entrada_unidade = a.dt_entrada_unidade
        and     c.dt_inicio_real between a.dt_entrada_unidade and a.dt_saida_unidade
        and     c.nr_cirurgia = nr_surgery_p
        order by a.dt_entrada_unidade desc;

        if ( (cd_departm_perf_surg_w IS NOT NULL AND cd_departm_perf_surg_w::text <> '') and type_p = 'DDPS' ) then
                select  a.ds_departamento
                into STRICT    ds_departm_perf_surg_w
                from    departamento_medico a
                where   a.cd_departamento = cd_departm_perf_surg_w;
        end if;
elsif (type_p = 'GPN') then
        select  obter_nome_pf(a.cd_pessoa_fisica)
        into STRICT    nm_patient_w
        from    atendimento_paciente a
        where   a.nr_atendimento = nr_attention_p;
elsif (type_p = 'GFSSD') then
        select  pkg_date_formaters.to_varchar(pkg_date_utils.get_datetime(a.dt_agenda, a.hr_inicio), 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)
        into STRICT    dt_sch_forma_surgery_w
        from    agenda_paciente a,
                cirurgia b
        where   a.nr_sequencia = b.nr_seq_agenda
        and     b.nr_cirurgia = nr_surgery_p;
end if;

-- CHOOSE RETURN
if ( type_p = 'CDSS' ) then
        data_to_return_w := cd_departm_schd_surg_w;
elsif ( type_p = 'DDSS' ) then
        data_to_return_w := ds_departm_schd_surg_w;
elsif ( type_p = 'CDPS' ) then
        data_to_return_w := cd_departm_perf_surg_w;
elsif ( type_p = 'DDPS' ) then
        data_to_return_w := ds_departm_perf_surg_w;
elsif ( type_p = 'GPN' ) then
        data_to_return_w := nm_patient_w;
elsif ( type_p = 'GFSSD' ) then
        data_to_return_w := dt_sch_forma_surgery_w;
end if;

return to_char(data_to_return_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_main_and_addit_data_surg ( type_p text, nr_surgery_p cirurgia.nr_cirurgia%type, nr_attention_p atendimento_paciente.nr_atendimento%type ) FROM PUBLIC;

