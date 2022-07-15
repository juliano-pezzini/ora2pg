-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_conta_paciente_adiant ( nr_interno_conta_p bigint, nr_adiantamento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') and (nr_adiantamento_p IS NOT NULL AND nr_adiantamento_p::text <> '') and (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	delete
	from	conta_paciente_adiant
	where	nr_interno_conta	= nr_interno_conta_p
	and	nr_adiantamento		= nr_adiantamento_p
	and	nr_sequencia		= nr_sequencia_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_conta_paciente_adiant ( nr_interno_conta_p bigint, nr_adiantamento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

