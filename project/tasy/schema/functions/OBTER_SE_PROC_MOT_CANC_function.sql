-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_mot_canc (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_motivo_canc_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tratamento_w		varchar(1) := 'S';
cd_area_proc_w		bigint;
cd_especial_proc_w	bigint;
cd_grupo_proc_w		bigint;
qt_reg_w			bigint;
qt_reg2_w			bigint;

BEGIN


		select	cd_area_procedimento,
				cd_especialidade,
				cd_grupo_proc
		into STRICT	cd_area_proc_w,
				cd_especial_proc_w,
				cd_grupo_proc_w
		from	estrutura_procedimento_v
		where	cd_procedimento	= cd_procedimento_p
		and		ie_origem_proced	= ie_origem_proced_p;
		
		select count(*)
		into STRICT   qt_reg_w
		from	MOTIVO_CANCEL_PROC_REGRA
		where	coalesce(cd_area_procedimento, cd_area_proc_w)		 = cd_area_proc_w
		and	coalesce(cd_especialidade, cd_especial_proc_w)		 = cd_especial_proc_w
		and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			 	 = cd_grupo_proc_w
		and	coalesce(cd_procedimento, coalesce(cd_procedimento_p,0))	 = coalesce(cd_procedimento_p,0)
		and	coalesce(ie_origem_proced, coalesce(ie_origem_proced_p,0))	 = coalesce(ie_origem_proced_p,0)
		and	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0))	 = coalesce(nr_seq_proc_interno_p,0)
		and	nr_seq_motivo_cancel = nr_seq_motivo_canc_p;
		
		if (qt_reg_w > 0) then
			begin
			
				 select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
				 into STRICT   ie_tratamento_w
				 from	MOTIVO_CANCEL_PROC_REGRA
				 where	coalesce(cd_area_procedimento, cd_area_proc_w)		 = cd_area_proc_w
				 and	coalesce(cd_especialidade, cd_especial_proc_w)		 = cd_especial_proc_w
				 and	coalesce(cd_grupo_proc, cd_grupo_proc_w)			 	 = cd_grupo_proc_w
				 and	coalesce(cd_procedimento, coalesce(cd_procedimento_p,0))	 = coalesce(cd_procedimento_p,0)
				 and	coalesce(ie_origem_proced, coalesce(ie_origem_proced_p,0))	 = coalesce(ie_origem_proced_p,0)
				 and	coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0))	 = coalesce(nr_seq_proc_interno_p,0)
				 and	nr_seq_motivo_cancel = nr_seq_motivo_canc_p;
			
			end;
			end if;
		

 return ie_tratamento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_mot_canc (cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_motivo_canc_p bigint) FROM PUBLIC;

