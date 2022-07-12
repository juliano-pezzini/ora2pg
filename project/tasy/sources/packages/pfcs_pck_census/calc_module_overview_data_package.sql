-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_pck_census.calc_module_overview_data (cd_establishment_p bigint, nm_user_p text) AS $body$
DECLARE

        cur_modules CURSOR FOR
        SELECT nr_sequencia nr_seq_dynamic_module,
            cd_exp_module,
            ds_dynamic_module ds_module,
            cd_funcao cd_function,
            nr_seq_display,
            ie_export,
            ie_situacao ie_situation
        from pfcs_dynamic_module
        where (ie_situacao = PFCS_PCK_CONSTANTS.IE_ACTIVE or ie_export = PFCS_PCK_CONSTANTS.IE_YES)
            and coalesce(cd_funcao,0) <> PFCS_PCK_CONSTANTS.CD_FUNC_ENTERPRISE_DEMAND;

        unit_classif_array_w    strarray;
        pr_occupancy_w          pfcs_module_overview.pr_occupancy%type;
        vl_census_w             pfcs_module_overview.vl_census%type;
        qt_total_beds_w         pfcs_module_overview.qt_total_beds%type;
        qt_avail_beds_w         pfcs_module_overview.qt_avail_beds%type;
        qt_unavail_beds_w       pfcs_module_overview.qt_unavail_beds%type;
        qt_discharge_orders_w   pfcs_module_overview.qt_discharge_orders%type;
        qt_discharge_delays_w   pfcs_module_overview.qt_discharge_delays%type;
        qt_total_admissions_w   pfcs_module_overview.qt_total_admissions%type;
        qt_total_discharges_w   pfcs_module_overview.qt_total_discharges%type;
        ie_hah_only_w           pfcs_panel.ie_flag%type;
        cd_function_aux_w       pfcs_module_overview.cd_function_aux%type;

BEGIN
        for c01_w in cur_modules loop
            unit_classif_array_w := pfcs_pck_dynamic_cards.get_module_unit_types_array(c01_w.nr_seq_dynamic_module);

            pr_occupancy_w := null;
            vl_census_w := null;
            qt_total_beds_w := null;
            qt_avail_beds_w := null;
            qt_unavail_beds_w := null;
            qt_discharge_orders_w := null;
            qt_discharge_delays_w := null;
            qt_total_admissions_w := null;
            qt_total_discharges_w := null;

            cd_function_aux_w := null;
            if (c01_w.ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE) then
                cd_function_aux_w := PFCS_PCK_CONSTANTS.CD_FUNC_ARCHIMEDES;
            end if;

            if (unit_classif_array_w.count > 0) then
                ie_hah_only_w := PFCS_PCK_CONSTANTS.IE_NO;
                if ( (unit_classif_array_w.count = 1) and (PFCS_PCK_CONSTANTS.CD_HAH member of(unit_classif_array_w)) ) then
                    ie_hah_only_w := PFCS_PCK_CONSTANTS.IE_YES;
                end if;

                if (PFCS_PCK_CONSTANTS.CD_UNIT_TYPE_TELE not member of(unit_classif_array_w)) then
                    select  case    when coalesce(sum(vl_indicator)::text, '') = '' then null
                                    else concat(pfcs_get_percentage_value(sum(vl_indicator_help), sum(vl_indicator)),'%')
                            end,
                            (sum(vl_indicator_help) || '/' || sum(vl_indicator))
                    into STRICT    pr_occupancy_w, vl_census_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_CAPACITY
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_avail_beds_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_AVAILABLE_BEDS
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator_help)
                    into STRICT    qt_total_beds_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_AVAILABLE_BEDS
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     cd_reference_aux <> PFCS_PCK_CONSTANTS.CD_HAH
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_unavail_beds_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_UNAVAILABLE_BEDS
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_discharge_orders_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_DISCHARGE_ORDERS
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_discharge_delays_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_DISCHARGE_DELAYS
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_total_admissions_w
                    from    pfcs_panel
                    where   nr_seq_indicator in (PFCS_PCK_INDICATORS.NR_ICU_ADMISSION_ORDERS, PFCS_PCK_INDICATORS.NR_VC_EXPECTED_ADMISSIONS)
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

                    select  sum(vl_indicator)
                    into STRICT    qt_total_discharges_w
                    from    pfcs_panel
                    where   nr_seq_indicator = PFCS_PCK_INDICATORS.NR_VC_TOTAL_DISCHARGES
                    and     nr_seq_operational_level = cd_establishment_p
                    and (cd_reference_aux member of(unit_classif_array_w))
                    and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;
                else
                    pr_occupancy_w          := pfcs_pck_indicators.get_value_panel(PFCS_PCK_INDICATORS.NR_TELE_CAPACITY, cd_establishment_p);
                    vl_census_w             := pfcs_pck_indicators.get_value_panel(PFCS_PCK_INDICATORS.NR_TELE_CENSUS, cd_establishment_p);
                    qt_avail_beds_w         := pfcs_pck_indicators.get_value_panel(PFCS_PCK_INDICATORS.NR_TELE_AVAILABLE_DEVICES, cd_establishment_p);
                    qt_unavail_beds_w       := pfcs_pck_indicators.get_value_panel(PFCS_PCK_INDICATORS.NR_TELE_BLOCKED_DEVICES, cd_establishment_p);
                    qt_discharge_orders_w   := pfcs_pck_indicators.get_value_panel(PFCS_PCK_INDICATORS.NR_TELE_DISCONTINUE_ORDERS, cd_establishment_p);
                end if;

                vl_census_w := case when length(vl_census_w) < 3 then null else vl_census_w end;
                if (ie_hah_only_w = PFCS_PCK_CONSTANTS.IE_YES) then
                    pr_occupancy_w      := null;
                    vl_census_w         := substr(vl_census_w, 1, position('/' in vl_census_w)-1);
                    qt_avail_beds_w     := null;
                    qt_unavail_beds_w   := null;
                end if;
            end if;

            insert into pfcs_module_overview(
                nr_seq_module,
                cd_function,
                cd_function_aux,
                nr_seq_display,
                cd_exp_module,
                ds_module,
                dt_atualizacao_nrec,
                dt_atualizacao,
                nm_usuario,
                nm_usuario_nrec,
                pr_occupancy,
                vl_census,
                qt_total_beds,
                qt_avail_beds,
                qt_unavail_beds,
                qt_discharge_orders,
                qt_discharge_delays,
                qt_total_admissions,
                qt_total_discharges,
                ds_occupancy_color,
                ds_census_color,
                ds_avail_beds_color,
                ds_unavail_beds_color,
                ds_disch_orders_color,
                ds_disch_delays_color,
                ds_total_admissions_color,
                ds_total_dischargers_color,
                ds_parameters,
                cd_establishment,
                ie_situation
            ) values (
                c01_w.nr_seq_dynamic_module,
                c01_w.cd_function,
                cd_function_aux_w,
                c01_w.nr_seq_display,
                c01_w.cd_exp_module,
                c01_w.ds_module,
                clock_timestamp(),
                clock_timestamp(),
                nm_user_p,
                nm_user_p,
                pr_occupancy_w,
                vl_census_w,
                qt_total_beds_w,
                qt_avail_beds_w,
                qt_unavail_beds_w,
                qt_discharge_orders_w,
                qt_discharge_delays_w,
                qt_total_admissions_w,
                qt_total_discharges_w,
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_CAPACITY,to_char(pr_occupancy_w),cd_establishment_p),
                null,
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_AVAILABLE_BEDS,to_char(qt_avail_beds_w),cd_establishment_p),
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_UNAVAILABLE_BEDS,to_char(qt_unavail_beds_w),cd_establishment_p),
                null,
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_DISCHARGE_DELAYS,to_char(qt_discharge_delays_w),cd_establishment_p),
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_TOTAL_ADMISSIONS,to_char(qt_total_admissions_w),cd_establishment_p),
                pfcs_pck_indicators.get_color(PFCS_PCK_INDICATORS.NR_VC_TOTAL_DISCHARGES,to_char(qt_total_discharges_w),cd_establishment_p),
                pfcs_pck_dynamic_cards.get_dashboard_parameters(c01_w.nr_seq_dynamic_module),
                cd_establishment_p,
                PFCS_PCK_CONSTANTS.IE_TEMPORARY
            );
        end loop;
        commit;

        delete  FROM pfcs_module_overview
        where   cd_establishment = cd_establishment_p
        and     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE;

        update  pfcs_module_overview
        set     ie_situation = PFCS_PCK_CONSTANTS.IE_ACTIVE
        where   cd_establishment = cd_establishment_p
        and     ie_situation = PFCS_PCK_CONSTANTS.IE_TEMPORARY;

        commit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_pck_census.calc_module_overview_data (cd_establishment_p bigint, nm_user_p text) FROM PUBLIC;
