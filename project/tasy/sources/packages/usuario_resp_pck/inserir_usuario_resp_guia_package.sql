-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE usuario_resp_pck.inserir_usuario_resp_guia (nm_usuario_p text, nr_seq_protocolo_p bigint, nm_usuario_responsavel_p text, nr_interno_conta_p bigint, nr_seq_regra_p bigint, nr_doc_convenio_p text) AS $body$
BEGIN
insert into USUARIO_RESP_GUIA_GRG(	nr_sequencia,
					dt_atualizacao_nrec,        
					nm_usuario,
					dt_atualizacao,
					nm_usuario_nrec,
					NR_SEQ_PROTOCOLO,   
					NM_USUARIO_RESPONSAVEL,
					NR_INTERNO_CONTA,
					NR_SEQ_REGRA_PREVISAO,
					CD_AUTORIZACAO)
values (	nextval('usuario_resp_guia_grg_seq'),  
					clock_timestamp(),        
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_protocolo_p,   
					nm_usuario_responsavel_p,
					nr_interno_conta_p,
					nr_seq_regra_p,
					nr_doc_convenio_p);
					
commit;	
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE usuario_resp_pck.inserir_usuario_resp_guia (nm_usuario_p text, nr_seq_protocolo_p bigint, nm_usuario_responsavel_p text, nr_interno_conta_p bigint, nr_seq_regra_p bigint, nr_doc_convenio_p text) FROM PUBLIC;
