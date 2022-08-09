-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE suspender_etapa_npt ( ie_tipo_solucao_p bigint, nr_seq_nut_pac_p bigint, nr_seq_nut_hor_p bigint, nr_prescricao_p bigint, nm_usuario_p text ) AS $body$
DECLARE


ie_alteracao_sol_w bigint;


BEGIN
    if ((ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '')
        and (nr_seq_nut_pac_p IS NOT NULL AND nr_seq_nut_pac_p::text <> '')
        and (nr_seq_nut_hor_p IS NOT NULL AND nr_seq_nut_hor_p::text <> '')
        and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '')) then

        ie_alteracao_sol_w := 12;

        CALL gerar_alter_sol_prescr_adep(ie_tipo_solucao_p, nr_prescricao_p, nr_seq_nut_pac_p, ie_alteracao_sol_w, null, nm_usuario_p,null);

        update	nut_paciente_hor
        set		dt_suspensao	= clock_timestamp(),
                nm_usuario_susp	= nm_usuario_p
        where	nr_sequencia = nr_seq_nut_hor_p
        and		coalesce(dt_suspensao::text, '') = ''
        and		coalesce(dt_fim_horario::text, '') = '';	

        commit;
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE suspender_etapa_npt ( ie_tipo_solucao_p bigint, nr_seq_nut_pac_p bigint, nr_seq_nut_hor_p bigint, nr_prescricao_p bigint, nm_usuario_p text ) FROM PUBLIC;
