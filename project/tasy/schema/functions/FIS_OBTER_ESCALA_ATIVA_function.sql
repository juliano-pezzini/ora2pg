-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_obter_escala_ativa (nr_sequencia_p bigint, ie_option_table_p text) RETURNS varchar AS $body$
DECLARE


ie_situacao_w escala.ie_situacao%TYPE := 'A';
response_w varchar(1) := 'S';


BEGIN
    IF (nr_sequencia_p > 0) THEN
        IF (ie_option_table_p = 'ESCALA') THEN
            BEGIN
                SELECT coalesce(ie_situacao, 'A')
                INTO STRICT ie_situacao_w
                FROM escala
                WHERE nr_sequencia = nr_sequencia_p;
            EXCEPTION WHEN OTHERS THEN
                ie_situacao_w := 'I';
            END;
        END IF;

        IF (ie_option_table_p = 'ESCALA_H') THEN
            BEGIN
                SELECT coalesce(ie_situacao, 'A')
                INTO STRICT ie_situacao_w
                FROM escala_horario
                WHERE nr_sequencia = nr_sequencia_p;
            EXCEPTION WHEN OTHERS THEN
                ie_situacao_w := 'I';
            END;
        END IF;

        IF (ie_situacao_w = 'A') THEN
            response_w := 'S';
        ELSE
            response_w := 'N';
        END IF;
    END IF;

RETURN response_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_obter_escala_ativa (nr_sequencia_p bigint, ie_option_table_p text) FROM PUBLIC;
