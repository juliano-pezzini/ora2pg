-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_lote_audit_rec_estagio ( nm_usuario_p text, nr_seq_lote_p bigint, nr_seq_estagio_p bigint, nr_seq_ret_hit_p bigint default null) AS $body$
BEGIN
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') and (nr_seq_estagio_p IS NOT NULL AND nr_seq_estagio_p::text <> '') then
	insert  into lote_audit_rec_estagio(
			dt_atualizacao,
			dt_estagio,
			nm_usuario,
			nr_seq_lote_audit_rec,
			nr_seq_ret_hist,
			nr_sequencia,
			nr_seq_est_lote_rec)
		values (
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_lote_p,
			nr_seq_ret_hit_p,
			nextval('lote_audit_rec_estagio_seq'),
			nr_seq_estagio_p);
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_lote_audit_rec_estagio ( nm_usuario_p text, nr_seq_lote_p bigint, nr_seq_estagio_p bigint, nr_seq_ret_hit_p bigint default null) FROM PUBLIC;
