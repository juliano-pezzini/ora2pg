-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_descredenciar_cooperado ( nr_seq_cooperado_p bigint, nr_seq_motivo_descred_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_prest_medico_w		bigint;
nr_seq_prestador_w		bigint;
cd_pessoa_fisica_w		varchar(10);

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_prestador_medico	a
	where	a.cd_medico	= cd_pessoa_fisica_w;

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_prestador	a
	where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;


BEGIN

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from	pls_cooperado
where	nr_sequencia	= nr_seq_cooperado_p;

if (coalesce(cd_pessoa_fisica_w,'X') <> 'X') then
	open C01;
	loop
	fetch C01 into
		nr_seq_prest_medico_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL pls_descredenciar_prestador(nr_seq_prest_medico_w, 2, clock_timestamp(), nm_usuario_p, nr_seq_motivo_descred_p);
		end;
	end loop;
	close C01;

	open C02;
	loop
	fetch C02 into
		nr_seq_prestador_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL pls_descredenciar_prestador(nr_seq_prestador_w, 1, clock_timestamp(), nm_usuario_p, nr_seq_motivo_descred_p);
		end;
	end loop;
	close C02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_descredenciar_cooperado ( nr_seq_cooperado_p bigint, nr_seq_motivo_descred_p bigint, nm_usuario_p text) FROM PUBLIC;

