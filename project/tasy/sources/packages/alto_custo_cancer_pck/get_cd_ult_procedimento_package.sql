-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_cancer_pck.get_cd_ult_procedimento (nr_atendimento_p text,cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


        ds_retorno_w			bigint;


BEGIN
        begin
            SELECT  max(proc.CD_PROCEDIMENTO_LOC)
            into STRICT    ds_retorno_w
            FROM    RXT_TUMOR rt,
                    RXT_TIPO rti,
                    RXT_TIPO_TRAT_PROCED rttp,
                    procedimento PROC,
                    rxt_tratamento rtr
            WHERE   nr_atendimento = nr_atendimento_p
            AND     rt.NR_SEQ_TIPO = rti.nr_sequencia
            AND     rttp.NR_SEQ_TIPO = rti.nr_sequencia
            AND     proc.CD_PROCEDIMENTO = rttp.CD_PROCEDIMENTO
            AND     proc.ie_origem_proced = rttp.IE_ORIGEM_PROCED
            AND     rt.nr_sequencia = rtr.nr_seq_tumor
            AND     rtr.DT_INICIO_TRAT = (
                                        SELECT  MAX(DT_INICIO_TRAT)
                                        FROM    rxt_tratamento rtr,
                                                rxt_tumor rt
                                        WHERE   rt.cd_pessoa_fisica = cd_pessoa_fisica_p
                                        AND     rt.nr_sequencia = rtr.nr_seq_tumor
                                        AND     coalesce(rtr.dt_cancelamento::text, '') = ''
                                        AND     DT_INICIO_TRAT BETWEEN alto_custo_pck.get_data_inicio_emissao_guia
                                                                    and alto_custo_pck.get_data_corte
                                        );

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
-- REVOKE ALL ON FUNCTION alto_custo_cancer_pck.get_cd_ult_procedimento (nr_atendimento_p text,cd_pessoa_fisica_p text) FROM PUBLIC;
