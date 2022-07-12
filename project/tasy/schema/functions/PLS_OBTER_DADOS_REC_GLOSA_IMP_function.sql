-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_rec_glosa_imp ( nr_seq_rec_glosa_glosas_imp_p bigint, nr_seq_motivo_glosa_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p  
  'C' - Codigo da glosa
  'D' - Descricao da glosa

*/
ds_retorno_w  varchar(400);


BEGIN

if (ie_opcao_p  = 'C') then
  if (coalesce(nr_seq_motivo_glosa_p,0) > 0) then
    select  cd_motivo_tiss
    into STRICT  ds_retorno_w
    from  tiss_motivo_glosa
    where  nr_sequencia = nr_seq_motivo_glosa_p;
  else
    select  max(cd_glosa)
    into STRICT  ds_retorno_w
    from  pls_rec_glosa_glosas_imp
    where  nr_sequencia  = nr_seq_rec_glosa_glosas_imp_p;
  end if;
elsif (ie_opcao_p  = 'D') then
  if (coalesce(nr_seq_motivo_glosa_p,0) > 0) then
    select  ds_motivo_tiss
    into STRICT  ds_retorno_w
    from  tiss_motivo_glosa
    where  nr_sequencia = nr_seq_motivo_glosa_p;
  else
    select  max(ds_justificativa)
    into STRICT  ds_retorno_w
    from  pls_rec_glosa_glosas_imp
    where  nr_sequencia  = nr_seq_rec_glosa_glosas_imp_p;
  end if;
end if;

return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_rec_glosa_imp ( nr_seq_rec_glosa_glosas_imp_p bigint, nr_seq_motivo_glosa_p bigint, ie_opcao_p text) FROM PUBLIC;

