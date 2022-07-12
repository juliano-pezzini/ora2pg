-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_eq_obter_status ( nr_seq_pessoa_proposta_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(80);
cd_pessoa_fisica_w		varchar(10);
ie_status_proposta_w		varchar(1);
nr_seq_entrevista_w		bigint;
dt_inicio_entrevista_w		timestamp;
dt_fim_entrevista_w		timestamp;
nr_seq_pericia_w		bigint;
nr_seq_proposta_w		bigint;
nr_seq_contrato_w		bigint;


BEGIN

begin
select	cd_beneficiario,
	nr_seq_proposta
into STRICT	cd_pessoa_fisica_w,
	nr_seq_proposta_w
from	pls_proposta_beneficiario
where	nr_sequencia	= nr_seq_pessoa_proposta_p;
exception
	when others then
	cd_pessoa_fisica_w	:= '';
end;

/* Verificar se está na proposta de adesão (1) */

begin
select	coalesce(b.ie_status,0)
into STRICT	ie_status_proposta_w
from	pls_proposta_adesao		b,
	pls_proposta_beneficiario	a
where	a.nr_seq_proposta		= b.nr_sequencia
and	a.cd_beneficiario		= cd_pessoa_fisica_w
and	dt_inicio_proposta		= (	SELECT	max(dt_inicio_proposta)
						from	pls_proposta_adesao
						where	cd_beneficiario	= cd_pessoa_fisica_w);
exception
	when others then
	ie_status_proposta_w	:= '';
end;

/* Verificar se já iniciou a entrevista qualificada (2) */

begin
select	nr_sequencia,
	dt_inicio_entrevista,
	dt_fim_entrevista
into STRICT	nr_seq_entrevista_w,
	dt_inicio_entrevista_w,
	dt_fim_entrevista_w
from	pls_entrevista_qualificada
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
exception
	when others then
	nr_seq_entrevista_w	:= 0;
	dt_inicio_entrevista_w	:= null;
	dt_fim_entrevista_w	:= null;
end;

/* Verificar se possui perícia médica (3)
select	nvl(max(b.nr_sequencia),0)
into	nr_seq_pericia_w
from	pls_pericia_medica	b,
	pls_segurado		a
where	a.nr_sequencia		= b.nr_seq_segurado
and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
*/
/* Verificar se possui contrato (5) */

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_contrato_w
from	pls_contrato
where	nr_seq_proposta	= nr_seq_proposta_w;

if (nr_seq_contrato_w	> 0) then
	ds_retorno_w	:= '5';
elsif (nr_seq_entrevista_w	> 0) and (dt_fim_entrevista_w IS NOT NULL AND dt_fim_entrevista_w::text <> '') then
	ds_retorno_w	:= '4';
/* elsif	(nr_seq_pericia_w	> 0) then
	ds_retorno_w	:= '3'; */
elsif (nr_seq_entrevista_w	> 0) and (dt_inicio_entrevista_w IS NOT NULL AND dt_inicio_entrevista_w::text <> '') then
	ds_retorno_w	:= '2';
elsif (ie_status_proposta_w	= 'E') then
	ds_retorno_w	:= '1';
end if;

if (ie_tipo_retorno_p	= 'D') then
	ds_retorno_w	:= substr(obter_valor_dominio(2442, ds_retorno_w),1,80);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_eq_obter_status ( nr_seq_pessoa_proposta_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;

