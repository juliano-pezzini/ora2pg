-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_pre_pagto_pck.carregar_xml ( ds_arquivo_xml_p text, ie_origem_imp_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_arq_xml_p INOUT ptu_aviso_arq_xml.nr_sequencia%type) AS $body$
BEGIN
if (coalesce(nr_seq_arq_xml_p::text, '') = '') then
  -- Inserir arquivo

  insert  into pls_faturamento_arq(nr_sequencia, dt_atualizacao, nm_usuario,
    dt_atualizacao_nrec, nm_usuario_nrec, ds_xml,
    dt_inicio_importacao, ie_tipo_faturamento)
  values (nextval('pls_faturamento_arq_seq'),  clock_timestamp(),    nm_usuario_p,
      clock_timestamp(), nm_usuario_p, ds_arquivo_xml_p,
      clock_timestamp(), ie_origem_imp_p
    ) returning nr_sequencia into nr_seq_arq_xml_p;

elsif (nr_seq_arq_xml_p IS NOT NULL AND nr_seq_arq_xml_p::text <> '') then
  -- Preencher arquivo XML

  update  pls_faturamento_arq
  set  ds_xml  = ds_xml || ds_arquivo_xml_p
  where  nr_sequencia  = nr_seq_arq_xml_p;
end if;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_pre_pagto_pck.carregar_xml ( ds_arquivo_xml_p text, ie_origem_imp_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_arq_xml_p INOUT ptu_aviso_arq_xml.nr_sequencia%type) FROM PUBLIC;