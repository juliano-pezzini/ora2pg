-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_dt_ini_last_cycle (cd_pessoa_fisica_p text) RETURNS timestamp AS $body$
DECLARE


        ds_retorno_w			timestamp;


BEGIN

        select max(dt_inicio_adm)
        into STRICT    ds_retorno_w
        from (
                SELECT
                nr_ciclo,
                max(a.dt_inicio_adm) dt_inicio_adm,
                nr_seq_paciente,
                count(1) qt_ciclos,
                sum(case when coalesce(dt_fim_adm::text, '') = '' then 0 else 1 end) qt_ciclos_finalizados
                from paciente_atendimento a
                cross join(SELECT cd_pessoa_fisica_p cd_pessoa_fisica )
                where a.nr_seq_paciente = (
                                            select  max(nr_seq_paciente)
                                            from    paciente_atendimento b
                                            where   cd_pessoa_fisica = obter_pessoa_atendimento(b.nr_atendimento, 'C') 
                                            and     b.dt_fim_adm between alto_custo_pck.get_data_inicio_emissao_guia
                                                                    and alto_custo_pck.get_data_corte
                                            )
                and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
                and     coalesce(dt_suspensao::text, '') = ''
                and (a.dt_fim_adm between alto_custo_pck.get_data_inicio_emissao_guia
                                        and alto_custo_pck.get_data_corte or coalesce(a.dt_fim_adm::text, '') = '')
                group by    nr_ciclo, nr_seq_paciente
                ) alias13 
        where qt_ciclos = qt_ciclos_finalizados;

      return ds_retorno_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_dt_ini_last_cycle (cd_pessoa_fisica_p text) FROM PUBLIC;