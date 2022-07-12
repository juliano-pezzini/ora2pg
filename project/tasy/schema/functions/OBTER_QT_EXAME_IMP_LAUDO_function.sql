-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_exame_imp_laudo (PNR_ATENDIMENTO NUMERIC) RETURNS bigint AS $body$
DECLARE

QT_EXAME_W  bigint;

BEGIN
  SELECT COUNT(1) INTO STRICT QT_EXAME_W
    FROM ATEND_EXAME_TRAZIDO
   WHERE NR_ATENDIMENTO = PNR_ATENDIMENTO
     AND COALESCE(IE_IMPORTANTE_LAUDO,'N') = 'S';

RETURN QT_EXAME_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_exame_imp_laudo (PNR_ATENDIMENTO NUMERIC) FROM PUBLIC;
