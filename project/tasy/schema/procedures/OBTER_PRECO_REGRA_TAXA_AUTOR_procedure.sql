-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_preco_regra_taxa_autor (nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_preco_taxa_w	bigint;
nr_atendimento_w		bigint;
cd_material_w			integer;
cd_classe_material_w		integer;
cd_subgrupo_material_w		smallint;
cd_grupo_material_w		smallint;
cd_material_regra_w		integer;
cd_classe_material_regra_w	integer;
cd_subgrupo_material_regra_w	smallint;
cd_grupo_material_regra_w	smallint;
vl_autorizado_w			double precision;
vl_total_w			double precision;
vl_total_mat_w			double precision;
pr_total_w			double precision;
vl_limite_w			regra_preco_proc_crit.vl_limite%type;
vl_ajuste_w			double precision;
c01 CURSOR FOR
SELECT	pr_total,
	cd_material,
	cd_classe_material,
	cd_subgrupo_material,
	cd_grupo_material,
	coalesce(vl_limite,0)
from	regra_preco_proc_crit
where	nr_seq_regra	= nr_seq_regra_preco_taxa_w;


BEGIN

select	max(b.nr_seq_regra_preco),
	max(a.nr_atendimento)
into STRICT	nr_seq_regra_preco_taxa_w,
	nr_atendimento_w
from	procedimento_paciente a,
	regra_ajuste_proc b
where	a.nr_seq_ajuste_proc	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_procedimento_p;

if (nr_seq_regra_preco_taxa_w IS NOT NULL AND nr_seq_regra_preco_taxa_w::text <> '') then

	vl_total_w := 0;

	open C01;
	loop
	fetch C01 into
		pr_total_w,
		cd_material_regra_w,
		cd_classe_material_regra_w,
		cd_subgrupo_material_regra_w,
		cd_grupo_material_regra_w,
		vl_limite_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		vl_total_mat_w	:= 0;

		select	sum(a.vl_total_autorizado)
		into STRICT	vl_total_mat_w
		from	material_autorizado a,
			estrutura_material_v b,
			autorizacao_convenio c,
			estagio_autorizacao d
		where	a.cd_material		= b.cd_material
		and	a.nr_sequencia_autor	= c.nr_sequencia
		and	c.nr_seq_estagio	= d.nr_sequencia
		and	d.ie_interno		= '10' --Somente se autorizado
		and	c.nr_atendimento	= nr_atendimento_w
		and (a.cd_material		= cd_material_regra_w or
			b.cd_grupo_material	= cd_grupo_material_regra_w or
			b.cd_subgrupo_material	= cd_subgrupo_material_regra_w or
			b.cd_classe_material   	= cd_classe_material_regra_w);


		vl_ajuste_w	:= (vl_total_mat_w * (pr_total_w / 100));


		if (coalesce(vl_limite_w,0) > 0) and (vl_ajuste_w > vl_limite_w) then
			vl_ajuste_w := vl_limite_w;
		end if;

		vl_total_w	:= vl_total_w + vl_ajuste_w;

		end;
	end loop;
	close C01;

	update	procedimento_paciente
	set	vl_procedimento		= vl_total_w,
		ie_valor_informado	= 'S',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_procedimento_p;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_preco_regra_taxa_autor (nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

