-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_evento_eficacia_afterpost (NM_USUARIO_P text, IE_STATUS_P bigint, NR_SEQUENCIA_P text) AS $body$
DECLARE




QT_REG_W            integer;
QT_REG_WW           integer;

BEGIN
UPDATE QUA_NAO_CONFORMIDADE
SET    DT_ENCERRAMENTO   = clock_timestamp(),
       IE_STATUS         = OBTER_TEXTO_TASY(IE_STATUS_P, null),
	   NM_USUARIO        = NM_USUARIO_P,
	   DT_ATUALIZACAO    = clock_timestamp()
WHERE  NR_SEQUENCIA      = NR_SEQUENCIA_P;


SELECT  COUNT(*)
INTO STRICT    QT_REG_W
FROM    QUA_NAO_CONFORM_EFICACIA
WHERE NR_SEQ_NAO_CONFORM = NR_SEQUENCIA_P
AND IE_EFICACIA = 'S';


SELECT  COUNT(*)
INTO STRICT    QT_REG_WW
FROM    QUA_ANALISE_PROBLEMA
WHERE   NR_SEQ_RNC = NR_SEQUENCIA_P;

IF (QT_REG_W > 0
    AND QT_REG_WW > 0)THEN
    UPDATE QUA_ANALISE_PROBLEMA
    SET    IE_STATUS = OBTER_TEXTO_TASY(IE_STATUS_P, null),
           DT_ATUALIZACAO = clock_timestamp(),
           NM_USUARIO = NM_USUARIO_P
    WHERE  NR_SEQ_RNC = NR_SEQUENCIA_P;
END IF;

COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_evento_eficacia_afterpost (NM_USUARIO_P text, IE_STATUS_P bigint, NR_SEQUENCIA_P text) FROM PUBLIC;
