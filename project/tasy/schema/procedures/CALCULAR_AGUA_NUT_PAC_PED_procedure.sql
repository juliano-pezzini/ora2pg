-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_agua_nut_pac_ped ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_peso_w					double precision;
nr_seq_elem_agua_w			bigint;
qt_vol_total_w				double precision;
qt_aporte_hidrico_diario_w	double precision;
qt_elem_kg_dia_w			double precision;
ie_arredonda_npt_w			parametro_medico.ie_arredondar_npt%type := 'N';


BEGIN

select	qt_peso,
		qt_aporte_hidrico_diario
into STRICT	qt_peso_w,
		qt_aporte_hidrico_diario_w
from	Nut_pac
where	nr_sequencia		= nr_sequencia_p;

select 	coalesce(max(ie_arredondar_npt),'N')
into STRICT	ie_arredonda_npt_w
from	parametro_medico
where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

/*Rotina para atualizar o volume do elemento do tipo água para ficar compatível com Aporte hídrico */

select	max(a.nr_sequencia)
into STRICT	nr_seq_elem_agua_w
from	nut_elemento b,
		nut_pac_elemento a
where	a.nr_seq_nut_pac	= nr_sequencia_p
and		a.nr_seq_elemento	= b.nr_sequencia
and		b.ie_tipo_elemento	= 'A';

if (nr_seq_elem_agua_w > 0) then
	begin

		if (ie_arredonda_npt_w = 'N') then

			select	coalesce(sum(qt_volume_final),0)
			into STRICT	qt_vol_total_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac	= nr_sequencia_p;

			if (qt_aporte_hidrico_diario_w > qt_vol_total_w) then
				begin

					select	sum(qt_elem_kg_dia)
					into STRICT	qt_elem_kg_dia_w
					from	nut_pac_elemento
					where	nr_seq_nut_pac	= nr_sequencia_p
					and		nr_sequencia	= nr_seq_elem_agua_w;

					qt_elem_kg_dia_w	:= qt_elem_kg_dia_w + (dividir((qt_aporte_hidrico_diario_w - qt_vol_total_w),qt_peso_w));
					qt_elem_kg_dia_w	:= ceil(qt_elem_kg_dia_w * 100) / 100;

					update	nut_pac_elemento
					set		qt_elem_kg_dia	=  coalesce(qt_elem_kg_dia_w,0)
					where	nr_seq_nut_pac	= nr_sequencia_p
					and		nr_sequencia	= nr_seq_elem_agua_w;

				end;
			elsif (qt_aporte_hidrico_diario_w < qt_vol_total_w) then
				begin

					select	sum(qt_elem_kg_dia)
					into STRICT	qt_elem_kg_dia_w
					from	nut_pac_elemento
					where	nr_seq_nut_pac	= nr_sequencia_p
					and		nr_sequencia	= nr_seq_elem_agua_w;

					qt_elem_kg_dia_w	:= qt_elem_kg_dia_w - (dividir((qt_vol_total_w - qt_aporte_hidrico_diario_w),qt_peso_w));
					qt_elem_kg_dia_w	:= ceil(qt_elem_kg_dia_w * 100) / 100;

					update	nut_pac_elemento
					set		qt_elem_kg_dia	= coalesce(qt_elem_kg_dia_w,0)
					where	nr_seq_nut_pac	= nr_sequencia_p
					and		nr_sequencia	= nr_seq_elem_agua_w;

				end;
			end if;
		else

			select	coalesce(sum(qt_volume_final),0)
			into STRICT	qt_vol_total_w
			from	nut_pac_elemento
			where	nr_seq_nut_pac	= nr_sequencia_p
			and		nr_sequencia	<> nr_seq_elem_agua_w;

			update	nut_pac_elemento
			set		qt_elem_kg_dia	= (ceil((qt_aporte_hidrico_diario_w - qt_vol_total_w) * 100) / 100) / qt_peso_w,
					qt_diaria		= ceil((qt_aporte_hidrico_diario_w - qt_vol_total_w) * 100) / 100,
					qt_volume_final	= ceil((qt_aporte_hidrico_diario_w - qt_vol_total_w) * 100) / 100
			where 	nr_seq_nut_pac	= nr_sequencia_p
			and		nr_sequencia	= nr_seq_elem_agua_w;

		end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_agua_nut_pac_ped ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
