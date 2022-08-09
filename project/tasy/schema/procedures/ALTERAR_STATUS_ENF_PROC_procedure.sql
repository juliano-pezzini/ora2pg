-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_status_enf_proc ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_status_p text default ' ', ds_observacao_enf_p text default ' ') AS $body$
DECLARE

qt_status_w bigint;
qt_reg_w 	bigint;


BEGIN 
 
select	count(*) 
into STRICT	qt_reg_w 
from	prescr_proc_enf 
where	nr_sequencia = nr_sequencia_p 
and		nr_prescricao = nr_prescricao_p;
 
if (cd_status_p <> ' ') then			 
	select count(*) 
	into STRICT  qt_status_w 
	from  proc_status_enf 
	where cd_status = cd_status_p 
	and  coalesce(ie_stuacao,'A') = 'A';
end if;
 
if (qt_reg_w > 0) then 
	if (cd_status_p <> ' ') then 
 
		if (qt_status_w > 0) then 
			update 	prescr_proc_enf 
			set 	ie_status_enf = cd_status_p 
			where  nr_prescricao = nr_prescricao_p  
			and   nr_sequencia = nr_sequencia_p;
		end if;
	end if;
 
	if (ds_observacao_enf_p <> ' ') then 
		update 	prescr_proc_enf 
		set 	ds_observacao_enf = ds_observacao_enf_p 
		where  nr_prescricao = nr_prescricao_p  
		and   nr_sequencia = nr_sequencia_p;
	end if;
	 
elsif (qt_status_w > 0) then 
 
	insert into prescr_proc_enf(nr_sequencia, 
			 nr_prescricao, 
			 dt_atualizacao, 
			 nm_usuario, 
			 dt_atualizacao_nrec, 
			 nm_usuario_nrec, 
			 ie_status_enf, 
			 ds_observacao_enf) 
	values ( nr_sequencia_p, 
			 nr_prescricao_p, 
			 clock_timestamp(), 
			 nm_usuario_p, 
			 clock_timestamp(), 
			 nm_usuario_p, 
			 cd_status_p, 
			 ds_observacao_enf_p);
			 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_status_enf_proc ( nr_prescricao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_status_p text default ' ', ds_observacao_enf_p text default ' ') FROM PUBLIC;
