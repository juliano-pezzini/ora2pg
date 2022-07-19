-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_ato_coop_mens ( nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
delete	FROM pls_mensalidade_ato_coop 
where	nr_seq_mensalidade	= nr_seq_mensalidade_p;
 
CALL pls_gerar_valor_ato_cooperado(nr_seq_mensalidade_p,null);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_ato_coop_mens ( nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

