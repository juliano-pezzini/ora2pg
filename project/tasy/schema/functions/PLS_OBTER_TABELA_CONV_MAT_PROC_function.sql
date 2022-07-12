-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tabela_conv_mat_proc (nr_seq_regra_p pls_conversao_proc.nr_sequencia%type) RETURNS PLS_CONVERSAO_PROC.IE_TIPO_TABELA%TYPE AS $body$
DECLARE


ie_tipo_tabela_w	pls_conversao_proc.ie_tipo_tabela%type	:= 0;


BEGIN

select	max(a.ie_tipo_tabela)
into STRICT	ie_tipo_tabela_w
from	pls_conversao_proc a
where	a.nr_sequencia = nr_seq_regra_p;

return	ie_tipo_tabela_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tabela_conv_mat_proc (nr_seq_regra_p pls_conversao_proc.nr_sequencia%type) FROM PUBLIC;

