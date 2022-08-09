-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avisar_atraso_material_estab ( dt_parametro_p timestamp, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ds_titulo_w				varchar(50);
ds_comunicado_w				varchar(4000);
nr_ordem_compra_w			bigint;
nm_fornecedor_w				varchar(80);
nm_fornecedor_ww				varchar(80);
nm_usuario_w				varchar(255);
nm_usuario_ww				varchar(255);
nr_sequencia_w				bigint;
nr_seq_classif_w				bigint;

c01 CURSOR FOR 
SELECT distinct 
	a.nr_ordem_compra, 
	c.nm_fornecedor, 
	substr(u.nm_usuario || ',' || 
		obter_usuario_pessoa(obter_pessoa_delegacao(c.cd_comprador, 'RC', clock_timestamp())),1,255) ds_usuario 
from 	ordem_compra_item b, 
	ordem_compra_item_entrega a, 
	usuario u, 
	ordem_compra_v2 c 
where 	a.nr_ordem_compra 	= c.nr_ordem_compra 
and 	a.nr_ordem_compra 	= b.nr_ordem_compra 
and 	a.nr_item_oci		= b.nr_item_oci 
and	c.cd_comprador		= u.cd_pessoa_fisica 
and	c.cd_estabelecimento	= cd_estabelecimento_p 
and	coalesce(c.dt_baixa::text, '') = '' 
and	coalesce(a.dt_cancelamento::text, '') = '' 
and	coalesce(nr_seq_motivo_cancel::text, '') = '' 
and	a.dt_prevista_entrega	< trunc(dt_parametro_p,'dd') 
and	a.dt_prevista_entrega	<= trunc(dt_parametro_p,'dd') - coalesce(obter_qt_dias_aviso_atraso(c.cd_estabelecimento), 60) 
and (coalesce(a.dt_real_entrega::text, '') = '' or a.qt_prevista_entrega > coalesce(a.qt_real_entrega,0)) 
order by	ds_usuario, 
	nm_fornecedor, 
	a.nr_ordem_compra;

c02 CURSOR FOR 
SELECT distinct 
	a.nr_ordem_compra, 
	c.nm_fornecedor, 
	substr(coalesce(obter_usuario_pessoa(c.cd_pessoa_solicitante),'A') || ',' || 
		obter_usuario_pessoa(obter_pessoa_delegacao(c.cd_pessoa_solicitante, 'RC', clock_timestamp())),1,255) ds_usuario 
from 	ordem_compra_item b, 
	ordem_compra_item_entrega a, 
	usuario u, 
	ordem_compra_v2 c 
where 	a.nr_ordem_compra 	= c.nr_ordem_compra 
and 	a.nr_ordem_compra 	= b.nr_ordem_compra 
and 	a.nr_item_oci		= b.nr_item_oci 
and	c.cd_pessoa_solicitante	= u.cd_pessoa_fisica 
and	c.cd_estabelecimento	= cd_estabelecimento_p 
and	coalesce(c.dt_baixa::text, '') = '' 
and	coalesce(a.dt_cancelamento::text, '') = '' 
and	coalesce(nr_seq_motivo_cancel::text, '') = '' 
and	obter_usuario_pessoa(c.cd_pessoa_solicitante) <> obter_usuario_pessoa(c.cd_comprador) 
and (substr(obter_se_avisa_solic_atraso_oc(c.cd_estabelecimento),1,1) = 'S') 
and	a.dt_prevista_entrega	< trunc(dt_parametro_p,'dd') 
and	a.dt_prevista_entrega	<= trunc(dt_parametro_p,'dd') - coalesce(obter_qt_dias_aviso_atraso(c.cd_estabelecimento), 60) 
and (coalesce(a.dt_real_entrega::text, '') = '' or a.qt_prevista_entrega > coalesce(a.qt_real_entrega,0)) 
order by	ds_usuario, 
	nm_fornecedor, 
	a.nr_ordem_compra;


BEGIN 
 
ds_titulo_w	:= wheb_mensagem_pck.get_texto(297616);/* 'Fornecedores com OC em Atraso '*/
ds_comunicado_w	:= '';
select obter_classif_comunic('F') 
into STRICT	nr_seq_classif_w
;
 
/*Cursor 1 para enviar comunicação interna para o comprador*/
 
open c01;
loop 
fetch c01 into 
	nr_ordem_compra_w, 
	nm_fornecedor_w, 
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	if (coalesce(nm_usuario_ww::text, '') = '') then 
		nm_usuario_ww	:= nm_usuario_w;
	end if;
	if (nm_usuario_w <> nm_usuario_ww) then 
		begin 
		select nextval('comunic_interna_seq') 
		into STRICT nr_sequencia_w 
		;
		insert into comunic_interna( 
			dt_comunicado, 
			ds_titulo, 
			ds_comunicado, 
			nm_usuario, 
			dt_atualizacao, 
			ie_geral, 
			nm_usuario_destino, 
			nr_sequencia, 
			ie_gerencial, 
			nr_seq_classif, 
			dt_liberacao) 
		values (clock_timestamp() + interval '1 days'/86400, 
			ds_titulo_w, 
			ds_comunicado_w, 
			/*'Atraso'*/
 
			wheb_mensagem_pck.get_texto(297617), 
			clock_timestamp(), 
			'N', 
			nm_usuario_ww || ',', 
			nr_sequencia_w, 
			'N', 
			nr_seq_classif_w, 
			clock_timestamp());
		ds_comunicado_w	:= '';
		nm_usuario_ww		:= nm_usuario_w;
		end;
	end if;
	if (length(coalesce(ds_comunicado_w,'A')) < 3900) then 
		begin 
		if (nm_fornecedor_w <> coalesce(nm_fornecedor_ww,'A')) then 
			begin 
			ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || chr(10) || 
						nm_fornecedor_w || chr(13) || chr(10),1,4000);
			nm_fornecedor_ww	:= nm_fornecedor_w;
			end;
		end if;
		ds_comunicado_w	:= substr(ds_comunicado_w || ' ' || to_char(nr_ordem_compra_w),1,4000);
		end;
	end if;
	end;
end loop;
close c01;
 
/*Faz este insert porque ele monta uma comunicação para cada usuario. O cursor tem order by nm_usuario*/
 
if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') and (nm_usuario_ww IS NOT NULL AND nm_usuario_ww::text <> '') then 
	begin 
	select nextval('comunic_interna_seq') 
	into STRICT nr_sequencia_w 
	;
	insert into comunic_interna( 
		dt_comunicado, 
		ds_titulo, 
		ds_comunicado, 
		nm_usuario, 
		dt_atualizacao, 
		ie_geral, 
		nm_usuario_destino, 
		nr_sequencia, 
		ie_gerencial, 
		nr_seq_classif, 
		dt_liberacao) 
	values (clock_timestamp() + interval '1 days'/86400, 
		ds_titulo_w, 
		ds_comunicado_w, 
		/*'Atraso'*/
 
		wheb_mensagem_pck.get_texto(297617), 
		clock_timestamp(), 
		'N', 
		nm_usuario_ww || ',', 
		nr_sequencia_w, 
		'N', 
		nr_seq_classif_w, 
		clock_timestamp());
	end;
end if;
 
/*Cursor 2 para enviar a comunicação interna para os solicitantes da ordem de compra. 
Só envia para o solicitante se o parâmetro de compras estiver marcado e se ele ainda não recebeu a comunicação como sendo comprador nas rotina acima*/
 
 
ds_titulo_w		:= wheb_mensagem_pck.get_texto(297616);/* 'Fornecedores com OC em Atraso '*/
ds_comunicado_w		:= '';
nm_usuario_ww		:= '';
nm_fornecedor_ww	:= '';
 
open c02;
loop 
fetch c02 into 
	nr_ordem_compra_w, 
	nm_fornecedor_w, 
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin 
	if (coalesce(nm_usuario_ww::text, '') = '') then 
		nm_usuario_ww		:= nm_usuario_w;
	end if;
	if (nm_usuario_w <> nm_usuario_ww) then 
		begin 
		select nextval('comunic_interna_seq') 
		into STRICT nr_sequencia_w 
		;
		insert into comunic_interna( 
			dt_comunicado, 
			ds_titulo, 
			ds_comunicado, 
			nm_usuario, 
			dt_atualizacao, 
			ie_geral, 
			nm_usuario_destino, 
			nr_sequencia, 
			ie_gerencial, 
			nr_seq_classif, 
			dt_liberacao) 
		values (clock_timestamp() + interval '1 days'/86400, 
			ds_titulo_w, 
			ds_comunicado_w, 
			/*'Atraso'*/
 
			wheb_mensagem_pck.get_texto(297617), 
			clock_timestamp(), 
			'N', 
			nm_usuario_ww || ',', 
			nr_sequencia_w, 
			'N', 
			nr_seq_classif_w, 
			clock_timestamp());
		ds_comunicado_w	:= '';
		nm_usuario_ww		:= nm_usuario_w;
		end;
	end if;
	if (length(coalesce(ds_comunicado_w,'A')) < 3900) then 
		begin 
		if (nm_fornecedor_w <> coalesce(nm_fornecedor_ww,'A')) then 
			begin 
			ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || chr(10) || 
						nm_fornecedor_w || chr(13) || chr(10),1,4000);
			nm_fornecedor_ww	:= nm_fornecedor_w;
			end;
		end if;
		ds_comunicado_w	:= substr(ds_comunicado_w || ' ' || to_char(nr_ordem_compra_w),1,4000);
		end;
	end if;
	end;
end loop;
close c02;
 
/*Faz este insert porque ele monta uma comunicação para cada usuario. O cursor tem order by nm_usuario*/
 
if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') and (nm_usuario_ww IS NOT NULL AND nm_usuario_ww::text <> '') then 
	begin 
	select nextval('comunic_interna_seq') 
	into STRICT nr_sequencia_w 
	;
	insert into comunic_interna( 
		dt_comunicado, 
		ds_titulo, 
		ds_comunicado, 
		nm_usuario, 
		dt_atualizacao, 
		ie_geral, 
		nm_usuario_destino, 
		nr_sequencia, 
		ie_gerencial, 
		nr_seq_classif, 
		dt_liberacao) 
	values (clock_timestamp() + interval '1 days'/86400, 
		ds_titulo_w, 
		ds_comunicado_w, 
		/*'Atraso'*/
 
		wheb_mensagem_pck.get_texto(297617), 
		clock_timestamp(), 
		'N', 
		nm_usuario_ww || ',', 
		nr_sequencia_w, 
		'N', 
		nr_seq_classif_w, 
		clock_timestamp());
	end;
end if;	
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avisar_atraso_material_estab ( dt_parametro_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
