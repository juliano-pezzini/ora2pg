-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_diops_compl_sem ( nr_seq_operadora_p bigint, nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_vigencia_w		timestamp;
nr_seq_transacao_w	bigint;


BEGIN 
 
/* Limpar tabelas transitórias */
 
delete	from w_diops_sem_ativoliq 
where	nr_seq_operadora 	= nr_seq_operadora_p 
and	nr_seq_periodo		= nr_seq_periodo_p;
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_transacao_w 
from	diops_transacao 
where	ie_tipo_transacao	= 'P' 
and	cd_estabelecimento	= cd_estabelecimento_p;
 
/* Obter dados da transação */
 
begin 
select	coalesce(dt_vigencia, clock_timestamp()) 
into STRICT	dt_vigencia_w 
from	diops_transacao 
where	nr_sequencia	= nr_seq_transacao_w 
and	cd_estabelecimento	= cd_estabelecimento_p;
exception 
	when others then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort( 266993, null);
end;
 
 
/* ct_lancAivoLiquido */
 
CALL diops_sem_gerar_ativo_liq(nr_seq_operadora_p, nr_seq_transacao_w, nr_seq_periodo_p, nm_usuario_p);
 
/* W_DIOPS_COMPL_SEMESTRAL */
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_diops_compl_sem ( nr_seq_operadora_p bigint, nr_seq_periodo_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

