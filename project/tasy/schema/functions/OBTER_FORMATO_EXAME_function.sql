-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_formato_exame (nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_seq_metodo_p bigint, ie_formato_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_formato_w	bigint := null;
nr_seq_metodo_w		bigint;

C01 CURSOR FOR
	SELECT nr_seq_formato
	from	( 	SELECT  a.nr_seq_formato,
				a.nr_seq_metodo,
				b.ie_prioridade,
				a.ie_mapa_laudo,
				0 ie_tipo
			from	exame_lab_material b,
				exame_lab_format a
			where 	a.nr_seq_exame = nr_seq_exame_p
			  and 	a.nr_seq_exame = b.nr_seq_exame
			  and 	a.nr_seq_material = b.nr_seq_material
			  and 	ie_padrao = 'S'
			  and 	ie_mapa_laudo = CASE WHEN ie_formato_p='L' THEN  ie_formato_p  ELSE ie_mapa_laudo END
			  and 	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())
			  and 	((coalesce(nr_seq_metodo_p,0) = 0) or (coalesce(a.nr_seq_metodo,nr_seq_metodo_w) = nr_seq_metodo_w))
			  and     not exists ( select 1 from exame_lab_format_estab b
							  	  where a.nr_seq_formato = b.nr_seq_formato)
			
union

			select	a.nr_seq_formato,
				a.nr_seq_metodo,
				b.ie_prioridade,
				a.ie_mapa_laudo,
				1 ie_tipo
			from	exame_lab_format_estab c,
				exame_lab_material b,
				exame_lab_format a
			where 	a.nr_seq_exame = nr_seq_exame_p
			  and 	a.nr_seq_exame = b.nr_seq_exame
			  and 	a.nr_seq_material = b.nr_seq_material
			  and 	a.ie_padrao = 'S'
			  and 	a.ie_mapa_laudo = CASE WHEN ie_formato_p='L' THEN  ie_formato_p  ELSE ie_mapa_laudo END 
			  and 	clock_timestamp() between coalesce(dt_inicio_vigencia,clock_timestamp()) and coalesce(dt_fim_vigencia,clock_timestamp())
			  and 	((coalesce(nr_seq_metodo_p,0) = 0) or (coalesce(a.nr_seq_metodo,nr_seq_metodo_w) = nr_seq_metodo_w))
			  and	c.nr_seq_formato = a.nr_seq_formato
			  and	c.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ) alias21
	order by ie_tipo, CASE WHEN ie_formato_p='L' THEN  ie_formato_p  ELSE ie_mapa_laudo END , ie_prioridade desc, coalesce(nr_seq_metodo,0);

BEGIN

nr_seq_metodo_w := coalesce(nr_seq_metodo_p,0);

begin
select nr_seq_formato
into STRICT nr_seq_formato_w
from(	SELECT  a.nr_seq_formato,
		coalesce(a.nr_seq_metodo,0),
		0 ie_tipo
	from 	exame_lab_format a
	where 	a.nr_seq_exame	= nr_seq_exame_p
	  and 	a.nr_seq_material	= nr_seq_material_p
	  and 	((coalesce(nr_seq_metodo_p::text, '') = '') or (coalesce(a.nr_seq_metodo,nr_seq_metodo_w) = nr_seq_metodo_w))
	  and 	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())
	  and 	a.ie_padrao		= 'S'
	  and 	a.ie_mapa_laudo	= ie_formato_p
	  and   not exists ( select 1 from exame_lab_format_estab b
			    where a.nr_seq_formato = b.nr_seq_formato )
	
union

	SELECT  a.nr_seq_formato,
		coalesce(a.nr_seq_metodo,0),
		1 ie_tipo
	from 	exame_lab_format a,
		exame_lab_format_estab b
	where 	a.nr_seq_formato 	= b.nr_seq_formato
	  and	a.nr_seq_exame		= nr_seq_exame_p
	  and 	a.nr_seq_material	= nr_seq_material_p
	  and 	((coalesce(nr_seq_metodo_p::text, '') = '') or (coalesce(a.nr_seq_metodo,nr_seq_metodo_w) = nr_seq_metodo_w))
	  and 	clock_timestamp() between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())
	  and 	a.ie_padrao		= 'S'
	  and 	a.ie_mapa_laudo	= ie_formato_p
	  and	b.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento
	order by 3 desc, 2 desc) LIMIT 1;
exception
	when no_data_found then
		begin
		open C01;
		loop
			fetch C01 into nr_seq_formato_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
		end loop;
		close C01;
		end;
end;

return nr_seq_formato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_formato_exame (nr_seq_exame_p bigint, nr_seq_material_p bigint, nr_seq_metodo_p bigint, ie_formato_p text) FROM PUBLIC;

