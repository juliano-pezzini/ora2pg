-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_score_escala_candida_md (IE_COLON_CANDIDA_P text, IE_CIRURGIA_UTI_P text, IE_NPT_P text, IE_SEPSE_P text ) RETURNS bigint AS $body$
DECLARE


   qt_score_w	bigint := 0;

BEGIN
    --- Inicio MD
    if (IE_COLON_CANDIDA_P = 'S') then
        qt_score_w	:= qt_score_w + 1;
    end if;

    if (IE_CIRURGIA_UTI_P = 'S') then
        qt_score_w	:= qt_score_w + 1;
    end if;

    if (IE_NPT_P = 'S') then
        qt_score_w	:= qt_score_w + 1;
    end if;

    if (IE_SEPSE_P = 'S') then
        qt_score_w	:= qt_score_w + 2;
    end if;
    --- Fim MD
    RETURN coalesce(qt_score_w,0);
   
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_score_escala_candida_md (IE_COLON_CANDIDA_P text, IE_CIRURGIA_UTI_P text, IE_NPT_P text, IE_SEPSE_P text ) FROM PUBLIC;

