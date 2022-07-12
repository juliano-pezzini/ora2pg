-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Retorna o total de procedimentos e materiais "inconsistentes".



CREATE OR REPLACE FUNCTION pls_cta_consistir_pck.qtde_itens_nao_liberados (nr_seq_conta_p pls_conta.nr_sequencia%type) RETURNS integer AS $body$
DECLARE

qt_item_inconsistente_w integer;


BEGIN

select 	sum(qtde)
into STRICT	qt_item_inconsistente_w
from (
	SELECT	count(1) qtde
	from	pls_conta_proc_v
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status in ('C','P')
	
union all

	SELECT	count(1) qtde
	from	pls_conta_mat_v
	where	nr_seq_conta	= nr_seq_conta_p
	and	ie_status in ('C','P')
     ) alias5;

return  qt_item_inconsistente_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_cta_consistir_pck.qtde_itens_nao_liberados (nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;
