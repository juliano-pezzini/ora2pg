-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_material ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
DECLARE


qt_commit_w		integer := 0;
dt_atual_w		timestamp := trunc(clock_timestamp());
ds_informacao_w		w_pls_inconsistencia_mat.ds_informacao%type;

C00 CURSOR FOR  -- Inconsistencias
	SELECT	nr_sequencia,
		ds_inconsistencia,
		ie_consiste
	from	pls_inconsistencia_mat
	where	cd_estabelecimento	= cd_estabelecimento_p
	order by 1;

C01 CURSOR FOR  -- Materiais
	SELECT	o.nr_sequencia,
		o.cd_material,
		o.cd_material_ops,
		o.ie_situacao,
		o.dt_inclusao_ref,
		o.dt_fim_vigencia_ref,
		o.nr_seq_material_unimed,
		o.cd_material_a900,
		o.cd_tiss_brasindice,
		o.cd_simpro,
		(SELECT	max(b.cd_medicamento)
		from	material_brasindice b
		where	b.cd_medicamento = o.cd_tiss_brasindice
		and	b.cd_material	= o.cd_material) cd_tiss_brasindice_prest,
		(select	max(s.cd_simpro)
		from	material_simpro s
		where	s.cd_simpro	= o.cd_simpro
		and	s.cd_material	= o.cd_material) cd_simpro_prest
	from	pls_material o;

type 			fetch_array is table of c00%rowtype;
s_array 		fetch_array;
i			integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c00_w		vetor;

BEGIN
-- Limpar as tabelas por tempo
delete FROM w_pls_inconsistencia_mat where dt_atualizacao < clock_timestamp() - interval '1 days';
commit;

-- Limpar as tabelas por usuário
delete FROM w_pls_inconsistencia_mat where nm_usuario = nm_usuario_p;
commit;

-- Carregar as inconsistencias
open c00;
loop
fetch c00 bulk collect into s_array limit 100;
	vetor_c00_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c00 */
end loop;
close c00;
s_array	:= Vetor_c00_w(1);

-- Consistir os materiais
for r_c01_w in c01 loop

	-- 1 - Material da operadora gerado por material A900 está sem vinculo com material hospital.
	if (s_array[1].ie_consiste = 'S') then

		if (r_c01_w.ie_situacao = 'A') and -- Ativo
			(dt_atual_w between r_c01_w.dt_inclusao_ref and r_c01_w.dt_fim_vigencia_ref) and -- Ativo
			((r_c01_w.nr_seq_material_unimed IS NOT NULL AND r_c01_w.nr_seq_material_unimed::text <> '') or (r_c01_w.cd_material_a900 IS NOT NULL AND r_c01_w.cd_material_a900::text <> '')) and -- Origem A900
			(coalesce(r_c01_w.cd_material::text, '') = '') then -- Sem Material Hospital
			ds_informacao_w := substr('Seq mat: '|| r_c01_w.nr_sequencia ||' Cód OPS: '||r_c01_w.cd_material_ops||' Seq A900: '||r_c01_w.nr_seq_material_unimed,1,4000);

			insert into w_pls_inconsistencia_mat(nr_sequencia,dt_atualizacao,nm_usuario,nr_seq_incons_mat,ds_informacao,nr_seq_material)
							values (nextval('w_pls_inconsistencia_mat_seq'),clock_timestamp(),nm_usuario_p,s_array[1].nr_sequencia,ds_informacao_w,r_c01_w.nr_sequencia);

		end if;
	end if;

	-- 2 - Divergência de código brasíndice entre material prestador e material operadora.
	if (s_array[2].ie_consiste = 'S') then

		if (r_c01_w.cd_tiss_brasindice IS NOT NULL AND r_c01_w.cd_tiss_brasindice::text <> '') and -- OPS tem Brasindice
			(coalesce(r_c01_w.cd_tiss_brasindice_prest::text, '') = '') and -- Brasindice divergente
			(r_c01_w.cd_material IS NOT NULL AND r_c01_w.cd_material::text <> '') then -- Tem Material Hospital
			ds_informacao_w := substr('Seq mat: '|| r_c01_w.nr_sequencia ||' Cód OPS: '||r_c01_w.cd_material_ops||' Cód hosp: '||r_c01_w.cd_material||' Brasíndice OPS: '||r_c01_w.cd_tiss_brasindice,1,4000);

			insert into w_pls_inconsistencia_mat(nr_sequencia,dt_atualizacao,nm_usuario,nr_seq_incons_mat,ds_informacao,nr_seq_material)
							values (nextval('w_pls_inconsistencia_mat_seq'),clock_timestamp(),nm_usuario_p,s_array[2].nr_sequencia,ds_informacao_w,r_c01_w.nr_sequencia);

		end if;

	end if;

	-- 3 - Divergência de código simpro entre material prestador e material operadora.
	if (s_array[3].ie_consiste = 'S') then

		if (r_c01_w.cd_simpro IS NOT NULL AND r_c01_w.cd_simpro::text <> '') and -- OPS tem Simpro
			(coalesce(r_c01_w.cd_simpro_prest::text, '') = '') and -- Simpro divergente
			(r_c01_w.cd_material IS NOT NULL AND r_c01_w.cd_material::text <> '') then -- Tem Material Hospital
			ds_informacao_w := substr('Seq mat: '|| r_c01_w.nr_sequencia ||' Cód OPS: '||r_c01_w.cd_material_ops||' Cód hosp: '||r_c01_w.cd_material||' Simpro OPS: '||r_c01_w.cd_simpro,1,4000);

			insert into w_pls_inconsistencia_mat(nr_sequencia,dt_atualizacao,nm_usuario,nr_seq_incons_mat,ds_informacao,nr_seq_material)
							values (nextval('w_pls_inconsistencia_mat_seq'),clock_timestamp(),nm_usuario_p,s_array[3].nr_sequencia,ds_informacao_w,r_c01_w.nr_sequencia);

		end if;

	end if;

	qt_commit_w := qt_commit_w + 1;
	if (qt_commit_w = 500) then
		commit;
		qt_commit_w := 0;
	end if;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_material ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;

