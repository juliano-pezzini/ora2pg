-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_consistir_limite_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, ds_consistencia_p INOUT text, ie_aprovadores_p INOUT text, nr_seq_regra_p INOUT text) AS $body$
DECLARE



cd_aprovador_ori_w 		pessoa_fisica_delegacao.cd_pessoa_fisica%type;
cd_aprovador_del_w 		pessoa_fisica_delegacao.cd_pessoa_substituta%type;
ie_considera_vl_limite_w 		varchar(2) := 'S';
nr_seq_regra_w			regra_limite_compras.nr_sequencia%type;
qt_regra_limite_compras_w		integer;
vl_limite_w			regra_limite_compras_valor.vl_limite%type;
vl_retorno_w        double precision;
ds_origem_preco_w       varchar(255);


c01 CURSOR FOR
SELECT	'O' ie_tipo,
	o.nr_ordem_compra nr_sequencia,
	o.nr_item_oci nr_seq_item,
	o.cd_material,
	(o.qt_material * o.vl_unitario_material) vl_total,
	m.cd_grupo_material,
	m.cd_subgrupo_material,
	m.cd_classe_material,
	o.cd_conta_contabil,
	o.cd_centro_custo,
	o.cd_local_estoque,
    o.cd_unidade_medida_compra,
    p.cd_estab_transf,
    o.qt_material,
    p.ie_tipo_ordem
FROM ordem_compra p, estrutura_material_v m, condicao_pagamento c, ordem_compra_item o
LEFT OUTER JOIN solic_compra s ON (o.nr_solic_compra = s.nr_solic_compra)
WHERE m.cd_material = o.cd_material and o.nr_ordem_compra = p.nr_ordem_compra and o.nr_seq_aprovacao = nr_seq_aprovacao_p and substr(obter_se_pessoa_deleg_item(o.cd_material,o.nr_seq_aprovacao,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S'  and p.cd_condicao_pagamento = c.cd_condicao_pagamento

union

SELECT	'S' ie_tipo,
	o.nr_solic_compra nr_sequencia,
	o.nr_item_solic_compra nr_seq_item,
	o.cd_material,
	(o.qt_material * coalesce(o.vl_unit_previsto,0)) vl_total,
	m.cd_grupo_material,
	m.cd_subgrupo_material,
	m.cd_classe_material,
	o.cd_conta_contabil,
	p.cd_centro_custo,
	p.cd_local_estoque,
    null,
    null,
    null,
    null
from	solic_compra_item o,
	solic_compra p,
	estrutura_material_v m
where	m.cd_material = o.cd_material
and	o.nr_solic_compra = p.nr_solic_compra
and	o.nr_seq_aprovacao = nr_seq_aprovacao_p
and	substr(obter_se_pessoa_deleg_item(o.cd_material,o.nr_seq_aprovacao,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S'

union

select	'C' ie_tipo,
	o.nr_cot_compra nr_sequencia,
	o.nr_item_cot_compra nr_seq_item,
	o.cd_material,
	coalesce(r.vl_preco_liquido, r.qt_material * r.vl_unitario_material) vl_total,
	m.cd_grupo_material,
	m.cd_subgrupo_material,
	m.cd_classe_material,
	obter_dados_solic_item_cot(o.nr_cot_compra, o.nr_item_cot_compra, 'CC'),
	(obter_dados_solic_item_cot(o.nr_cot_compra, o.nr_item_cot_compra, 'C'))::numeric ,
	(obter_dados_solic_item_cot(o.nr_cot_compra, o.nr_item_cot_compra, 'L'))::numeric ,
    null,
    null,
    null,
    null
from	cot_compra_item o,
	cot_compra p,
	estrutura_material_v m,
	cot_compra_resumo r,
	cot_compra_forn f
where	m.cd_material = o.cd_material
and	o.nr_cot_compra = p.nr_cot_compra
and	o.nr_cot_compra = r.nr_cot_compra
and	o.nr_item_cot_compra = r.nr_item_cot_compra
and	p.nr_cot_compra = f.nr_cot_compra
and	r.nr_seq_cot_forn = f.nr_sequencia
and	o.nr_seq_aprovacao = nr_seq_aprovacao_p
and	substr(obter_se_pessoa_deleg_item(o.cd_material,o.nr_seq_aprovacao,nr_seq_processo_p,cd_pessoa_fisica_p,'AC',clock_timestamp()),1,1) = 'S';

item_w		c01%rowtype;

c02 CURSOR FOR
SELECT	a.ie_considerar_oc_acum,
	a.ie_considerar_sc_acum,
	a.ie_considerar_cc_acum,
    a.ie_considerar_oct_acum,
	c.vl_limite,
	a.cd_material,
	a.cd_classe_material,
	a.cd_subgrupo_material,
	a.cd_grupo_material,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.cd_local_estoque,
	a.nr_sequencia,
	b.nr_sequencia nr_seq_regra_data
from	regra_limite_compras a,
	regra_limite_compras_data b,
	regra_limite_compras_valor c
where	a.nr_sequencia = b.nr_seq_regra
and	b.nr_sequencia = c.nr_seq_regra
and	a.cd_estabelecimento = cd_estabelecimento_p
and	(((item_w.ie_tipo = 'O') and (a.ie_consiste_oc = 'S') and (item_w.ie_tipo_ordem <> 'T'))
or	(item_w.ie_tipo = 'S' AND a.ie_consiste_sc = 'S')
or	(item_w.ie_tipo = 'C' AND a.ie_consiste_cc = 'S')
or ((item_w.ie_tipo = 'O') and (a.ie_consiste_oct = 'S') and (item_w.ie_tipo_ordem = 'T')))
and	a.ie_situacao = 'A'
and	clock_timestamp() between dt_inicio_vigencia and (dt_fim_vigencia + 86399/86400)
and	coalesce(a.cd_material,item_w.cd_material) = item_w.cd_material
and	coalesce(a.cd_grupo_material,item_w.cd_grupo_material) = item_w.cd_grupo_material
and	coalesce(a.cd_subgrupo_material,item_w.cd_subgrupo_material) = item_w.cd_subgrupo_material
and	coalesce(a.cd_classe_material,item_w.cd_classe_material) = item_w.cd_classe_material
and	coalesce(a.cd_conta_contabil,coalesce(item_w.cd_conta_contabil,'0')) = coalesce(item_w.cd_conta_contabil,'0')
and	coalesce(a.cd_centro_custo,coalesce(item_w.cd_centro_custo,'0')) = coalesce(item_w.cd_centro_custo,'0')
and	coalesce(a.cd_local_estoque,coalesce(item_w.cd_local_estoque,'0')) = coalesce(item_w.cd_local_estoque,'0')
and	not exists (	SELECT	1
			from	regra_limite_compras_aprov
			where	nr_seq_regra = a.nr_sequencia
			and	cd_aprovador = cd_pessoa_fisica_p)
order by a.cd_material,
	a.cd_classe_material,
	a.cd_subgrupo_material,
	a.cd_grupo_material,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.cd_local_estoque;


type valores is table of c02%rowtype index by integer;

regra_w		c02%rowtype;
valores_w 	valores;	
i		integer;
ie_encontrado_w	boolean;
qt_existe_w	bigint;


c03 CURSOR FOR
SELECT	distinct cd_aprovador
from	regra_limite_compras_aprov
where	nr_seq_regra = nr_seq_regra_w;

c04 CURSOR FOR
SELECT	obter_pessoa_delegacao(cd_aprovador,'AC',trunc(clock_timestamp(),'dd'))
from	regra_limite_compras_aprov
where	nr_seq_regra = nr_seq_regra_w;



BEGIN

select	count(*)
into STRICT	qt_existe_w
from	regra_limite_compras
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_situacao = 'A';

if (qt_existe_w > 0) then
	open c01;
	loop
	fetch c01 into	
		item_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		open c02;
		loop
		fetch c02 into
			regra_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin

			ie_encontrado_w := false;			
			nr_seq_regra_w	:= regra_w.nr_sequencia;

			select	coalesce(sum(vl_limite),0)
			into STRICT	vl_limite_w
			from	regra_limite_compras_valor
			where	nr_seq_regra = regra_w.nr_seq_regra_data;

			open c04;
			loop
			fetch c04 into
				cd_aprovador_del_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
				begin	
				if (cd_pessoa_fisica_p = cd_aprovador_del_w) then	
					open c03;
					loop
					fetch c03 into
						cd_aprovador_ori_w;
					EXIT WHEN NOT FOUND; /* apply on c03 */
						begin							
						select	count(*)
						into STRICT	qt_regra_limite_compras_w
						from	regra_limite_compras_aprov
						where	nr_seq_regra = regra_w.nr_sequencia
						and	cd_aprovador = cd_aprovador_ori_w;

						if (qt_regra_limite_compras_w > 0) then
							ie_considera_vl_limite_w := 'N';
						end if;								
						end;
					end loop;
					close c03;
				end if;
				end;
			end loop;
			close c04;

			for i in 0..valores_w.count-1 loop
                if (item_w.ie_tipo = 'O' and item_w.ie_tipo_ordem = 'T') then
                    SELECT * FROM sup_obter_valor_item_transf(item_w.cd_estab_transf, item_w.cd_material, item_w.cd_unidade_medida_compra, vl_retorno_w, ds_origem_preco_w) INTO STRICT vl_retorno_w, ds_origem_preco_w;
                    item_w.vl_total := vl_retorno_w * item_w.qt_material;
                end if;

				if ((regra_w.cd_material IS NOT NULL AND regra_w.cd_material::text <> '') and regra_w.cd_material = valores_w[i].cd_material) then
					valores_w[i].vl_limite := valores_w[i].vl_limite + item_w.vl_total;
					ie_encontrado_w := true;	

					if (valores_w[i].vl_limite > vl_limite_w) and (ie_considera_vl_limite_w = 'S') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289192,'CD_MATERIAL=' || regra_w.cd_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					end if;
				elsif ((regra_w.cd_classe_material IS NOT NULL AND regra_w.cd_classe_material::text <> '') and regra_w.cd_classe_material = valores_w[i].cd_classe_material) then
					valores_w[i].vl_limite := valores_w[i].vl_limite + item_w.vl_total;
					ie_encontrado_w := true;

					if (valores_w[i].vl_limite > vl_limite_w)  and (ie_considera_vl_limite_w = 'S') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289193,'CD_MATERIAL=' || regra_w.cd_classe_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					end if;
				elsif ((regra_w.cd_subgrupo_material IS NOT NULL AND regra_w.cd_subgrupo_material::text <> '') and regra_w.cd_subgrupo_material = valores_w[i].cd_subgrupo_material) then
					valores_w[i].vl_limite := valores_w[i].vl_limite + item_w.vl_total;
					ie_encontrado_w := true;

					if (valores_w[i].vl_limite > vl_limite_w)  and (ie_considera_vl_limite_w = 'S') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289194,'CD_MATERIAL=' || regra_w.cd_subgrupo_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					end if;

				elsif ((regra_w.cd_grupo_material IS NOT NULL AND regra_w.cd_grupo_material::text <> '') and regra_w.cd_grupo_material = valores_w[i].cd_grupo_material) then
					valores_w[i].vl_limite := valores_w[i].vl_limite + item_w.vl_total;
					ie_encontrado_w := true;

					if (valores_w[i].vl_limite > vl_limite_w)  and (ie_considera_vl_limite_w = 'S') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289196,'CD_MATERIAL=' || regra_w.cd_grupo_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					end if;
				end if;
			end loop;			

			if (not ie_encontrado_w) then

                if (item_w.ie_tipo = 'O' and item_w.ie_tipo_ordem = 'T') then
                    SELECT * FROM sup_obter_valor_item_transf(item_w.cd_estab_transf, item_w.cd_material, item_w.cd_unidade_medida_compra, vl_retorno_w, ds_origem_preco_w) INTO STRICT vl_retorno_w, ds_origem_preco_w;
                    item_w.vl_total := vl_retorno_w * item_w.qt_material;
                end if;

				i := valores_w.count;
				valores_w(i) := regra_w;
				valores_w[i].vl_limite := coalesce(item_w.vl_total,0) + coalesce(obter_valor_acumulado_compra(regra_w.nr_sequencia,trunc(clock_timestamp(),'mm'),clock_timestamp(),vl_retorno_w,item_w.nr_sequencia),0);


				if (valores_w[i].vl_limite > vl_limite_w) and (ie_considera_vl_limite_w = 'S') then
					if (regra_w.cd_material IS NOT NULL AND regra_w.cd_material::text <> '') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289192,'CD_MATERIAL=' || regra_w.cd_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					elsif (regra_w.cd_classe_material IS NOT NULL AND regra_w.cd_classe_material::text <> '') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289193,'CD_MATERIAL=' || regra_w.cd_classe_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					elsif (regra_w.cd_subgrupo_material IS NOT NULL AND regra_w.cd_subgrupo_material::text <> '') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289194,'CD_MATERIAL=' || regra_w.cd_subgrupo_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					elsif (regra_w.cd_grupo_material IS NOT NULL AND regra_w.cd_grupo_material::text <> '') then
						ds_consistencia_p := wheb_mensagem_pck.get_texto(289196,'CD_MATERIAL=' || regra_w.cd_grupo_material || ';VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					else
						ds_consistencia_p := wheb_mensagem_pck.get_texto(954646,'VL_APROVADO=' || campo_mascara_virgula(valores_w[i].vl_limite) || ';VL_LIMITE=' || campo_mascara_virgula(vl_limite_w));
					end if;
				end if;
			end if;

			if (ds_consistencia_p IS NOT NULL AND ds_consistencia_p::text <> '') then
				select	count(*)
				into STRICT	qt_existe_w
				from	regra_limite_compras_aprov
				where	nr_seq_regra = regra_w.nr_sequencia;

				if (qt_existe_w > 0) then
					ie_aprovadores_p := 'S';
				end if;
			end if;

			nr_seq_regra_p := regra_w.nr_sequencia;

			exit;

			end;
		end loop;
		close c02;

		end;
	end loop;
	close c01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_consistir_limite_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p bigint, cd_estabelecimento_p bigint, ds_consistencia_p INOUT text, ie_aprovadores_p INOUT text, nr_seq_regra_p INOUT text) FROM PUBLIC;

