-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_nurse_shift ( linha_work_code text) AS $body$
BEGIN

declare

cont_posicao_w              bigint := 0;


nr_seq_int_call_log_w                   integration_message_log.nr_seq_int_call_log%type := 0;
ds_message_w                            varchar(4000);
nm_usuario_w                            varchar(20) := 'NURSE';
ds_error_w                              varchar(2000);
cd_person_w                             varchar(20);
patient_data_p                          nurse_shift_user.ds_staff_name%type;


p_cd_pessoa_fisica                      nurse_shift_user.cd_pessoa_fisica%type;
p_dt_month_year                         nurse_shift_user.cd_staff_id%type;
p_cd_ward_department                    nurse_shift_user.cd_ward_department%type;
p_cd_staff_id                           nurse_shift_user.cd_staff_id%type;
p_cd_staff_id_2                         nurse_shift_user.cd_staff_id%type;
p_user_id                               nurse_shift_user.cd_staff_id%type;
p_cd_order_display                      nurse_shift_user.cd_order_display%type;
p_cd_team                               nurse_shift_user.cd_team%type;
p_cd_order_display_2                    nurse_shift_user.cd_order_display%type;
p_cd_team_2                             nurse_shift_user.cd_team%type;
p_cd_order_display_3                    nurse_shift_user.cd_order_display%type;
p_cd_team_3                             nurse_shift_user.cd_team%type;
p_ward_display_order                    nurse_shift_user.ds_staff_name%type;
p_valid_start_date                      nurse_shift_user.ds_staff_name%type;
p_expirate_date                         nurse_shift_user.ds_staff_name%type;
p_cd_start_date                         nurse_shift_user.ds_staff_name%type;
p_cd_end_date                           nurse_shift_user.ds_staff_name%type;
p_cd_staff_name                         nurse_shift_user.ds_staff_name%type;
p_cd_kana_name                          nurse_shift_user.ds_staff_name%type;
p_dt_posture_start                      nurse_shift_user.ds_staff_name%type;
p_dt_poture_end                         nurse_shift_user.ds_staff_name%type;
p_cd_position                           nurse_shift_user.cd_position%type;
p_dt_hiring_start                       nurse_shift_user.ds_staff_name%type;
p_dt_hiring_end                         nurse_shift_user.ds_staff_name%type;
p_cd_recurutment                        nurse_shift_user.cd_team%type;
p_dt_job_type_start                     nurse_shift_user.ds_staff_name%type;
p_dt_job_type_end                       nurse_shift_user.ds_staff_name%type;
p_cd_job                                nurse_shift_user.cd_job%type;
p_dt_placement_start                    nurse_shift_user.ds_staff_name%type;
p_dt_placement_end                      nurse_shift_user.ds_staff_name%type;
p_cd_ward_department2                   nurse_shift_user.cd_ward_department%type;
p_cd_ward_department3                   nurse_shift_user.cd_ward_department%type;
p_dt_month_year_working                 nurse_shift_user.cd_staff_id%type;
p_cd_work_code                          varchar(200);
p_assoc_dt_acq                          varchar(200);
p_nurse_lis_aq                          varchar(200);
p_midwife_lis_aq                        varchar(200);
p_public_lis_aq                         varchar(200);
p_cd_update                             nurse_shift_user.cd_staff_id%type;
p_dt_update                             nurse_shift_user.ds_staff_name%type;
p_hr_update                             nurse_shift_user.ds_staff_name%type;
p_ultimo_virgula                        varchar(200);


p_pk_nr_sequencia                       nurse_shift_user.nr_sequencia%type;
nr_sequence_w                           nurse_shift_user.nr_sequencia%type;

c01 CURSOR FOR
        SELECT 
        cd_registro 
            from ( 
                SELECT * from table(lista_pck.obter_lista_char(linha_work_code)) 
                ) alias2
            where 1=1;

begin

for v_registro in c01

loop

cont_posicao_w := cont_posicao_w+1;

if (cont_posicao_w = 1) then p_dt_month_year := replace(v_registro.cd_registro, '"', null)||01; end if;
if (cont_posicao_w = 2) then p_cd_ward_department := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 3) then p_cd_staff_id := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 4) then p_cd_staff_id_2 := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 5) then p_user_id := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 6) then p_cd_order_display := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 7) then p_cd_team := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 8) then p_cd_order_display_2 := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 9) then p_cd_team_3 := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 10) then p_ward_display_order := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 11) then p_valid_start_date := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 12) then p_expirate_date := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 13) then p_cd_start_date := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 14) then p_cd_end_date := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 15) then p_cd_staff_name := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 16) then p_cd_kana_name := null; end if;
if (cont_posicao_w = 17) then p_dt_posture_start := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 18) then p_dt_poture_end := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 19) then p_cd_position := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 20) then p_dt_hiring_start := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 21) then p_dt_hiring_end := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 22) then p_cd_recurutment := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 23) then p_dt_job_type_start := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 24) then p_dt_job_type_end := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 25) then p_cd_job := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 26) then p_dt_placement_start := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 27) then p_dt_placement_end := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 28) then p_cd_ward_department2 := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 29) then p_cd_ward_department3 := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 30) then p_dt_month_year_working := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 31) then p_cd_work_code := replace(v_registro.cd_registro, '"', null); end if;

if (cont_posicao_w = 32) then p_assoc_dt_acq := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 33) then p_nurse_lis_aq := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 34) then p_midwife_lis_aq := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 35) then p_public_lis_aq := replace(v_registro.cd_registro, '"', null); end if;

if (cont_posicao_w = 36) then p_cd_update := null; end if;
if (cont_posicao_w = 37) then p_dt_update := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 38) then p_hr_update := replace(v_registro.cd_registro, '"', null); end if;
if (cont_posicao_w = 39) then p_ultimo_virgula := replace(v_registro.cd_registro, '"', null); end if;


end loop;


    select  coalesce(max(nr_sequencia), 0)
    into STRICT    nr_sequence_w
    from    nurse_shift_user nu
    where   1=1
    --and     nu.dt_month_year=to_char(to_date(p_dt_month_year, 'yyyymmdd'), 'dd/mm/yyyy')
    and     nu.dt_start_date=to_char(to_date(p_dt_posture_start, 'yyyymmdd'), 'dd/mm/yyyy')
    and     nu.dt_end_date=to_char(to_date(p_dt_poture_end, 'yyyymmdd'), 'dd/mm/yyyy')
    and     nu.cd_staff_id=p_cd_staff_id;
    --and     nu.cd_ward_department   =   p_cd_ward_department;
    if (nr_sequence_w = 0)
    then

    select  nextval('nurse_shift_user_seq')
    into STRICT    nr_sequence_w 
;


    insert into nurse_shift_user(
                        nr_sequencia,
                        dt_atualizacao, 
                        nm_usuario, 
                        dt_atualizacao_nrec, 
                        nm_usuario_nrec, 
                        cd_pessoa_fisica, 
                        dt_month_year, 
                        cd_ward_department, 
                        cd_staff_id, 
                        cd_order_display, 
                        cd_team, 
                        dt_end_date, 
                        dt_start_date, 
                        ds_staff_name, 
                        dt_posture_start, 
                        dt_poture_end, 
                        cd_position, 
                        dt_hiring_start, 
                        dt_hiring_end, 
                        dt_job_type_start, 
                        dt_job_type_end, 
                        cd_job, 
                        dt_placement_start, 
                        dt_placement_end, 
                        cd_ward_department2, 
                        dt_month_year_working, 
                        cd_recruitment,
                        dt_update
                        ) values (
                                nr_sequence_w, 
                                to_date(clock_timestamp(),'dd/mm/yyyy'), 
                                'assantana', 
                                to_date(clock_timestamp(),'dd/mm/yyyy'), 
                                'assantana',
                                p_cd_pessoa_fisica, 
                                to_char(to_date(p_dt_month_year, 'yyyymmdd'), 'dd/mm/yyyy'),  
                                p_cd_ward_department, 
                                p_cd_staff_id, 
                                p_cd_order_display, 
                                p_cd_team, 
                                to_date(p_cd_end_date,'yyyy-mm-dd'),  
                                to_date(p_cd_start_date,'yyyy-mm-dd'),  
                                p_cd_staff_name, 
                                to_date(p_dt_posture_start,'yyyy-mm-dd'),   
                                to_date(p_dt_poture_end,'yyyy-mm-dd'),  
                                p_cd_position, 
                                to_date(p_dt_hiring_start,'yyyy-mm-dd'),
                                to_date(p_dt_hiring_end,'yyyy-mm-dd'),   
                                to_date(p_dt_job_type_start,'yyyy-mm-dd'), 
                                to_date(p_dt_job_type_end,'yyyy-mm-dd'), 
                                p_cd_job, 
                                to_date(p_dt_placement_start,'yyyy-mm-dd'), 
                                to_date(p_dt_placement_end,'yyyy-mm-dd'), 
                                p_cd_ward_department2, 
                                to_char(to_date(p_dt_month_year, 'yyyymmdd'), 'dd/mm/yyyy'),  
                                p_cd_recurutment,
                                to_date(p_dt_update ||' '||p_hr_update,'yyyy-mm-dd hh24:mi:ss'));


    else
    
    update      nurse_shift_user 
    set         cd_ward_department          =   p_cd_ward_department,
                cd_job                      =   p_cd_job,
                cd_position                 =   p_cd_position,
                cd_recruitment              =   p_cd_recurutment
    where       1=1
    and         nr_sequencia=nr_sequence_w;





    end if;


CALL import_nurse_shift_user_daily(nr_sequence_w, p_dt_month_year, p_cd_ward_department, p_cd_staff_id, p_cd_order_display, p_cd_team, p_cd_start_date, p_cd_end_date, p_cd_staff_name, 
p_cd_kana_name, p_dt_posture_start, p_dt_poture_end, p_cd_position, p_dt_hiring_start, p_dt_hiring_end, p_cd_recurutment, p_dt_job_type_start, 
p_dt_job_type_end, p_cd_job, p_dt_placement_start, p_dt_placement_end, p_cd_ward_department2, p_cd_ward_department3, p_dt_month_year_working, 
p_cd_work_code, p_assoc_dt_acq, p_nurse_lis_aq, p_cd_update, p_dt_update, p_hr_update);


end;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_nurse_shift ( linha_work_code text) FROM PUBLIC;
