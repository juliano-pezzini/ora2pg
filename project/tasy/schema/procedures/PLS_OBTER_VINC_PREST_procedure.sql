-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_vinc_prest ( cd_medico_p text, ie_tipo_vinculo_p INOUT text, nr_seq_prest_medico_p bigint) AS $body$
DECLARE


ie_tipo_vinculo_w	varchar(1);
nr_seq_prestador_ref_w	bigint;


BEGIN

begin
	select	nr_seq_prestador_ref
	into STRICT	nr_seq_prestador_ref_w
	from	pls_prestador_medico
	where	nr_sequencia = nr_seq_prest_medico_p;
exception
when others then
	nr_seq_prestador_ref_w :=0;
end;
if (coalesce(nr_seq_prestador_ref_w,0) > 0) then
	select	max(ie_tipo_vinculo)
	into STRICT	ie_tipo_vinculo_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_ref_w;
else
	select	max(ie_tipo_vinculo)
	into STRICT	ie_tipo_vinculo_w
	from	pls_prestador
	where	cd_pessoa_fisica = cd_medico_p;
end if;
if (coalesce(ie_tipo_vinculo_w,'X') <> 'X') then

	update	pls_prestador_medico
	set	ie_tipo_vinculo = ie_tipo_vinculo_w
	where	nr_sequencia 	= nr_seq_prest_medico_p;

	ie_tipo_vinculo_p := ie_tipo_vinculo_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_vinc_prest ( cd_medico_p text, ie_tipo_vinculo_p INOUT text, nr_seq_prest_medico_p bigint) FROM PUBLIC;

