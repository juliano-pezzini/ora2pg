-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter tipo do contrato <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Retornar o tipo do contrato. Pagar/Receber
	Parametros: 
	nr_seq_contrato_p = Numero de sequencia do contrato.
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_tipo_contrato (nr_seq_contrato_p bigint) RETURNS varchar AS $body$
DECLARE

		
		ie_pagar_receber_w	contrato.ie_pagar_receber%type;
		
		
BEGIN
		
		ie_pagar_receber_w := 'P';
		
		select coalesce(ie_pagar_receber, 'P')
		  into STRICT ie_pagar_receber_w
		  from contrato
		 where nr_sequencia = nr_seq_contrato_p;
		
		return ie_pagar_receber_w;
				
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_tipo_contrato (nr_seq_contrato_p bigint) FROM PUBLIC;
