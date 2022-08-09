-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_atendimento_visita_grupo (nr_seq_atend_visita_p bigint, nr_seq_grupo_acesso_p bigint, nr_atendimento_p bigint, dt_acompanhante_p timestamp, qt_acessos_p bigint, nr_cracha_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_w		bigint;
cd_entrada_w		varchar(15);
cd_saida_w		varchar(15);
cd_grupo_w		bigint;
nr_seq_wgrupo_w		bigint;
nr_atendimento_w	bigint;
dt_acompanhante_w	timestamp;

c01 CURSOR FOR
	SELECT	a.nr_atendimento,
		a.dt_acompanhante
	from	atendimento_acompanhante a
	where	not exists (SELECT	1
			from	atendimento_visita_grupo b
			where	b.nr_atendimento = a.nr_atendimento
			and	b.dt_acompanhante = a.dt_acompanhante
			and	b.nr_sequencia	= nr_seq_grupo_acesso_p)
	and	nr_atendimento = nr_atendimento_p;


BEGIN

select	nextval('atendimento_visita_grupo_seq')
into STRICT	nr_seq_w
;

insert into atendimento_visita_grupo(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_atend_visita,
	nr_seq_grupo_acesso,
	nr_atendimento,
	dt_acompanhante,
	qt_acessos)
values (nr_seq_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_atend_visita_p,
	nr_seq_grupo_acesso_p,
	nr_atendimento_p,
	dt_acompanhante_p,
	qt_acessos_p);

commit;

select	max(cd_entrada),
	max(cd_saida),
	max(cd_grupo)
into STRICT	cd_entrada_w,
	cd_saida_w,
	cd_grupo_w
from	controle_acesso_visita
where	nr_sequencia	= nr_seq_grupo_acesso_p;

if (cd_entrada_w IS NOT NULL AND cd_entrada_w::text <> '') then
	select	nextval('w_grupo_acesso_seq')
	into STRICT	nr_seq_wgrupo_w
	;

	insert into w_grupo_acesso(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_cracha,
		cd_grupo,
		cd_entrada_saida,
		qt_acesso,
		nr_seq_atend)
	values (nr_seq_wgrupo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_cracha_p,
		cd_grupo_w,
		cd_entrada_w,
		qt_acessos_p,
		nr_seq_w);

	select	nextval('w_grupo_acesso_seq')
	into STRICT	nr_seq_wgrupo_w
	;

	insert into w_grupo_acesso(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_cracha,
		cd_grupo,
		cd_entrada_saida,
		qt_acesso,
		nr_seq_atend)
	values (nr_seq_wgrupo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_cracha_p,
		cd_grupo_w,
		cd_saida_w,
		qt_acessos_p,
		nr_seq_w);

	commit;
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (coalesce(dt_acompanhante_p::text, '') = '') then

	open c01;
	loop
	fetch c01 into
		nr_atendimento_w,
		dt_acompanhante_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		select	nextval('atendimento_visita_grupo_seq')
		into STRICT	nr_seq_w
		;

		insert into atendimento_visita_grupo(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_atend_visita,
			nr_seq_grupo_acesso,
			nr_atendimento,
			dt_acompanhante,
			qt_acessos)
		values (nr_seq_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_atend_visita_p,
			nr_seq_grupo_acesso_p,
			nr_atendimento_w,
			dt_acompanhante_w,
			qt_acessos_p);

		commit;

		select	max(cd_entrada),
			max(cd_saida),
			max(cd_grupo)
		into STRICT	cd_entrada_w,
			cd_saida_w,
			cd_grupo_w
		from	controle_acesso_visita
		where	nr_sequencia	= nr_seq_grupo_acesso_p;

		if (cd_entrada_w IS NOT NULL AND cd_entrada_w::text <> '') then
			select	nextval('w_grupo_acesso_seq')
			into STRICT	nr_seq_wgrupo_w
			;

			insert into w_grupo_acesso(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_cracha,
				cd_grupo,
				cd_entrada_saida,
				qt_acesso,
				nr_seq_atend)
			values (nr_seq_wgrupo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_cracha_p,
				cd_grupo_w,
				cd_entrada_w,
				qt_acessos_p,
				nr_seq_w);

			select	nextval('w_grupo_acesso_seq')
			into STRICT	nr_seq_wgrupo_w
			;

			insert into w_grupo_acesso(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_cracha,
				cd_grupo,
				cd_entrada_saida,
				qt_acesso,
				nr_seq_atend)
			values (nr_seq_wgrupo_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_cracha_p,
				cd_grupo_w,
				cd_saida_w,
				qt_acessos_p,
				nr_seq_w);

			commit;
		end if;

	end loop;
	close c01;

end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_atendimento_visita_grupo (nr_seq_atend_visita_p bigint, nr_seq_grupo_acesso_p bigint, nr_atendimento_p bigint, dt_acompanhante_p timestamp, qt_acessos_p bigint, nr_cracha_p text, nm_usuario_p text) FROM PUBLIC;
