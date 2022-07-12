-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_if_past_tumor (cd_pessoa_fisica_p text, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


        ds_retorno_w			integer;


BEGIN

      begin

            select  CASE WHEN count(pac.cd_doenca)=0 THEN  2  ELSE 1 END  
            into STRICT    ds_retorno_w
            from    diagnostico_doenca dd,
                    paciente_antec_clinico pac,
                    regra_alto_custo_cid racc, 
                    regra_alto_custo rac 
            where   pac.cd_pessoa_fisica = cd_pessoa_fisica_p 
            and     dd.nr_atendimento = nr_atendimento_p
            and     rac.ie_tipo_doenca = 'C'
            and     rac.nr_sequencia = racc.nr_seq_regra_alto_custo
            and     dd.cd_doenca like '%'||racc.cd_categoria_cid||'%'
            and     pac.cd_doenca = dd.cd_doenca
            and     dd.ie_classificacao_doenca  = 'P'
            and     dd.ie_tipo_diagnostico = 2
            and     (dd.dt_liberacao IS NOT NULL AND dd.dt_liberacao::text <> '')
            and     coalesce(dd.dt_inativacao::text, '') = ''
            and     (pac.dt_liberacao IS NOT NULL AND pac.dt_liberacao::text <> '')
            and     coalesce(pac.dt_inativacao::text, '') = ''
            and     coalesce(pac.dt_fim, pac.dt_inicio) < (dd.dt_liberacao - 1);

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
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_if_past_tumor (cd_pessoa_fisica_p text, nr_atendimento_p bigint) FROM PUBLIC;