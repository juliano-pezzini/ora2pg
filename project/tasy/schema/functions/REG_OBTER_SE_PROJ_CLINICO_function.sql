-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_obter_se_proj_clinico (nr_seq_proj_p bigint) RETURNS varchar AS $body$
DECLARE


ie_clinico_w	varchar(1);


BEGIN

select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
into STRICT	ie_clinico_w
from 	des_requisito a,
		des_requisito_item b,
		reg_product_requirement c
where	a.nr_sequencia = b.nr_seq_requisito
and		b.nr_seq_pr= c.nr_sequencia
and		coalesce(c.ie_clinico, 'N') = 'S'
and		a.nr_seq_projeto = nr_seq_proj_p;

return	ie_clinico_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_obter_se_proj_clinico (nr_seq_proj_p bigint) FROM PUBLIC;
