-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION col_gerar_arquivo_rips.obter_endereco_pessoa_fisica ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, ie_informacao_p end_endereco.ie_informacao%TYPE ) RETURNS varchar AS $body$
DECLARE

        nr_seq_catalogo_w	        end_catalogo.nr_sequencia%type;
        nr_seq_pessoa_endereco_w    compl_pessoa_fisica.nr_seq_pessoa_endereco%TYPE;
        cd_endereco_catalogo_w      end_endereco.cd_endereco_catalogo%TYPE;

BEGIN
        SELECT  MAX(nr_seq_pessoa_endereco)
        INTO STRICT    nr_seq_pessoa_endereco_w
        FROM    compl_pessoa_fisica
        WHERE   cd_pessoa_fisica = cd_pessoa_fisica_p
        AND     ie_tipo_complemento = 1;

        IF (nr_seq_pessoa_endereco_w IS NOT NULL AND nr_seq_pessoa_endereco_w::text <> '') THEN
            BEGIN
            SELECT	a.nr_seq_catalogo
            INTO STRICT	nr_seq_catalogo_w
            FROM	end_catalogo b,
                    pessoa_endereco a
            WHERE	a.nr_seq_catalogo = b.nr_sequencia
            AND		a.nr_sequencia	= nr_seq_pessoa_endereco_w;

            EXCEPTION
                WHEN OTHERS THEN
                nr_seq_catalogo_w := NULL;
            END;

            IF	coalesce(nr_seq_catalogo_w::text, '') = '' THEN
                BEGIN
                SELECT	b.nr_seq_catalogo
                INTO STRICT	nr_seq_catalogo_w
                FROM	pessoa_endereco_item a,
                        end_endereco b,
                        end_catalogo c
                WHERE   a.nr_seq_end_endereco = b.nr_sequencia
                AND     b.nr_seq_catalogo = c.nr_sequencia
                AND		a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w  LIMIT 1;
                EXCEPTION
                    WHEN OTHERS THEN
                    nr_seq_catalogo_w := NULL;
                END;
            END IF;

        SELECT  MAX(b.cd_endereco_catalogo)
        INTO STRICT    cd_endereco_catalogo_w
        FROM end_endereco b, pessoa_endereco_item a
LEFT OUTER JOIN config_endereco c ON (a.ie_informacao = c.ie_informacao)
WHERE a.nr_seq_end_endereco = b.nr_sequencia  AND a.nr_seq_pessoa_endereco = nr_seq_pessoa_endereco_w AND b.nr_seq_catalogo = nr_seq_catalogo_w AND a.nr_seq_end_endereco > 0 AND b.ie_informacao = ie_informacao_p;

        END IF;

      RETURN cd_endereco_catalogo_w;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION col_gerar_arquivo_rips.obter_endereco_pessoa_fisica ( cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%TYPE, ie_informacao_p end_endereco.ie_informacao%TYPE ) FROM PUBLIC;
