-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_desfazer_reinf_2070 (nr_seq_superior_p bigint, nm_usuario_p text, lote_desfeito_p INOUT text) AS $body$
DECLARE


nr_sequencia_w  FIS_REINF_TITULOS_R2070.nr_sequencia%TYPE;

c01 CURSOR FOR
	SELECT	nr_sequencia
	FROM    FIS_REINF_TITULOS_R2070
	WHERE	NR_SEQ_SUPERIOR 	= nr_seq_superior_p;

BEGIN
  lote_desfeito_p := 'N';

   OPEN c01;
   LOOP
   FETCH c01 INTO
	   nr_sequencia_w;
   EXIT WHEN NOT FOUND; /* apply on c01 */
	   DELETE FROM FIS_REINF_TITULOS_R2070 WHERE nr_sequencia = nr_sequencia_w;
	   CALL FIS_DESFAZER_ded_reinf_2070(nr_seq_superior_p,nm_usuario_p);
	   lote_desfeito_p := 'S';
   END LOOP;
   CLOSE c01;

   update FIS_REINF_R2070 set dt_geracao  = NULL where nr_sequencia = nr_seq_superior_p;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_desfazer_reinf_2070 (nr_seq_superior_p bigint, nm_usuario_p text, lote_desfeito_p INOUT text) FROM PUBLIC;

