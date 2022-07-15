-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_calc_nf_oc ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_commit_p text default 'S') AS $body$
DECLARE

 
/*Regra*/
 
qt_existe_regra_w		bigint;
ds_mensagem_w		varchar(4000);
ds_assunto_w		varchar(80);
ds_email_origem_w	varchar(255);
ds_email_destino_w	varchar(255);
ie_prioridade_w		varchar(1);
ie_usuario_w		varchar(1);
nr_seq_regra_w		bigint;
ds_email_adicional_w	varchar(2000);
cd_perfil_disparar_w	integer;
ie_existe_regra_w		varchar(1);
ds_destinatarios_w		varchar(4000);
ds_email_remetente_w	varchar(255);

/*Filtros da regra*/
 
cd_local_estoque_w	smallint;
cd_centro_custo_w	smallint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
cd_material_w		bigint;
ie_consignado_w		varchar(1);
ie_envia_email_w	varchar(1);

/*Usuários da regra*/
 
ie_usuario_receb_w	varchar(15);
nm_usuario_receb_w	varchar(15);
ie_aprov_dif_regra_w	varchar(1);

/*Nota fiscal*/
 
qt_existe_w		bigint;
ie_enviar_w		varchar(1);

/*Ordem de Compra*/
 
nr_ordem_compra_w	bigint;
cd_comprador_w		bigint;
dt_ordem_compra_w	timestamp;
dt_liberacao_w		timestamp;
nm_comprador_w		varchar(60);
nm_usuario_origem_w	varchar(255);

/*Solicitação de Compra*/
 
nr_solic_compra_w	bigint;
nm_comprador_resp_w	varchar(60);
cd_pessoa_solic_w	bigint;
dt_solic_compra_w	timestamp;
dt_liberacao_solic_w	timestamp;
ds_email_solic_w	varchar(255);
nm_usuario_solic_w	varchar(15);
nm_solicitante_w	varchar(60);

ds_materiais_w		varchar(4000);

C01 CURSOR FOR 
	SELECT	ds_assunto, 
		ds_mensagem_padrao, 
		ie_usuario, 
		nr_sequencia, 
		coalesce(ds_email_remetente,'X'), 
		ds_email_adicional, 
		cd_perfil_disparar 
	from	regra_envio_email_compra 
	where	cd_estabelecimento = cd_estabelecimento_p 
	and	ie_tipo_mensagem = 65 
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
	SELECT 	distinct nr_ordem_compra 
	from (	SELECT	nr_ordem_compra 
		from	nota_fiscal 
		where 	nr_sequencia = nr_sequencia_p 
		
union
 
		select nr_ordem_compra 
		from	nota_fiscal_item 
		where	nr_sequencia = nr_sequencia_p) alias0 
	where	(nr_ordem_compra IS NOT NULL AND nr_ordem_compra::text <> '');
		
C04 CURSOR FOR 
	SELECT	distinct nr_solic_compra 
	from	ordem_compra_item 
	where	nr_ordem_compra = nr_ordem_compra_w;
		

BEGIN 
 
select	count(*) 
into STRICT	qt_existe_regra_w 
from	regra_envio_email_compra 
where	cd_estabelecimento = cd_estabelecimento_p 
and	ie_tipo_mensagem = 65 
and	ie_situacao = 'A';
 
if (qt_existe_regra_w > 0) then 
	begin 
 
open C03;
	loop 
	fetch C03 into	 
		nr_ordem_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		 
		select	cd_comprador, 
			substr(obter_nome_pf_pj(cd_comprador,null),1,255), 
			dt_ordem_compra, 
			dt_liberacao 
		into STRICT	cd_comprador_w, 
			nm_comprador_w, 
			dt_ordem_compra_w, 
			dt_liberacao_w 
		from	ordem_compra 
		where 	nr_ordem_compra = nr_ordem_compra_w;
		 
		open C04;
		loop 
		fetch C04 into	 
			nr_solic_compra_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin 
 
			select	substr(obter_nome_pf_pj(cd_comprador_resp,null),1,60), 
				cd_pessoa_solicitante, 
				dt_solicitacao_compra, 
				dt_liberacao, 
				substr(obter_nome_pf_pj(cd_pessoa_solicitante,null),1,255), 
				SUBSTR(obter_select_concatenado_bv( 
			    		'select cd_material || chr(45) ||obter_desc_material(cd_material) || chr(13) from nota_fiscal_item where nr_sequencia = :nr_sequencia', 
			    		'nr_sequencia=' || nr_sequencia_p,','),1,4000) 
			into STRICT	nm_comprador_resp_w, 
				cd_pessoa_solic_w, 
				dt_solic_compra_w, 
				dt_liberacao_solic_w, 
				nm_solicitante_w, 
				ds_materiais_w 
			from	solic_compra 
			where 	nr_solic_compra = nr_solic_compra_w;
			 
			select	max(coalesce(nm_usuario,'')) 
			into STRICT	nm_usuario_solic_w 
			from	usuario 
			where 	cd_pessoa_fisica = cd_pessoa_solic_w 
			and	cd_estabelecimento = cd_estabelecimento_p;
			 
			ds_email_solic_w := obter_email_usuario(cd_pessoa_solic_w, nm_usuario_solic_w, cd_estabelecimento_p);
			 
			open C01;
			loop 
			fetch C01 into	 
				ds_assunto_w, 
				ds_mensagem_w, 
				ie_usuario_w, 
				nr_seq_regra_w, 
				ds_email_remetente_w, 
				ds_email_adicional_w, 
				cd_perfil_disparar_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				if (coalesce(cd_perfil_disparar_w::text, '') = '') or 
				  (cd_perfil_disparar_w IS NOT NULL AND cd_perfil_disparar_w::text <> '' AND cd_perfil_disparar_w = obter_perfil_ativo)then 
					if (ie_usuario_w = 'U') or 
						((coalesce(cd_comprador_w,'0') <> 0) and (ie_usuario_w = 'O')) then --Usuario 
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
						cd_material_w, 
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
						and	e.cd_material = coalesce(cd_material_w,e.cd_material) 
						and	e.cd_grupo_material = coalesce(cd_grupo_material_w,e.cd_grupo_material) 
						and	e.cd_subgrupo_material = coalesce(cd_subgrupo_material_w,e.cd_subgrupo_material) 
						and	e.cd_classe_material = coalesce(cd_classe_material_w,e.cd_classe_material) 
						and	e.ie_consignado = coalesce(ie_consignado_w,e.ie_consignado);
						 
						if (qt_existe_w > 0) and (ie_envia_email_w = 'S') then 
							ie_enviar_w := 'S';
						end if;
						end;
					end loop;
					close C02;
					 
					if (ie_enviar_w = 'S') then	 
						begin 
						ds_destinatarios_w := ds_email_solic_w || ';' || ds_email_adicional_w;
						 
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nr_ordem_compra',to_char(nr_ordem_compra_w)),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nr_seq_nota',to_char(nr_sequencia_p)),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nm_comprador_ordem',nm_comprador_w),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Dt_ordem',to_char(dt_ordem_compra_w,'dd/mm/yyyy')),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nm_comprador_resp',nm_comprador_resp_w),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Dt_solic_compra',to_char(dt_solic_compra_w,'dd/mm/yyyy')),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Dt_liberacao_solic',to_char(dt_liberacao_solic_w,'dd/mm/yyyy')),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nm_solicitante',nm_solicitante_w),1,80);
						ds_assunto_w := subStr(replace_macro(ds_assunto_w,'@Nr_solicitacao',nr_solic_compra_w),1,80);
						 
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nr_ordem_compra',to_char(nr_ordem_compra_w)),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nr_seq_nota',to_char(nr_sequencia_p)),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nm_comprador_ordem',nm_comprador_w),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Dt_ordem',to_char(dt_ordem_compra_w,'dd/mm/yyyy')),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nm_comprador_resp',nm_comprador_resp_w),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Dt_solic_compra',to_char(dt_solic_compra_w,'dd/mm/yyyy')),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Dt_liberacao_solic',to_char(dt_liberacao_solic_w,'dd/mm/yyyy')),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nm_solicitante',nm_solicitante_w),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Nr_solicitacao',nr_solic_compra_w),1,4000);
						ds_mensagem_w := subStr(replace_macro(ds_mensagem_w,'@Ds_materiais',ds_materiais_w),1,4000);
						 
						if ((ds_email_origem_w IS NOT NULL AND ds_email_origem_w::text <> '') and (ds_destinatarios_w IS NOT NULL AND ds_destinatarios_w::text <> '') and (nm_usuario_origem_w IS NOT NULL AND nm_usuario_origem_w::text <> '')) then 
							begin 
							CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_destinatarios_w,nm_usuario_origem_w,'M');
							end;
						end if;
						end;
					end if;
				end if;
				exception 
					when others then 
						null;
				end;
			end loop;
			close C01;
			end;
		end loop;
		close C04;
		 
		end;
	end loop;
	close C03;
exception 
	when others then 
		null;
if (coalesce(ie_commit_p,'S') = 'S') then 
	commit;
end if;
 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_calc_nf_oc ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint, ie_commit_p text default 'S') FROM PUBLIC;

