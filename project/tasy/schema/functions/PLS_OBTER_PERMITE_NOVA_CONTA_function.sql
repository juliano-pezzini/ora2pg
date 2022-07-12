-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_permite_nova_conta ( nr_seq_protocolo_p bigint) RETURNS varchar AS $body$
DECLARE


ie_status_w			varchar(2);
qt_demonstrativo_w		bigint;
ie_alterar_conta_w		varchar(1)	:= 'S';


BEGIN
select	max(ie_status)
into STRICT	ie_status_w
from	pls_protocolo_conta
where	nr_sequencia	= nr_seq_protocolo_p;

select	count(*)
into STRICT	qt_demonstrativo_w
from	pls_prot_conta_titulo
where	nr_seq_protocolo	= nr_seq_protocolo_p;

if (ie_status_w = '3') or (ie_status_w = '4') or (ie_status_w = '6') or (qt_demonstrativo_w	> 0) then
	ie_alterar_conta_w	:= 'N';
end if;
return	ie_alterar_conta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_permite_nova_conta ( nr_seq_protocolo_p bigint) FROM PUBLIC;
