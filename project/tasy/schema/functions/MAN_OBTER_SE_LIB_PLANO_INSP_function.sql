-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_lib_plano_insp ( nr_seq_plano_insp_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_atualizacao_w	varchar(1) := 'N';
qt_existe_w		bigint;
nr_seq_regra_w		bigint;
cd_perfil_w		integer := Obter_perfil_Ativo;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	man_plano_insp_lib
where	nr_seq_plano_inspecao = nr_seq_plano_insp_p;

if (qt_existe_w = 0) then
	ie_atualizacao_w := 'S';
else
	begin
	/* Regra Usuário */

	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_w
	from	man_plano_insp_lib
	where	nm_usuario_lib = nm_usuario_p
	and	nr_seq_plano_inspecao = nr_seq_plano_insp_p;

	if (coalesce(nr_seq_regra_w,0) = 0) then
		begin
		/* Regra Perfil */

		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_w
		from	man_plano_insp_lib
		where	cd_perfil = cd_perfil_w
		and	nr_seq_plano_inspecao = nr_seq_plano_insp_p;

		if (coalesce(nr_seq_regra_w,0) = 0) then
			begin
			/* Regra Grupo de planejamento e trabalho */

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_regra_w
			from	man_plano_insp_lib a
			where	a.nr_seq_plano_inspecao = nr_seq_plano_insp_p
			and exists (	SELECT	1
					from	man_grupo_trab_usuario z,
						man_grupo_planej_trab y,
						man_grupo_trabalho x
					where	x.nr_sequencia = y.nr_seq_grupo_trab
					and	x.nr_sequencia = z.nr_seq_grupo_trab
					and	y.nr_seq_grupo_planej = a.nr_seq_grupo_planej
					and	x.nr_sequencia = a.nr_seq_grupo_trab
					and	z.nm_usuario_param = nm_usuario_p);

			if (coalesce(nr_seq_regra_w,0) = 0) then
				begin
				/* Regra Grupo de trabalho */

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_regra_w
				from	man_plano_insp_lib a
				where	a.nr_seq_plano_inspecao = nr_seq_plano_insp_p
				and exists (	SELECT	1
						from	man_grupo_trab_usuario z,
							man_grupo_planej_trab y,
							man_grupo_trabalho x
						where	x.nr_sequencia = y.nr_seq_grupo_trab
						and	x.nr_sequencia = z.nr_seq_grupo_trab
						and	x.nr_sequencia = a.nr_seq_grupo_trab
						and	z.nm_usuario_param = nm_usuario_p);

				if (coalesce(nr_seq_regra_w,0) = 0) then
					begin
					/* Regra Grupo de planejamento */

					select	max(a.nr_sequencia)
					into STRICT	nr_seq_regra_w
					from	man_plano_insp_lib a
					where	a.nr_seq_plano_inspecao = nr_seq_plano_insp_p
					and exists (	SELECT	1
							from	man_grupo_trab_usuario z,
								man_grupo_planej_trab y,
								man_grupo_trabalho x
							where	x.nr_sequencia = y.nr_seq_grupo_trab
							and	x.nr_sequencia = z.nr_seq_grupo_trab
							and	y.nr_seq_grupo_planej = a.nr_seq_grupo_planej
							and	z.nm_usuario_param = nm_usuario_p);

					if (coalesce(nr_seq_regra_w,0) = 0) then
						select	max(nr_sequencia)
						into STRICT	nr_seq_regra_w
						from	man_plano_insp_lib
						where	coalesce(nm_usuario_lib::text, '') = ''
						and	coalesce(cd_perfil::text, '') = ''
						and	coalesce(nr_seq_grupo_planej::text, '') = ''
						and	coalesce(nr_seq_grupo_trab::text, '') = ''
						and	nr_seq_plano_inspecao = nr_seq_plano_insp_p;
					end if;
					end;
				end if;
				end;
			end if;
			end;
		end if;
		end;
	end if;

	if (coalesce(nr_seq_regra_w,0) > 0) then
		select	ie_atualizacao
		into STRICT	ie_atualizacao_w
		from	man_plano_insp_lib
		where	nr_sequencia = nr_seq_regra_w;
	end if;
	end;
end if;

return	ie_atualizacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_lib_plano_insp ( nr_seq_plano_insp_p bigint, nm_usuario_p text) FROM PUBLIC;

