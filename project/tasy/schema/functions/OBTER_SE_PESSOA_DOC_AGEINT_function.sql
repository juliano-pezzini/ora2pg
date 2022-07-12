-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pessoa_doc_ageint ( nr_seq_documento_p bigint, nr_seq_ageint_p bigint, nr_seq_tipo_documentacao_p bigint, nr_seq_ageint_documento_p bigint default null, dt_atualizacao_nrec_p timestamp default null) RETURNS varchar AS $body$
DECLARE


ie_cart_convenio_w	tipo_documentacao.ie_cart_convenio%type;
ie_pedido_medico_w	tipo_documentacao.ie_pedido_medico%type;
ds_retorno_w		varchar(1) := 'S';


BEGIN

select	coalesce(max(ie_cart_convenio),'N'),
	coalesce(max(ie_pedido_medico),'N')
into STRICT	ie_cart_convenio_w,
	ie_pedido_medico_w
from	tipo_documentacao
where	nr_sequencia = nr_seq_tipo_documentacao_p;

if (ie_cart_convenio_w = 'S') and (coalesce(nr_seq_documento_p,0) > 0) and (coalesce(nr_seq_ageint_p,0) > 0) then
	select	CASE WHEN coalesce(max(nr_sequencia)::text, '') = '' THEN 'N'  ELSE 'S' END
	into STRICT	ds_retorno_w
	from	pessoa_titular_convenio a
	where	a.nr_seq_pessoa_doc = nr_seq_documento_p
	and	trunc(a.dt_validade_carteira) >= trunc(clock_timestamp())
	and exists (	SELECT	1
			from	agenda_integrada b
			where	b.cd_convenio = a.cd_convenio
			and	b.cd_categoria = a.cd_categoria
			and	b.nr_sequencia = nr_seq_ageint_p);
elsif (ie_pedido_medico_w = 'S') then
	-- apresenta os pedidos médicos registrados na data atual e os pedidos médicos que estão vinculados ao agendamento do dia
	if	((trunc(dt_atualizacao_nrec_p) = trunc(clock_timestamp())) or (nr_seq_ageint_documento_p = nr_seq_ageint_p))then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pessoa_doc_ageint ( nr_seq_documento_p bigint, nr_seq_ageint_p bigint, nr_seq_tipo_documentacao_p bigint, nr_seq_ageint_documento_p bigint default null, dt_atualizacao_nrec_p timestamp default null) FROM PUBLIC;

