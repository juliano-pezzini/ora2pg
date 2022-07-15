-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_reenviar_email_parecer_la (nr_seq_registro_p bigint, cd_material_p bigint, cd_destinatario_p text, cd_grupo_destino_p text, nm_usuario_p text) AS $body$
DECLARE


ds_mensagem_w				varchar(4000);
ds_assunto_w				varchar(255);
nm_usuario_origem_w			varchar(255);
ds_email_origem_w			varchar(255);
ds_email_w					varchar(255);
ds_email_remetente_w		varchar(255);
ds_parecer_w				varchar(4000);
cd_pessoa_dest_w			varchar(10);
cd_pessoa_grupo_w			varchar(10);
nr_seq_parecer_w			bigint;
cd_material_w				bigint;
ds_material_w				varchar(255);
ds_tipo_parecer_w			varchar(255);
ds_destinatarios_w			varchar(255);
nr_seq_grupo_w				bigint;
ie_comunic_interna_w		varchar(1);
ie_email_w					varchar(1);
nr_seq_comunic_w			bigint;
nm_usuario_dest_w			varchar(4000);
ds_resposta_w				varchar(4000);
hr_prev_resposta_w			timestamp;
nr_seq_tipo_parecer_w		bigint;
nr_seq_parecer_duplicado_w	bigint;
qt_selecionados_w			integer;

C01 CURSOR FOR
	SELECT	cd_destinatario_p
	
	where	(cd_destinatario_p IS NOT NULL AND cd_destinatario_p::text <> '')
	
union

	SELECT	cd_pessoa_grupo
	from	pcs_pessoas_grupo_dest
	where	nr_seq_grupo = cd_grupo_destino_p
	and		(cd_pessoa_grupo IS NOT NULL AND cd_pessoa_grupo::text <> '')
	and		(cd_grupo_destino_p IS NOT NULL AND cd_grupo_destino_p::text <> '');


C02 CURSOR FOR
	SELECT  distinct c.ds_parecer,
			b.cd_material,
			obter_desc_material(b.cd_material),
			c.nr_sequencia,
			substr(obter_descricao_padrao('PCS_TIPO_PARECER','DS_TIPO_PARECER',c.NR_SEQ_TIPO_PARECER),1,255),
			c.ie_comunic_interna,
			c.ie_email,
			c.ds_resposta,
			c.hr_prev_resposta,
			c.nr_seq_tipo_parecer
	from	pcs_reg_analise a,
			pcs_reg_analise_itens b,
			pcs_parecer c
	where	a.nr_sequencia = b.nr_seq_registro
	and		b.cd_material = c.cd_material
	and		a.nr_sequencia = nr_seq_registro_p
	and		b.cd_material = cd_material_p
	and		c.ie_selecionado = 'S'
	and		((c.ie_comunic_interna = 'S') or (c.ie_email = 'S'))
	and		(c.dt_envio IS NOT NULL AND c.dt_envio::text <> '')   --Para reenviar, precisa que já esteja enviado.
	order by b.cd_material;


BEGIN

select	count(*)
into STRICT	qt_selecionados_w
from	pcs_reg_analise_itens a,
		pcs_parecer b
where	a.cd_material = b.cd_material
and		a.nr_seq_registro = nr_seq_registro_p
and		a.cd_material = cd_material_p
and 	(b.cd_pessoa_dest IS NOT NULL AND b.cd_pessoa_dest::text <> '')
and		b.ie_selecionado = 'S'
and		((ie_comunic_interna = 'S') or (ie_email = 'S'))
and		(b.dt_envio IS NOT NULL AND b.dt_envio::text <> '');

if (qt_selecionados_w = 0) then
	--É obrigatório marcar pelo menos um parecer e setar o registro para enviar comunicação interna ou e-mail!
	CALL wheb_mensagem_pck.exibir_mensagem_abort(295919);
end if;

select	max(ds_email)
into STRICT	ds_email_remetente_w
from	usuario
where	nm_usuario = nm_usuario_p;

open C01;
loop
fetch C01 into
	cd_pessoa_dest_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	max(ds_email) || ';',
			max(nm_usuario) || ','
	into STRICT	ds_destinatarios_w,
			nm_usuario_dest_w
	from	usuario
	where	cd_pessoa_fisica = cd_pessoa_dest_w;

	ds_mensagem_w := null;
	ds_mensagem_w	:= wheb_mensagem_pck.get_texto(316635,'NR_SEQ_LISTA_W='||nr_seq_registro_p);
	ds_assunto_w := null;

	open C02;
	loop
	fetch C02 into
		ds_parecer_w,
		cd_material_w,
		ds_material_w,
		nr_seq_parecer_w,
		ds_tipo_parecer_w,
		ie_comunic_interna_w,
		ie_email_w,
		ds_resposta_w,
		hr_prev_resposta_w,
		nr_seq_tipo_parecer_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		ds_assunto_w := substr(wheb_mensagem_pck.get_Texto(295898) || ' :  ' || wheb_mensagem_pck.get_Texto(295600) || ' ' || cd_material_w || ' - ' || ds_material_w,1,255);
		ds_mensagem_w := ds_mensagem_w || chr(13) || chr(10) || nr_seq_parecer_w || ' - ' || ds_tipo_parecer_w;
		ds_mensagem_w := substr(ds_mensagem_w || chr(13) || chr(10) || ds_parecer_w || chr(13) || chr(10),1,4000);
		ds_email_w := null;

		select	nextval('pcs_parecer_seq')
		into STRICT	nr_seq_parecer_duplicado_w
		;

		insert into pcs_parecer(cd_pessoa_dest,
						ds_parecer,
						ds_resposta,
						dt_atualizacao,
						dt_atualizacao_nrec,
						dt_envio,
						dt_parecer,
						dt_resposta,
						hr_prev_resposta,
						ie_comunic_interna,
						ie_email,
						ie_origem,
						ie_selecionado,
						nm_usuario,
						nm_usuario_envio,
						nm_usuario_nrec,
						nm_usuario_resp,
						nr_seq_grupo_dest,
						nr_seq_tipo_parecer,
						nr_sequencia,
						nr_seq_registro_pcs,
						cd_material,
						ie_status)
			values (		cd_pessoa_dest_w,
						ds_parecer_w,
						ds_resposta_w,
						clock_timestamp(),
						clock_timestamp(),
						clock_timestamp(),
						clock_timestamp(),
						null,
						hr_prev_resposta_w,
						ie_comunic_interna_w,
						ie_email_w,
						'L',
						'N',
						nm_usuario_p,
						null,
						nm_usuario_p,
						null,
						cd_grupo_destino_p,
						nr_seq_tipo_parecer_w,
						nr_seq_parecer_duplicado_w,
						nr_seq_registro_p,
						cd_material_p,
						'P');

		end;
	end loop;
	close C02;
		-- Parecer do item :
	if (coalesce(ie_email_w,'N') = 'S') then
		CALL enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_remetente_w,ds_destinatarios_w,nm_usuario_p,'M'); --coloquei o usuario maicon só pra testar, por causa do SMTP
		--enviar_email(ds_assunto_w,ds_mensagem_w,ds_email_remetente_w,'maurici@wheb.com.br','Maicon','M'); --coloquei o usuario maicon só pra testar, por causa do SMTP
	end if;

	if (coalesce(ie_comunic_interna_w,'N') = 'S') then

			select	nextval('comunic_interna_seq')
			into STRICT	nr_seq_comunic_w
			;

			insert	into comunic_interna(
						dt_comunicado,
						ds_titulo,
						ds_comunicado,
						nm_usuario,
						dt_atualizacao,
						ie_geral,
						nm_usuario_destino,
						nr_sequencia,
						ie_gerencial,
						dt_liberacao)
				values (	clock_timestamp(),
						ds_assunto_w,
						ds_mensagem_w,
						nm_usuario_p,
						clock_timestamp(),
						'N',
						nm_usuario_dest_w,
						nr_seq_comunic_w,
						'N',
						clock_timestamp());
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
-- REVOKE ALL ON PROCEDURE pcs_reenviar_email_parecer_la (nr_seq_registro_p bigint, cd_material_p bigint, cd_destinatario_p text, cd_grupo_destino_p text, nm_usuario_p text) FROM PUBLIC;

