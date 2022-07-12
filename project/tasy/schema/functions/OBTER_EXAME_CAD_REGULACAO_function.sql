-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_exame_cad_regulacao (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_exame_w		varchar(255);
nr_seq_exame_w		bigint;
ds_exame_sem_cad_w	varchar(255);
nr_seq_exame_lab_w	bigint;
nr_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

BEGIN

select	nr_seq_exame_cad,
	nr_seq_exame,
	nr_seq_proc_interno,
	cd_procedimento,
	ie_origem_proced
into STRICT	nr_seq_exame_w,
	nr_seq_exame_lab_w,
	nr_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w
from	regra_regulacao
where	nr_sequencia	= nr_sequencia_p;

if (nr_seq_exame_w > 0) then
	begin
	select	ds_exame
	into STRICT	ds_exame_w
	from	med_exame_padrao
	where	nr_sequencia	= nr_seq_exame_w;
	end;
elsif (ds_exame_sem_cad_w IS NOT NULL AND ds_exame_sem_cad_w::text <> '') then
	begin
	ds_exame_w	:= ds_exame_sem_cad_w;
	end;
elsif (nr_seq_exame_lab_w IS NOT NULL AND nr_seq_exame_lab_w::text <> '') then
	begin
	ds_exame_w	:= substr(obter_desc_exame(nr_seq_exame_lab_w),1,255);
	end;
elsif (nr_proc_interno_w IS NOT NULL AND nr_proc_interno_w::text <> '') then
	begin
	ds_exame_w	:= substr( obter_desc_proc_interno(nr_proc_interno_w),1,255);
	end;
elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
	begin
	ds_exame_w	:= substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
	end;
end if;

return	ds_exame_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_exame_cad_regulacao (nr_sequencia_p bigint) FROM PUBLIC;

