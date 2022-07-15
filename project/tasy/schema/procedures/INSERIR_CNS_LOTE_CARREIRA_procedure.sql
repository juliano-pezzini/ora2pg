-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_cns_lote_carreira (nr_seq_lote_imp_p bigint, nr_seq_sus_p bigint, nr_cns_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_lote_imp_p IS NOT NULL AND nr_seq_lote_imp_p::text <> '') and (nr_seq_sus_p IS NOT NULL AND nr_seq_sus_p::text <> '') and (nr_cns_p IS NOT NULL AND nr_cns_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	insert into cns_lote_carteira_sus(
			nr_sequencia,
			nr_seq_lote_imp,
			nr_seq_sus,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_codigo_utilizado,
			nr_cns)
		values (nextval('cns_lote_carteira_sus_seq'),
			nr_seq_lote_imp_p,
			nr_seq_sus_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			'N',
			nr_cns_p);
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_cns_lote_carreira (nr_seq_lote_imp_p bigint, nr_seq_sus_p bigint, nr_cns_p bigint, nm_usuario_p text) FROM PUBLIC;

