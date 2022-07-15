-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aceita_ordem_compra_web ( nr_ordem_compra_p bigint, nm_usuario_aceite_p text, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_regra_w				bigint;
cd_estabelecimento_w			smallint;
cd_cgc_fornecedor_w			varchar(14);
ds_razao_social_w				varchar(100);
ds_fantasia_w				varchar(100);
ds_fornecedor_w				varchar(100);
ds_email_origem_w				varchar(255);
ds_email_destino_w				varchar(255);
ds_email_solicitante_w			varchar(255);
ds_email_comprador_w			varchar(255);
ds_assunto_w				varchar(255);
ds_mensagem_w				varchar(2000);
ie_usuario_w				varchar(3);
ds_email_compras_w			varchar(255);
ds_email_adicional_w			varchar(2000);
ie_momento_envio_w			varchar(1);
ds_email_remetente_w			varchar(255);


BEGIN 
if (nr_ordem_compra_p IS NOT NULL AND nr_ordem_compra_p::text <> '') then 
	begin 
	update ordem_compra 
	set	dt_aceite   	= clock_timestamp(), 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p, 
		nm_usuario_aceite 	= nm_usuario_aceite_p 
	where	nr_ordem_compra 	= nr_ordem_compra_p 
	and	coalesce(dt_aceite::text, '') = '';
 
	select	cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from	ordem_compra 
	where	nr_ordem_compra = nr_ordem_compra_p;
 
	select	coalesce(max(nr_sequencia),0), 
		coalesce(max(ie_usuario),'U'), 
		coalesce(max(ds_email_remetente),'X'), 
		max(replace(ds_email_adicional,',',';')), 
		coalesce(max(ie_momento_envio),'I') 
	into STRICT	nr_seq_regra_w, 
		ie_usuario_w, 
		ds_email_remetente_w, 
		ds_email_adicional_w, 
		ie_momento_envio_w 
	from	regra_envio_email_compra 
	where	ie_tipo_mensagem = 19 
	and	ie_situacao = 'A' 
	and	cd_estabelecimento = cd_estabelecimento_w 
	and	obter_se_envia_email_regra(nr_ordem_compra_p, 'OC', 19, cd_estabelecimento_w) = 'S';
	 
	if (nr_seq_regra_w > 0) then 
		select	substr(obter_dados_pf_pj(null,obter_cgc_estabelecimento(cd_estabelecimento),'N'),1,100) ds_razao_social, 
			substr(obter_dados_pf_pj(null,obter_cgc_estabelecimento(cd_estabelecimento),'F'),1,100) ds_fantasia, 
			substr(obter_dados_pf_pj(null,cd_cgc_fornecedor,'F'),1,100) ds_fornecedor, 
			substr(obter_dados_pf_pj_estab(cd_estabelecimento,null,cd_cgc_fornecedor,'M'),1,100) ds_email_origem, 
			substr(obter_dados_usuario_opcao(obter_usuario_pessoa(cd_pessoa_solicitante),'E'),1,255) ds_email_solicitante, 
			substr(obter_dados_usuario_opcao(obter_usuario_pessoa(cd_comprador),'E'),1,255) ds_email_comprador 
		into STRICT	ds_razao_social_w, 
			ds_fantasia_w, 
			ds_fornecedor_w, 
			ds_email_origem_w, 
			ds_email_solicitante_w, 
			ds_email_comprador_w 
		from	ordem_compra 
		where	nr_ordem_compra = nr_ordem_compra_p;
 
		select	substr( 
			replace( 
			replace( 
			replace( 
			replace( 
			replace( 
			replace(ds_assunto, 
			'@fantasia_pj',ds_fantasia_w), 
			'@razao_pj',ds_razao_social_w), 
			'@ordem',nr_ordem_compra_p), 
			'@usuario_aceite',nm_usuario_aceite_p), 
			'@data',clock_timestamp()), 
			'@fornecedor',ds_fornecedor_w),1,255), 
			substr( 
			replace( 
			replace( 
			replace( 
			replace( 
			replace( 
			replace(ds_mensagem_padrao, 
			'@fantasia_pj',ds_fantasia_w), 
			'@razao_pj',ds_razao_social_w), 
			'@ordem',nr_ordem_compra_p), 
			'@usuario_aceite',nm_usuario_aceite_p), 
			'@data',clock_timestamp()), 
			'@fornecedor',ds_fornecedor_w),1,2000) 
		into STRICT	ds_assunto_w, 
			ds_mensagem_w 
		from	regra_envio_email_compra 
		where	nr_sequencia = nr_seq_regra_w;
		 
		ds_email_destino_w := ds_email_solicitante_w;
		 
		if (ie_usuario_w = 'C') then 
			select	ds_email 
			into STRICT	ds_email_compras_w 
			from	parametro_compras 
			where	cd_estabelecimento = cd_estabelecimento_w;
			 
			if (ds_email_compras_w IS NOT NULL AND ds_email_compras_w::text <> '') then 
				ds_email_origem_w := ds_email_compras_w;
			end if;
		end if;
			 
		if (coalesce(ds_email_comprador_w,'X') <> coalesce(ds_email_solicitante_w,'X')) then 
			if (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then 
				ds_email_destino_w := ds_email_destino_w || '; ' || ds_email_comprador_w;
			else 
				ds_email_destino_w := ds_email_comprador_w;
			end if;
		end if;		
		 
		if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then 
			if (ds_email_destino_w IS NOT NULL AND ds_email_destino_w::text <> '') then 
				ds_email_destino_w := ds_email_destino_w || '; ' || ds_email_adicional_w;
			else 
				ds_email_destino_w := ds_email_adicional_w;
			end if;
		end if;
 
		if (ds_email_remetente_w <> 'X') then 
			ds_email_origem_w	:= ds_email_remetente_w;
		end if;
 
		if (ie_momento_envio_w = 'A') then 
			begin 
 
			CALL sup_grava_envio_email( 
				'OC', 
				'19', 
				nr_ordem_compra_p, 
				null, 
				null, 
				ds_email_destino_w, 
				nm_usuario_p, 
				ds_email_origem_w, 
				ds_assunto_w, 
				ds_mensagem_w, 
				cd_estabelecimento_w, 
				nm_usuario_p);
 
			end;
		else		 
			CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_email_destino_w,nm_usuario_p,'M');
		end if;	
 
	end if;
 
	commit;
	end;	
end if;
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aceita_ordem_compra_web ( nr_ordem_compra_p bigint, nm_usuario_aceite_p text, nm_usuario_p text) FROM PUBLIC;

