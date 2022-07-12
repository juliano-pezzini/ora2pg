-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proced_princ_sus_aih (nr_aih_p bigint) RETURNS bigint AS $body$
DECLARE

 
ie_tipo_laudo_sus_w		integer;
cd_procedimento_solic_w		bigint;
cd_procedimento_realiz_w	bigint;
ie_politraumatizado_w		varchar(1);
ie_cirurgia_multipla_w		varchar(1);
dt_emissao_w			timestamp;

 
 
C01 CURSOR FOR 
SELECT	cd_procedimento_solic, 
	ie_tipo_laudo_sus, 
	dt_emissao 
from 	sus_laudo_paciente 
where 	ie_tipo_laudo_sus	in (0,1,9) 
and	nr_aih			= nr_aih_p 
order by 2, 3;


BEGIN 
 
cd_procedimento_realiz_w	:= 0;
ie_politraumatizado_w	:= 'N';
ie_cirurgia_multipla_w	:= 'N';
 
OPEN C01;
LOOP 
FETCH C01 	into 
		cd_procedimento_solic_w, 
		ie_tipo_laudo_sus_w, 
		dt_emissao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
		if (ie_tipo_laudo_sus_w in (0,1)) then 
			cd_procedimento_realiz_w	:= cd_procedimento_solic_w;
		end if;
		if (cd_procedimento_solic_w in (39000001,70000000,40290000,33000000)) then 
			ie_politraumatizado_w	 := 'S';
		end if;	
		if (cd_procedimento_solic_w in (31000002)) then 
			ie_cirurgia_multipla_w	 := 'S';
		end if;	
		if (ie_tipo_laudo_sus_w = 9) and (ie_politraumatizado_w	= 'S' or 
			 ie_cirurgia_multipla_w	= 'S')	then 
			cd_procedimento_realiz_w	:= cd_procedimento_solic_w;
		end if;
		end;
END LOOP;
CLOSE C01;
 
RETURN	cd_procedimento_realiz_w;
	 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proced_princ_sus_aih (nr_aih_p bigint) FROM PUBLIC;

