-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adic_objeto_excecoes_ccb ( nm_objeto_p text, nr_seq_ordem_serv_p bigint, ds_motivo_p text, nm_usuario_p text ) AS $body$
BEGIN

	if (nm_objeto_p IS NOT NULL AND nm_objeto_p::text <> '') and (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then

		insert into ccb_excecao_objeto(
			nr_sequencia,
			nr_seq_ordem_serv,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nm_objeto,
			ds_motivo
		) values (
			nextval('ccb_excecao_objeto_seq'),
			nr_seq_ordem_serv_p,
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_objeto_p,
			ds_motivo_p
		);

		commit;

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adic_objeto_excecoes_ccb ( nm_objeto_p text, nr_seq_ordem_serv_p bigint, ds_motivo_p text, nm_usuario_p text ) FROM PUBLIC;

