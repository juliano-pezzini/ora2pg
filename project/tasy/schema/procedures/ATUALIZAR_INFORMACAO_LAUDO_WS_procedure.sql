-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_informacao_laudo_ws ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_prescr_p prescr_procedimento.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE, ie_normal_p laudo_paciente.ie_normal%TYPE) AS $body$
BEGIN

    UPDATE laudo_paciente
    SET ie_normal = ie_normal_p,
        dt_atualizacao = clock_timestamp(),
        nm_usuario = nm_usuario_p
    WHERE nr_prescricao = nr_prescricao_p
        AND nr_seq_prescricao = nr_seq_prescr_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_informacao_laudo_ws ( nr_prescricao_p prescr_procedimento.nr_prescricao%TYPE, nr_seq_prescr_p prescr_procedimento.nr_sequencia%TYPE, nm_usuario_p usuario.nm_usuario%TYPE, ie_normal_p laudo_paciente.ie_normal%TYPE) FROM PUBLIC;
