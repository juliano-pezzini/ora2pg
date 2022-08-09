-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_email_final_cot_comp ( nr_cot_compra_p bigint, cd_material_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
nr_seq_regra_w			bigint;
ds_email_remetente_w		varchar(255);
ds_email_adicional_w		varchar(2000);
cd_perfil_dispara_w			integer;
ie_momento_envio_w		varchar(1);
ie_envia_pessoa_deleg_w		varchar(1);
ds_assunto_w			varchar(255);
ds_mensagem_w			varchar(4000);
ds_destinatarios_w			varchar(4000);
nm_usuario_receb_w		varchar(15);
ds_email_w			varchar(255);
ie_existe_w			varchar(1);
ds_material_w			varchar(255);
ds_email_origem_w			varchar(255);
nm_usuario_origem_w		varchar(255);
nr_atendimento_w			material_atend_paciente.nr_atendimento%type;
nr_seq_autorizacao_w		autorizacao_cirurgia.nr_sequencia%type;
nm_paciente_w			pessoa_fisica.nm_pessoa_fisica%type;
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;

C01 CURSOR FOR 
	SELECT	coalesce(nr_sequencia,0), 
		coalesce(ds_email_remetente,'X'), 
		replace(ds_email_adicional,',',';'), 
		cd_perfil_disparar, 
		coalesce(ie_momento_envio,'I'), 
		coalesce(ie_envia_pessoa_deleg,'N') 
	from	regra_envio_email_compra 
	where	ie_tipo_mensagem = 97 
	and	ie_situacao = 'A' 
	and	cd_estabelecimento = cd_estabelecimento_p;

C03 CURSOR FOR 
	SELECT	nm_usuario_receb 
	from	regra_envio_email_usu 
	where	nr_seq_regra = nr_seq_regra_w 
	and	(nm_usuario_receb IS NOT NULL AND nm_usuario_receb::text <> '');


BEGIN 
open C01;
loop 
fetch C01 into 
	nr_seq_regra_w, 
	ds_email_remetente_w, 
	ds_email_adicional_w, 
	cd_perfil_dispara_w, 
	ie_momento_envio_w, 
	ie_envia_pessoa_deleg_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
 
	if	((coalesce(cd_perfil_dispara_w::text, '') = '') or 
		(cd_perfil_dispara_w IS NOT NULL AND cd_perfil_dispara_w::text <> '' AND cd_perfil_dispara_w = obter_perfil_ativo)) then 
 
		select	ds_assunto, 
			ds_mensagem_padrao 
		into STRICT	ds_assunto_w, 
			ds_mensagem_w 
		from	regra_envio_email_compra 
		where	nr_sequencia = nr_seq_regra_w;
 
		ds_destinatarios_w	:= null;
 
		open C03;
		loop 
		fetch C03 into 
			nm_usuario_receb_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			select	ds_email 
			into STRICT	ds_email_w 
			from	usuario 
			where	nm_usuario = nm_usuario_receb_w;
 
			if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then 
				begin 
 
				select	coalesce(max('S'),'N') 
				into STRICT	ie_existe_w 
				 
				where	upper(ds_destinatarios_w) like upper('%' || ds_email_w || '%');
 
				if (ie_existe_w = 'N') then 
					begin 
					ds_destinatarios_w	:= substr(ds_destinatarios_w || ds_email_w || ';',1,4000);
					end;
				end if;
 
				end;
			end if;
 
			end;
		end loop;
		close C03;
		 
		begin 
		select	max(a.nr_atendimento), 
			max(a.nr_sequencia), 
			substr(max(coalesce(obter_nome_pf(a.cd_pessoa_fisica),coalesce(obter_nome_paciente_agenda(a.nr_seq_agenda),obter_dados_atendimento(a.nr_atendimento,'NP')))),1,255) nm_paciente 
		into STRICT	nr_atendimento_w, 
			nr_seq_autorizacao_w, 
			nm_paciente_w 
		from	autorizacao_cirurgia a, 
			material_autor_cirurgia b 
		where	a.nr_sequencia = b.nr_seq_autorizacao 
		and	b.nr_cot_compra = nr_cot_compra_p 
		and	b.cd_material = cd_material_p;
		exception 
		when others then 
			nm_paciente_w := '';
		end;
	 
		select	ds_material 
		into STRICT	ds_material_w 
		from	material 
		where	cd_material = cd_material_p;
		 
		select	coalesce(max(ds_razao_social),'') 
		into STRICT	ds_razao_social_w 
		from	pessoa_juridica 
		where	cd_cgc = nm_usuario_p; /*O usuario nesse caso sempre é o CNPJ do fornecedor que acessa pelo portal.*/
 
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@cdMAterial', cd_material_p);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@nr_atendimento', nr_atendimento_w);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@nr_seq_autorizacao', nr_seq_autorizacao_w);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@nm_paciente', nm_paciente_w);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@cotacao', nr_cot_compra_p);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@cnpj', nm_usuario_p); /*O usuario nesse caso sempre é o CNPJ do fornecedor que acessa pelo portal.*/
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@razao_pj', ds_razao_social_w);
		ds_assunto_w	:= replace_macro(ds_assunto_w, '@dsMaterial', ds_material_w);
		ds_assunto_w	:= substr(ds_assunto_w, 1, 255);
 
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@cdMAterial', cd_material_p), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nr_atendimento', nr_atendimento_w), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nr_seq_autorizacao', nr_seq_autorizacao_w), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@nm_paciente', nm_paciente_w), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@cotacao', nr_cot_compra_p), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@cnpj', nm_usuario_p), 1, 4000); /*O usuario nesse caso sempre é o CNPJ do fornecedor que acessa pelo portal.*/
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@razao_pj', ds_razao_social_w), 1, 4000);
		ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w, '@dsMaterial', ds_material_w), 1, 4000);
		ds_mensagem_w	:= substr(ds_mensagem_w, 1, 4000);
 
		select	a.ds_email 
		into STRICT	ds_email_origem_w 
		from	pessoa_juridica a 
		where	a.cd_cgc = nm_usuario_p;
		 
		select	obter_usuario_pf(cd_comprador_padrao) 
		into STRICT	nm_usuario_origem_w 
		from	parametro_compras 
		where	cd_estabelecimento = cd_estabelecimento_p;
		 
		if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then 
			begin 
			ds_destinatarios_w	:= substr(ds_destinatarios_w || ds_email_adicional_w,1,4000);
			end;
		end if;
		 
		ds_destinatarios_w := substr(replace(replace(replace(ds_destinatarios_w,chr(9),''),chr(10),''),chr(13),''),1,4000);
 
		CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_destinatarios_w,nm_usuario_origem_w,'M');
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
-- REVOKE ALL ON PROCEDURE envia_email_final_cot_comp ( nr_cot_compra_p bigint, cd_material_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
