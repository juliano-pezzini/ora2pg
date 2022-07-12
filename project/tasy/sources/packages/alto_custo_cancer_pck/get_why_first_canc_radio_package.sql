-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_why_first_canc_radio (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


      ds_retorno_w    bigint;


BEGIN        

        select  alto_custo_cancer_pck.get_cd_motivo_cancelamento(nr_seq_motivo_canc)
        into STRICT    ds_retorno_w
        from (
                SELECT  rtr.nr_seq_motivo_canc, rtr.dt_inicio_trat, rtr.dt_cancelamento
                from    rxt_tratamento rtr,
                        rxt_tumor rt
                where   rt.cd_pessoa_fisica = cd_pessoa_fisica_p
                and     rt.nr_sequencia = rtr.nr_seq_tumor
                and     (rtr.dt_liberacao IS NOT NULL AND rtr.dt_liberacao::text <> '')
                and     coalesce(rtr.dt_suspensao::text, '') = ''
                and     rtr.dt_inicio_trat between alto_custo_pck.get_data_inicio_emissao_guia
                                                and alto_custo_pck.get_data_corte
                order by    dt_inicio_trat
                ) alias3 where     (dt_cancelamento IS NOT NULL AND dt_cancelamento::text <> '') LIMIT 1;

        return ds_retorno_w;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_why_first_canc_radio (cd_pessoa_fisica_p text) FROM PUBLIC;