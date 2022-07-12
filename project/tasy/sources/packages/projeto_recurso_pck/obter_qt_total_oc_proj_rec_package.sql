-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	
	--QT>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter a quantidade de ordens de compra do projeto recurso <<<<<<<<<<<<<<<<<<<<<<<<<<--	

	/*
	Objetivo: Retornar o quantidade total de ordens do projeto recurso que ainda estao sendo consideradas no saldo .
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	*/
	


CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_qt_total_oc_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

				
	/* Variavel para retornar a quantidade total de ordens de compra do projeto recurso.*/


	qt_total_ordem_proj_rec		bigint;	
	
		
	
BEGIN
		
	select  coalesce(count(a.nr_ordem_compra),0)
	into STRICT 	qt_total_ordem_proj_rec
	from    ordem_compra a
	where   (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and     coalesce(a.nr_seq_motivo_cancel::text, '') = ''
	and	projeto_recurso_pck.obter_ie_comprometido_ordem(nr_seq_proj_rec_p, a.nr_ordem_compra) > 0
	and     exists (SELECT  1
			from    ordem_compra_item b
			where   a.nr_ordem_compra = b.nr_ordem_compra
			and     b.nr_seq_proj_rec = nr_seq_proj_rec_p);
	
	return qt_total_ordem_proj_rec;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_qt_total_oc_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
