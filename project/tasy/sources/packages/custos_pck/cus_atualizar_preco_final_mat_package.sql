-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE custos_pck.cus_atualizar_preco_final_mat ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) AS $body$
BEGIN

update  preco_padrao_mat
set     vl_preco_tabela     = vl_preco_calculado
where   nr_seq_tabela       = nr_seq_tabela_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE custos_pck.cus_atualizar_preco_final_mat ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, nr_seq_tabela_p bigint, nm_usuario_p text) FROM PUBLIC;
