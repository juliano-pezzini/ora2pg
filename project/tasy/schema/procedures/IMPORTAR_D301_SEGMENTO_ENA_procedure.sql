-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_d301_segmento_ena ( nr_seq_dataset_p bigint, ds_conteudo_ena_p text, nm_usuario_p text) AS $body$
DECLARE

 ds_conteudo_ena_w  varchar(4000);

BEGIN
   
 if (substr(ds_conteudo_ena_p,1,3) = 'ENA') then 
     
    ds_conteudo_ena_w:=replace(ds_conteudo_ena_p,'''','');
     
    insert into d301_segmento_ena(nr_sequencia, 
      dt_atualizacao, 
      nm_usuario, 
      dt_atualizacao_nrec, 
      nm_usuario_nrec, 
      nr_seq_301_tipo_pag, 
      nr_seq_301_indic_adic_ebm, 
      ds_justif_cobranca, 
      ie_taxa_pacote, 
      ds_dt_tratamento, 
      qt_ponto_ebm, 
      nr_cobranca, 
      vl_ponto_ebm, 
      vl_taxa, 
      nr_seq_dataset, 
      nr_seq_dataset_ret)  
    values (nextval('d301_segmento_ena_seq'), 
        clock_timestamp(), 
        nm_usuario_p, 
        clock_timestamp(), 
        nm_usuario_p, 
        obter_seq_valor_301('C301_4_TIPO_COBRANCA','IE_TIPO',obter_valor_separador(ds_conteudo_ena_w,2,'+')), 
        obter_seq_valor_301('C301_19_INDIC_ADIC_EBM','IE_INDICADOR',obter_valor_separador(ds_conteudo_ena_w,3,'+')), 
        obter_valor_separador(ds_conteudo_ena_w,4,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,5,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,6,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,7,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,8,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,9,'+'), 
        obter_valor_separador(ds_conteudo_ena_w,10,'+'), 
        null, 
        nr_seq_dataset_p);
    commit;
 end if;
     
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_d301_segmento_ena ( nr_seq_dataset_p bigint, ds_conteudo_ena_p text, nm_usuario_p text) FROM PUBLIC;
