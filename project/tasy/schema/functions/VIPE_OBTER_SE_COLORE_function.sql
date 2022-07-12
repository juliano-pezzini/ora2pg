-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION vipe_obter_se_colore (ie_motivo_prescricao_p text, nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


ie_pintar_w     varchar(1);
qt_horario_w    bigint;


BEGIN

select  max(ie_pintar)
into STRICT    ie_pintar_w
from    vipe_regra_motivo_prescr
where   ie_motivo_prescricao    = ie_motivo_prescricao_p;

if (ie_pintar_w = 'S') then
        if (ie_tipo_item_p in ('M','MAT','SNE','S','SOL')) then
                select  count(*)
                into STRICT    qt_horario_w
                from    prescr_mat_hor
                where   (dt_fim_horario IS NOT NULL AND dt_fim_horario::text <> '')
                and     nr_prescricao = nr_prescricao_p
                and     nr_seq_material = nr_sequencia_p;

                if (qt_horario_w > 0) then
                        ie_pintar_w := 'N';
                end if;
        elsif (ie_tipo_item_p in ('P','CCG','CIG','L','IVC','HM')) then
                select  count(*)
                into STRICT    qt_horario_w
                from    prescr_proc_hor
                where   (dt_fim_horario IS NOT NULL AND dt_fim_horario::text <> '')
                and     nr_prescricao = nr_prescricao_p
                and     nr_seq_procedimento = nr_sequencia_p;

                if (qt_horario_w > 0) then
                        ie_pintar_w := 'N';
                end if;
        elsif (ie_tipo_item_p = 'R') then
                select  count(*)
                into STRICT    qt_horario_w
                from    prescr_rec_hor
                where   (dt_fim_horario IS NOT NULL AND dt_fim_horario::text <> '')
                and     nr_prescricao = nr_prescricao_p
                and     nr_seq_recomendacao     = nr_sequencia_p;

                if (qt_horario_w > 0) then
                        ie_pintar_w := 'N';
                end if;
        end if;
end if;

return  ie_pintar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION vipe_obter_se_colore (ie_motivo_prescricao_p text, nr_prescricao_p bigint, nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;
