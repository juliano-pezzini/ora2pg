-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION fis_refatoracao_nf_pck.fis_obter_sit_nf (nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_situacao_w	varchar(1):= 0;


BEGIN

begin

select	ie_situacao
into STRICT	ie_situacao_w
from	nota_fiscal
where	nr_sequencia =	nr_seq_nota_fiscal_p;

exception
when others then
	ie_situacao_w:= 0;
end;

return	ie_situacao_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION fis_refatoracao_nf_pck.fis_obter_sit_nf (nr_seq_nota_fiscal_p nota_fiscal.nr_sequencia%type) FROM PUBLIC;