-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_se_existe_tipo_doc ( nr_seq_fornec_docto_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_w		varchar(1)	:= 'N';
cd_cgc_w		reg_lic_fornec.cd_cgc_fornec%type;
nr_seq_tipo_docto_w	reg_lic_fornec_docto.nr_seq_tipo_docto%type;
nr_seq_fornec_w		reg_lic_fornec_docto.nr_seq_fornec%type;


BEGIN

select	nr_seq_tipo_docto,
	nr_seq_fornec
into STRICT	nr_seq_tipo_docto_w,
	nr_seq_fornec_w
from	reg_lic_fornec_docto
where	nr_sequencia = nr_seq_fornec_docto_p;

select	cd_cgc_fornec
into STRICT	cd_cgc_w
from	reg_lic_fornec
where	nr_sequencia = nr_seq_fornec_w;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_existe_w
from	pessoa_juridica_doc
where	nr_seq_tipo_docto = nr_seq_tipo_docto_w
and	cd_cgc = cd_cgc_w;

return	ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_se_existe_tipo_doc ( nr_seq_fornec_docto_p bigint) FROM PUBLIC;
