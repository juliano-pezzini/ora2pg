-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	--VR>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Controle bancario <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	/*
	Objetivo: Retornar o valor realizado da transacao do controle bancario passada por parametro no projeto recurso passado por parametro.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nr_transacao_p = Numero de sequencia da transacao.
	*/



CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_vl_realizado_cb ( nr_seq_proj_rec_p bigint, nr_transacao_p bigint default 0, cd_estabelecimento_p bigint DEFAULT NULL) RETURNS bigint AS $body$
DECLARE

	
	vl_total_cb_w			movto_trans_financ.vl_transacao%type;
	ie_contr_banc_proj_rec_w	parametro_compras.ie_contr_banc_proj_rec%type;
	
	
BEGIN

	vl_total_cb_w := 0;
	
	select 	coalesce(max(ie_contr_banc_proj_rec),'N')
	into STRICT	ie_contr_banc_proj_rec_w
	from   	parametro_compras
	where  	cd_estabelecimento = cd_estabelecimento_p;
	
	/* Transacoes financeiras do tipo RENDIMENTO e RECEBIMENTO nao devem ser consideradas como valor realizado. */


	
	return	vl_total_cb_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_vl_realizado_cb ( nr_seq_proj_rec_p bigint, nr_transacao_p bigint default 0, cd_estabelecimento_p bigint DEFAULT NULL) FROM PUBLIC;
