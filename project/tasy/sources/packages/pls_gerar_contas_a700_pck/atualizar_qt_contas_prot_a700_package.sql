-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.atualizar_qt_contas_prot_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por atualizar a quantidade de contas vinculadas ao protocolo. 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

	
qt_contas_w		integer;
	

BEGIN

select	count(1)
into STRICT	qt_contas_w
from	pls_conta
where	nr_seq_protocolo = nr_seq_protocolo_p;

update	pls_protocolo_conta
set	qt_contas_informadas	= qt_contas_w,
	ie_status		= '7' -- '7' = Encerrado A700

where	nr_sequencia		= nr_seq_protocolo_p;	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.atualizar_qt_contas_prot_a700 ( nr_seq_protocolo_p pls_conta.nr_seq_protocolo%type) FROM PUBLIC;