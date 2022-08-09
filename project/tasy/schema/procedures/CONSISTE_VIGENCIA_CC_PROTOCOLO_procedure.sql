-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_vigencia_cc_protocolo ( nr_seq_protocolo_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
dt_mesano_referencia_w	timestamp;
cd_conta_contabil_w		varchar(20);
ie_vigente_w			varchar(01);

 
C01 CURSOR FOR 
SELECT	distinct 
	b.cd_conta_contabil 
from	conta_paciente a, 
	procedimento_paciente b, 
	atendimento_paciente d 
where 	a.nr_seq_protocolo	 	= nr_seq_protocolo_p 
and	a.nr_interno_conta		= b.nr_interno_conta 
and	a.nr_atendimento		= d.nr_atendimento;

C02 CURSOR FOR 
SELECT	distinct 
	b.cd_conta_contabil 
from	conta_paciente a, 
	material_atend_paciente b, 
	atendimento_paciente d 
where	a.nr_seq_protocolo	 	= nr_seq_protocolo_p 
and	a.nr_interno_conta		= b.nr_interno_conta 
and	a.nr_atendimento		= d.nr_atendimento;


BEGIN 
 
select	dt_mesano_referencia 
into STRICT	dt_mesano_referencia_w 
from	protocolo_convenio 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
open C01;
loop 
fetch C01 into	 
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then 
		select	substr(obter_se_conta_vigente(cd_conta_contabil_w, dt_mesano_referencia_w),1,1) 
		into STRICT	ie_vigente_w 
		;
		 
		if (coalesce(ie_vigente_w,'S') = 'N') then 
			ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(280794);
		end if;
	end if;
	end;
end loop;
close C01;
 
if (coalesce(ds_erro_p::text, '') = '') then 
	begin 
	open C02;
	loop 
	fetch C02 into	 
		cd_conta_contabil_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then 
			select	substr(obter_se_conta_vigente(cd_conta_contabil_w, dt_mesano_referencia_w),1,1) 
			into STRICT	ie_vigente_w 
			;
		 
			if (coalesce(ie_vigente_w,'S') = 'N') then 
				ds_erro_p := WHEB_MENSAGEM_PCK.get_texto(280794);
			end if;
		end if;
		end;
	end loop;
	close C02;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_vigencia_cc_protocolo ( nr_seq_protocolo_p bigint, ds_erro_p INOUT text) FROM PUBLIC;
