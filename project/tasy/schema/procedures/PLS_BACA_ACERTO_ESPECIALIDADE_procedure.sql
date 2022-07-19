-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_acerto_especialidade () AS $body$
DECLARE


cd_medico_w		varchar(10);
nr_seq_prestador_w	bigint;
cd_especialidade_w	integer;
qt_registro_w		integer;

c01 CURSOR FOR
SELECT	a.cd_pessoa_fisica,
	a.cd_especialidade
from	medico_especialidade a
where	a.ie_plano_saude = 'S'
order by
	a.cd_pessoa_fisica,
	a.cd_especialidade;

c02 CURSOR FOR
SELECT	a.nr_sequencia
from	pls_prestador a
where	a.cd_pessoa_fisica	= cd_medico_w

union all

select	a.nr_seq_prestador
from	pls_prestador_medico a
where	a.cd_medico		= cd_medico_w;


BEGIN

open c01;
loop
fetch c01 into
	cd_medico_w,
	cd_especialidade_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	open c02;
	loop
	fetch c02 into
		nr_seq_prestador_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		select	count(*)
		into STRICT	qt_registro_w
		from	pls_prestador_med_espec a
		where	a.nr_seq_prestador	= nr_seq_prestador_w
		and	a.cd_pessoa_fisica	= cd_medico_w
		and	a.cd_especialidade	= cd_especialidade_w;

		if (qt_registro_w = 0) then

			insert into pls_prestador_med_espec(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_prestador,
				cd_pessoa_fisica,
				cd_especialidade)
			values (nextval('pls_prestador_med_espec_seq'),
				'Tasy',
				clock_timestamp(),
				'Tasy',
				clock_timestamp(),
				nr_seq_prestador_w,
				cd_medico_w,
				cd_especialidade_w);
		end if;
		end;
	end loop;
	close c02;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_acerto_especialidade () FROM PUBLIC;

