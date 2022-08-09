-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE envia_ci_autor_pendente (nr_seq_autor_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_evento_p bigint) AS $body$
DECLARE


nr_seq_regra_w			bigint;
nm_usuarios_adic_w		varchar(255);
cd_setor_regra_usuario_w	integer;
ds_perfil_adicional_w	varchar(4000) := '';
nm_usuario_envio_w			varchar(15) := '';
ds_setor_adicional_w	varchar(2000) := '';
cd_perfil_usuario_w		integer;
ds_material_w			varchar(255);
ds_titulo_w				varchar(80);
ds_comunicado_w		varchar(32000);
cd_perfil_w				varchar(10);
ie_ci_lida_w			varchar(1);
nm_usuarios_destino_w	varchar(255);
nr_seq_classif_w		bigint;
nr_seq_comunic_w		bigint;
ds_perfil_enviar_w		varchar(4000);
nm_usuarios_evento_w	varchar(255);
nm_usuario_adicional_w	varchar(4000);
cd_setor_evento_w		integer;
ds_lista_material_w		varchar(4000);
nr_cot_compra_w			bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.nm_usuarios_adic
	from	regra_envio_comunic_compra a,
		regra_envio_comunic_evento b
	where	a.nr_sequencia = b.nr_seq_regra
	and	a.cd_funcao = cd_funcao_p
	and	b.cd_evento = cd_evento_p
	and	b.ie_situacao = 'A'
	and	cd_estabelecimento = cd_estabelecimento_p
	and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,null,'CC',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';

C02 CURSOR FOR
	SELECT	coalesce(a.cd_setor_atendimento,0),
		coalesce(a.cd_perfil,0),
		coalesce(a.nm_usuario_envio,'0')
	from	regra_envio_comunic_usu a
	where	a.nr_seq_evento = nr_seq_regra_w;


C03 CURSOR FOR
	SELECT	cd_material||' - '||
		substr(obter_desc_estrut_mat(null, null, null, cd_material),1,100),
		nr_cot_compra
	from	material_autor_cirurgia
	where	nr_seq_autorizacao = nr_seq_autor_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	nm_usuario_adicional_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		cd_setor_regra_usuario_w,
		cd_perfil_usuario_w,
		nm_usuario_envio_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then
			ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
		end if;
		if (cd_perfil_usuario_w <> 0) and (obter_se_contido_char(cd_perfil_usuario_w, ds_perfil_adicional_w) = 'N') then
			ds_perfil_adicional_w := substr(ds_perfil_adicional_w || cd_perfil_usuario_w || ',',1,4000);
		end if;
		if (nm_usuario_envio_w <> '0') and (obter_se_contido_char(nm_usuario_envio_w, nm_usuario_adicional_w) = 'N') then
			begin
			nm_usuario_adicional_w :=  substr(nm_usuario_adicional_w||','|| nm_usuario_envio_w,1,4000);
			end;
		end if;
		end;
	end loop;
	close C02;

	ds_lista_material_w	:= null;

	open C03;
	loop
	fetch C03 into
		ds_material_w,
		nr_cot_compra_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin

		ds_lista_material_w := substr(ds_lista_material_w || ds_material_w ||' '|| chr(13) || chr(10),1,3200);

		end;
	end loop;
	close C03;

	select	max(substr(ds_titulo,1,80)),
		max(ds_comunicacao),
		max(cd_perfil),
		max(cd_setor_destino)
	into STRICT	ds_titulo_w,
		ds_comunicado_w,
		cd_perfil_w,
		cd_setor_evento_w
	from	regra_envio_comunic_evento
	where	nr_sequencia = nr_seq_regra_w;

	select	coalesce(ie_ci_lida,'N')
	into STRICT	ie_ci_lida_w
	from 	regra_envio_comunic_evento
	where 	nr_sequencia = nr_seq_regra_w;


	ds_comunicado_w	:= replace_macro(ds_comunicado_w,'@nr_cotacao',nr_cot_compra_w);
	ds_comunicado_w	:= replace_macro(ds_comunicado_w,'@nr_autorizacao',nr_seq_autor_p);
	ds_comunicado_w	:= replace_macro(ds_comunicado_w,'@ds_lista_materiais',ds_lista_material_w);


	if (cd_setor_evento_w <> 0) then
		begin
		ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_evento_w || ',',1,4000);
		end;
	end if;

	nm_usuarios_destino_w := nm_usuario_adicional_w;

	if (nm_usuarios_destino_w IS NOT NULL AND nm_usuarios_destino_w::text <> '') then

		select	obter_classif_comunic('F')
		into STRICT	nr_seq_classif_w
		;

		select	nextval('comunic_interna_seq')
		into STRICT	nr_seq_comunic_w
		;

		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then
			ds_perfil_adicional_w := substr(ds_perfil_adicional_w || cd_perfil_w ||',',1,4000);
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
			nm_usuarios_destino_w,
			nr_seq_comunic_w,
			'N',
			nr_seq_classif_w,
			clock_timestamp(),
			null,
			ds_perfil_adicional_w,
			ds_setor_adicional_w);

		if (ie_ci_lida_w = 'S') then
			insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_seq_comunic_w,nm_usuario_p,clock_timestamp());
		end if;

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
-- REVOKE ALL ON PROCEDURE envia_ci_autor_pendente (nr_seq_autor_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, cd_funcao_p bigint, cd_evento_p bigint) FROM PUBLIC;
