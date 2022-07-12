-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_esc_pall_prog_md ( ie_karnofskya_p bigint, ie_ingestao_oral_p bigint, ie_edema_p text, ie_dispneia_p text, ie_delirium_p text ) RETURNS bigint AS $body$
DECLARE

    qt_pontuacao_karnofsky_w      real := 0;
    qt_pontuacao_ingestao_oral_w  real := 0;
    qt_pontuacao_edema_w          real := 0;
    qt_pontuacao_dispneia_w       real := 0;
    qt_pontuacao_delirium_w       real := 0;
    qt_pontos_w                   real;

BEGIN
    IF ( coalesce(ie_karnofskya_p,0) <= 20 ) THEN
        qt_pontuacao_karnofsky_w := 4;
    ELSIF ( coalesce(ie_karnofskya_p,0) <= 50 ) THEN
        qt_pontuacao_karnofsky_w := 2.5;
    END IF;

    IF ( coalesce(ie_ingestao_oral_p,0) = 1 ) THEN
        qt_pontuacao_ingestao_oral_w := 2.5;
    ELSIF ( coalesce(ie_ingestao_oral_p,0) = 2 ) THEN
        qt_pontuacao_ingestao_oral_w := 1;
    END IF;

    IF ( ie_edema_p = 'S' ) THEN
        qt_pontuacao_edema_w := 1;
    END IF;
    IF ( ie_dispneia_p = 'S' ) THEN
        qt_pontuacao_dispneia_w := 3.5;
    END IF;

    IF ( ie_delirium_p = 'S' ) THEN
        qt_pontuacao_delirium_w := 4;
    END IF;

    qt_pontos_w := (coalesce(qt_pontuacao_karnofsky_w,0)      + 
                    coalesce(qt_pontuacao_ingestao_oral_w,0)  + 
                    coalesce(qt_pontuacao_edema_w,0)          + 
                    coalesce(qt_pontuacao_dispneia_w,0)       + 
                    coalesce(qt_pontuacao_delirium_w,0));

    RETURN coalesce(qt_pontos_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_esc_pall_prog_md ( ie_karnofskya_p bigint, ie_ingestao_oral_p bigint, ie_edema_p text, ie_dispneia_p text, ie_delirium_p text ) FROM PUBLIC;
