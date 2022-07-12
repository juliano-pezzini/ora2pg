-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dias_entrega ( DT_ENTREGA_P timestamp, DT_PREV_ENTREGA_P timestamp ) RETURNS bigint AS $body$
DECLARE


QTDE_DIAS_W		     	bigint;
HOJE_W             			timestamp;
PREVISAO_ENTREGA_W 		timestamp;


BEGIN

IF (coalesce(DT_PREV_ENTREGA_P::text, '') = '') THEN
  PREVISAO_ENTREGA_W := PKG_DATE_UTILS.START_OF(clock_timestamp(), 'DD');
ELSE
  PREVISAO_ENTREGA_W := PKG_DATE_UTILS.START_OF(DT_PREV_ENTREGA_P, 'DD');
END IF;

IF (DT_ENTREGA_P IS NOT NULL AND DT_ENTREGA_P::text <> '') THEN
  QTDE_DIAS_W := 0;
ELSE
  HOJE_W      := PKG_DATE_UTILS.START_OF(clock_timestamp(), 'DD');
  QTDE_DIAS_W := (PREVISAO_ENTREGA_W - HOJE_W);
END IF;

RETURN QTDE_DIAS_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dias_entrega ( DT_ENTREGA_P timestamp, DT_PREV_ENTREGA_P timestamp ) FROM PUBLIC;
