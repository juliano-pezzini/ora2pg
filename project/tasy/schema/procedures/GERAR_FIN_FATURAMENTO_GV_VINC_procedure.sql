-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fin_faturamento_gv_vinc ( nm_usuario_p text, nr_seq_viagem_p bigint, NR_SEQ_FAT_GV_P bigint, vl_despesa_p bigint, dt_lib_relat_p timestamp) AS $body$
BEGIN
insert into fin_faturamento_gv_vinc(	dt_atualizacao,
					dt_atualizacao_nrec,
					dt_lib_relat,
					nm_usuario,
					nm_usuario_nrec,
					nr_sequencia,
					nr_seq_viagem,
					vl_despesa,
					nr_seq_fat_gv)
				values (	clock_timestamp(),
					clock_timestamp(),
					dt_lib_relat_p,
					nm_usuario_p,
					nm_usuario_p,
					nextval('fin_faturamento_gv_vinc_seq'),
					nr_seq_viagem_p,
					vl_despesa_p,
					nr_seq_fat_gv_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fin_faturamento_gv_vinc ( nm_usuario_p text, nr_seq_viagem_p bigint, NR_SEQ_FAT_GV_P bigint, vl_despesa_p bigint, dt_lib_relat_p timestamp) FROM PUBLIC;
