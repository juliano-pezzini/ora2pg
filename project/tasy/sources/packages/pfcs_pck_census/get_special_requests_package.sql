-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_census.get_special_requests ( cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text default null) RETURNS bigint AS $body$
DECLARE

        qt_special_requests_w integer;

BEGIN
        select count(pd.nr_sequencia)
        into STRICT qt_special_requests_w
        from pfcs_panel_detail pd,
            pfcs_detail_patient pat,
            pfcs_detail_bed bed
        where pat.nr_seq_detail = pd.nr_sequencia
            and bed.nr_seq_detail = pd.nr_sequencia
            and (pat.ds_special_request IS NOT NULL AND pat.ds_special_request::text <> '')
            and pd.nr_seq_indicator = 100
            and (coalesce(cd_unit_p::text, '') = '' or bed.cd_department = to_char(cd_unit_p))
            and (coalesce(cd_unit_classification_p::text, '') = '' or bed.ie_classification = cd_unit_classification_p)
            and pd.nr_seq_operational_level = cd_establishment_p;
        return qt_special_requests_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_census.get_special_requests ( cd_establishment_p bigint, cd_unit_p bigint default null, cd_unit_classification_p text default null) FROM PUBLIC;
