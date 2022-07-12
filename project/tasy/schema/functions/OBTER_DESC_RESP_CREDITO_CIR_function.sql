-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_resp_credito_cir ( nr_cirurgia_p cirurgia.nr_cirurgia%TYPE, nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w   varchar(80);
    ie_funcao_w    varchar(1);

BEGIN
    SELECT  coalesce(MAX(ie_funcao), 'C')
    INTO STRICT    ie_funcao_w
    FROM (
            SELECT  MAX('A') ie_funcao
            FROM    anestesia_descricao
            WHERE   nr_cirurgia = nr_cirurgia_p
            AND     nr_sequencia = nr_sequencia_p

UNION

            SELECT  MAX('C') ie_funcao
            FROM    cirurgia_descricao
            WHERE   nr_cirurgia = nr_cirurgia_p
            AND     nr_sequencia = nr_sequencia_p
        ) alias4;

    IF ( (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') AND ie_funcao_w = 'A' ) THEN
        SELECT  substr(MAX(ds_regra), 1, 80)
        INTO STRICT    ds_retorno_w
        FROM    regra_honorario    a,
                resp_credito_cir   b
        WHERE   a.cd_regra = b.ie_responsavel_credito
        AND     b.nr_cirurgia = nr_cirurgia_p
        AND     coalesce(b.ie_funcao, 'C') = 'A';

    ELSIF (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') THEN
        SELECT  substr(MAX(ds_regra), 1, 80)
        INTO STRICT ds_retorno_w
        FROM    regra_honorario    a,
                resp_credito_cir   b
        WHERE   a.cd_regra = b.ie_responsavel_credito
        AND     b.nr_cirurgia = nr_cirurgia_p
        AND     coalesce(b.ie_funcao, 'C') <> 'A';

    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_resp_credito_cir ( nr_cirurgia_p cirurgia.nr_cirurgia%TYPE, nr_sequencia_p bigint ) FROM PUBLIC;

