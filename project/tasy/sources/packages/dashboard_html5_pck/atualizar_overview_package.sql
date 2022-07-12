-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dashboard_html5_pck.atualizar_overview () AS $body$
DECLARE

        /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Finalidade:  Atualizar dados de OVERVIEW do Dashboard do HTML5
        ---------------------------------------------------------------------------------------------------------------------------------------------

        Locais de chamada direta: 
        [  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [X] Outros: Procedure atualizar_dashboard
         --------------------------------------------------------------------------------------------------------------------------------------------

        Pontos de atencao:
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

    
        /*variaveis precisam ficar antes pois sao usadas no cursor c01 */


        dt_ini_w     timestamp;
        dt_fim_w     timestamp;
        dia_semana_w bigint;

        /* dados para inserir previsto */


        c01 CURSOR FOR
            SELECT g.ie_tipo_informacao,
                   g.nr_seq_agrupamento,
                   sum(g.qt_milestone_prev) qt_milestone_prev,
                   sum(g.qt_horas_prev) qt_horas_prev
              from ( -- seleciona checkpoints previstos para funcoes que nao tem milestones
                    SELECT 'A' ie_tipo_informacao,
                            a.nr_seq_agrupamento,
                            count(a.nr_sequencia) qt_milestone_prev,
                            sum(a.qt_horas_cron_analise) qt_horas_prev
                      from funcoes_html5 a
                     where trunc(a.dt_prev_checkpoint) between dt_ini_w and dt_fim_w
                       and not exists (select 1 from funcoes_html5_milestone m where m.nr_seq_funcao = a.nr_sequencia)
                     group by 'A',
                               a.nr_seq_agrupamento
                    
union all

                    -- seleciona milestones previstos das funcoes

                    select 'A' ie_tipo_informacao,
                            a.nr_seq_agrupamento,
                            count(m.nr_sequencia) qt_milestone_prev,
                            sum(m.qt_hora_prev) qt_horas_prev
                      from funcoes_html5_milestone m,
                            funcoes_html5           a
                     where m.nr_seq_funcao = a.nr_sequencia
                       and trunc(m.dt_prevista) between dt_ini_w and dt_fim_w
                     group by 'A',
                               a.nr_seq_agrupamento) g
             group by g.ie_tipo_informacao,
                      g.nr_seq_agrupamento
            
union all

            select 'V' ie_tipo_informacao,
                   nr_seq_agrupamento,
                   count(nr_sequencia) qt_milestone_prev,
                   sum(qt_horas_cron_teste) qt_horas_prev
              from funcoes_html5
             where trunc(dt_prev_fim_teste) between dt_ini_w and dt_fim_w
             group by 'V',
                      nr_seq_agrupamento;

        /* dados para atualizar realizado */


        c02 CURSOR FOR
            SELECT g.ie_tipo_informacao,
                   g.nr_seq_agrupamento,
                   sum(g.qt_milestone_real) qt_milestone_real,
                   sum(g.qt_horas_real) qt_horas_real
              from ( -- seleciona checkpoints realizados para funcoes que nao tem milestones
                    SELECT 'A' ie_tipo_informacao,
                            a.nr_seq_agrupamento,
                            count(a.nr_sequencia) qt_milestone_real,
                            sum(a.qt_horas_cron_analise) qt_horas_real
                      from funcoes_html5 a
                     where trunc(a.dt_real_checkpoint) between dt_ini_w and dt_fim_w
                       and not exists (select 1 from funcoes_html5_milestone m where m.nr_seq_funcao = a.nr_sequencia)
                     group by 'A',
                               a.nr_seq_agrupamento
                    
union all

                    -- seleciona milestones realizados das funcoes

                    select 'A' ie_tipo_informacao,
                            a.nr_seq_agrupamento,
                            count(m.nr_sequencia) qt_milestone_real,
                            sum(m.qt_hora_real) qt_horas_real
                      from funcoes_html5_milestone m,
                            funcoes_html5           a
                     where m.nr_seq_funcao = a.nr_sequencia
                       and trunc(m.dt_real) between dt_ini_w and dt_fim_w
                     group by 'A',
                               a.nr_seq_agrupamento) g
             group by g.ie_tipo_informacao,
                      g.nr_seq_agrupamento
            
union all

            select 'V' ie_tipo_informacao,
                   nr_seq_agrupamento,
                   count(nr_sequencia) qt_milestone_real,
                   sum(qt_horas_total_teste) qt_horas_real
              from funcoes_html5
             where trunc(dt_real_fim_teste) between dt_ini_w and dt_fim_w
             group by 'V',
                      nr_seq_agrupamento;
        nr_sequencia_rem_w bigint;

BEGIN
    
        dt_fim_w     := trunc(clock_timestamp());
        dia_semana_w := to_char(dt_fim_w, 'd');

        /*se for diferente de sabado sai da procedure*/


        if dia_semana_w <> 7 then
            return;
        end if;

        /* Atualiza realizado ******************************************/


    
        /*define primeiro dia da semana  para filtro do cursor c02*/


        dt_ini_w := trunc(dt_fim_w - 5);

        /*define ultimo dia da semana para filtro do cursor c02*/


        dt_fim_w := trunc(dt_fim_w - 1);

        /*atualiza realizado*/


        for c02_w in c02 loop
            update funcoes_html5_overview
               set qt_milestone_real = c02_w.qt_milestone_real,
                   qt_horas_real     = c02_w.qt_horas_real
             where trunc(dt_primeiro_dia_semana) = trunc(dt_ini_w)
               and nr_seq_agrupamento = c02_w.nr_seq_agrupamento
               and ie_tipo_informacao = c02_w.ie_tipo_informacao;
        end loop;
        commit;

        /*insere previsto**********************************************/


    
        /* define data fim previsto*/


        dt_fim_w := trunc(clock_timestamp() + interval '6 days');

        /*define data inicio previsto filtro do cursor c01*/


        dt_ini_w := trunc(dt_fim_w - 4);

        for c01_w in c01 loop
            /* deleta para evitar duplicidade */


            delete from funcoes_html5_overview
             where nr_seq_agrupamento = c01_w.nr_seq_agrupamento
               and trunc(dt_primeiro_dia_semana) = trunc(dt_ini_w)
               and ie_tipo_informacao = c01_w.ie_tipo_informacao;
            commit;

            $if $$tasy_local_dict=true $then
            nr_sequencia_rem_w := get_remote_sequence('seq:funcoes_html5_overview_seq');
            $else
            select nextval('funcoes_html5_overview_seq') into STRICT nr_sequencia_rem_w;
            $end

            insert into funcoes_html5_overview(nr_sequencia,
                 dt_atualizacao,
                 nm_usuario,
                 dt_atualizacao_nrec,
                 nm_usuario_nrec,
                 nr_seq_agrupamento,
                 dt_primeiro_dia_semana,
                 ie_tipo_informacao,
                 qt_milestone_prev,
                 qt_horas_prev)
            values (nr_sequencia_rem_w, --funcoes_html5_overview_seq.nextval,
                 clock_timestamp(),
                 'tasy',
                 clock_timestamp(),
                 'tasy',
                 c01_w.nr_seq_agrupamento,
                 dt_ini_w,
                 c01_w.ie_tipo_informacao,
                 c01_w.qt_milestone_prev,
                 c01_w.qt_horas_prev);
            commit;
        end loop;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_html5_pck.atualizar_overview () FROM PUBLIC;