-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_data_coleta ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_etapa_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_coleta_w	timestamp;


BEGIN

select	max(dt_atualizacao)
into STRICT	dt_coleta_w
from	prescr_proc_etapa
where	nr_prescricao 		= nr_prescricao_p
and     nr_seq_prescricao 	= nr_seq_prescricao_p
and	ie_etapa		= ie_etapa_p;

return 	dt_coleta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_data_coleta ( nr_prescricao_p bigint, nr_seq_prescricao_p bigint, ie_etapa_p bigint) FROM PUBLIC;
