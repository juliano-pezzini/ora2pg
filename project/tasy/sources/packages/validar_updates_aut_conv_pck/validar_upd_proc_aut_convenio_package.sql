-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE validar_updates_aut_conv_pck.validar_upd_proc_aut_convenio (nr_seq_proc_interno_p procedimento_autorizado.nr_seq_proc_interno%TYPE, nr_sequencia_autor_p tiss_retorno_autorizacao.nr_seq_proc_autor%TYPE, ds_mensagem_retorno_p INOUT integration_call_log.ds_notes%TYPE, nr_sequencia_p procedimento_autorizado.nr_sequencia%TYPE) AS $body$
DECLARE


    nr_seq_proc_interno_w procedimento_autorizado.nr_seq_proc_interno%TYPE := nr_seq_proc_interno_p;
    nr_sequencia_autor_w tiss_retorno_autorizacao.nr_seq_proc_autor%TYPE := nr_sequencia_autor_p;
    nr_sequencia_w procedimento_autorizado.nr_sequencia%TYPE := nr_sequencia_p;
    quantidade_registros_w integer;


BEGIN
        select count(1)
        into STRICT quantidade_registros_w
        from procedimento_autorizado
        where nr_sequencia = nr_sequencia_w
        and nr_sequencia_autor = nr_sequencia_autor_w;

        if (quantidade_registros_w = 0) then
            ds_mensagem_retorno_p := current_setting('validar_updates_aut_conv_pck.separador_linha_w')::varchar(50)CHR(13)||||'There are no records with the Transaction Id '||nr_sequencia_autor_w|| ' and procedureSequence '||
                                     nr_sequencia_w ||'. Validate the information and try again.';
            CALL validar_updates_aut_conv_pck.grava_log_processo_erro(ds_mensagem_retorno_p);
        end if;

    EXCEPTION
        WHEN no_data_found THEN
             CALL wheb_mensagem_pck.exibir_mensagem_abort('An error occurred while consulting the insurance authorization procedure records. '
||
             'numberSeqInternalProc '||nr_seq_proc_interno_w||'. Error: '|| sqlerrm);
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_updates_aut_conv_pck.validar_upd_proc_aut_convenio (nr_seq_proc_interno_p procedimento_autorizado.nr_seq_proc_interno%TYPE, nr_sequencia_autor_p tiss_retorno_autorizacao.nr_seq_proc_autor%TYPE, ds_mensagem_retorno_p INOUT integration_call_log.ds_notes%TYPE, nr_sequencia_p procedimento_autorizado.nr_sequencia%TYPE) FROM PUBLIC;