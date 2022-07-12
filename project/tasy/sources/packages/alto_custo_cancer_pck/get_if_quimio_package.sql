-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_if_quimio (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


        ds_retorno_w			integer;


BEGIN

      begin

            select  CASE WHEN count(*)=0 THEN  98  ELSE 1 END 
            into STRICT    ds_retorno_w
            from    paciente_atendimento
            where   nr_atendimento = nr_atendimento_p
            and     (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
            and     coalesce(dt_suspensao::text, '') = ''
            and     (dt_fim_adm IS NOT NULL AND dt_fim_adm::text <> '')
            and     dt_fim_adm between alto_custo_pck.get_data_inicio_emissao_guia
                                  and alto_custo_pck.get_data_corte;

        exception
            when no_data_found then
                ds_retorno_w := null;
      end;

      return ds_retorno_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_if_quimio (nr_atendimento_p bigint) FROM PUBLIC;
