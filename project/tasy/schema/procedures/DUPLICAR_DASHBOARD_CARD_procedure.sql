-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_dashboard_card ( nm_usuario_p text, nr_sequencia_p bigint, nr_seq_dashboard_card_p INOUT bigint, ds_titulo_p INOUT text) AS $body$
BEGIN
	select 	nextval('dashboard_cards_seq')
	into STRICT	nr_seq_dashboard_card_p
	;

	select	max(ds_title || ' (' || obter_desc_expressao(303214, 'Cópia') || ')')
	into STRICT	ds_titulo_p
	from	dashboard_cards
	where	nr_sequencia = nr_sequencia_p;

	insert into dashboard_cards(nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_dashboard,
								nr_seq_indicator,
								nr_seq_dimension,
								nr_seq_information,
								ds_title,
								qt_colspan,
								qt_rowspan,
								qt_x,
								qt_y,
								ie_chart_type,
								ie_date_type,
								dt_inicio,
								dt_fim,
								nr_seq_data,
								ie_sort)
	SELECT	nr_seq_dashboard_card_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_dashboard,
			nr_seq_indicator,
			nr_seq_dimension,
			nr_seq_information,
			ds_titulo_p,
			qt_colspan,
			qt_rowspan,
			qt_x,
			qt_y,
			ie_chart_type,
			ie_date_type,
			dt_inicio,
			dt_fim,
			nr_seq_data,
			ie_sort
	from	dashboard_cards
	where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_dashboard_card ( nm_usuario_p text, nr_sequencia_p bigint, nr_seq_dashboard_card_p INOUT bigint, ds_titulo_p INOUT text) FROM PUBLIC;

