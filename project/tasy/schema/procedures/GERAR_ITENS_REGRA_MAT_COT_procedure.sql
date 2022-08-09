-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_regra_mat_cot ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


cd_material_w				integer;
cd_unidade_medida_compra_w		varchar(30);
cd_unidade_compra_w			varchar(30);
cd_estabelecimento_w			smallint;
ie_grava_proprio_mat_w			varchar(1);

c01 CURSOR FOR
SELECT	a.cd_material,
	substr(obter_dados_material_estab(a.cd_material,cd_estabelecimento_w,'UMC'),1,30) cd_unidade_medida_compra
from	material a
where	a.cd_material_estoque = cd_material_w
and	a.ie_situacao = 'A'
and	ie_opcao_p = 'E'
and	((ie_grava_proprio_mat_w = 'S') or (ie_grava_proprio_mat_w = 'N' and a.cd_material <> cd_material_w))
and not exists (
	SELECT	1
	from	regra_mat_cot_item x
	where	x.cd_material = a.cd_material
	and	x.nr_seq_regra_mat = nr_sequencia_p)

union

select	a.cd_material,
	substr(obter_dados_material_estab(a.cd_material,cd_estabelecimento_w,'UMC'),1,30) cd_unidade_medida_compra
from	material a
where	a.cd_material_generico = cd_material_w
and	a.ie_situacao = 'A'
and	ie_opcao_p = 'G'
and	((ie_grava_proprio_mat_w = 'S') or (ie_grava_proprio_mat_w = 'N' and a.cd_material <> cd_material_w))
and not exists (
	select	1
	from	regra_mat_cot_item x
	where	x.cd_material = a.cd_material
	and	x.nr_seq_regra_mat = nr_sequencia_p);


BEGIN

select	cd_material,
	obter_dados_material(cd_material,'UMP'),
	cd_estabelecimento
into STRICT	cd_material_w,
	cd_unidade_compra_w,
	cd_estabelecimento_w
from	regra_material_cotacao
where	nr_sequencia = nr_sequencia_p;

select	coalesce(max(obter_valor_param_usuario(915, 154, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 'S')
into STRICT	ie_grava_proprio_mat_w
;

open C01;
loop
fetch C01 into
	cd_material_w,
	cd_unidade_medida_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_unidade_compra_w = cd_unidade_medida_compra_w) then

		insert into regra_mat_cot_item(
			nr_sequencia,
			nr_seq_regra_mat,
			dt_atualizacao,
			nm_usuario,
			cd_material,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (nextval('regra_mat_cot_item_seq'),
			nr_sequencia_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_material_w,
			clock_timestamp(),
			nm_usuario_p);
	end if;
	end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_regra_mat_cot ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
