-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_itens_lote_disp ( cd_mat_barra_p ap_lote.nr_sequencia%type, nr_seq_processo_p adep_processo.nr_sequencia%type, cd_material_p INOUT text, cd_barras_p INOUT text, cd_unid_med_p INOUT text ) AS $body$
DECLARE


cd_material_w           varchar(4000);
cd_barras_w             varchar(4000);
cd_unid_med_w           varchar(4000);
nr_seq_lote_fornec_w    material_atend_paciente.nr_seq_lote_fornec%type;
cd_barra_material_lf_w  material_lote_fornec.cd_barra_material%type;

c01 CURSOR FOR
SELECT  b.cd_material cd_material,
        coalesce(b.cd_unidade_medida_dose, 'XPTO') cd_unid_med,
        d.nr_atendimento,
        d.nr_prescricao,
        b.nr_seq_material,
        b.nr_seq_lote_fornec
from    prescr_mat_hor b,
        ap_lote a,
        ap_lote_item c,
        adep_processo d
where   d.nr_sequencia = b.nr_seq_processo
and     a.nr_sequencia = c.nr_seq_lote
and     b.nr_sequencia = c.nr_seq_mat_hor
and     a.nr_sequencia = b.nr_seq_lote
and     a.nr_sequencia = cd_mat_barra_p
and     d.nr_sequencia = nr_seq_processo_p
and	    obter_se_horario_liberado(b.dt_lib_horario, b.dt_horario) = 'S';

BEGIN

if (cd_mat_barra_p IS NOT NULL AND cd_mat_barra_p::text <> '' AND nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') then

    for c01_w in c01
    loop
        if (c01_w.cd_material IS NOT NULL AND c01_w.cd_material::text <> '') then
            if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
                cd_material_w := cd_material_w || ',' || c01_w.cd_material;
            else
                cd_material_w := c01_w.cd_material;
            end if;
            if (cd_unid_med_w IS NOT NULL AND cd_unid_med_w::text <> '') then
                cd_unid_med_w := cd_unid_med_w || ',' || c01_w.cd_unid_med;
            else
                cd_unid_med_w := c01_w.cd_unid_med;
            end if;
        end if;

        select  coalesce(max(a.nr_seq_lote_fornec), c01_w.nr_seq_lote_fornec)
        into STRICT    nr_seq_lote_fornec_w
        from    material_atend_paciente a
        where   a.nr_atendimento = c01_w.nr_atendimento
        and     a.nr_prescricao = c01_w.nr_prescricao
        and     a.nr_sequencia_prescricao = c01_w.nr_seq_material
        and     a.nr_seq_lote_ap = cd_mat_barra_p;

        if ((c01_w.nr_atendimento IS NOT NULL AND c01_w.nr_atendimento::text <> '') and
                (c01_w.nr_prescricao IS NOT NULL AND c01_w.nr_prescricao::text <> '') and
                (c01_w.nr_seq_material IS NOT NULL AND c01_w.nr_seq_material::text <> '')) then

            select  max(a.cd_barra_material)
            into STRICT    cd_barra_material_lf_w
            from    material_lote_fornec a
            where   a.nr_sequencia = nr_seq_lote_fornec_w;

            if (cd_barra_material_lf_w IS NOT NULL AND cd_barra_material_lf_w::text <> '') then
                if (cd_barras_w IS NOT NULL AND cd_barras_w::text <> '') then
                    cd_barras_w := cd_barras_w || ',' || cd_barra_material_lf_w;
                else
                    cd_barras_w := cd_barra_material_lf_w;
                end if;
            elsif (nr_seq_lote_fornec_w IS NOT NULL AND nr_seq_lote_fornec_w::text <> '') then
                if (length(nr_seq_lote_fornec_w) < 10) then
                    if (cd_barras_w IS NOT NULL AND cd_barras_w::text <> '') then
                        cd_barras_w := cd_barras_w || ',' || lpad(nr_seq_lote_fornec_w, 10, '0');
                    else
                        cd_barras_w := lpad(nr_seq_lote_fornec_w, 10, '0');
                    end if;
                else
                    if (cd_barras_w IS NOT NULL AND cd_barras_w::text <> '') then
                        cd_barras_w := cd_barras_w || ',' || nr_seq_lote_fornec_w;
                    else
                        cd_barras_w := nr_seq_lote_fornec_w;
                    end if;
                end if;
            else
                if (cd_barras_w IS NOT NULL AND cd_barras_w::text <> '') then
                    cd_barras_w := cd_barras_w || ',' || c01_w.cd_material;
                else
                    cd_barras_w := c01_w.cd_material;
                end if;
            end if;
        end if;
    end loop;

    cd_material_p := cd_material_w;
    cd_barras_p := cd_barras_w;
    cd_unid_med_p := cd_unid_med_w;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_itens_lote_disp ( cd_mat_barra_p ap_lote.nr_sequencia%type, nr_seq_processo_p adep_processo.nr_sequencia%type, cd_material_p INOUT text, cd_barras_p INOUT text, cd_unid_med_p INOUT text ) FROM PUBLIC;

