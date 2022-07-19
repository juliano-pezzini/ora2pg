-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prot_medic_proc_atribchange ( nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, ie_proc_cgc_p INOUT text, ie_proc_cig_p INOUT text, ds_observacao_p INOUT text, nr_seq_exame_p INOUT bigint) AS $body$
DECLARE


proc_w			varchar(3);
proc_cig_w		varchar(3);
ie_proc_cgc_w		varchar(1)	:= 'N';
ie_proc_cig_w		varchar(1)	:= 'N';
nr_seq_exame_w		bigint;
ds_observacao_w		varchar(2000);


BEGIN

proc_w	:= obter_ctrl_glic_proc(nr_seq_proc_interno_p);

if (proc_w = 'CCG') or (proc_w = 'CIG') then
	begin
	ie_proc_cgc_w	:= 'S';
	end;
end if;

select	max(a.nr_seq_exame)
into STRICT	nr_seq_exame_w
from	procedimento b,
	exame_laboratorio a
where	a.cd_procedimento = b.cd_procedimento
and	a.ie_origem_proced  = b.ie_origem_proced
and	a.ie_origem_proced  = coalesce(ie_origem_proced_p, a.ie_origem_proced)
and	a.cd_procedimento   = coalesce(cd_procedimento_p, a.cd_procedimento)
and	a.nr_seq_exame      = coalesce(null, a.nr_seq_exame)
order	by a.nm_exame;

ds_observacao_w := obter_obs_proc_prescr(nr_seq_proc_interno_p,cd_procedimento_p,ie_origem_proced_p);

ie_proc_cgc_p	:= ie_proc_cgc_w;
ie_proc_cig_p	:= ie_proc_cig_w;
ds_observacao_p	:= ds_observacao_w;
nr_seq_exame_p	:= nr_seq_exame_w;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prot_medic_proc_atribchange ( nr_seq_proc_interno_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, ie_proc_cgc_p INOUT text, ie_proc_cig_p INOUT text, ds_observacao_p INOUT text, nr_seq_exame_p INOUT bigint) FROM PUBLIC;

