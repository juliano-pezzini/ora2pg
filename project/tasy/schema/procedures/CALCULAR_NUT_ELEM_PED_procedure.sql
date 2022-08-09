-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_nut_elem_ped ( nr_sequencia_p bigint, nm_usuario_p text, ie_alterou_volume_p text default 'N') AS $body$
DECLARE


qt_peso_w				double precision;
nr_sequencia_w			bigint;
nr_seq_elemento_w		nut_pac_elemento.nr_sequencia%type;
qt_elem_kg_dia_w		double precision;
qt_diaria_w				double precision;
pr_total_w				smallint;
qt_kcal_w				nut_pac_elemento.qt_kcal%type;
ie_tipo_elemento_w		varchar(3);
qt_conversao_ml_w		double precision;
qt_volume_w				double precision;
nr_seq_elem_mat_w		bigint;
nr_fator_lipideo_w  	double precision;
nr_fator_lipideo_ww 	double precision;
qt_conversao_kcal_w		nut_elem_material.qt_conversao_kcal%type;
ie_arredonda_npt_w		parametro_medico.ie_arredondar_npt%type := 'N';
qt_volume_final_w		nut_pac_elemento.qt_volume_final%type;
ie_glutamina_w			nut_elemento.ie_glutamina%type;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.qt_elem_kg_dia,
		b.ie_tipo_elemento,
		a.qt_diaria,
		a.nr_seq_elemento,
		a.qt_volume_final,
		coalesce(b.ie_glutamina,'N')
from	nut_elemento b,
		nut_pac_elemento a
where	nr_seq_nut_pac	= nr_sequencia_p
and		a.nr_seq_elemento	= b.nr_sequencia;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
		qt_conversao_ml
from	nut_elem_material b,
		nut_pac_elem_mat a
where	a.nr_seq_pac_elem	= nr_sequencia_w
and		a.nr_seq_elem_mat	= b.nr_sequencia
and		coalesce(b.ie_tipo,'NPT')	= 'NPT';


BEGIN

nr_fator_lipideo_w := Obter_Param_Usuario(924, 763, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, nr_fator_lipideo_w);

select	coalesce(max(qt_peso),0)
into STRICT	qt_peso_w
from	nut_pac
where	nr_sequencia	= nr_sequencia_p;

select 	coalesce(max(ie_arredondar_npt),'N')
into STRICT	ie_arredonda_npt_w
from	parametro_medico
where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

open c01;
loop
	fetch c01	into
		nr_sequencia_w,
      	qt_elem_kg_dia_w,
		ie_tipo_elemento_w,
		qt_diaria_w,
		nr_seq_elemento_w,
		qt_volume_final_w,
		ie_glutamina_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(ie_alterou_volume_p,'N') = 'N') or (ie_tipo_elemento_w <> 'C')	then
		begin

		qt_diaria_w := qt_elem_kg_dia_w * qt_peso_w;
		qt_kcal_w	:= 0;

		if (ie_tipo_elemento_w in ('C','P')) then /* Glicose ou proteina */
			if (ie_arredonda_npt_w = 'S') and (ie_glutamina_w = 'S') and (ie_tipo_elemento_w = 'P') then
				qt_kcal_w	:= qt_volume_final_w * 0.8;
			else
				qt_kcal_w	:= qt_diaria_w * 4;
			end if;
		elsif (ie_tipo_elemento_w = 'L') then  /* Lipidio */
			select	coalesce(max(c.qt_conversao_kcal),0)
			into STRICT	qt_conversao_kcal_w
			from	nut_pac_elem_mat a,
					nut_pac_elemento b,
					nut_elem_material c
			where  	b.nr_seq_nut_pac 	= nr_sequencia_p
			and	   	b.nr_sequencia		= a.nr_seq_pac_elem
			and	   	c.nr_sequencia 		= a.nr_seq_elem_mat
			and	   	a.nr_seq_pac_elem 	= nr_sequencia_w;

			if (qt_conversao_kcal_w > 0) then
				nr_fator_lipideo_ww	:= qt_conversao_kcal_w;
			else
				nr_fator_lipideo_ww	:= nr_fator_lipideo_w;
			end if;
			if (ie_arredonda_npt_w = 'S') then
				qt_kcal_w	:= qt_volume_final_w * coalesce(nr_fator_lipideo_ww,9);
			else
				qt_kcal_w	:= qt_diaria_w * coalesce(nr_fator_lipideo_ww,9);
			end if;

		elsif (ie_arredonda_npt_w = 'S' AND ie_tipo_elemento_w = 'V') and (qt_diaria_w > 5) then
			qt_diaria_w	:= 5;
		elsif (ie_arredonda_npt_w = 'S' AND ie_tipo_elemento_w = 'G') and (qt_diaria_w > 4) then
			qt_diaria_w	:= 4;
		end if;
		exception
			when others then
				-- O valor informado para Qt/kg/dia é muito grande e deve ser reduzido!
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(226994);
		end;

		if (ie_arredonda_npt_w = 'S') then
			--qt_diaria_w	:= ceil(qt_diaria_w * 100) / 100;
			qt_diaria_w	:= round((qt_diaria_w)::numeric, 2);
		end if;

		update	nut_pac_elemento
		set		qt_diaria	= coalesce(qt_diaria_w,0),
				qt_kcal		= coalesce(qt_kcal_w,0)
		where	nr_sequencia	= nr_sequencia_w;

	end if;
	open c02;
	loop
	fetch c02	into
		nr_seq_elem_mat_w,
      	qt_conversao_ml_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		qt_volume_w	:= qt_diaria_w * qt_conversao_ml_w;

		if (ie_arredonda_npt_w = 'S') then
			--qt_volume_w	:= ceil(qt_volume_w * 100) / 100;
			qt_volume_w	:= round((qt_volume_w)::numeric, 2);
		end if;
		update	nut_pac_elem_mat
		set		qt_volume		= qt_volume_w
		where	nr_sequencia	= nr_seq_elem_mat_w;

	end loop;
	close c02;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_nut_elem_ped ( nr_sequencia_p bigint, nm_usuario_p text, ie_alterou_volume_p text default 'N') FROM PUBLIC;
