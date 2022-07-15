-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_estagio_os ( nr_seq_ordem_p bigint, nr_seq_estagio_alt_p bigint, ds_historico_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') and (nr_seq_estagio_alt_p IS NOT NULL AND nr_seq_estagio_alt_p::text <> '') and (ds_historico_p IS NOT NULL AND ds_historico_p::text <> '') then

	update	man_ordem_servico
	set	nr_seq_estagio = nr_seq_estagio_alt_p
	where	nr_sequencia = nr_seq_ordem_p;

	insert into man_ordem_serv_tecnico(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		ds_relat_tecnico,
		nr_seq_ordem_serv,
		nm_usuario_lib,
		ie_origem,
		dt_historico,
		dt_liberacao,
		nr_seq_tipo)
	values (	nextval('man_ordem_serv_tecnico_seq'),
		nm_usuario_p,
		clock_timestamp(),
		ds_historico_p,
		nr_seq_ordem_p,
		nm_usuario_p,
		'I',
		clock_timestamp(),
		clock_timestamp(),
		7);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_estagio_os ( nr_seq_ordem_p bigint, nr_seq_estagio_alt_p bigint, ds_historico_p text, nm_usuario_p text) FROM PUBLIC;

