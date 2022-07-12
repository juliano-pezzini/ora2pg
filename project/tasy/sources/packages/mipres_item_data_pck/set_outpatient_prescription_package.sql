-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE mipres_item_data_pck.set_outpatient_prescription () AS $body$
BEGIN

		ds_sql_cursor_w :=
			   'select a.nr_atendimento nr_encounter, '
			|| '       a.dt_receita, b.qt_dose, b.cd_unidade_medida, b.ie_via_aplicacao, b.cd_intervalo, '
			|| '       a.cd_medico, null cd_resident, a.dt_cancelamento, '
			|| '       substr(m.ds_material, 1, 255) ds_item, '
			|| '       m.cd_cum item_code, m.ie_conselho_medico, nvl(m.ie_med_unirs, ''N'') ie_med_unirs, '
            || '       a.dt_receita dt_item_prescription, a.cd_medico cd_item_prescriber '
			|| '  from fa_receita_farmacia a, '
			|| '	   fa_receita_farmacia_item b, '
			|| '	   material m '
			|| ' where a.nr_sequencia = b.nr_seq_receita '
			|| '   and b.cd_material = m.cd_material '
			|| '   and a.nr_sequencia = :nr_seq_receita_amb_p '
			|| '   and b.nr_sequencia = :nr_seq_item_receita_amb_p ';

		ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_receita_amb_p', nr_seq_receita_amb_p, ds_bind_cCursor_w);
		ds_bind_cCursor_w := sql_pck.bind_variable(':nr_seq_item_receita_amb_p', nr_seq_item_receita_amb_p, ds_bind_cCursor_w);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mipres_item_data_pck.set_outpatient_prescription () FROM PUBLIC;
