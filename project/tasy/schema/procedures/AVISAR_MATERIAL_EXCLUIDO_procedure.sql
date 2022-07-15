-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE avisar_material_excluido ( cd_material_p bigint, nm_usuario_p text, nr_atendimento_p bigint) AS $body$
DECLARE


cd_grupo_material_w	smallint;
cd_subgrupo_material_w 	smallint;
cd_classe_material_w	integer;
ds_grupo_material_w	varchar(255);
ds_subgrupo_material_w 	varchar(255);
ds_classe_material_w	varchar(255);
ds_comunic_w		varchar(500);
qt_regras_w		bigint;
cd_setor_dest_w		integer;
cd_perfil_w		integer;
nm_usuario_regra_w	varchar(255);
ie_ci_lida_w		varchar(1);
ds_setor_w		varchar(255);
nm_usuario_dest_w		varchar(4000);
ds_titulo_w		varchar(255);
nr_seq_comunic_w		bigint;
nr_seq_classif_w		bigint;
ie_gerar_ci_w		varchar(1) := 'N';

c01 CURSOR FOR
	SELECT	cd_setor_atendimento,
		cd_perfil,
		ds_usuario_destino,
		coalesce(ie_ci_lida,'N')
	from 	regra_aviso_exec_mat
	where	coalesce(cd_grupo_material, coalesce(cd_grupo_material_w,0)) = coalesce(cd_grupo_material_w,0)
	and	coalesce(cd_subgrupo_material, coalesce(cd_subgrupo_material_w,0)) = coalesce(cd_subgrupo_material_w,0)
	and	coalesce(cd_classe_material, coalesce(cd_classe_material_w,0)) = coalesce(cd_classe_material_w,0)
	and	coalesce(cd_material, cd_material_p)	= cd_material_p
	and	coalesce(ie_exclusao_mat,'N') = 'S'
	and 	coalesce(cd_funcao, coalesce(obter_funcao_ativa,0)) = coalesce(obter_funcao_ativa,0)
	order by
		coalesce(cd_grupo_material, 0),
		coalesce(cd_subgrupo_material, 0),
		coalesce(cd_classe_material, 0),
		coalesce(cd_material, 0),
		coalesce(cd_funcao,0);


BEGIN

select	max(cd_grupo_material),
	max(cd_subgrupo_material),
	max(cd_classe_material),
	substr(max(ds_grupo_material),1,255),
	substr(max(ds_subgrupo_material),1,255),
	substr(max(ds_classe_material),1,255)
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	ds_grupo_material_w,
	ds_subgrupo_material_w,
	ds_classe_material_w
from	estrutura_material_v
where 	cd_material = cd_material_p;

select	count(*)
into STRICT	qt_regras_w
from 	regra_aviso_exec_mat
where	coalesce(ie_exclusao_mat,'N') = 'S';

if (qt_regras_w > 0) then

	open C01;
	loop
	fetch C01 into
		cd_setor_dest_w,
		cd_perfil_w,
		nm_usuario_regra_w,
		ie_ci_lida_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cd_setor_dest_w IS NOT NULL AND cd_setor_dest_w::text <> '') then
			ds_setor_w := ds_setor_w || substr(to_char(cd_setor_dest_w) || ',',1,255);
		end if;
		if (nm_usuario_regra_w IS NOT NULL AND nm_usuario_regra_w::text <> '') then
			nm_usuario_dest_w := substr(nm_usuario_dest_w || nm_usuario_regra_w || ',',1,4000);
		end if;

		ie_gerar_ci_w := 'S';

		end;
	end loop;
	close C01;

	if (ie_gerar_ci_w = 'S') then

		select	substr(wheb_mensagem_pck.get_texto(313594)||'.' || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(308545)|| ' ' || cd_material_p || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(308539)|| ' ' || substr(obter_desc_material(cd_material_p),1,120) || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(118576) ||' ' || ds_grupo_material_w || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(118575)||' ' || ds_subgrupo_material_w || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(118572) || ' ' || ds_classe_material_w,1,255) || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(308048) || ' ' || nr_atendimento_p || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(261653) || ' ' || clock_timestamp() || chr(13) || chr(10) ||
				wheb_mensagem_pck.get_texto(308677) || ' ' || substr(obter_nome_usuario(nm_usuario_p),1,80),
				wheb_mensagem_pck.get_texto(313594) ||' !'
		into STRICT	ds_comunic_w,
			ds_titulo_w
		;

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
			nm_usuario_oculto)
		values (clock_timestamp(),
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
			'',
			ds_setor_w,
			clock_timestamp(),
			'',
			'');

		if (ie_ci_lida_w = 'S') then

			insert into comunic_interna_lida(
				nr_sequencia,
				nm_usuario,
				dt_atualizacao)
			values (nr_seq_comunic_w,
				nm_usuario_p,
				clock_timestamp());

		end if;

	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE avisar_material_excluido ( cd_material_p bigint, nm_usuario_p text, nr_atendimento_p bigint) FROM PUBLIC;

