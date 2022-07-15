-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE com_gravar_acesso_hist ( nr_seq_cliente_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w	integer;
/*
IE_OPCAO_P
N - Novo historico
L - Historico lido
*/
BEGIN

select	count(*)
into STRICT	qt_registro_w
from	com_cliente_hist_acesso
where	nr_seq_cliente = nr_seq_cliente_p
and	nm_usuario = nm_usuario_p;

if (qt_registro_w = 0) then
	insert into com_cliente_hist_acesso(
		nr_sequencia,
		nr_seq_cliente,
		dt_ultima_visao,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec
	) values (
		nextval('com_cliente_hist_acesso_seq'),
		nr_seq_cliente_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp()
	);
	commit;
elsif (ie_opcao_p = 'N') then
	update	com_cliente_hist_acesso
	set	dt_atualizacao = clock_timestamp()
	where	nr_seq_cliente = nr_seq_cliente_p
	and	nm_usuario = nm_usuario_p;

	update	com_cliente_hist_acesso
	set	dt_ultima_visao  = NULL,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_cliente = nr_seq_cliente_p
	and	nm_usuario <> nm_usuario_p;

	commit;
elsif (ie_opcao_p = 'L') then
	update	com_cliente_hist_acesso
	set	dt_ultima_visao = clock_timestamp(),
		dt_atualizacao = clock_timestamp()
	where	nr_seq_cliente = nr_seq_cliente_p
	and	nm_usuario = nm_usuario_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE com_gravar_acesso_hist ( nr_seq_cliente_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

