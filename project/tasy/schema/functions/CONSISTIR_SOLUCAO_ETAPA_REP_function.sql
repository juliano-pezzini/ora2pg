-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_solucao_etapa_rep ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


qt_existe_w	bigint := 0;
ie_calc_aut_w	varchar(1);
nr_etapas_w	smallint;
retorno_w		varchar(1) := 'N';


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	prescr_material
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia_solucao = nr_seq_solucao_p
and	ie_agrupador = 4;

select	coalesce(ie_calc_aut,'N'),
	coalesce(nr_etapas,0)
into STRICT	ie_calc_aut_w,
	nr_etapas_w
from	prescr_solucao
where	nr_prescricao = nr_prescricao_p
and	nr_seq_solucao = nr_seq_solucao_p;

if (qt_existe_w <> 0) and (ie_calc_aut_w = 'S') and (nr_etapas_w = 0) then

	retorno_w := 'S';

end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_solucao_etapa_rep ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
