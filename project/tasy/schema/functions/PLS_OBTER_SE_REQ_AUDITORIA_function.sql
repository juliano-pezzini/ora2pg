-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_req_auditoria ( nr_seq_requisicao_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


nr_retorno_w			integer;
qt_req_proc_auditoria_w		integer := 0;
qt_req_mat_auditoria_w		integer := 0;
qt_requisicao_ocorrencia_w	integer := 0;
ie_estagio_w			smallint;

/*
	ie_opcao_p
		P - Procedimento
		M - Material
		C - Cabeçalho
*/
BEGIN
/*
select	count(*)
into	qt_req_proc_auditoria_w
from	pls_requisicao_proc
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'A';

select	count(*)
into	qt_req_mat_auditoria_w
from	pls_requisicao_mat
where	nr_seq_requisicao	= nr_seq_requisicao_p
and	ie_status		= 'A';
*/
select	count(1)
into STRICT	qt_req_proc_auditoria_w
from	pls_ocorrencia		b,
	pls_ocorrencia_benef	a
where	a.nr_seq_requisicao	= nr_seq_requisicao_p
and	a.nr_seq_ocorrencia	= b.nr_sequencia
and	b.ie_auditoria 		= 'S'
and	exists (	SELECT	1
		from	pls_requisicao_proc x
		where	x.nr_sequencia	= a.nr_seq_proc
		and	x.ie_status	<> 'C')
and	not exists (	select	1
			from	pls_auditoria y
			where	y.nr_seq_requisicao	= nr_seq_requisicao_p
			and	(y.dt_liberacao IS NOT NULL AND y.dt_liberacao::text <> ''));

select	count(1)
into STRICT	qt_req_mat_auditoria_w
from	pls_ocorrencia		b,
	pls_ocorrencia_benef	a
where	a.nr_seq_requisicao	= nr_seq_requisicao_p
and	a.nr_seq_ocorrencia	= b.nr_sequencia
and	b.ie_auditoria 		= 'S'
and	exists (	SELECT	1
		from	pls_requisicao_mat
		where	nr_sequencia	= a.nr_seq_mat
		and	ie_status	<> 'C')
and	not exists (	select	1
			from	pls_auditoria y
			where	y.nr_seq_requisicao	= nr_seq_requisicao_p
			and	(y.dt_liberacao IS NOT NULL AND y.dt_liberacao::text <> ''));

/*begin
select	ie_estagio
into	ie_estagio_w
from	pls_requisicao
where	nr_sequencia	= nr_seq_requisicao_p;
exception
when others then
	ie_estagio_w := 0;
end;

if	(ie_estagio_w = 1) then*/
	select	count(*)
	into STRICT	qt_requisicao_ocorrencia_w
	from	pls_ocorrencia		b,
		pls_ocorrencia_benef	a
	where	a.nr_seq_requisicao	= nr_seq_requisicao_p
	and	a.nr_seq_ocorrencia	= b.nr_sequencia
	and	b.ie_auditoria 		= 'S'
	and	coalesce(a.nr_seq_proc::text, '') = ''
	and	coalesce(a.nr_seq_mat::text, '') = ''
	and	not exists (	SELECT	1
				from	pls_auditoria y
				where	y.nr_seq_requisicao	= nr_seq_requisicao_p
				and	(y.dt_liberacao IS NOT NULL AND y.dt_liberacao::text <> ''));
--end if;
if (ie_opcao_p	= 'P') then
	nr_retorno_w := qt_req_proc_auditoria_w;
elsif (ie_opcao_p	= 'M') then
	nr_retorno_w := qt_req_mat_auditoria_w;
elsif (ie_opcao_p	= 'C') then
	nr_retorno_w := qt_requisicao_ocorrencia_w;
else
	nr_retorno_w := qt_req_proc_auditoria_w + qt_req_mat_auditoria_w + qt_requisicao_ocorrencia_w;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_req_auditoria ( nr_seq_requisicao_p bigint, ie_opcao_p text) FROM PUBLIC;

