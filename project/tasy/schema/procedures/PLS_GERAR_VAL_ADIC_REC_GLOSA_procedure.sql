-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_val_adic_rec_glosa ( nr_seq_rec_protocolo_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_rec_conta_p pls_rec_glosa_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
ie_gerar_coparticipacao_w		pls_parametros_rec_glosa.ie_gerar_coparticipacao%type;
					

BEGIN 
 
select	coalesce(max(ie_gerar_coparticipacao), 'S') 
into STRICT	ie_gerar_coparticipacao_w 
from	pls_parametros_rec_glosa 
where	cd_estabelecimento = cd_estabelecimento_p;
 
-- Pós-estabelecido 
CALL pls_gerar_pos_estab_rec_glosa( nr_seq_rec_protocolo_p, nr_seq_rec_conta_p, cd_estabelecimento_p, nm_usuario_p);
 
-- Coparticipação 
if (ie_gerar_coparticipacao_w = 'S') then 
	CALL pls_gerar_copartic_rec_glosa( nr_seq_rec_protocolo_p, nr_seq_rec_conta_p, cd_estabelecimento_p, nm_usuario_p);
end if;
 
-- Custo operacional (Pré-contrato) 
CALL pls_gerar_co_rec_glosa( nr_seq_rec_protocolo_p, nr_seq_rec_conta_p, cd_estabelecimento_p, nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_val_adic_rec_glosa ( nr_seq_rec_protocolo_p pls_rec_glosa_protocolo.nr_sequencia%type, nr_seq_rec_conta_p pls_rec_glosa_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

