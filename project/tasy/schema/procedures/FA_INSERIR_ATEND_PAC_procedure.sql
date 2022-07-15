-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fa_inserir_atend_pac ( nr_sequencia_p bigint, nr_atendimento_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	update	fa_paciente_entrega
	set	nr_atendimento = nr_atendimento_p
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fa_inserir_atend_pac ( nr_sequencia_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

