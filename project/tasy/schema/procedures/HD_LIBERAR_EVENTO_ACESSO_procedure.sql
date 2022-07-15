-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_liberar_evento_acesso (nr_seq_p bigint) AS $body$
DECLARE

    nr_seq_evento_w         bigint;
    nr_seq_acesso_w         bigint;
    nr_seq_proc_interno_w   bigint;
    cd_pessoa_fisica_w      varchar(255);
    estabelecimento_ativo_w bigint;
    nr_ultimo_atendimento_w bigint;
    dt_ent_unidade_w        timestamp;
    nr_seq_proc_pac_w       bigint;
    ds_erro_w               varchar(255);
    usuario_ativo_w         varchar(255);
    cd_setor_atendimento_w  bigint;
    nr_seq_atepacu_w        bigint;
    cd_convenio_w           bigint;
    cd_categoria_w          varchar(255);
    ie_tipo_atendimento_w   bigint;
    nr_seq_classificacao_w  bigint;
    cd_procedimento_w       bigint;
    ie_origem_proced_w      bigint;
    cd_profissional_w       varchar(255);
    ie_medico_executor_w    varchar(255);
    cd_cgc_prest_regra_w    varchar(255);
    cd_medico_executor_w    varchar(255);
    cd_pes_fis_regra_w      varchar(255);
    cd_medico_exec_w        varchar(255);
    cd_medico_laudo_sus_w   varchar(255);
    cd_local_estoque_w      bigint;

BEGIN

    -- select * from hd_evento_acesso_pac where nr_SEQUENCIA = 51

    -- select * from hd_evento_acesso

    -- select * from hd_acesso  
    usuario_ativo_w := obter_usuario_ativo;
    --usuario_ativo_w := 'gmllessa';
    estabelecimento_ativo_w := obter_estabelecimento_ativo;
    --estabelecimento_ativo_w := 1;
    SELECT max(nr_seq_evento),
           max(nr_seq_acesso)
      INTO STRICT nr_seq_evento_w,
           nr_seq_acesso_w
      FROM hd_evento_acesso_pac
     WHERE nr_sequencia = nr_seq_p;

    BEGIN
        SELECT nr_seq_proc_interno
          INTO STRICT nr_seq_proc_interno_w
          FROM hd_evento_acesso
         WHERE nr_sequencia = nr_seq_evento_w;
    EXCEPTION
        WHEN no_data_found THEN
            nr_seq_proc_interno_w := NULL;
    END;

    IF (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') THEN
        BEGIN
            SELECT max(cd_pessoa_fisica) INTO STRICT cd_pessoa_fisica_w FROM hd_acesso WHERE nr_sequencia = nr_seq_acesso_w;

            nr_ultimo_atendimento_w := hd_obter_ultimo_atend_pac(cd_pessoa_fisica_w, estabelecimento_ativo_w);

            IF ((nr_ultimo_atendimento_w = '0') OR (coalesce(nr_ultimo_atendimento_w::text, '') = '')) THEN
                BEGIN
                    -- ds_erro_w          := wheb_mensagem_pck.get_texto(793796)||chr(13);
                    CALL wheb_mensagem_pck.exibir_mensagem_abort(191445);
                END;

            ELSE
                BEGIN
                
                    cd_setor_atendimento_w := wheb_usuario_pck.get_cd_setor_atendimento;
                    --cd_setor_atendimento_w := 157;
                    SELECT MAX(dt_entrada_unidade),
                           MAX(nr_seq_interno)
                      INTO STRICT dt_ent_unidade_w,
                           nr_seq_atepacu_w
                      FROM atend_paciente_unidade
                     WHERE nr_atendimento = nr_ultimo_atendimento_w
                       AND cd_setor_atendimento = cd_setor_atendimento_w;

                    IF (coalesce(nr_seq_atepacu_w, 0) = 0) THEN
                        CALL gerar_passagem_setor_atend(nr_ultimo_atendimento_w,
                                                   cd_setor_atendimento_w,
                                                   clock_timestamp(),
                                                   'S',
                                                   usuario_ativo_w);

                        SELECT MAX(dt_entrada_unidade),
                               MAX(nr_seq_interno)
                          INTO STRICT dt_ent_unidade_w,
                               nr_seq_atepacu_w
                          FROM atend_paciente_unidade
                         WHERE nr_atendimento = nr_ultimo_atendimento_w
                           AND cd_setor_atendimento = cd_setor_atendimento_w;
                    END IF;

                    SELECT MAX(obter_convenio_atendimento(nr_atendimento)),
                           MAX(obter_dados_categ_conv(nr_atendimento, 'CA')),
                           MAX(ie_tipo_atendimento),
                           MAX(nr_seq_classificacao)
                      INTO STRICT cd_convenio_w,
                           cd_categoria_w,
                           ie_tipo_atendimento_w,
                           nr_seq_classificacao_w
                      FROM atendimento_paciente
                     WHERE nr_atendimento = nr_ultimo_atendimento_w;

                    SELECT * FROM obter_proc_tab_interno_conv(nr_seq_proc_interno_w, estabelecimento_ativo_w, cd_convenio_w, cd_categoria_w, NULL, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, NULL, clock_timestamp(), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL) INTO STRICT cd_procedimento_w, ie_origem_proced_w;

                    SELECT MAX(cd_pessoa_fisica)
                      INTO STRICT cd_profissional_w
                      FROM usuario
                     WHERE nm_usuario = usuario_ativo_w;

                    SELECT * FROM consiste_medico_executor(estabelecimento_ativo_w, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, NULL, nr_seq_proc_interno_w, ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w, NULL, clock_timestamp(), nr_seq_classificacao_w, 'N', NULL, NULL) INTO STRICT ie_medico_executor_w, cd_cgc_prest_regra_w, cd_medico_executor_w, cd_pes_fis_regra_w;
                    IF (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') AND (coalesce(cd_medico_exec_w::text, '') = '') THEN
                        cd_medico_exec_w := cd_medico_executor_w;
                    END IF;

                    IF (coalesce(cd_medico_executor_w::text, '') = '') AND (ie_medico_executor_w = 'N') THEN
                        cd_medico_exec_w := NULL;
                    END IF;

                    IF (ie_medico_executor_w = 'S') THEN
                        SELECT MAX(cd_medico_requisitante)
                          INTO STRICT cd_medico_laudo_sus_w
                          FROM sus_laudo_paciente
                         WHERE nr_atendimento = nr_ultimo_atendimento_w
                           AND cd_procedimento_solic = cd_procedimento_w
                           AND ie_origem_proced = ie_origem_proced_w;

                        cd_medico_exec_w := coalesce(cd_medico_laudo_sus_w, cd_medico_exec_w);
                    END IF;

                    IF (ie_medico_executor_w = 'M') THEN
                        BEGIN
                            cd_medico_laudo_sus_w := sus_obter_dados_sismama_atend(nr_ultimo_atendimento_w, 'M', 'CMR');
                            cd_medico_exec_w      := coalesce(cd_medico_laudo_sus_w, cd_medico_exec_w);
                        END;
                    END IF;

                    IF (ie_medico_executor_w = 'A') AND (coalesce(cd_medico_exec_w::text, '') = '') THEN
                        SELECT MAX(cd_medico_resp)
                          INTO STRICT cd_medico_exec_w
                          FROM atendimento_paciente
                         WHERE nr_atendimento = nr_ultimo_atendimento_w;
                    END IF;

                    IF (ie_medico_executor_w = 'F') AND (cd_medico_executor_w IS NOT NULL AND cd_medico_executor_w::text <> '') THEN
                        cd_medico_exec_w := cd_medico_executor_w;
                    END IF;

                    IF (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') OR (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') AND (ie_medico_executor_w = 'Y') THEN
                        cd_pes_fis_regra_w := NULL;
                        cd_profissional_w  := NULL;
                    END IF;

                    IF (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') OR (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') AND (ie_medico_executor_w = 'Y') THEN
                        cd_pes_fis_regra_w := NULL;
                        cd_profissional_w  := NULL;
                    END IF;

					select nextval('procedimento_paciente_seq')
					into STRICT nr_seq_proc_pac_w
					;
                    INSERT INTO procedimento_paciente(nr_sequencia,
                         nr_atendimento,
                         dt_entrada_unidade,
                         cd_procedimento,
                         dt_procedimento,
                         qt_procedimento,
                         dt_atualizacao,
                         nm_usuario,
                         cd_setor_atendimento,
                         ie_origem_proced,
                         nr_seq_atepacu,
                         nr_seq_proc_interno,
                         cd_convenio,
                         cd_categoria,
                         cd_pessoa_fisica,
                         cd_medico_executor,
                         cd_cgc_prestador)
                    VALUES (nr_seq_proc_pac_w,
                         nr_ultimo_atendimento_w,
                         dt_ent_unidade_w,
                         cd_procedimento_w,
                         clock_timestamp(),
                         1,
                         clock_timestamp(),
                         usuario_ativo_w,
                         cd_setor_atendimento_w,
                         ie_origem_proced_w,
                         nr_seq_atepacu_w,
                         nr_seq_proc_interno_w,
                         cd_convenio_w,
                         cd_categoria_w,
                         coalesce(cd_profissional_w, cd_pes_fis_regra_w),
                         cd_medico_exec_w,
                         cd_cgc_prest_regra_w);

                    SELECT MAX(cd_local_estoque)
                      INTO STRICT cd_local_estoque_w
                      FROM setor_atendimento
                     WHERE cd_setor_atendimento = cd_setor_atendimento_w;

                    ds_erro_w := consiste_exec_procedimento(nr_seq_proc_pac_w, ds_erro_w);
                    CALL atualiza_preco_procedimento(nr_seq_proc_pac_w, cd_convenio_w, usuario_ativo_w);
                    CALL gerar_lancamento_automatico(nr_ultimo_atendimento_w,
                                                cd_local_estoque_w,
                                                34,
                                                usuario_ativo_w,
                                                nr_seq_proc_pac_w,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL,
                                                NULL);

                END;
            END IF;

        END;
    END IF;

    UPDATE hd_evento_acesso_pac
       SET dt_liberacao   = clock_timestamp(),
           nm_usuario_lib = usuario_ativo_w,
           nr_seq_propaci = nr_seq_proc_pac_w
     WHERE nr_sequencia = nr_seq_p;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_liberar_evento_acesso (nr_seq_p bigint) FROM PUBLIC;

