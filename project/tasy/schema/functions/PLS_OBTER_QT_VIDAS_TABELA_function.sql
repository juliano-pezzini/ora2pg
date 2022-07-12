-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_vidas_tabela ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_titular_p pls_segurado.nr_sequencia%type, nr_seq_tabela_p pls_tabela_preco.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type) RETURNS bigint AS $body$
DECLARE


qt_vidas_w			bigint;
ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;


BEGIN

select	coalesce(max(ie_preco_vidas_contrato),'N'),
	coalesce(max(ie_calculo_vidas),'A')
into STRICT	ie_preco_vidas_contrato_w,
	ie_calculo_vidas_w
from	pls_tabela_preco
where	nr_sequencia	= nr_seq_tabela_p;

if (ie_preco_vidas_contrato_w = 'S') then
	if (ie_calculo_vidas_w = 'A') then
		select	count(1)
		into STRICT	qt_vidas_w
		from	pls_segurado
		where	nr_seq_contrato = nr_seq_contrato_p
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'month') >= dt_referencia_p));
	elsif (ie_calculo_vidas_w = 'T') then
		select	count(1)
		into STRICT	qt_vidas_w
		from	pls_segurado
		where	nr_seq_contrato = nr_seq_contrato_p
		and	coalesce(nr_seq_titular::text, '') = ''
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'month') >= dt_referencia_p));
	elsif (ie_calculo_vidas_w = 'D') then
		select	count(1)
		into STRICT	qt_vidas_w
		from	pls_segurado
		where	nr_seq_contrato = nr_seq_contrato_p
		and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
		and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
		and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'month') >= dt_referencia_p));
	elsif (ie_calculo_vidas_w = 'TD') then
		select	count(1)
		into STRICT	qt_vidas_w
		from	pls_segurado a
		where	a.nr_seq_contrato = nr_seq_contrato_p
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	((coalesce(a.dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'month') >= dt_referencia_p))
		and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(1)
											from	grau_parentesco x
											where	x.nr_sequencia = a.nr_seq_parentesco
											and	x.ie_tipo_parentesco = '1') > 0)));
	elsif (ie_calculo_vidas_w = 'F') then
		qt_vidas_w	:= coalesce(pls_obter_qt_familia_benef(nr_seq_segurado_p,nr_seq_titular_p,'L',dt_referencia_p),0);
	else
		qt_vidas_w	:= 0;
	end if;
else
	qt_vidas_w	:= 0;
end if;

return	qt_vidas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_vidas_tabela ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_titular_p pls_segurado.nr_sequencia%type, nr_seq_tabela_p pls_tabela_preco.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type) FROM PUBLIC;

