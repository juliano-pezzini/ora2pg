-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_licitacao_anexo_doc (nr_Sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_licitacao_w			bigint;
nr_seq_doc_w			bigint;
nr_seq_tipo_docto_w		bigint;
nr_seq_fornec_w			bigint;


BEGIN

select	coalesce(max(nr_seq_doc),0)
into STRICT	nr_seq_doc_w
from	pessoa_juridica_doc_anexo
where	nr_Sequencia = nr_sequencia_p;

if (nr_seq_doc_w > 0) then

	select	coalesce(max(nr_seq_tipo_docto),0)
	into STRICT	nr_seq_tipo_docto_w
	from	pessoa_juridica_doc
	where	nr_sequencia = nr_seq_doc_w;

	if (nr_seq_tipo_docto_w > 0) then

		select	coalesce(max(nr_seq_fornec),0)
		into STRICT	nr_seq_fornec_w
		from	reg_lic_fornec_docto
		where	nr_seq_tipo_docto	= nr_seq_tipo_docto_w;

		if (nr_seq_fornec_w > 0) then

			select	max(nr_seq_licitacao)
			into STRICT	nr_seq_licitacao_w
			from	reg_lic_fornec
			where	nr_sequencia = nr_seq_fornec_w;
		end if;
	end if;

end if;

return	nr_seq_licitacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_licitacao_anexo_doc (nr_Sequencia_p bigint) FROM PUBLIC;

