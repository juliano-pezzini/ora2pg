-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_lab_soro_armazena_rack ( cd_barras_rack_p text ) AS $body$
DECLARE

nr_seq_rack_w  lab_soro_armazena_rack.nr_seq_rack%TYPE;
nr_seq_armazena_w lab_soro_armazena_rack.nr_sequencia%TYPE;


BEGIN
    BEGIN
        SELECT nr_sequencia
        INTO STRICT   nr_seq_rack_w
        FROM   lab_soro_rack
        WHERE  coalesce(ds_etiqueta, nr_etiqueta) = cd_barras_rack_p;
    EXCEPTION
        WHEN no_data_found THEN
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1024678, 'CD_BARRAS_RACK='||cd_barras_rack_p);
    END;

	select nextval('lab_soro_armazena_rack_seq')
	into STRICT   nr_seq_armazena_w
;

    INSERT INTO lab_soro_armazena_rack( nr_sequencia,
                                         dt_atualizacao,
                                         nm_usuario,
                                         dt_atualizacao_nrec,
                                         nm_usuario_nrec,
                                         nr_seq_rack ) VALUES ( nr_seq_armazena_w,
                                         clock_timestamp(),
                                         wheb_usuario_pck.get_nm_usuario(),
                                         clock_timestamp(),
                                         wheb_usuario_pck.get_nm_usuario(),
                                         nr_seq_rack_w );

    INSERT INTO lab_soro_processo_info( nr_sequencia,
                                         ie_acao,
                                         dt_acao,
                                         dt_atualizacao,
                                         nr_seq_armazena_rack,
                                         nm_usuario ) VALUES ( nextval('lab_soro_processo_info_seq'),
                                         'AR',
                                         clock_timestamp(),
                                         clock_timestamp(),
                                         nr_seq_armazena_w,
                                         wheb_usuario_pck.get_nm_usuario());
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_lab_soro_armazena_rack ( cd_barras_rack_p text ) FROM PUBLIC;
