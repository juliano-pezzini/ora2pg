-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_lib_agenda (cd_agenda_p bigint, cd_procedimento1_p bigint, cd_procedimento2_p bigint, cd_procedimento3_p bigint, cd_procedimento4_p bigint, cd_procedimento5_p bigint, cd_procedimento6_p bigint, nr_seq_proc_interno1_p bigint, nr_seq_proc_interno2_p bigint, nr_seq_proc_interno3_p bigint, nr_seq_proc_interno4_p bigint, nr_seq_proc_interno5_p bigint, nr_seq_proc_interno6_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w			varchar(1)	:= 'N';
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_grupo_proc_w			bigint;
cd_especialidade_w		bigint;
cd_area_procedimento_w		bigint;
nr_seq_proc_interno_w		bigint;

c01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		cd_grupo_proc,
		cd_especialidade,
		cd_area_procedimento
	from	estrutura_procedimento_v
	where	cd_procedimento	in (cd_procedimento1_p, cd_procedimento2_p, cd_procedimento3_p, cd_procedimento4_p, cd_procedimento5_p, cd_procedimento6_p);

c02 CURSOR FOR
	SELECT	nr_sequencia,
		cd_procedimento,
		ie_origem_proced
	from	proc_interno
	where	nr_sequencia in (nr_seq_proc_interno1_p, nr_seq_proc_interno2_p, nr_seq_proc_interno3_p, nr_seq_proc_interno4_p, nr_seq_proc_interno5_p, nr_seq_proc_interno6_p);


BEGIN

open	c01;
loop
fetch	c01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	cd_grupo_proc_w,
	cd_especialidade_w,
	cd_area_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ie_liberado_w	= 'N') then
		begin

		select	coalesce(max('S'),'N')
		into STRICT	ie_liberado_w
		from	agenda_global
		where	cd_agenda	= cd_agenda_p
		and	coalesce(cd_area_proc, cd_area_procedimento_w) = cd_area_procedimento_w
		and	coalesce(cd_especialidade, cd_especialidade_w) = cd_especialidade_w
		and	coalesce(cd_grupo_proc, cd_grupo_proc_w)	  = cd_grupo_proc_w
		and	coalesce(cd_procedimento, cd_procedimento_w)	  = cd_procedimento_w
		and	coalesce(ie_origem_proced, ie_origem_proced_w) = ie_origem_proced_w;



		end;
	end if;

	end;
end loop;
close 	c01;

open	c02;
loop
fetch	c02 into
	nr_seq_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	if (ie_liberado_w	= 'N') then
		begin

		select	coalesce(max('S'),'N')
		into STRICT	ie_liberado_w
		from	agenda_global
		where	cd_agenda		= cd_agenda_p
		and	nr_seq_proc_interno	= nr_seq_proc_interno_w;

		if (ie_liberado_w		= 'N') then
			select	cd_grupo_proc,
				cd_especialidade,
				cd_area_procedimento
			into STRICT	cd_grupo_proc_w,
				cd_especialidade_w,
				cd_area_procedimento_w
			from	estrutura_procedimento_v
			where	cd_procedimento		= cd_procedimento_w
			and	ie_origem_proced	= ie_origem_proced_w;

			select	coalesce(max('S'),'N')
			into STRICT	ie_liberado_w
			from	agenda_global
			where	cd_agenda	= cd_agenda_p
			and	coalesce(cd_area_proc, cd_area_procedimento_w) = cd_area_procedimento_w
			and	coalesce(cd_especialidade, cd_especialidade_w) = cd_especialidade_w
			and	coalesce(cd_grupo_proc, cd_grupo_proc_w)	  = cd_grupo_proc_w
			and	coalesce(cd_procedimento, cd_procedimento_w)	  = cd_procedimento_w
			and	coalesce(ie_origem_proced, ie_origem_proced_w) = ie_origem_proced_w;


		end if;

		end;
	end if;


	end;
end loop;
close c02;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_lib_agenda (cd_agenda_p bigint, cd_procedimento1_p bigint, cd_procedimento2_p bigint, cd_procedimento3_p bigint, cd_procedimento4_p bigint, cd_procedimento5_p bigint, cd_procedimento6_p bigint, nr_seq_proc_interno1_p bigint, nr_seq_proc_interno2_p bigint, nr_seq_proc_interno3_p bigint, nr_seq_proc_interno4_p bigint, nr_seq_proc_interno5_p bigint, nr_seq_proc_interno6_p bigint) FROM PUBLIC;

