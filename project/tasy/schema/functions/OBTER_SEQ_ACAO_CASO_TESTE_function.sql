-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_acao_caso_teste (cd_caso_teste_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_acao_caso_teste_w		caso_teste_acao.nr_ordem_execucao%TYPE;


BEGIN

select	coalesce(max(nr_ordem_execucao),0)+5
into STRICT	nr_seq_acao_caso_teste_w
from	caso_teste_acao
where	NR_SEQ_CASO_TESTE = cd_caso_teste_p;

return	nr_seq_acao_caso_teste_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_acao_caso_teste (cd_caso_teste_p bigint) FROM PUBLIC;

