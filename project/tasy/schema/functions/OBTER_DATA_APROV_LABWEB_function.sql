-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_aprov_labweb ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS timestamp AS $body$
DECLARE

dt_aprovacao_w		timestamp;
ie_status_atend_w	prescr_procedimento.ie_status_atend%type;


BEGIN

select	max(b.dt_aprovacao)
into STRICT	dt_aprovacao_w
from	exame_lab_result_item b,
	exame_lab_resultado a
where	a.nr_seq_resultado	= b.nr_seq_resultado
and	a.nr_prescricao		= nr_prescricao_p
and	b.nr_seq_prescr		= nr_seq_prescr_p;

select	coalesce(max(ie_status_atend),0)
into STRICT	ie_status_atend_w
from 	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia = nr_seq_prescr_p;

if (coalesce(dt_aprovacao_w::text, '') = '' and ie_status_atend_w = 35) then
	select	max(dt_atualizacao)
	into STRICT	dt_aprovacao_w
	from	prescr_proc_etapa
	where	nr_prescricao = nr_prescricao_p
	and	nr_seq_prescricao = nr_seq_prescr_p
	and	ie_etapa = 35;
end if;

return dt_aprovacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_aprov_labweb ( nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;
