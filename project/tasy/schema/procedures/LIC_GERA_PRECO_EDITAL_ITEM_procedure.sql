-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gera_preco_edital_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, ie_opcao_preco_p bigint, ie_somente_zerados_p text, ie_itens_definir_p text, pr_inflacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_preco_p
0 - Vencedor das cotações da licitação
1 - Valor ultima compra do item
2 - Média dos fornecedores da cotação da licitação*/
/*ie_itens_definir_p
0 - Define somente o item selecionado no grid
1 - Define todos os itens ao mesmo tempo*/
vl_maximo_edital_w				double precision;
nr_seq_lic_item_w				integer;
qt_existe_w				bigint;
pr_taxa_inflacao_w				double precision;
cd_material_w				integer;
qt_item_w				double precision;
vl_total_item_w				double precision;
nr_item_cot_compra_w			bigint;
nr_cot_compra_w				bigint;
vl_maximo_ant_w				double precision;

c01 CURSOR FOR
SELECT	nr_seq_lic_item,
	qt_item
from	reg_lic_item
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	nr_seq_lic_item	= nr_seq_lic_item_p
and	ie_itens_definir_p	= 0

union all

select	nr_seq_lic_item,
	qt_item
from	reg_lic_item
where	nr_seq_licitacao = nr_seq_licitacao_p
and	((ie_somente_zerados_p = 'N') or
	((ie_somente_zerados_p = 'S') and (coalesce(vl_maximo_edital,0) = 0)))
and	ie_itens_definir_p = 1;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	reg_lic_edital
where	nr_seq_licitacao = nr_seq_licitacao_p
and	(dt_homologacao_edital IS NOT NULL AND dt_homologacao_edital::text <> '');

if (qt_existe_w > 0) then
	/*(-20011,'Não é possível gerar os preços para os itens, pois o edital desta licitação já foi homologado.');*/

	CALL wheb_mensagem_pck.exibir_mensagem_abort(190869);
end if;

open C01;
loop
fetch C01 into
	nr_seq_lic_item_w,
	qt_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_opcao_preco_p = 0) then
		begin

		select	coalesce(max(x.nr_cot_compra),0)
		into STRICT	nr_cot_compra_w
		from	cot_compra x
		where	x.nr_seq_reg_licitacao = nr_seq_licitacao_p;

		if (nr_cot_compra_w > 0) then
			begin
			select	max(cd_material)
			into STRICT	cd_material_w
			from	reg_lic_item
			where	nr_seq_licitacao	= nr_seq_licitacao_p
			and	nr_seq_lic_item	= nr_seq_lic_item_w;

			select	coalesce(max(a.nr_item_cot_compra),0)
			into STRICT	nr_item_cot_compra_w
			from	cot_compra_item a
			where	a.nr_cot_compra	= nr_cot_compra_w
			and	a.cd_material	= cd_material_w;

			if (nr_item_cot_compra_w > 0) then
				begin
				select	min(a.vl_unitario_material)
				into STRICT	vl_maximo_edital_w
				from	cot_compra_forn_item a
				where	a.nr_cot_compra = nr_cot_compra_w
				and	coalesce(a.ie_considera_media_lic,'S') = 'S'
				and	a.nr_item_cot_compra = nr_item_cot_compra_w
				and	a.vl_unitario_material > 0;
				end;
			end if;
			end;
		end if;
		end;
	elsif (ie_opcao_preco_p = 1) then
		begin
		select	coalesce(obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'),0)
		into STRICT	vl_maximo_edital_w
		from	reg_licitacao a,
			reg_lic_item b
		where	a.nr_sequencia	= b.nr_seq_licitacao
		and	a.nr_sequencia	= nr_seq_licitacao_p
		and	b.nr_seq_lic_item	= nr_seq_lic_item_w;
		end;

	elsif (ie_opcao_preco_p = 2) then
		begin
		if (pr_inflacao_p > 0) then
			select	coalesce((coalesce(obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'),0) +
				(dividir(coalesce(obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'),0),100) * pr_taxa_inflacao_w)),0) vl_ult_compra_inflacao
			into STRICT	vl_maximo_edital_w
			from	reg_licitacao a,
				reg_lic_item b
			where	a.nr_sequencia	= b.nr_seq_licitacao
			and	a.nr_sequencia	= nr_seq_licitacao_p
			and	b.nr_seq_lic_item	= nr_seq_lic_item_w;
		else
			select	coalesce(obter_dados_ult_compra_data(a.cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VU'),0) vl_ult_compra_inflacao
			into STRICT	vl_maximo_edital_w
			from	reg_licitacao a,
				reg_lic_item b
			where	a.nr_sequencia	= b.nr_seq_licitacao
			and	a.nr_sequencia	= nr_seq_licitacao_p
			and	b.nr_seq_lic_item	= nr_seq_lic_item_w;
		end if;
		end;
	elsif (ie_opcao_preco_p = 3) then
		begin

		select	coalesce(max(x.nr_cot_compra),0)
		into STRICT	nr_cot_compra_w
		from	cot_compra x
		where	x.nr_seq_reg_licitacao = nr_seq_licitacao_p;

		if (nr_cot_compra_w > 0) then
			begin

			select	max(cd_material)
			into STRICT	cd_material_w
			from	reg_lic_item
			where	nr_seq_licitacao	= nr_seq_licitacao_p
			and	nr_seq_lic_item	= nr_seq_lic_item_w;

			select	coalesce(max(a.nr_item_cot_compra),0)
			into STRICT	nr_item_cot_compra_w
			from	cot_compra_item a
			where	a.nr_cot_compra	= nr_cot_compra_w
			and	a.cd_material	= cd_material_w;

			if (nr_item_cot_compra_w > 0) then
				begin

				select	dividir(vl_unitario_material,qt_fornec) vl_media
				into STRICT	vl_maximo_edital_w
				from (	SELECT	count(*) qt_fornec,
						sum(vl_unitario_material) vl_unitario_material
				from	cot_compra_forn_item a
				where	a.nr_cot_compra in (
					SELECT	x.nr_cot_compra
					from	cot_compra x
					where	x.nr_seq_reg_licitacao = nr_seq_licitacao_p)
				and (substr(obter_se_existe_cot_resumo(a.nr_cot_compra),1,1) = 'S')
				and	a.nr_item_cot_compra = nr_item_cot_compra_w
				and	coalesce(a.ie_considera_media_lic,'S') = 'S'
				and	a.vl_unitario_material > 0) alias9;

				end;
			end if;
			end;
		end if;


		end;
	end if;

	vl_total_item_w	:= coalesce(qt_item_w,0) * coalesce(vl_maximo_edital_w,0);

	select	coalesce(max(vl_maximo_edital),0)
	into STRICT	vl_maximo_ant_w
	from	reg_lic_item
	where	nr_seq_licitacao	= nr_seq_licitacao_p
	and	nr_seq_lic_item		= nr_seq_lic_item_w;

	update	reg_lic_item
	set	vl_maximo_edital	= coalesce(vl_maximo_edital_w,0),
		pr_inflacao		= pr_inflacao_p,
		vl_total_item		= vl_total_item_w
	where	nr_seq_licitacao	= nr_seq_licitacao_p
	and	nr_seq_lic_item		= nr_seq_lic_item_w;

	CALL lic_gerar_hist_alt_item(
		nr_seq_licitacao_p,
		nr_seq_lic_item_w,
		'VL_MAXIMO_EDITAL',
		ie_opcao_preco_p,
		vl_maximo_ant_w,
		coalesce(vl_maximo_edital_w,0),
		nm_usuario_p);


	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gera_preco_edital_item ( nr_seq_licitacao_p bigint, nr_seq_lic_item_p bigint, ie_opcao_preco_p bigint, ie_somente_zerados_p text, ie_itens_definir_p text, pr_inflacao_p bigint, nm_usuario_p text) FROM PUBLIC;
