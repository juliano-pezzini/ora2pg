-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_farmacia_pck.gerar_contas_e_materiais ( ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


cd_carteirinha_w    pls_segurado_carteira.cd_usuario_plano%type;
nr_seq_conta_gerada_w  pls_conta.nr_sequencia%type;



BEGIN

  cd_carteirinha_w :=  substr(ds_conteudo_p, 2, 9);

  select max(nr_sequencia)
  into STRICT  nr_seq_conta_gerada_w
  from  pls_conta
  where  nr_seq_protocolo = current_setting('pls_imp_farmacia_pck.nr_seq_protocolo_w')::pls_protocolo_conta.nr_sequencia%type
  and   substr(pls_obter_dados_segurado(nr_seq_segurado,'CR'),1,9)   = cd_carteirinha_w;

  if (coalesce(nr_seq_conta_gerada_w::text, '') = '') then

    nr_seq_conta_gerada_w := pls_imp_farmacia_pck.inserir_conta(  ds_conteudo_p, nm_usuario_p, cd_estabelecimento_p, nr_seq_conta_gerada_w);

  end if;

  CALL pls_imp_farmacia_pck.inserir_item( nr_seq_conta_gerada_w, ds_conteudo_p, nm_usuario_p, cd_estabelecimento_p);

null;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_farmacia_pck.gerar_contas_e_materiais ( ds_conteudo_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;