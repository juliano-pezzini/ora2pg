-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_possui_saldo_estoque ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, nr_prescricao_p bigint, cd_material_p prescr_material.cd_material%type default null, qt_material_p prescr_material.qt_total_dispensar%type default null, cd_unid_med_dose_p prescr_material.cd_unidade_medida_dose%type default null) AS $body$
DECLARE


qt_estoque_w                prescr_material.qt_total_dispensar%type;
cd_material_w               prescr_material.cd_material%type;
cd_setor_atendimento_w      prescr_medica.cd_setor_atendimento%type;
cd_unidade_medida_dose_w    prescr_material.cd_unidade_medida_dose%type;
nr_seq_lote_fornec_w        prescr_material.nr_seq_lote_fornec%type;
ie_validado_w               varchar(1);

c01 CURSOR FOR
SELECT  a.cd_material,
        sum(a.qt_total_dispensar),
        b.cd_setor_atendimento,
        a.cd_unidade_medida_dose,
        a.nr_seq_lote_fornec
from    prescr_material a,
        prescr_medica b
where   a.nr_prescricao = b.nr_prescricao
and     b.nr_prescricao = nr_prescricao_p
and     coalesce(a.nr_seq_kit::text, '') = ''
and     coalesce(b.dt_liberacao::text, '') = ''
and     b.ie_emergencia = 'S'
group by a.cd_material,
      b.cd_setor_atendimento,
      a.cd_unidade_medida_dose,
      a.nr_seq_lote_fornec;


BEGIN

ie_validado_w := 'N';

if (cd_local_estoque_p IS NOT NULL AND cd_local_estoque_p::text <> '' AND nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
    open c01;
    loop
    fetch c01 into
        cd_material_w,
        qt_estoque_w,
        cd_setor_atendimento_w,
        cd_unidade_medida_dose_w,
        nr_seq_lote_fornec_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */

    if (cd_material_w = cd_material_p) then
        qt_estoque_w := qt_estoque_w + qt_material_p;
        ie_validado_w := 'S';
    end if;

    CALL obter_se_saldo_estoque( cd_estabelecimento_p => cd_estabelecimento_p,
                              cd_local_estoque_p => cd_local_estoque_p,
                              cd_material_p => cd_material_w,
                              qt_material_p => qt_estoque_w,
                              cd_setor_atendimento_p => cd_setor_atendimento_w,
                              cd_unidade_medida_dose_p => cd_unidade_medida_dose_w,
                              nr_seq_lote_fornec_p => nr_seq_lote_fornec_w );

    end loop;
    close c01;

    if ((cd_material_p IS NOT NULL AND cd_material_p::text <> '') and
            (qt_material_p IS NOT NULL AND qt_material_p::text <> '') and
            ie_validado_w = 'N') then

        select  max(a.cd_setor_atendimento)
        into STRICT    cd_setor_atendimento_w
        from    prescr_medica a
        where   a.nr_prescricao = nr_prescricao_p;

        CALL obter_se_saldo_estoque( cd_estabelecimento_p => cd_estabelecimento_p,
                                  cd_local_estoque_p => cd_local_estoque_p,
                                  cd_material_p => cd_material_p,
                                  qt_material_p => qt_material_p,
                                  cd_setor_atendimento_p => cd_setor_atendimento_w,
                                  cd_unidade_medida_dose_p => cd_unid_med_dose_p,
                                  nr_seq_lote_fornec_p => null );
    end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_possui_saldo_estoque ( cd_estabelecimento_p bigint, cd_local_estoque_p bigint, nr_prescricao_p bigint, cd_material_p prescr_material.cd_material%type default null, qt_material_p prescr_material.qt_total_dispensar%type default null, cd_unid_med_dose_p prescr_material.cd_unidade_medida_dose%type default null) FROM PUBLIC;

