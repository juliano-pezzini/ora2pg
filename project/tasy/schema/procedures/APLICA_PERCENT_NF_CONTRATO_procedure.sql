-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aplica_percent_nf_contrato (nr_seq_contrato_nf_p bigint, vl_percent_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_pagto_w	contrato_regra_nf.vl_pagto%type;


BEGIN

begin

select (dividir(coalesce(vl_pagto,0),100) * vl_percent_p) + vl_pagto
into STRICT	vl_pagto_w
from	contrato_regra_nf
where	nr_sequencia = nr_seq_contrato_nf_p;

exception
when others then
	vl_pagto_w := 0;
end;

update	contrato_regra_nf
set 	vl_pagto = vl_pagto_w
where 	nr_sequencia = nr_seq_contrato_nf_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aplica_percent_nf_contrato (nr_seq_contrato_nf_p bigint, vl_percent_p bigint, nm_usuario_p text) FROM PUBLIC;

