-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_dados_ultima_compra () AS $body$
DECLARE



cd_estabelecimento_w			bigint;
nr_seq_nota_w				bigint;
cd_material_w				bigint;
nr_item_nf_w				bigint;
qt_registros_w				bigint;

c01 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	ie_situacao = 'A';


c02 CURSOR FOR
SELECT	distinct
	b.cd_material
from	nota_fiscal a,
	nota_fiscal_item b,
	natureza_operacao n,
	operacao_nota o
where	a.dt_atualizacao_estoque <= clock_timestamp()
and	a.nr_sequencia = b.nr_sequencia
and	n.cd_natureza_operacao = a.cd_natureza_operacao
and	a.cd_operacao_nf = o.cd_operacao_nf
and	n.ie_entrada_saida = 'E'
and	a.ie_situacao = '1'
and	coalesce(o.ie_devolucao,'N') = 'N'
and	a.ie_acao_nf = 1
and	coalesce(o.ie_ultima_compra, 'S') = 'S'
and	b.cd_estabelecimento = cd_estabelecimento_w
and	b.cd_material > 0
and not exists (
	SELECT	1
	from	sup_dados_ultima_compra x
	where	x.cd_material = b.cd_material
	and	x.cd_estabelecimento = a.cd_estabelecimento);


BEGIN

open C01;
loop
fetch C01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		nr_seq_nota_w	:= coalesce(OBTER_DADOS_ULT_COMPRA_DATA(cd_estabelecimento_w, cd_material_w, null, clock_timestamp(), 0, 'SN'),0);

		if (nr_seq_nota_w > 0) then

			select	coalesce(min(nr_item_nf),0)
			into STRICT	nr_item_nf_w
			from	nota_fiscal_item
			where	nr_sequencia = nr_seq_nota_w
			and	cd_material = cd_material_w;

			if (nr_item_nf_w > 0) then

			insert into sup_dados_ultima_compra(
				nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_nota,
				nr_seq_item,
				cd_material)
			values (	nextval('sup_dados_ultima_compra_seq'),
				cd_estabelecimento_w,
				clock_timestamp(),
				'Tasy01',
				clock_timestamp(),
				'Tasy01',
				nr_seq_nota_w,
				nr_item_nf_w,
				cd_material_w);

			commit;
			end if;

		end if;
		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_dados_ultima_compra () FROM PUBLIC;
