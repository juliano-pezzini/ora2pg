-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_agenda_regiao (cd_Agenda_p bigint, nr_Seq_regiao_p bigint, cd_estabelecimento_p bigint DEFAULT NULL, ie_limitrofes_p text DEFAULT 'N') RETURNS varchar AS $body$
DECLARE


    ds_retorno_w         varchar(1) := 'S';
    cd_estabelecimento_w estabelecimento.cd_estabelecimento%TYPE;
    cd_cep_w             pessoa_juridica.cd_cep%TYPE;


BEGIN
    IF (nr_seq_regiao_p IS NOT NULL AND nr_seq_regiao_p::text <> '') THEN
        IF (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') THEN
            SELECT MAX(a.cd_estabelecimento),
                   MAX(c.cd_cep)
              INTO STRICT cd_estabelecimento_w,
                   cd_cep_w
              FROM agenda          a,
                   estabelecimento b,
                   pessoa_juridica c
             WHERE a.cd_estabelecimento = b.cd_estabelecimento
               AND b.cd_cgc = c.cd_cgc
               AND a.cd_agenda = cd_agenda_p;

        ELSIF (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') THEN
            SELECT cd_estabelecimento_p,
                   MAX(c.cd_cep)
              INTO STRICT cd_estabelecimento_w,
                   cd_cep_w
              FROM estabelecimento b,
                   pessoa_juridica c
             WHERE b.cd_estabelecimento = cd_estabelecimento_p
               AND b.cd_cgc = c.cd_cgc;
        END IF;

        cd_cep_w := regexp_replace(cd_cep_w, '[^0-9]', '');

        SELECT CASE WHEN COUNT(*)=1 THEN  'S'  ELSE 'N' END
          INTO STRICT ds_retorno_w
          FROM wsuite_grupo_loc_estab
         WHERE nr_grupo_local = nr_seq_regiao_p
           AND coalesce(cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
           AND coalesce(cd_cep, cd_cep_w) = cd_cep_w
           AND (coalesce(cd_faixa_cep_inicial::text, '') = '' OR
               cd_cep_w BETWEEN coalesce(cd_faixa_cep_inicial, cd_cep_w) AND coalesce(cd_faixa_cep_final, cd_cep_w));

        IF ds_retorno_w = 'N' AND
           ie_limitrofes_p = 'S' THEN
            SELECT CASE WHEN COUNT(*)=0 THEN  'N'  ELSE 'S' END
              INTO STRICT ds_retorno_w
              FROM wsuite_grupo_loc_estab     gle,
                   wsuite_grupo_loc_limitrofe gll
             WHERE gll.nr_seq_grupo_loc  = nr_seq_regiao_p
               AND gll.nr_seq_loc_limit= gle.nr_grupo_local

               AND coalesce(gle.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
               AND coalesce(gle.cd_cep, cd_cep_w) = cd_cep_w
               AND (coalesce(gle.cd_faixa_cep_inicial::text, '') = '' OR
                   cd_cep_w BETWEEN coalesce(gle.cd_faixa_cep_inicial, cd_cep_w) AND coalesce(gle.cd_faixa_cep_final, cd_cep_w));

        END IF;
    END IF;

    RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_agenda_regiao (cd_Agenda_p bigint, nr_Seq_regiao_p bigint, cd_estabelecimento_p bigint DEFAULT NULL, ie_limitrofes_p text DEFAULT 'N') FROM PUBLIC;
