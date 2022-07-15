-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_ci_entrega_oci_dif_solic ( nr_ordem_compra_p text, nm_usuario_p text) AS $body$
DECLARE

 
/* Variáveis para envio da CI */
 
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
nr_seq_regra_w			bigint;
cd_perfil_ww			varchar(10);
qt_regra_usuario_w			bigint;
ie_ci_lida_w			varchar(1);
nm_usuario_destino_w		varchar(255);
ds_titulo_w			varchar(80);
ds_comunic_w			varchar(4000);
nr_seq_comunic_w			bigint;
nr_seq_classif_w			bigint;
qt_divergencia_entrega_w		bigint;
nr_solic_compra_w			bigint;
nr_item_oci_w			integer;
nr_item_solic_w			integer;
ds_itens_ordem_w			varchar(2000);
ds_datas_entrega_ordem_w		varchar(2000);
dt_entrega_limite_w			varchar(110);
ds_datas_entrega_solic_w		varchar(2000);
dt_entrega_solicitada_w		varchar(110);
ds_material_direto_w		varchar(270);
cd_comprador_w			varchar(10);
nm_guerra_w			comprador.nm_guerra%type;
ie_tipo_material_w		varchar(3);

 
ds_material_w			varchar(255);
cd_material_w			integer;

/*Verifica se pode gerar a comunicação para os usuários*/
 
ie_gerar_comunicacao_w		boolean := false;

/* Se tiver setor na regra, envia CI para os setores */
 
ds_setor_adicional_w  		varchar(2000) := '';
/* Campos da regra Usuário da Regra */
cd_setor_regra_usuario_w		integer;

c01 CURSOR FOR 
	SELECT	b.nr_sequencia, 
		b.cd_perfil 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	a.cd_funcao = 917 
	and	b.cd_evento = 53 
	and	b.ie_situacao = 'A' 
	and	a.cd_estabelecimento = cd_estabelecimento_w 
	and	((cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '' AND b.cd_setor_destino = cd_setor_atendimento_w) or 
		((coalesce(cd_setor_atendimento_w::text, '') = '') and (coalesce(b.cd_setor_destino::text, '') = '')) or (coalesce(b.cd_setor_destino::text, '') = '')) 
	and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_ordem_compra_p,'OC',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

c02 CURSOR FOR 
	SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento 
	from	regra_envio_comunic_usu a 
	where	a.nr_seq_evento = nr_seq_regra_w;

c03 CURSOR FOR 
	SELECT	a.cd_material, 
		substr(obter_desc_material(a.cd_material),1,255) ds_material, 
		a.nr_item_solic_compra, 
		a.nr_item_oci 
	from	ordem_compra_item a 
	where	a.nr_ordem_compra = nr_ordem_compra_p 
	and	((ie_tipo_material_w = 'A') or (ie_tipo_material_w = 'E' and obter_se_material_estoque(cd_estabelecimento_w,cd_estabelecimento_w,a.cd_material) = 'S') or (ie_tipo_material_w = 'N' and obter_se_material_estoque(cd_estabelecimento_w,cd_estabelecimento_w,a.cd_material) = 'N')) 
	order by a.nr_item_oci;

c04 CURSOR FOR 
	SELECT	to_char(b.dt_entrega_solicitada, 'dd/mm/yyyy') dt_entrega_solicitada 
	from	solic_compra_item_entrega b 
	where	b.nr_solic_compra		= nr_solic_compra_w 
	and	b.nr_item_solic_compra	= nr_item_solic_w 
	and   	exists (SELECT	1 
			from	ordem_compra_item_entrega a 
			where	a.nr_ordem_compra	= nr_ordem_compra_p 
			and	a.dt_entrega_limite 	> b.dt_entrega_solicitada 
			and	a.nr_item_oci	= nr_item_oci_w);

c05 CURSOR FOR 
	SELECT	to_char(a.dt_entrega_limite, 'dd/mm/yyyy') dt_entrega_limite 
	from	ordem_compra_item_entrega a 
	where	a.nr_ordem_compra	= nr_ordem_compra_p 
	and	a.nr_item_oci	= nr_item_oci_w 
	and 	exists (	SELECT	1 
			from	solic_compra_item_entrega b 
			where	b.nr_solic_compra		= nr_solic_compra_w 
			and	b.nr_item_solic_compra	= nr_item_solic_w 
			and	a.dt_entrega_limite		> b.dt_entrega_solicitada);


BEGIN 
 
select	coalesce(max(nr_solic_compra),0) 
into STRICT	nr_solic_compra_w 
from	ordem_compra_item 
where	nr_ordem_compra = nr_ordem_compra_p;
 
select	coalesce(max(cd_estabelecimento),0), 
	coalesce(max(cd_setor_atendimento),0), 
	coalesce(max(cd_comprador),'0') 
into STRICT	cd_estabelecimento_w, 
	cd_setor_atendimento_w, 
	cd_comprador_w 
from	ordem_compra 
where	nr_ordem_compra = nr_ordem_compra_p;
 
select	substr(coalesce(max(nm_guerra),wheb_mensagem_pck.get_Texto(299886)),1,80) /*Não informado*/
 
into STRICT	nm_guerra_w 
from	comprador 
where	cd_pessoa_fisica = cd_comprador_w;
 
select	obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
ie_tipo_material_w := Obter_Param_Usuario(917, 126, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_tipo_material_w);
 
open C01;
loop 
fetch C01 into 
	nr_seq_regra_w, 
	cd_perfil_ww;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	select	count(*) 
	into STRICT	qt_regra_usuario_w 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b, 
		regra_envio_comunic_usu c 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	b.nr_sequencia = c.nr_seq_evento 
	and	b.nr_sequencia = nr_seq_regra_w;
 
	select	coalesce(ie_ci_lida,'N') 
	into STRICT	ie_ci_lida_w 
	from 	regra_envio_comunic_evento 
	where 	nr_sequencia = nr_seq_regra_w;
 
	if (qt_regra_usuario_w > 0) and (nr_solic_compra_w > 0) then 
		begin 
		open C03;
		loop 
		fetch C03 into 
			cd_material_w, 
			ds_material_w, 
			nr_item_solic_w, 
			nr_item_oci_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin	 
			 
			select	count(*) 
			into STRICT	qt_divergencia_entrega_w 
			from	ordem_compra_item_entrega a 
			where	a.nr_ordem_compra	= nr_ordem_compra_p 
			and	a.nr_item_oci	= nr_item_oci_w 
			and 	exists (	SELECT	1 
					from	solic_compra_item_entrega b 
					where	b.nr_solic_compra		= nr_solic_compra_w 
					and	b.nr_item_solic_compra	= nr_item_solic_w 
					and	a.dt_entrega_limite		> b.dt_entrega_solicitada);
 
			if (qt_divergencia_entrega_w > 0) and (nr_item_oci_w > 0) then 
				begin 
 
				select	substr(CASE WHEN ds_material_direto='' THEN ''  ELSE ' (' || ds_material_direto || ') ' END ,1,270) 
				into STRICT	ds_material_direto_w 
				from	solic_compra_item 
				where	nr_solic_compra = nr_solic_compra_w 
				and	nr_item_solic_compra	= nr_item_solic_w;
				 
				open C04;
				loop 
				fetch C04 into	 
					dt_entrega_solicitada_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */
					begin 
					ds_datas_entrega_solic_w := substr(	ds_datas_entrega_solic_w || ' ' || wheb_mensagem_pck.get_Texto(795096) || ': ' || nr_item_solic_w || ' - ' || 
										ds_material_w || ' ' || ds_material_direto_w || ' - ' || 
										dt_entrega_solicitada_w || ' ' || wheb_mensagem_pck.get_Texto(795097) || chr(13) || chr(10),1,2000);
					end;
				end loop;
				close C04;
 
				select	substr(CASE WHEN ds_material_direto='' THEN ''  ELSE ' (' || ds_material_direto || ') ' END ,1,270) 
				into STRICT	ds_material_direto_w 
				from	ordem_compra_item 
				where	nr_ordem_compra = nr_ordem_compra_p 
				and	nr_item_oci	= nr_item_oci_w;
				 
				open C05;
				loop 
				fetch C05 into	 
					dt_entrega_limite_w;
				EXIT WHEN NOT FOUND; /* apply on C05 */
					begin 
					ds_datas_entrega_ordem_w := substr(	ds_datas_entrega_ordem_w || ' ' || wheb_mensagem_pck.get_Texto(795099) || ': ' || nr_item_oci_w || ' - ' || 
										ds_material_w || ' ' || ds_material_direto_w || ' - ' || 
										dt_entrega_limite_w || ' ' || wheb_mensagem_pck.get_Texto(795100) || chr(13) || chr(10),1,2000);
					end;
				end loop;
				close C05;
 
				ds_itens_ordem_w := substr(	ds_itens_ordem_w || nr_item_oci_w || ' - ' || 
							cd_material_w || ' - ' || ds_material_w || chr(13) || chr(10),1,2000);
 
				ie_gerar_comunicacao_w := true;
 
				end;
			end if;
 
			end;
		end loop;
		close C03;
		end;
	end if;
 
	if (coalesce(ds_itens_ordem_w,'X') <> 'X') and (ie_gerar_comunicacao_w) then 
		begin 
 
		open C02;
		loop 
		fetch C02 into 
			cd_setor_regra_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then 
				ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
			end if;
			end;
		end loop;
		close C02;
 
		nm_usuario_destino_w	:= '';
		nm_usuario_destino_w	:= obter_usuarios_comunic_compras(nr_ordem_compra_p, null, 53, nr_seq_regra_w, '');
		ds_titulo_w		:= '';
		ds_comunic_w		:= '';
 
		select	max(a.ds_titulo), 
			max(a.ds_comunicacao) 
		into STRICT	ds_titulo_w, 
			ds_comunic_w 
		from	regra_envio_comunic_evento a 
		where	a.nr_sequencia = nr_seq_regra_w;
		 
		ds_titulo_w := substr(replace_macro(ds_titulo_w, '@nr_ordem',nr_ordem_compra_p), 1, 80);
		ds_titulo_w := substr(replace_macro(ds_titulo_w, '@solicitacao', nr_solic_compra_w), 1, 80);
		ds_titulo_w := substr(replace_macro(ds_titulo_w, '@itens_ordem', ds_itens_ordem_w), 1, 80);
		 
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@nr_ordem',nr_ordem_compra_p), 1, 4000);
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@solicitacao', nr_solic_compra_w), 1, 4000);		
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@dt_entrega_limite_oc', ds_datas_entrega_ordem_w), 1, 4000);				
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@dt_entrega_solic', ds_datas_entrega_solic_w), 1, 4000);				
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@itens_ordem', ds_itens_ordem_w), 1, 4000);				
		ds_comunic_w := substr(replace_macro(ds_comunic_w, '@comprador', nm_guerra_w), 1, 4000);
 
		if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then 
			select	nextval('comunic_interna_seq') 
			into STRICT	nr_seq_comunic_w 
			;
 
			if (cd_perfil_ww IS NOT NULL AND cd_perfil_ww::text <> '') then 
				cd_perfil_ww := cd_perfil_ww ||',';
			end if;
 
			insert	into comunic_interna( 
				cd_estab_destino,			dt_comunicado,				ds_titulo, 
				ds_comunicado,			nm_usuario,				dt_atualizacao, 
				ie_geral,				nm_usuario_destino,			nr_sequencia, 
				ie_gerencial,			nr_seq_classif,				dt_liberacao, 
				ds_perfil_adicional,			ds_setor_adicional) 
			values (	cd_estabelecimento_w,		clock_timestamp(),					ds_titulo_w, 
				ds_comunic_w,			nm_usuario_p,				clock_timestamp(), 
				'N',				nm_usuario_destino_w,			nr_seq_comunic_w, 
				'N',				nr_seq_classif_w,				clock_timestamp(), 
				cd_perfil_ww,			ds_setor_adicional_w);
 
			/*Para que a comunicação seja gerada como lida ao próprio usuário */
 
			if (ie_ci_lida_w = 'S') then 
				insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
			end if;
		end if;
 
		end;
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
-- REVOKE ALL ON PROCEDURE envia_ci_entrega_oci_dif_solic ( nr_ordem_compra_p text, nm_usuario_p text) FROM PUBLIC;

