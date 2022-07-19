-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_lote_apres_aut ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

nr_seq_protocolo_w	bigint;
C01 CURSOR FOR
	SELECT	nr_sequencia 
	from	pls_protocolo_conta 
	where	nr_seq_lote_apres_autom = nr_seq_lote_p;

BEGIN
open C01;
loop 
fetch C01 into	 
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		CALL pls_excluir_protocolo_lote( nr_seq_protocolo_w, nm_usuario_p, cd_estabelecimento_p);
	end;
end loop;
close C01;
 
delete	FROM pls_apres_automatica_guia 
where	nr_seq_lote = nr_seq_lote_p;
 
delete FROM pls_lote_apres_aut_log 
where	nr_seq_lote = nr_seq_lote_p;
 
delete	FROM pls_log_apresent_autom 
where	nr_seq_lote_apresentacao = nr_seq_lote_p;
 
delete	FROM pls_lote_apres_automatica 
where	nr_sequencia = nr_seq_lote_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_lote_apres_aut ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

