-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_notas_vinculas_card ( nr_sequencia_p nota_fiscal.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


  ds_retorno_w      varchar(100);
  nr_sequencia_w    nota_fiscal.nr_sequencia%type;

  C01 CURSOR FOR
    SELECT  nr_sequencia
    from    nota_fiscal
    where   nr_sequencia_ref = nr_sequencia_p
    
union
   
    SELECT  nr_sequencia_ref 
    from    nota_fiscal
    where   nr_sequencia = nr_sequencia_p
    
union

    select  NR_SEQ_NF_GERADA 
    from    NF_CREDITO 
    where   NR_SEQ_NF_ORIG = nr_sequencia_p
    
union

    select  NR_SEQ_NF_ORIG 
    from    NF_CREDITO 
    where   NR_SEQ_NF_GERADA = nr_sequencia_p
    
union

    select  nr_sequencia
    from    nota_fiscal
    where   (nr_seq_baixa_tit IS NOT NULL AND nr_seq_baixa_tit::text <> '')
    and     nr_sequencia_ref = nr_sequencia_p
    
union
   
    select  nfi.nr_sequencia
    from    nota_fiscal_item nfi
    where   nfi.nr_titulo in (select tr.nr_titulo from titulo_receber tr where tr.nr_seq_nf_saida = nr_sequencia_p)
    and     (nfi.nr_seq_tit_rec IS NOT NULL AND nfi.nr_seq_tit_rec::text <> '');


BEGIN
  open C01;
    loop
      fetch C01 into
        nr_sequencia_w;
        EXIT WHEN NOT FOUND; /* apply on C01 */
        begin
          if (nr_sequencia_w > 0) then
            ds_retorno_w := ds_retorno_w || nr_sequencia_w||'-';
          end if;
        end;
    end loop;
    ds_retorno_w := RTRIM(ds_retorno_w, '-');
  close C01;
  return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_notas_vinculas_card ( nr_sequencia_p nota_fiscal.nr_sequencia%type) FROM PUBLIC;
