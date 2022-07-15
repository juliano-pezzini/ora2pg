-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avisar_fornec_validade_doc ( cd_estabelecimento_p bigint) AS $body$
DECLARE



cd_cgc_w				varchar(14);
ds_razao_social_w				pessoa_juridica.ds_razao_social%type;
nm_fantasia_w				varchar(80);
ds_comprador_padrao_w			varchar(100);
ds_responsavel_compras_w			varchar(100);
nr_registro_resp_tecnico_w			varchar(20);
ds_orgao_reg_resp_tecnico_w		varchar(10);
dt_validade_resp_tecnico_w			timestamp;
nr_alvara_sanitario_w			varchar(20);
dt_validade_alvara_sanit_w			timestamp;
nr_alvara_sanitario_munic_w			varchar(20);
dt_validade_alvara_munic_w			timestamp;
nr_certificado_boas_prat_w			varchar(20);
dt_validade_cert_boas_prat_w		timestamp;
nr_autor_func_w				pessoa_juridica.nr_autor_func%type;
dt_validade_autor_func_w			timestamp;
ds_mensagem_w				varchar(2000);
ds_assunto_w				varchar(255);
nm_usuario_compras_w			varchar(15);
ds_lista_documentos_w			varchar(2000);
nr_seq_regra_w				bigint;
ie_usuario_w				varchar(3);
ds_email_destino_w				varchar(255);
ds_email_adicional_w			varchar(2000);
ds_email_origem_w				varchar(255);
nr_telefone_w				varchar(15);
nr_dias_aviso_fornec_w			varchar(150);	

c01 CURSOR FOR
SELECT	cd_cgc,
	ds_razao_social,
	nm_fantasia,
	nr_registro_resp_tecnico,
	trunc(dt_validade_resp_tecnico),
	ds_orgao_reg_resp_tecnico,
	nr_alvara_sanitario,
	trunc(dt_validade_alvara_sanit),
	nr_alvara_sanitario_munic,
	trunc(dt_validade_alvara_munic),
	nr_certificado_boas_prat,
	trunc(dt_validade_cert_boas_prat),
	nr_autor_func,
	trunc(dt_validade_autor_func)
from	pessoa_juridica
where	ie_situacao = 'A'
and	((nr_dias_aviso_fornec_w = '0') OR
	obter_se_contido_char(SUBSTR(clock_timestamp(),1,2),nr_dias_aviso_fornec_w) = 'S')
and	((dt_validade_resp_tecnico IS NOT NULL AND dt_validade_resp_tecnico::text <> '') or (dt_validade_alvara_sanit IS NOT NULL AND dt_validade_alvara_sanit::text <> '') or (dt_validade_alvara_munic IS NOT NULL AND dt_validade_alvara_munic::text <> '') or (dt_validade_cert_boas_prat IS NOT NULL AND dt_validade_cert_boas_prat::text <> '') or (dt_validade_autor_func IS NOT NULL AND dt_validade_autor_func::text <> ''));

BEGIN

select	coalesce(max(nr_sequencia),0),
	coalesce(max(ie_usuario),'U'),
	max(replace(ds_email_adicional,',',';'))
into STRICT	nr_seq_regra_w,
	ie_usuario_w,
	ds_email_adicional_w
from	regra_envio_email_compra
where	ie_tipo_mensagem = 29
and	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_p;

select 	coalesce(nr_dias_aviso_fornec,'0')
into STRICT	nr_dias_aviso_fornec_w
from 	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

if (nr_seq_regra_w > 0) then
	open C01;
	loop
	fetch C01 into
		cd_cgc_w,
		ds_razao_social_w,
		nm_fantasia_w,
		nr_registro_resp_tecnico_w,
		dt_validade_resp_tecnico_w,
		ds_orgao_reg_resp_tecnico_w,
		nr_alvara_sanitario_w,
		dt_validade_alvara_sanit_w,
		nr_alvara_sanitario_munic_w,
		dt_validade_alvara_munic_w,
		nr_certificado_boas_prat_w,
		dt_validade_cert_boas_prat_w,
		nr_autor_func_w,
		dt_validade_autor_func_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	substr(obter_nome_pf_pj(cd_comprador_padrao,null),1,100),
			substr(obter_nome_pf_pj(cd_responsavel_compras,null),1,100),
			substr(obter_usuario_pessoa(coalesce(cd_responsavel_compras,cd_comprador_padrao)),1,15),
			nr_telefone,
			ds_email
		into STRICT	ds_comprador_padrao_w,
			ds_responsavel_compras_w,
			nm_usuario_compras_w,
			nr_telefone_w,
			ds_email_origem_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_p;
		
		select	coalesce(max(ds_email),'')
		into STRICT	ds_email_destino_w
		from	pessoa_juridica_estab
		where	cd_cgc = cd_cgc_w
		and	cd_estabelecimento = cd_estabelecimento_p;
		
		ds_mensagem_w 			:= '';
		ds_lista_documentos_w		:= '';
		
		if (dt_validade_resp_tecnico_w <= trunc(clock_timestamp())) then
			--'Registro de Responsavel Tecnico - ' || dt_validade_resp_tecnico_w || ' - Orgao: ' || ds_orgao_reg_resp_tecnico_w || '.'
			ds_lista_documentos_w := substr(ds_lista_documentos_w || wheb_mensagem_pck.get_texto(305473,'DT_VALIDADE_RESP_TECNICO_W='||dt_validade_resp_tecnico_w||';DS_ORGAO_REG_RESP_TECNICO_W='||ds_orgao_reg_resp_tecnico_w) || chr(13) || chr(10),1,2000);
		end if;
		
		if (dt_validade_alvara_sanit_w <= trunc(clock_timestamp())) then
			--Alvara Sanitario - ' || dt_validade_alvara_sanit_w || '.
			ds_lista_documentos_w := substr(ds_lista_documentos_w || wheb_mensagem_pck.get_texto(305478,'DT_VALIDADE_ALVARA_SANIT_W='||dt_validade_alvara_sanit_w) || chr(13) || chr(10),1,2000);
		end if;
		
		if (dt_validade_alvara_munic_w <= trunc(clock_timestamp())) then
			--Alvara Sanitario Municipal - ' || dt_validade_alvara_munic_w || '.
			ds_lista_documentos_w := substr(ds_lista_documentos_w || wheb_mensagem_pck.get_texto(305482,'DT_VALIDADE_ALVARA_MUNIC_W='||dt_validade_alvara_munic_w) || chr(13) || chr(10),1,2000);
		end if;
		
		if (dt_validade_cert_boas_prat_w <= trunc(clock_timestamp())) then
			--Certificado de Boas Praticas - ' || dt_validade_cert_boas_prat_w || '.
			ds_lista_documentos_w := substr(ds_lista_documentos_w || wheb_mensagem_pck.get_texto(305485,'DT_VALIDADE_CERT_BOAS_PRAT_W='||dt_validade_cert_boas_prat_w) || chr(13) || chr(10),1,2000);
		end if;
		
		if (dt_validade_autor_func_w <= trunc(clock_timestamp())) then
			--Alvara de Localizacao e Funcionamento Municipal - ' || dt_validade_autor_func_w || '.
			ds_lista_documentos_w := substr(ds_lista_documentos_w || wheb_mensagem_pck.get_texto(305487,'DT_VALIDADE_AUTOR_FUNC_W='||dt_validade_autor_func_w) || chr(13) || chr(10),1,2000);
		end if;

		if (coalesce(ds_lista_documentos_w,'X') <> 'X') then			
			select	substr(ds_assunto,1,255),
				substr(ds_mensagem_padrao,1,2000)
			into STRICT	ds_assunto_w,
				ds_mensagem_w
			from	regra_envio_email_compra
			where	nr_sequencia = nr_seq_regra_w;
			
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@cnpj',cd_cgc_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@razao_pj',ds_razao_social_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@fantasia_pj',nm_fantasia_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@lista_doc',ds_lista_documentos_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@comprador',ds_comprador_padrao_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@resp_compras',ds_responsavel_compras_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@fone',nr_telefone_w),1,255);
			
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@cnpj',cd_cgc_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@razao_pj',ds_razao_social_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@fantasia_pj',nm_fantasia_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@lista_doc',ds_lista_documentos_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@comprador',ds_comprador_padrao_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@resp_compras',ds_responsavel_compras_w),1,2000);
			ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@fone',nr_telefone_w),1,2000);

			if (coalesce(ds_mensagem_w,'X') <> 'X') and (coalesce(ds_email_origem_w,'X') <> 'X') and (coalesce(ds_email_destino_w,'X') <> 'X') and (coalesce(nm_usuario_compras_w,'X') <> 'X') then
				begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_email_destino_w,nm_usuario_compras_w,'M');
				exception when others then
					ds_assunto_w := '';
				end;
			end if;
		end if;
		end;
	end loop;
	close C01;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avisar_fornec_validade_doc ( cd_estabelecimento_p bigint) FROM PUBLIC;

