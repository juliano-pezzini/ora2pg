-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_valores_conv_ret_item ( nr_sequencia_p bigint, ds_vl_guia_p bigint) AS $body$
BEGIN
update	convenio_retorno_item a
set	a.vl_amenor 	= ds_vl_guia_p,
	a.vl_pago	= 0,
	a.ie_glosa	= 'P'
where	a.nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_valores_conv_ret_item ( nr_sequencia_p bigint, ds_vl_guia_p bigint) FROM PUBLIC;

