-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_ocorrencias_transf_epis ( nr_episodio_origem_p bigint, nr_episodio_destino_p bigint, nm_tabela_p text, nm_atributo_p text, nm_usuario_p text, cd_estabelecimento_p bigint DEFAULT NULL, qt_reg_p bigint DEFAULT NULL, dt_registro_p timestamp DEFAULT NULL, ie_transfere_p text DEFAULT NULL, ds_motivo_transf_p text  DEFAULT NULL) AS $body$
DECLARE


    nr_seq_transf_cases_w   ocorrencia_transf_episodio.nr_sequencia%TYPE;
    nr_episodio_origem_w    episodio_paciente.nr_sequencia%TYPE := nr_episodio_origem_p;
    nr_episodio_destino_w   episodio_paciente.nr_sequencia%TYPE := nr_episodio_destino_p;
    cd_estabelecimento_w    episodio_paciente.cd_estabelecimento%TYPE := cd_estabelecimento_p;
    nm_usuario_w            episodio_paciente.nm_usuario%TYPE := nm_usuario_p;
    dt_registro_w           episodio_paciente.dt_atualizacao%TYPE := dt_registro_p;

BEGIN
    SELECT
        nextval('ocorrencia_transf_episodio_seq')
    INTO STRICT nr_seq_transf_cases_w
;

    IF ( coalesce(dt_registro_w::text, '') = '' ) THEN
        dt_registro_w := clock_timestamp();
    END IF;
    INSERT INTO ocorrencia_transf_episodio(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        cd_estabelecimento,
        nm_tabela,
        nm_atributo,
        nr_episodio_origem,
        nr_episodio_destino,
        qt_registros,
        ie_transfere,
        ds_motivo_transf
    ) VALUES (
        nr_seq_transf_cases_w,
        dt_registro_w,
        nm_usuario_w,
        cd_estabelecimento_w,
        nm_tabela_p,
        nm_atributo_p,
        nr_episodio_origem_w,
        nr_episodio_destino_w,
        qt_reg_p,
        ie_transfere_p,
        ds_motivo_transf_p
    );

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_ocorrencias_transf_epis ( nr_episodio_origem_p bigint, nr_episodio_destino_p bigint, nm_tabela_p text, nm_atributo_p text, nm_usuario_p text, cd_estabelecimento_p bigint DEFAULT NULL, qt_reg_p bigint DEFAULT NULL, dt_registro_p timestamp DEFAULT NULL, ie_transfere_p text DEFAULT NULL, ds_motivo_transf_p text  DEFAULT NULL) FROM PUBLIC;
