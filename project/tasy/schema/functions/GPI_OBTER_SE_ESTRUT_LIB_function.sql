-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_se_estrut_lib ( nr_seq_estrutura_p bigint, nr_seq_proj_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


type vetor is table of bigint index by integer;

vetor_w			vetor;
vetor_aux_w		vetor;

cd_perfil_ativo_w		bigint	:= obter_perfil_ativo;
cd_perfil_w		bigint;
ie_permite_w		varchar(1)	:= 'X';
ie_regra_w		varchar(1)	:= 'N';

nm_usuario_lib_w		varchar(15);
qt_regra_w		bigint;
nr_seq_estrutura_w		bigint;
cd_empresa_w		bigint;
nr_seq_superior_w		bigint;
nr_seq_grupo_w		bigint;

nr_seq_estrutura_ww	bigint;

i			integer;
k			integer;

ie_continua_w		boolean;

c01 CURSOR FOR
SELECT	y.nr_seq_estrutura,
	y.ie_permissao_regra
from (
select	b.nr_seq_estrutura,
	substr(gpi_obter_se_proj_lib(b.nr_seq_estrutura, a.nr_seq_proj_gpi, nm_usuario_p),1,1) ie_permissao_regra
from	gpi_estrut_proj_lib a,
	gpi_projeto b
where	a.nr_seq_proj_gpi = b.nr_sequencia
and	coalesce(a.nm_usuario_lib,nm_usuario_p)	= nm_usuario_p
and	coalesce(a.cd_perfil,cd_perfil_ativo_w)	= cd_perfil_ativo_w
and	coalesce(a.nr_seq_grupo::text, '') = ''
and	(a.nr_seq_proj_gpi IS NOT NULL AND a.nr_seq_proj_gpi::text <> '')

union all

select	b.nr_seq_estrutura,
	substr(gpi_obter_se_proj_lib(b.nr_seq_estrutura, a.nr_seq_proj_gpi, nm_usuario_p),1,1) ie_permissao_regra
from	gpi_estrut_proj_lib a,
	gpi_projeto b
where	a.nr_seq_proj_gpi = b.nr_sequencia
and	coalesce(a.nm_usuario_lib,nm_usuario_p)	= nm_usuario_p
and	coalesce(a.cd_perfil,cd_perfil_ativo_w)	= cd_perfil_ativo_w
and	(a.nr_seq_grupo IS NOT NULL AND a.nr_seq_grupo::text <> '')
and	(a.nr_seq_proj_gpi IS NOT NULL AND a.nr_seq_proj_gpi::text <> '')
and 	exists (	select	1
		from	usuario_grupo x
		where 	x.nm_usuario_grupo	= nm_usuario_p
		and 	x.nr_seq_grupo	= a.nr_seq_grupo
		and	x.ie_situacao	= 'A')) y
where	y.ie_permissao_regra in ('S','V');

c02 CURSOR FOR
SELECT	coalesce(nm_usuario_lib,'A'),
	coalesce(nr_seq_grupo,0),
	coalesce(cd_perfil,0),
	a.ie_permite
from	gpi_estrut_proj_lib a
where	coalesce(a.nr_seq_proj_gpi::text, '') = ''
and	coalesce(a.nm_usuario_lib,nm_usuario_p)	= nm_usuario_p
and	coalesce(a.cd_perfil,cd_perfil_ativo_w)	= cd_perfil_ativo_w
and	coalesce(a.nr_seq_grupo::text, '') = ''
and	a.nr_seq_estrutura = nr_seq_estrutura_w

union all

select	coalesce(nm_usuario_lib,'A'),
	coalesce(nr_seq_grupo,0),
	coalesce(cd_perfil,0),
	a.ie_permite
from	gpi_estrut_proj_lib a
where	coalesce(a.nr_seq_proj_gpi::text, '') = ''
and	coalesce(a.nm_usuario_lib,nm_usuario_p)	= nm_usuario_p
and	coalesce(a.cd_perfil,cd_perfil_ativo_w)	= cd_perfil_ativo_w
and	nr_seq_estrutura = nr_seq_estrutura_w
and	(a.nr_seq_grupo IS NOT NULL AND a.nr_seq_grupo::text <> '')
and 	exists (	select	1
		from	usuario_grupo x
		where 	x.nm_usuario_grupo	= nm_usuario_p
		and 	x.nr_seq_grupo	= a.nr_seq_grupo
		and	x.ie_situacao	= 'A')
order by 1,2,3;

c03 CURSOR FOR
SELECT	nr_sequencia
from	gpi_estrutura
where	nr_seq_superior = nr_seq_superior_w;


BEGIN
if (coalesce(nr_seq_proj_p,0) > 0) then
	select	nr_seq_estrutura
	into STRICT	nr_seq_estrutura_ww
	from	gpi_projeto
	where	nr_sequencia = nr_seq_proj_p;
else
	nr_seq_estrutura_ww := nr_seq_estrutura_p;
end if;

begin
select	coalesce(cd_empresa,0)
into STRICT	cd_empresa_w
from	gpi_estrutura
where	nr_sequencia = nr_seq_estrutura_ww;
exception when others then
	cd_empresa_w	:= 0;
end;

select	count(1)
into STRICT	qt_regra_w
from	gpi_estrut_proj_lib
where	cd_empresa = cd_empresa_w;

if (qt_regra_w > 0) then
	begin
	if (coalesce(nr_seq_proj_p,0) > 0) then
		begin
		ie_regra_w := substr(gpi_obter_se_proj_lib(nr_seq_estrutura_ww, nr_seq_proj_p, nm_usuario_p),1,1);

		if (ie_regra_w in ('S','N','V')) then
			ie_permite_w := ie_regra_w;
		end if;
		end;
	else
		begin
		open c01;
		loop
		fetch c01 into
			nr_seq_estrutura_w,
			ie_regra_w;
		exit when ((c01%notfound) or (ie_permite_w = 'S'));
			begin
			if (nr_seq_estrutura_w = nr_seq_estrutura_ww) then
				ie_permite_w := 'S';
			else
				begin
				while (nr_seq_estrutura_w IS NOT NULL AND nr_seq_estrutura_w::text <> '' AND ie_permite_w <> 'S') loop
					begin
					select	nr_seq_superior
					into STRICT	nr_seq_superior_w
					from	gpi_estrutura
					where	nr_sequencia = nr_seq_estrutura_w;

					nr_seq_estrutura_w := nr_seq_superior_w;

					if (nr_seq_estrutura_w = nr_seq_estrutura_ww) then
						ie_permite_w := 'S';
					end if;
					end;
				end loop;
				end;
			end if;
			end;
		end loop;
		close c01;
		end;
	end if;

	if (ie_permite_w = 'X') then
		begin
		ie_regra_w 		:= 'X';
		nr_seq_estrutura_w 	:= nr_seq_estrutura_ww;

		open c02;
		loop
		fetch c02 into
			nm_usuario_lib_w,
			nr_seq_grupo_w,
			cd_perfil_w,
			ie_regra_w;
		exit when(c02%notfound);
		end loop;
		close c02;

		if (ie_regra_w <> 'X') then
			ie_permite_w := ie_regra_w;
		end if;
		end;
	end if;

	if (ie_permite_w = 'X') then
		begin
		if (coalesce(nr_seq_proj_p,0) = 0) then
			begin
			vetor_w.delete;
			vetor_w(0) 	:= nr_seq_estrutura_ww;
			ie_continua_w	:= true;

			while(ie_continua_w) loop
				begin
				i	:= 0;
				while(i < vetor_w.count) and (ie_permite_w = 'X') loop
					begin
					nr_seq_estrutura_w := vetor_w(i);

					open c02;
					loop
					fetch c02 into
						nm_usuario_lib_w,
						nr_seq_grupo_w,
						cd_perfil_w,
						ie_regra_w;
					exit when(c02%notfound);
					end loop;
					close c02;

					if (ie_regra_w in ('S','V')) then
						ie_permite_w := 'S';
					end if;

					i := (i+1);
					end;
				end loop;

				if (ie_permite_w = 'S') then
					ie_continua_w := false;
				else
					begin
					vetor_aux_w.delete;
					k := 0;
					i := 0;

					while(i < vetor_w.count) loop
						begin
						nr_seq_superior_w := vetor_w(i);

						open c03;
						loop
						fetch c03 into
							nr_seq_estrutura_w;
						EXIT WHEN NOT FOUND; /* apply on c03 */
							begin
							if (nr_seq_estrutura_w IS NOT NULL AND nr_seq_estrutura_w::text <> '') then
								begin
								vetor_aux_w(k) := nr_seq_estrutura_w;
								k := (k + 1);
								end;
							end if;
							end;
						end loop;
						close c03;

						i := i+1;
						end;
					end loop;

					if (vetor_aux_w.count > 0) then
						begin
						vetor_w.delete;
						vetor_w := vetor_aux_w;
						end;
					else
						ie_continua_w := false;
					end if;
					end;
				end if;
				end;
			end loop;
			end;
		end if;

		if (ie_permite_w = 'X') then
			begin
			nr_seq_estrutura_w := nr_seq_estrutura_ww;

			while(nr_seq_estrutura_w IS NOT NULL AND nr_seq_estrutura_w::text <> '') and (ie_permite_w = 'X') loop
				begin
				open c02;
				loop
				fetch c02 into
					nm_usuario_lib_w,
					nr_seq_grupo_w,
					cd_perfil_w,
					ie_regra_w;
				exit when(c02%notfound);
				end loop;
				close c02;

				if (ie_regra_w in ('S','V')) then
					ie_permite_w := 'S';
				else
					begin
					select	nr_seq_superior
					into STRICT	nr_seq_superior_w
					from	gpi_estrutura
					where	nr_sequencia = nr_seq_estrutura_w;

					nr_seq_estrutura_w := nr_seq_superior_w;
					end;
				end if;
				end;
			end loop;
			end;
		end if;
		end;
	end if;
	end;
else
	ie_permite_w := 'S';
end if;

if (ie_permite_w not in ('S','V')) then
	ie_permite_w := 'N';
end if;

return	ie_permite_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gpi_obter_se_estrut_lib ( nr_seq_estrutura_p bigint, nr_seq_proj_p bigint, nm_usuario_p text) FROM PUBLIC;
