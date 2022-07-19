-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consult_laudo_apac_paci ( nr_seq_interno_p bigint) AS $body$
DECLARE

        nr_integration_code_w   constant bigint := 1003;
        ds_param_integ_w        varchar(1000);
        cd_pessoa_fisica_w      sus_laudo_paciente.cd_pessoa_fisica%type;
        dt_emissao_w            sus_laudo_paciente.dt_emissao%type;
        cd_procedimento_solic_w sus_laudo_paciente.cd_procedimento_solic%type;
        cd_cartaoSUS_w          pessoa_fisica.nr_cartao_nac_sus%type;
        nr_apac_w               sus_laudo_paciente.nr_apac%type;
        co_CNS_w                constant varchar(3)   := 'CNS';
        co_nrSeqInterno_w       constant varchar(20)  := '{"nrSeqInterno" : ';
        co_cartaoSUS_w          constant varchar(20)  := ' , "cartaoSUS" : ';
        co_codigoProcedimento_w constant varchar(30)  := ' , "codigoProcedimento" : ';
        co_somenteMaisRecente_w constant varchar(30)  := ' , "somenteMaisRecente" : ';
        co_numeroApac_w         constant varchar(20)  := ' , "numeroApac" : ';
        co_aspas_w              constant varchar(5)   := '"';
        co_chave_w              constant varchar(5)   := '}';

BEGIN

        select  cd_pessoa_fisica, 
                dt_emissao somenteMaisRecente,
                cd_procedimento_solic codigoProcedimento,
                obter_dados_pf(cd_pessoa_fisica, co_CNS_w) cartaoSUS,
                nr_apac numeroApac
        into STRICT    cd_pessoa_fisica_w,
                dt_emissao_w,
                cd_procedimento_solic_w,
                cd_cartaoSUS_w,
                nr_apac_w
        from sus_laudo_paciente
        where nr_seq_interno = nr_seq_interno_p
        and (cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');

        ds_param_integ_w := 
                co_nrSeqInterno_w || co_aspas_w || nr_seq_interno_p || co_aspas_w || 
                co_cartaoSUS_w || co_aspas_w || cd_cartaoSUS_w || co_aspas_w || 
                co_codigoprocedimento_w || co_aspas_w || cd_procedimento_solic_w || co_aspas_w || 
                co_somenteMaisRecente_w || co_aspas_w || dt_emissao_w || co_aspas_w || 
                co_numeroApac_w || co_aspas_w || nr_apac_w || co_aspas_w || co_chave_w;

        CALL execute_bifrost_integration(nr_integration_code_w, ds_param_integ_w);
        commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consult_laudo_apac_paci ( nr_seq_interno_p bigint) FROM PUBLIC;

