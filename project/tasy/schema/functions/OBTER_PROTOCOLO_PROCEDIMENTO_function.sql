-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_protocolo_procedimento ( cd_procedimento_p text, cd_tipo_protocolo_p text, ie_origem_proced_p text, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint) RETURNS bigint AS $body$
DECLARE



cd_protocolo_w			bigint;
cd_tipo_protocolo_w		varchar(4000);

BEGIN

cd_tipo_protocolo_w	:= substr(cd_tipo_protocolo_p, 1, 4000);
if (position('-' in cd_tipo_protocolo_w) > 0) then
	cd_tipo_protocolo_w	:= replace(cd_tipo_protocolo_w, '-', ',');
end if;


if (coalesce(cd_procedimento_p, 'X') <> 'X') and (coalesce(ie_origem_proced_p, 'X') <> 'X') then
	begin

	if (nr_seq_proc_interno_p > 0) then
		begin

		select	max(a.cd_protocolo)
		into STRICT	cd_protocolo_w
	        	from	protocolo a,
				protocolo_proc_interno b
	        	where	a.cd_protocolo = b.cd_protocolo
			and	substr(obter_se_contido_char(a.cd_tipo_protocolo, cd_tipo_protocolo_w), 1, 1) = 'S'
	        	and	b.nr_seq_proc_interno = nr_seq_proc_interno_p  LIMIT 1;
		end;
	elsif (nr_seq_exame_p > 0) then
		begin

		select	max(a.cd_protocolo)
		into STRICT	cd_protocolo_w
		from	protocolo a,
			protocolo_exame b
		where	a.cd_protocolo = b.cd_protocolo
		and	substr(obter_se_contido_char(a.cd_tipo_protocolo, cd_tipo_protocolo_w), 1, 1) = 'S'
		and	b.nr_seq_exame = nr_seq_exame_p  LIMIT 1;

		end;
	else
		begin
		select	max(a.cd_protocolo)
		into STRICT	cd_protocolo_w
		from	protocolo a,
			protocolo_procedimento b
		where	a.cd_protocolo = b.cd_protocolo
		and	substr(obter_se_contido_char(a.cd_tipo_protocolo, cd_tipo_protocolo_w), 1, 1) = 'S'
		and	b.cd_procedimento = cd_procedimento_p
		and	b.ie_origem_proced = ie_origem_proced_p  LIMIT 1;
		end;
	end if;
	end;
end if;

return	cd_protocolo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_protocolo_procedimento ( cd_procedimento_p text, cd_tipo_protocolo_p text, ie_origem_proced_p text, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
