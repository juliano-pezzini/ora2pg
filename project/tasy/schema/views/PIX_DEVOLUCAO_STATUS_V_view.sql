-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pix_devolucao_status_v (ie_status_devolucao, ds_cor, ds_descricao, ordem) AS select trim(both ie_status_devolucao), ds_cor, ds_descricao,
   case ie_status_devolucao
   when 'NAO_REGISTRADA' then '0'
   when 'EM_PROCESSAMENTO' then '1'
   when 'DEVOLVIDO' then '2'
   when 'NAO_REALIZADO' then '3'    
   end ordem
FROM (
select distinct 
       ie_status_devolucao,
       case ie_status_devolucao
           when 'EM_PROCESSAMENTO' then '#E3A600'
           when 'DEVOLVIDO' then '#00BA2F' 
           when 'NAO_REALIZADO' then '#DA2935'   
           else '#9E9E9E' 
       end ds_cor,
       case ie_status_devolucao
           when 'EM_PROCESSAMENTO' then 'Em Processamento'
           when 'DEVOLVIDO' then 'Devolvida' 
           when 'NAO_REALIZADO' then obter_desc_expressao(1062390) 
           else obter_desc_expressao(1062390) 
       end ds_descricao
from pix_devolucao a) alias3
order by ordem;

