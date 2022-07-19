-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consiste_simulpreco ( nr_seq_simulacao_p bigint, nr_seq_item_p bigint, ie_tipo_operacao_p text, ie_tipo_entrada_p text, ie_tipo_simulacao_p text, nr_seq_item_individual_p bigint, nr_seq_item_coletivo_p bigint, ie_gerar_vl_inscr_simul_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN
 
CALL pls_recalcular_simulacao(nr_seq_simulacao_p, nm_usuario_p);
 
if (ie_tipo_operacao_p = 'E') or (ie_tipo_operacao_p = 'I') then 
	begin 
	CALL pls_gerar_resumo_simulacao( 
		nr_seq_simulacao_p, 
		nr_seq_item_p, 
		ie_tipo_operacao_p, 
		ie_tipo_entrada_p, 
		ie_tipo_simulacao_p, 
		cd_estabelecimento_p, 
		nm_usuario_p);
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consiste_simulpreco ( nr_seq_simulacao_p bigint, nr_seq_item_p bigint, ie_tipo_operacao_p text, ie_tipo_entrada_p text, ie_tipo_simulacao_p text, nr_seq_item_individual_p bigint, nr_seq_item_coletivo_p bigint, ie_gerar_vl_inscr_simul_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

