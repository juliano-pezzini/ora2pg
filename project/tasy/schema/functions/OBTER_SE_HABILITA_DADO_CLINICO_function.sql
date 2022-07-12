-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_habilita_dado_clinico (nr_seq_procedimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_habilitado_w	bigint 	:= 0;
ie_habilitado_w	varchar(1)	:= 'N';


BEGIN
if (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	if (coalesce(ie_opcao_p,'MUP') = 'MUP') then
		select	coalesce(count(*),0)
		into STRICT	qt_habilitado_w
		from	hem_medic a
		where	ie_uso_medic	= 'P'
		and	not exists (SELECT	1
					from	hem_proc_medic y,
						hem_proc x
					where	a.nr_sequencia	= y.nr_seq_medic
					and	y.ie_uso_medic	= 'P'
					and	y.nr_seq_proc		= x.nr_sequencia
					and	x.nr_sequencia	= nr_seq_procedimento_p
					and	x.cd_pessoa_fisica	= cd_pessoa_fisica_p);
	elsif (coalesce(ie_opcao_p,'MUP') = 'MUE') then
		select	coalesce(count(*),0)
		into STRICT	qt_habilitado_w
		from	hem_medic a
		where	ie_uso_medic	= 'E'
		and	not exists (SELECT	1
					from	hem_proc_medic y,
						hem_proc x
					where	a.nr_sequencia	= y.nr_seq_medic
					and	y.ie_uso_medic	= 'E'
					and	y.nr_seq_proc		= x.nr_sequencia
					and	x.nr_sequencia	= nr_seq_procedimento_p
					and	x.cd_pessoa_fisica	= cd_pessoa_fisica_p);
	elsif (coalesce(ie_opcao_p,'MUP') = 'E') then
		select	coalesce(count(*),0)
		into STRICT	qt_habilitado_w
		from	hem_exame a
		where	not exists (SELECT	1
					from	hem_proc_exame y,
						hem_proc x
					where	a.nr_sequencia	= y.nr_seq_exame
					and	y.nr_seq_proc		= x.nr_sequencia
					and	x.nr_sequencia	= nr_seq_procedimento_p
					and	x.cd_pessoa_fisica	= cd_pessoa_fisica_p);
	elsif (coalesce(ie_opcao_p,'MUP') = 'I') then
		select	coalesce(count(*),0)
		into STRICT	qt_habilitado_w
		from	hem_dado_clinico a
		where	not exists (SELECT	1
					from	hem_proc_dado_clinico y,
						hem_proc x
					where	a.nr_sequencia	= y.nr_seq_dado_clinico
					and	y.nr_seq_proc		= x.nr_sequencia
					and	x.nr_sequencia	= nr_seq_procedimento_p
					and	x.cd_pessoa_fisica	= cd_pessoa_fisica_p);
	end if;

if (coalesce(qt_habilitado_w,0) > 0) then
	ie_habilitado_w	:= 'S';
end if;
end if;

return ie_habilitado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_habilita_dado_clinico (nr_seq_procedimento_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;
