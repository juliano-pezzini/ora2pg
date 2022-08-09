-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_volume_compras_pj ( cd_cnpj_p text, dt_inicio_p timestamp, dt_final_p timestamp, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
ie_entrada_saida_w		varchar(1);
vl_compra_w		double precision := 0;
vl_liquido_w		double precision;
qt_item_estoque_w		double precision;
qt_compra_w		double precision := 0;

c01 CURSOR FOR
SELECT distinct
	a.nr_sequencia,
	p.ie_entrada_saida
FROM operacao_estoque p, operacao_nota o, nota_fiscal a
LEFT OUTER JOIN condicao_pagamento c ON (a.cd_condicao_pagamento = c.cd_condicao_pagamento)
WHERE a.dt_entrada_saida between dt_inicio_p and fim_dia(dt_final_p) and a.cd_operacao_nf = o.cd_operacao_nf and p.ie_tipo_requisicao in (6,0) and ((coalesce(p.ie_consignado::text, '') = '') or (p.ie_consignado in (0,1,3))) and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '') and o.cd_operacao_estoque	= p.cd_operacao_estoque  and a.ie_situacao	= '1' and o.ie_tipo_operacao = '1' and (coalesce(a.cd_cgc, a.cd_cgc_emitente) IS NOT NULL AND (coalesce(a.cd_cgc, a.cd_cgc_emitente))::text <> '') and coalesce(nr_interno_conta::text, '') = '' and coalesce(nr_seq_protocolo::text, '') = '' and CASE WHEN p.ie_tipo_requisicao=0 THEN  coalesce(a.cd_cgc, a.cd_cgc_emitente)  ELSE a.cd_cgc_emitente END  = cd_cnpj_p and a.cd_estabelecimento = cd_estabelecimento_p;

c02 CURSOR FOR
SELECT	coalesce(a.qt_item_estoque,0),
	a.vl_liquido
from	material m,
	nota_fiscal_item a,
	estrutura_material_v e
where	a.nr_sequencia = nr_sequencia_w
and	a.cd_material = m.cd_material
and	e.cd_material = a.cd_material
and	coalesce(vl_liquido,0) <> 0
and	ie_entrada_saida_w = 'E'
and	((cd_grupo_material_p = 0) or (e.cd_grupo_material = cd_grupo_material_p))
and	((cd_subgrupo_material_p = 0) or (e.cd_subgrupo_material = cd_subgrupo_material_p))
and	((cd_classe_material_p = 0) or (e.cd_classe_material = cd_classe_material_p))
and	((cd_material_p = 0) or (e.cd_material = cd_material_p))

union all

select	coalesce(a.qt_item_estoque,0),
	(a.vl_liquido * -1)
from	material m,
	nota_fiscal_item a,
	estrutura_material_v e
where	a.nr_sequencia	= nr_sequencia_w
and	a.cd_material = m.cd_material
and	e.cd_material = a.cd_material
and	coalesce(vl_liquido,0) <> 0
and	ie_entrada_saida_w = 'S'
and	((cd_grupo_material_p = 0) or (e.cd_grupo_material = cd_grupo_material_p))
and	((cd_subgrupo_material_p = 0) or (e.cd_subgrupo_material = cd_subgrupo_material_p))
and	((cd_classe_material_p = 0) or (e.cd_classe_material = cd_classe_material_p))
and	((cd_material_p = 0) or (e.cd_material = cd_material_p));



BEGIN

delete from w_volume_compras_pj
where nm_usuario = nm_usuario_p;

open C01;
loop
fetch C01 into
	nr_sequencia_w,
	ie_entrada_saida_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		qt_item_estoque_w,
		vl_liquido_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		vl_compra_w	:= vl_compra_w + vl_liquido_w;
		qt_compra_w	:= qt_compra_w + qt_item_estoque_w;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

insert into w_volume_compras_pj(
	cd_cnpj,
	nm_usuario,
	vl_compra,
	qt_compra)
values (	cd_cnpj_p,
	nm_usuario_p,
	vl_compra_w,
	qt_compra_w);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_volume_compras_pj ( cd_cnpj_p text, dt_inicio_p timestamp, dt_final_p timestamp, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
