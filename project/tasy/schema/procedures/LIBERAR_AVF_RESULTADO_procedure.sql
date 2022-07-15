-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_avf_resultado ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, ds_mensagem_p text, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w			bigint;
ie_envia_comunic_w		varchar(1);
nm_usuario_destino_w		varchar(4000);
cd_cnpj_w			varchar(18);
ds_razao_social_w			pessoa_juridica.ds_razao_social%type;
nr_seq_regra_w			bigint;
ds_titulo_w			varchar(80);
ds_comunicado_w			varchar(4000);
qt_regra_usuario_w			bigint;
nr_seq_comunic_w			bigint;
nr_seq_classif_w			bigint;
ds_tipo_aval_w			varchar(100);
ds_fornecedor_w			varchar(100);
cd_estabelecimento_w		smallint;
cd_perfil_w			varchar(10);
ie_ci_lida_w			varchar(1);
/* Se tiver setor na regra, envia CI para os setores */

ds_setor_adicional_w                   	varchar(2000) := '';
/* Campos da regra Usuario da Regra */

cd_setor_regra_usuario_w		integer;

c05 CURSOR FOR
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento
from	regra_envio_comunic_usu a
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	avf_resultado_item
where	nr_seq_resultado = nr_sequencia_p;

if (qt_existe_w = 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(454840); /*E necessario ter pelo menos uma pergunta para liberar a avaliacao*/
end if;

update	avf_resultado
set	dt_liberacao	= clock_timestamp()
where	nr_sequencia	= nr_sequencia_p;

select	substr(obter_nome_avf_tipo_avaliacao(nr_seq_tipo_aval),1,100),
	substr(obter_nome_pf_pj(null,cd_cnpj),1,100),
	cd_estabelecimento
into STRICT	ds_tipo_aval_w,
	ds_fornecedor_w,
	cd_estabelecimento_w
from	avf_resultado
where	nr_sequencia = nr_sequencia_p;

select	coalesce(max(b.nr_sequencia), 0),
	max(cd_perfil)
into STRICT	nr_seq_regra_w,
	cd_perfil_w
from	regra_envio_comunic_compra a,
	regra_envio_comunic_evento b
where	a.nr_sequencia = b.nr_seq_regra
and	a.cd_funcao = 6
and	b.cd_evento = 19
and	b.ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_w
and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_sequencia_p,'AF',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

select	obter_usuario_pessoa(cd_pessoa_resp),
	obter_cgc_cpf_editado(cd_cnpj),
	substr(obter_nome_pf_pj(null, cd_cnpj),1,255)
into STRICT	nm_usuario_destino_w,
	cd_cnpj_w,
	ds_razao_social_w
from	avf_resultado
where	nr_sequencia = nr_sequencia_p;

if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') and
	((nr_seq_regra_w = 0) or (ds_mensagem_p <> '')) then
	begin

	ds_comunicado_w := substr(WHEB_MENSAGEM_PCK.get_texto(310224) || cd_cnpj_w || ' - ' || ds_razao_social_w  || '.' --Existe uma pendencia para avaliacao do fornecedor
									  || chr(13) || chr(10) || chr(13) || chr(10) || ds_mensagem_p,1,4000);
	CALL gerar_comunic_padrao(clock_timestamp(),
		WHEB_MENSAGEM_PCK.get_texto(310225) , --Aviso de pendencia para avaliacao de fornecedor.
		ds_comunicado_w,
		nm_usuario_p,
		'N',
		nm_usuario_destino_w,
		'N',null,'',null,'',clock_timestamp(),'','');
	
	end;
end if;

if (nr_seq_regra_w > 0) then

	open C05;
	loop
	fetch C05 into	
		cd_setor_regra_usuario_w;
	EXIT WHEN NOT FOUND; /* apply on C05 */
		begin
		if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then
			ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
		end if;
		end;
	end loop;
	close C05;

	select	max(substr(ds_titulo,1,80)),
		max(substr(ds_comunicacao,1,4000)) ds_comunicacao
	into STRICT	ds_titulo_w,
		ds_comunicado_w
	from	regra_envio_comunic_evento
	where	nr_sequencia = nr_seq_regra_w;
	
	ds_comunicado_w := substr(replace_macro(ds_comunicado_w,'@tp_avaliacao', ds_tipo_aval_w),1,4000);
	ds_comunicado_w := substr(replace_macro(ds_comunicado_w,'@fornecedor', ds_fornecedor_w),1,4000);
	ds_comunicado_w := substr(replace_macro(ds_comunicado_w,'@nr_avaliacao', nr_sequencia_p),1,4000);
	ds_comunicado_w := substr(replace_macro(ds_comunicado_w,'@cnpj', cd_cnpj_w),1,4000);

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

	if (qt_regra_usuario_w > 0) then
		nm_usuario_destino_w := obter_usuarios_comunic_compras(nr_sequencia_p, null, 19, nr_seq_regra_w, nm_usuario_p);
	end if;

	if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then

		select	obter_classif_comunic('F')
		into STRICT	nr_seq_classif_w
		;

		select	nextval('comunic_interna_seq')
		into STRICT	nr_seq_comunic_w
		;
		
		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
			cd_perfil_w := cd_perfil_w ||',';
		end if;

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
			dt_liberacao,
			nr_seq_resultado,
			ds_perfil_adicional,
			ds_setor_adicional)
		values (	clock_timestamp(),
			ds_titulo_w,
			ds_comunicado_w,
			nm_usuario_p,
			clock_timestamp(),
			'N',
			nm_usuario_destino_w,
			nr_seq_comunic_w,
			'N',
			nr_seq_classif_w,
			clock_timestamp(),
			nr_sequencia_p,
			cd_perfil_w,
			ds_setor_adicional_w);

		/*Para que a comunicacao seja gerada como lida ao proprio usuario */

		if (ie_ci_lida_w = 'S') then
			insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
		end if;

	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_avf_resultado ( nr_sequencia_p bigint, cd_estabelecimento_p bigint, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;

