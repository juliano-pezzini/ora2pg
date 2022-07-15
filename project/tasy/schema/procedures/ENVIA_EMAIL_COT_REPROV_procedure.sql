-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_email_cot_reprov ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_cot_compra_w			bigint;
nr_seq_regra_w			bigint;
ds_email_adicional_w		varchar(2000);
cd_perfil_dispara_w		integer;
ie_momento_envio_w		varchar(1);
ds_email_remetente_w		varchar(255);

ds_titulo_w			varchar(255);
dt_cot_compra_w			timestamp;
cd_comprador_w			varchar(10);
nm_comprador_w			varchar(255);
cd_pessoa_solicitante_w		varchar(10);
nm_pessoa_solicitante_w		varchar(255);
nm_usuario_reprov_w		varchar(15);
nm_pessoa_reprov_w		varchar(255);
dt_reprovacao_w			timestamp;
ds_motivo_reprov_w		varchar(255);
ds_justificativa_w		processo_aprov_compra.ds_observacao%type;
ds_assunto_w			varchar(255);
ds_mensagem_w			varchar(4000);
ds_email_comprador_w		varchar(255);

ie_usuario_w			varchar(1);
ds_email_origem_w			varchar(255);
nm_usuario_origem_w		varchar(255);
ds_destinatarios_w			varchar(4000);


BEGIN 
 
select	coalesce(max(nr_cot_compra),0) 
into STRICT	nr_cot_compra_w 
from	cot_compra_item 
where	nr_seq_aprovacao = nr_seq_aprovacao_p;
 
select	coalesce(max(nr_sequencia),0), 
	coalesce(max(ds_email_remetente),'X'), 
	max(replace(ds_email_adicional,',',';')), 
	max(cd_perfil_disparar), 
	coalesce(max(ie_momento_envio),'I') 
into STRICT	nr_seq_regra_w, 
	ds_email_remetente_w,	 
	ds_email_adicional_w, 
	cd_perfil_dispara_w, 
	ie_momento_envio_w 
from	regra_envio_email_compra 
where	ie_tipo_mensagem = 78 
and	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_p 
and	substr(obter_se_envia_email_regra(nr_cot_compra_w, 'CC', ie_tipo_mensagem, cd_estabelecimento),1,1) = 'S';
 
if (nr_cot_compra_w > 0) and (nr_seq_regra_w > 0) and 
	((coalesce(cd_perfil_dispara_w::text, '') = '') or 
	(cd_perfil_dispara_w IS NOT NULL AND cd_perfil_dispara_w::text <> '' AND cd_perfil_dispara_w = obter_perfil_ativo)) then 
	begin 
 
	select	coalesce(ds_titulo, wheb_mensagem_pck.get_texto(299910)), 
		dt_cot_compra, 
		cd_comprador, 
		substr(sup_obter_nome_comprador(cd_estabelecimento,cd_comprador),1,255), 
		cd_pessoa_solicitante, 
		substr(coalesce(obter_nome_pf(cd_pessoa_solicitante),wheb_mensagem_pck.get_texto(299886)),1,255) 
	into STRICT	ds_titulo_w, 
		dt_cot_compra_w, 
		cd_comprador_w, 
		nm_comprador_w, 
		cd_pessoa_solicitante_w, 
		nm_pessoa_solicitante_w 
	from	cot_compra 
	where	nr_cot_compra = nr_cot_compra_w;
 
	select	nm_usuario_aprov, 
		substr(obter_nome_usuario(nm_usuario_aprov),1,255), 
		dt_definicao, 
		substr(obter_valor_dominio(1015,ie_motivo_reprovacao),1,255), 
		substr(ds_observacao,1,2000) 
	into STRICT	nm_usuario_reprov_w, 
		nm_pessoa_reprov_w, 
		dt_reprovacao_w, 
		ds_motivo_reprov_w, 
		ds_justificativa_w 
	from	processo_aprov_compra 
	where	nr_sequencia = nr_seq_aprovacao_p 
	and	nr_seq_proc_aprov = nr_seq_proc_aprov_p;
 
	select	max(ds_email), 
		max(nm_guerra) 
	into STRICT	ds_destinatarios_w, 
		nm_comprador_w 
	from	comprador 
	where	cd_pessoa_fisica = cd_comprador_w 
	and	cd_estabelecimento = cd_estabelecimento_p;
 
	select	ds_assunto, 
		ds_mensagem_padrao 
	into STRICT	ds_assunto_w, 
		ds_mensagem_w 
	from	regra_envio_email_compra 
	where	nr_sequencia = nr_seq_regra_w;
 
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@nr_cotacao', nr_cot_compra_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@nm_solicitante', nm_pessoa_solicitante_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@ds_titulo', ds_titulo_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@seq_aprovacao', nr_seq_aprovacao_p);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@dt_cotacao', dt_cot_compra_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@nm_comprador', nm_comprador_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@nm_usuario_reprov', nm_usuario_reprov_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@nm_pessoa_reprov', nm_pessoa_reprov_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@dt_reprovacao', dt_reprovacao_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@ds_motivo_reprov', ds_motivo_reprov_w);
	ds_assunto_w	:= replace_macro(ds_assunto_w, '@ds_justificativa', ds_justificativa_w);
	ds_assunto_w	:= substr(ds_assunto_w, 1, 255);
 
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nr_cotacao', nr_cot_compra_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nm_solicitante', nm_pessoa_solicitante_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@ds_titulo', ds_titulo_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@seq_aprovacao', nr_seq_aprovacao_p), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dt_cotacao', dt_cot_compra_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nm_comprador', nm_comprador_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nm_usuario_reprov', nm_usuario_reprov_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nm_pessoa_reprov', nm_pessoa_reprov_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dt_reprovacao', dt_reprovacao_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@ds_motivo_reprov', ds_motivo_reprov_w), 1, 4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@ds_justificativa', ds_justificativa_w), 1, 4000);
	ds_mensagem_w	:= substr(ds_mensagem_w, 1, 4000);
 
	select	coalesce(max(ie_usuario),'U') 
	into STRICT	ie_usuario_w 
	from	regra_envio_email_compra 
	where	nr_sequencia = nr_seq_regra_w;
 
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
 
	if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then 
		ds_destinatarios_w	:= ds_destinatarios_w || ';' || ds_email_adicional_w;
	end if;
 
	if (ds_destinatarios_w IS NOT NULL AND ds_destinatarios_w::text <> '') then 
		begin 
 
		if (ie_momento_envio_w = 'A') then 
			begin 
 
			CALL sup_grava_envio_email( 
				'CC', 
				'78', 
				nr_cot_compra_w, 
				nr_seq_aprovacao_p, 
				nr_seq_proc_aprov_p, 
				ds_destinatarios_w, 
				nm_usuario_origem_w, 
				ds_email_origem_w, 
				ds_assunto_w, 
				ds_mensagem_w, 
				cd_estabelecimento_p, 
				nm_usuario_p);
 
			end;
		else 
			begin			 
			CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_destinatarios_w,nm_usuario_origem_w,'M');
			exception 
			when others then 
				/*gravar__log__tasy(91301,'Falha ao enviar e-mail compras - Evento: 78 - Seq. Regra: ' || nr_seq_regra_w,nm_usuario_p);*/
 
				CALL gerar_historico_cotacao( 
					nr_cot_compra_w, 
					wheb_mensagem_pck.get_texto(299745), 
					wheb_mensagem_pck.get_texto(299917, 'NR_SEQ_REGRA=' || nr_seq_regra_w), 
					'S', 
					nm_usuario_p);
			end;
		end if;
 
		end;
	end if;
 
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE envia_email_cot_reprov ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

