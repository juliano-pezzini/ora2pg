-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_min_aplicacao ( nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_mat_diluicao_w		bigint;
qt_minuto_aplicacao_w		bigint;
qt_hora_aplicacao_w			bigint;
qt_w						bigint;


BEGIN

select	max(nr_seq_mat_diluicao)
into STRICT	nr_seq_mat_diluicao_w
from	prescr_material
where	nr_prescricao			= nr_prescricao_p
and		nr_sequencia_diluicao	= nr_seq_material_p
and		ie_agrupador			= 9;

select	count(*)
into STRICT	qt_w
from	prescr_material
where	nr_prescricao			= nr_prescricao_p
and		nr_sequencia_diluicao	= nr_seq_material_p
and		ie_agrupador			= 3;

if (nr_seq_mat_diluicao_w > 0) and (qt_w = 0) then
	select	max(qt_minuto_aplicacao)
	into STRICT	qt_minuto_aplicacao_w
	from	material_diluicao
	where	nr_seq_interno	= nr_seq_mat_diluicao_w;

	if (qt_minuto_aplicacao_w > 0) then
		if (qt_minuto_aplicacao_w < 60) then
			qt_hora_aplicacao_w	:= null;
		elsif (qt_minuto_aplicacao_w = 60) then
			qt_hora_aplicacao_w	:= 1;
			qt_minuto_aplicacao_w	:= null;
		else
			qt_hora_aplicacao_w	:= trunc(dividir(qt_minuto_aplicacao_w,60));
			qt_minuto_aplicacao_w	:= (qt_minuto_aplicacao_w - (qt_hora_aplicacao_w * 60));
		end if;
	end if;

	if (qt_minuto_aplicacao_w = 0) then
		qt_minuto_aplicacao_w	:= null;
	end if;

	if (coalesce(qt_minuto_aplicacao_w,0) > 0) or (coalesce(qt_hora_aplicacao_w,0) > 0) then
		update	prescr_material
		set		qt_min_aplicacao	= qt_minuto_aplicacao_w,
				qt_hora_aplicacao	= qt_hora_aplicacao_w
		where	nr_prescricao		= nr_prescricao_p
		and		nr_sequencia		= nr_seq_material_p
		and		ie_aplic_bolus		= 'N'
		and		ie_aplic_lenta		= 'N';

		commit;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_min_aplicacao ( nr_prescricao_p bigint, nr_seq_material_p bigint, nm_usuario_p text) FROM PUBLIC;
