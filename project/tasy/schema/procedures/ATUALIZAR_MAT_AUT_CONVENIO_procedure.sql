-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_mat_aut_convenio (cd_material_glo_p material_vinculo_global.cd_material_glo%TYPE, nr_seq_autorizacao_p material_autorizado.nr_seq_autorizacao%TYPE, qt_autorizada_p material_autorizado.qt_autorizada%TYPE, ds_motivo_glosa_p material_autorizado.ds_motivo_glosa%TYPE, vl_coseguro_p material_autorizado.vl_coseguro%TYPE, vl_percentual_coseguro_p material_autorizado.vl_percentual_coseguro%TYPE, vl_total_autorizado_p material_autorizado.vl_total_autorizado%TYPE, vl_iva_autorizado_p material_autorizado.vl_iva_autorizado%TYPE, nr_sequencia_autor_p material_autorizado.nr_sequencia_autor%TYPE, vl_qt_bonus_p material_autorizado.qt_bonus%TYPE, nr_sequencia_p material_autorizado.nr_sequencia%TYPE) AS $body$
DECLARE


cd_material_glo_w material_vinculo_global.cd_material_glo%TYPE := cd_material_glo_p;
nr_seq_autorizacao_w material_autorizado.nr_seq_autorizacao%TYPE := nr_seq_autorizacao_p;
qt_autorizada_w material_autorizado.qt_autorizada%TYPE := qt_autorizada_p;
ds_motivo_glosa_w material_autorizado.ds_motivo_glosa%TYPE := ds_motivo_glosa_p;
vl_coseguro_w material_autorizado.vl_coseguro%TYPE := vl_coseguro_p;
vl_percentual_coseguro_w material_autorizado.vl_percentual_coseguro%TYPE := vl_percentual_coseguro_p;
vl_total_autorizado_w material_autorizado.vl_total_autorizado%TYPE := vl_total_autorizado_p;
vl_iva_autorizado_w material_autorizado.vl_iva_autorizado%TYPE := vl_iva_autorizado_p;
nr_sequencia_autor_w material_autorizado.nr_sequencia_autor%TYPE := nr_sequencia_autor_p;
vl_qt_bonus_w material_autorizado.qt_bonus%TYPE := vl_qt_bonus_p;
nr_sequencia_w material_autorizado.nr_sequencia%TYPE := nr_sequencia_p;
nm_usuario_w constant tiss_retorno_autorizacao.nm_usuario%type := 'interfaces';
nm_interface_w constant integration_call_log.nm_interface%type := 'api.insurance.authorization';
nr_seq_int_call_log_w integration_message_log.nr_seq_int_call_log%type := 0;
ds_notes_w integration_call_log.ds_notes%TYPE;
ds_notes_message_w integration_call_log.ds_notes%TYPE := 'Success in the update process. Table: material_autorizado. ';
ds_notes_params_w integration_call_log.ds_notes%TYPE;
ie_status_w integration_call_log.ie_status%type := 'S';
ie_message_type_w constant integration_call_log.ie_message_type%type := 'R';
separador_linha_w constant integration_call_log.nm_interface%type :=  CHR(13) || CHR(10);


BEGIN

    <<PARAMS>>
    BEGIN
        ds_notes_params_w := substr(' nr_sequencia_autor: '||nr_sequencia_autor_w||
                                    ' cd_material_glo: '||cd_material_glo_w||' nr_seq_autorizacao: '||nr_seq_autorizacao_w||
                                    ' qt_autorizada: '||qt_autorizada_w||' ds_motivo_glosa: '||ds_motivo_glosa_w||' vl_coseguro: '||vl_coseguro_w||
                                    ' vl_percentual_coseguro: '||vl_percentual_coseguro_w||' vl_total_autorizado: '||vl_total_autorizado_w||
                                    ' vl_iva_autorizado: '||vl_iva_autorizado_w||' vl_qt_bonus: '||vl_qt_bonus_w||
                                    ' nr_sequencia: '||nr_sequencia_w,1,499);

    END;

    <<BLOCO_UPDATE>>
    BEGIN
        
        INSERT INTO tiss_retorno_autorizacao(
            nr_seq_mat_autor,
            nr_seq_autorizacao,                
            dt_evento,
            nm_usuario,
            dt_atualizacao,
            ds_motivo_geral_glosa,
            nr_sequencia)
        VALUES (
            nr_sequencia_w,
            nr_sequencia_autor_w,
            clock_timestamp(),
            nm_usuario_w,
            clock_timestamp(),
            ds_motivo_glosa_w,
            nextval('tiss_retorno_autorizacao_seq'));

        update material_autorizado
        set    qt_autorizada = qt_autorizada_w,
               ds_motivo_glosa = ds_motivo_glosa_w,
               vl_coseguro = vl_coseguro_w,
               vl_total_autorizado = vl_total_autorizado_w,
               vl_iva_autorizado = vl_iva_autorizado_w,
               vl_percentual_coseguro = vl_percentual_coseguro_w,
               dt_atualizacao = clock_timestamp(),
               nr_seq_autorizacao = nr_seq_autorizacao_w,
               qt_bonus = vl_qt_bonus_w
        where nr_sequencia = nr_sequencia_w
        and nr_sequencia_autor = nr_sequencia_autor_w;

        ds_notes_w := substr(ds_notes_message_w || separador_linha_w || ds_notes_params_w,1,499);

        nr_seq_int_call_log_w := record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), nm_interface_w, nm_interface_w, ie_status_w, ie_message_type_w, null, ds_notes_w, null, null, null, nr_seq_int_call_log_w, null, null, null);

        COMMIT;

    EXCEPTION
        WHEN no_data_found OR data_exception THEN
            ie_status_w := 'E';
            ds_notes_message_w := substr('Error in updating authorization materials. Table: material_autorizado. SQL_ERRM = '|| sqlerrm||' ',1,499);
            ds_notes_w := substr(ds_notes_message_w || separador_linha_w || ds_notes_params_w,1,499);

            nr_seq_int_call_log_w := record_integration_call_log(nm_usuario_w, nm_usuario_w, clock_timestamp(), nm_interface_w, nm_interface_w, ie_status_w, ie_message_type_w, null, ds_notes_w, null, null, null, nr_seq_int_call_log_w, null, null, null);

            CALL wheb_mensagem_pck.exibir_mensagem_abort('Update error in AuthorizedMaterial. '||ds_notes_w);
    END;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_mat_aut_convenio (cd_material_glo_p material_vinculo_global.cd_material_glo%TYPE, nr_seq_autorizacao_p material_autorizado.nr_seq_autorizacao%TYPE, qt_autorizada_p material_autorizado.qt_autorizada%TYPE, ds_motivo_glosa_p material_autorizado.ds_motivo_glosa%TYPE, vl_coseguro_p material_autorizado.vl_coseguro%TYPE, vl_percentual_coseguro_p material_autorizado.vl_percentual_coseguro%TYPE, vl_total_autorizado_p material_autorizado.vl_total_autorizado%TYPE, vl_iva_autorizado_p material_autorizado.vl_iva_autorizado%TYPE, nr_sequencia_autor_p material_autorizado.nr_sequencia_autor%TYPE, vl_qt_bonus_p material_autorizado.qt_bonus%TYPE, nr_sequencia_p material_autorizado.nr_sequencia%TYPE) FROM PUBLIC;
