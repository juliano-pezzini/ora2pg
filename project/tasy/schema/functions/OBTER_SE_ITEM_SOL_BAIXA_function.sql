-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_sol_baixa ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_item_baixado_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_item_baixado_w
from	prescr_material
where	nr_prescricao 		= nr_prescricao_p
and	nr_sequencia_solucao 	= nr_seq_solucao_p
and	cd_motivo_baixa = 1;

return	ie_item_baixado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_sol_baixa ( nr_prescricao_p bigint, nr_seq_solucao_p bigint) FROM PUBLIC;
