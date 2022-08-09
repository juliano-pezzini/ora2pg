-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_historico_cobr_orgao ( nr_seq_titulo_p bigint, nr_seq_cheque_cr_p bigint, nr_seq_lote_p bigint, ds_historico_p text, nm_usuario_p text, ie_hist_destino_p text) AS $body$
BEGIN

if (ie_hist_destino_p = 'P') then

	insert into tit_cheque_orgao_cobr_hist(
						nr_sequencia,
						nr_seq_titulo,
						nr_seq_cheque_cr,
						ds_historico,
						dt_atualizacao,
						nm_usuario,
						dt_historico,
						ie_origem)
					values (nextval('tit_cheque_orgao_cobr_hist_seq'),
						nr_seq_titulo_p,
						nr_seq_cheque_cr_p,
						ds_historico_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						'S');
elsif (ie_hist_destino_p = 'E') then

	insert into lote_orgao_cobr_hist(
						nr_sequencia,
						nr_seq_lote,
						ds_historico,
						dt_atualizacao,
						nm_usuario,
						dt_historico,
						ie_origem)
					values (nextval('lote_orgao_cobr_hist_seq'),
						nr_seq_lote_p,
						ds_historico_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						'S');

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_historico_cobr_orgao ( nr_seq_titulo_p bigint, nr_seq_cheque_cr_p bigint, nr_seq_lote_p bigint, ds_historico_p text, nm_usuario_p text, ie_hist_destino_p text) FROM PUBLIC;
