-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcula_escala_capurro_md (QT_TEXTURA_PELE_P bigint, QT_PREGAS_PLANTARES_P bigint, QT_GLANDULA_MAMARIA_P bigint, QT_FORMACAO_MAMILO_P bigint, QT_FORMATO_ORELHA_P bigint, qt_dias_p INOUT bigint, qt_semanas_p INOUT bigint ) AS $body$
DECLARE

	qt_pontuacao_w bigint;

BEGIN
    qt_pontuacao_w := coalesce(QT_TEXTURA_PELE_P,0)     + 
                      coalesce(QT_PREGAS_PLANTARES_P,0) + 
                      coalesce(QT_GLANDULA_MAMARIA_P,0) +
                      coalesce(QT_FORMACAO_MAMILO_P,0)  + 
                      coalesce(QT_FORMATO_ORELHA_P,0);

    qt_pontuacao_w  := coalesce(qt_pontuacao_w,0) + 204;

    qt_dias_p       := qt_pontuacao_w;
    qt_semanas_p    := dividir_md(qt_pontuacao_w,7);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcula_escala_capurro_md (QT_TEXTURA_PELE_P bigint, QT_PREGAS_PLANTARES_P bigint, QT_GLANDULA_MAMARIA_P bigint, QT_FORMACAO_MAMILO_P bigint, QT_FORMATO_ORELHA_P bigint, qt_dias_p INOUT bigint, qt_semanas_p INOUT bigint ) FROM PUBLIC;
