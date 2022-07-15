-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_elem_peritoneal ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_peso_w		double precision;
nr_sequencia_w		bigint;
nr_seq_elemento_w	bigint;
qt_elem_kg_dia_w	double precision;
qt_diaria_w		double precision;
pr_total_w		smallint;
qt_kcal_w		double precision;
ie_tipo_elemento_w	varchar(3);
qt_conversao_ml_w	double precision;
qt_volume_w		double precision;
cd_material_w		integer;
nr_seq_dialise_w	bigint;
qt_volume_ciclo_w	double precision;
nr_ciclos_w		smallint;
ie_tipo_peritoneal_w	varchar(15);


c01 CURSOR FOR
SELECT	qt_solucao,
	cd_material
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_solucao	= nr_seq_solucao_p;


c02 CURSOR FOR
SELECT	a.nr_sequencia,
	c.qt_conversao_ml,
	b.ie_tipo_elemento,
	a.qt_elemento
from	nut_elem_material c,
	nut_elemento b,
	hd_prescr_sol_elem a
where	a.nr_seq_elemento	= b.nr_sequencia
and	b.nr_sequencia	= c.nr_seq_elemento
and	c.cd_material	= cd_material_w
and	a.nr_prescricao	= nr_prescricao_p
and	a.nr_seq_solucao	= nr_seq_solucao_p
and	coalesce(c.ie_tipo,'NPT')	= 'NPT';


BEGIN

update	hd_prescr_sol_elem
set	qt_elemento	= 0
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p;

commit;

open c01;
loop
fetch c01 into
	qt_volume_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	open c02;
	loop
	fetch c02 into
      		nr_seq_elemento_w,
		qt_conversao_ml_w,
		ie_tipo_elemento_w,
		qt_diaria_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		qt_diaria_w		:= qt_diaria_w + dividir(qt_volume_w,qt_conversao_ml_w);

		update	hd_prescr_sol_elem
		set	qt_elemento	= qt_diaria_w
		where	nr_sequencia	= nr_seq_elemento_w;

	end loop;
	close c02;


end loop;
close c01;

select	sum(qt_solucao)
into STRICT	qt_volume_w
from	prescr_material
where	nr_prescricao		= nr_prescricao_p
and	nr_sequencia_solucao	= nr_seq_solucao_p;

update	prescr_solucao
set	qt_volume	= qt_volume_w,
	qt_solucao_total= coalesce(nr_etapas,1) * qt_volume_w
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p;

select	nr_seq_dialise
into STRICT	nr_seq_dialise_w
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_solucao	= nr_seq_solucao_p;

select	sum(qt_volume)
into STRICT	qt_volume_w
from	prescr_solucao
where	nr_prescricao	= nr_prescricao_p
and	nr_seq_dialise	= nr_seq_dialise_w
and	coalesce(ie_ultima_bolsa,'N') = 'N';

select	max(nr_ciclos),
	max(ie_tipo_peritoneal)
into STRICT	nr_ciclos_w,
	ie_tipo_peritoneal_w
from	hd_prescricao
where	nr_sequencia	= nr_seq_dialise_w;

if (nr_ciclos_w > 0) and (ie_tipo_peritoneal_w <> 'DPA') then
	qt_volume_ciclo_w	:= (qt_volume_w / nr_ciclos_w);
end if;

update	hd_prescricao
set	qt_volume_total	= qt_volume_w,
	qt_volume_ciclo	= coalesce(qt_volume_ciclo_w,qt_volume_ciclo)
where	nr_sequencia	= nr_seq_dialise_w;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_elem_peritoneal ( nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text) FROM PUBLIC;

