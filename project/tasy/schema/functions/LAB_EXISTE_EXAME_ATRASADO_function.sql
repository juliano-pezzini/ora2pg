-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_existe_exame_atrasado ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type, nr_seq_grupo_p exame_laboratorio.nr_seq_grupo%type default null, ie_urgencia_p prescr_procedimento.ie_urgencia%type default null) RETURNS varchar AS $body$
DECLARE

ie_exame_atrasado_w	varchar(1) := 'N';

BEGIN
    if (coalesce(nr_seq_grupo_p::text, '') = '') then
        select	CASE WHEN count(*)=0 THEN ie_exame_atrasado_w  ELSE 'S' END
        into STRICT	ie_exame_atrasado_w
        from 	prescr_procedimento a,
            prescr_procedimento_compl b
        where	a.nr_prescricao = nr_prescricao_p
        and	(((coalesce(nr_seq_prescr_p::text, '') = '') or (nr_seq_prescr_p = 0)) or (a.nr_sequencia = nr_seq_prescr_p))
        and	b.nr_sequencia = a.nr_seq_proc_compl
        and ((coalesce(ie_urgencia_p::text, '') = '' ) or (coalesce(ie_urgencia,'N') = ie_urgencia_p))
        and	b.dt_result_atrasado < clock_timestamp();
    else
        select	CASE WHEN count(*)=0 THEN ie_exame_atrasado_w  ELSE 'S' END
        into STRICT	ie_exame_atrasado_w
        from 	prescr_procedimento a,
            prescr_procedimento_compl b,
            exame_laboratorio c
        where	a.nr_prescricao = nr_prescricao_p
        and	(((coalesce(nr_seq_prescr_p::text, '') = '') or (nr_seq_prescr_p = 0)) or (a.nr_sequencia = nr_seq_prescr_p))
        and	c.nr_seq_grupo = nr_seq_grupo_p
        and	b.nr_sequencia = a.nr_seq_proc_compl
        and	a.nr_seq_exame = c.nr_seq_exame
        and ((coalesce(ie_urgencia_p::text, '') = '' ) or (coalesce(ie_urgencia,'N') = ie_urgencia_p))
        and	b.dt_result_atrasado < clock_timestamp();
    end if;

return	ie_exame_atrasado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_existe_exame_atrasado ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_prescr_p prescr_procedimento.nr_sequencia%type, nr_seq_grupo_p exame_laboratorio.nr_seq_grupo%type default null, ie_urgencia_p prescr_procedimento.ie_urgencia%type default null) FROM PUBLIC;
