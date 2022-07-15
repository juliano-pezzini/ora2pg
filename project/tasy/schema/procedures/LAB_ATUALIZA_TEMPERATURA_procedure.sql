-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atualiza_temperatura ( nr_sequencia_p bigint, qt_temp_atual_p bigint, dt_coleta_temp_p timestamp, nm_usuario_p text) AS $body$
DECLARE


ds_horario_lim_w lab_soro_turno.ds_horario_lim%type;
nr_seq_turno_p lab_soro_turno.nr_sequencia%type;
nr_seq_armazenamento_w lab_soro_control_temp.nr_seq_armazenamento%type;
ds_turno_w lab_soro_turno.ds_turno%type;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '' AND qt_temp_atual_p IS NOT NULL AND qt_temp_atual_p::text <> '') then

    if (dt_coleta_temp_p > clock_timestamp()) then
        CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(1024245, '');
        --A data de coleta não pode ser posterior ao momento do registro de coleta;
    end if;

    select pkg_date_utils.get_DateTime(clock_timestamp(), a.ds_horario_lim)
    into STRICT   ds_horario_lim_w
    from   lab_soro_turno a,
           lab_soro_control_temp b
    where  b.nr_sequencia = nr_sequencia_p
       and a.nr_sequencia = b.nr_seq_turno;

    if (dt_coleta_temp_p > ds_horario_lim_w) then
        CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(1024197, '');
    end if;

    select nr_seq_armazenamento
    into STRICT   nr_seq_armazenamento_w
    from   lab_soro_control_temp
    where  nr_sequencia = nr_sequencia_p;

    select min(a.nr_sequencia)
    into STRICT   nr_seq_turno_p
    from   lab_soro_turno a,
           lab_soro_control_temp b
    where  pkg_date_utils.start_of(clock_timestamp(), 'DAY') = pkg_date_utils.start_of(b.dt_atualizacao, 'DAY')
       and a.nr_sequencia = b.nr_seq_turno
       and b.nr_sequencia <> nr_sequencia_p
       and b.nr_seq_armazenamento = nr_seq_armazenamento_w
       and pkg_date_utils.get_DateTime(clock_timestamp(), a.ds_horario_lim) < ds_horario_lim_w
       and pkg_date_utils.get_DateTime(clock_timestamp(), a.ds_horario_lim) > pkg_date_utils.get_DateTime(clock_timestamp(), dt_coleta_temp_p);

    if (nr_seq_turno_p IS NOT NULL AND nr_seq_turno_p::text <> '') then
        select ds_turno
        into STRICT   ds_turno_w
        from   lab_soro_turno
        where  nr_sequencia = nr_seq_turno_p;

        CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(1024240, 'DS_TURNO='||ds_turno_w);
    end if;

	begin
    insert into lab_soro_control_temp_inf(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ds_observacao,
            nr_seq_control_temp,
            dt_coleta_temp,
            qt_temperatura)
    SELECT  nextval('lab_soro_control_temp_inf_seq'),
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            null,
            nr_sequencia_p,
            dt_coleta_temp,
            qt_temp_atual
    from    lab_soro_control_temp
	where   nr_sequencia = nr_sequencia_p;

	update lab_soro_control_temp
	set    qt_temp_atual = qt_temp_atual_p,
		   dt_atualizacao = clock_timestamp(),
		   nm_usuario = nm_usuario_p,
		   dt_coleta_temp = dt_coleta_temp_p
	where  nr_sequencia = nr_sequencia_p;

	exception
		when others then
			CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(1022108,'DS_MENSAGEM='||SQLERRM);
		end;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atualiza_temperatura ( nr_sequencia_p bigint, qt_temp_atual_p bigint, dt_coleta_temp_p timestamp, nm_usuario_p text) FROM PUBLIC;

