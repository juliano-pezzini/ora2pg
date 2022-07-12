-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_liberado (nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_liberado_w
from	prescr_medica a,
	prescr_mat_hor b
where	a.nr_prescricao = b.nr_prescricao
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_prescricao = nr_prescricao_p
and	b.nr_seq_material = nr_sequencia_p
and	(b.dt_lib_horario IS NOT NULL AND b.dt_lib_horario::text <> '')
and	coalesce(a.dt_liberacao_farmacia::text, '') = '';

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_liberado (nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

