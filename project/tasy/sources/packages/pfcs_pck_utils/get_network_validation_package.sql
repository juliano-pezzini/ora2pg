-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pfcs_pck_utils.get_network_validation (nr_seq_patient_p bigint) RETURNS varchar AS $body$
DECLARE

        ie_in_network_w     pfcs_detail_patient.ds_coverage_network%type;
        qt_count_w          integer := 0;
        nr_seq_patient_w    pfcs_coverage.nr_seq_beneficiary_patient%type := nr_seq_patient_p;

BEGIN
        select      count(1)
        into STRICT        qt_count_w
        from        empresa emp
        inner join  pfcs_network_config cfg on emp.cd_empresa = cfg.cd_empresa
        inner join  pfcs_coverage cov on emp.cd_base_cgc = to_char(cov.nr_seq_payor_organization)
        where       cov.nr_seq_beneficiary_patient = nr_seq_patient_w  LIMIT 1;

        if (qt_count_w > 0) then
            ie_in_network_w := PFCS_PCK_CONSTANTS.IE_YES;
        else
            ie_in_network_w := PFCS_PCK_CONSTANTS.IE_NO;
        end if;
        return ie_in_network_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pfcs_pck_utils.get_network_validation (nr_seq_patient_p bigint) FROM PUBLIC;
