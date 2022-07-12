-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/*inserre a prescrição para ser integrada pelo sistema*/
 


CREATE OR REPLACE PROCEDURE shift_integracao_pck.agendar_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint) AS $body$
BEGIN
 
		CALL gravar_agend_integracao(	nr_seq_evento_p, 
									ds_parametros_p, 
									cd_setor_atendimento_p);
 
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE shift_integracao_pck.agendar_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint) FROM PUBLIC;