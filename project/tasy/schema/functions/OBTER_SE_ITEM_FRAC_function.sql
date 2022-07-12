-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_frac ( nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	gedi_medic_atend
where	nr_seq_horario = nr_seq_horario_p
and		coalesce(qt_saldo,0) > 0;

if (ds_retorno_w = 'N') then

    select	coalesce(max('S'), 'N')
	into STRICT	ds_retorno_w
	from	prescr_material a,
			prescr_mat_hor b
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_sequencia = b.nr_seq_material
	and		b.nr_sequencia = nr_seq_horario_p
	and		b.qt_dispensar_hor = 0
	and		a.ie_regra_disp in ('E', 'S');

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_frac ( nr_seq_horario_p bigint) FROM PUBLIC;

