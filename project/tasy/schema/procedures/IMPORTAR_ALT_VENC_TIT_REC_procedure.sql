-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_alt_venc_tit_rec ( cd_motivo_p bigint, ds_observacao_p text, dt_alteracao_p timestamp, dt_atualizacao_p timestamp, dt_vencimento_p timestamp, nm_usuario_p text, nr_titulo_externo_p text) AS $body$
DECLARE

/*


cd_motivo				1 - Prorrogação de Vencimento
					2 - Antecipação de Vencimento

*/
nr_sequencia_w		bigint;
dt_anterior_w		timestamp;
nr_titulo_w		bigint;


BEGIN

SELECT	MAX(nr_titulo)
INTO STRICT	nr_titulo_w
FROM	titulo_receber
WHERE	nr_titulo_externo = nr_titulo_externo_p;

IF (coalesce(nr_titulo_w::text, '') = '') THEN
	--R.AISE_APPLICATION_ERROR(-20011,'Título não encontrado');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(267406);
ELSE
	SELECT 	coalesce(MAX(nr_sequencia),0) + 1
	INTO STRICT	nr_sequencia_w
	FROM	alteracao_vencimento
	WHERE	nr_titulo = nr_titulo_w;

	SELECT	dt_vencimento
	INTO STRICT	dt_anterior_w
	FROM	titulo_receber
	WHERE	nr_titulo = nr_titulo_w;
END IF;

INSERT 	INTO 	alteracao_vencimento(nr_sequencia,
					cd_motivo,
					ds_observacao,
					dt_alteracao,
					dt_anterior,
					dt_atualizacao,
					dt_vencimento,
					nm_usuario,
					nr_titulo)
			VALUES (nr_sequencia_w,
					cd_motivo_p,
					ds_observacao_p,
					dt_alteracao_p,
					dt_anterior_w,
					dt_atualizacao_p,
					dt_vencimento_p,
					nm_usuario_p,
					nr_titulo_w);

UPDATE	titulo_receber
SET	dt_pagamento_previsto	= dt_vencimento_p
WHERE	nr_titulo		= nr_titulo_w;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_alt_venc_tit_rec ( cd_motivo_p bigint, ds_observacao_p text, dt_alteracao_p timestamp, dt_atualizacao_p timestamp, dt_vencimento_p timestamp, nm_usuario_p text, nr_titulo_externo_p text) FROM PUBLIC;
