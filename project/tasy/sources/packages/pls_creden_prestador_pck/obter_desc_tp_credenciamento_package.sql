-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_creden_prestador_pck.obter_desc_tp_credenciamento ( nr_seq_tipo_credenciamento_p pls_tipo_cred_prestador.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

ds_tipo_credenciamento_w	pls_tipo_cred_prestador.ds_tipo_credenciamento%type;

BEGIN

select	max(ds_tipo_credenciamento)
into STRICT	ds_tipo_credenciamento_w
from	pls_tipo_cred_prestador
where	nr_sequencia	= nr_seq_tipo_credenciamento_p;

return ds_tipo_credenciamento_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_creden_prestador_pck.obter_desc_tp_credenciamento ( nr_seq_tipo_credenciamento_p pls_tipo_cred_prestador.nr_sequencia%type) FROM PUBLIC;
