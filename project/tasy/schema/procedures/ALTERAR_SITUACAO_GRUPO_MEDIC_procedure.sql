-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_situacao_grupo_medic ( nr_sequencia_p bigint, ie_opcao_p text) AS $body$
BEGIN

IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') THEN

	UPDATE	med_grupo_medic
	SET	     ie_situacao	= ie_opcao_p
	WHERE	nr_sequencia	= nr_sequencia_p;

     UPDATE  med_medic_padrao
     SET     ie_situacao        = ie_opcao_p
     WHERE   nr_seq_grupo_medic = nr_sequencia_p;

	COMMIT;
END IF;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_situacao_grupo_medic ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

