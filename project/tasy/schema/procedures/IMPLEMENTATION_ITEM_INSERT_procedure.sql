-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE implementation_item_insert ( nm_value_p text, nr_sequencia_p bigint, nr_seq_classif_item_p bigint, ds_excl_unit_p text, ds_item_category_p text ) AS $body$
DECLARE

    nm_unit_w    bigint;
    nr_count_w   bigint;

BEGIN
    SELECT
        coalesce(MAX(nr_temp_unid), 20)
    INTO STRICT nm_unit_w
    FROM (
            SELECT
                nr_temp_unid
            FROM
                rp_parametros
            ORDER BY
                dt_atualizacao DESC
        ) alias2 LIMIT 1;

    INSERT INTO rp_implemen_item_reab(
        nr_sequencia,
        ds_classification,
        dt_atualizacao,
        nm_usuario,
        nr_unit,
        nr_seq_impl_reab,
        nr_seq_classif_item,
        ds_excl_unit,
        ds_item_category
    ) VALUES (
        nextval('rp_implemen_item_reab_seq'),
        nm_value_p,
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        nm_unit_w,
        nr_sequencia_p,
        nr_seq_classif_item_p,
        ds_excl_unit_p,
        ds_item_category_p
    );

    SELECT
        COUNT(*)
    INTO STRICT nr_count_w
    FROM
        rp_implemen_item_reab
    WHERE
        nr_seq_impl_reab = nr_sequencia_p
        AND ds_excl_unit = 'I';
    IF ( nr_count_w > 0 ) THEN
     UPDATE rp_implementation_reab
     SET
        dt_end_time = dt_start_time + ( 1 / 1440 * ( nr_count_w * nm_unit_w ) ),
        dt_total_time = pkg_date_utils.start_of(dt_total_time, 'DD', 0) + ( 1 / 1440 * ( nr_count_w * nm_unit_w ) )
     WHERE
        nr_sequencia = nr_sequencia_p;

    END IF;
    COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE implementation_item_insert ( nm_value_p text, nr_sequencia_p bigint, nr_seq_classif_item_p bigint, ds_excl_unit_p text, ds_item_category_p text ) FROM PUBLIC;

