-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_reprov (nr_seq_horario_p bigint) RETURNS varchar AS $body$
DECLARE


ie_reprovado_w	varchar(1) := 'N';
cont_w		bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	material c,
	prescr_mat_hor a,
	prescr_material b
where	a.nr_prescricao		= b.nr_prescricao
and	a.nr_seq_material	= b.nr_sequencia
and	a.cd_material		= c.cd_material
and	a.nr_sequencia		= nr_seq_horario_p
and	b.qt_dias_liberado	= 0
and	c.ie_controle_medico 	<> '0';

if (cont_w	> 0) then
	ie_reprovado_w	:= 'S';
end if;

return	ie_reprovado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_reprov (nr_seq_horario_p bigint) FROM PUBLIC;
