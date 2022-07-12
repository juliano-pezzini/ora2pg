-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_alergico ( cd_pessoa_fisica_p text, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE



ie_pac_alergia_w		bigint := 0;
nr_seq_ficha_tecnica_w		bigint;
qt_ficha_tec_mat_w		bigint;
nr_seq_dcb_w			bigint;
cd_material_w			integer;
cd_material_generico_w		integer;
cd_classe_mat_w			bigint;
qt_alergia_w			bigint;
cd_classe_material_w		integer;
qt_dcb_w			bigint;
qt_dcb_ficha_w			bigint;
nr_sequencia_dcb_w		bigint;
nr_seq_tipo_w			paciente_alergia.nr_seq_tipo%type;
ie_latex_w				tipo_alergia.ie_latex%type;
qt_cont_w				bigint;
ie_retorno_w			varchar(255);
ie_liberar_hist_saude_w		varchar(1);



C01 CURSOR FOR
	SELECT	nr_seq_ficha_tecnica,
		nr_seq_dcb,
		cd_material,
		cd_classe_mat,
		nr_seq_tipo
	from	paciente_alergia
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	coalesce(dt_fim::text, '') = ''
	and	coalesce(dt_inativacao::text, '') = ''
	and	((ie_liberar_hist_saude_w = 'N') or (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));
	

C02 CURSOR FOR
	SELECT	nr_seq_ficha_tecnica
	from	material
	where	cd_material in (SELECT	cd_material_w
				
				
union

				select	b.cd_material_generico
				from	material b
				where	b.cd_material = cd_material_w
				
union

				select	b.cd_material
				from	material b
				where	b.cd_material_generico = cd_material_w);

C03 CURSOR FOR
	SELECT	a.nr_seq_dcb
	from	material_dcb a
	where	a.cd_material in (SELECT	cd_material_w
					
					
union

					select	b.cd_material_generico
					from	material b
					where	b.cd_material = cd_material_w
					
union

					select	b.cd_material
					from	material b
					where	b.cd_material_generico = cd_material_w)
	
union

	select	b.nr_seq_dcb
	from	medic_ficha_tecnica b,
		material a
	where	a.cd_material in (select	cd_material_w
					
					
union

					select	b.cd_material_generico
					from	material b
					where	b.cd_material = cd_material_w
					
union

					select	b.cd_material
					from	material b
					where	b.cd_material_generico = cd_material_w)
	and (a.nr_seq_ficha_tecnica	= b.nr_sequencia or
			 a.nr_seq_ficha_tecnica = b.nr_seq_superior);

C04 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_dcb
	from	medic_ficha_tecnica
	where	nr_seq_superior		= nr_seq_ficha_tecnica_w;


BEGIN

select	coalesce(max(ie_liberar_hist_saude),'N')
into STRICT	ie_liberar_hist_saude_w
from	parametro_medico
where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

ie_retorno_w	:= 'N';

select	count(*)
into STRICT	qt_alergia_w
from	paciente_alergia
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	coalesce(dt_fim::text, '') = '';

if (qt_alergia_w > 0) then
	begin
	
	select	max(cd_classe_material)
	into STRICT	cd_classe_material_w
	from	estrutura_material_v
	where	cd_material	= cd_material_p;

	open c01;
	loop
	fetch c01 into	
		nr_seq_ficha_tecnica_w,
		nr_seq_dcb_w,
		cd_material_w,
		cd_classe_mat_w,
		nr_seq_tipo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		if (nr_seq_tipo_w IS NOT NULL AND nr_seq_tipo_w::text <> '') then
			select	max(ie_latex)
			into STRICT	ie_latex_w
			from	tipo_alergia
			where	nr_sequencia	= nr_seq_tipo_w;
			
			if (ie_latex_w = 'S') then
				select	count(*)
				into STRICT	qt_cont_w
				from	material
				where	cd_material = cd_material_p
				and	coalesce(ie_latex,'N') = 'S';
				
				if (qt_cont_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;
			end if;
		end if;
		
		if (cd_classe_mat_w > 0) then
			if (cd_classe_material_w = cd_classe_mat_w) then
				ie_retorno_w	:= 'S';
				exit;
			end if;
		end if;

		if (nr_seq_ficha_tecnica_w > 0) then
			begin
			select	count(*)
			into STRICT	qt_ficha_tec_mat_w
			from	material a
			where	a.cd_material in (SELECT	cd_material_p
							
							
union

							SELECT	b.cd_material_generico
							from	material b
							where	b.cd_material = cd_material_p
							
union

							select	b.cd_material
							from	material b
							where	b.cd_material_generico = cd_material_p)
			and	a.nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w;

			if (qt_ficha_tec_mat_w > 0) then
				ie_retorno_w	:= 'S';
				exit;
			end if;

			select	coalesce(max(nr_seq_dcb),0)
			into STRICT	nr_sequencia_dcb_w
			from	medic_ficha_tecnica
			where	nr_sequencia	= nr_seq_ficha_tecnica_w;
			
			if (nr_sequencia_dcb_w > 0) then
				begin
				select	count(*)
				into STRICT	qt_ficha_tec_mat_w
				from	material_dcb a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_dcb	= nr_sequencia_dcb_w;
				
				if (qt_ficha_tec_mat_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;
				end;
			end if;
			
			end;
		end if;
		
		if (coalesce(nr_seq_dcb_w,0) = 0) then
			select	coalesce(max(nr_seq_dcb),0)
			into STRICT	nr_seq_dcb_w
			from	medic_ficha_tecnica
			where	nr_sequencia	= nr_seq_ficha_tecnica_w;
		end if;

		if (nr_seq_dcb_w > 0) then
			select	count(*)
			into STRICT	qt_dcb_w
			from	material_dcb a
			where	a.cd_material in (SELECT	cd_material_p
							
							
union

							SELECT	b.cd_material_generico
							from	material b
							where	b.cd_material = cd_material_p
							
union

							select	b.cd_material
							from	material b
							where	b.cd_material_generico = cd_material_p)
			and	a.nr_seq_dcb	= nr_seq_dcb_w;

			select	count(*)
			into STRICT	qt_dcb_ficha_w
			FROM material a, medic_ficha_tecnica c
LEFT OUTER JOIN medic_ficha_tecnica b ON (c.nr_seq_superior = b.nr_sequencia)
WHERE a.cd_material in (SELECT	cd_material_p
							
							
union

							SELECT	b.cd_material_generico
							from	material b
							where	b.cd_material = cd_material_p
							
union

							select	b.cd_material
							from	material b
							where	b.cd_material_generico = cd_material_p) and a.nr_seq_ficha_tecnica	= b.nr_sequencia  and (b.nr_seq_dcb		= nr_seq_dcb_w or
				c.nr_seq_dcb		= nr_seq_dcb_w);

			if (qt_dcb_w > 0) or (qt_dcb_ficha_w > 0) then
				ie_retorno_w	:= 'S';
				exit;
			end if;
		end if;

		if (cd_material_w > 0) then
			select	count(*)
			into STRICT	qt_alergia_w
			
			where	cd_material_p in (SELECT	cd_material_w
							
							
union

							SELECT	b.cd_material_generico
							from	material b
							where	b.cd_material = cd_material_w
							
union

							select	b.cd_material
							from	material b
							where	b.cd_material_generico = cd_material_w);

			if (qt_alergia_w > 0) then
				ie_retorno_w	:= 'S';
				exit;
			end if;

			open c02;
			loop
			fetch c02 into	
				nr_seq_ficha_tecnica_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				select	count(*)
				into STRICT	qt_ficha_tec_mat_w
				from	material a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w;

				if (qt_ficha_tec_mat_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;
			
			end loop;
			close c02;

			if (ie_retorno_w = 'S') then
				exit;
			end if;
		
			open c03;
			loop
			fetch c03 into	
				nr_seq_dcb_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */

				select	count(*)
				into STRICT	qt_dcb_w
				from	material_dcb a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_dcb	= nr_seq_dcb_w;

				select	count(*)
				into STRICT	qt_dcb_ficha_w
				from	medic_ficha_tecnica b,
					material a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and (a.nr_seq_ficha_tecnica	= b.nr_sequencia or
						 a.nr_seq_ficha_tecnica = b.nr_seq_superior)
				and	b.nr_seq_dcb		= nr_seq_dcb_w;
	
				if (qt_dcb_w > 0) or (qt_dcb_ficha_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;

			end loop;
			close c03;

			if (ie_retorno_w = 'S') then
				exit;
			end if;

		end if;

		/* Verificar os derivados correspondentes, caso existam no princípio ativo - Ivan em 27/02/2008 OS80350 */

		open C04;
		loop
		fetch C04 into	
			nr_seq_ficha_tecnica_w,
			nr_seq_dcb_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			
			if (nr_seq_ficha_tecnica_w > 0) then
				select	count(*)
				into STRICT	qt_ficha_tec_mat_w
				from	material a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w;
	
				if (qt_ficha_tec_mat_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;
			end if;

			if (nr_seq_dcb_w > 0) then
				select	count(*)
				into STRICT	qt_dcb_w
				from	material_dcb a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_dcb	= nr_seq_dcb_w;
	
				select	count(*)
				into STRICT	qt_dcb_ficha_w
				from	medic_ficha_tecnica b,
					material a
				where	a.cd_material in (SELECT	cd_material_p
								
								
union

								SELECT	b.cd_material_generico
								from	material b
								where	b.cd_material = cd_material_p
								
union

								select	b.cd_material
								from	material b
								where	b.cd_material_generico = cd_material_p)
				and	a.nr_seq_ficha_tecnica	= b.nr_sequencia
				and	b.nr_seq_dcb		= nr_seq_dcb_w;
	
				if (qt_dcb_w > 0) or (qt_dcb_ficha_w > 0) then
					ie_retorno_w	:= 'S';
					exit;
				end if;
			end if;

			end;
		end loop;
		close C04;

		end;
	end loop;
	close c01;
	
	end;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_alergico ( cd_pessoa_fisica_p text, cd_material_p bigint) FROM PUBLIC;
