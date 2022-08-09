-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_acompanhante ( cd_categoria_p atend_categoria_convenio.cd_categoria%TYPE, cd_convenio_p atend_categoria_convenio.cd_convenio%TYPE, cd_departamento_p atend_paciente_unidade.cd_departamento%TYPE, cd_pessoa_fisica_p atendimento_paciente.cd_pessoa_fisica%TYPE, cd_procedencia_p atendimento_paciente.cd_procedencia%TYPE, cd_setor_atendimento_p atend_paciente_unidade.cd_setor_atendimento%TYPE, cd_tipo_acomodacao_p atend_paciente_unidade.cd_tipo_acomodacao%TYPE, cd_unidade_basica_p atend_paciente_unidade.cd_unidade_basica%TYPE, cd_unidade_compl_p atend_paciente_unidade.cd_unidade_compl%TYPE, dt_entrada_p atendimento_paciente.dt_entrada%TYPE, dt_inicio_vigencia_p atend_categoria_convenio.dt_inicio_vigencia%TYPE, ie_tipo_atendimento_p atendimento_paciente.ie_tipo_atendimento%TYPE, nr_seq_classif_esp_p atendimento_paciente.nr_seq_classif_esp%TYPE, nr_seq_classificacao_p atendimento_paciente.nr_seq_classificacao%TYPE, nr_seq_tipo_admissao_fat_p atendimento_paciente.nr_seq_tipo_admissao_fat%TYPE, nr_seq_tipo_episodio_p episodio_paciente.nr_seq_tipo_episodio%TYPE, nr_seq_episodio_p atendimento_paciente.nr_seq_episodio%TYPE, qt_dias_pagamento_p pessoa_fisica_taxa.qt_dias_pagamento%TYPE ) AS $body$
DECLARE


    nr_atend_acompanhante_w    atendimento_paciente.nr_atendimento%TYPE;
    nr_atend_paciente_w        atendimento_paciente.nr_atendimento%TYPE;
    cd_medico_resp_w           atendimento_paciente.cd_medico_resp%TYPE;
    nr_seq_ep_acompanhante_w   episodio_paciente.nr_sequencia%TYPE;
    cd_estabelecimento_w       episodio_paciente.cd_estabelecimento%TYPE;


BEGIN

    BEGIN

    -- DATA FROM LAST ENCOUNTER
    SELECT
        max(atend.nr_atendimento),
        max(atend.cd_medico_resp)
    INTO STRICT
        nr_atend_paciente_w,
        cd_medico_resp_w
    FROM
        atendimento_paciente atend
    WHERE
        atend.nr_seq_episodio = nr_seq_episodio_p 
    ORDER BY
        atend.dt_entrada DESC LIMIT 1;

    -- CASE
    SELECT
        max(coalesce(cd_estabelecimento,wheb_usuario_pck.get_cd_estabelecimento))
    INTO STRICT
        cd_estabelecimento_w
    FROM
        episodio_paciente
    WHERE
        nr_sequencia = nr_seq_episodio_p
        AND nr_seq_tipo_episodio = nr_seq_tipo_episodio_p;


       -- STATUS,
            nr_seq_ep_acompanhante_w := case_create_new(
                wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_nm_usuario, cd_pessoa_fisica_p, nr_seq_tipo_episodio_p, NULL,    -- SUBTIPO
            NULL, 
            nr_seq_ep_acompanhante_w, cd_estabelecimento_w

    );

    -- ENCOUNTER
    SELECT
        nextval('atendimento_paciente_seq')
        INTO STRICT nr_atend_acompanhante_w
;

    INSERT INTO atendimento_paciente(
        cd_estabelecimento,
        cd_medico_resp,
        cd_pessoa_fisica,
        cd_procedencia,
        dt_atualizacao,
        dt_atualizacao_nrec,
        dt_entrada,
        ie_permite_visita,
        ie_tipo_atendimento,
        nm_usuario,
        nm_usuario_nrec,
        nr_atendimento,
        nr_seq_classif_esp,
        nr_seq_classificacao,
        nr_seq_episodio,
        nr_seq_tipo_admissao_fat
    ) VALUES (
        wheb_usuario_pck.get_cd_estabelecimento,
        cd_medico_resp_w,
        cd_pessoa_fisica_p,
        cd_procedencia_p,
        clock_timestamp(),
        clock_timestamp(),
        dt_entrada_p,
        'S',
        ie_tipo_atendimento_p,
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        nr_atend_acompanhante_w,
        nr_seq_classif_esp_p,
        nr_seq_classificacao_p,
        nr_seq_ep_acompanhante_w,
        nr_seq_tipo_admissao_fat_p
    );

    -- INSURANCE
    INSERT INTO atend_categoria_convenio(
        cd_categoria,
        cd_convenio,
        dt_atualizacao,
        dt_inicio_vigencia,
        nm_usuario,
        nr_atendimento,
        nr_seq_interno
    ) VALUES (
        cd_categoria_p,
        cd_convenio_p,
        clock_timestamp(),
        dt_inicio_vigencia_p,
        wheb_usuario_pck.get_nm_usuario,
        nr_atend_acompanhante_w,
        nextval('atend_categoria_convenio_seq')
    );

    -- DEPARTMENT
    INSERT INTO atend_paciente_unidade(
        cd_departamento,
        cd_setor_atendimento,
        cd_tipo_acomodacao,
        cd_unidade_basica,
        cd_unidade_compl,
        dt_atualizacao,
        dt_entrada_unidade,
        nm_usuario,
        nm_usuario_nrec,
        nr_atendimento,
        nr_seq_interno,
        nr_sequencia
    ) VALUES (
        cd_departamento_p,
        cd_setor_atendimento_p,
        cd_tipo_acomodacao_p,
        cd_unidade_basica_p,
        cd_unidade_compl_p,
        clock_timestamp(),
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        nr_atend_acompanhante_w,
        nextval('atend_paciente_unidade_seq'),
        1
    );

    -- PAYMENT
    INSERT INTO pessoa_fisica_taxa(
        cd_pessoa_fisica,
        dt_atualizacao,
        dt_atualizacao_nrec,
        nm_usuario,
        nm_usuario_nrec,
        nr_atendimento,
        nr_sequencia,
        qt_dias_pagamento
    ) VALUES (
        cd_pessoa_fisica_p,
        clock_timestamp(),
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        nr_atend_acompanhante_w,
        nextval('pessoa_fisica_taxa_seq'),
        qt_dias_pagamento_p
    );

    -- COMPANION
    INSERT INTO atendimento_acompanhante(
        cd_pessoa_fisica,
        dt_acompanhante,
        dt_atualizacao,
        dt_atualizacao_nrec,
        ie_alojamento,
        nm_usuario,
        nm_usuario_nrec,
        nr_acompanhante,
        nr_atendimento

    ) VALUES (
        cd_pessoa_fisica_p,
        dt_entrada_p,
        clock_timestamp(),
        clock_timestamp(),
        'S',
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        '1',
        nr_atend_paciente_w
    );

    -- CASE/COMPANION
    INSERT INTO episodio_acompanhante(
        dt_atualizacao,
        dt_atualizacao_nrec,
        nm_usuario,
        nm_usuario_nrec,
        nr_atend_acompanhante,
        nr_atend_paciente,
        nr_seq_ep_acompanhante,
        nr_seq_ep_paciente,
        nr_sequencia
    ) VALUES (
        clock_timestamp(),
        clock_timestamp(),
        wheb_usuario_pck.get_nm_usuario,
        wheb_usuario_pck.get_nm_usuario,
        nr_atend_acompanhante_w,
        nr_atend_paciente_w,
        nr_seq_ep_acompanhante_w,
        nr_seq_episodio_p,
        nextval('episodio_acompanhante_seq')
    );

    -- BILLING ADRESS
    CALL replicar_end_cob_acompanhante(nr_atend_acompanhante_w, cd_pessoa_fisica_p);

    -- NECESSARIO PARA O DISPARO DE TRIGGERS
    COMMIT;

    END;

    BEGIN

    -- UPDATE UNIDADE_ATENDIMENTO
    UPDATE unidade_atendimento un
    SET
        un.cd_paciente_reserva = cd_pessoa_fisica_p,
        un.dt_entrada_unidade  = NULL,
        un.ie_status_unidade = 'M',
        un.nr_atendimento  = NULL,
        un.nm_usuario_reserva = wheb_usuario_pck.get_nm_usuario,
        un.nr_atendimento_acomp = nr_atend_paciente_w
    WHERE
        un.nr_atendimento = nr_atend_acompanhante_w;

    IF coalesce(wheb_usuario_pck.GET_IE_COMMIT, 'S') = 'S' THEN
        COMMIT;
    END IF;

    END;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_acompanhante ( cd_categoria_p atend_categoria_convenio.cd_categoria%TYPE, cd_convenio_p atend_categoria_convenio.cd_convenio%TYPE, cd_departamento_p atend_paciente_unidade.cd_departamento%TYPE, cd_pessoa_fisica_p atendimento_paciente.cd_pessoa_fisica%TYPE, cd_procedencia_p atendimento_paciente.cd_procedencia%TYPE, cd_setor_atendimento_p atend_paciente_unidade.cd_setor_atendimento%TYPE, cd_tipo_acomodacao_p atend_paciente_unidade.cd_tipo_acomodacao%TYPE, cd_unidade_basica_p atend_paciente_unidade.cd_unidade_basica%TYPE, cd_unidade_compl_p atend_paciente_unidade.cd_unidade_compl%TYPE, dt_entrada_p atendimento_paciente.dt_entrada%TYPE, dt_inicio_vigencia_p atend_categoria_convenio.dt_inicio_vigencia%TYPE, ie_tipo_atendimento_p atendimento_paciente.ie_tipo_atendimento%TYPE, nr_seq_classif_esp_p atendimento_paciente.nr_seq_classif_esp%TYPE, nr_seq_classificacao_p atendimento_paciente.nr_seq_classificacao%TYPE, nr_seq_tipo_admissao_fat_p atendimento_paciente.nr_seq_tipo_admissao_fat%TYPE, nr_seq_tipo_episodio_p episodio_paciente.nr_seq_tipo_episodio%TYPE, nr_seq_episodio_p atendimento_paciente.nr_seq_episodio%TYPE, qt_dias_pagamento_p pessoa_fisica_taxa.qt_dias_pagamento%TYPE ) FROM PUBLIC;
