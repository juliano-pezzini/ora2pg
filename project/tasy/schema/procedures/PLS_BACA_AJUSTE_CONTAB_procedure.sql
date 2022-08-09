-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajuste_contab ( nm_usuario_p text) AS $body$
DECLARE

 
C01 CURSOR FOR 
	SELECT	conta.nr_sequencia 
	from	pls_protocolo_conta	prot, 
		pls_conta		conta 
	where	prot.nr_sequencia	= conta.nr_seq_protocolo 
	and	prot.ie_situacao	in ('D','T') 
	and	prot.dt_mes_competencia	>= '01/01/2015' 
	and	conta.ie_status		!= 'C' 
	and	not exists (SELECT 1 from pls_conta_pos_estabelecido pos where pos.nr_seq_conta = conta.nr_sequencia and (nr_seq_lote_fat IS NOT NULL AND nr_seq_lote_fat::text <> ''));
BEGIN
 
for r_c01_w in c01() loop 
	begin 
	CALL pls_gerar_contab_val_adic(	r_c01_w.nr_sequencia,null, null,null,null,null,null, 
					'C','N', nm_usuario_p);
	commit;
	CALL pls_gerar_contab_val_adic(	r_c01_w.nr_sequencia,null, null,null,null,null,null, 
					'P','N', nm_usuario_p);
	commit;
	end;
end loop;
 
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_ajuste_contab ( nm_usuario_p text) FROM PUBLIC;
