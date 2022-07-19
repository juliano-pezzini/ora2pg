-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE save_dashboard_cards ( nm_usuario_p text, nr_seq_dashboard_p bigint ) AS $body$
DECLARE


nr_seq_ind_dash_w		bigint;
nr_seq_indicator_w		bigint;
nr_seq_dimension_w	bigint;
nr_seq_information_w	bigint;
nr_seq_date_w	bigint;
ds_indicator_w		varchar(255);
ie_tipo_data_w		varchar(5);

c01 CURSOR FOR
	SELECT	nr_sequencia,
			nr_seq_indicator
	from	dashboard_indicator
	where	nr_seq_dashboard = nr_seq_dashboard_p;


BEGIN

	open c01;
	loop
	fetch c01 into
		nr_seq_ind_dash_w,
		nr_seq_indicator_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

			select	nr_seq_dimension
			into STRICT	nr_seq_dimension_w
			from	dashboard_dimension
			where	nr_seq_dashboard = nr_seq_dashboard_p
			and		nr_seq_indicator = nr_seq_ind_dash_w;

			select	nr_seq_information
			into STRICT	nr_seq_information_w
			from	dashboard_information
			where	nr_seq_dashboard = nr_seq_dashboard_p
			and		nr_seq_indicator = nr_seq_ind_dash_w;

			select	nr_seq_date
			into STRICT	nr_seq_date_w
			from	dashboard_date
			where	nr_seq_dashboard = nr_seq_dashboard_p
			and		nr_seq_indicator = nr_seq_ind_dash_w;

			select	ds_indicador
			into STRICT	ds_indicator_w
			from	ind_base
			where	nr_sequencia = nr_seq_indicator_w;

			select	ie_tipo_data
			into STRICT	ie_tipo_data_w
			from	ind_data
			where	nr_sequencia = nr_seq_date_w;

			insert into dashboard_cards(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_dashboard,
				nr_seq_indicator,
				nr_seq_dimension,
				nr_seq_information,
				nr_seq_data,
				ds_title,
				qt_colspan,
				qt_rowspan,
				ie_chart_type,
				ie_date_type,
				dt_inicio,
				dt_fim,
				ie_sort) values (
				nextval('dashboard_cards_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_dashboard_p,
				nr_seq_indicator_w,
				nr_seq_dimension_w,
				nr_seq_information_w,
				nr_seq_date_w,
				ds_indicator_w,
				1,
				1,
				'bar',
				ie_tipo_data_w,
				clock_timestamp(),
				clock_timestamp(),
				'A');
		end;
	end loop;
	close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE save_dashboard_cards ( nm_usuario_p text, nr_seq_dashboard_p bigint ) FROM PUBLIC;

