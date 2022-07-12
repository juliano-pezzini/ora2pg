-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_resc_prog_contrato ( nr_seq_contrato_p bigint ) RETURNS varchar AS $body$
DECLARE

			
ie_situacao_w	varchar(1);
qt_resc_prog_contrato_w	bigint;


BEGIN
ie_situacao_w := 'N';

select	count(1)
into STRICT	qt_resc_prog_contrato_w
from 	pls_rescisao_contrato
where 	nr_seq_contrato = nr_seq_contrato_p
and	ie_situacao = 'A';

if (qt_resc_prog_contrato_w > 0) then
	ie_situacao_w := 'S';
end if;

return	ie_situacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_resc_prog_contrato ( nr_seq_contrato_p bigint ) FROM PUBLIC;

