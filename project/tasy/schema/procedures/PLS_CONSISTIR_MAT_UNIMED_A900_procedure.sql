-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_mat_unimed_a900 (nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_inconsistente_w		varchar(1);
cd_unidade_medida_tasy_w	varchar(255);
ie_consiste7_w			varchar(5);
ie_consiste8_w			varchar(5);
ie_consiste12_w			varchar(5);
ie_consiste13_w			varchar(5);

nr_cont_w			integer := 0;
qt_commit_w			integer := 0;

tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
tb_ie_inconsistente_w		pls_util_cta_pck.t_varchar2_table_1;

C01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_mat_unimed,
		upper(trim(both a.cd_unidade_medida)) ie_unidade_utilizacao,
		a.cd_cnpj cd_cgc,
		a.ie_situacao ie_situacao,
		coalesce(coalesce((SELECT max(b.cd_unidade_medida) from unidade_medida b where b.ie_situacao = 'A' and upper(b.cd_sistema_ant) = upper(trim(both a.cd_unidade_medida))),
			(select max(b.cd_unidade_medida) from unidade_medida b where b.ie_situacao = 'A' and upper(b.cd_unidade_medida) = upper(trim(both a.cd_unidade_medida)))),
				(select max(b.cd_unidade_medida) from unidade_medida b where b.ie_situacao = 'A' and upper(b.cd_unidade_ptu) = upper(trim(both a.cd_unidade_medida)))) cd_unidade_medida,
		(select	max(b.nr_seq_marca)
		from	marca_pessoa_juridica b
		where	b.cd_cgc = a.cd_cnpj) nr_seq_marca,
		(select count(1)
		from	pls_material x,
			pls_pacote_material z
		where	x.nr_sequencia = z.nr_seq_material
		and	x.nr_seq_material_unimed = a.nr_sequencia  LIMIT 1) qt_pacote,
		(select	upper(max(x.cd_unidade_medida))
		from	pls_material x
		where	x.nr_seq_material_unimed = a.nr_sequencia) cd_unidade_medida_pls,
		(select	upper(max(x.cd_unidade_medida))
		from	pls_material x,
			pls_material_a900 p
		where	x.nr_sequencia		= p.nr_seq_material
		and	p.nr_seq_material_unimed = a.nr_sequencia) cd_unidade_medida_ptu,
		(select	upper(max(b.cd_unidade_ptu))
		from	pls_material x,
			unidade_medida b
		where	x.cd_unidade_medida	= b.cd_unidade_medida
		and	x.nr_seq_material_unimed = a.nr_sequencia) cd_unidade_pls,
		(select	upper(max(b.cd_unidade_ptu))
		from	pls_material x,
			unidade_medida b,
			pls_material_a900 p
		where	x.cd_unidade_medida	= b.cd_unidade_medida
		and	x.nr_sequencia		= p.nr_seq_material
		and	p.nr_seq_material_unimed = a.nr_sequencia) cd_unidade_ptu
	from	pls_material_unimed	a
	where 	coalesce(a.dt_vinculo::text, '') = '';

BEGIN

delete	FROM pls_mat_unimed_inc;
commit;

ie_consiste7_w := ptu_obter_se_consiste_mat(7, ie_consiste7_w); -- 7 - A unidade de medida nao esta cadastrada no sistema.
ie_consiste8_w := ptu_obter_se_consiste_mat(8, ie_consiste8_w); -- 8 - A unidade de medida importada e diferente da cadastrada para o material no Tasy.
ie_consiste12_w := ptu_obter_se_consiste_mat(12, ie_consiste12_w); -- 12 - A marca informada nao esta cadastrada no sistema.
ie_consiste13_w := ptu_obter_se_consiste_mat(13, ie_consiste13_w); -- 13 - O material inativado esta vinculado a um pacote.
for r_c01_w in c01 loop
	ie_inconsistente_w := 'N';
	qt_commit_w := qt_commit_w + 1;
	
	if (coalesce(r_c01_w.cd_unidade_medida::text, '') = '') then
		-- 7 - A unidade de medida nao esta cadastrada no sistema.
		if (ie_consiste7_w = 'S') then
			CALL ptu_inserir_inconsistencia_mat(r_c01_w.nr_seq_mat_unimed, 7, nm_usuario_p);
			ie_inconsistente_w := 'S';
		end if;
	else
		cd_unidade_medida_tasy_w := coalesce(r_c01_w.cd_unidade_medida_pls,r_c01_w.cd_unidade_medida_ptu);
		
		if (cd_unidade_medida_tasy_w IS NOT NULL AND cd_unidade_medida_tasy_w::text <> '') and (cd_unidade_medida_tasy_w <> r_c01_w.cd_unidade_medida) then
			--Caso detectar diferenca entre a unidade de medida que esta sendo importada e ja cadastrada para o material, entao

			--faz uma verificacao adicional com a unidade ptu dessa unidade de medida(vinculada ao pls_material)
			cd_unidade_medida_tasy_w := coalesce(r_c01_w.cd_unidade_pls,r_c01_w.cd_unidade_ptu);
			
			--Caso nao  tiver um cd_unidade_pls ou tambem for diferente do que esta sendo importado, entao prossegue com processamento e gera inconsistencia
			if (coalesce(cd_unidade_medida_tasy_w::text, '') = '') and (cd_unidade_medida_tasy_w <> r_c01_w.cd_unidade_medida) then
				
				-- 8 - A unidade de medida importada e diferente da cadastrada para o material no Tasy.
				if (ie_consiste8_w = 'S') then
					CALL ptu_inserir_inconsistencia_mat(r_c01_w.nr_seq_mat_unimed, 8, nm_usuario_p);
					ie_inconsistente_w := 'S';
				end if;	
			end if;
		end if;
	end if;
	
	if (coalesce(r_c01_w.nr_seq_marca::text, '') = '') then
		-- 12 - A marca informada nao esta cadastrada no sistema.
		if (ie_consiste12_w = 'S') then
			CALL ptu_inserir_inconsistencia_mat(r_c01_w.nr_seq_mat_unimed, 12, nm_usuario_p);
			ie_inconsistente_w := 'S';
		end if;	
	end if;
	
	if (r_c01_w.qt_pacote > 0) and (r_c01_w.ie_situacao = 'I') then
		-- 13 - O material inativado esta vinculado a um pacote.
		if (ie_consiste13_w = 'S') then
			CALL ptu_inserir_inconsistencia_mat(r_c01_w.nr_seq_mat_unimed, 13, nm_usuario_p);
			ie_inconsistente_w := 'S';
		end if;	
	end if;
	
	if (qt_commit_w = 10000) then
		commit;
		qt_commit_w := 0;
	end if;	
	
	tb_nr_sequencia_w(nr_cont_w) := r_c01_w.nr_seq_mat_unimed;
	tb_ie_inconsistente_w(nr_cont_w) := ie_inconsistente_w;
	nr_cont_w := nr_cont_w + 1;
end loop;

if (tb_nr_sequencia_w.count > 0) then
	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		update	pls_material_unimed
		set	ie_inconsistente	= tb_ie_inconsistente_w(i)
		where	nr_sequencia		= tb_nr_sequencia_w(i);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_mat_unimed_a900 (nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
