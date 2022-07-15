-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_check_pac_cross_sens ( cd_pessoa_fisica_p text, cd_material_p bigint, ie_alergico_p INOUT text, ds_mensagem_p INOUT text) AS $body$
DECLARE


qt_alergia_w			bigint;
ie_liberar_hist_saude_w		varchar(1);
nr_seq_ficha_tecnica_w		material.nr_seq_ficha_tecnica%type;
ds_derivados_ficha_medica_w	varchar(255);
ds_mensagem_w			varchar(600) := null;


C01 CURSOR FOR	
	SELECT	nr_seq_ficha_tecnica,
		cd_classe_mat,
		cd_material
	from	paciente_alergia
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	coalesce(dt_fim::text, '') = ''
	and	coalesce(dt_inativacao::text, '') = ''
	and	((ie_liberar_hist_saude_w = 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''))
	order by 	cd_material,
			nr_seq_ficha_tecnica, 
			cd_classe_mat;


BEGIN

ds_mensagem_p 	:= null;
ie_alergico_p	:= 'N';

select	coalesce(max(ie_liberar_hist_saude),'N')
into STRICT	ie_liberar_hist_saude_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(nr_seq_ficha_tecnica)
	into STRICT	nr_seq_ficha_tecnica_w
	from	material a
	where	a.cd_material =	cd_material_p;
	
	ds_derivados_ficha_medica_w := obter_derivados_ficha_medica(nr_seq_ficha_tecnica_w);

	for r_c01 in C01 loop
		begin
	
		if (coalesce(r_c01.cd_material,0) > 0) then

			select	count(1)
			into STRICT	qt_alergia_w
			from	medic_reacao_cruzada m,
				table(lista_pck.obter_lista(ds_derivados_ficha_medica_w)) x
			where	m.nr_seq_ficha_tecnica 	= x.nr_registro
			and 	cd_material	= r_c01.cd_material;

			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(1125890, 'CD_MATERIAL_W=' || obter_desc_material(r_c01.cd_material) ||
									';FICHA_TECNICA_W=' || obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',nr_seq_ficha_tecnica_w));

		elsif (coalesce(r_c01.nr_seq_ficha_tecnica,0) > 0) then

			select	count(1)
			into STRICT	qt_alergia_w
			from	material a
			where	exists (	SELECT	1
						from	medic_reacao_cruzada c,
							table(lista_pck.obter_lista(ds_derivados_ficha_medica_w)) x
						where	c.nr_seq_ficha_tecnica = x.nr_registro
						and	c.cd_material in (	select	cd_material
										from	material
										where	nr_seq_ficha_tecnica	= r_c01.nr_seq_ficha_tecnica))
			and	a.nr_seq_ficha_tecnica	= r_c01.nr_seq_ficha_tecnica;
			
			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(1125890, 'CD_MATERIAL_W=' || obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',r_c01.nr_seq_ficha_tecnica) ||
					';FICHA_TECNICA_W=' || obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',nr_seq_ficha_tecnica_w));

		elsif (coalesce(r_c01.cd_classe_mat,0) > 0) then

			select	count(1)
			into STRICT	qt_alergia_w
			from	medic_reacao_cruzada m,
				table(lista_pck.obter_lista(ds_derivados_ficha_medica_w)) x
			where	m.nr_seq_ficha_tecnica = x.nr_registro
			and 	m.cd_material in (	SELECT 	a.cd_material
							from	material_classe_adic a
							where 	a.cd_classe_material = r_c01.cd_classe_mat
							
union all

							SELECT a.cd_material
							from material a
							where a.cd_classe_material = r_c01.cd_classe_mat);
			
			ds_mensagem_w	:= wheb_mensagem_pck.get_texto(1125890, 'CD_MATERIAL_W=' || obter_descricao_padrao('CLASSE_MATERIAL', 'DS_CLASSE_MATERIAL',r_c01.cd_classe_mat) ||
					';FICHA_TECNICA_W=' || obter_descricao_padrao('MEDIC_FICHA_TECNICA', 'DS_SUBSTANCIA',nr_seq_ficha_tecnica_w));

		end if;
		
		if (qt_alergia_w > 0) then
			ds_mensagem_p := ds_mensagem_w;
			ie_alergico_p	:= 'S';
			return;
		end if;
		
		end;
	end loop;
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_check_pac_cross_sens ( cd_pessoa_fisica_p text, cd_material_p bigint, ie_alergico_p INOUT text, ds_mensagem_p INOUT text) FROM PUBLIC;

