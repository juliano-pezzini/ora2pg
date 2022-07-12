-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_internado_alt ( nr_seq_conta_p pls_conta.nr_sequencia%type, -- informe se os dados da conta foram passados por pametro, neste caso não é feito select da conta novamente.
 ie_dados_parametros_p text default 'N', ie_tipo_guia_p pls_conta.ie_tipo_guia%type default null, nr_seq_guia_p pls_conta.nr_seq_guia%type default null, nr_seq_segurado_p pls_conta.nr_seq_segurado%type default null, cd_guia_ok_p pls_conta.cd_guia_ok%type default null, nr_seq_analise_p pls_analise_conta.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE



ie_retorno_w			pls_tipo_atendimento.ie_internado%type	:= 'N';
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
nr_seq_guia_w			pls_conta.nr_seq_guia%type;
qt_guia_int_w			integer;
nr_seq_segurado_w		pls_conta.nr_seq_segurado%type;
cd_guia_ok_w			pls_conta.cd_guia_ok%type;
nr_seq_analise_w		pls_analise_conta.nr_sequencia%type;


BEGIN

if (ie_dados_parametros_p = 'S') then

	ie_tipo_guia_w		:= ie_tipo_guia_p;
	nr_seq_guia_w		:= nr_seq_guia_p;
	nr_seq_segurado_w       := nr_seq_segurado_p;
	cd_guia_ok_w		:= cd_guia_ok_p;
	nr_seq_analise_w	:= nr_seq_analise_p;
else
	select	coalesce(max(ie_tipo_guia),'0'),
		max(nr_seq_guia),
		max(nr_seq_segurado),
		max(cd_guia_ok),
		max(nr_seq_analise)
	into STRICT	ie_tipo_guia_w,
		nr_seq_guia_w,
		nr_seq_segurado_w,
		cd_guia_ok_w,
		nr_seq_analise_w
	from	pls_conta
	where	nr_sequencia	= nr_seq_conta_p;
end if;

-- Se for resumo de internação então é internação
if (ie_tipo_guia_w = '5') then

	ie_retorno_w	:= 'I';

-- qualquer outro tipo de guia verifica se existe algum vínculo com outra guia de resumo de internação
-- se tiver vinculo é internação, senão não é
else
	-- somente verifica pelo código da guia os outros atendimentos vinculados
	-- solicitação feita pelo Carlos em conexão sobre a OS 853108
	select	count(1)
	into STRICT	qt_guia_int_w
	from	pls_conta
	where	ie_tipo_guia	= '5'
	and	cd_guia_ok	= cd_guia_ok_w
	and	nr_seq_segurado	= nr_seq_segurado_w
	and	ie_status	!= 'C';

	if (qt_guia_int_w = 0) then
		select	count(1)
		into STRICT	qt_guia_int_w
		from	pls_conta
		where	ie_tipo_guia	= '5'
		and	nr_seq_guia	= nr_seq_guia_w
		and	nr_seq_segurado	= nr_seq_segurado_w
		and	ie_status	!= 'C';

		if (qt_guia_int_w = 0) then
			select	count(1)
			into STRICT	qt_guia_int_w
			from	pls_conta
			where	ie_tipo_guia	= '5'
			and	nr_seq_analise	= nr_seq_analise_w
			and	ie_status	!= 'C';
		end if;
	end if;

	if (qt_guia_int_w	> 0) then
		ie_retorno_w	:= 'I';
	end if;

end if;

if (coalesce(ie_retorno_w::text, '') = '') then

	ie_retorno_w	:= 'N';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_internado_alt ( nr_seq_conta_p pls_conta.nr_sequencia%type,  ie_dados_parametros_p text default 'N', ie_tipo_guia_p pls_conta.ie_tipo_guia%type default null, nr_seq_guia_p pls_conta.nr_seq_guia%type default null, nr_seq_segurado_p pls_conta.nr_seq_segurado%type default null, cd_guia_ok_p pls_conta.cd_guia_ok%type default null, nr_seq_analise_p pls_analise_conta.nr_sequencia%type default null) FROM PUBLIC;

