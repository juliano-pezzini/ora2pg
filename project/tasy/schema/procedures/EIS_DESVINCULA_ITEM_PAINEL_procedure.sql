-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eis_desvincula_item_painel ( nr_seq_painel_p bigint, nr_seq_grafico_p bigint, nr_seq_painel_controle_p bigint) AS $body$
DECLARE


nr_sequencia_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	FROM	painel_grafico
	WHERE	nr_seq_painel = nr_seq_painel_p
	AND	coalesce(nr_seq_grafico,0) = coalesce(nr_seq_grafico_p,0)
	AND	coalesce(nr_seq_painel_controle,0) = coalesce(nr_seq_painel_controle_p,0);

BEGIN

OPEN C01;
LOOP
FETCH C01 INTO nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
		DELETE	FROM painel_grafico
		WHERE	nr_sequencia = nr_sequencia_w;
	END;
END LOOP;
CLOSE C01;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_desvincula_item_painel ( nr_seq_painel_p bigint, nr_seq_grafico_p bigint, nr_seq_painel_controle_p bigint) FROM PUBLIC;
