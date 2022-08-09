-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mensalidade_ant ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, qt_meses_ant_p bigint, ie_agrupar_p text, ie_mes_atual_p text, nm_usuario_p text) AS $body$
BEGIN
 
update	pls_lote_mensalidade 
set	ie_mensalidade_mes_anterior	= 'S', 
	ie_mens_ant_agrupar	= coalesce(ie_agrupar_p,'N'), 
	ie_mens_ant_mes_atual	= coalesce(ie_mes_atual_p,'N') 
where	nr_sequencia		= nr_seq_lote_p;
 
CALL pls_geracao_mensalidade(nr_seq_lote_p, cd_estabelecimento_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mensalidade_ant ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, qt_meses_ant_p bigint, ie_agrupar_p text, ie_mes_atual_p text, nm_usuario_p text) FROM PUBLIC;
