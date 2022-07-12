-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_vidas_tab_preco ( nr_seq_segurado_p bigint, ie_calculo_vidas_p text, ie_acao_p text) RETURNS bigint AS $body$
DECLARE


qt_vidas_w		bigint;
nr_seq_contrato_w	pls_contrato.nr_sequencia%type;
nr_seq_titular_w	pls_segurado.nr_seq_titular%type;
dt_contratacao_w	pls_segurado.dt_contratacao%type;
dt_contrato_w		pls_contrato.dt_contrato%type;
dt_liberacao_w		pls_segurado.dt_liberacao%type;
dt_aprovacao_w		pls_contrato.dt_aprovacao%type;

BEGIN

select	nr_seq_contrato
into STRICT	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

if (coalesce(nr_seq_contrato_w::text, '') = '') then
	select	a.nr_seq_intercambio,
		coalesce(a.nr_seq_titular,a.nr_sequencia),
		trunc(a.dt_contratacao,'dd'),
		trunc(b.dt_inclusao,'dd'),
		trunc(a.dt_liberacao,'dd'),
		trunc(b.dt_aprovacao,'dd')
	into STRICT	nr_seq_contrato_w,
		nr_seq_titular_w,
		dt_contratacao_w,
		dt_contrato_w,
		dt_liberacao_w,
		dt_aprovacao_w
	from	pls_segurado	a,
		pls_intercambio	b
	where	b.nr_sequencia	= a.nr_seq_intercambio
	and	a.nr_sequencia	= nr_seq_segurado_p;

	if (dt_contratacao_w = dt_contrato_w) and (coalesce(ie_acao_p,'X') = 'C') then
		if (ie_calculo_vidas_p = 'A') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'T') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	coalesce(nr_seq_titular::text, '') = ''
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'D') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'TD') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado a
			where	a.nr_seq_intercambio = nr_seq_contrato_w
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(a.nr_seq_titular::text, '') = '') or ((a.nr_seq_titular IS NOT NULL AND a.nr_seq_titular::text <> '') and ((SELECT	count(1)
												from	grau_parentesco x
												where	x.nr_sequencia = a.nr_seq_parentesco
												and	x.ie_tipo_parentesco = '1') > 0)))
			and	coalesce(a.dt_rescisao::text, '') = '';
		elsif (ie_calculo_vidas_p = 'F') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((nr_sequencia = nr_seq_titular_w) or (nr_seq_titular = nr_seq_titular_w))
			and	coalesce(dt_rescisao::text, '') = '';
		end if;
	else
		if (ie_calculo_vidas_p = 'A') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'T') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	coalesce(nr_seq_titular::text, '') = ''
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'D') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'TD') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado a
			where	a.nr_seq_intercambio = nr_seq_contrato_w
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(1)
												from	grau_parentesco x
												where	x.nr_sequencia = a.nr_seq_parentesco
												and	x.ie_tipo_parentesco = '1') > 0)));
		elsif (ie_calculo_vidas_p = 'F') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_intercambio = nr_seq_contrato_w
			and	((nr_sequencia = nr_seq_titular_w) or (nr_seq_titular = nr_seq_titular_w))
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()));
		end if;
	end if;
else
	select	a.nr_seq_contrato,
		coalesce(a.nr_seq_titular,a.nr_sequencia),
		trunc(a.dt_contratacao,'dd'),
		trunc(b.dt_contrato,'dd'),
		trunc(a.dt_liberacao,'dd'),
		trunc(b.dt_aprovacao,'dd')
	into STRICT	nr_seq_contrato_w,
		nr_seq_titular_w,
		dt_contratacao_w,
		dt_contrato_w,
		dt_liberacao_w,
		dt_aprovacao_w
	from	pls_segurado	a,
		pls_contrato	b
	where	b.nr_sequencia	= a.nr_seq_contrato
	and	a.nr_sequencia	= nr_seq_segurado_p;

	if (dt_contratacao_w = dt_contrato_w) and (coalesce(ie_acao_p,'X') = 'C') then
		if (ie_calculo_vidas_p = 'A') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'T') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	coalesce(nr_seq_titular::text, '') = ''
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'D') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
			and	coalesce(dt_rescisao::text, '') = ''
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'TD') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado a
			where	a.nr_seq_contrato = nr_seq_contrato_w
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(a.nr_seq_titular::text, '') = '') or ((a.nr_seq_titular IS NOT NULL AND a.nr_seq_titular::text <> '') and ((SELECT	count(1)
												from	grau_parentesco x
												where	x.nr_sequencia = a.nr_seq_parentesco
												and	x.ie_tipo_parentesco = '1') > 0)))
			and	coalesce(a.dt_rescisao::text, '') = '';
		elsif (ie_calculo_vidas_p = 'F') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato	= nr_seq_contrato_w
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((nr_sequencia = nr_seq_titular_w) or (nr_seq_titular = nr_seq_titular_w))
			and	coalesce(dt_rescisao::text, '') = '';
		end if;
	else
		if (ie_calculo_vidas_p = 'A') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'T') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	coalesce(nr_seq_titular::text, '') = ''
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'D') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato = nr_seq_contrato_w
			and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = '';
		elsif (ie_calculo_vidas_p = 'TD') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado a
			where	a.nr_seq_contrato = nr_seq_contrato_w
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(1)
												from	grau_parentesco x
												where	x.nr_sequencia = a.nr_seq_parentesco
												and	x.ie_tipo_parentesco = '1') > 0)));
		elsif (ie_calculo_vidas_p = 'F') then
			select	count(1)
			into STRICT	qt_vidas_w
			from	pls_segurado
			where	nr_seq_contrato	= nr_seq_contrato_w
			and	((nr_sequencia = nr_seq_titular_w) or (nr_seq_titular = nr_seq_titular_w))
			and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(dt_cancelamento::text, '') = ''
			and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()));
		end if;
	end if;
end if;

return	coalesce(qt_vidas_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_vidas_tab_preco ( nr_seq_segurado_p bigint, ie_calculo_vidas_p text, ie_acao_p text) FROM PUBLIC;

