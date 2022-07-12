-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_reajuste_pck.obter_quantidade_vidas_interc ( ie_calculo_vidas_p pls_tabela_preco.ie_calculo_vidas%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, dt_reajuste_p pls_reajuste.dt_reajuste%type, nr_seq_titular_p bigint) RETURNS bigint AS $body$
DECLARE


qt_vidas_w		bigint;


BEGIN
if (ie_calculo_vidas_p = 'A') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_segurado
	where	nr_seq_intercambio = nr_seq_intercambio_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > dt_reajuste_p));
elsif (ie_calculo_vidas_p = 'T') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_segurado
	where	nr_seq_intercambio = nr_seq_intercambio_p
	and	coalesce(nr_seq_titular::text, '') = ''
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > dt_reajuste_p));
elsif (ie_calculo_vidas_p = 'D') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_segurado
	where	nr_seq_intercambio = nr_seq_intercambio_p
	and	(nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '')
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	((coalesce(dt_rescisao::text, '') = '') or (trunc(dt_rescisao,'mm') > dt_reajuste_p));
elsif (ie_calculo_vidas_p = 'TD') then
	select	count(*)
	into STRICT	qt_vidas_w
	from	pls_segurado a
	where	a.nr_seq_intercambio = nr_seq_intercambio_p
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and	((coalesce(a.dt_rescisao::text, '') = '') or (trunc(a.dt_rescisao,'mm') > dt_reajuste_p))
	and	((coalesce(nr_seq_titular::text, '') = '') or ((nr_seq_titular IS NOT NULL AND nr_seq_titular::text <> '') and ((SELECT	count(*)
										from	grau_parentesco x
										where	x.nr_sequencia = a.nr_seq_parentesco
										and	x.ie_tipo_parentesco = '1') > 0)));
elsif (ie_calculo_vidas_p = 'F') then
	qt_vidas_w	:= coalesce(pls_obter_qt_vida_benef(nr_seq_segurado_p, nr_seq_titular_p, clock_timestamp()),0);
end if;

return qt_vidas_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_reajuste_pck.obter_quantidade_vidas_interc ( ie_calculo_vidas_p pls_tabela_preco.ie_calculo_vidas%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, dt_reajuste_p pls_reajuste.dt_reajuste%type, nr_seq_titular_p bigint) FROM PUBLIC;
