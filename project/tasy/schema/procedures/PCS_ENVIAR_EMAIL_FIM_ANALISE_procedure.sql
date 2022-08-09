-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_enviar_email_fim_analise (nr_seq_registro_p bigint, ds_destinatarios_p text, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*Regra*/

qt_existe_regra_w		bigint;
ds_mensagem_w			varchar(4000);
ds_assunto_w			varchar(80);
ds_email_origem_w		varchar(255);
ds_email_destino_w		varchar(255);
ie_prioridade_w			varchar(1);
ie_usuario_w			varchar(1);
nr_seq_regra_w			bigint;
ds_email_adicional_w	varchar(2000);
cd_perfil_disparar_w	integer;
ie_existe_regra_w		varchar(1);
ds_destinatarios_w		varchar(4000);
ds_email_remetente_w	varchar(255);
nm_usuario_origem_w		varchar(255);
cd_material_w			integer;

/*Macros*/

ds_lista_w			varchar(4000);
ds_material_w		varchar(255);
nr_ordem_servico_w	bigint;

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
	and		ie_tipo_mensagem = 102
	and		ie_situacao = 'A';


C03 CURSOR FOR
	SELECT	distinct b.cd_material,
			substr(obter_desc_material(b.cd_material),1,255)
	from	pcs_reg_analise a,
			pcs_reg_analise_itens b
	where	a.nr_sequencia = b.nr_seq_registro
	and		a.nr_sequencia = nr_seq_registro_p;


BEGIN

select	nr_ordem_serv
into STRICT	nr_ordem_servico_w
from	pcs_reg_analise a
where	a.nr_sequencia = nr_seq_registro_p;

select	ds_email,
		nm_usuario
into STRICT	ds_email_origem_w,
		nm_usuario_origem_w
from	usuario
where	nm_usuario = nm_usuario_p;

if (ds_destinatarios_p IS NOT NULL AND ds_destinatarios_p::text <> '') then
	ds_destinatarios_w := ds_destinatarios_p || ';';
end if;

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
	ds_lista_w := null;

	ds_destinatarios_w := ds_destinatarios_w || ds_email_adicional_w || ';';

	open C03;
	loop
	fetch C03 into
		cd_material_w,
		ds_material_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		ds_lista_w := substr(ds_lista_w || cd_material_w || ' - ' || ds_material_w || chr(13) || chr(10),1,4000);
		end;
	end loop;
	close C03;

	ds_assunto_w := substr(replace_macro(ds_assunto_w,'@ds_lista',ds_lista_w),1,80);
	ds_assunto_w := substr(replace_macro(ds_assunto_w,'@nr_ordem_servico',to_char(nr_ordem_servico_w)),1,80);
	ds_assunto_w := substr(replace_macro(ds_assunto_w,'@nr_seq_registro',to_char(nr_seq_registro_p)),1,80);

	ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@ds_lista',ds_lista_w),1,4000);
	ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@nr_ordem_servico',to_char(nr_ordem_servico_w)),1,4000);
	ds_mensagem_w := substr(replace_macro(ds_mensagem_w,'@nr_seq_registro',to_char(nr_seq_registro_p)),1,4000);

	end;
end loop;
close C01;

if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
	ds_mensagem_w := substr(ds_observacao_p || chr(13) || chr(10) || ds_mensagem_w,1,4000);
end if;

if ((ds_email_origem_w IS NOT NULL AND ds_email_origem_w::text <> '') and (ds_destinatarios_w IS NOT NULL AND ds_destinatarios_w::text <> '') and (nm_usuario_origem_w IS NOT NULL AND nm_usuario_origem_w::text <> '')) then
	begin
	CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_origem_w,ds_destinatarios_w,nm_usuario_origem_w,'M');

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_enviar_email_fim_analise (nr_seq_registro_p bigint, ds_destinatarios_p text, ds_observacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
