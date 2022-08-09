-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE privacy_verify_state_rule ( NR_SEQUENCIA_P bigint) AS $body$
DECLARE


IE_SITUACAO_W	PRIVACY_RULE.IE_SITUACAO%TYPE;


BEGIN

SELECT	IE_SITUACAO
INTO STRICT	IE_SITUACAO_W
FROM	PRIVACY_RULE
WHERE	NR_SEQUENCIA = NR_SEQUENCIA_P;


IF (IE_SITUACAO_W = 'I') THEN
	CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(836848);
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE privacy_verify_state_rule ( NR_SEQUENCIA_P bigint) FROM PUBLIC;
