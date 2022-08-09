-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_emprestimo ( nr_emprestimo_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE


qt_mat_dev_w	double precision;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select	sum(qt_material)
	into STRICT	qt_mat_dev_w
	from	emprestimo_material_dev
	where	nr_emprestimo = nr_emprestimo_p
	and	nr_sequencia = nr_sequencia_p;

	if (qt_mat_dev_w IS NOT NULL AND qt_mat_dev_w::text <> '') then
		update	emprestimo_material
		set	qt_material = qt_emprestimo - qt_mat_dev_w
		where	nr_emprestimo = nr_emprestimo_p
		and	nr_sequencia = nr_sequencia_p;
	else
		update	emprestimo_material
		set	qt_material = qt_emprestimo
		where	nr_emprestimo = nr_emprestimo_p
		and	nr_sequencia = nr_sequencia_p;
	end if;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_emprestimo ( nr_emprestimo_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
