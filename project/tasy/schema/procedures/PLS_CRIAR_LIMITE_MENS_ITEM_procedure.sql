-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_criar_limite_mens_item () AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_regra
	from	pls_regra_limite_copartic	a
	where	not exists (SELECT	1
				from	pls_regra_limite_mens_item	x
				where	a.nr_sequencia	= x.nr_seq_regra
				and	x.ie_tipo_item	= '3');

BEGIN

for w_cursor_c01 in C01 loop
	begin

	update	pls_regra_limite_copartic
	set	dt_liberacao = clock_timestamp(),
		nm_usuario = 'tasy'
	where	nr_sequencia = w_cursor_c01.nr_seq_regra;

	insert into pls_regra_limite_mens_item(	nr_sequencia,
						nr_seq_regra,
						ie_tipo_item,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec)
					values (nextval('pls_regra_limite_mens_item_seq'),
						w_cursor_c01.nr_seq_regra,
						'3',
						clock_timestamp(),
						'tasy',
						clock_timestamp(),
						'tasy');
	commit;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_criar_limite_mens_item () FROM PUBLIC;
