-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_historico_fluxo_lote ( nr_seq_lote_fluxo_p bigint, ie_origem_p text, ds_historico_p text, nm_usuario_p text) AS $body$
DECLARE


/* ie_origem_p
'S' = Sistema
'U' = Usuário
'SA' = Sistema (marcado como alterado o lote)
*/
BEGIN
if (ie_origem_p = 'U') or (ie_origem_p = 'S') then

	insert into fluxo_caixa_lote_hist(
		nr_sequencia,
		nr_seq_lote_fluxo,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		ie_origem,
		dt_historico,
		ds_historico)
	values (nextval('fluxo_caixa_lote_hist_seq'),
		nr_seq_lote_fluxo_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		ie_origem_p,
		clock_timestamp(),
		ds_historico_p);

elsif (ie_origem_p = 'SA') then

	insert into fluxo_caixa_lote_hist(
		nr_sequencia,
		nr_seq_lote_fluxo,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		ie_origem,
		dt_historico,
		ds_historico)
	values (nextval('fluxo_caixa_lote_hist_seq'),
		nr_seq_lote_fluxo_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		'S',
		clock_timestamp(),
		ds_historico_p);

	update	fluxo_caixa_lote
	set	ie_alterado	= 'S'
	where	nr_sequencia	= nr_seq_lote_fluxo_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_historico_fluxo_lote ( nr_seq_lote_fluxo_p bigint, ie_origem_p text, ds_historico_p text, nm_usuario_p text) FROM PUBLIC;

