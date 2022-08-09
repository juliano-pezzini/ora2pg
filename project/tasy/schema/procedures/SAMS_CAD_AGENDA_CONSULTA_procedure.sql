-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sams_cad_agenda_consulta () AS $body$
DECLARE

    registros CURSOR FOR
        SELECT oid AS id,
               sams.*
          FROM sams_solic_agenda sams
         WHERE sams.ie_status = 'I'
            OR coalesce(sams.ie_status::text, '') = '';

     registros_01 registros%ROWTYPE;

    nr_sequencia_w bigint;
    qt_agendamentos_w  bigint;
    cd_pessoa_fisica_medico_w medico.cd_pessoa_fisica%TYPE;
    ie_erro_w          sams_solic_agenda.ie_status%TYPE;
    ds_erro_w          sams_solic_agenda.ds_erro_agendamento%TYPE;
    tipo_agenda_consulta_w sams_solic_agenda.cd_tipo_agenda%TYPE := 3;
    tipo_agenda_exame_w sams_solic_agenda.cd_tipo_agenda%TYPE := 2;


BEGIN
  OPEN registros;
    LOOP
        FETCH registros
            INTO registros_01;
        EXIT WHEN NOT FOUND; /* apply on registros */
        BEGIN

            nr_sequencia_w := NULL;
            qt_agendamentos_w  := NULL;
            cd_pessoa_fisica_medico_w := NULL;
            ie_erro_w := 'N';

            IF registros_01.cd_tipo_agenda = tipo_agenda_consulta_w THEN
                SELECT MAX(a.nr_sequencia)
                    INTO STRICT nr_sequencia_w
                     FROM agenda_consulta a,
                        agenda b
                WHERE a.dt_agenda = registros_01.dt_agenda
                    AND a.ie_status_agenda IN ('L', 'LF')
                    AND a.cd_agenda = b.cd_agenda
                    AND b.cd_agenda_externa = registros_01.cd_agenda_externa;

                IF coalesce(nr_sequencia_w::text, '') = '' THEN
                    ie_erro_w := 'S';
                    ds_erro_w := obter_expressao_dic_objeto(1112604);
                END IF;

                IF ie_erro_w = 'N' THEN
                    SELECT COUNT(*)
                        INTO STRICT qt_agendamentos_w
                        FROM agenda_consulta a
                        WHERE a.dt_agenda = registros_01.dt_agenda
                           AND a.cd_pessoa_fisica = registros_01.cd_pessoa_fisica
                           AND a.ie_status_agenda NOT IN ('C', 'F');

                    IF qt_agendamentos_w > 0 THEN
                        ie_erro_w := 'S';
                        ds_erro_w := obter_expressao_dic_objeto(1112605);
                    END IF;
                END IF;
                IF ie_erro_w = 'N' THEN

                    BEGIN
                        SELECT MAX(cd_pessoa_fisica) 
                            INTO STRICT cd_pessoa_fisica_medico_w 
                            FROM medico
                        WHERE nr_crm = registros_01.nr_crm;

                        UPDATE agenda_consulta a
                           SET a.nm_usuario        = 'SAMS',
                                a.cd_especialidade = coalesce(a.cd_especialidade, obter_conversao_interna_int(NULL, 'AGENDA_CONSULTA', 'CD_ESPECIALIDADE', registros_01.cd_especialidade, 'SAMS')),
                                a.cd_medico_req = coalesce(cd_medico_req, cd_pessoa_fisica_medico_w),
                                a.dt_atualizacao = clock_timestamp(),
                                a.ie_status_agenda  = 'CN',
                                a.cd_pessoa_fisica = registros_01.cd_pessoa_fisica,
                                a.nm_paciente = obter_nome_pf(registros_01.cd_pessoa_fisica)
                         WHERE a.nr_sequencia = nr_sequencia_w;
                    EXCEPTION
                        WHEN OTHERS THEN
                            ie_erro_w := 'S';
                            ds_erro_w := obter_expressao_dic_objeto(1112606) || ' - '  || SQLERRM;
                    END;

                END IF;
                
            ELSIF registros_01.cd_tipo_agenda = tipo_agenda_exame_w THEN
                SELECT MAX(a.nr_sequencia)
                    INTO STRICT nr_sequencia_w
                    FROM agenda_paciente a,
                        agenda b
                WHERE a.hr_inicio = registros_01.dt_agenda
                    AND a.ie_status_agenda IN ('L', 'LF')
                    AND a.cd_agenda = b.cd_agenda
                    AND b.cd_agenda_externa = registros_01.cd_agenda_externa;

                IF coalesce(nr_sequencia_w::text, '') = '' THEN
                    ie_erro_w := 'S';
                    ds_erro_w := obter_expressao_dic_objeto(1112604);
                END IF;

                IF ie_erro_w = 'N' THEN
                    SELECT COUNT(*)
                        INTO STRICT qt_agendamentos_w
                        FROM agenda_paciente a
                        WHERE a.hr_inicio = registros_01.dt_agenda
                           AND a.cd_pessoa_fisica = registros_01.cd_pessoa_fisica
                           AND a.ie_status_agenda NOT IN ('C', 'F');

                    IF qt_agendamentos_w > 0 THEN
                        ie_erro_w := 'S';
                        ds_erro_w := obter_expressao_dic_objeto(1112605);
                    END IF;
                END IF;
                IF ie_erro_w = 'N' THEN

                    BEGIN                    
                        UPDATE agenda_paciente a
                           SET a.nm_usuario        = 'SAMS',
                               a.dt_atualizacao = clock_timestamp(),
                               a.nr_seq_proc_interno = coalesce(a.nr_seq_proc_interno, obter_conversao_interna_int(NULL,'AGENDA_PACIENTE', 'NR_SEQ_PROC_INTERNO', registros_01.cd_procedimento_ext, 'SAMS')),
                               a.ie_status_agenda  = 'CN',
                               a.cd_pessoa_fisica = registros_01.cd_pessoa_fisica,
                               a.nm_paciente = obter_nome_pf(registros_01.cd_pessoa_fisica)
                         WHERE a.nr_sequencia = nr_sequencia_w;
                    EXCEPTION
                        WHEN OTHERS THEN
                            ie_erro_w := 'S';
                            ds_erro_w := obter_expressao_dic_objeto(1112606) || ' - '  || SQLERRM;
                    END;

                END IF;
            END IF;

            IF ie_erro_w = 'S' THEN
                UPDATE sams_solic_agenda
                   SET ie_status           = 'E', 
                       ds_erro_agendamento = ds_erro_w
                 WHERE ROWID = registros_01.id;
            ELSE
                UPDATE sams_solic_agenda
                   SET ie_status           = 'A',
                       ds_erro_agendamento = ''
                 WHERE ROWID = registros_01.id;

            END IF;

            COMMIT;
        END;
    END LOOP;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sams_cad_agenda_consulta () FROM PUBLIC;
