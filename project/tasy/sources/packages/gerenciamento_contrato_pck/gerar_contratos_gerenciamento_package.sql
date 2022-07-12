-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> INSERE CONTROLE DE SALDO DOS CONTRATOS ATIVOS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Gerar o gerenciamento de saldo para os contratos ativos.
			    nm_usuario_p 		 = Nome do usuario.
				cd_estabelecimento_p = Codigo do estabelecimento dos contratos.
				ie_tipo_insert_p     = Quando 'J': indica que o gerenciamento foi disparado pelo Job. 
				                       Quando 'U': disparado diretamente pelo usuario na funcao Controle de Contratos.
	*/
CREATE OR REPLACE PROCEDURE gerenciamento_contrato_pck.gerar_contratos_gerenciamento (nm_usuario_p text, cd_estabelecimento_p bigint, ie_tipo_insert_p text) AS $body$
DECLARE

		
		c01 CURSOR FOR
		 SELECT nr_sequencia nr_seq_contrato,
			   cd_contrato cd_contrato
		   from contrato
		  where ie_situacao = 'A'
		    and ie_classificacao = 'AT'
		    and cd_estabelecimento = cd_estabelecimento_p
		    and ((clock_timestamp() between dt_inicio and dt_fim) or coalesce(dt_fim::text, '') = '');
		
		
BEGIN
		
			For r01 in c01 loop
				CALL gerenciamento_contrato_pck.inserir_contrato_gerenciamento(r01.nr_seq_contrato, nm_usuario_p, ie_tipo_insert_p);
			end loop;		
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerenciamento_contrato_pck.gerar_contratos_gerenciamento (nm_usuario_p text, cd_estabelecimento_p bigint, ie_tipo_insert_p text) FROM PUBLIC;
