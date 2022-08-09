-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_zeros_cont_invent ( nr_inventario_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_contagem_atual_w		integer;
cd_material_w			integer;
qt_contagem_w			double precision;
qt_recontagem_w			double precision;
qt_seg_recontagem_w		double precision;
qt_terc_recontagem_w		double precision;
ds_descricao_w			text;
ds_contagem_inserida_w		integer;
qt_reg_w	integer;

c01 CURSOR FOR
SELECT	cd_material,
	coalesce(qt_contagem,'0')
from	inventario_material
where	nr_seq_inventario = nr_inventario_p
and	coalesce(qt_contagem::text, '') = ''
and	coalesce(qt_inventario::text, '') = '';

c02 CURSOR FOR
SELECT	cd_material,
	coalesce(qt_recontagem,'0')
from	inventario_material
where	nr_seq_inventario = nr_inventario_p
and	coalesce(qt_recontagem::text, '') = ''
and	coalesce(qt_inventario::text, '') = '';

c03 CURSOR FOR
SELECT	cd_material,
	coalesce(qt_seg_recontagem,'0')
from	inventario_material
where	nr_seq_inventario = nr_inventario_p
and	coalesce(qt_seg_recontagem::text, '') = ''
and	coalesce(qt_inventario::text, '') = '';

c04 CURSOR FOR
SELECT	cd_material,
	coalesce(qt_terc_recontagem,'0')
from	inventario_material
where	nr_seq_inventario = nr_inventario_p
and	coalesce(qt_terc_recontagem::text, '') = ''
and	coalesce(qt_inventario::text, '') = '';



BEGIN
qt_reg_w := 0;
select	coalesce(max(ie_contagem_atual),1)
into STRICT	ie_contagem_atual_w
from	inventario
where	nr_sequencia = nr_inventario_p;

if (ie_contagem_atual_w = 1) then
	begin
	ds_contagem_inserida_w := ie_contagem_atual_w;
	open c01;
	loop
	fetch c01 into
		cd_material_w,
		qt_contagem_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (qt_contagem_w = 0) then
			begin
			update	inventario_material
			set	qt_contagem = 0,
				nm_usuario_contagem = nm_usuario_p,
				dt_contagem = clock_timestamp()
			where	cd_material = cd_material_w
			and	nr_seq_inventario = nr_inventario_p;

			ds_descricao_w := ds_descricao_w || cd_material_w || ' | ';

			qt_reg_w := qt_reg_w + 1;
			if (qt_reg_w = 500) then
				begin
				ds_descricao_w := substr(wheb_mensagem_pck.get_texto(314042),1,255) || chr(13) || chr(10) || ds_descricao_w;
				CALL gravar_inventario_arq(nr_inventario_p,substr(wheb_mensagem_pck.get_texto(314049,'DS_CONTAGEM_INSERIDA=' || ds_contagem_inserida_w),1,255),ds_descricao_w,'R',nm_usuario_p);
				commit;
				ds_descricao_w := null;
				qt_reg_w := 0;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c01;
	update	inventario_material_lote
	set	qt_contagem = 0
	where	coalesce(qt_contagem::text, '') = ''
	and	nr_seq_inventario = nr_inventario_p;
	end;
elsif (ie_contagem_atual_w = 2) then
	begin
	ds_contagem_inserida_w := ie_contagem_atual_w;
	open c02;
	loop
	fetch c02 into
		cd_material_w,
		qt_recontagem_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		if (qt_recontagem_w = 0) then
			begin
			update	inventario_material
			set	qt_recontagem = 0,
				nm_usuario_recontagem = nm_usuario_p,
				dt_recontagem = clock_timestamp()
			where	cd_material = cd_material_w
			and	nr_seq_inventario = nr_inventario_p;

			ds_descricao_w := ds_descricao_w || cd_material_w || ' | ';

			qt_reg_w := qt_reg_w + 1;
			if (qt_reg_w = 500) then
				begin
				ds_descricao_w := substr(wheb_mensagem_pck.get_texto(314042),1,255) || chr(13) || chr(10) || ds_descricao_w;
				CALL gravar_inventario_arq(nr_inventario_p,substr(wheb_mensagem_pck.get_texto(314049,'DS_CONTAGEM_INSERIDA=' || ds_contagem_inserida_w),1,255),ds_descricao_w,'R',nm_usuario_p);
				commit;
				ds_descricao_w := null;
				qt_reg_w := 0;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c02;
	update	inventario_material_lote
	set	qt_recontagem = 0
	where	coalesce(qt_recontagem::text, '') = ''
	and	nr_seq_inventario = nr_inventario_p;
	end;
elsif (ie_contagem_atual_w = 3) then
	begin
	ds_contagem_inserida_w := ie_contagem_atual_w;
	open c03;
	loop
	fetch c03 into
		cd_material_w,
		qt_seg_recontagem_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
		begin
		if (qt_seg_recontagem_w = 0) then
			begin
			update	inventario_material
			set	qt_seg_recontagem = 0,
				nm_usuario_seg_recontagem = nm_usuario_p,
				dt_seg_recontagem = clock_timestamp()
			where	cd_material = cd_material_w
			and	nr_seq_inventario = nr_inventario_p;

			ds_descricao_w := ds_descricao_w || cd_material_w || ' | ';

			qt_reg_w := qt_reg_w + 1;
			if (qt_reg_w = 500) then
				begin
				ds_descricao_w := substr(wheb_mensagem_pck.get_texto(314042),1,255) || chr(13) || chr(10) || ds_descricao_w;
				CALL gravar_inventario_arq(nr_inventario_p,substr(wheb_mensagem_pck.get_texto(314049,'DS_CONTAGEM_INSERIDA=' || ds_contagem_inserida_w),1,255),ds_descricao_w,'R',nm_usuario_p);
				commit;
				ds_descricao_w := null;
				qt_reg_w := 0;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c03;
	update	inventario_material_lote
	set	qt_seg_recontagem = 0
	where	coalesce(qt_seg_recontagem::text, '') = ''
	and	nr_seq_inventario = nr_inventario_p;
	end;
elsif (ie_contagem_atual_w = 4) then
	begin
	ds_contagem_inserida_w := ie_contagem_atual_w;
	open c04;
	loop
	fetch c04 into
		cd_material_w,
		qt_terc_recontagem_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
		begin
		if (qt_terc_recontagem_w = 0) then
			begin
			update	inventario_material
			set	qt_terc_recontagem = 0,
				nm_usuario_terc_recontagem = nm_usuario_p,
				dt_terc_recontagem = clock_timestamp()
			where	cd_material = cd_material_w
			and	nr_seq_inventario = nr_inventario_p;

			ds_descricao_w := ds_descricao_w || cd_material_w || ' | ';

			qt_reg_w := qt_reg_w + 1;
			if (qt_reg_w = 500) then
				begin
				ds_descricao_w := substr(wheb_mensagem_pck.get_texto(314042),1,255) || chr(13) || chr(10) || ds_descricao_w;
				CALL gravar_inventario_arq(nr_inventario_p,substr(wheb_mensagem_pck.get_texto(314049,'DS_CONTAGEM_INSERIDA=' || ds_contagem_inserida_w),1,255),ds_descricao_w,'R',nm_usuario_p);
				commit;
				ds_descricao_w := null;
				qt_reg_w := 0;
				end;
			end if;
			end;
		end if;
		end;
	end loop;
	close c04;
	update	inventario_material_lote
	set	qt_terc_recontagem = 0
	where	coalesce(qt_terc_recontagem::text, '') = ''
	and	nr_seq_inventario = nr_inventario_p;
	end;
end if;

if (ds_contagem_inserida_w IS NOT NULL AND ds_contagem_inserida_w::text <> '') and (qt_reg_w > 0) then
	begin
	ds_descricao_w := substr(wheb_mensagem_pck.get_texto(314042),1,255) || chr(13) || chr(10) || ds_descricao_w;
	CALL gravar_inventario_arq(nr_inventario_p,substr(wheb_mensagem_pck.get_texto(314049,'DS_CONTAGEM_INSERIDA=' || ds_contagem_inserida_w),1,255),ds_descricao_w,'R',nm_usuario_p);
	commit;
	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_zeros_cont_invent ( nr_inventario_p bigint, nm_usuario_p text) FROM PUBLIC;
