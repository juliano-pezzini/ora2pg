-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_saldo_cir (cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_saldo_cir_w		double precision	:= 0;
qt_cirurgia_w			double precision	:= 0;
qt_emprestimo_w		double precision	:= 0;
cd_material_w			integer;
ie_tipo_local_w		varchar(5);
qt_conv_estoque_w		double precision;
cd_local_estoque_w		integer;
dt_mesano_referencia_w	timestamp;

C01 CURSOR FOR
SELECT	distinct cd_local_estoque
from	saldo_estoque
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_local_estoque	= cd_local_estoque_p
and	cd_material		= cd_material_w
and	dt_mesano_referencia	>= dt_mesano_referencia_w
and	coalesce(cd_local_estoque_p,0) > 0

union all

SELECT	distinct cd_local_estoque
from	saldo_estoque
where	cd_estabelecimento	= cd_estabelecimento_p
and	coalesce(cd_local_estoque_p,0) = 0
and	dt_mesano_referencia	>= dt_mesano_referencia_w
and	cd_material		= cd_material_w;


BEGIN

select	max(dt_mesano_vigente)
into STRICT	dt_mesano_referencia_w
from	Parametro_estoque
where	cd_estabelecimento	= cd_estabelecimento_p;

select	coalesce(max(qt_conv_estoque_consumo),1),
	max(cd_material_estoque)
into STRICT	qt_conv_estoque_w,
	cd_material_w
from	Material
where	cd_material			= cd_material_p;

OPEN  c01;
LOOP
FETCH c01 into cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_emprestimo_w	:= 0;
	qt_cirurgia_w		:= 0;

	select	ie_tipo_local
	into STRICT	ie_tipo_local_w
	from 	local_estoque
	where	cd_local_estoque	= cd_local_estoque_w;

	if (ie_tipo_local_w = 2) then
		begin
		select	/*+ index (a PRESMAT_I3)*/                coalesce(sum(qt_total_dispensar),0)
		into STRICT	qt_cirurgia_w
		from	Setor_Atendimento c,
			Cirurgia b,
			Material x,
			Prescr_material a,
			prescr_medica m
		where	a.cd_motivo_baixa = 0
		and	a.cd_material             = x.cd_material
		and	x.cd_material_estoque     = cd_material_w
		and	m.nr_prescricao           = b.nr_prescricao
		and	m.nr_prescricao           = a.nr_prescricao
		and	b.cd_setor_atendimento    = c.cd_setor_atendimento
		and	c.cd_local_estoque        = cd_local_estoque_w
		and	a.ie_status_cirurgia    in ('CB','AD');
		qt_cirurgia_w	:= dividir( coalesce(qt_cirurgia_w,0), coalesce(qt_conv_estoque_w,1));
		end;
	end if;
	qt_saldo_cir_w	:= qt_saldo_cir_w + coalesce(qt_cirurgia_w,0);
	end;
END LOOP;
CLOSE c01;

return qt_saldo_cir_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_saldo_cir (cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint, dt_mesano_referencia_p timestamp) FROM PUBLIC;

