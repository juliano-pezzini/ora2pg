-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_status_ocupacao (cd_pessoa_fisica_p text, dt_agenda_p timestamp, nr_seq_dialise_p bigint) RETURNS varchar AS $body$
DECLARE

    ie_retorno    varchar(1) := '';
    dt_chegada_w  timestamp;
    ie_pac_faltou varchar(1);
    ie_status_w   varchar(10);
    dt_dialise_w  timestamp;

BEGIN
    IF (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') THEN
        BEGIN
            SELECT ie_pac_faltou,
                   dt_chegada
              INTO STRICT ie_pac_faltou,
                   dt_chegada_w
              FROM (SELECT ie_pac_faltou,
                           dt_chegada
                      FROM hd_prc_chegada
                     WHERE cd_pessoa_fisica = cd_pessoa_fisica_p
                       AND trunc(dt_chegada) = trunc(dt_agenda_p)
                     ORDER BY dt_chegada DESC) alias3 LIMIT 1;
        EXCEPTION
            WHEN OTHERS THEN
                ie_pac_faltou := NULL;
                dt_chegada_w  := NULL;
        END;

        SELECT MAX(CASE
                       WHEN (hd.dt_cancelamento IS NOT NULL AND hd.dt_cancelamento::text <> '') THEN
                        'E' -- Hemodialise Cancelada
                       WHEN (hd.dt_inicio_dialise IS NOT NULL AND hd.dt_inicio_dialise::text <> '') AND
                            coalesce(hd.dt_fim_dialise::text, '') = '' THEN
                        'F' -- Em Hemodialise 
                       WHEN (hd.dt_fim_dialise IS NOT NULL AND hd.dt_fim_dialise::text <> '') THEN
                        'D' -- Hemodialise Finalizada 
                       ELSE
                        'G' -- Hemodialise Gerada 
                   END)
          INTO STRICT ie_retorno
          FROM hd_dialise hd
         WHERE cd_pessoa_fisica = cd_pessoa_fisica_p
           AND (trunc(hd.dt_dialise) = dt_agenda_p OR hd.nr_sequencia = nr_seq_dialise_p);

        IF coalesce(ie_retorno::text, '') = '' THEN
            IF ie_pac_faltou = 'S' OR (dt_agenda_p < trunc(clock_timestamp()) AND coalesce(dt_chegada_w::text, '') = '') THEN
                ie_retorno := 'C'; -- Paciente Faltou
            ELSIF (dt_chegada_w IS NOT NULL AND dt_chegada_w::text <> '') THEN
                ie_retorno := 'A'; -- Paciente Chegou
            ELSE

                SELECT MAX(ie_status)
                  INTO STRICT ie_status_w
                  FROM hd_status_recepcao
                 WHERE cd_pessoa_fisica = cd_pessoa_fisica_p
                   AND ie_situacao = 'A'
                   AND trunc(dt_status) = trunc(dt_agenda_p);
                IF ie_status_w = 'CO' THEN
                    ie_retorno := 'H'; -- Paciente Confirmado
                ELSE
                    ie_retorno := 'B'; -- Paciente Não Chegou
                END IF;

            END IF;
        END IF;
    END IF;
    RETURN ie_retorno;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_status_ocupacao (cd_pessoa_fisica_p text, dt_agenda_p timestamp, nr_seq_dialise_p bigint) FROM PUBLIC;
