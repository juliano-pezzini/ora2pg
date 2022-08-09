-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_se_lib_proc_global (cd_medico_p text, ie_tab_interna_p text, ie_estab_usuario_p text, cd_estab_filtro_p bigint, nr_seq_proc_interno1_p bigint, nr_seq_proc_interno2_p bigint, nr_seq_proc_interno3_p bigint, nr_seq_proc_interno4_p bigint, nr_seq_proc_interno5_p bigint, nr_seq_proc_interno6_p bigint, dt_agenda_p text, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_libera_p INOUT text) AS $body$
DECLARE

 
cd_agenda_w		bigint;
cd_estabelecimento_w	smallint;
ie_permite_agenda_w	varchar(1) := 'S';
qt_estab_w		bigint;
ie_executa_1w		varchar(1) := 'S';
ie_executa_2w		varchar(1) := 'S';
ie_executa_3w		varchar(1) := 'S';			
ie_executa_4w		varchar(1) := 'S';
ie_executa_5w		varchar(1) := 'S';
ie_executa_6w		varchar(1) := 'S';
ie_continua_w		varchar(1) := 'S';
ie_libera_w		varchar(1) := 'S';
ds_agenda_w		varchar(100);
ie_exec_1w		varchar(1) := 'N';
ie_exec_2w		varchar(1) := 'N';
ie_exec_3w		varchar(1) := 'N';
ie_exec_4w		varchar(1) := 'N';
ie_exec_5w		varchar(1) := 'N';
ie_exec_6w		varchar(1) := 'N';
cd_procedimento_w1	bigint;
cd_procedimento_w2	bigint;
cd_procedimento_w3	bigint;
cd_procedimento_w4	bigint;
cd_procedimento_w5	bigint;
cd_procedimento_w6	bigint;
ie_origem_proced_w1	bigint;
ie_origem_proced_w2	bigint;
ie_origem_proced_w3	bigint;
ie_origem_proced_w4	bigint;
ie_origem_proced_w5	bigint;
ie_origem_proced_w6	bigint;

 
 
			 
C01 CURSOR FOR 
	SELECT	cd_agenda, 
		cd_estabelecimento 
	from	agenda 
	where	cd_tipo_agenda = 2 
	and	ie_situacao = 'A' 
	and	Obter_Se_Proc_Lib_Agenda(cd_agenda, 
					0, 0, 0, 0, 0, 0,	 
					nr_seq_proc_interno1_p,	 
					nr_seq_proc_interno2_p,	 
					nr_seq_proc_interno3_p, 
					nr_seq_proc_interno4_p,	 
					nr_seq_proc_interno5_p,	 
					nr_seq_proc_interno6_p) = 'S' 
	order by 1;

C02 CURSOR FOR 
	SELECT	cd_agenda, 
		cd_estabelecimento 
	from	agenda 
	where	cd_tipo_agenda = 2 
	and	ie_situacao = 'A' 
	and	Obter_Se_Proc_Lib_Agenda(cd_agenda, 
					nr_seq_proc_interno1_p,	 
					nr_seq_proc_interno2_p,	 
					nr_seq_proc_interno3_p, 
					nr_seq_proc_interno4_p,	 
					nr_seq_proc_interno5_p,	 
					nr_seq_proc_interno6_p, 
					0, 0, 0, 0, 0, 0) = 'S' 
	order by 1;	
			 

BEGIN 
 
if (ie_tab_interna_p = 'S') then 
	open C01;
	loop 
	fetch C01 into	 
		cd_agenda_w, 
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_agenda_w := substr(obter_desc_agenda(cd_agenda_w),1,100);
		 
		if (cd_estab_filtro_p IS NOT NULL AND cd_estab_filtro_p::text <> '') and (cd_estabelecimento_w <> cd_estab_filtro_p) then 
			ie_permite_agenda_w := 'N';
		elsif (ie_estab_usuario_p = 'S') and (cd_estabelecimento_w <> cd_estabelecimento_p) then 
			ie_permite_agenda_w := 'N';
		else 
			select count(*) 
			into STRICT	qt_estab_w 
			from  usuario_estabelecimento x  
			where  x.nm_usuario_param = nm_usuario_p 
			and	x.cd_estabelecimento = cd_estabelecimento_w;
			if (qt_estab_w = 0) then 
				ie_permite_agenda_w := 'N';
			end if;
		end if;
		 
		if (ie_permite_agenda_w = 'S') then 
					 
			if (nr_seq_proc_interno1_p <> 0) then 
				ie_executa_1w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno1_p,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno2_p <> 0) then 
				ie_executa_2w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno2_p,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno3_p <> 0) then 
				ie_executa_3w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno3_p,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno4_p <> 0) then 
				ie_executa_4w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno4_p,cd_medico_p);
			end if;
			 
			if (nr_seq_proc_interno5_p <> 0) then 
				ie_executa_5w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno5_p,cd_medico_p);
			end if;
			 
			if (nr_seq_proc_interno6_p <> 0) then 
				ie_executa_6w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,0,0,nr_seq_proc_interno6_p,cd_medico_p);
			end if;
		end if;
				 
		if (ie_exec_1w = 'N') and (ie_executa_1w = 'S') then 
			ie_exec_1w := 'S';
		end if;
		 
		if (ie_exec_2w = 'N') and (ie_executa_2w = 'S') then 
			ie_exec_2w := 'S';
		end if;
		 
		if (ie_exec_3w = 'N') and (ie_executa_3w = 'S') then 
			ie_exec_3w := 'S';
		end if;
		 
		if (ie_exec_4w = 'N') and (ie_executa_4w = 'S') then 
			ie_exec_4w := 'S';
		end if;	
		 
		if (ie_exec_5w = 'N') and (ie_executa_5w = 'S') then 
			ie_exec_5w := 'S';
		end if;	
		 
		if (ie_exec_6w = 'N') and (ie_executa_6w = 'S') then 
			ie_exec_6w := 'S';
		end if;
		end;
	end loop;
	close C01;
else 
	open C02;
	loop 
	fetch C02 into	 
		cd_agenda_w, 
		cd_estabelecimento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		ds_agenda_w := substr(obter_desc_agenda(cd_agenda_w),1,100);
		 
		if (cd_estab_filtro_p IS NOT NULL AND cd_estab_filtro_p::text <> '') and (cd_estabelecimento_w <> cd_estab_filtro_p) then 
			ie_permite_agenda_w := 'N';
		elsif (ie_estab_usuario_p = 'S') and (cd_estabelecimento_w <> cd_estabelecimento_p) then 
			ie_permite_agenda_w := 'N';
		else 
			select count(*) 
			into STRICT	qt_estab_w 
			from  usuario_estabelecimento x  
			where  x.nm_usuario_param = nm_usuario_p 
			and	x.cd_estabelecimento = cd_estabelecimento_w;
			if (qt_estab_w = 0) then 
				ie_permite_agenda_w := 'N';
			end if;
		end if;
		 
		if (ie_permite_agenda_w = 'S') then 
					 
			if (nr_seq_proc_interno1_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno1_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w1, ie_origem_proced_w1) INTO STRICT cd_procedimento_w1, ie_origem_proced_w1;
				ie_executa_1w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno1_p,ie_origem_proced_w1,0,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno2_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno2_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w2, ie_origem_proced_w2) INTO STRICT cd_procedimento_w2, ie_origem_proced_w2;
				ie_executa_2w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno2_p,ie_origem_proced_w2,0,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno3_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno3_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w3, ie_origem_proced_w3) INTO STRICT cd_procedimento_w3, ie_origem_proced_w3;
				ie_executa_3w := coalesce(obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno3_p,ie_origem_proced_w3,0,cd_medico_p),'N');
			end if;
			 
			if (nr_seq_proc_interno4_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno4_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w4, ie_origem_proced_w4) INTO STRICT cd_procedimento_w4, ie_origem_proced_w4;
				ie_executa_4w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno4_p,ie_origem_proced_w4,0,cd_medico_p);
			end if;
			 
			if (nr_seq_proc_interno5_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno5_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w5, ie_origem_proced_w5) INTO STRICT cd_procedimento_w5, ie_origem_proced_w5;
				ie_executa_5w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno5_p,ie_origem_proced_w5,0,cd_medico_p);
			end if;
			 
			if (nr_seq_proc_interno6_p <> 0) then 
				SELECT * FROM obter_procedimento_tab_interna(nr_seq_proc_interno6_p, cd_convenio_p, cd_estabelecimento_p, dt_agenda_p, cd_procedimento_w6, ie_origem_proced_w6) INTO STRICT cd_procedimento_w6, ie_origem_proced_w6;
				ie_executa_6w := obter_se_proc_conv_agenda(cd_estabelecimento_p,cd_agenda_w,cd_convenio_p,nr_seq_proc_interno6_p,ie_origem_proced_w6,0,cd_medico_p);
			end if;
		end if;
						 
		if (ie_exec_1w = 'N') and (ie_executa_1w = 'S') then 
			ie_exec_1w := 'S';
		end if;
		 
		if (ie_exec_2w = 'N') and (ie_executa_2w = 'S') then 
			ie_exec_2w := 'S';
		end if;
		 
		if (ie_exec_3w = 'N') and (ie_executa_3w = 'S') then 
			ie_exec_3w := 'S';
		end if;
		 
		if (ie_exec_4w = 'N') and (ie_executa_4w = 'S') then 
			ie_exec_4w := 'S';
		end if;	
		 
		if (ie_exec_5w = 'N') and (ie_executa_5w = 'S') then 
			ie_exec_5w := 'S';
		end if;	
		 
		if (ie_exec_6w = 'N') and (ie_executa_6w = 'S') then 
			ie_exec_6w := 'S';
		end if;
		end;
	end loop;
	close C02;
end if;	
if	((ie_exec_1w = 'N') or (ie_exec_2w = 'N') or (ie_exec_3w = 'N') or (ie_exec_4w = 'N') or (ie_exec_5w = 'N') or (ie_exec_6w = 'N')) then 
	ie_libera_w := 'N';
end if;
 
ie_libera_p := ie_libera_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_se_lib_proc_global (cd_medico_p text, ie_tab_interna_p text, ie_estab_usuario_p text, cd_estab_filtro_p bigint, nr_seq_proc_interno1_p bigint, nr_seq_proc_interno2_p bigint, nr_seq_proc_interno3_p bigint, nr_seq_proc_interno4_p bigint, nr_seq_proc_interno5_p bigint, nr_seq_proc_interno6_p bigint, dt_agenda_p text, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_libera_p INOUT text) FROM PUBLIC;
