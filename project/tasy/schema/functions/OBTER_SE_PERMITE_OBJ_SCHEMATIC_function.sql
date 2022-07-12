-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_obj_schematic (ie_tipo_obj_atual_p text, ie_tipo_obj_novo_p text, nr_seq_tipo_sch_atual_p bigint default null, nr_seq_tipo_sch_novo_p bigint default null, nr_seq_bo_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_permite_w		varchar(10) := 'N';
nr_seq_regra_w		bigint;
qt_regra_w		bigint;
nr_seq_regra_obj_w	bigint;
nr_seq_tipo_sch_atual_w	bigint;
nr_seq_tipo_sch_novo_w	bigint;


BEGIN

if (nr_seq_tipo_sch_novo_p = '0') then
	nr_seq_tipo_sch_novo_w	:= null;
else
	nr_seq_tipo_sch_novo_w	:= (nr_seq_tipo_sch_novo_p)::numeric;
end if;

select	max(nr_sequencia)
into STRICT	nr_seq_regra_w
from	REGRA_SCHEMATIC
where	ie_situacao 	= 'A';
--and	dt_liberacao 	is not null;
if (nr_seq_regra_w > 0) then

	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_obj_w
	from	regra_schematic_obj a
	where	a.nr_seq_regra		= nr_seq_regra_w
	and	a.ie_tipo_objeto	= ie_tipo_obj_atual_p
	and	a.nr_seq_tipo_schematic	= nr_seq_tipo_sch_atual_p;

	if (coalesce(nr_seq_regra_obj_w,0) > 0) and (coalesce(nr_seq_tipo_sch_novo_w,0) > 0) then
		select	count(*)
		into STRICT	qt_regra_w
		from	regra_schematic_obj_filho
		where	nr_seq_regra_obj	= nr_seq_regra_obj_w
		and	ie_tipo_objeto		= ie_tipo_obj_novo_p
		and	coalesce(nr_seq_tipo_schematic,nr_seq_tipo_sch_novo_w)	= nr_seq_tipo_sch_novo_w;

	else

		select	count(*)
		into STRICT	qt_regra_w
		from	regra_schematic_obj a
		where	a.nr_seq_regra		= nr_seq_regra_w
		and	a.ie_tipo_objeto	= ie_tipo_obj_atual_p
		and (coalesce(a.nr_seq_tipo_schematic::text, '') = '' or a.nr_seq_tipo_schematic = nr_seq_tipo_sch_atual_p)
		and	exists (SELECT	1
				from	regra_schematic_obj_filho b
				where	b.nr_seq_regra_obj	= a.nr_sequencia
				and	b.ie_tipo_objeto	= ie_tipo_obj_novo_p
				and	coalesce(b.nr_seq_tipo_schematic,coalesce(nr_seq_tipo_sch_novo_w,0)) = coalesce(nr_seq_tipo_sch_novo_w,coalesce(b.nr_seq_tipo_schematic,0)));
	end if;

	if (qt_regra_w > 0) then
		ie_permite_w	:= 'S';
	end if;

end if;

--Habilitar o navegador de breadcrumb de DBPanel apenas para o scehmatic 6/6 e 12
if (nr_seq_tipo_sch_atual_p > 0) and (nr_seq_tipo_sch_atual_p not in (22,23)) and (ie_tipo_obj_atual_p = 'SCH') and (ie_tipo_obj_novo_p = 'MN') then
	ie_permite_w	:= 'N';
end if;

if (ie_tipo_obj_atual_p = 'WDLG') and (ie_tipo_obj_novo_p = 'C') and (coalesce(nr_seq_tipo_sch_novo_w::text, '') = '' or nr_seq_tipo_sch_novo_w = 90)then
	ie_permite_w	:= 'S';
end if;

if (ie_tipo_obj_atual_p = 'FBO') and (ie_tipo_obj_novo_p = 'C') and (coalesce(nr_seq_tipo_sch_atual_p,0) = 0)then
	ie_permite_w	:= 'S';
end if;

if (ie_tipo_obj_atual_p = 'WSCB') and (ie_tipo_obj_novo_p = 'C') and (coalesce(nr_seq_tipo_sch_novo_w::text, '') = '' or nr_seq_tipo_sch_novo_w = 98)then
	ie_permite_w	:= 'S';
end if;

if (ie_tipo_obj_atual_p = 'WAE') and (ie_tipo_obj_novo_p = 'C') and (coalesce(nr_seq_tipo_sch_novo_w::text, '') = '' or nr_seq_tipo_sch_novo_w = 112)then
	ie_permite_w	:= 'S';
end if;

if (ie_tipo_obj_atual_p = 'FSCH') and (ie_tipo_obj_novo_p = 'FSCH') then
	ie_permite_w	:= 'S';
end if;

--Impedir que sejam adicionados painéis dentro de BO
if (coalesce(nr_seq_bo_p,0) > 0) and (ie_tipo_obj_novo_p = 'P') then
	ie_permite_w := 'N';
end if;

return ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_obj_schematic (ie_tipo_obj_atual_p text, ie_tipo_obj_novo_p text, nr_seq_tipo_sch_atual_p bigint default null, nr_seq_tipo_sch_novo_p bigint default null, nr_seq_bo_p bigint default null) FROM PUBLIC;

