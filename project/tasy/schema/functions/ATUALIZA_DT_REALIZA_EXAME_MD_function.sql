-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION atualiza_dt_realiza_exame_md ( dt_prevista_exec_p timestamp, nr_dia_semana_p integer, ie_domingo_p text, ie_segunda_p text, ie_terca_p text, ie_quarta_p text, ie_quinta_p text, ie_sexta_p text, ie_sabado_p text, ie_feriado_aux_p integer, ie_feriado_p text ) RETURNS timestamp AS $body$
DECLARE

    dt_prevista_w timestamp := dt_prevista_exec_p;

BEGIN
    IF ( nr_dia_semana_p = 1  AND  ie_domingo_p = 'N' ) OR ( nr_dia_semana_p = 2  AND  ie_segunda_p = 'N' ) OR ( nr_dia_semana_p = 3  AND  ie_terca_p = 'N' ) OR ( nr_dia_semana_p = 4  AND  ie_quarta_p = 'N' ) OR ( nr_dia_semana_p = 5  AND  ie_quinta_p = 'N' ) OR ( nr_dia_semana_p = 6  AND  ie_sexta_p = 'N' ) OR ( nr_dia_semana_p = 7  AND  ie_sabado_p = 'N' ) OR ( ie_feriado_aux_p > 0  AND  ie_feriado_p = 'N' ) THEN
        IF ( nr_dia_semana_p = 1 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 1 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 1 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 1 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 1 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 1 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 2 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 3 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 4 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 5 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_sabado_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 6 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_domingo_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 1;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_segunda_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 2;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_terca_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 3;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_quarta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 4;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_quinta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 5;
        ELSIF ( nr_dia_semana_p = 7 )
            AND ( ie_sexta_p = 'S' )
        THEN
            dt_prevista_w := dt_prevista_w + 6;
        END IF;
    END IF;

    RETURN dt_prevista_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION atualiza_dt_realiza_exame_md ( dt_prevista_exec_p timestamp, nr_dia_semana_p integer, ie_domingo_p text, ie_segunda_p text, ie_terca_p text, ie_quarta_p text, ie_quinta_p text, ie_sexta_p text, ie_sabado_p text, ie_feriado_aux_p integer, ie_feriado_p text ) FROM PUBLIC;

