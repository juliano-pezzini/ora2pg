-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_agenda_conv_espec (cd_agenda_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_consistencia_p INOUT text) AS $body$
DECLARE

 
cd_profissional_w	varchar(10);
cd_especialidade_w	integer;	
ds_especialidade_w	varchar(255);
nr_seq_regra_w		bigint;	
ie_tipo_consistencia_w	varchar(3);	
ds_especialidades_w	varchar(255);
				
C01 CURSOR FOR 
	SELECT	a.cd_especialidade, 
		b.ds_especialidade 
	from	medico_especialidade a, 
		especialidade_medica b 
	where	a.cd_especialidade = b.cd_especialidade 
	and	a.cd_pessoa_fisica = cd_profissional_w;				
				 

BEGIN 
ds_erro_p 		:= '';
ie_consistencia_p	:= '';
 
select	max(cd_pessoa_fisica) 
into STRICT	cd_profissional_w 
from	agenda 
where	cd_agenda = cd_agenda_p;
 
if (cd_profissional_w IS NOT NULL AND cd_profissional_w::text <> '') then 
	open C01;
	loop 
	fetch C01 into	 
		cd_especialidade_w, 
		ds_especialidade_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		nr_seq_regra_w		:= '';
		ie_tipo_consistencia_w	:= '';
	 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_regra_w 
		from	agenda_conv_especialidade 
		where	cd_convenio = cd_convenio_p 
		and	cd_especialidade = cd_especialidade_w 
		and	coalesce(ie_situacao,'A') = 'A';	
		 
		if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then 
			 
			select	coalesce(max(ie_tipo_consistencia),'A') 
			into STRICT	ie_tipo_consistencia_w 
			from	agenda_conv_especialidade 
			where	nr_sequencia = nr_seq_regra_w;
			 
			if (coalesce(ie_consistencia_p,'X') <> 'B') then 
				ie_consistencia_p := ie_tipo_consistencia_w;
			end if;
			 
			ds_especialidades_w := substr(ds_especialidades_w ||' '||ds_especialidade_w||',',1,255);
		end if;
		 
		end;
	end loop;
	close C01;
	 
end if;
 
ds_erro_p := substr(ds_especialidades_w, 1, length(ds_especialidades_w)-1);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_agenda_conv_espec (cd_agenda_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text, ie_consistencia_p INOUT text) FROM PUBLIC;
