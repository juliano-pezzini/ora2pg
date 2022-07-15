-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_aceitaveis_cotacao ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_w			bigint;
cd_material_w			integer;
qt_material_w			double precision;
qt_conv_compra_estoque_w		double precision;
qt_material_conv_w			double precision;
cd_estabelecimento_w		bigint;

c01 CURSOR FOR
SELECT	a.cd_material
from	regra_mat_cot_item a
where	a.nr_seq_regra_mat = nr_seq_regra_w;


BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	cot_compra
where	nr_cot_compra = nr_cot_compra_p;

select	cd_material,
	(qt_material * obter_dados_material(cd_material,'QCE'))
into STRICT	cd_material_w,
	qt_material_w
from (
	SELECT	max(cd_material) cd_material,
		max(qt_material) qt_material
	from	cot_compra_item
	where	nr_cot_compra		= nr_cot_compra_p
	and	nr_item_cot_compra	= nr_item_cot_compra_p) alias4;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_regra_w
from	regra_material_cotacao
where	cd_material = cd_material_w
and	cd_estabelecimento = cd_estabelecimento_w;

delete	from cot_compra_item_aceite
where	nr_cot_compra		= nr_cot_compra_p
and	nr_item_cot_compra	= nr_item_cot_compra_p;

if (nr_seq_regra_w > 0) then
	open C01;
	loop
	fetch C01 into
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	qt_conv_compra_estoque
		into STRICT	qt_conv_compra_estoque_w
		from	material
		where	cd_material = cd_material_w;

		qt_material_conv_w := round((dividir(qt_material_w,qt_conv_compra_estoque_w))::numeric,0);

		if (qt_material_conv_w > 0) then

			insert into cot_compra_item_aceite(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_cot_compra,
				nr_item_cot_compra,
				cd_material,
				qt_material)
			values (nextval('cot_compra_item_aceite_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_cot_compra_p,
				nr_item_cot_compra_p,
				cd_material_w,
				qt_material_conv_w);
		end if;
		end;
	end loop;
	close C01;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_aceitaveis_cotacao ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

