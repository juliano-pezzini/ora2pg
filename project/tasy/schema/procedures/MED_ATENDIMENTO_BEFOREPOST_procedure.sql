-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_atendimento_beforepost ( nr_seq_cliente_p bigint, qt_primeira_consulta_p INOUT bigint) AS $body$
DECLARE


qt_primeira_consulta_w	bigint;


BEGIN

if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
	begin

	/* Verifica se o cliente já fez primeira consulta */

	select	count(*)
	into STRICT	qt_primeira_consulta_w
	from	med_cliente
	where	(dt_primeira_consulta IS NOT NULL AND dt_primeira_consulta::text <> '')
	and	nr_sequencia = nr_seq_cliente_p;

	if (qt_primeira_consulta_w = 0) then
		begin
		/* Atualiza a primeira e a ultima data de consulta */

		CALL med_inserir_data_consulta(nr_seq_cliente_p, 'PU');
		end;
	else
		begin
		/* Atualiza a ultima data de consulta */

		CALL med_inserir_data_consulta(nr_seq_cliente_p, 'U');
		end;
	end if;

	qt_primeira_consulta_p := qt_primeira_consulta_w;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_atendimento_beforepost ( nr_seq_cliente_p bigint, qt_primeira_consulta_p INOUT bigint) FROM PUBLIC;
