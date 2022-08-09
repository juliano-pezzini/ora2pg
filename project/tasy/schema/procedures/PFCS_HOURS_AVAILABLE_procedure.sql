-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pfcs_hours_available ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


    qt_time_rule_w PFCS_TIME_AVAILABLE_HOURS.qt_time%type;
	c01 CURSOR FOR
    SELECT
        b.nr_seq_sala_cir nr_seq_room,
        (SELECT ds_sala_painel FROM sala_cirurgia where b.nr_seq_sala_cir = nr_sequencia) ds_room,
        SUM(a.nr_minuto_duracao) qt_minutos
    FROM   agenda_paciente a,
           agenda b
    WHERE  a.cd_agenda 	   	 	  = b.cd_agenda
        AND    b.cd_estabelecimento = cd_estabelecimento_p
        AND	   b.cd_tipo_agenda		  = 1
        AND	   a.ie_status_agenda	  = 'L'
        AND	   TRUNC(a.DT_agenda)	  BETWEEN TRUNC(clock_timestamp()) AND TRUNC(clock_timestamp()) + qt_time_rule_w  
        AND    (b.nr_seq_sala_cir IS NOT NULL AND b.nr_seq_sala_cir::text <> '')
    GROUP BY b.nr_seq_sala_cir
    ORDER BY 1;



	qt_total_w							bigint := 0;
	pfcs_panel_detail_seq_w			    pfcs_panel_detail.nr_sequencia%type;
	nr_seq_operational_level_w			pfcs_operational_level.nr_sequencia%type;
	nr_seq_panel_w					    pfcs_panel.nr_sequencia%type;


	
BEGIN
    select max(qt_time)
            into STRICT qt_time_rule_w 
            from PFCS_TIME_AVAILABLE_HOURS;

	nr_seq_operational_level_w := pfcs_get_structure_level(
		cd_establishment_p => cd_estabelecimento_p,
		ie_level_p => 'O',
		ie_info_p => 'C');
    for c01_w in c01 loop

      begin

        qt_total_w := qt_total_w + c01_w.qt_minutos;

        select	nextval('pfcs_panel_detail_seq')
        into STRICT	pfcs_panel_detail_seq_w
;

        insert into pfcs_panel_detail(
          nr_sequencia,
          nm_usuario,
          dt_atualizacao,
          nm_usuario_nrec,
          dt_atualizacao_nrec,
          ie_situation,
          nr_seq_indicator,
          nr_seq_operational_level)
        values (
          pfcs_panel_detail_seq_w,
          nm_usuario_p,
          clock_timestamp(),
          nm_usuario_p,
          clock_timestamp(),
          'T',
          nr_seq_indicator_p,
          nr_seq_operational_level_w);

        insert into pfcs_detail_schedule(
          nr_sequencia,
          nm_usuario,
          dt_atualizacao,
          nm_usuario_nrec,
          dt_atualizacao_nrec,
          nr_seq_detail,
          ds_room,
          qt_duration_minutes
          )
        values (
          nextval('pfcs_detail_patient_seq'),
          nm_usuario_p,
          clock_timestamp(),
          nm_usuario_p,
          clock_timestamp(),
          pfcs_panel_detail_seq_w,
          c01_w.ds_room,
          c01_w.qt_minutos
          );

      end;

    end loop;

    commit;


     := pfcs_pck.pfcs_generate_results(
      vl_indicator_p => round((qt_total_w/60)::numeric,0), vl_indicator_aux_p =>qt_total_w, ds_reference_value_p => null, nr_seq_indicator_p => nr_seq_indicator_p, nr_seq_operational_level_p => nr_seq_operational_level_w, nm_usuario_p => nm_usuario_p, nr_seq_panel_p => nr_seq_panel_w);

    CALL pfcs_pck.pfcs_update_detail(
        nr_seq_indicator_p => nr_seq_indicator_p,
        nr_seq_panel_p => nr_seq_panel_w,
        nr_seq_operational_level_p => nr_seq_operational_level_w,
        nm_usuario_p => nm_usuario_p);

    CALL pfcs_pck.pfcs_activate_records(
            nr_seq_indicator_p => nr_seq_indicator_p,
            nr_seq_operational_level_p => nr_seq_operational_level_w,
            nm_usuario_p => nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_hours_available ( nr_seq_indicator_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;
