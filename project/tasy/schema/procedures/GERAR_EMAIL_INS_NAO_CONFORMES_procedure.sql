-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_email_ins_nao_conformes ( nr_seq_registro_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
 
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
nr_nota_fiscal_w		nota_fiscal.nr_nota_fiscal%type;
ds_fornecedor_w			pessoa_juridica.ds_razao_social%type;
cd_cnpj_w			pessoa_juridica.cd_cgc%type;
nr_seq_tipo_nao_conf_w		inspecao_recebimento.nr_seq_tipo_nao_conf%type;
ds_email_fornec_w		pessoa_juridica_estab.ds_email%type;
ds_material_w			material.ds_material%type;
ds_lista_material_w		varchar(4000);
ds_lista_w			varchar(4000);
ds_nao_conforme_w		inspecao_nao_conf.ds_tipo%type;
nr_seq_regra_w			regra_envio_email_compra.nr_sequencia%type;
ds_email_adicional_w		regra_envio_email_compra.ds_email_adicional%type;
cd_perfil_disparar_w		regra_envio_email_compra.cd_perfil_disparar%type;
ds_email_remetente_w		regra_envio_email_compra.ds_email_remetente%type;
ie_momento_envio_w		regra_envio_email_compra.ie_momento_envio%type;
ds_email_origem_w		usuario.ds_email%type;
ds_assunto_w			varchar(255);
ds_mensagem_w			varchar(4000);

 
C01 CURSOR FOR 
SELECT	nr_sequencia, 
	ds_email_adicional, 
	cd_perfil_disparar, 
	coalesce(ds_email_remetente,'X'), 
	coalesce(ie_momento_envio,'I') 
from	regra_envio_email_compra 
where	ie_tipo_mensagem = 103 
and	ie_situacao = 'A' 
and	cd_estabelecimento = cd_estabelecimento_w 
and	obter_se_envia_email_regra(nr_seq_registro_p, 'IR', 103, cd_estabelecimento_w) = 'S';

c02 CURSOR FOR 
SELECT	nr_seq_tipo_nao_conf 
from	inspecao_recebimento 
where	nr_seq_registro = nr_seq_registro_p 
and	(nr_seq_tipo_nao_conf IS NOT NULL AND nr_seq_tipo_nao_conf::text <> '') 
group by nr_seq_tipo_nao_conf;

c03 CURSOR FOR 
SELECT	ds_material 
from	material a, 
	inspecao_recebimento b 
where	a.cd_material = b.cd_material 
and	b.nr_seq_registro = nr_seq_registro_p 
and	b.nr_seq_tipo_nao_conf = nr_seq_tipo_nao_conf_w;

 

BEGIN 
ds_lista_w	:= '';
 
select	cd_estabelecimento, 
	substr(obter_nota_registro_inspecao(nr_sequencia),1,255), 
	cd_cnpj, 
	substr(obter_nome_pf_pj(null,cd_cnpj),1,255) 
into STRICT	cd_estabelecimento_w, 
	nr_nota_fiscal_w, 
	cd_cnpj_w, 
	ds_fornecedor_w 
from	inspecao_registro 
where	nr_sequencia = nr_seq_registro_p;
 
select	obter_dados_pf_pj_estab(cd_estabelecimento_w, null, cd_cnpj_w, 'M') 
into STRICT	ds_email_fornec_w
;
 
if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') and (ds_email_fornec_w IS NOT NULL AND ds_email_fornec_w::text <> '') then 
 
	open C02;
	loop 
	fetch C02 into 
		nr_seq_tipo_nao_conf_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
 
		select	ds_tipo 
		into STRICT	ds_nao_conforme_w 
		from	inspecao_nao_conf 
		where	nr_sequencia = nr_seq_tipo_nao_conf_w;
 
		ds_lista_material_w	:= '';
 
		open C03;
		loop 
		fetch C03 into 
			ds_material_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin 
			ds_lista_material_w	:= substr(ds_lista_material_w || '  ' || ds_material_w || chr(13) || chr(10),1,4000);
			end;
		end loop;
		close C03;
 
		ds_lista_w		:= substr(ds_lista_w || ds_nao_conforme_w || chr(13) || chr(10) || ds_lista_material_w || chr(13) || chr(10),1,4000);
 
		end;
	end loop;
	close C02;
 
	if (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then 
 
 
		open C01;
		loop 
		fetch C01 into 
			nr_seq_regra_w, 
			ds_email_adicional_w, 
			cd_perfil_disparar_w, 
			ds_email_remetente_w, 
			ie_momento_envio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
 
			if (coalesce(cd_perfil_disparar_w::text, '') = '') or (cd_perfil_disparar_w IS NOT NULL AND cd_perfil_disparar_w::text <> '') and (cd_perfil_disparar_w = obter_perfil_ativo) then 
 
 
				select	substr(ds_assunto,1,255), 
					substr(ds_mensagem_padrao,1,4000) 
				into STRICT	ds_assunto_w, 
					ds_mensagem_w 
				from	regra_envio_email_compra 
				where	nr_sequencia = nr_seq_regra_w;
 
				ds_assunto_w := replace_macro(ds_assunto_w, '@cnpj',cd_cnpj_w);
				ds_assunto_w := replace_macro(ds_assunto_w, '@razao_pj',ds_fornecedor_w);
				ds_assunto_w := replace_macro(ds_assunto_w, '@nr_nota_fiscal',nr_nota_fiscal_w);
				ds_assunto_w := substr(replace_macro(ds_assunto_w, '@lista_itens',ds_lista_w),1,255);
 
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@cnpj',cd_cnpj_w);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@razao_pj',ds_fornecedor_w);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@nr_nota_fiscal',nr_nota_fiscal_w);
				ds_mensagem_w := substr(replace_macro(ds_mensagem_w, '@lista_itens',ds_lista_w),1,4000);
 
 
				if (ds_email_adicional_w IS NOT NULL AND ds_email_adicional_w::text <> '') then 
					ds_email_fornec_w := substr(ds_email_fornec_w || ';' || ds_email_adicional_w,1,2000);
				end if;
 
				select	coalesce(max(ds_email),'X') 
				into STRICT	ds_email_origem_w 
				from	usuario 
				where	nm_usuario = nm_usuario_p;
 
				if (ds_email_remetente_w <> 'X') then 
					ds_email_origem_w	:= ds_email_remetente_w;
				end if;
 
				if (ie_momento_envio_w = 'A') and (ds_email_origem_w <> 'X') then 
					begin 
 
					CALL sup_grava_envio_email( 
						'IR', 
						'103', 
						nr_seq_registro_p, 
						null, 
						null, 
						ds_email_fornec_w, 
						nm_usuario_p, 
						ds_email_origem_w, 
						ds_assunto_w, 
						ds_mensagem_w, 
						cd_estabelecimento_w, 
						nm_usuario_p);
 
					end;
				else 
					begin 
					CALL enviar_email(	ds_assunto_w, 
							ds_mensagem_w, 
							null, 
							ds_email_fornec_w, 
							nm_usuario_p, 
							'M');
					exception 
						when others then 
						ds_mensagem_w := '';
					end;
				end if;
			end if;
 
			end;
		end loop;
		close C01;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_email_ins_nao_conformes ( nr_seq_registro_p bigint, nm_usuario_p text) FROM PUBLIC;
