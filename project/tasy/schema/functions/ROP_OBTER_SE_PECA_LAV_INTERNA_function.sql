-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rop_obter_se_peca_lav_interna ( nr_seq_roupa_p bigint) RETURNS varchar AS $body$
DECLARE


ie_interna_w			varchar(1) := 'N';
ie_tipo_local_w			varchar(15);


BEGIN

select	rop_obter_tipo_local(rop_obter_local_atual_roupa(nr_seq_roupa_p))
into STRICT	ie_tipo_local_w
;

if (upper(ie_tipo_local_w) = 'LI') then
	ie_interna_w := 'S';
end if;

return	ie_interna_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rop_obter_se_peca_lav_interna ( nr_seq_roupa_p bigint) FROM PUBLIC;

