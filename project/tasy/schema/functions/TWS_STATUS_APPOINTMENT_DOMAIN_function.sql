-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tws_status_appointment_domain ( nr_sequence_p bigint, ie_type_p text) RETURNS bigint AS $body$
DECLARE

  /* Objeto documentado novamente pois nao gerou historico nem parametros,  usuario original kimran
  ie_type_p:
  EX - Exams - agenda_paciente
  CO - Consultation - agenda_consulta
  SE - Services - agenda_consulta
  CH - Chemoteraphy - agenda_quimio
  SU - Surgery - agenda_paciente
  */

  /*
  -- Dominio status, codigo 8452

  10 - Done
  15 - Canceled
  20 - Lost
  25 - Waiting for insurance approved
  30 - Not approved by insurance
  35 - Confirmed by client
  40 - Done
  */
  ie_status_w                varchar(2);
  ds_retorno_w               bigint;
  qt_registros_confirmacao_w smallint;

BEGIN
  IF (ie_type_p = 'EX') OR (ie_type_p = 'SU') THEN
    SELECT MAX(ie_status_agenda)
    INTO STRICT ie_status_w
    FROM agenda_paciente
    WHERE nr_sequencia = nr_sequence_p;
  elsif (ie_type_p     = 'CH') THEN
    SELECT MAX(ie_status_agenda)
    INTO STRICT ie_status_w
    FROM agenda_quimio
    WHERE nr_sequencia = nr_sequence_p;
  elsif (ie_type_p     = 'CO') OR (ie_type_p = 'SE') THEN
    SELECT MAX(ie_status_agenda)
    INTO STRICT ie_status_w
    FROM agenda_consulta
    WHERE nr_sequencia = nr_sequence_p;
  END IF;
IF (ie_status_w = 'E') OR (ie_status_w = 'AD') OR (ie_status_w = 'CR') THEN
  --Done
  ds_retorno_w    := 10;
elsif (ie_status_w = 'C') OR (ie_status_w = 'S') THEN
  --Canceled
  ds_retorno_w    := 15;
elsif (ie_status_w = 'F') OR (ie_status_w = 'I') THEN
  --Lost
  ds_retorno_w := 20;
ELSE
  BEGIN
    IF (ie_type_p = 'EX') OR (ie_type_p = 'SU') THEN
      SELECT COUNT(1)
      INTO STRICT qt_registros_confirmacao_w
      FROM agenda_paciente
      WHERE nr_sequencia = nr_sequence_p
		and clock_timestamp()  > hr_inicio;
     -- AND sysdate > to_Date(pkg_date_formaters.To_varchar(hr_inicio, 'short', pkg_date_formaters.Getuserlanguagetag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario), NULL),'dd/mm/yyyy hh24:mi');
    elsif (ie_type_p     = 'CH') THEN
      SELECT COUNT(1)
      INTO STRICT qt_registros_confirmacao_w
      FROM agenda_quimio
      WHERE nr_sequencia = nr_sequence_p
      --AND sysdate        > dt_agenda; modified as part of missing value mismatch--
      AND clock_timestamp() > to_Date(pkg_date_formaters.To_varchar(dt_agenda, 'short', pkg_date_formaters.Getuserlanguagetag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario), NULL),'dd/mm/yyyy hh24:mi');
    elsif (ie_type_p     = 'CO') OR (ie_type_p = 'SE') THEN
      SELECT COUNT(1)
      INTO STRICT qt_registros_confirmacao_w
      FROM agenda_consulta
      WHERE nr_sequencia = nr_sequence_p
      AND clock_timestamp()        > dt_agenda;
      --AND sysdate > to_Date(pkg_date_formaters.To_varchar(dt_agenda, 'short', pkg_date_formaters.Getuserlanguagetag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario), NULL),'dd/mm/yyyy hh24:mi');
    END IF;
    IF (qt_registros_confirmacao_w > 0) THEN
      --Lost
      ds_retorno_w := 20;
    ELSE
      BEGIN
        qt_registros_confirmacao_w := 0;
        IF (ie_type_p               = 'EX') OR (ie_type_p = 'SU') THEN
          SELECT COUNT(1)
          INTO STRICT qt_registros_confirmacao_w
          FROM agenda_paciente
          WHERE nr_sequencia  = nr_sequence_p
          AND ie_autorizacao IN ('PA', 'PZ', 'P', 'PN');
        elsif (ie_type_p      = 'CH') THEN
          SELECT COUNT(1)
          INTO STRICT qt_registros_confirmacao_w
          FROM agenda_quimio a,
            paciente_atendimento b
          WHERE a.nr_seq_atendimento                                                            = b.nr_seq_atendimento
          AND a.nr_sequencia                                                                    = nr_sequence_p
          AND obter_autorizacao_quimio(b.nr_seq_atendimento, b.nr_ciclo, b.ds_dia_ciclo, 'NR') IN ('1', '5');
        elsif (ie_type_p                                                                        = 'CO') OR (ie_type_p = 'SE') THEN
          SELECT COUNT(1)
          INTO STRICT qt_registros_confirmacao_w
          FROM agenda_consulta
          WHERE nr_sequencia  = nr_sequence_p
          AND ie_autorizacao IN ('PA', 'PZ', 'P', 'PN');
        END IF;
        IF (qt_registros_confirmacao_w > 0) THEN
          --Waiting for insurance approved
          ds_retorno_w := 25;
        ELSE
          BEGIN
            qt_registros_confirmacao_w := 0;
            IF (ie_type_p               = 'EX') OR (ie_type_p = 'SU') THEN
              SELECT COUNT(1)
              INTO STRICT qt_registros_confirmacao_w
              FROM agenda_paciente
              WHERE nr_sequencia = nr_sequence_p
              AND ie_autorizacao = 'N';
            elsif (ie_type_p     = 'CH') THEN
              SELECT COUNT(1)
              INTO STRICT qt_registros_confirmacao_w
              FROM agenda_quimio a,
                paciente_atendimento b
              WHERE a.nr_seq_atendimento                                                           = b.nr_seq_atendimento
              AND a.nr_sequencia                                                                   = nr_sequence_p
              AND obter_autorizacao_quimio(b.nr_seq_atendimento, b.nr_ciclo, b.ds_dia_ciclo, 'NR') = '90';
            elsif (ie_type_p                                                                       = 'CO') OR (ie_type_p = 'SE') THEN
              SELECT COUNT(1)
              INTO STRICT qt_registros_confirmacao_w
              FROM agenda_consulta
              WHERE nr_sequencia = nr_sequence_p
              AND ie_autorizacao = 'N';
            END IF;
            IF (qt_registros_confirmacao_w > 0) THEN
              --Not approved by insurance
              ds_retorno_w := 30;
            ELSE
              BEGIN
                qt_registros_confirmacao_w := 0;
                IF (ie_type_p               = 'EX') OR (ie_type_p = 'SU') THEN
                  SELECT COUNT(1)
                  INTO STRICT qt_registros_confirmacao_w
                  FROM agenda_paciente
                  WHERE nr_sequencia  = nr_sequence_p
                  AND (dt_confirmacao IS NOT NULL AND dt_confirmacao::text <> '');
                elsif (ie_type_p      = 'CH') THEN
                  SELECT COUNT(1)
                  INTO STRICT qt_registros_confirmacao_w
                  FROM agenda_quimio
                  WHERE nr_sequencia  = nr_sequence_p
                  AND (dt_confirmacao IS NOT NULL AND dt_confirmacao::text <> '');
                elsif (ie_type_p      = 'CO') OR (ie_type_p = 'SE') THEN
                  SELECT COUNT(1)
                  INTO STRICT qt_registros_confirmacao_w
                  FROM agenda_consulta
                  WHERE nr_sequencia  = nr_sequence_p
                  AND (dt_confirmacao IS NOT NULL AND dt_confirmacao::text <> '');
                END IF;
                IF (qt_registros_confirmacao_w > 0) THEN
                  --Confirmed by patient
                  ds_retorno_w := 35;
                ELSE
                  BEGIN
                    qt_registros_confirmacao_w := 0;
                    IF (ie_type_p               = 'EX') OR (ie_type_p = 'SU') THEN
                      SELECT COUNT(1)
                      INTO STRICT qt_registros_confirmacao_w
                      FROM agenda_paciente
                      WHERE nr_sequencia  = nr_sequence_p
                      AND coalesce(dt_confirmacao::text, '') = '';
                    elsif (ie_type_p      = 'CH') THEN
                      SELECT COUNT(1)
                      INTO STRICT qt_registros_confirmacao_w
                      FROM agenda_quimio
                      WHERE nr_sequencia  = nr_sequence_p
                      AND coalesce(dt_confirmacao::text, '') = '';
                    elsif (ie_type_p      = 'CO') OR (ie_type_p = 'SE') THEN
                      SELECT COUNT(1)
                      INTO STRICT qt_registros_confirmacao_w
                      FROM agenda_consulta
                      WHERE nr_sequencia  = nr_sequence_p
                      AND coalesce(dt_confirmacao::text, '') = '';
                    END IF;
                    IF (qt_registros_confirmacao_w > 0) THEN
                      --Approved
                      ds_retorno_w := 40;
                    END IF;
                  END;
                END IF;
              END;
            END IF;
          END;
        END IF;
      END;
    END IF;
  END;
END IF;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tws_status_appointment_domain ( nr_sequence_p bigint, ie_type_p text) FROM PUBLIC;

