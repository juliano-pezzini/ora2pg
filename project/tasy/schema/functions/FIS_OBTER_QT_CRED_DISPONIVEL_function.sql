-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_obter_qt_cred_disponivel ( nr_seq_nf_orig_p bigint, nr_item_nf_orig_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w			bigint;
qt_itens_diminuido_w		nf_credito_item.qt_aplicacao%type;
qt_itens_aumentado_w		nf_credito_item.qt_aplicacao%type;
qt_item_nf_w			nota_fiscal_item.qt_item_nf%type;


BEGIN

select 	coalesce(sum(a.qt_aplicacao),0)
into STRICT	qt_itens_aumentado_w
from  	nf_credito_item a,
	nf_credito b
where 	a.nr_seq_nf_orig 	= nr_seq_nf_orig_p
and	a.nr_item_nf_orig	= nr_item_nf_orig_p
and 	a.nr_seq_nf_credito	= b.nr_sequencia
and   	ie_acao 		= 'A'
and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and	b.ie_situacao		<> '3';

select 	qt_item_nf
into STRICT 	qt_item_nf_w
from 	nota_fiscal_item
where 	nr_item_nf 	= nr_item_nf_orig_p
and 	nr_sequencia	= nr_seq_nf_orig_p;

select 	coalesce(sum(a.qt_aplicacao),0)
into STRICT	qt_itens_diminuido_w
from 	nf_credito_item a,
	nf_credito b
where 	a.nr_seq_nf_orig 	= nr_seq_nf_orig_p
and	a.nr_item_nf_orig	= nr_item_nf_orig_p
and 	a.nr_seq_nf_credito	= b.nr_sequencia
and	ie_acao			= 'D'
and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
and	b.ie_situacao		<> '3';

ds_retorno_w := qt_itens_aumentado_w + qt_item_nf_w - qt_itens_diminuido_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_obter_qt_cred_disponivel ( nr_seq_nf_orig_p bigint, nr_item_nf_orig_p bigint) FROM PUBLIC;

