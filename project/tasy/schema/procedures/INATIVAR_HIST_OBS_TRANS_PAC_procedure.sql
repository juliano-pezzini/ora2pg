-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inativar_hist_obs_trans_pac ( NR_SEQUENCIA_P bigint, DT_INATIVACAO_P timestamp, NM_USUARIO_INATIVACAO_P text, DS_JUSTIFICATIVA_P text) AS $body$
BEGIN

UPDATE	GESTAO_TRANSP_OBSERVACAO
SET	DT_INATIVACAO = DT_INATIVACAO_P,
	NM_USUARIO_INATIVACAO = NM_USUARIO_INATIVACAO_P,
	DS_JUSTIFICATIVA = DS_JUSTIFICATIVA_P,
	IE_SITUACAO = 'I'
WHERE	NR_SEQUENCIA = NR_SEQUENCIA_P;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inativar_hist_obs_trans_pac ( NR_SEQUENCIA_P bigint, DT_INATIVACAO_P timestamp, NM_USUARIO_INATIVACAO_P text, DS_JUSTIFICATIVA_P text) FROM PUBLIC;

