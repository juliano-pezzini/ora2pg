-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/* Buscar os atributos e materiais para gerar seus valores (em outra procedure) */

CREATE OR REPLACE PROCEDURE pcs_sup_gerar_plano_pck.atualizar_atributos_planej ( cd_empresa_p bigint, nm_usuario_p text) AS $body$
DECLARE


	nr_seq_atributo_w			bigint;
	cd_material_w			integer;
	vl_retorno_w			double precision;

	c01 CURSOR FOR
	SELECT	nr_sequencia
	from	pcs_atributo;

/*	cursor	c02 is
	select	distinct
		a.cd_material
	from	segmento_compras_estrut a,
		segmento_compras b
	where	a.nr_seq_segmento = b.nr_sequencia
	and	a.cd_material is not null;*/
	c02 CURSOR FOR
	SELECT	distinct
			a.cd_material
	from	pcs_estrutura_segmento a,
			pcs_segmento b
	where	a.nr_seq_segmento = b.nr_sequencia
	and		(a.cd_material IS NOT NULL AND a.cd_material::text <> '');

	
BEGIN

	open c01;
	loop
	fetch c01 into
		nr_seq_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		open c02;
		loop
		fetch c02 into
			cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			vl_retorno_w := pcs_sup_gerar_plano_pck.gerar_valor_atrib_planej(
					nr_seq_atributo_w, cd_material_w, vl_retorno_w, 0, cd_empresa_p, nm_usuario_p);

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
-- REVOKE ALL ON PROCEDURE pcs_sup_gerar_plano_pck.atualizar_atributos_planej ( cd_empresa_p bigint, nm_usuario_p text) FROM PUBLIC;
