-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter valor total do titulo a pagar <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Retornar o valor total do titulo a pagar.
	Parametros: 
	nr_seq_tit_pag_p = Numero de sequencia do titulo a pagar.
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_vl_titulo_pagar (nr_seq_tit_pag_p bigint) RETURNS bigint AS $body$
DECLARE

					
	vl_titulo_w	titulo_pagar.vl_titulo%type;	
	
	
BEGIN
	
	select coalesce(max(vl_titulo),0)
	  into STRICT vl_titulo_w
	 from titulo_pagar
	 where nr_titulo = nr_seq_tit_pag_p;
	
	/*select (select nvl(max(a.vl_saldo_titulo),0)
		      from titulo_pagar a
			 where a.nr_titulo = nr_seq_tit_pag_p) + 
	       (select  nvl(sum(vl_baixa),0)
			  from    titulo_pagar_baixa
			 where   nr_titulo = nr_seq_tit_pag_p) vl_tit_pag 
	into	vl_titulo_w
	from 	dual;*/
		
	return vl_titulo_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_vl_titulo_pagar (nr_seq_tit_pag_p bigint) FROM PUBLIC;