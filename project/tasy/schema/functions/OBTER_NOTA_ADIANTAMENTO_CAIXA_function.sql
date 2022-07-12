-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nota_adiantamento_caixa ( nr_seq_caixa_rec_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	nota_fiscal.ds_observacao%type;
nr_sequencia_w  nota_fiscal.nr_sequencia%type;

c01 CURSOR FOR

    SELECT nf.nr_sequencia
    from nota_fiscal nf 
    where nf.nr_seq_adiantamento in (SELECT a.nr_adiantamento from adiantamento a
                                  where a.nr_seq_caixa_rec = nr_seq_caixa_rec_p);


BEGIN
    if (nr_seq_caixa_rec_p IS NOT NULL AND nr_seq_caixa_rec_p::text <> '') then
        open c01;
        loop
        fetch c01 into nr_sequencia_w;
        EXIT WHEN NOT FOUND; /* apply on c01 */
            begin
                if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
                    ds_retorno_w := substr(concat(ds_retorno_w, concat(',', nr_sequencia_w)), 1, 4000);
                else
                    ds_retorno_w := nr_sequencia_w;
                end if;
            end;
        end loop;
        close c01;
    end if;

    return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nota_adiantamento_caixa ( nr_seq_caixa_rec_p bigint) FROM PUBLIC;
