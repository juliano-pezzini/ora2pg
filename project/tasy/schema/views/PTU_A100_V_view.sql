-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ptu_a100_v (ds_registro, tp_registro) AS select	'Header' ds_registro,
	'101' tp_registro
FROM	ptu_intercambio	a

union

select	'Empresa' ds_registro,
	'102' tp_registro
from	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	a.nr_sequencia		= b.nr_seq_intercambio

union

select	'Plano' ds_registro,
	'103' tp_registro
from	ptu_intercambio_plano	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa

union

select	'Beneficiário' ds_registro,
	'104' tp_registro
from	ptu_intercambio_benef	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa

union

select	'Carencia' ds_registro,
	'105' tp_registro
from	ptu_beneficiario_carencia	d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa
and	c.nr_sequencia		= d.nr_seq_beneficiario

union

select	'Agregado' ds_registro,
	'106' tp_registro
from	ptu_benef_plano_agregado	d,
	ptu_intercambio_benef		c,
	ptu_intercambio_empresa		b,
	ptu_intercambio			a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa
and	c.nr_sequencia		= d.nr_seq_beneficiario

union

select	'Complemento' ds_registro,
	'107' tp_registro
from	ptu_beneficiario_compl	d,
	ptu_intercambio_benef	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa
and	c.nr_sequencia		= d.nr_seq_beneficiario

union

select	'Preexistencia' ds_registro,
	'108' tp_registro
from	ptu_benef_preexistencia	d,
	ptu_intercambio_benef	c,
	ptu_intercambio_empresa	b,
	ptu_intercambio		a
where	a.nr_sequencia		= b.nr_seq_intercambio
and	b.nr_sequencia		= c.nr_seq_empresa
and	c.nr_sequencia		= d.nr_seq_beneficiario;
