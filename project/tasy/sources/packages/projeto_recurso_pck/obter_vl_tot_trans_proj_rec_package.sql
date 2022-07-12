-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

						
						
	--VTR>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obtem o valor total transeferido do projeto <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--		

	/*
	Objetivo: Obter o valor total transferido de entrada e saida para o projeto passado por parametro.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	*/
	


CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_vl_tot_trans_proj_rec ( nr_seq_proj_rec_p bigint) RETURNS bigint AS $body$
BEGIN
	
	return projeto_recurso_pck.obter_vl_trans_proj_rec(nr_seq_proj_rec_p, 'E') - projeto_recurso_pck.obter_vl_trans_proj_rec(nr_seq_proj_rec_p, 'S');
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_vl_tot_trans_proj_rec ( nr_seq_proj_rec_p bigint) FROM PUBLIC;