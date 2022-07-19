-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE valida_fatura_liberada ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_lote_conta_w	bigint;
ds_erro_w		varchar(4000);	
ds_erro_cons_w		varchar(4000);	
				 

BEGIN 
 
CALL ptu_ajustar_fatura_pcmso(nr_seq_fatura_p, null, cd_estabelecimento_p, nm_usuario_p, 'N');
 
ds_erro_cons_w := ptu_consistir_fatura(nr_seq_fatura_p, ds_erro_cons_w, cd_estabelecimento_p, nm_usuario_p);
 
SELECT * FROM ptu_gerar_pls_contas_medicas(nr_seq_fatura_p, nr_seq_lote_conta_w, ds_erro_w, cd_estabelecimento_p, nm_usuario_p) INTO STRICT nr_seq_lote_conta_w, ds_erro_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE valida_fatura_liberada ( nr_seq_fatura_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

