-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_kit_material_autor ( nr_sequencia_autor_p bigint, cd_kit_material_p bigint, qt_kit_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w			integer;
qt_material_w			double precision;
ds_material_w			varchar(255);
cont_w				bigint;
cd_estabelecimento_w		smallint;



c001 CURSOR FOR
	SELECT 	a.cd_material,
		a.qt_material,
		b.ds_material
	from	material b, componente_kit a
	where (a.cd_material = b.cd_material)
	and 	a.cd_kit_material = cd_kit_material_p
	and 	a.ie_situacao = 'A'
	and 	b.ie_situacao = 'A'
	and	((coalesce(a.cd_estab_regra::text, '') = '') or (a.cd_estab_regra = cd_estabelecimento_w));


BEGIN
select 	wheb_usuario_pck.get_cd_estabelecimento
into STRICT	cd_estabelecimento_w
;

if (cd_kit_material_p IS NOT NULL AND cd_kit_material_p::text <> '') and (qt_kit_p > 0) then

	open c001;
	loop
		fetch c001 into
			cd_material_w,
			qt_material_w,
			ds_material_w;
		EXIT WHEN NOT FOUND; /* apply on c001 */

		select	count(*)
		into STRICT	cont_w
		from	material_autorizado
		where	nr_sequencia_autor	= nr_sequencia_autor_p
		and	cd_material		= cd_material_w;

		if (cont_w = 0) then
	
			insert	into	material_autorizado(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				cd_material,
				qt_solicitada,
				nr_sequencia_autor,
				qt_autorizada,
				ds_observacao)
			values (nextval('material_autorizado_seq'),
				clock_timestamp(),
				nm_usuario_p,
				cd_material_w,
				qt_material_w * qt_kit_p,
				nr_sequencia_autor_p,
				0,
				WHEB_MENSAGEM_PCK.get_texto(818800, 'DS_MATERIAL=' || ds_material_w)); /* 'Gerado pelo kit #@DS_MATERIAL#@' */
		else
			update	material_autorizado
			set	qt_solicitada		= qt_solicitada + (qt_material_w * qt_kit_p),
				dt_atualizacao 		= clock_timestamp(),
				nm_usuario		= nm_usuario_p
			where	nr_sequencia_autor	= nr_sequencia_autor_p
			and	cd_material		= cd_material_w;
		end if;
	end loop;
	close c001;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_kit_material_autor ( nr_sequencia_autor_p bigint, cd_kit_material_p bigint, qt_kit_p bigint, nm_usuario_p text) FROM PUBLIC;
