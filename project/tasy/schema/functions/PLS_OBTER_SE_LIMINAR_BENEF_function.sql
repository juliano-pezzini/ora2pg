-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_liminar_benef ( nr_seq_segurado_p bigint, dt_solicitacao_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_reg_w			integer;
nr_seq_contrato_w		bigint;

cd_pessoa_fisica_w		pessoa_fisica.cd_pessoa_fisica%type;


BEGIN

begin
	select	nr_seq_contrato,
		cd_pessoa_fisica
	into STRICT	nr_seq_contrato_w,
		cd_pessoa_fisica_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;
exception
when others then
	nr_seq_contrato_w := 0;
end;


select	count(*)
into STRICT	qt_reg_w
from	processo_judicial_liminar
where	(((coalesce(ie_considera_codigo_pf, 'N') = 'N'	and nr_seq_segurado	= nr_seq_segurado_p)
or (coalesce(ie_considera_codigo_pf, 'N') = 'S'		and pls_obter_dados_segurado(nr_seq_segurado, 'PF')	= cd_pessoa_fisica_w))
or	nr_seq_contrato		= nr_seq_contrato_w)
and	ie_estagio		= 2
and	ie_impacto_autorizacao	= 'S' --Somente liminar com impacto para autorizações
and	dt_solicitacao_p between trunc(dt_inicio_validade) and fim_dia(coalesce(dt_fim_validade,dt_solicitacao_p));

if (qt_reg_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_liminar_benef ( nr_seq_segurado_p bigint, dt_solicitacao_p timestamp) FROM PUBLIC;
