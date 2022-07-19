-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_buscar_pagador_benef_js ( nr_seq_contrato_p bigint, cd_pessoa_fisica_p INOUT text, qt_pagadores_p INOUT bigint, nm_usuario_p text) AS $body$
BEGIN

select	count(1)
into STRICT	qt_pagadores_p
from	pls_contrato_pagador
where	nr_seq_contrato	= nr_seq_contrato_p
and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');

if (qt_pagadores_p	= 1) then
	select  max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_p
	from	pls_contrato_pagador
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	(cd_pessoa_fisica IS NOT NULL AND cd_pessoa_fisica::text <> '');
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_buscar_pagador_benef_js ( nr_seq_contrato_p bigint, cd_pessoa_fisica_p INOUT text, qt_pagadores_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;

