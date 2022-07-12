-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pfcs_get_tele_pat_review_cnt ( cd_establishment_p pfcs_panel.nr_seq_operational_level%type) RETURNS PFCS_PANEL.VL_INDICATOR%TYPE AS $body$
DECLARE


qt_patient_on_review_w	pfcs_panel.vl_indicator%type := 0;


BEGIN

    select	count(*) into STRICT qt_patient_on_review_w
    from	pfcs_panel_detail ppd join pfcs_detail_patient pdp on ppd.nr_sequencia = pdp.nr_seq_detail
		join pfcs_detail_bed pdb on ppd.nr_sequencia = pdb.nr_seq_detail
        join pfcs_detail_device pdd on ppd.nr_sequencia = pdd.nr_seq_detail
    where	ppd.nr_seq_indicator =  pfcs_pck_indicators.nr_tele_monitors_in_use
    and	ppd.nr_seq_operational_level = cd_establishment_p
    and	ppd.ie_situation = pfcs_pck_constants.ie_active
    and pfcs_telemetry_config_pck.get_patient_review(pdp.dt_monitor_entrance) =  pfcs_pck_constants.ie_yes_br;

    return qt_patient_on_review_w;

    exception
        when no_data_found then
            return 0;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pfcs_get_tele_pat_review_cnt ( cd_establishment_p pfcs_panel.nr_seq_operational_level%type) FROM PUBLIC;

