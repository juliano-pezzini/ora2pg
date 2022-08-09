-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apurar_res_centro_controle (cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_atualizar_indic_p text, nm_usuario_p text, nr_seq_tabela_p bigint) AS $body$
BEGIN

CALL custos_pck.apurar_res_centro_controle(	cd_estabelecimento_p,
					cd_tabela_custo_p,
					ie_atualizar_indic_p,
					nm_usuario_p,
					nr_seq_tabela_p	
					);	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apurar_res_centro_controle (cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, ie_atualizar_indic_p text, nm_usuario_p text, nr_seq_tabela_p bigint) FROM PUBLIC;
