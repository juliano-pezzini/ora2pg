-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_pend_tab_preco_nf ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE

 
qt_existe_regra_w			bigint;
nr_nota_fiscal_w			varchar(255);
nr_item_nf_w			bigint;
cd_cnpj_editado_w			varchar(20);
cd_cgc_fornecedor_w		varchar(14);
ds_fantasia_w			varchar(255);
ds_fornecedor_w			varchar(255);
cd_material_w			integer;
cd_material_ww			integer;
ds_material_w			varchar(255);
vl_ultima_compra_w		double precision;
vl_unitario_material_w		double precision;
nr_ordem_compra_w		bigint;
ds_assunto_w			varchar(80);
ds_mensagem_w			varchar(4000);
ie_usuario_w			varchar(1);
nr_seq_regra_w			bigint;
ds_email_adicional_w		varchar(2000);
cd_perfil_disparar_w		integer;
ds_email_origem_w			varchar(255);
nm_usuario_origem_w		varchar(255);
cd_local_estoque_w		smallint;
cd_centro_custo_w			smallint;
cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
ie_consignado_w			varchar(1);
ie_envia_email_w			varchar(1);
qt_existe_w			bigint;
ie_enviar_w			varchar(1) := 'S';
nm_usuario_receb_w		varchar(15);
ds_email_w			varchar(255);
ie_existe_w			varchar(1);
ds_destinatarios_w			varchar(4000);
ie_momento_envio_w		varchar(1);
cd_comprador_w			varchar(10);
cd_tab_preco_mat_w		bigint;
vl_preco_venda_w			double precision;
ds_email_remetente_w		varchar(255);

 
C01 CURSOR FOR 
	SELECT	ds_assunto, 
		ds_mensagem_padrao, 
		ie_usuario, 
		nr_sequencia, 
		ds_email_adicional, 
		cd_perfil_disparar, 
		coalesce(ds_email_remetente,'X'), 
		coalesce(ie_momento_envio,'I') 
	from	regra_envio_email_compra 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	ie_tipo_mensagem = 74 
	and	ie_situacao = 'A';
	
C02 CURSOR FOR 
	SELECT 	cd_local_estoque, 
		cd_centro_custo, 
		cd_grupo_material, 
		cd_subgrupo_material, 
		cd_classe_material, 
		cd_material, 
		ie_consignado, 
		ie_envia_email 
	from	envio_email_compra_filtro 
	where	nr_seq_regra = nr_seq_regra_w;
	
C03 CURSOR FOR 
	SELECT	a.nr_nota_fiscal, 
		b.nr_item_nf, 
		substr(obter_cgc_cpf_editado(a.cd_cgc_emitente),1,20) cd_cnpj_editado, 
		a.cd_cgc_emitente, 
		substr(obter_dados_pf_pj(a.cd_pessoa_fisica, a.cd_cgc_emitente, 'F'),1,255) ds_fantasia, 
		substr(obter_nome_pf_pj(a.cd_pessoa_fisica, a.cd_cgc_emitente),1,255) ds_fornecedor, 
		b.cd_material, 
		substr(obter_desc_material(b.cd_material),1,255) ds_material, 
		coalesce(obter_valor_ultima_compra_seq(a.cd_estabelecimento, 365, b.cd_material, null, 'N',a.nr_sequencia), 0) vl_ultima_compra, 
		b.vl_unitario_item_nf, 
		b.nr_ordem_compra 
	from	nota_fiscal a, 
		nota_fiscal_item b 
	where	a.nr_sequencia = b.nr_sequencia 
	and	coalesce(b.ie_pend_tab_preco,'N') = 'S' 
	and	(b.cd_material IS NOT NULL AND b.cd_material::text <> '') 
	and	b.nr_sequencia = nr_sequencia_p;

C04 CURSOR FOR 
	SELECT	nm_usuario_receb 
	from	regra_envio_email_usu 
	where	nr_seq_regra = nr_seq_regra_w 
	and	(nm_usuario_receb IS NOT NULL AND nm_usuario_receb::text <> '');	
		 

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_regra_w 
from	regra_envio_email_compra 
where	cd_estabelecimento = cd_estabelecimento_p 
and	ie_tipo_mensagem = 74 
and	ie_situacao = 'A';
 
ds_assunto_w:= null;
ds_mensagem_w := null;
ds_email_adicional_w := null;
ds_email_remetente_w := null;
 
if (qt_existe_regra_w > 0) then 
 
	open C03;
	loop 
	fetch C03 into	 
		nr_nota_fiscal_w, 
		nr_item_nf_w, 
		cd_cnpj_editado_w, 
		cd_cgc_fornecedor_w, 
		ds_fantasia_w, 
		ds_fornecedor_w, 
		cd_material_w, 
		ds_material_w, 
		vl_ultima_compra_w, 
		vl_unitario_material_w, 
		nr_ordem_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		 
		open C01;
		loop 
		fetch C01 into	 
			ds_assunto_w, 
			ds_mensagem_w, 
			ie_usuario_w, 
			nr_seq_regra_w, 
			ds_email_adicional_w, 
			cd_perfil_disparar_w, 
			ds_email_remetente_w,			 
			ie_momento_envio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			ds_destinatarios_w		:= '';
			ds_email_w		:= '';
			cd_comprador_w		:= '';
			 
			if (nr_ordem_compra_w > 0) then 
				select	cd_comprador 
				into STRICT	cd_comprador_w 
				from	ordem_compra 
				where	nr_ordem_compra = nr_ordem_compra_w;
			end if;
			 
			if (coalesce(cd_perfil_disparar_w::text, '') = '') or 
				(cd_perfil_disparar_w IS NOT NULL AND cd_perfil_disparar_w::text <> '' AND cd_perfil_disparar_w = obter_perfil_ativo) then 
			 
				if (ie_usuario_w = 'U') or 
					((coalesce(cd_comprador_w,'0') <> '0') and (ie_usuario_w = 'O')) then --Usuario 
					begin 
					select	ds_email, 
						nm_usuario 
					into STRICT	ds_email_origem_w, 
						nm_usuario_origem_w 
					from	usuario 
					where	nm_usuario = nm_usuario_p;
					end;
				elsif (ie_usuario_w = 'C') then --Setor compras 
					begin 
					select	ds_email 
					into STRICT	ds_email_origem_w 
					from	parametro_compras 
					where	cd_estabelecimento = cd_estabelecimento_p;
			 
					select	coalesce(ds_fantasia,ds_razao_social) 
					into STRICT	nm_usuario_origem_w 
					from	estabelecimento_v 
					where	cd_estabelecimento = cd_estabelecimento_p;
					end;
				elsif (ie_usuario_w = 'O') then --Comprador 
					begin 
					select	max(ds_email), 
						max(nm_guerra) 
					into STRICT	ds_email_origem_w, 
						nm_usuario_origem_w 
					from	comprador 
					where	cd_pessoa_fisica = cd_comprador_w 
					and	cd_estabelecimento = cd_estabelecimento_p;
					end;
				end if;
 
				if (ds_email_remetente_w <> 'X') then 
					ds_email_origem_w	:= ds_email_remetente_w;
				end if;
				 
				open C02;
				loop 
				fetch C02 into	 
					cd_local_estoque_w, 
					cd_centro_custo_w, 
					cd_grupo_material_w, 
					cd_subgrupo_material_w, 
					cd_classe_material_w, 
					cd_material_ww, 
					ie_consignado_w, 
					ie_envia_email_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin 
					if (ie_consignado_w = 'N') then 
						ie_consignado_w := '0';
					elsif (ie_consignado_w = 'S') then 
						ie_consignado_w := '1';
					elsif (ie_consignado_w = 'A') then 
						ie_consignado_w	:= null;
					end if;
					 
					select	count(*) 
					into STRICT	qt_existe_w 
					from	nota_fiscal_item a, 
						estrutura_material_v e 
					where	a.nr_sequencia = nr_sequencia_p 
					and	((coalesce(cd_local_estoque_w::text, '') = '') or (a.cd_local_estoque = coalesce(cd_local_estoque_w,a.cd_local_estoque))) 
					and	((coalesce(cd_centro_custo_w::text, '') = '') or (a.cd_centro_custo = coalesce(cd_centro_custo_w,a.cd_centro_custo))) 
					and	a.cd_material = e.cd_material 
					and	e.cd_material = coalesce(cd_material_ww,e.cd_material) 
					and	e.cd_grupo_material = coalesce(cd_grupo_material_w,e.cd_grupo_material) 
					and	e.cd_subgrupo_material = coalesce(cd_subgrupo_material_w,e.cd_subgrupo_material) 
					and	e.cd_classe_material = coalesce(cd_classe_material_w,e.cd_classe_material) 
					and	e.ie_consignado = coalesce(ie_consignado_w,e.ie_consignado);
					 
					if (qt_existe_w > 0) and (ie_envia_email_w = 'S') then 
						ie_enviar_w := 'S';
					else 
						ie_enviar_w := 'N';
					end if;
			--		end; 
			--	end loop; 
			--	close C02; 
				 
				if (ie_enviar_w = 'S') then	 
					 
					ds_destinatarios_w := ds_destinatarios_w || ds_email_adicional_w;					
					if (ds_destinatarios_w IS NOT NULL AND ds_destinatarios_w::text <> '') and (substr(ds_destinatarios_w,length(ds_destinatarios_w),1) <> ';') then 
						ds_destinatarios_w := ds_destinatarios_w || ';';
					end if;
					 
					open C04;
					loop 
					fetch C04 into	 
						nm_usuario_receb_w;
					EXIT WHEN NOT FOUND; /* apply on C04 */
						begin 
						 
						select	ds_email 
						into STRICT	ds_email_w 
						from	usuario 
						where	nm_usuario = nm_usuario_receb_w;	
	 
						if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then 
		 
							select	coalesce(max('S'),'N') 
							into STRICT	ie_existe_w 
							 
							where	upper(ds_destinatarios_w) like upper('%' || ds_email_w || '%');
 
							if (ie_existe_w = 'N') then 
								ds_destinatarios_w	:= ds_destinatarios_w || ds_email_w || ';';
							end if;
						end if;
						end;				
					end loop;
					close C04;
 
					select	coalesce(vl_parametro,vl_parametro_padrao) 
					into STRICT	cd_tab_preco_mat_w 
					from	funcao_parametro 
					where	cd_funcao	= 40 
					and	nr_sequencia	= 1;
 
					select	coalesce(max(vl_preco_venda),0) 
					into STRICT	vl_preco_venda_w 
					from	preco_material a 
					where	cd_tab_preco_mat = cd_tab_preco_mat_w 
					and	cd_material = cd_material_w 
					and	a.ie_situacao = 'A' 
					and	dt_inicio_vigencia =	(SELECT	max(x.dt_inicio_vigencia) 
									from	preco_material x 
									where	x.cd_tab_preco_mat = a.cd_tab_preco_mat 
									and	x.cd_material = a.cd_material 
									and	x.cd_estabelecimento = cd_estabelecimento_p 
									and	x.ie_situacao = 'A');
					 
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@nr_seq_nota',to_char(nr_sequencia_p)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@nr_nota_fiscal',nr_nota_fiscal_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@nr_item_nf',to_char(nr_item_nf_w)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@cnpj_editado',cd_cnpj_editado_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@cnpj',cd_cgc_fornecedor_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@fantasia_pj',ds_fantasia_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@razao_pj',ds_fornecedor_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@cd_material',to_char(cd_material_w)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@ds_material',ds_material_w),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@vl_ultima_compra',campo_mascara_virgula_casas(vl_ultima_compra_w,4)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@vl_unitario_nf',campo_mascara_virgula_casas(vl_unitario_material_w,4)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w,'@vl_ultima_compra_tab',campo_mascara_virgula_casas(vl_preco_venda_w,4)),1,80);
					 
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@nr_seq_nota',to_char(nr_sequencia_p)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@nr_nota_fiscal',nr_nota_fiscal_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@nr_item_nf',to_char(nr_item_nf_w)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@cnpj_editado',cd_cnpj_editado_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@cnpj',cd_cgc_fornecedor_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@fantasia_pj',ds_fantasia_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@razao_pj',ds_fornecedor_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@cd_material',to_char(cd_material_w)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@ds_material',ds_material_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@vl_ultima_compra',campo_mascara_virgula_casas(vl_ultima_compra_w,4)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@vl_unitario_nf',campo_mascara_virgula_casas(vl_unitario_material_w,4)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@vl_ultima_tab',campo_mascara_virgula_casas(vl_preco_venda_w,4)),1,4000);					
					 
					if	((ds_email_origem_w IS NOT NULL AND ds_email_origem_w::text <> '') and (ds_destinatarios_w IS NOT NULL AND ds_destinatarios_w::text <> '') and (nm_usuario_origem_w IS NOT NULL AND nm_usuario_origem_w::text <> '')) then 
						 
						if (ie_momento_envio_w = 'A') then 
							CALL sup_grava_envio_email( 
								'NF', 
								'74', 
								nr_sequencia_p, 
								null, 
								null, 
								ds_destinatarios_w, 
								nm_usuario_origem_w, 
								ds_email_origem_w, 
								ds_assunto_w, 
								ds_mensagem_w, 
								cd_estabelecimento_p, 
								nm_usuario_p);
						else 
							begin 
							CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_destinatarios_w,nm_usuario_origem_w,'M');
							exception when others then 
								ds_assunto_w := '';
							end;
						end if;
 
					end if;
				end if;
				end;
				end loop;
				close C02;
			end if;
			end;
		end loop;
		close C01;
		 
		end;
	end loop;
	close C03;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_pend_tab_preco_nf ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
