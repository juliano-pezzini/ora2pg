-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sequencia_item_perfil (cd_perfil_p bigint, nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


qtde_w	smallint;
nr_retorno_w	perfil_item_pepo.nr_sequencia%type;

BEGIN

with counter as (
select	count(*) qtde
from		perfil_item_pront
where	cd_perfil = cd_perfil_p
and		nr_sequencia = nr_seq_item_p

union

select	count(*) qtde
from		perfil_item_pepo
where	cd_perfil = cd_perfil_p
and		nr_sequencia = nr_seq_item_p)
select max(a.qtde)
into STRICT	qtde_w
from counter a;

if (qtde_w = 0) then
	nr_retorno_w	:= null;
else
	nr_retorno_w	:= nr_seq_item_p;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sequencia_item_perfil (cd_perfil_p bigint, nr_seq_item_p bigint) FROM PUBLIC;

