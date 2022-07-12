-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_pck.get_num_identificacao (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

    ds_retorno_w      varchar(255);

BEGIN
    begin
      select (case
              when f.nr_seq_tipo_doc_identificacao = 'RC' then d.nr_cert_nasc
              when f.nr_seq_tipo_doc_identificacao = 'TI' then d.nr_ric
              when f.nr_seq_tipo_doc_identificacao = 'CC' then d.nr_identidade
              when f.nr_seq_tipo_doc_identificacao = 'CE' then d.nr_cartao_estrangeiro
              when f.nr_seq_tipo_doc_identificacao = 'PA' then d.nr_passaporte
              when f.nr_seq_tipo_doc_identificacao = 'MS' then f.nr_menor_sem_identificacao
              when f.nr_seq_tipo_doc_identificacao = 'CD' then f.nr_cartao_diplomatico
              when f.nr_seq_tipo_doc_identificacao = 'SC' then f.nr_salvo_conduto
              when f.nr_seq_tipo_doc_identificacao = 'PE' then d.nr_reg_geral_estrang
              when f.nr_seq_tipo_doc_identificacao = 'AS' then f.nr_adulto_sem_identificacao end) identidade
      into STRICT    ds_retorno_w
      from    pessoa_fisica d,
              pessoa_fisica_aux f
      where   d.cd_pessoa_fisica = f.cd_pessoa_fisica
      and     f.cd_pessoa_fisica = cd_pessoa_fisica_p;
    exception
      when others then
        ds_retorno_w := '';
    end;

    return elimina_caracteres_especiais(ds_retorno_w);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_pck.get_num_identificacao (cd_pessoa_fisica_p text) FROM PUBLIC;