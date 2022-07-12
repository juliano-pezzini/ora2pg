-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	--QT>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter a quantidade de notas fiscais do projeto recurso <<<<<<<<<<<<<<<<<<<<<<<<<<--	

	/*
	Objetivo: Retornar o quantidade total de notas fiscais do projeto recurso.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	*/
	


CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_qt_total_nf_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

				
	/* Variavel para retornar a quantidade total de notas fiscais do projeto recurso.*/


	qt_total_nf_proj_rec		bigint;	
	
		
	
BEGIN
		
	select  coalesce(count(a.nr_sequencia),0)
	into STRICT	qt_total_nf_proj_rec
	from    nota_fiscal a,
		operacao_nota b
	where   a.ie_situacao = 1
	and     (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
	and	a.cd_operacao_nf = b.cd_operacao_nf
	and	b.ie_operacao_fiscal = 'E'
	and     exists (SELECT 	1
			from 	nota_fiscal_item b
			where	a.nr_sequencia = b.nr_sequencia
			and 	b.nr_seq_proj_rec = nr_seq_proj_rec_p);
	
	return qt_total_nf_proj_rec;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_qt_total_nf_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;