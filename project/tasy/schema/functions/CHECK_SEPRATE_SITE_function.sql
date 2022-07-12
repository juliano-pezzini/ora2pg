-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_seprate_site ( nr_voucher_num_p bigint , nr_account_p bigint , cd_procedimento_p text, ie_origem_p bigint) RETURNS varchar AS $body$
DECLARE


nr_procedure_count_w   	bigint;
cd_mbs_code_w		varchar(5);
nr_proc_count_w		bigint;
result_w 		varchar(2);
ie_nt_related_w		varchar(1) := 'N';
ie_nt_comparsion_w	varchar(1) := 'N';
nr_group_count_w	bigint;
nr_proc_group_w		procedimento.cd_grupo_proc%type;
nr_group_w		procedimento.cd_grupo_proc%type;
cd_rest_val_w		prescr_procedimento.nr_doc_convenio%type;

BEGIN


select	max(p.cd_grupo_proc),
	max(coalesce(count(p.cd_grupo_proc),0))
into STRICT	nr_proc_group_w,
	nr_group_count_w


from 	prescr_procedimento pp,
	prescr_medica b ,
	atendimento_paciente c ,
	conta_paciente d,
	procedimento p

where   d.nr_interno_conta =  nr_account_p
and   	d.nr_atendimento   = c.nr_atendimento
and   	b.nr_atendimento   = c.nr_atendimento
and   	b.nr_prescricao    = pp.nr_prescricao
and     p.cd_procedimento =  pp.cd_procedimento
group by	p.cd_grupo_proc having count(p.cd_grupo_proc ) > 1;

select	cd_grupo_proc
into STRICT 	nr_group_w
from 	procedimento
where 	cd_procedimento = cd_procedimento_p;

select	max(pp.nr_doc_convenio)
into STRICT	cd_rest_val_w
from 	prescr_procedimento pp,
	prescr_medica b ,
	atendimento_paciente c ,
	conta_paciente d


where   d.nr_interno_conta = nr_account_p
and   	d.nr_atendimento   = c.nr_atendimento
and   	b.nr_atendimento   = c.nr_atendimento
and   	b.nr_prescricao    = pp.nr_prescricao
and     cd_procedimento = cd_procedimento_p;



if (nr_proc_group_w =  nr_group_w) then
	select	cd_procedimento_loc
	into STRICT 	cd_mbs_code_w
	from	procedimento
	where  	cd_procedimento  = cd_procedimento_p
	and 	ie_origem_proced = ie_origem_p;

	select	count(*)
	into STRICT	nr_proc_count_w
	from	dbs_item a, procedimento p
	where 	a.cd_item = p.cd_procedimento_loc
  and   p.cd_grupo_proc = nr_proc_group_w
	and 	nr_seq_voucher 	= nr_voucher_num_p;

if ( nr_proc_count_w >=1 and (cd_rest_val_w IS NOT NULL AND cd_rest_val_w::text <> '')) then
	result_w := cd_rest_val_w;
	return result_w;
end if;
if (nr_proc_count_w >= 1) then
	result_w := 'SP';
end if;
else
	result_w := cd_rest_val_w;

end if;
return  result_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_seprate_site ( nr_voucher_num_p bigint , nr_account_p bigint , cd_procedimento_p text, ie_origem_p bigint) FROM PUBLIC;

