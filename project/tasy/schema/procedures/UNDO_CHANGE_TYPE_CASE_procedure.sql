-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE undo_change_type_case ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p text) AS $body$
DECLARE


        ds_erro_w               varchar(2000);
        tipo_episodio_w         tipo_episodio.nr_sequencia%type;
        nr_episodio_w           episodio_paciente.nr_sequencia%type;
        dt_cancel_w             atendimento_paciente.dt_cancelamento%type;
        dt_discharger_w         atendimento_paciente.dt_alta%type;
        ds_prev_status_agecon_w agenda_consulta.IE_STATUS_AGENDA%type;
        ds_prev_status_agepac_w agenda_paciente.IE_STATUS_AGENDA%type;
        ds_prev_status_bed_w    gestao_vaga.ie_status%type;
        nr_last_group_w         atend_hist_pac_change_type.nr_seq_agrup%type;
        nr_tipo_his_w           atendimento_hist_paciente.nr_seq_tipo_historico%type;
        ds_column_w             varchar(2000);
        cd_doenca_w             diagnostico_doenca.cd_doenca%type;
        ds_dt_diagnosis_w       varchar(2000);
        dt_diagnosis_w          diagnostico_doenca.dt_diagnostico%type;
        nr_seq_registro_w       bigint;

        c_encounter_history CURSOR(pc_nr_atendimento  bigint, pc_nr_tipo_his  bigint, pc_nr_last_group  bigint) FOR
        SELECT ahpct.*
        from atendimento_hist_paciente athp
                join atend_hist_pac_change_type ahpct
                on athp.nr_sequencia = ahpct.nr_seq_historico
        where
                athp.nr_atendimento = pc_nr_atendimento
                and athp.nr_seq_tipo_historico = pc_nr_tipo_his
                and ahpct.nr_seq_agrup = pc_nr_last_group;


        procedure insert_log_error(
                                ds_erro_p       in      text,
                                nm_usuario_p    in      text
                                ) is
;
BEGIN
                insert into log_atendimento(
                        dt_atualizacao,
                        nm_usuario,
                        cd_log,
                        ds_log
                ) values (
                        clock_timestamp(),
                        nm_usuario_p,
                        17,
                        ds_erro_p
                );

                commit;
        end;

begin

        begin
                select max(nr_sequencia)
                into STRICT nr_tipo_his_w
                from tipo_historico_atendimento
                where coalesce(upper(ie_tipo_alterar_case), 'N') = 'S' and upper(ie_situacao) = 'A';

        exception
                WHEN no_data_found THEN
                        ds_erro_w        := 'select into nr_tipo_his_w - no data found - error: ' || sqlerrm(SQLSTATE);
                        insert_log_error(ds_erro_w, nm_usuario_p);
        end;

        select coalesce(max(ahpct.nr_seq_agrup), 0) as last_group
        into STRICT nr_last_group_w
        from atendimento_hist_paciente athp
                join atend_hist_pac_change_type ahpct
                on athp.nr_sequencia = ahpct.nr_seq_historico
        where
                athp.nr_atendimento = nr_atendimento_p
                and athp.nr_seq_tipo_historico = nr_tipo_his_w
                order by athp.dt_atualizacao desc;

        begin

                begin
                        select max(nr_sequencia)
                        into STRICT tipo_episodio_w
                        from tipo_episodio
                        where ie_tipo = 1
                                and ie_situacao =  'A'
                                and ie_acompanhante_paciente =  'N'
                        order by nr_sequencia asc;
                exception
                        WHEN no_data_found THEN
                                        ds_erro_w        := 'select into tipo_episodio_w - no data found - error: ' || sqlerrm(SQLSTATE);
                                        insert_log_error(ds_erro_w, nm_usuario_p);
                end;

                begin
                        select nr_seq_episodio
                        into STRICT nr_episodio_w
                        from atendimento_paciente
                        where nr_atendimento = nr_atendimento_p;
                exception
                        WHEN no_data_found THEN
                                        ds_erro_w        := 'select nr_seq_episodio into nr_episodio_w - NO_DATA_FOUND - error: ' || sqlerrm(SQLSTATE);
                                        insert_log_error(ds_erro_w, nm_usuario_p);

                        WHEN too_many_rows THEN
                                        ds_erro_w        := 'select nr_seq_episodio into nr_episodio_w - TOO_MANY_ROWS - error: ' || sqlerrm(SQLSTATE);
                                        insert_log_error(ds_erro_w, nm_usuario_p);
                end;

                update episodio_paciente
                set
                nr_seq_tipo_episodio = tipo_episodio_w,
                nm_usuario = nm_usuario_p,
                dt_atualizacao = clock_timestamp()
                where nr_sequencia = nr_episodio_w;

                commit;

                CALL insert_atend_hist_paciente(nr_atendimento_p, 16, null, null, null, null, null, null, null, null);

        exception
                when others then

                ds_erro_w        := concat('undo change case type - nr_atend_p:',
                                                nr_atendimento_p
                                                || ' tipo_episodio_w:'
                                                || tipo_episodio_w
                                                || ' nr_episodio_w: '
                                                || nr_episodio_w
                                                || ' error: '
                                                || sqlerrm(SQLSTATE)
                                        );

                insert_log_error(ds_erro_w, nm_usuario_p);
        end;

        begin

                select dt_cancelamento,
                        dt_alta
                into STRICT dt_cancel_w,
                        dt_discharger_w
                from atendimento_paciente
                where nr_atendimento = nr_atendimento_p;

                if (dt_cancel_w IS NOT NULL AND dt_cancel_w::text <> '') then

                        CALL desfazer_cancelamento_atend(nr_atendimento_p, nm_usuario_p);


                elsif (dt_discharger_w IS NOT NULL AND dt_discharger_w::text <> '') then

                        ds_erro_w := null;

                        ds_erro_w := gerar_estornar_alta(
                                        nr_atendimento_p, 'E',  --estornar, desfazer alta
                                        0, 0, clock_timestamp(), nm_usuario_p, ds_erro_w, 0, null, 'undo discharger by change case type option');

                end if;

                CALL insert_atend_hist_paciente(nr_atendimento_p, 17, null, null, null, null, null, null, null, null);

        exception
                when others then

                ds_erro_w        := 'undo encounter cancel/discharger - nr_atend_p:' ||  nr_atendimento_p || ' error: ' || sqlerrm(SQLSTATE);

                insert_log_error(ds_erro_w, nm_usuario_p);

        end;

        begin

                for r_encounter_history in c_encounter_history(nr_atendimento_p, nr_tipo_his_w, nr_last_group_w) loop

                        nr_seq_registro_w       := r_encounter_history.nr_seq_registro;

                        --consultation schedule 3 - service schedule 5
                        if r_encounter_history.ie_tipo_registro = '3' or  r_encounter_history.ie_tipo_registro = '5' then

                                ds_prev_status_agecon_w := get_additional_info(r_encounter_history.ds_observacao, 'status:', '%%%');

                                begin
                                        update	agenda_consulta
                                        set	ie_status_agenda	= ds_prev_status_agecon_w,
                                                nm_usuario		= nm_usuario_p
                                        where	nr_sequencia		= nr_seq_registro_w;

                                        commit;

                                        CALL insert_atend_hist_paciente(nr_atendimento_p, 20, null, null, null, null, nr_seq_registro_w, null, null, null);

                                exception
                                        when others then

                                        ds_erro_w        := concat('undo consultation/service schedule - nr_sequencia:', nr_seq_registro_w
                                                                                                || ' error: '
                                                                                                || sqlerrm(SQLSTATE)
                                                                );

                                        insert_log_error(ds_erro_w, nm_usuario_p);

                                end;

                         --surgical schedule 1
                        elsif r_encounter_history.ie_tipo_registro = '1' then

                                ds_prev_status_agepac_w := get_additional_info(r_encounter_history.ds_observacao, 'status:', '%%%');

                                CALL atualiza_status_agenda_cirur(nr_seq_registro_w, ds_prev_status_agepac_w);

                                CALL insert_atend_hist_paciente(nr_atendimento_p, 19, null, null, null, null, nr_seq_registro_w, null, null, null);


                         --exam schedule
                        elsif r_encounter_history.ie_tipo_registro = '2' then

                                ds_prev_status_agepac_w := get_additional_info(r_encounter_history.ds_observacao, 'status:', '%%%');

                                begin
                                        update	agenda_paciente
                                        set	ie_status_agenda        = ds_prev_status_agepac_w,
                                                nm_usuario              = nm_usuario_p
                                        where	nr_sequencia = nr_seq_registro_w;

                                        commit;

                                        CALL insert_atend_hist_paciente(nr_atendimento_p, 18, null, null, null, null, nr_seq_registro_w, null, null, null);

                                exception
                                        when others then

                                        ds_erro_w        := concat('undo exam schedule - nr_sequencia:', nr_seq_registro_w
                                                                                                || ' error: '
                                                                                                || sqlerrm(SQLSTATE)
                                                                );

                                        insert_log_error(ds_erro_w, nm_usuario_p);

                                end;

                         --bed resquest
                        elsif r_encounter_history.ie_tipo_registro = '10' then

                                ds_prev_status_bed_w := get_additional_info(r_encounter_history.ds_observacao, 'status:', '%%%');

                                begin

                                        atualizar_status_gestao_html(
                                                                ds_prev_status_bed_w,
                                                                wheb_usuario_pck.get_nm_usuario,
                                                                nr_seq_registro_w,
                                                                null,
                                                                null,
                                                                null,
                                                                null,
                                                                wheb_usuario_pck.get_nm_usuario,
                                                                null,
                                                                null
                                                        );

                                        CALL insert_atend_hist_paciente(nr_atendimento_p, 23, null, null, null, null, nr_seq_registro_w, null, null, null);

                                exception
                                        when others then

                                        ds_erro_w        := concat('undo bed request - nr_sequencia:', nr_seq_registro_w
                                                                                                || ' error: '
                                                                                                || sqlerrm(SQLSTATE)
                                                                );

                                        insert_log_error(ds_erro_w, nm_usuario_p);

                                end;

                         --diagnosis
                        elsif r_encounter_history.ie_tipo_registro = '11' then

                                begin
                                        ds_column_w             := get_additional_info(r_encounter_history.ds_observacao, 'column:', '%%%');
                                        cd_doenca_w             := get_additional_info(r_encounter_history.ds_observacao, 'cd_doenca:', '%%%');
                                        ds_dt_diagnosis_w       := get_additional_info(r_encounter_history.ds_observacao, 'date:', '%%%');

                                        ds_column_w             := upper(ds_column_w);
                                        dt_diagnosis_w          := to_date(ds_dt_diagnosis_w, 'dd/mm/yy hh24:mi:ss');

                                        CALL undo_diagnosis_change(
                                                nr_atendimento_p,
                                                ds_column_w,
                                                dt_diagnosis_w,
                                                cd_doenca_w
                                        );

                                exception
                                        when others then

                                        ds_erro_w        := concat('undo diagnosis -  error: ', sqlerrm(SQLSTATE));

                                        insert_log_error(ds_erro_w, nm_usuario_p);

                                end;

                         --companions
                        elsif r_encounter_history.ie_tipo_registro = '12' then

                                begin
                                        update episodio_acompanhante eap
                                        set
                                                eap.nr_atend_paciente = nr_atendimento_p,
                                                eap.nr_seq_ep_paciente = nr_episodio_w,
                                                eap.dt_atualizacao = clock_timestamp(),
                                                eap.nm_usuario = nm_usuario_p
                                        where
                                        eap.nr_sequencia = nr_seq_registro_w;

                                        commit;

                                        CALL insert_atend_hist_paciente(nr_atendimento_p, 21, null, null, null, null, null, nr_seq_registro_w, null, null);

                                exception
                                        when others then

                                        ds_erro_w        := concat('undo companions unlink - nr_sequencia:', nr_seq_registro_w
                                                                                                || ' error: '
                                                                                                || sqlerrm(SQLSTATE)
                                                                );

                                        insert_log_error(ds_erro_w, nm_usuario_p);

                                end;

                        end if;
                end loop;

        exception
                when others then

                ds_erro_w        := concat('undo general error - nr_sequencia:', nr_seq_registro_w
                                                                        || ' error: '
                                                                        || sqlerrm(SQLSTATE)
                                        );

                insert_log_error(ds_erro_w, nm_usuario_p);

        end;

       commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE undo_change_type_case ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nm_usuario_p text) FROM PUBLIC;
