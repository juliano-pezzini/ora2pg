-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_preco_venda ( nr_sequencia_nf_p bigint, nr_item_nf_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_atualizacao_w        		timestamp 		:= clock_timestamp();
vl_unitario_item_nf_w		double precision	:= 0;
cd_tab_exclusiva_w		smallint	:= 0;
cd_material_w			integer	:= 0;
cd_estabelecimento_w		smallint	:= 0;
ie_acao_nf_w			varchar(1);
dt_entrada_saida_w		timestamp;
ie_preco_compra_w		varchar(1);
vl_unitario_w			double precision	:= 0;
vl_preco_venda_w			double precision	:= 0;
cd_tab_preco_w			smallint	:= 0;
cd_moeda_w			smallint	:= 0;

qt_conv_compra_estoque_w		double precision	:= 0;
qt_conv_estoque_consumo_w	double precision	:= 0;
cd_unidade_compra_w		varchar(30);
cd_unidade_estoque_w		varchar(30);
cd_unidade_consumo_w		varchar(30);
cd_unidade_compra_nf_w		varchar(30);
pr_ipi_w				double precision	:= 0;

cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
qt_registo_w			bigint;

vl_unit_desc_item_nf_w		double precision	:= 0;
ie_valor_desc_item_w		varchar(1)	:= 'N';

qt_reg_w				bigint;
nr_seq_preco_mat_nf_w		bigint;
pr_ajuste_w			double precision;

ie_ignorar_w			varchar(1);
ie_atualizar_w			varchar(1);
ie_atualiza_todos_w		varchar(1);
ie_atualiza_todos_estab_w		varchar(1);
ie_atualiza_tab_preco_w		varchar(1);
cd_operacao_nf_w			smallint;
nr_ordem_compra_w		bigint;

vl_custo_medio_nf_w		double precision:= 0;
qt_atualiza_w			bigint;
vl_unitario_ww			double precision:= 0;

vl_item_preco_pub_w		nota_fiscal_item.vl_item_preco_pub%type;
nr_seq_familia_w		material.nr_seq_familia%type;


c01 CURSOR FOR
	SELECT	distinct(a.cd_tab_preco_mat),
		a.cd_moeda
	from	tabela_preco_material b,
		preco_material a
	where	((ie_atualiza_todos_w		= 'S') or (a.cd_material = cd_material_w))
	and	b.cd_estabelecimento		= cd_estabelecimento_w
	and	a.cd_tab_preco_mat		= b.cd_tab_preco_mat
	and 	coalesce(b.cd_operacao_nf, coalesce(cd_operacao_nf_w,0)) = coalesce(cd_operacao_nf_w,0)
	and 	((coalesce(b.ie_ordem_compra,'N') = 'N') or (nr_ordem_compra_w IS NOT NULL AND nr_ordem_compra_w::text <> ''))
	and	b.ie_atualiza_nf		= 'S';

c02 CURSOR FOR
	SELECT	distinct(a.cd_tab_preco_mat),
		a.cd_moeda
	from	tabela_preco_material b,
		preco_material a
	where	((ie_atualiza_todos_w		= 'S') or (a.cd_material = cd_material_w))
	and	b.cd_estabelecimento		= cd_estabelecimento_w
	and	a.cd_tab_preco_mat		= b.cd_tab_preco_mat
	and 	coalesce(b.cd_operacao_nf, coalesce(cd_operacao_nf_w,0)) = coalesce(cd_operacao_nf_w,0)
	and 	((coalesce(b.ie_ordem_compra,'N') = 'N') or (nr_ordem_compra_w IS NOT NULL AND nr_ordem_compra_w::text <> ''))
	and	b.ie_atualiza_nf		= 'R';
	
c03 CURSOR FOR
	SELECT	nr_sequencia
	from	regra_tab_preco_mat_nf
	where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
	and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
	and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_w) = 'S'))
	and	coalesce(cd_material,cd_material_w)			= cd_material_w
	and	cd_tab_preco_mat 					= cd_tab_preco_w
	and	coalesce(vl_unitario_w,0) between coalesce(vl_inicial, coalesce(vl_unitario_w,0)) and coalesce(vl_final, coalesce(vl_unitario_w,0))
	and	ie_situacao					= 'A'
	order by	coalesce(cd_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(vl_inicial,0),
		coalesce(vl_final,0);
			
c04 CURSOR FOR
	SELECT	nr_sequencia
	from	regra_tab_preco_mat_nf
	where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
	and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
	and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
	and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_w) = 'S'))
	and	coalesce(cd_material,cd_material_w)				= cd_material_w
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
	and	cd_tab_preco_mat 					= cd_tab_exclusiva_w
	and	coalesce(vl_unitario_w,0) between coalesce(vl_inicial, coalesce(vl_unitario_w,0)) and coalesce(vl_final, coalesce(vl_unitario_w,0))
	and	ie_situacao						= 'A'
	order by	coalesce(cd_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0),
		coalesce(vl_inicial,0),
		coalesce(vl_final,0);
			
c05 CURSOR FOR
	SELECT	coalesce(ie_ignora_atualizacao,'N')
	from	tab_preco_mat_regra
	where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
	and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
	and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
	and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
	and	coalesce(cd_material, cd_material_w)				= cd_material_w
	and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
	and	cd_tab_preco_mat					= cd_tab_preco_w
	and	ie_situacao						= 'A'
	order by	coalesce(cd_material,0),
		coalesce(nr_seq_familia,0),
		coalesce(cd_classe_material,0),
		coalesce(cd_subgrupo_material,0),
		coalesce(cd_grupo_material,0);
				

BEGIN

/* parametro que define tabela exclusiva para gravar o preco 
nunca pode ser alterado para buscar: ou de usuariuo ou de perfil, porque a tabela de preco deve ser do hospital, ou seja:
nao posso (eu estar atualizando tabela x e outro estar atualizando tabela y*/
begin

if (philips_param_pck.get_cd_pais = 2) then
	cd_tab_exclusiva_w := coalesce(obter_valor_param_usuario(40,1,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 0);
else
	select	coalesce(vl_parametro,vl_parametro_padrao)
	into STRICT	cd_tab_exclusiva_w
	from	funcao_parametro
	where	cd_funcao	= 40
	and	nr_sequencia	= 1;
end if;

exception
when others then
	cd_tab_exclusiva_w := 0;
end;

/*parametro que define se o item deve ser inserido na tabela de precos, caso o mesmo nao existir. depende do parametro [1] da nota fiscal estar com valor zero (atualiza todas as tabelas)*/

ie_atualiza_todos_w	:= coalesce(obter_valor_param_usuario(40,282,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');

ie_atualiza_todos_estab_w	:= coalesce(obter_valor_param_usuario(3110,52,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');

/* recupera dados da nota fiscal */

begin


select	a.vl_unitario_item_nf,
	a.cd_estabelecimento,
	a.cd_material,
	b.dt_entrada_saida,
	b.ie_acao_nf,
	coalesce(c.qt_conv_compra_estoque,1),
	c.ie_preco_compra,
	substr(obter_dados_material_estab(c.cd_material,a.cd_estabelecimento,'UMC'),1,30) cd_unidade_medida_compra,
	substr(obter_dados_material_estab(c.cd_material,a.cd_estabelecimento,'UME'),1,30) cd_unidade_medida_estoque,
	substr(obter_dados_material_estab(c.cd_material,a.cd_estabelecimento,'UMS'),1,30) cd_unidade_medida_consumo,
	coalesce(c.qt_conv_estoque_consumo,1),
	a.cd_unidade_medida_compra,
	dividir(vl_liquido, qt_item_nf),
	cd_operacao_nf,
	b.nr_ordem_compra,
	CASE WHEN a.qt_item_estoque=0 THEN 0  ELSE dividir(a.vl_liquido, a.qt_item_estoque) END  vl_custo_medio_nf,
	a.vl_item_preco_pub
into STRICT	vl_unitario_item_nf_w,
	cd_estabelecimento_w,
	cd_material_w,
	dt_entrada_saida_w,
	ie_acao_nf_w,
	qt_conv_compra_estoque_w,
	ie_preco_compra_w,
	cd_unidade_compra_w,
	cd_unidade_estoque_w,
	cd_unidade_consumo_w,
	qt_conv_estoque_consumo_w,
	cd_unidade_compra_nf_w,
	vl_unit_desc_item_nf_w,
	cd_operacao_nf_w,
	nr_ordem_compra_w,
	vl_custo_medio_nf_w,
	vl_item_preco_pub_w
from	nota_fiscal_item a,
	nota_fiscal b,
	material c
where	a.nr_sequencia	= b.nr_sequencia
and	a.nr_sequencia	= nr_sequencia_nf_p
and	a.nr_item_nf	= nr_item_nf_p
and	a.cd_material	= c.cd_material;

exception
when others then
	cd_material_w := 0;
end;

select	coalesce(max(ie_atualiza_tab_preco),'S')
into STRICT	ie_atualiza_tab_preco_w
from	operacao_nota
where	cd_operacao_nf = cd_operacao_nf_w;

if (ie_atualiza_tab_preco_w = 'N') then
	goto final;
end if;

begin
select	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	coalesce(nr_seq_familia,0)
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	nr_seq_familia_w
from	estrutura_material_v
where	cd_material		= cd_material_w;
exception
      	when others then
           	cd_grupo_material_w	 := 0;
           	cd_subgrupo_material_w	 := 0;
           	cd_classe_material_w	 := 0;
end;


select	coalesce(max(coalesce(a.tx_tributo,0)),0)
into STRICT	pr_ipi_w
from	tributo b,
	nota_fiscal_item_trib a
where	a.nr_sequencia	= nr_sequencia_nf_p
and	a.nr_item_nf	= nr_item_nf_p
and	a.cd_tributo	= b.cd_tributo
and	upper(b.ds_tributo) like '%IPI%';

if (qt_conv_compra_estoque_w = 0) then
           	qt_conv_compra_estoque_w := 1;
end if;

if (qt_conv_estoque_consumo_w = 0) then
           	qt_conv_estoque_consumo_w := 1;
end if;

vl_unitario_w := vl_unitario_item_nf_w;

if (philips_param_pck.get_cd_pais = 2) and (coalesce(vl_item_preco_pub_w,0) > 0) then -- SOMENTE PARA O MEXICO
	vl_unitario_w := vl_item_preco_pub_w;
	vl_unitario_item_nf_w := vl_item_preco_pub_w;
end if;

ie_valor_desc_item_w	:= coalesce(obter_valor_param_usuario(40,225,obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento), 'N');
if (ie_valor_desc_item_w = 'S') then
	vl_unitario_item_nf_w := vl_unit_desc_item_nf_w;
	vl_unitario_w := vl_unitario_item_nf_w;
elsif (ie_valor_desc_item_w = 'R') then
	vl_unitario_item_nf_w := vl_custo_medio_nf_w;
	vl_unitario_w := vl_unitario_item_nf_w;
end if;

if (cd_unidade_compra_nf_w		<> cd_unidade_consumo_w) then
	begin
	if (cd_unidade_compra_nf_w = cd_unidade_compra_w) then
		begin
		vl_unitario_w := (vl_unitario_item_nf_w / qt_conv_compra_estoque_w);
		vl_unitario_w := (vl_unitario_w / qt_conv_estoque_consumo_w);
		end;
	end if;
	if (cd_unidade_compra_nf_w = cd_unidade_estoque_w) then
		vl_unitario_w := (vl_unitario_item_nf_w / qt_conv_estoque_consumo_w);
	end if;
	end;
end if;

vl_unitario_w	:= vl_unitario_w + (vl_unitario_w * pr_ipi_w /100);
vl_unitario_ww	:= vl_unitario_w;

if (ie_preco_compra_w <> 'S') then
           	cd_material_w := 0;
end if;

if (cd_tab_exclusiva_w = 0) then
		begin
		open c01;
		loop
		fetch c01 into
			cd_tab_preco_w,
			cd_moeda_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	count(*)
		into STRICT	qt_reg_w
		from	regra_tab_preco_mat_nf
		where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
		and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
		and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
		and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
		and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_w) = 'S'))
		and	coalesce(cd_material,cd_material_w)				= cd_material_w
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
		and	cd_tab_preco_mat 					= cd_tab_preco_w
		and	coalesce(vl_unitario_w,0) between coalesce(vl_inicial, coalesce(vl_unitario_w,0)) and coalesce(vl_final, coalesce(vl_unitario_w,0))
		and	ie_situacao						= 'A';

		if (qt_reg_w > 0) then
			begin
			open c03;
			loop
			fetch c03	into	
				nr_seq_preco_mat_nf_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				nr_seq_preco_mat_nf_w	:= nr_seq_preco_mat_nf_w;				
				end;
			end loop;
			close c03;
			
			if (coalesce(nr_seq_preco_mat_nf_w,0) > 0) then
				
				select 	pr_ajuste
				into STRICT	pr_ajuste_w
				from	regra_tab_preco_mat_nf
				where	nr_sequencia = nr_seq_preco_mat_nf_w;
			
			
				vl_unitario_ww	:=  vl_unitario_w  + round(vl_unitario_w * (pr_ajuste_w/100),4);
			end if;	
			
			end;
		end if;
		
		CALL atualizar_preco_venda(cd_estabelecimento_w,
					cd_tab_preco_w,
					cd_material_w,
					dt_entrada_saida_w,
					vl_unitario_ww,
					cd_moeda_w,
					nr_sequencia_nf_p,
					nr_item_nf_p,
					ie_acao_nf_w,
					nm_usuario_p);
					
		if (ie_atualiza_todos_estab_w = 'S') then
			copiar_mat_tabela_estab(cd_tab_preco_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
		elsif (ie_atualiza_todos_estab_w = 'R') then
			copiar_mat_tabela_estab_regra(cd_tab_preco_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
		end if;
		
		end;
		end loop;
		close c01;
		
		open c02;
		loop
		fetch c02 into
			cd_tab_preco_w,
			cd_moeda_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		
		select	count(*)
		into STRICT	qt_registo_w
		from	tab_preco_mat_regra
		where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
		and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
		and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
		and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
		and	coalesce(cd_material, cd_material_w)				= cd_material_w
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
		and	cd_tab_preco_mat					= cd_tab_preco_w
		and	ie_situacao						= 'A';

		
		if (qt_registo_w > 0) then
		
			ie_atualizar_w	:= 'S';
			open c05;
			loop
			fetch c05 into	
				ie_ignorar_w;
			EXIT WHEN NOT FOUND; /* apply on c05 */
				begin
				ie_ignorar_w:= ie_ignorar_w;				
				end;
			end loop;
			close c05;
			
			if (ie_ignorar_w = 'S') then
				ie_atualizar_w	:= 'N';
			end if;
			
			if (ie_atualizar_w = 'S') then
			
				select	count(*)
				into STRICT	qt_reg_w
				from	regra_tab_preco_mat_nf
				where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
				and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
				and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
				and	coalesce(cd_material,cd_material_w)				= cd_material_w
				and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
				and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_w) = 'S'))
				and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
				and	cd_tab_preco_mat 					= cd_tab_preco_w
				and	coalesce(vl_unitario_w,0) between coalesce(vl_inicial, coalesce(vl_unitario_w,0)) and coalesce(vl_final, coalesce(vl_unitario_w,0))
				and	ie_situacao						= 'A';
		
				if (qt_reg_w > 0) then
					begin
					open c03;
					loop
					fetch c03	into	
						nr_seq_preco_mat_nf_w;
					EXIT WHEN NOT FOUND; /* apply on c03 */
						begin
						nr_seq_preco_mat_nf_w	:= nr_seq_preco_mat_nf_w;
						end;
					end loop;
					close c03;
					
					if (coalesce(nr_seq_preco_mat_nf_w,0) > 0) then
						
						select 	pr_ajuste
						into STRICT	pr_ajuste_w
						from	regra_tab_preco_mat_nf
						where	nr_sequencia = nr_seq_preco_mat_nf_w;
						
						
						vl_unitario_ww	:=  vl_unitario_w  + round(vl_unitario_w * (pr_ajuste_w/100),4);
					end if;	
					
					end;
				end if;
			
				CALL atualizar_preco_venda(cd_estabelecimento_w,
					cd_tab_preco_w,
					cd_material_w,
					dt_entrada_saida_w,
					vl_unitario_ww,
					cd_moeda_w,
					nr_sequencia_nf_p,
					nr_item_nf_p,
					ie_acao_nf_w,
					nm_usuario_p);
					
				if (ie_atualiza_todos_estab_w = 'S') then
					copiar_mat_tabela_estab(cd_tab_preco_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
				elsif (ie_atualiza_todos_estab_w = 'R') then
					copiar_mat_tabela_estab_regra(cd_tab_preco_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
				end if;
			
			end if;
		end if;
		
		end;
		end loop;
		close c02;
			
			
		end;
else

		select 	count(*)
		into STRICT	qt_atualiza_w
		from 	tabela_preco_material
		where 	cd_tab_preco_mat = cd_tab_exclusiva_w
		and 	cd_estabelecimento = cd_estabelecimento_w
		and 	coalesce(cd_operacao_nf, coalesce(cd_operacao_nf_w,0)) = coalesce(cd_operacao_nf_w,0)
		and 	((coalesce(ie_ordem_compra,'N') = 'N') or (nr_ordem_compra_w IS NOT NULL AND nr_ordem_compra_w::text <> ''));
		
		if (qt_atualiza_w = 0) then
			goto final;
		end if;

		begin
		begin
		select	a.cd_moeda
		into STRICT		cd_moeda_w
		from		preco_material a
		where		a.cd_material			= cd_material_w
		and		a.cd_estabelecimento		= cd_estabelecimento_w
		and		a.cd_tab_preco_mat		= cd_tab_exclusiva_w
		and		a.dt_inicio_vigencia		=
				(SELECT max(x.dt_inicio_vigencia)	from preco_material x
					where	x.cd_material		= cd_material_w
					and	x.cd_estabelecimento	= cd_estabelecimento_w
					and	x.cd_tab_preco_mat	= cd_tab_exclusiva_w);
		exception
      			when others then
           			cd_moeda_w := 1;
		end;
		
		select	count(*)
		into STRICT	qt_reg_w
		from	regra_tab_preco_mat_nf
		where	coalesce(cd_grupo_material, cd_grupo_material_w) 		= cd_grupo_material_w
		and	coalesce(cd_subgrupo_material, cd_subgrupo_material_w) 	= cd_subgrupo_material_w
		and	coalesce(cd_classe_material, cd_classe_material_w) 		= cd_classe_material_w
		and	coalesce(cd_material,cd_material_w)				= cd_material_w
		and	coalesce(nr_seq_familia, nr_seq_familia_w) 				= nr_seq_familia_w
		and	((coalesce(nr_seq_estrutura::text, '') = '') or (consistir_se_mat_estrutura(nr_seq_estrutura,cd_material_w) = 'S'))
		and	coalesce(cd_estabelecimento,cd_estabelecimento_w)		= cd_estabelecimento_w
		and	cd_tab_preco_mat 					= cd_tab_exclusiva_w
		and	coalesce(vl_unitario_w,0) between coalesce(vl_inicial, coalesce(vl_unitario_w,0)) and coalesce(vl_final, coalesce(vl_unitario_w,0))
		and	ie_situacao						= 'A';

		if (qt_reg_w > 0) then
			begin
			open c04;
			loop
			fetch c04	into	
				nr_seq_preco_mat_nf_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
				begin
				nr_seq_preco_mat_nf_w	:= nr_seq_preco_mat_nf_w;
				end;
			end loop;
			close c04;
			
			if (coalesce(nr_seq_preco_mat_nf_w,0) > 0) then
				
				select 	pr_ajuste
				into STRICT	pr_ajuste_w
				from	regra_tab_preco_mat_nf
				where	nr_sequencia = nr_seq_preco_mat_nf_w;
				
				vl_unitario_w	:=  vl_unitario_w  + round(vl_unitario_w * (pr_ajuste_w/100),4);
						
			end if;
			
			end;
		end if;		

		CALL atualizar_preco_venda(cd_estabelecimento_w,
					cd_tab_exclusiva_w,
					cd_material_w,
					dt_entrada_saida_w,
					vl_unitario_w,
					cd_moeda_w,
					nr_sequencia_nf_p,
					nr_item_nf_p,
					ie_acao_nf_w,
					nm_usuario_p);
					
		if (ie_atualiza_todos_estab_w = 'S') then
			copiar_mat_tabela_estab(cd_tab_exclusiva_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
		elsif (ie_atualiza_todos_estab_w = 'R') then
			copiar_mat_tabela_estab_regra(cd_tab_exclusiva_w, cd_estabelecimento_w, cd_material_w, dt_entrada_saida_w, nm_usuario_p, 'N');
		end if;
		
		end;
	
end if;

<<final>>
--Criado este bloco pois o goto e necessario um comando final 
if (ie_atualiza_tab_preco_w = 'N') then
	ie_atualiza_tab_preco_w := 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_preco_venda ( nr_sequencia_nf_p bigint, nr_item_nf_p bigint, nm_usuario_p text) FROM PUBLIC;

