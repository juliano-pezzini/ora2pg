-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_rejeitar_rescisao_program ( nr_seq_rescisao_prog_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE

			 
nr_seq_segurado_w 	bigint;


BEGIN 
 
update	pls_rescisao_contrato 
set	NR_SEQ_MOTIVO_REJEICAO	= nr_seq_motivo_p, 
	DS_OBSERVACAO_REJEICAO	= ds_observacao_p, 
	ie_situacao		= 'I', 
	nm_usuario		= nm_usuario_p, 
	dt_atualizacao		= clock_timestamp() 
where	nr_sequencia		= nr_seq_rescisao_prog_p;
 
select 	nr_seq_segurado 
into STRICT	nr_seq_segurado_w 
from 	pls_rescisao_contrato 
where 	nr_sequencia =	nr_seq_rescisao_prog_p;
 
if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then 
	CALL pls_alerta_rejeicao_mov(nr_seq_segurado_w, null, null, 4, nr_seq_rescisao_prog_p, nm_usuario_p);
end if;
 
if (ie_commit_p = 'S') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rejeitar_rescisao_program ( nr_seq_rescisao_prog_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
