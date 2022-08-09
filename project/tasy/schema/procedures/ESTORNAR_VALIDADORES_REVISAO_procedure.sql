-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_validadores_revisao ( NM_USUARIO_P text, NR_SEQ_REVISAO_P text) AS $body$
BEGIN

IF (NR_SEQ_REVISAO_P IS NOT NULL AND NR_SEQ_REVISAO_P::text <> '')THEN
    UPDATE	QUA_DOC_REVISAO_VALIDACAO
    SET     DT_VALIDACAO  = NULL,
            DT_ATUALIZACAO = clock_timestamp(),
            NM_USUARIO = NM_USUARIO_P
    WHERE   NR_SEQ_DOC_REVISAO = NR_SEQ_REVISAO_P;
END IF;
COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_validadores_revisao ( NM_USUARIO_P text, NR_SEQ_REVISAO_P text) FROM PUBLIC;
