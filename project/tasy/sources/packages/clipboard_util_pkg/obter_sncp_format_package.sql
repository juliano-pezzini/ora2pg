-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION clipboard_util_pkg.obter_sncp_format ( seq_p text, ie_field_p text, set_seq_p bigint ) RETURNS varchar AS $body$
DECLARE


        diag_nm         varchar(3000);
        res             varchar(3000);
        diag_seq        varchar(3000);
        diag_date       varchar(3000);
        res_diag_date   varchar(3000);
        diag_res_w      varchar(3000);
        diag_res        varchar(3000);
        sncp_seq        varchar(3000);
        dig_rel_fac_w   varchar(3000);
        diag_rel_fac    varchar(3000);
        dt_nm_w         varchar(1000);
        rel_fact_nm_w   varchar(1000);
        evl_nm          varchar(1000);
        result_w        varchar(1000);
        diag_num        varchar(1000);
        diag_num_res_w  varchar(1000);

        p_cur_diag CURSOR(
            nr_seq      text
        ) FOR
        SELECT
            obter_desc_expressao(822287)
            || '-'
            || coalesce(di.ds_diagnostico, 'NA-'),
            a.nr_sequencia,
            b.nr_seq_diag
        FROM
            pe_prescricao    a,
            pe_prescr_diag   b,
            pe_diagnostico   di
        WHERE
            a.nr_sequencia = b.nr_seq_prescr
            AND di.nr_sequencia = b.nr_seq_diag
            AND a.nr_sequencia = nr_seq;

        p_cur_diag_dt CURSOR(
            nr_seq text,
            diag_seq text
        ) FOR
        SELECT
            obter_desc_expressao(288452)
            || '-'
            || coalesce(to_char(b.dt_atualizacao, 'DD-MON-YY'), 'NA-')
        FROM
            pe_prescricao    a,
            pe_prescr_diag   b,
            pe_diagnostico   di
        WHERE
            a.nr_sequencia = b.nr_seq_prescr
            AND di.nr_sequencia = b.nr_seq_diag
            AND b.nr_seq_diag = diag_seq
            AND a.nr_sequencia = nr_seq;

        p_cur_result CURSOR(
            nr_seq text,
            diag_seq text
        ) FOR
        SELECT
            obter_desc_expressao(315181)
            || '-'
            || coalesce(obter_select_concatenado_bv('SELECT b.ds_item || '' - ''|| Obter_Desc_Item_Resultado(pp.nr_seq_result)
                                             FROM
                                                pe_prescricao a,
                                                pe_item_examinar b,
                                                PE_PRESCR_ITEM_RESULT pp
                                             WHERE
                                                a.nr_sequencia = pp.nr_seq_prescr
                                                and b.nr_sequencia = ( select nr_seq_item from PE_PRESCR_ITEM_RESULT c  where c.nr_sequencia = pp.NR_SEQUENCIA)
                                                and pp.NR_SEQUENCIA in ( select h.NR_SEQ_ITEM from PE_PRESCR_ITEM_RESULT_DIAG  h
                                                where h.NR_SEQ_DIAG in (select nr_sequencia from pe_prescr_diag x where x.nr_seq_diag = :diag_seq
                                                and x.nr_seq_prescr = :nr_seq) )
                                                and a.nr_sequencia = :nr_seq',
                                                'nr_seq=' || nr_seq || ';diag_seq=' || diag_seq, ', '), 'NA-')
;

        p_cur_relfac CURSOR(
            nr_seq text,
            diag_seq text
        ) FOR
        SELECT
            obter_desc_expressao(307595)
            || '-'
            ||coalesce(obter_select_concatenado_bv('SELECT obter_desc_fator_relac(c.nr_seq_fat_rel)
                                            FROM
                                                pe_prescricao    a,
                                                pe_prescr_diag   b,
                                                PE_PRESCR_DIAG_FAT_REL c
                                            WHERE
                                                a.nr_sequencia = b.nr_seq_prescr
                                                AND b.nr_sequencia = c.nr_seq_diag
                                                and b.nr_seq_diag = :diag_seq
                                                AND a.nr_sequencia = :nr_seq', 'diag_seq=' || diag_seq || ';nr_seq=' ||  nr_seq, ','), 'NA-')
;


        p_cur_diag_num CURSOR(
            nr_seq text,
            diag_seq text
        ) FOR
        SELECT
            obter_desc_expressao(1062798)
            || '-'
            ||coalesce(obter_select_concatenado_bv('SELECT nvl(b.NR_SEQ_ORDENACAO, 0)
                                              FROM
                                                pe_prescricao    a,
                                                pe_prescr_diag   b
                                              WHERE
                                                a.nr_sequencia = b.nr_seq_prescr
                                                and b.nr_seq_diag = :diag_seq
                                                AND a.nr_sequencia = :nr_seq', 'diag_seq=' || diag_seq || ';nr_seq=' ||  nr_seq, ','), 'NA-')
;


BEGIN
        OPEN p_cur_diag(seq_p);
        LOOP
            FETCH p_cur_diag INTO
                diag_nm,
                sncp_seq,
                diag_seq;
            EXIT WHEN NOT FOUND; /* apply on p_cur_diag */
            IF ( position('NA-' in diag_nm) = 0 ) THEN
                res := res
                       || diag_nm
                       || '<br/>';
            END IF;

            OPEN p_cur_diag_dt(sncp_seq,diag_seq);
            LOOP
                FETCH p_cur_diag_dt INTO diag_date;
                EXIT WHEN NOT FOUND; /* apply on p_cur_diag_dt */
                IF ( position('NA-' in diag_date) = 0 ) THEN
                    res_diag_date := diag_date;
                END IF;

            END LOOP;

            CLOSE p_cur_diag_dt;
            IF ( ie_field_p = 'DIAG_DATE' OR ie_field_p = 'EVALUATN' OR ie_field_p = 'REL_FAC' OR ie_field_p = 'NUM_DIAG') THEN
                res := res
                       || res_diag_date
                       || '<br/>';
            END IF;

            OPEN p_cur_relfac(sncp_seq,diag_seq);
            LOOP
                FETCH p_cur_relfac INTO diag_rel_fac;
                EXIT WHEN NOT FOUND; /* apply on p_cur_relfac */
                dig_rel_fac_w :=  diag_rel_fac;
            END LOOP;

            CLOSE p_cur_relfac;
            IF ( ie_field_p = 'REL_FAC' OR ie_field_p = 'EVALUATN' OR ie_field_p = 'NUM_DIAG' ) THEN
                IF (diag_rel_fac IS NOT NULL AND diag_rel_fac::text <> '') THEN
                    res := res
                           || dig_rel_fac_w
                           || '<br/>';

                END IF;
            END IF;

        OPEN p_cur_result(sncp_seq,diag_seq);
        LOOP
            FETCH p_cur_result INTO diag_res;
            EXIT WHEN NOT FOUND; /* apply on p_cur_result */
            diag_res_w := diag_res;
        END LOOP;

        CLOSE p_cur_result;
        IF ( ie_field_p = 'EVALUATN' OR ie_field_p = 'NUM_DIAG' ) THEN
            IF ( position('NA-' in diag_res) = 0 ) THEN
                res := res
                       || diag_res_w
                       || '<br/>';
            END IF;
        END IF;

        OPEN p_cur_diag_num(sncp_seq,diag_seq);
        LOOP
            FETCH p_cur_diag_num INTO diag_num;
            EXIT WHEN NOT FOUND; /* apply on p_cur_diag_num */
            diag_num_res_w := diag_num || '<br/>';
        END LOOP;

        CLOSE p_cur_diag_num;
        IF ( ie_field_p = 'NUM_DIAG' ) THEN
            IF ( position('NA-' in diag_num) = 0 ) THEN
                res := res
                       || diag_num_res_w
                       || '<br/>';
            END IF;
        END IF;

    END LOOP;

        CLOSE p_cur_diag;
        RETURN substr(res, 0, 2000);
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION clipboard_util_pkg.obter_sncp_format ( seq_p text, ie_field_p text, set_seq_p bigint ) FROM PUBLIC;
