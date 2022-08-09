-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cartao_cancelar ( nr_seq_pagamento_p pls_solic_pagto_cartao_cr.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

CALL pls_cartao_integracao_pck.cancelar_pagamento(nr_seq_pagamento_p, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cartao_cancelar ( nr_seq_pagamento_p pls_solic_pagto_cartao_cr.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
