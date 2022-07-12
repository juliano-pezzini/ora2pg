-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hora_min_aplicacao_md ( qt_dose_ml_item_p bigint, qt_hora_min_aplicacao_p bigint, qt_conversao_p bigint ) RETURNS bigint AS $body$
DECLARE

    qt_hora_min_aplicacao_aux_w double precision := qt_hora_min_aplicacao_p;

BEGIN

    qt_hora_min_aplicacao_aux_w := dividir_sem_round_md((qt_dose_ml_item_p * qt_hora_min_aplicacao_aux_w), qt_conversao_p);

    RETURN qt_hora_min_aplicacao_aux_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hora_min_aplicacao_md ( qt_dose_ml_item_p bigint, qt_hora_min_aplicacao_p bigint, qt_conversao_p bigint ) FROM PUBLIC;

