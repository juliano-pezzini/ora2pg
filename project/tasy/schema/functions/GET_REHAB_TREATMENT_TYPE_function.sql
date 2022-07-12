-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_rehab_treatment_type ( nr_seq_rehab_times_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_treatment_type_w varchar(500);

BEGIN
    SELECT
        tr.nr_sequencia
        || ' - TIPO: '
        || tp.ds_tratamento
        || ' - STATUS: '
        || st.ds_status
        || ' - INICIO: '
        || to_char(tr.dt_inicio_tratamento, 'DD/MM/YYYY')
    INTO STRICT ds_treatment_type_w
    FROM
        rp_tratamento            tr
        LEFT JOIN rp_tipo_tratamento       tp ON tp.nr_sequencia = tr.nr_seq_tipo_tratamento
        LEFT JOIN rp_status_reabilitacao   st ON st.nr_sequencia = tr.nr_seq_status
    WHERE
        tr.nr_sequencia IN (
            SELECT
                MAX(b.ie_treatment_type)
            FROM
                agenda_consulta_adic       a,
                rp_reab_times              b,
                rp_paciente_reabilitacao   c
            WHERE
                a.nr_seq_reab_times = b.nr_sequencia
                AND c.nr_sequencia = b.nr_seq_pac_reab
                AND a.nr_seq_reab_times = nr_seq_rehab_times_p
        );

    RETURN ds_treatment_type_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_rehab_treatment_type ( nr_seq_rehab_times_p bigint ) FROM PUBLIC;

