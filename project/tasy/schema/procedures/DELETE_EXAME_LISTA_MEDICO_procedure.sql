-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_exame_lista_medico ( nr_prescricao_p bigint, nr_sequencia_prescricao_p bigint) AS $body$
DECLARE

    nr_prescricao_w             lista_central_exame.nr_prescricao%type;
    nr_seq_prescricao_w         lista_central_exame.nr_sequencia_prescricao%type;
    nr_seq_laudo_w              laudo_paciente.nr_sequencia%type;
    remove_lista_medica_w       varchar(1) := 'N';

BEGIN
    nr_prescricao_w     := nr_prescricao_p;
    nr_seq_prescricao_w := nr_sequencia_prescricao_p;

    remove_lista_medica_w := obter_param_usuario(99010, 94, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, remove_lista_medica_w);

    select max(nr_sequencia)
    into STRICT nr_seq_laudo_w
    from laudo_paciente
    where nr_prescricao = nr_prescricao_w
    and nr_seq_prescricao = nr_seq_prescricao_w
    and ie_status_laudo = 'LL'
    order by dt_atualizacao;

    if ((nr_seq_laudo_w IS NOT NULL AND nr_seq_laudo_w::text <> '') and remove_lista_medica_w = 'S') then
        DELETE FROM lista_central_exame a
        WHERE a.rowid in (
            SELECT d.rowid
            from laudo_paciente b,
                procedimento_paciente c,
                lista_central_exame d
            where b.nr_sequencia = c.nr_laudo
            and c.nr_prescricao = d.nr_prescricao
            and c.nr_sequencia_prescricao = d.nr_sequencia_prescricao
            and b.nr_sequencia = nr_seq_laudo_w);
    else
        DELETE FROM lista_central_exame a
        WHERE a.nr_prescricao = nr_prescricao_w
        AND a.nr_sequencia_prescricao = nr_seq_prescricao_w;
    end if;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_exame_lista_medico ( nr_prescricao_p bigint, nr_sequencia_prescricao_p bigint) FROM PUBLIC;
