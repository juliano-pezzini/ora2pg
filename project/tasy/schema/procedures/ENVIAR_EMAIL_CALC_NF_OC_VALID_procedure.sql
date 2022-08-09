-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_calc_nf_oc_valid ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint) AS $body$
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
cd_perfil_dispara_w	integer;
ie_existe_regra_w		varchar(1);
ds_destinatarios_w		varchar(4000);
ie_momento_envio_w	varchar(1);

/*Filtros da regra*/
 
cd_local_estoque_w	smallint;
cd_centro_custo_w	smallint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
cd_material_w		bigint;
ie_consignado_w		varchar(1);
ie_envia_email_w		varchar(1);
ie_email_w		varchar(1);
qt_existe_filtro_w		bigint;
ds_email_remetente_w	varchar(255);

/*Usuários da regra*/
 
ie_usuario_receb_w	varchar(15);
nm_usuario_receb_w	varchar(15);
ie_aprov_dif_regra_w	varchar(1);

/*Nota fiscal*/
 
qt_existe_w		bigint;
ie_enviar_w		varchar(1);
nr_item_nf_w		bigint;
dt_validade_w		timestamp;
cd_lote_fabricacao_w	varchar(20);

/*Ordem de Compra*/
 
nr_ordem_compra_w	bigint;
cd_comprador_w		bigint;
dt_ordem_compra_w	timestamp;
dt_liberacao_w		timestamp;
nm_comprador_w		varchar(60);
nm_usuario_origem_w	varchar(255);
nm_solicitante_w		varchar(255);
ds_material_w		varchar(255);

ds_lista_material_w	varchar(4000);

c01 CURSOR FOR 
SELECT 	distinct nr_ordem_compra 
from (	SELECT	a.nr_ordem_compra 
	from	nota_fiscal a 
	where 	a.nr_sequencia = nr_sequencia_p 
	and	(a.nr_ordem_compra IS NOT NULL AND a.nr_ordem_compra::text <> '') 
	and	exists (	select	1 
			from	nota_fiscal_item x 
			where	x.nr_sequencia = a.nr_sequencia 
			and	coalesce(x.nr_ordem_compra::text, '') = '' 
			and	(x.dt_validade IS NOT NULL AND x.dt_validade::text <> '') 
			and	x.dt_validade <= trunc(clock_timestamp() + interval '365 days')) 
	
union
 
	select	a.nr_ordem_compra 
	from	nota_fiscal_item a 
	where	a.nr_sequencia = nr_sequencia_p 
	and	(a.nr_ordem_compra IS NOT NULL AND a.nr_ordem_compra::text <> '') 
	and	(a.dt_validade IS NOT NULL AND a.dt_validade::text <> '') 
	and	a.dt_validade <= trunc(clock_timestamp() + interval '365 days')) alias10 
where	(nr_ordem_compra IS NOT NULL AND nr_ordem_compra::text <> '');

c02 CURSOR FOR 
SELECT	nr_item_nf 
from	nota_fiscal_item 
where	nr_sequencia = nr_sequencia_p 
and	nr_ordem_compra = nr_ordem_compra_w 
and	(dt_validade IS NOT NULL AND dt_validade::text <> '') 
and	dt_validade <= trunc(clock_timestamp() + interval '365 days');

c03 CURSOR FOR 
SELECT	nr_sequencia, 
	coalesce(ds_email_remetente,'X'), 
	replace(ds_email_adicional,',',';'), 
	cd_perfil_disparar, 
	coalesce(ie_momento_envio,'I'), 
	coalesce(ie_usuario,'U') 
from	regra_envio_email_compra 
where	ie_tipo_mensagem = 69 
and	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_p 
and	(ds_email_adicional IS NOT NULL AND ds_email_adicional::text <> '');

c04 CURSOR FOR 
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


BEGIN 
 
select	count(*) 
into STRICT	qt_existe_regra_w 
from	regra_envio_email_compra 
where	cd_estabelecimento = cd_estabelecimento_p 
and	ie_tipo_mensagem = 69 
and	ie_situacao = 'A';
 
if (qt_existe_regra_w > 0) then 
	begin 
 
	open c01;
	loop 
	fetch c01 into 
		nr_ordem_compra_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
 
		select	cd_comprador, 
			substr(obter_nome_pf_pj(cd_comprador,null),1,255), 
			substr(obter_nome_pf_pj(cd_pessoa_solicitante,null),1,255), 
			dt_ordem_compra, 
			dt_liberacao 
		into STRICT	cd_comprador_w, 
			nm_comprador_w, 
			nm_solicitante_w, 
			dt_ordem_compra_w, 
			dt_liberacao_w 
		from	ordem_compra 
		where 	nr_ordem_compra = nr_ordem_compra_w;
 
		open c02;
		loop 
		fetch c02 into 
			nr_item_nf_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin 
 
			select	a.cd_material, 
				b.ds_material, 
				a.dt_validade, 
				a.cd_lote_fabricacao 
			into STRICT	cd_material_w, 
				ds_material_w, 
				dt_validade_w, 
				cd_lote_fabricacao_w 
			from	nota_fiscal_item a, 
				estrutura_material_v b 
			where	b.cd_material = a.cd_material 
			and	a.nr_sequencia = nr_sequencia_p 
			and	a.nr_item_nf = nr_item_nf_w;
 
			ds_lista_material_w := substr(ds_lista_material_w	|| cd_material_w || ' - ' 
										|| ds_material_w || ' - ' 
										|| PKG_DATE_FORMATERS.TO_VARCHAR(dt_validade_w, 'shortDate', cd_estabelecimento_p, nm_usuario_p) || ' - ' 
										|| cd_lote_fabricacao_w || chr(10) || chr(13),1,4000);
 
			end;
		end loop;
		close c02;
 
		open c03;
		loop 
		fetch c03 into 
			nr_seq_regra_w, 
			ds_email_remetente_w, 
			ds_email_adicional_w, 
			cd_perfil_dispara_w, 
			ie_momento_envio_w, 
			ie_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin 
 
			if (coalesce(cd_perfil_dispara_w::text, '') = '') or 
				(cd_perfil_dispara_w IS NOT NULL AND cd_perfil_dispara_w::text <> '' AND cd_perfil_dispara_w = obter_perfil_ativo) then 
				begin 
 
				select	count(*) 
				into STRICT	qt_existe_filtro_w 
				from	envio_email_compra_filtro 
				where	nr_seq_regra = nr_seq_regra_w;
 
				if (qt_existe_filtro_w > 0) then 
					begin 
 
					ie_envia_email_w := 'N';
 
					open c04;
					loop 
					fetch c04 into 
						cd_local_estoque_w, 
						cd_centro_custo_w, 
						cd_grupo_material_w, 
						cd_subgrupo_material_w, 
						cd_classe_material_w, 
						cd_material_w, 
						ie_consignado_w, 
						ie_email_w;
					EXIT WHEN NOT FOUND; /* apply on c04 */
						begin 
 
						if (ie_envia_email_w = 'N') then 
							begin 
	 
							select	count(*) 
							into STRICT	qt_existe_w 
							from	nota_fiscal_item a, 
								estrutura_material_v e 
							where	a.nr_sequencia = nr_sequencia_p 
							and	a.nr_ordem_compra = nr_ordem_compra_w 
							and	a.dt_validade <= trunc(clock_timestamp() + interval '365 days') 
							and	((coalesce(cd_local_estoque_w::text, '') = '') or (a.cd_local_estoque = coalesce(cd_local_estoque_w,a.cd_local_estoque))) 
							and	((coalesce(cd_centro_custo_w::text, '') = '') or (a.cd_centro_custo = coalesce(cd_centro_custo_w,a.cd_centro_custo))) 
							and	a.cd_material = e.cd_material 
							and	e.cd_material = coalesce(cd_material_w,e.cd_material) 
							and	e.cd_grupo_material = coalesce(cd_grupo_material_w,e.cd_grupo_material) 
							and	e.cd_subgrupo_material = coalesce(cd_subgrupo_material_w,e.cd_subgrupo_material) 
							and	e.cd_classe_material = coalesce(cd_classe_material_w,e.cd_classe_material) 
							and	e.ie_consignado = coalesce(ie_consignado_w,e.ie_consignado);
						 
							if (qt_existe_w > 0) and (ie_email_w = 'S') then 
								ie_envia_email_w := 'S';
							end if;
	 
							end;
						end if;
	 
						end;
					end loop;
					close c04;
 
					end;
				else 
					ie_envia_email_w := 'S';
				end if;
 
				if (ie_envia_email_w = 'S') then 
					begin 
	 
					select	ds_assunto, 
						ds_mensagem_padrao 
					into STRICT	ds_assunto_w, 
						ds_mensagem_w 
					from	regra_envio_email_compra 
					where	nr_sequencia = nr_seq_regra_w;
 
 
					ds_assunto_w := subStr(replace_macro(ds_assunto_w, '@nr_ordem_compra', to_char(nr_ordem_compra_w)),1,80);
					ds_assunto_w := subStr(replace_macro(ds_assunto_w, '@nm_solicitante', nm_solicitante_w),1,80);
					ds_assunto_w := subStr(replace_macro(ds_assunto_w, '@nr_seq_nota', to_char(nr_sequencia_p)),1,80);
					ds_assunto_w := subStr(replace_macro(ds_assunto_w, '@nm_comprador', nm_comprador_w),1,80);
					ds_assunto_w := subStr(replace_macro(ds_assunto_w, '@dt_ordem', PKG_DATE_FORMATERS.TO_VARCHAR(dt_ordem_compra_w, 'shortDate', cd_estabelecimento_p, nm_usuario_p)),1,80);
					ds_assunto_w := substr(replace_macro(ds_assunto_w, '@ds_material', ds_lista_material_w),1,255);
 
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@nr_ordem_compra',to_char(nr_ordem_compra_w)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@nm_solicitante',nm_solicitante_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@nr_seq_nota',to_char(nr_sequencia_p)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@nm_comprador',nm_comprador_w),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@dt_ordem',PKG_DATE_FORMATERS.TO_VARCHAR(dt_ordem_compra_w, 'shortDate', cd_estabelecimento_p, nm_usuario_p)),1,4000);
					ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@ds_material',ds_lista_material_w),1,4000);
 
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
 
					if (ie_momento_envio_w = 'A') then 
						begin 
 
						CALL sup_grava_envio_email( 
							'NF', 
							'69', 
							nr_sequencia_p, 
							null, 
							null, 
							ds_email_adicional_w, 
							nm_usuario_origem_w, 
							ds_email_origem_w, 
							ds_assunto_w, 
							ds_mensagem_w, 
							cd_estabelecimento_p, 
							nm_usuario_p);
 
						end;
					else 
						begin 
						CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_email_adicional_w,nm_usuario_origem_w,'M');
						exception 
						when others then 
							/*gravar__log__tasy(91301,'Falha ao enviar e-mail compras - Evento: 69 - Seq. Regra: ' || nr_seq_regra_w,nm_usuario_p);*/
 
							CALL gerar_historico_nota_fiscal( 
								nr_sequencia_p, 
								nm_usuario_p, 
								54, 
								wheb_mensagem_pck.get_texto(300309,'DS_RETORNO='||nr_seq_regra_w));
						end;
					end if;
 
					end;
				end if; /*End do envia_email = 'S'*/
 
				end;
			end if;
			end;
		end loop;
		close c03;	
 
		end;
	end loop;
	close c01;
 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_calc_nf_oc_valid ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
