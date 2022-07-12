-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	--VS>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter valor total de saldo de subprojetos no projeto recurso <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	/*
	Objetivo: Retornar o valor de saldo restante nos subprojetos do projeto recurso passado por parametro.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	*/



CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_vls_saldo_sub_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

	
	/* Valor de saldo do projeto recurso */
		
	vl_saldo_proj_rec_w		projeto_recurso_saldo.vl_saldo%type;

			
	
BEGIN
	
	vl_saldo_proj_rec_w := 0;
	
	select  coalesce(sum(projeto_recurso_pck.obter_vl_saldo_proj_rec(nr_sequencia, nm_usuario_p, cd_estabelecimento_p)),0)
	into STRICT	vl_saldo_proj_rec_w
	from  	projeto_recurso
	where 	nr_seq_superior = nr_seq_proj_rec_p
	and     (dt_aprovacao IS NOT NULL AND dt_aprovacao::text <> '');
		
	return vl_saldo_proj_rec_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_vls_saldo_sub_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
