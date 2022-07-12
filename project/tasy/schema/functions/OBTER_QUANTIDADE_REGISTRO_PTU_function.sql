-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_quantidade_registro_ptu ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*ie_opcao_p =
	102 -> qt_total_r102
	103 -> qt_total_r103
	104 -> qt_total_r104
	105 -> qt_total_r105
	106 -> qt_total_r106
	107 -> qt_total_r107
	108 -> qt_total_r108
	qt_inclusao     -> qt_total_inclusao
	qt_exclusao    -> qt_exclusos_benef
	*/
qt_total_w			integer;
qt_total_r102_w			smallint;
qt_total_r103_w			smallint;
qt_total_r104_w			integer;
qt_total_inclusao_w		integer;
qt_exclusos_benef_w		integer;
qt_total_alteracoes_w		integer;
qt_total_transferencia_w	integer;
qt_total_r105_w			integer;
qt_total_r106_w			integer;
qt_total_r107_w			integer;
qt_total_r108_w			integer;


BEGIN

select	count(*)
into STRICT	qt_total_r102_w
from	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_r103_w
from	ptu_intercambio_plano	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_r104_w
from	ptu_intercambio_benef	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_r105_w
from	ptu_beneficiario_carencia	d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	d.nr_seq_beneficiario	= c.nr_sequencia
and	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;


select	count(*)
into STRICT	qt_total_r106_w
from	ptu_benef_plano_agregado	d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	d.nr_seq_beneficiario	= c.nr_sequencia
and	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_r107_w
from	ptu_beneficiario_compl		d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	d.nr_seq_beneficiario	= c.nr_sequencia
and	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_r108_w
from	ptu_benef_preexistencia		d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	d.nr_seq_beneficiario	= c.nr_sequencia
and	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_inclusao_w
from	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	(c.dt_inclusao IS NOT NULL AND c.dt_inclusao::text <> '')
and	a.nr_sequencia		= nr_sequencia_p;

select	count(*)
into STRICT	qt_total_inclusao_w
from	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	c.nr_seq_empresa	= b.nr_sequencia
and	b.nr_seq_intercambio	= a.nr_sequencia
and	(c.dt_exclusao IS NOT NULL AND c.dt_exclusao::text <> '')
and	a.nr_sequencia		= nr_sequencia_p;

if (ie_opcao_p	= '102') then
	qt_total_w	:= qt_total_r102_w;
elsif (ie_opcao_p	= '103') then
	qt_total_w	:= qt_total_r103_w;
elsif (ie_opcao_p	= '104') then
	qt_total_w	:= qt_total_r104_w;
elsif (ie_opcao_p	= '105') then
	qt_total_w	:= qt_total_r105_w;
elsif (ie_opcao_p	= '106') then
	qt_total_w	:= qt_total_r106_w;
elsif (ie_opcao_p	= '107') then
	qt_total_w	:= qt_total_r107_w;
elsif (ie_opcao_p	= '108') then
	qt_total_w	:= qt_total_r108_w;
elsif (ie_opcao_p	= 'qt_inclusao') then
	qt_total_w	:= qt_total_inclusao_w;
elsif (ie_opcao_p	= 'qt_exclusao') then
	qt_total_w	:= qt_total_inclusao_w;
end if;

return	qt_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_quantidade_registro_ptu ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

