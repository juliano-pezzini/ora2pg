-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_ie_tipo_processo ( nr_seq_processo_p prescr_mat_hor.nr_seq_processo%type, nr_seq_horario_p prescr_mat_hor.nr_sequencia%type, nr_seq_area_prep_p prescr_mat_hor.nr_seq_area_prep%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_proc_p prescr_procedimento.nr_sequencia%type ) AS $body$
DECLARE


ie_tipo_processo_w prescr_mat_hor.ie_tipo_item_processo%type;


BEGIN

if (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '' AND nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') then
    select  max('IVC')
    into STRICT    ie_tipo_processo_w
    from    prescr_procedimento a where     a.nr_prescricao = nr_prescricao_p
    and     a.nr_sequencia = nr_sequencia_proc_p
    and     a.ie_suspenso = 'N'
    and     obter_se_proc_ivc(a.nr_seq_proc_interno) = 'S' LIMIT 1;

    if (coalesce(ie_tipo_processo_w::text, '') = '') then
        select  max('IAG')
        into STRICT    ie_tipo_processo_w
        from    proc_interno w,
                prescr_procedimento y,
                prescr_material x,
                prescr_mat_hor c
        where   w.nr_sequencia = y.nr_seq_proc_interno
        and     y.nr_prescricao = x.nr_prescricao
        and     y.nr_sequencia = x.nr_sequencia_proc
        and     x.nr_prescricao = c.nr_prescricao
        and     x.nr_sequencia = c.nr_seq_material
        and     c.nr_prescricao = y.nr_prescricao
        and     coalesce(w.ie_tipo,'O') <> 'BS'
        and     coalesce(w.ie_ivc,'N') <> 'S'
        and     coalesce(w.ie_ctrl_glic,'NC') in ('CCG','CIG')
        and     (y.nr_seq_proc_interno IS NOT NULL AND y.nr_seq_proc_interno::text <> '')
        and     (y.nr_seq_prot_glic IS NOT NULL AND y.nr_seq_prot_glic::text <> '')
        and     coalesce(y.nr_seq_exame::text, '') = ''
        and     coalesce(y.nr_seq_solic_sangue::text, '') = ''
        and     coalesce(y.nr_seq_solic_sangue::text, '') = ''
        and     coalesce(y.nr_seq_derivado::text, '') = ''
        and     coalesce(y.nr_seq_exame_sangue::text, '') = ''
        and     x.ie_agrupador = 5
        and     c.ie_agrupador = 5
        and     c.nr_prescricao = nr_prescricao_p
        and     y.nr_sequencia = nr_sequencia_proc_p
        and     coalesce(c.ie_situacao,'A') = 'A';
    end if;

    update  prescr_mat_hor a
    set     a.nr_seq_processo = nr_seq_processo_p,
            a.ie_tipo_item_processo = coalesce(ie_tipo_processo_w, 'MAP')
    where   a.nr_sequencia = nr_seq_horario_p
    and     ((a.nr_seq_area_prep = nr_seq_area_prep_p) or (coalesce(nr_seq_area_prep_p::text, '') = ''));
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_ie_tipo_processo ( nr_seq_processo_p prescr_mat_hor.nr_seq_processo%type, nr_seq_horario_p prescr_mat_hor.nr_sequencia%type, nr_seq_area_prep_p prescr_mat_hor.nr_seq_area_prep%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_proc_p prescr_procedimento.nr_sequencia%type ) FROM PUBLIC;

