-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_cux ( nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into d301_segmento_cux(NM_USUARIO,
	NR_SEQ_301_MOEDA,
	NR_SEQUENCIA,
	DT_ATUALIZACAO,
	DT_ATUALIZACAO_NREC,
	NM_USUARIO_NREC,
	NR_SEQ_DATASET,
	NR_SEQ_DATASET_RET)
values (nm_usuario_p,
	2, --EURO sempre padrão.
	nextval('d301_segmento_cux_seq'),
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_dataset_p,
	null);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_cux ( nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;
