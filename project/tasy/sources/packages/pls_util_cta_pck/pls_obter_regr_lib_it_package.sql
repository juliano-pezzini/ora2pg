-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--  usada para obter a regra de liberacao do item cadastrada em OPS - Cadastro de Regras, na pasta Cadastro de Regras, itens OPS - Contas Medicas->Liberacao de valores na conta



CREATE OR REPLACE FUNCTION pls_util_cta_pck.pls_obter_regr_lib_it ( nr_seq_regra_valor_p pls_regra_valor_conta.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE

ie_regra_liberacao_w	pls_regra_valor_conta.ie_regra_liberacao%type;

BEGIN

select	max(a.ie_regra_liberacao)
into STRICT	ie_regra_liberacao_w
from 	pls_regra_valor_conta 	a
where	a.nr_sequencia = nr_seq_regra_valor_p;

return ie_regra_liberacao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_cta_pck.pls_obter_regr_lib_it ( nr_seq_regra_valor_p pls_regra_valor_conta.nr_sequencia%type) FROM PUBLIC;
