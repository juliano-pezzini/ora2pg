-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_atend_orcamento ( nr_seq_orcamento_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_seq_orcamento_p,0) <> 0) then

	update	orcamento_paciente
	set	nr_atendimento = nr_atendimento_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia_orcamento = nr_seq_orcamento_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_atend_orcamento ( nr_seq_orcamento_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

