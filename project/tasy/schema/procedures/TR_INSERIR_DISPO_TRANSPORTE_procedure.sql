-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tr_inserir_dispo_transporte (NR_SEQ_DISPOSITIVO_P bigint, NR_SEQ_SOLICITACAO_P bigint) AS $body$
BEGIN

IF (NR_SEQ_DISPOSITIVO_P IS NOT NULL AND NR_SEQ_DISPOSITIVO_P::text <> '' AND NR_SEQ_SOLICITACAO_P IS NOT NULL AND NR_SEQ_SOLICITACAO_P::text <> '') THEN

INSERT INTO TRANS_SOLIC_DISPOSITIVO(NR_SEQUENCIA,
									DT_ATUALIZACAO,
									NM_USUARIO,
									NR_SEQ_DISPOSITIVO,
									NR_SEQ_SOLICITACAO)
							VALUES (nextval('trans_solic_dispositivo_seq'),
									clock_timestamp(),
									WHEB_USUARIO_PCK.GET_NM_USUARIO,
									NR_SEQ_DISPOSITIVO_P,
									NR_SEQ_SOLICITACAO_P);

END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tr_inserir_dispo_transporte (NR_SEQ_DISPOSITIVO_P bigint, NR_SEQ_SOLICITACAO_P bigint) FROM PUBLIC;

