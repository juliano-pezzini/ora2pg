-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_anexo ( nr_sequencia_p bigint, ds_table_p text) RETURNS varchar AS $body$
DECLARE


ds_anexo_w		varchar(4000);


BEGIN

if ds_table_p = 'PEP_PAC_CI' then
  select ds_arquivo
  into STRICT	ds_anexo_w
    from (
      SELECT ds_arquivo ds_arquivo
        from pep_pac_ci_anexo 
        where nr_seq_pac_ci = nr_sequencia_p
        order by dt_atualizacao_nrec desc
    ) alias0 LIMIT 1;
elsif ds_table_p = 'EVOLUCAO_PACIENTE' then
  select ds_arquivo
  into STRICT	ds_anexo_w
    from (
      SELECT ds_imagem ds_arquivo
        from pep_imagem 
        where nr_seq_item_pront = 5
        and cd_evolucao = nr_sequencia_p
        order by dt_atualizacao_nrec desc
    ) alias0 LIMIT 1;
elsif ds_table_p = 'PARECER_MEDICO_REQ_ANEXO' then
  select ds_arquivo
  into STRICT	ds_anexo_w
    from (
      SELECT ds_arquivo ds_arquivo
        from parecer_medico_req_anexo 
        where nr_seq_par_med_req = nr_sequencia_p
        order by dt_atualizacao_nrec desc
    ) alias0 LIMIT 1;
elsif ds_table_p = 'ATEND_SUMARIO_ALTA' then
  select ds_arquivo
  into STRICT	ds_anexo_w
    from (
      SELECT ds_arquivo ds_arquivo
        from atend_sumario_alta_anexo 
        where nr_seq_atend_sum_alta = nr_sequencia_p
        order by dt_atualizacao_nrec desc
    ) alias0 LIMIT 1;
elsif ds_table_p = 'ATENDIMENTO_ALTA' then
  select ds_arquivo
  into STRICT	ds_anexo_w
    from (
      SELECT ds_arquivo ds_arquivo
        from atendimento_alta_foto 
        where nr_seq_atend_alta = nr_sequencia_p
        order by dt_atualizacao_nrec desc
    ) alias0 LIMIT 1;
end if;

return	ds_anexo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_anexo ( nr_sequencia_p bigint, ds_table_p text) FROM PUBLIC;
