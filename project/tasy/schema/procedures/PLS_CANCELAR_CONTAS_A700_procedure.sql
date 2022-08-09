-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cancelar_contas_a700 ( nr_seq_serv_pre_pagto_p ptu_servico_pre_pagto.nr_sequencia%type, nr_seq_motivo_cancel_p pls_motivo_cancel_conta.nr_sequencia%type, ds_justificativa_p ptu_servico_pre_pagto.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

 
ds_observacao_w			varchar(4000);		
nr_seq_conta_w			pls_conta.nr_sequencia%type;										
	 
C01 CURSOR(nr_seq_serv_prev_pagto_w ptu_servico_pre_pagto.nr_sequencia%type) FOR 
	SELECT	b.nr_sequencia nr_seq_conta 
	from	pls_conta		b, 
		ptu_servico_pre_pagto 	a 
	where	a.nr_sequencia 		= b.nr_seq_serv_pre_pagto 
	and	a.nr_sequencia		= nr_seq_serv_prev_pagto_w;
	
BEGIN 
if (nr_seq_serv_pre_pagto_p IS NOT NULL AND nr_seq_serv_pre_pagto_p::text <> '') then	 
	update	pls_protocolo_conta 
	set	ie_status 		= '5', 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_seq_serv_pre_pagto 	= nr_seq_serv_pre_pagto_p;
 
	for r_c01 in C01(nr_seq_serv_pre_pagto_p) loop 
		ds_observacao_w := pls_cancelar_conta(r_c01.nr_seq_conta, nr_seq_motivo_cancel_p, nm_usuario_p, cd_estabelecimento_p, 1, ds_observacao_w, 'N');
		ds_observacao_w := pls_cancelar_conta(r_c01.nr_seq_conta, nr_seq_motivo_cancel_p, nm_usuario_p, cd_estabelecimento_p, 2, ds_observacao_w, 'N');
	end loop;
	 
	update	ptu_servico_pre_pagto 
	set	nr_seq_motivo_cancel	= nr_seq_motivo_cancel_p, 
		ds_justificativa	= ds_justificativa_p, 
		nm_usuario_cancelamento	= nm_usuario_p, 
		dt_cancelamento	 	= clock_timestamp(), 
		nm_usuario		= nm_usuario_p, 
		dt_atualizacao		= clock_timestamp() 
	where	nr_sequencia 		= nr_seq_serv_pre_pagto_p;
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cancelar_contas_a700 ( nr_seq_serv_pre_pagto_p ptu_servico_pre_pagto.nr_sequencia%type, nr_seq_motivo_cancel_p pls_motivo_cancel_conta.nr_sequencia%type, ds_justificativa_p ptu_servico_pre_pagto.ds_justificativa%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
