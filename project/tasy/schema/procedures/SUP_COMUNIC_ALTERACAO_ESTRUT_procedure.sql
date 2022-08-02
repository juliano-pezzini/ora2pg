-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_comunic_alteracao_estrut ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ds_historico_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ds_grupo_material_w		varchar(255);
ds_subgrupo_material_w 		varchar(255);
ds_classe_material_w		varchar(255);
nr_seq_classif_w		bigint;
cd_setor_dest_w			bigint;
nm_usuario_regra_w		varchar(255);
qt_regras_w			bigint;
ds_setor_w			varchar(255);
nm_usuario_dest_w		varchar(4000);
ds_titulo_w			varchar(255);
ds_comunic_w			varchar(4000);
cd_perfil_w			integer;
ds_setor_atend_w		varchar(100);
nr_sequencia_w			bigint;
nr_sequencia_s_w		bigint;
cd_estabelecimento_w		smallint;
ds_estab_w			varchar(255);
nr_seq_comunic_w		bigint;
ie_ci_lida_w			varchar(1);
cd_setor_w			bigint;
qt_existe_Format_w		bigint;
ds_historico_w			text;
ie_regra_w			varchar(1);

c01 CURSOR FOR
	SELECT	cd_setor_atendimento,
		cd_perfil,
		ds_usuario_destino,
		coalesce(ie_ci_lida,'N')
	from 	regra_aviso_exec_mat
	where	coalesce(cd_estabelecimento, cd_estabelecimento_p)		= cd_estabelecimento_p
	and	coalesce(ie_alteracao_estrut,'N')				= 'S'
	and 	coalesce(cd_funcao, coalesce(obter_funcao_ativa,0)) = coalesce(obter_funcao_ativa,0);


BEGIN

select	count(*)
into STRICT	qt_regras_w
from 	regra_aviso_exec_mat
where	coalesce(ie_alteracao_estrut,'N') = 'S';

if (qt_regras_w > 0) then
	begin
	ie_regra_w	:=	'N';

	open c01;
	loop
	fetch c01 into
		cd_setor_dest_w,
		cd_perfil_w,
		nm_usuario_regra_w,
		ie_ci_lida_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (cd_setor_dest_w IS NOT NULL AND cd_setor_dest_w::text <> '') then
			ds_setor_w := ds_setor_w || substr(to_char(cd_setor_dest_w) || ',',1,255);
		end if;

		if (nm_usuario_regra_w IS NOT NULL AND nm_usuario_regra_w::text <> '') then
			nm_usuario_dest_w := substr(nm_usuario_dest_w || nm_usuario_regra_w || ',',1,4000);
		end if;

		ie_regra_w	:=	'S';
		end;
	end loop;
	close 	c01;

	if (ie_regra_w = 'S') then
		begin
		if (coalesce(cd_grupo_material_p,0) <> 0) then
			begin
			select	ds_grupo_material
			into STRICT	ds_grupo_material_w
			from	grupo_material
			where	cd_grupo_material = cd_grupo_material_p;

			--ds_titulo_w	:= 'Alteração da estrutura do material';
			ds_titulo_w	:= wheb_mensagem_pck.get_texto(314215);
			/*ds_comunic_w	:= substr('Código: ' || cd_grupo_material_p || chr(13) || chr(10) ||
						'Grupo: ' || ds_grupo_material_w,1,255); */
			ds_comunic_w	:= substr(wheb_mensagem_pck.get_texto(314216, 'CODIGO=' || cd_grupo_material_p) || chr(13) || chr(10) ||
						  wheb_mensagem_pck.get_texto(314210,'DS_GRUPO_MATERIAL=' || ds_grupo_material_w),1,255);
			end;
		elsif (coalesce(cd_subgrupo_material_p,0) <> 0) then
			begin
			select	ds_subgrupo_material
			into STRICT	ds_subgrupo_material_w
			from	subgrupo_material
			where	cd_subgrupo_material = cd_subgrupo_material_p;

			--ds_titulo_w	:= 'Alteração da estrutura do material';
			ds_titulo_w	:= wheb_mensagem_pck.get_texto(314215);
			/*ds_comunic_w	:= substr('Código: ' || cd_subgrupo_material_p || chr(13) || chr(10) ||
						'Subgrupo: ' || ds_subgrupo_material_w,1,255);*/
			ds_comunic_w	:= substr(wheb_mensagem_pck.get_texto(314216, 'CODIGO=' || cd_subgrupo_material_p) || chr(13) || chr(10) ||
						  wheb_mensagem_pck.get_texto(314211,'DS_SUBGRUPO_MATERIAL=' || ds_subgrupo_material_w),1,255);
			end;
		elsif (coalesce(cd_classe_material_p,0) <> 0) then
			begin
			select	ds_classe_material
			into STRICT	ds_classe_material_w
			from	classe_material
			where	cd_classe_material = cd_classe_material_p;

			--ds_titulo_w	:= 'Alteração da estrutura do material';
			ds_titulo_w	:= wheb_mensagem_pck.get_texto(314215);
			/*ds_comunic_w	:= substr('Código: ' || cd_classe_material_p || chr(13) || chr(10) ||
						'Classe: ' || ds_classe_material_w,1,255);*/
			ds_comunic_w	:= substr(wheb_mensagem_pck.get_texto(314216, 'CODIGO=' || cd_classe_material_p) || chr(13) || chr(10) ||
						  wheb_mensagem_pck.get_texto(314212,'DS_CLASSE_MATERIAL=' || ds_classe_material_w),1,255);
			end;
		end if;

		select	position('{\ul{\b' in ds_historico_w)
		into STRICT	qt_existe_format_w
		;

		IF (qt_existe_Format_w > 0) THEN
			ds_historico_w	:= SUBSTR('{\rtf1\ansi\deff0{\fonttbl ' ||
						'{\f0\fnil\fcharset0 Verdana;}{\f1\fnil Verdana;}}' ||
						'\viewkind4\uc1\pard\cf1\lang1046\f0\fs20' ||
						ds_historico_w || '\b0 }',1,200);
		end if;

		ds_historico_w	:= SUBSTR(ds_historico_p,1,1000);

		if (ds_historico_p IS NOT NULL AND ds_historico_p::text <> '') then
		  ds_comunic_w := ds_comunic_w || chr(13) || chr(10) || ds_historico_w;
		end if;

		cd_estabelecimento_w	:= cd_estabelecimento_p;
		if (cd_estabelecimento_p = 0) then
			cd_estabelecimento_w	:= null;
		end if;

		if (coalesce(cd_estabelecimento_w, 0) > 0) then
			ds_estab_w	:= substr(obter_nome_estabelecimento(cd_estabelecimento_w),1,255);
			--ds_titulo_w	:= substr('Alteração da estrutura dos materiais no estabelecimento - ' || ds_estab_w,1,255);
			ds_titulo_w	:= substr(wheb_mensagem_pck.get_texto(314214, 'DS_ESTAB=' || ds_estab_w),1,255);
		end if;

		select	max(obter_classif_comunic('F'))
		into STRICT	nr_seq_classif_w
		;

		select	nextval('comunic_interna_seq')
		into STRICT	nr_seq_comunic_w
		;

		insert into comunic_interna(dt_comunicado,
			ds_titulo,
			ds_comunicado,
			nm_usuario,
			dt_atualizacao,
			ie_geral,
			nm_usuario_destino,
			cd_perfil,
			nr_sequencia,
			ie_gerencial,
			nr_seq_classif,
			ds_perfil_adicional,
			cd_setor_destino,
			cd_estab_destino,
			ds_setor_adicional,
			dt_liberacao,
			ds_grupo,
			nm_usuario_oculto) values (clock_timestamp(),
				ds_titulo_w,
				wheb_rtf_pck.get_texto_rtf(ds_comunic_w),
				nm_usuario_p,
				clock_timestamp(),
				'N',
				nm_usuario_dest_w,
				null,
				nr_seq_comunic_w,
				'N',
				nr_seq_classif_w,
				cd_perfil_w || ',',
				null,
				cd_estabelecimento_w,
				ds_setor_w,  --tirado o ds_setor_atend_w, e colocado o cd_setor_w, pois o campo é function. mhbarth.
				clock_timestamp(),
				'',
				'');

		if (ie_ci_lida_w = 'S') then

			insert into comunic_interna_lida(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao) values (
					nr_seq_comunic_w,
					nm_usuario_p,
					clock_timestamp());

		end if;
		end;
	end if;
	end;
end if;

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_comunic_alteracao_estrut ( cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, ds_historico_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

