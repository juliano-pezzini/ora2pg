-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_dados_302_pck.gerar_dataset_slga ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_seq_dataset_w	d302_dataset_envio.nr_sequencia%type;

	
BEGIN
		nr_seq_dataset_w := gerar_dados_302_pck.inserir_dataset(nr_seq_lote_p, 'SLGA', nm_usuario_p, null, nr_seq_dataset_w); --ajustar o "null"
		CALL GERAR_D302_SEGMENTO_UNH(nr_seq_dataset_w,nm_usuario_p);

		CALL GERAR_D302_SEGMENTO_FKT(nr_seq_dataset_w,nm_usuario_p);
		CALL GERAR_D302_SEGMENTO_REC(nr_seq_dataset_w,nm_usuario_p);
		CALL GERAR_D302_SEGMENTO_UST(nr_seq_dataset_w,nm_usuario_p);
		CALL GERAR_D302_SEGMENTO_SKO(nr_seq_dataset_w,nm_usuario_p);
		CALL GERAR_D302_SEGMENTO_GES(nr_seq_dataset_w,nm_usuario_p);
		CALL GERAR_D302_SEGMENTO_NAM(nr_seq_dataset_w,nm_usuario_p);

		CALL GERAR_D302_SEGMENTO_UNH(nr_seq_dataset_w,nm_usuario_p);

		commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dados_302_pck.gerar_dataset_slga ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
