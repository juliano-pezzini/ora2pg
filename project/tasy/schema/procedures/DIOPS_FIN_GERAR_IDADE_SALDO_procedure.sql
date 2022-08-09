-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_fin_gerar_idade_saldo ( nr_seq_operadora_p bigint, nr_seq_transacao_p bigint, nr_seq_periodo_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
CALL diops_gerar_idadesaldo_passivo(nr_seq_operadora_p, nr_seq_transacao_p, nr_seq_periodo_p, nm_usuario_p);
 
CALL diops_gerar_idadesaldo_ativo(nr_seq_operadora_p, nr_seq_transacao_p, nr_seq_periodo_p, nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_fin_gerar_idade_saldo ( nr_seq_operadora_p bigint, nr_seq_transacao_p bigint, nr_seq_periodo_p bigint, nm_usuario_p text) FROM PUBLIC;
