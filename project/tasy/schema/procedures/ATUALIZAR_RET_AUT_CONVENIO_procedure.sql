-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_ret_aut_convenio (ds_erro_retorno_p tiss_retorno_autorizacao.ds_erro_retorno%type, nr_seq_autorizacao_p tiss_retorno_autorizacao.nr_seq_autorizacao%type, ds_motivo_geral_glosa_p tiss_retorno_autorizacao.ds_motivo_geral_glosa%type, nr_seq_estagio_p autorizacao_convenio.nr_seq_estagio%type, cd_senha_p autorizacao_convenio.cd_senha%type, dt_inicio_vigencia_p autorizacao_convenio.dt_inicio_vigencia%type) AS $body$
DECLARE


ds_erro_retorno_w tiss_retorno_autorizacao.ds_erro_retorno%type := ds_erro_retorno_p;
nr_seq_autorizacao_w tiss_retorno_autorizacao.nr_seq_autorizacao%type := nr_seq_autorizacao_p;
nm_usuario_w constant tiss_retorno_autorizacao.nm_usuario%type := 'interfaces';
ds_motivo_geral_glosa_w tiss_retorno_autorizacao.ds_motivo_geral_glosa%type := ds_motivo_geral_glosa_p;
nr_seq_estagio_w autorizacao_convenio.nr_seq_estagio%type := nr_seq_estagio_p;
cd_senha_w autorizacao_convenio.cd_senha%type := cd_senha_p;
dt_inicio_vigencia_w autorizacao_convenio.dt_inicio_vigencia%type := dt_inicio_vigencia_p;
nm_interface_w constant integration_call_log.nm_interface%type := 'api.insurance.authorization';
nr_seq_int_call_log_w integration_message_log.nr_seq_int_call_log%type := 0;
ds_notes_w integration_call_log.ds_notes%TYPE;
ds_notes_message_w integration_call_log.ds_notes%TYPE := 'Success in the update process. Table: autorizacao_convenio. ';
ds_notes_params_w integration_call_log.ds_notes%TYPE;
ie_status_w integration_call_log.ie_status%type := 'S';
ie_message_type_w integration_call_log.ie_message_type%type := 'R';
separador_linha_w constant integration_call_log.nm_message%type :=  CHR(13) || CHR(10);


BEGIN

    <<INSERT_TISS>>
    BEGIN        
    
        ds_notes_params_w := substr(' nr_seq_autorizacao: '||nr_seq_autorizacao_w||
                                    ' nr_seq_estagio: '||nr_seq_estagio_w||' cd_senha: '||cd_senha_w||' ds_motivo_geral_glosa: '||ds_motivo_geral_glosa_w||
                                    ' ds_erro_retorno: '||ds_erro_retorno_w||' ds_motivo_geral_glosa: '||ds_motivo_geral_glosa_w||' dt_inicio_vigencia: '||
                                    to_char(dt_inicio_vigencia_w,'dd/mm/yyyy'),1,499);

        ds_notes_w := substr(ds_notes_message_w || separador_linha_w || ds_notes_params_w,1,499);
    
        INSERT INTO tiss_retorno_autorizacao(
            ds_erro_retorno,
            dt_atualizacao,
            dt_atualizacao_nrec,
            dt_evento,
            nm_usuario,
            nr_seq_autorizacao,
            ds_motivo_geral_glosa,
            nr_sequencia)
        VALUES (
            ds_erro_retorno_w,
            clock_timestamp(),
            clock_timestamp(),
            clock_timestamp(),
            nm_usuario_w,
            nr_seq_autorizacao_w,
            ds_motivo_geral_glosa_w,
            nextval('tiss_retorno_autorizacao_seq'));

    END;
        
    <<UPDATE_TISS>>
    BEGIN
        update autorizacao_convenio
        set nr_seq_estagio = nr_seq_estagio_w,
            cd_senha = cd_senha_w,
            dt_inicio_vigencia = dt_inicio_vigencia_w,
            dt_atualizacao = clock_timestamp()
        where nr_sequencia = nr_seq_autorizacao_w;

        nr_seq_int_call_log_w := record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), nm_interface_w, nm_interface_w, ie_status_w, ie_message_type_w, null, ds_notes_w, null, null, null, nr_seq_int_call_log_w, null, null, null);
    END;

    COMMIT;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_ret_aut_convenio (ds_erro_retorno_p tiss_retorno_autorizacao.ds_erro_retorno%type, nr_seq_autorizacao_p tiss_retorno_autorizacao.nr_seq_autorizacao%type, ds_motivo_geral_glosa_p tiss_retorno_autorizacao.ds_motivo_geral_glosa%type, nr_seq_estagio_p autorizacao_convenio.nr_seq_estagio%type, cd_senha_p autorizacao_convenio.cd_senha%type, dt_inicio_vigencia_p autorizacao_convenio.dt_inicio_vigencia%type) FROM PUBLIC;
