-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
/* --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

		


CREATE OR REPLACE FUNCTION ptu_moviment_benef_a300_pck.obter_versao_ptu ( nr_seq_lote_p ptu_mov_produto_lote.nr_sequencia%type ) RETURNS varchar AS $body$
DECLARE

	
	cd_versao_ptu_w		ptu_regra_interface.cd_versao_ptu%type;
	cd_unimed_destino_w	ptu_movimentacao_produto.cd_unimed_destino%type;
	
	
BEGIN
	
	select	max(cd_unimed_destino)
	into STRICT	cd_unimed_destino_w
	from	ptu_movimentacao_produto
	where	nr_seq_lote = nr_seq_lote_p;
	
	cd_versao_ptu_w	:= pls_obter_versao_ptu(wheb_usuario_pck.get_cd_estabelecimento, cd_unimed_destino_w, clock_timestamp(), 'A300');
	
	return	cd_versao_ptu_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ptu_moviment_benef_a300_pck.obter_versao_ptu ( nr_seq_lote_p ptu_mov_produto_lote.nr_sequencia%type ) FROM PUBLIC;
