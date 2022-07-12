-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/* Busca as regras de calculo para então obter a sequencia das fórmulas a serem executadas e gerar os valores */

CREATE OR REPLACE PROCEDURE sup_gerar_planej_pck.atualizar_valor_form_planej ( cd_empresa_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_seq_planejamento_w			bigint;
	nr_seq_grupo_w				bigint;
	nr_seq_regra_w				bigint;
	nr_seq_formula_planej_w			bigint;
	cd_material_w				integer;
	cd_estabelecimento_w			integer;
	qt_existe_w				bigint;
	vl_retorno_w				double precision;

	c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_grupo
	from	sup_planejamento_compras a,
		estabelecimento_v b
	where	a.cd_estabelecimento = b.cd_estabelecimento
	and	b.cd_empresa = cd_empresa_p
	and	(a.nr_seq_grupo IS NOT NULL AND a.nr_seq_grupo::text <> '')
	and	clock_timestamp() between dt_periodo_inicial and trunc(dt_periodo_final) + 86399/86400;

	c02 CURSOR FOR
	SELECT	a.nr_seq_formula_planej
	from	sup_reg_calc_com_formula a
	where	a.nr_seq_regra = nr_seq_regra_w
	order by	a.nr_ordem_calculo;

	c03 CURSOR FOR
	SELECT	a.cd_material,
		b.cd_estabelecimento
	from	segmento_compras_estrut a,
		segmento_compras b,
		segmento_compra_vinc_grupo c
	where	a.nr_seq_segmento = b.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_segmento
	and	(b.cd_estabelecimento IS NOT NULL AND b.cd_estabelecimento::text <> '')
	and	c.nr_seq_grupo = nr_seq_grupo_w
	
union all

	SELECT	a.cd_material,
		e.cd_estabelecimento
	from	estabelecimento_v e,
		segmento_compras_estrut a,
		segmento_compras b,
		segmento_compra_vinc_grupo c
	where	a.nr_seq_segmento = b.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_segmento
	and	coalesce(b.cd_estabelecimento::text, '') = ''
	and	c.nr_seq_grupo = nr_seq_grupo_w
	and	e.cd_empresa = cd_empresa_p
	and	e.ie_situacao = 'A'
	order by	1;

	
BEGIN

	open c01;
	loop
	fetch c01 into
		nr_seq_planejamento_w,
		nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	nr_seq_regra_calculo
		into STRICT	nr_seq_regra_w
		from	grupo_segmento_compras
		where	nr_sequencia = nr_seq_grupo_w;

		open c02;
		loop
		fetch c02 into
			nr_seq_formula_planej_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			open c03;
			loop
			fetch c03 into
				cd_material_w,
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin

				select	count(*)
				into STRICT	qt_existe_w
				from	w_valor_formula
				where	cd_estabelecimento = cd_estabelecimento_w
				and	cd_material = cd_material_w
				and	nr_seq_formula = nr_seq_formula_planej_w;

				if (qt_existe_w = 0) then
					begin

					vl_retorno_w := sup_gerar_planej_pck.gerar_valor_form_planej(
							nr_seq_formula_planej_w, cd_material_w, 'N', vl_retorno_w, cd_estabelecimento_w, nm_usuario_p);

					end;
				end if;

				end;
			end loop;
			close c03;

			end;
		end loop;
		close c02;

		end;
	end loop;
	close c01;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_planej_pck.atualizar_valor_form_planej ( cd_empresa_p bigint, nm_usuario_p text) FROM PUBLIC;