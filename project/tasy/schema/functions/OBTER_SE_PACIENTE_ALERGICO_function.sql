-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_paciente_alergico ( nr_atendimento_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(4000)	:= '';
qt_reg_w			bigint;
nr_proc_interno_w	bigint;
cd_material_w		bigint;
cd_pessoa_fisica_w	varchar(10);
ds_material_w		varchar(255);

C01 CURSOR FOR 
	SELECT	cd_material 
	from	proc_int_mat_prescr 
	where	NR_SEQ_PROC_INTERNO  = nr_proc_interno_w;


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_exame_p IS NOT NULL AND nr_seq_exame_p::text <> '') then	 
	 
	Select nr_proc_interno 
	into STRICT	nr_proc_interno_w 
	from	med_exame_padrao 
	where	nr_sequencia = nr_seq_exame_p;
	 
	if (nr_proc_interno_w IS NOT NULL AND nr_proc_interno_w::text <> '') then	 
	 
		cd_pessoa_fisica_w := obter_pessoa_atendimento(nr_atendimento_p,'C');
 
		open C01;
		loop 
		fetch C01 into	 
			cd_material_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin 
			 
			Select count(*) 
			into STRICT	qt_reg_w 
			from	PACIENTE_ALERGIA 
			where	cd_pessoa_fisica = cd_pessoa_fisica_w 
			and		coalesce(dt_inativacao::text, '') = '' 
			and 	coalesce(dt_fim::text, '') = '' 
			and		cd_material = cd_material_w;
			 
			 
			If (qt_reg_w > 0) then 
			 
				ds_material_w := substr(obter_desc_material(cd_material_w),1,254);
			 
				if (coalesce(ds_retorno_w::text, '') = '') then 
						ds_retorno_w := wheb_mensagem_pck.get_texto(309371)||Chr(10)||' - '||ds_material_w; -- O paciente possui alergia aos seguintes materiais: 
				else			
						ds_retorno_w := substr(ds_retorno_w||Chr(10)||' - '||ds_material_w,1,4000);
					 
				end if;
			 
			end if;
			 
			end;
		end loop;
		close C01;	
		 
	end if;	
	 
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_paciente_alergico ( nr_atendimento_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;

