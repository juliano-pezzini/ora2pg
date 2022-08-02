-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE save_dashboard_card ( nm_usuario_p text, nr_seq_ind_dashboard_p bigint, nr_seq_dashboard_p bigint, ie_origem_p text, ie_origem_bsc_p text default 'N') AS $body$
DECLARE


nr_seq_ind_dash_w		bigint;

nr_seq_indicator_w		bigint;

nr_seq_dimension_w	bigint;

nr_seq_information_w	bigint;

nr_seq_date_w	bigint;

ds_indicator_w		varchar(255);

ie_tipo_data_w		varchar(5);

nr_seq_indicator_bsc_w	bigint;


	
BEGIN

		select	nr_seq_dimension
		into STRICT	nr_seq_dimension_w
		from	dashboard_dimension
		where	nr_seq_dashboard = nr_seq_dashboard_p
		and		nr_seq_indicator = nr_seq_ind_dashboard_p;

		select	nr_seq_information
		into STRICT	nr_seq_information_w
		from	dashboard_information
		where	nr_seq_dashboard = nr_seq_dashboard_p
		and		nr_seq_indicator = nr_seq_ind_dashboard_p;

        if (ie_origem_p <> 'PA') then
                select	nr_seq_date
                into STRICT	nr_seq_date_w
                from	dashboard_date
                where	nr_seq_dashboard = nr_seq_dashboard_p
                and		nr_seq_indicator = nr_seq_ind_dashboard_p;
                
                select	ie_tipo_data
                into STRICT	ie_tipo_data_w
                from	ind_data
                where	nr_sequencia = nr_seq_date_w;
        end if;
		
		select nr_seq_indicator
		into STRICT nr_seq_indicator_w
		from	dashboard_indicator
		where	nr_sequencia = nr_seq_ind_dashboard_p;

		select  coalesce(substr(obter_desc_expressao(cd_exp_indicador, ''), 1, 255),ds_indicador) ds_indicador
		into STRICT	ds_indicator_w
		from	ind_base
		where	nr_sequencia = nr_seq_indicator_w;

        if (ie_origem_p <> 'PA') then
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
                ie_sort
                ) values (
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
                2,
                1,
                'bar',
                ie_tipo_data_w,
                clock_timestamp(),
                clock_timestamp(),
                'A');
        else
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
                ds_title,
                qt_colspan,
                qt_rowspan,
                ie_chart_type,
                ie_sort
                ) values (
                nextval('dashboard_cards_seq'),
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_dashboard_p,
                nr_seq_indicator_w,
                nr_seq_dimension_w,
                nr_seq_information_w,
                ds_indicator_w,
                2,
                1,
                'bar',
                'A');
        end if;

            
		

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE save_dashboard_card ( nm_usuario_p text, nr_seq_ind_dashboard_p bigint, nr_seq_dashboard_p bigint, ie_origem_p text, ie_origem_bsc_p text default 'N') FROM PUBLIC;

