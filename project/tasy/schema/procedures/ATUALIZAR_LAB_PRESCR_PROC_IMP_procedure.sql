-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_lab_prescr_proc_imp ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_mapa_laudo_p text, nm_usuario_p text, ie_tipo_imp_p text) AS $body$
DECLARE


nr_status_exame_param_w integer;
nr_status_exame_w   integer;
ie_valida_nr_seq_prescr_w varchar(1);

BEGIN

select  CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
into STRICT    ie_valida_nr_seq_prescr_w
from    prescr_procedimento
where   nr_prescricao       = nr_prescricao_p and
        nr_sequencia        = coalesce(nr_seq_prescr_p, nr_sequencia);

if (ie_valida_nr_seq_prescr_w = 'S') then

    insert  into lab_prescr_proc_impressao(
        nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            dt_impressao,
            nr_prescricao,
            nr_seq_prescr,
            ie_mapa_laudo,
        ie_tipo_imp)
    values (    nextval('lab_prescr_proc_impressao_seq'),
        clock_timestamp(),
        coalesce(nm_usuario_p, 'TASY'),
        clock_timestamp(),
        coalesce(nm_usuario_p, 'TASY'),
        clock_timestamp(),
        nr_prescricao_p,
        nr_seq_prescr_p,
        ie_mapa_laudo_p,
        ie_tipo_imp_p);


    nr_status_exame_param_w := Obter_Valor_Param_Usuario( 80, 40, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);

    if ((nr_status_exame_param_w IS NOT NULL AND nr_status_exame_param_w::text <> '') and (ie_mapa_laudo_p = 'I') and (ie_tipo_imp_p) = 'V') then

        select  max(ie_status_atend)
        into STRICT    nr_status_exame_w
        from    prescr_procedimento
        where   nr_prescricao       = nr_prescricao_p
        and nr_sequencia        = nr_seq_prescr_p;

        if (nr_status_exame_w IS NOT NULL AND nr_status_exame_w::text <> '') and (nr_status_exame_w >= 35) then
            update  prescr_procedimento
            set ie_status_atend     = nr_status_exame_param_w,
                nm_usuario = coalesce(nm_usuario_p, 'LaboratorioWeb'),
                dt_atualizacao = clock_timestamp()
            where   nr_prescricao       = nr_prescricao_p
            and nr_sequencia        = nr_seq_prescr_p;
        end if;

    end if;

else

    CALL gravar_log_lab(13684, 'Atualizar_lab_prescr_proc_imp não foi possível localizar o exame. nr_seq_prescr_p: ' || nr_seq_prescr_p ||
                            ' ie_mapa_laudo_p: ' || ie_mapa_laudo_p ||
                            ' ie_tipo_imp_p: ' || ie_tipo_imp_p, nm_usuario_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_lab_prescr_proc_imp ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_mapa_laudo_p text, nm_usuario_p text, ie_tipo_imp_p text) FROM PUBLIC;
