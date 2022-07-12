-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_imc ( qt_peso_p bigint, qt_altura_p bigint, cd_pessoa_fisica_p text DEFAULT NULL) RETURNS bigint AS $body$
DECLARE


    qt_peso_parte_w  bigint;
    qt_peso_real_w   bigint;
    pr_proporcao_w   varchar(1000);
    qt_peso_w        varchar(1000);
    sql_w            varchar(1000);
    qt_imc_w         double precision;
  i RECORD;

BEGIN
    IF (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') THEN
        FOR i IN (
            SELECT
                pr_proporcao,
                qt_peso_p AS qt_peso
            FROM
                paciente_amputacao  pa,
                tipo_amputacao      ta
            WHERE
                    ta.nr_sequencia = pa.nr_seq_amputacao
                AND cd_pessoa_fisica = cd_pessoa_fisica_p
                AND pa.ie_situacao <> 'I'
                AND ta.ie_situacao <> 'I'
                AND (pa.dt_liberacao IS NOT NULL AND pa.dt_liberacao::text <> '') )
          LOOP
            IF coalesce(pr_proporcao_w::text, '') = '' THEN
                pr_proporcao_w := coalesce(i.pr_proporcao, 0);
            ELSE
                pr_proporcao_w := pr_proporcao_w
                                  || '@'
                                  || coalesce(i.pr_proporcao, 0);
            END IF;

            IF coalesce(qt_peso_w::text, '') = '' THEN
                qt_peso_w := coalesce(i.qt_peso, 0);
            ELSE
                qt_peso_w := qt_peso_w
                             || '@'
                             || coalesce(i.qt_peso, 0);
            END IF;

        END LOOP;

        BEGIN
            sql_w := 'call peso_parte_pck_md.calcular_peso_parte_md(:1, :2, :3) into :qt_peso_parte_w';
            EXECUTE sql_w
                USING IN pr_proporcao_w, IN qt_peso_w, IN '@', OUT qt_peso_parte_w;
        EXCEPTION
            WHEN OTHERS THEN
                qt_peso_parte_w := NULL;
        END;

    END IF;

    qt_peso_real_w := qt_peso_p;

  --- Inicio MD1 verificar se ja nao temos uma rotina
    IF ( coalesce(qt_peso_parte_w, 0) > 0 )
        AND ( coalesce(cd_pessoa_fisica_p::text, '') = '' )
    THEN
        qt_peso_parte_w := 0;
    END IF;

    IF ( coalesce(qt_peso_real_w, 0) > 0 )
        AND ( coalesce(qt_altura_p, 0) > 0 )
    THEN
        BEGIN
            sql_w := 'call obter_valor_imc_md(:1, :2, :3) into :qt_imc_w';
            EXECUTE sql_w
                USING IN qt_peso_real_w, IN qt_peso_parte_w, IN qt_altura_p, OUT qt_imc_w;
        EXCEPTION
            WHEN OTHERS THEN
                qt_imc_w := NULL;
        END;
    ELSE
        RETURN NULL;
    END IF;

    RETURN qt_imc_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_imc ( qt_peso_p bigint, qt_altura_p bigint, cd_pessoa_fisica_p text DEFAULT NULL) FROM PUBLIC;
