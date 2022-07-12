-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_justificativa_prescr_onc ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_justificativa_w			varchar(254) := '';
qt_interacao_w				bigint;
qt_interacao_onc_w			bigint;
cont_w						bigint := 0;

nr_prescricao_ww			paciente_atendimento.nr_prescricao%type;

nr_prescricao_w 			paciente_atendimento.nr_prescricao%type;
nr_ciclo_w					paciente_atendimento.nr_ciclo%type;
ds_dia_ciclo_w				paciente_atendimento.ds_dia_ciclo%type;
nr_seq_paciente_w			paciente_atendimento.nr_seq_paciente%type;

cd_material_w				prescr_medica_interacao.cd_material%type;
cd_material_interacao_w		prescr_medica_interacao.cd_material_interacao%type;

c01 CURSOR FOR
    SELECT a.nr_prescricao
	from   paciente_atendimento a
    where  (a.nr_prescricao IS NOT NULL AND a.nr_prescricao::text <> '')
    and	   a.nr_seq_paciente 	= nr_seq_paciente_w
    and    a.nr_ciclo 			= nr_ciclo_w
	and	   exists (SELECT 1
		   		   from	  prescr_medica x
				   where  x.nr_prescricao = a.nr_prescricao
				   and	  (x.ds_justificativa IS NOT NULL AND x.ds_justificativa::text <> '')
				   and	  x.nr_prescricao <> nr_prescricao_p);
	
c02 CURSOR FOR
	SELECT 	cd_material,
			cd_material_interacao
	from	prescr_medica_interacao
	where	nr_prescricao = nr_prescricao_p;


BEGIN

select 	max(nr_prescricao),
	   	max(nr_ciclo),
	   	max(ds_dia_ciclo),
	   	max(nr_seq_paciente)
into STRICT	nr_prescricao_w,
		nr_ciclo_w,
		ds_dia_ciclo_w,
		nr_seq_paciente_w
from   	paciente_atendimento
where  	nr_prescricao = nr_prescricao_p;

select 	count(*)
into STRICT	qt_interacao_w
from   	prescr_medica_interacao
where	nr_prescricao = nr_prescricao_p;

open c01;
loop
fetch c01 into
	nr_prescricao_ww;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	select 	count(*)
	into STRICT	qt_interacao_onc_w
	from   	prescr_medica_interacao
	where	nr_prescricao = nr_prescricao_ww;
	
	if (qt_interacao_w = qt_interacao_onc_w) then
		begin
		
		cont_w	:= 0;
		
		open c02;
		loop
		fetch c02 into
				cd_material_w,
				cd_material_interacao_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		
		select 	count(*)
		into STRICT 	cont_w
		from 	prescr_medica_interacao a
		where 	a.nr_Prescricao 	= 	nr_prescricao_ww
		and 	a.cd_material 		= 	cd_material_w
		and 	cd_material_interacao = cd_material_interacao_w;
		
		if (cont_w = 0) then
			exit;
		end if;
		
		end;
		end loop;
		close c02;
		
		end;
	end if;
	
	if (cont_w <> 0) then
		
		select  substr(ds_justificativa,1,254)
		into STRICT	ds_justificativa_w
		from	prescr_medica
		where 	nr_prescricao = nr_prescricao_ww;
		
		exit;
	
	end if;
	
	end;
end loop;
close c01;

return	ds_justificativa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_justificativa_prescr_onc ( nr_prescricao_p bigint) FROM PUBLIC;

