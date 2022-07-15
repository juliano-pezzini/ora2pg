-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_pe_prescr_diag ( nr_seq_pe_prescr_p bigint, nr_seq_diagnostico_p bigint, ie_acao_p text, nm_usuario_p text) AS $body$
DECLARE

	  
    nr_sequencia_pe_prescr_diag_w       pe_prescr_diag.nr_sequencia%type;
    nr_seq_pe_prescr_diag_troca_w       pe_prescr_diag.nr_sequencia%type;
    ie_diag_colab_cp_possible_w         cp_possible_diag.ie_diag_colab%type;
    nr_ordenacao_pe_prescr_diag_w       pe_prescr_diag.nr_seq_ordenacao%type;
    ie_recorrencia_w                    pe_prescr_diag.ie_recorrencia%type;
    cd_pessoa_fisica_w                  pe_prescricao.cd_pessoa_fisica%type;
    dt_prescricao_w                     pe_prescricao.dt_prescricao%type;
    dt_inicio_prescr_w                  pe_prescricao.dt_inicio_prescr%type;
    nr_prioridade_w                     pe_prescr_diag.nr_prioridade%TYPE := null;
    nr_prioridade_troca_w               pe_prescr_diag.nr_prioridade%TYPE := null;

    const_ie_inclusao_w                 varchar(1)  :=  'I';
    const_ie_exclusao_w                 varchar(1)  :=  'E';
    const_ie_up_priority_w              varchar(1)  :=  'U';
    const_ie_down_priority_w            varchar(1)  :=  'D';

BEGIN
    select  cd_pessoa_fisica
    into STRICT    cd_pessoa_fisica_w
    from    pe_prescricao
    where   nr_sequencia = nr_seq_pe_prescr_p;

    ie_recorrencia_w := check_diagnosis_is_recurrence(cd_pessoa_fisica_w, nr_seq_pe_prescr_p, nr_seq_diagnostico_p);

    if ie_acao_p = const_ie_inclusao_w then

        select  coalesce(max(ie_diag_colab), 'N')
        into STRICT    ie_diag_colab_cp_possible_w
        from    cp_possible_diag
        where   nr_seq_diag = nr_seq_diagnostico_p;

        SELECT COUNT(1)+1 INTO STRICT nr_prioridade_w FROM pe_prescr_diag WHERE nr_seq_prescr = nr_seq_pe_prescr_p;

        SELECT DT_PRESCRICAO, dt_inicio_prescr  
        INTO STRICT dt_prescricao_w, dt_inicio_prescr_w
        FROM PE_PRESCRICAO 
        WHERE NR_SEQUENCIA = nr_seq_pe_prescr_p;

        select nextval('pe_prescr_diag_seq')
        into STRICT nr_sequencia_pe_prescr_diag_w
;

        nr_ordenacao_pe_prescr_diag_w := obter_num_ordenacao_diag( nr_seq_pe_prescr_p, nr_seq_diagnostico_p, ie_diag_colab_cp_possible_w);

        insert into
            pe_prescr_diag(
            nr_sequencia,
            nr_seq_prescr,
            nr_seq_diag,
            nm_usuario,
            dt_atualizacao,
            dt_start,
            ie_diag_colab,
            nr_seq_ordenacao,
            ie_recorrencia,
            NR_PRIORIDADE)
        values (
            nr_sequencia_pe_prescr_diag_w,
            nr_seq_pe_prescr_p,
            nr_seq_diagnostico_p,
            nm_usuario_p,
            dt_prescricao_w,
            dt_inicio_prescr_w,
            ie_diag_colab_cp_possible_w,
            nr_ordenacao_pe_prescr_diag_w,
            ie_recorrencia_w,
            nr_prioridade_w);

        if (obter_param_funcao_html5(281, 1614) = 'N') then  
            
            CALL VINCULAR_DIAG_RESULTS(nr_seq_diagnostico_p,nr_seq_pe_prescr_p,nm_usuario_p);
            
        END IF;

    elsif (ie_acao_p = const_ie_exclusao_w) then

        select  max(nr_seq_ordenacao), MAX(NR_PRIORIDADE)
        into STRICT    nr_ordenacao_pe_prescr_diag_w, nr_prioridade_w
        from    pe_prescr_diag
        where   nr_seq_prescr = nr_seq_pe_prescr_p
        and     nr_seq_diag = nr_seq_diagnostico_p;

        delete
        from    pe_prescr_diag
        where   nr_seq_prescr = nr_seq_pe_prescr_p
        and     nr_seq_diag = nr_seq_diagnostico_p;

        CALL consistir_nr_seq_ord_diag( nr_seq_pe_prescr_p, nr_ordenacao_pe_prescr_diag_w);

        UPDATE pe_prescr_diag SET NR_PRIORIDADE = NR_PRIORIDADE - 1 WHERE nr_seq_prescr = nr_seq_pe_prescr_p AND NR_PRIORIDADE >= nr_prioridade_w;

    elsif (ie_acao_p = const_ie_up_priority_w or ie_acao_p = const_ie_down_priority_w) then

        select  nr_sequencia,
                NR_PRIORIDADE
        into STRICT    nr_sequencia_pe_prescr_diag_w,
                nr_prioridade_w
        from    pe_prescr_diag
        where   nr_seq_prescr = nr_seq_pe_prescr_p
        and     nr_seq_diag   = nr_seq_diagnostico_p;

        if (ie_acao_p = const_ie_down_priority_w) then

            select coalesce(max(a.nr_sequencia), 0),
                   max(NR_PRIORIDADE)
            into STRICT   nr_seq_pe_prescr_diag_troca_w,
                   nr_prioridade_troca_w
            from   pe_prescr_diag a
            where  a.nr_seq_prescr = nr_seq_pe_prescr_p
            and    a.NR_PRIORIDADE = (SELECT min(x.NR_PRIORIDADE)
                                         from   pe_prescr_diag x
                                         where  x.nr_seq_prescr = nr_seq_pe_prescr_p
                                         and    x.NR_PRIORIDADE > nr_prioridade_w);

        end if;

        if (ie_acao_p = const_ie_up_priority_w) then

            select coalesce(max(a.nr_sequencia), 0),
                   max(nr_prioridade)
            into STRICT   nr_seq_pe_prescr_diag_troca_w,
                   nr_prioridade_troca_w
            from   pe_prescr_diag a
            where  a.nr_seq_prescr = nr_seq_pe_prescr_p
            and    a.NR_PRIORIDADE = (SELECT max(x.NR_PRIORIDADE)
                                         from   pe_prescr_diag x
                                         where  x.nr_seq_prescr = nr_seq_pe_prescr_p
                                         and    x.NR_PRIORIDADE < nr_prioridade_w);

        end if;

        if (nr_sequencia_pe_prescr_diag_w > 0 and nr_seq_pe_prescr_diag_troca_w > 0 ) then

            UPDATE pe_prescr_diag
            SET    nr_prioridade = nr_prioridade_troca_w
            WHERE  nr_seq_prescr    = nr_seq_pe_prescr_p
            and    nr_sequencia     = nr_sequencia_pe_prescr_diag_w;

            UPDATE pe_prescr_diag
            SET    nr_prioridade = nr_prioridade_w
            WHERE  nr_seq_prescr = nr_seq_pe_prescr_p
            and    nr_sequencia = nr_seq_pe_prescr_diag_troca_w;

        end if;

    end if;

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_pe_prescr_diag ( nr_seq_pe_prescr_p bigint, nr_seq_diagnostico_p bigint, ie_acao_p text, nm_usuario_p text) FROM PUBLIC;

