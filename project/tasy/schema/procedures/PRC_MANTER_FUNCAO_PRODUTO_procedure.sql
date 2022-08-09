-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prc_manter_funcao_produto (nr_seq_produto_p bigint, cd_funcao_p bigint, nm_usuario_p text, action_p text) AS $body$
BEGIN

  IF action_p = 'I' THEN

    insert into mkt_prod_core_funcao(
      nr_sequencia,
      dt_atualizacao,
      nm_usuario,
      dt_atualizacao_nrec,
      nm_usuario_nrec,
      nr_seq_produto,
      cd_funcao
    ) values (
      nextval('mkt_prod_core_funcao_seq'),
      clock_timestamp(),
      nm_usuario_p,
      clock_timestamp(),
      nm_usuario_p,
      nr_seq_produto_p,
      cd_funcao_p
      );

  END IF;

  IF action_p = 'D' THEN

    delete from mkt_prod_core_funcao
    where nr_seq_produto = nr_seq_produto_p
    and cd_funcao = cd_funcao_p;
  END IF;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prc_manter_funcao_produto (nr_seq_produto_p bigint, cd_funcao_p bigint, nm_usuario_p text, action_p text) FROM PUBLIC;
