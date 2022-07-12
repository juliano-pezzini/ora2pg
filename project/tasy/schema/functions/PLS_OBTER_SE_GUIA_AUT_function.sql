-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_guia_aut ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, ie_tipo_validacao_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);
qt_conta_consistencia_w	integer;
qt_guia_autorizada_w	integer;
cd_usuario_plano_w	pls_conta.cd_usuario_plano_imp%type;
nr_seq_segurado_w	bigint;
/* valores para ie_tipo_validacao_p
P - consite procedimento da guia da conta
C - consiste somente a guia da conta
*/
BEGIN
ie_retorno_w := 'N';
qt_guia_autorizada_w := 0;
select	count(1)
into STRICT	qt_conta_consistencia_w
from	pls_conta	a
where	a.nr_sequencia	= nr_seq_conta_p
and	(a.cd_guia IS NOT NULL AND a.cd_guia::text <> '');

/*TRATAMENTO REALIZADO PARA ARQUIVOS IMPORTADOS*/

select	max(cd_usuario_plano_imp),
	max(nr_seq_segurado)
into STRICT	cd_usuario_plano_w,
	nr_seq_segurado_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_p;

if (coalesce(nr_seq_segurado_w::text, '') = '') then
	nr_seq_segurado_w	:= pls_obter_segurado_carteira(cd_usuario_plano_w,cd_estabelecimento_p);
end if;
-- valida pelo procedimento da guia
if (ie_tipo_validacao_p = 'P') then
	-- significa que a conta já foi importada e está em processo de consistência
	if (qt_conta_consistencia_w > 0) then
		-- busca pela guia de referência
		select	count(1)
		into STRICT	qt_guia_autorizada_w
		from	pls_conta a,
			pls_guia_plano b,
			pls_guia_plano_proc c
		where	a.nr_sequencia		= nr_seq_conta_p
		and	b.nr_seq_prestador	= a.nr_seq_prestador
		and	b.cd_guia		= a.cd_guia_referencia
		and	b.nr_seq_segurado	= a.nr_seq_segurado
		and	c.nr_seq_guia		= b.nr_sequencia
		and 	c.cd_procedimento	= cd_procedimento_p
		and	c.ie_origem_proced	= ie_origem_proced_p
		and	c.ie_status 		in ('L', 'S', 'P');
		if (qt_guia_autorizada_w = 0) then
			-- se não achar a guia de referência busca pela guia
			select	count(1)
			into STRICT	qt_guia_autorizada_w
			from	pls_conta a,
				pls_guia_plano b,
				pls_guia_plano_proc c
			where	a.nr_sequencia		= nr_seq_conta_p
			and	b.nr_seq_prestador	= a.nr_seq_prestador
			and	b.cd_guia		= a.cd_guia
			and	b.nr_seq_segurado	= a.nr_seq_segurado
			and	c.nr_seq_guia		= b.nr_sequencia
			and 	c.cd_procedimento	= cd_procedimento_p
			and	c.ie_origem_proced	= ie_origem_proced_p
			and	c.ie_status 		in ('L', 'S', 'P');
		end if;
	-- significa que a conta está apenas importada, busca pelos campos imp
	else
		-- busca pela guia de referência
		select	count(1)
		into STRICT	qt_guia_autorizada_w
		from	pls_conta a,
			pls_guia_plano b,
			pls_guia_plano_proc c
		where	a.nr_sequencia		= nr_seq_conta_p
		and	b.nr_seq_prestador	= a.nr_seq_prestador_imp
		and	b.cd_guia		= a.cd_guia_solic_imp
		and	b.nr_seq_segurado	= nr_seq_segurado_w
		and	c.nr_seq_guia		= b.nr_sequencia
		and 	c.cd_procedimento	= cd_procedimento_p
		and	c.ie_origem_proced	= ie_origem_proced_p
		and	c.ie_status 		in ('L', 'S', 'P');

		if (qt_guia_autorizada_w = 0) then
			-- se não achar a guia de referência busca pela guia
			select	count(1)
			into STRICT	qt_guia_autorizada_w
			from	pls_conta a,
				pls_guia_plano b,
				pls_guia_plano_proc c
			where	a.nr_sequencia		= nr_seq_conta_p
			and	b.nr_seq_prestador	= a.nr_seq_prestador_imp
			and	b.cd_guia		= a.cd_guia_imp
			and	b.nr_seq_segurado	= nr_seq_segurado_w
			and	c.nr_seq_guia		= b.nr_sequencia
			and 	c.cd_procedimento	= cd_procedimento_p
			and	c.ie_origem_proced	= ie_origem_proced_p
			and	c.ie_status 		in ('L', 'S', 'P');
		end if;
	end if;
-- valida somente pela guia
elsif (ie_tipo_validacao_p = 'C') then
	-- significa que a conta já foi importada e está em processo de consistência
	if (qt_conta_consistencia_w > 0) then
		-- busca pela guia de referência
		select	count(1)
		into STRICT	qt_guia_autorizada_w
		from	pls_conta a,
			pls_guia_plano b
		where	a.nr_sequencia		= nr_seq_conta_p
		and	b.nr_seq_prestador	= a.nr_seq_prestador
		and	b.cd_guia		= a.cd_guia_referencia
		and	b.nr_seq_segurado	= a.nr_seq_segurado
		and	b.ie_status		= '1';
		if (qt_guia_autorizada_w = 0) then
			-- se não achar a guia de referência busca pela guia
			select	count(1)
			into STRICT	qt_guia_autorizada_w
			from	pls_conta a,
				pls_guia_plano b
			where	a.nr_sequencia		= nr_seq_conta_p
			and	b.nr_seq_prestador	= a.nr_seq_prestador
			and	b.cd_guia		= a.cd_guia
			and	b.nr_seq_segurado	= a.nr_seq_segurado
			and	b.ie_status		= '1';
		end if;
	-- significa que a conta está apenas importada, busca pelos campos imp
	else
		-- busca pela guia de referência
		select	count(1)
		into STRICT	qt_guia_autorizada_w
		from	pls_conta a,
			pls_guia_plano b
		where	a.nr_sequencia		= nr_seq_conta_p
		and	b.nr_seq_prestador	= a.nr_seq_prestador_imp
		and	b.cd_guia		= a.cd_guia_solic_imp
		and	b.nr_seq_segurado	= nr_seq_segurado_w
		and	b.ie_status		= '1';
		if (qt_guia_autorizada_w = 0) then
			-- se não achar a guia de referência busca pela guia
			select	count(1)
			into STRICT	qt_guia_autorizada_w
			from	pls_conta a,
				pls_guia_plano b
			where	a.nr_sequencia		= nr_seq_conta_p
			and	b.nr_seq_prestador	= a.nr_seq_prestador_imp
			and	b.cd_guia		= a.cd_guia_imp
			and	b.nr_seq_segurado	= nr_seq_segurado_w
			and	b.ie_status		= '1';
		end if;
	end if;
end if;

if (qt_guia_autorizada_w > 0) then
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_guia_aut ( nr_seq_conta_p pls_conta.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, ie_tipo_validacao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
