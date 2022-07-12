-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_modalidade_compra (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_mod_compra_w		bigint;


BEGIN

select	nr_seq_mod_compra
into STRICT	nr_seq_mod_compra_w
from	reg_licitacao
where	nr_sequencia = nr_sequencia_p;

return	nr_seq_mod_compra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_modalidade_compra (nr_sequencia_p bigint) FROM PUBLIC;

