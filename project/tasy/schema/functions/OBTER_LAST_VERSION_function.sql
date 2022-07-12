-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_last_version ( NR_SEQUENCIA_P bigint ) RETURNS bigint AS $body$
DECLARE

QT_VERSION_W bigint;

BEGIN

SELECT  count(1)
  INTO STRICT QT_VERSION_W
  FROM PROTOCOLO_INTEGRADO
 WHERE NR_SEQ_VERSAO_ANT = NR_SEQUENCIA_p;

RETURN QT_VERSION_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_last_version ( NR_SEQUENCIA_P bigint ) FROM PUBLIC;

