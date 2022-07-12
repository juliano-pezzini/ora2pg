-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_chamado_pck.get_ds_tipo_chamado ( nr_seq_tipo_chamado_p pls_tipo_chamado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ds_tipo_chamado_w	pls_tipo_chamado.ds_tipo_chamado%type;

BEGIN
select	max(ds_tipo_chamado)
into STRICT	ds_tipo_chamado_w
from	pls_tipo_chamado
where	nr_sequencia	= nr_seq_tipo_chamado_p;
return ds_tipo_chamado_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_chamado_pck.get_ds_tipo_chamado ( nr_seq_tipo_chamado_p pls_tipo_chamado.nr_sequencia%type) FROM PUBLIC;