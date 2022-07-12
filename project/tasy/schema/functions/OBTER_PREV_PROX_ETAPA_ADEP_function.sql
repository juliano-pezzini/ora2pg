-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prev_prox_etapa_adep (nr_seq_cpoe_p cpoe_material.nr_sequencia%type) RETURNS timestamp AS $body$
DECLARE


dt_prev_prox_etapa_w	prescr_solucao.dt_prev_prox_etapa%type;


BEGIN

select	max(a.dt_prev_prox_etapa)
into STRICT	dt_prev_prox_etapa_w
from	prescr_solucao a,
		prescr_material b
where	a.nr_prescricao = b.nr_prescricao
and		a.nr_seq_solucao = b.nr_sequencia_solucao
and		b.nr_seq_mat_cpoe = nr_seq_cpoe_p;

return	dt_prev_prox_etapa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prev_prox_etapa_adep (nr_seq_cpoe_p cpoe_material.nr_sequencia%type) FROM PUBLIC;

