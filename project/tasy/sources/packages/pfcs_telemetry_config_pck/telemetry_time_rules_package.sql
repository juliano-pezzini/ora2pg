-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pfcs_telemetry_config_pck.telemetry_time_rules ( qt_time_telemetry_rule_p INOUT bigint, qt_trans_review_rule_p INOUT bigint, qt_tr_trs_rule_p INOUT bigint, qt_tr_red_alrm_rule_p INOUT bigint, qt_tr_yllw_alrm_rule_p INOUT bigint) AS $body$
BEGIN
		select	coalesce(max(qt_time_on_tele__rule),12),
				max(qt_trans_review_rule),
				coalesce(max(qt_tr_trs_rule),50),
				max(qt_tr_red_alrm_rule),
				max(qt_tr_yllw_alrm_rule)
		  into STRICT	qt_time_telemetry_rule_p,
				qt_trans_review_rule_p,
				qt_tr_trs_rule_p,
				qt_tr_red_alrm_rule_p,
				qt_tr_yllw_alrm_rule_p
		  from	pfcs_telemetry_config;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pfcs_telemetry_config_pck.telemetry_time_rules ( qt_time_telemetry_rule_p INOUT bigint, qt_trans_review_rule_p INOUT bigint, qt_tr_trs_rule_p INOUT bigint, qt_tr_red_alrm_rule_p INOUT bigint, qt_tr_yllw_alrm_rule_p INOUT bigint) FROM PUBLIC;