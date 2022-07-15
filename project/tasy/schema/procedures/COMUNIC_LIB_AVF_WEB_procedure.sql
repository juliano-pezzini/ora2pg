-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE comunic_lib_avf_web ( nr_seq_avaliacao_p bigint, nm_usuario_p text) AS $body$
DECLARE




cd_perfil_w		bigint := obter_perfil_ativo;
cd_estab_w		smallint := Wheb_Usuario_pck.get_cd_estabelecimento;
ie_usuario_w		varchar(15);
cd_cnpj_w		varchar(14);
qt_existe_w		bigint;
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;
nm_fantasia_w		varchar(80);
ds_assunto_w		varchar(255);
ds_mensagem_padrao_w	varchar(2000);
ds_estab_w		varchar(255);
ds_email_origem_w		varchar(255);
ds_usuario_origem_w	varchar(255);
cd_cnpj_editado_w		varchar(20);
ds_email_usuario_w		varchar(255);
ds_usuario_w		varchar(255);
ds_email_adicional_w	varchar(255);
ds_email_destino_w		varchar(255);
ie_momento_envio_w	varchar(1);
ds_email_remetente_w	varchar(255);
ds_lista_email_destino_w	varchar(2000);

c01 CURSOR FOR
SELECT	ie_usuario,
	ds_assunto,
	ds_mensagem_padrao,
	ds_email_adicional,
	coalesce(ds_email_remetente,'X'),
	coalesce(ie_momento_envio,'I')
from	regra_envio_email_compra
where	ie_tipo_mensagem			= 45
and	ie_situacao 			= 'A'
and	cd_estabelecimento 		= cd_estab_w
and	coalesce(cd_perfil_disparar, cd_perfil_w) 	= cd_perfil_w;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	regra_envio_email_compra
where	ie_tipo_mensagem			= 45
and	ie_situacao 			= 'A'
and	cd_estabelecimento			= cd_estab_w
and	coalesce(cd_perfil_disparar, cd_perfil_w) 	= cd_perfil_w;

if (qt_existe_w > 0) then
	begin
	select	cd_cnpj
	into STRICT	cd_cnpj_w
	from	avf_resultado
	where	nr_sequencia = nr_seq_avaliacao_p;

	select	ds_razao_social,
		nm_fantasia,
		obter_cgc_cpf_editado(cd_cgc) cd_cnpj_editado,
		coalesce(substr(obter_dados_pf_pj_estab(cd_estab_w, null, cd_cgc, 'M'),1,255),ds_email) ds_email_destino
	into STRICT	ds_razao_social_w,
		nm_fantasia_w,
		cd_cnpj_editado_w,
		ds_email_destino_w
	from	pessoa_juridica
	where	cd_cgc = cd_cnpj_w;
	
	select	substr(coalesce(ds_fantasia,ds_razao_social),1,255)
	into STRICT	ds_estab_w
	from	estabelecimento_v
	where	cd_estabelecimento = cd_estab_w;
	
	select	ds_email,
		nm_usuario
	into STRICT	ds_email_usuario_w,
		ds_usuario_w
	from	usuario
	where	nm_usuario = nm_usuario_p;
	
	open C01;
	loop
	fetch C01 into	
		ie_usuario_w,
		ds_assunto_w,
		ds_mensagem_padrao_w,
		ds_email_adicional_w,
		ds_email_remetente_w,
		ie_momento_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_lista_email_destino_w := ds_email_destino_w;

		if (ie_usuario_w in ('U','O')) then --Usuario/comprador nao existe nesta regra, por isso passa usuario tambem
			ds_email_origem_w		:= ds_email_usuario_w;
			ds_usuario_origem_w	:= ds_usuario_w;
		elsif (ie_usuario_w = 'C') then --Setor compras
			select	ds_email
			into STRICT	ds_email_origem_w
			from	parametro_compras
			where	cd_estabelecimento = cd_estab_w;
			
			ds_usuario_origem_w	:= ds_estab_w;
		end if;
		
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@cnpj_editado', cd_cnpj_editado_w),1,2000);
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@cnpj', cd_cnpj_w),1,2000);
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@fantasia_pj', nm_fantasia_w),1,2000);
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@razao_pj', ds_razao_social_w),1,2000);
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@email', ds_email_usuario_w),1,2000);
		ds_mensagem_padrao_w	:= substr(replace_macro(ds_mensagem_padrao_w, '@nr_avaliacao', nr_seq_avaliacao_p),1,2000);
		
		if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then
			ds_lista_email_destino_w := substr(ds_email_adicional_w || ';' || ds_lista_email_destino_w,1,2000);
		end if;

		if (ds_email_remetente_w <> 'X') then
			ds_email_origem_w	:= ds_email_remetente_w;
		end if;
		
		if (coalesce(ds_lista_email_destino_w,'X') <> 'X') then
			begin

			if (ie_momento_envio_w = 'A') then
				begin

				CALL sup_grava_envio_email(
					'PJ',
					'45',
					nr_seq_avaliacao_p,
					null,
					null,
					ds_lista_email_destino_w,
					nm_usuario_p,
					ds_email_origem_w,
					ds_assunto_w,
					ds_mensagem_padrao_w,
					cd_estab_w,
					nm_usuario_p);

				end;
			else
				begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_padrao_w,ds_email_origem_w,ds_lista_email_destino_w,nm_usuario_p,'M');
				exception when others then
					ds_assunto_w := '';
				end;
			end if;			
			end;
		end if;
		end;
	end loop;
	close C01;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE comunic_lib_avf_web ( nr_seq_avaliacao_p bigint, nm_usuario_p text) FROM PUBLIC;

