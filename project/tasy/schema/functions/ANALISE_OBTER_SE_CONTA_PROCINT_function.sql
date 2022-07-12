-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (nr_seq_proc_interno 	double precision);


CREATE OR REPLACE FUNCTION analise_obter_se_conta_procint ( nr_interno_conta_p bigint, ds_filtro_procedimento_p text) RETURNS varchar AS $body$
DECLARE

type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;
qt_duracao_w			double precision;
ds_filtro_procedimento_w	varchar(4000);
i 			 	integer;
ie_proc_conta_w			varchar(10);
BEGIN
ds_filtro_procedimento_w	:= ds_filtro_procedimento_p;
ds_filtro_procedimento_w	:= replace(ds_filtro_procedimento_w,')','');
ds_filtro_procedimento_w	:= replace(ds_filtro_procedimento_w,'(','');
ds_filtro_procedimento_w	:= replace(ds_filtro_procedimento_w,chr(39),'');
i := 0;
while(length(ds_filtro_procedimento_w) > 0) loop
	begin
	i	:= i+1;
	if (position(',' in ds_filtro_procedimento_w)	>0)  then
		Vetor_w[i].nr_seq_proc_interno	:= somente_numero(substr(ds_filtro_procedimento_w,1,position(',' in ds_filtro_procedimento_w) ));
		ds_filtro_procedimento_w	:= substr(ds_filtro_procedimento_w,position(',' in ds_filtro_procedimento_w)+1,40000);

	else
		Vetor_w[i].nr_seq_proc_interno	:= somente_numero(ds_filtro_procedimento_w);
		ds_filtro_procedimento_w	:= null;
	end if;

	end;
end loop;

ie_proc_conta_w	:= 'S';

for j in 1..Vetor_w.count loop
	begin
	select	'S'
	into STRICT	ie_proc_conta_w
	from	procedimento_paciente
	where	nr_interno_conta	= nr_interno_conta_p
	and	coalesce(cd_motivo_exc_conta::text, '') = ''
	and	nr_seq_proc_interno		= Vetor_w[j].nr_seq_proc_interno;
	exception
	when no_data_found then
		ie_proc_conta_w	:= 'N';
		exit;
	when others then
		ie_proc_conta_w	:= 'S';
	end;
end loop;
return ie_proc_conta_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION analise_obter_se_conta_procint ( nr_interno_conta_p bigint, ds_filtro_procedimento_p text) FROM PUBLIC;

