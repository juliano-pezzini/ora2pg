-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_sae_e_planoeduc_js ( nr_seq_horario_p bigint, ie_evolucao_p INOUT text, ie_plano_educacional_p INOUT text, ie_evolucao_clinica_p INOUT text, nr_seq_prescr_proc_p INOUT bigint) AS $body$
DECLARE


ie_evolucao_w			varchar(255);	
ie_plano_educacional_w		varchar(255);	
						

BEGIN

select	max(ie_evolucao)
into STRICT 	ie_evolucao_p
from 	pe_procedimento c,
	pe_prescr_proc a,
	pe_prescr_proc_hor b
where a.nr_seq_proc = c.nr_sequencia
and b.nr_seq_pe_proc = a.nr_sequencia 
and b.nr_sequencia = nr_seq_horario_p;

select 	max(c.ie_plano_educacional)
into STRICT	ie_plano_educacional_p
from 	pe_procedimento c,
	pe_prescr_proc a,
	pe_prescr_proc_hor b
where a.nr_seq_proc = c.nr_sequencia
and b.nr_seq_pe_proc = a.nr_sequencia
and b.nr_sequencia = nr_seq_horario_p;

ie_evolucao_w := ie_evolucao_p;
ie_plano_educacional_w := ie_plano_educacional_p;

if ( upper(ie_evolucao_w) = 'S') then
	select 	max(ie_evolucao_clinica)
	into STRICT	ie_evolucao_clinica_p
	from 	pe_procedimento c,
		pe_prescr_proc a,
		pe_prescr_proc_hor b
	where a.nr_seq_proc = c.nr_sequencia
	and b.nr_seq_pe_proc = a.nr_sequencia
	and b.nr_sequencia = nr_seq_horario_p;
end if;

if ( upper(ie_plano_educacional_w) in ('S','A')) then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_prescr_proc_p
	from	pe_procedimento c,
		pe_prescr_proc a,
		pe_prescr_proc_hor b
	where a.nr_seq_proc = c.nr_sequencia
	and b.nr_seq_pe_proc = a.nr_sequencia
	and b.nr_sequencia = nr_seq_horario_p;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_sae_e_planoeduc_js ( nr_seq_horario_p bigint, ie_evolucao_p INOUT text, ie_plano_educacional_p INOUT text, ie_evolucao_clinica_p INOUT text, nr_seq_prescr_proc_p INOUT bigint) FROM PUBLIC;
