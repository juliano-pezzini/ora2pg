-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pep_consiste_qt_nasc (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_nascimento_inf_w	bigint;
qt_nascimento_real_w	bigint;
ds_mensagem_w		varchar(255);


BEGIN
select	sum(coalesce(qt_nasc_mortos,0) + coalesce(qt_nasc_vivos,0))
into STRICT	qt_nascimento_inf_w
from 	parto
where 	nr_atendimento = nr_atendimento_p;

if (coalesce(qt_nascimento_inf_w,0) > 0) then
	select	count(*)
	into STRICT	qt_nascimento_real_w
	from	nascimento
	where	nr_atendimento = nr_atendimento_p
	and		coalesce(dt_inativacao::text, '') = '';
	
	if (coalesce(qt_nascimento_real_w,0) > 0) and (coalesce(qt_nascimento_real_w,0) >= coalesce(qt_nascimento_inf_w,0)) then
		ds_mensagem_w := wheb_mensagem_pck.get_texto(333375,'ITEM='||qt_nascimento_inf_w);
	end if;
end if;

return ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pep_consiste_qt_nasc (nr_atendimento_p bigint) FROM PUBLIC;

