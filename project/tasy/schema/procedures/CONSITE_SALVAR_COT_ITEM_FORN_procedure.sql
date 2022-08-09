-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consite_salvar_cot_item_forn ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nr_seq_fornecedor_p bigint, cd_material_p bigint, vl_unitario_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



ie_bloqueia_w					varchar(01);
pr_dif_valor_ultima_compra_w				smallint;
vl_ultima_compra_w				double precision;
vl_diferenca_w					double precision;
ds_consistencia_w					varchar(2000);


BEGIN

delete	from cot_compra_consist_calc
where	nr_cot_compra = nr_cot_compra_p;

select	coalesce(max((vl_parametro)::numeric ),0),
	coalesce(max(ie_bloqueia),'N')
into STRICT	pr_dif_valor_ultima_compra_w,
	ie_bloqueia_w
from	cot_regra_consist_calc
where	obter_se_consist_regra_mat(nr_sequencia, cd_material_p) = 'S'
and	cd_estabelecimento	= cd_estabelecimento_p
and	ie_tipo_regra 		= 1;

if (pr_dif_valor_ultima_compra_w > 0) then

	select	coalesce(obter_dados_ult_compra_data(cd_estabelecimento_p, cd_material_p, null, clock_timestamp(), 0, 'VU'), 0)
	into STRICT	vl_ultima_compra_w
	;

	if (vl_ultima_compra_w > 0) then
		vl_diferenca_w	:= dividir((vl_ultima_compra_w * pr_dif_valor_ultima_compra_w), 100);
		if	(vl_unitario_p > (vl_ultima_compra_w + vl_diferenca_w)) or
			(vl_unitario_p < (vl_ultima_compra_w - vl_diferenca_w)) then
			begin
			ds_consistencia_w	:= Wheb_mensagem_pck.get_Texto(299050);
			CALL grava_consistencia_cotacao(nr_cot_compra_p, nr_item_cot_compra_p, nr_seq_fornecedor_p, ds_consistencia_w, ie_bloqueia_w, nm_usuario_p);
			end;
		end if;
	end if;


end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consite_salvar_cot_item_forn ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nr_seq_fornecedor_p bigint, cd_material_p bigint, vl_unitario_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
