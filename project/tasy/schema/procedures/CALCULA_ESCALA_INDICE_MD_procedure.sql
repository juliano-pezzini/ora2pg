-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_escala_indice_md ( ie_resposta_motora_p bigint, ie_resposta_verbal_p bigint, ie_abertura_ocular_p bigint, ie_avaliacao_pupilar_p bigint, qt_glasgow_pupilar_p bigint, qt_glasgow_p bigint, qt_glasgow_pupilar_aux_p INOUT bigint, qt_glasgow_aux_p INOUT bigint ) AS $body$
BEGIN
    IF ( qt_glasgow_p = -1 ) THEN
        qt_glasgow_aux_p := 0;
    ELSIF ( qt_glasgow_p = -2 ) THEN
        qt_glasgow_aux_p := NULL;
    ELSE
        qt_glasgow_aux_p := coalesce(ie_resposta_motora_p, 0) + coalesce(ie_resposta_verbal_p, 0) + coalesce(ie_abertura_ocular_p, 0);

        IF (qt_glasgow_pupilar_p IS NOT NULL AND qt_glasgow_pupilar_p::text <> '') THEN
            qt_glasgow_pupilar_aux_p := ( coalesce(ie_resposta_motora_p, 0) + coalesce(ie_resposta_verbal_p, 0) + coalesce(ie_abertura_ocular_p,0) ) - coalesce(ie_avaliacao_pupilar_p, 0);

        END IF;

    END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_escala_indice_md ( ie_resposta_motora_p bigint, ie_resposta_verbal_p bigint, ie_abertura_ocular_p bigint, ie_avaliacao_pupilar_p bigint, qt_glasgow_pupilar_p bigint, qt_glasgow_p bigint, qt_glasgow_pupilar_aux_p INOUT bigint, qt_glasgow_aux_p INOUT bigint ) FROM PUBLIC;
