-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_acato_proc_conta (nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


vl_conta_w	double precision;


BEGIN

vl_conta_w	:= coalesce(pls_conta_processo_obter_valor(nr_seq_proc_conta_p),0);

update	pls_processo_conta
set	ie_status_conta		= 'R',
	ie_status_pagamento	 = NULL,
	vl_pendente		= vl_conta_w,
	vl_ressarcir		= 0
where	nr_sequencia	= nr_seq_proc_conta_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_acato_proc_conta (nr_seq_proc_conta_p pls_processo_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
