-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_alterar_grau_satisfacao_os ( nm_usuario_p text, nr_sequencia_p bigint, ie_grau_satisfacao_p text, nr_seq_estagio_p bigint, ds_justificativa_p text) AS $body$
BEGIN

	if (coalesce(nr_sequencia_p, 0) > 0) then
		begin
		update	man_ordem_servico
		set	ie_grau_satisfacao 	= ie_grau_satisfacao_p,
			ds_justif_grau_satisf	= ds_justificativa_p,
			nr_seq_estagio		=coalesce(nr_seq_estagio_p, nr_seq_estagio),
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario 		= nm_usuario_p
		where	nr_sequencia 		= nr_sequencia_p;
		commit;
		end;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_alterar_grau_satisfacao_os ( nm_usuario_p text, nr_sequencia_p bigint, ie_grau_satisfacao_p text, nr_seq_estagio_p bigint, ds_justificativa_p text) FROM PUBLIC;

