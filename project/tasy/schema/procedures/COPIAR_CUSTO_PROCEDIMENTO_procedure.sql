-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_custo_procedimento (cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, nr_seq_tabela_origem_p bigint) AS $body$
BEGIN
CALL custos_pck.copiar_custo_procedimento(	cd_estabelecimento_p,
					cd_tabela_origem_p,
					cd_tabela_destino_p,
					nm_usuario_p,
					nr_seq_tabela_p,
					nr_seq_tabela_origem_p	
					);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_custo_procedimento (cd_estabelecimento_p bigint, cd_tabela_origem_p bigint, cd_tabela_destino_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, nr_seq_tabela_origem_p bigint) FROM PUBLIC;

