-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_checkup_convenio_pf ( cd_pessoa_fisica_p text, dt_previsto_p timestamp, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text, cd_empresa_ref_p INOUT bigint) AS $body$
DECLARE

 
cd_convenio_w 			bigint;
cd_categoria_w			varchar(10);
cd_plano_w			varchar(10);
ie_dentro_periodo_w		varchar(1);
ie_pessoa_liberada_w		varchar(1);
cd_empresa_ref_w		bigint;									
qt_checkup_lib_w		bigint;
qt_agenda_checkup_w		bigint;


BEGIN 
 
select	CASE WHEN coalesce(max(a.nr_sequencia),0)=0 THEN 'N'  ELSE 'S' END  
into STRICT	ie_pessoa_liberada_w 
from  empresa_contrato_checkup a, 
	empresa_pessoa_checkup b 
where  a.nr_sequencia = b.nr_seq_contrato 
and   b.cd_pessoa_fisica = cd_pessoa_fisica_p;
 
if (ie_pessoa_liberada_w = 'S') then 
	begin 
	select CASE WHEN coalesce(max(a.nr_sequencia),0)=0 THEN 'N'  ELSE 'S' END  
	into STRICT	ie_dentro_periodo_w 
	from  	empresa_contrato_checkup a, 
		empresa_pessoa_checkup b 
	where 	a.nr_sequencia = b.nr_seq_contrato 
	and   b.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   coalesce(dt_previsto_p,clock_timestamp()) between coalesce(a.dt_inicial,dt_previsto_p) and coalesce(a.dt_final,dt_previsto_p);
 
	if (ie_dentro_periodo_w = 'N') then 
		begin 
		select max(a.cd_empresa) 
		into STRICT	cd_empresa_ref_w 
		from  	empresa_contrato_checkup a, 
			empresa_pessoa_checkup b 
		where 	a.nr_sequencia = b.nr_seq_contrato 
		and   b.cd_pessoa_fisica = cd_pessoa_fisica_p;
		 
		--Expirou o período de vigência para a empresa. ' || obter_nome_empresa_ref(cd_empresa_ref_w) || '#@#@'); 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261581, 'EMPRESA='||obter_nome_empresa_ref(cd_empresa_ref_w));
		end;
	end if;
	end;
end if;
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (dt_previsto_p IS NOT NULL AND dt_previsto_p::text <> '') then 
	begin 
	select 	max(a.cd_empresa), 
		max(a.cd_convenio), 
		max(a.cd_plano), 
		max(a.cd_categoria), 
		max(b.qt_checkup_lib) 
	into STRICT  cd_empresa_ref_w, 
		  cd_convenio_w, 
		  cd_plano_w, 
		  cd_categoria_w, 
		  qt_checkup_lib_w 
	from  empresa_contrato_checkup a, 
		  empresa_pessoa_checkup b 
	where a.nr_sequencia = b.nr_seq_contrato 
	and	  b.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   coalesce(dt_previsto_p,clock_timestamp()) between coalesce(a.dt_inicial,dt_previsto_p) and coalesce(a.dt_final,dt_previsto_p);
 
 
	select count(*) 
	into STRICT 	qt_agenda_checkup_w 
	from  	checkup a 
	where  a.cd_pessoa_fisica = cd_pessoa_fisica_p 
	and   trunc(a.dt_previsto) between trunc(clock_timestamp()) and fim_dia(clock_timestamp()) 
	and 	coalesce(a.dt_cancelamento::text, '') = '';
 
	if (qt_agenda_checkup_w > qt_checkup_lib_w) then 
		/*O paciente ' || obter_nome_pf(cd_pessoa_fisica_p) || 
		' excedeu a quantidade de agendas permitida para a data '|| trunc(sysdate) ||' #@#@');*/
 
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261585,'PACIENTE='|| obter_nome_pf(cd_pessoa_fisica_p) || ';' || 
														'DATA=' || to_char(trunc(clock_timestamp()),'dd/mm/yyyy'));
	end if;
 
	cd_empresa_ref_p 	:= cd_empresa_ref_w;
	cd_convenio_p 		:= cd_convenio_w;
	cd_plano_p		:= cd_plano_w;
	cd_categoria_p		:= cd_categoria_w;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_checkup_convenio_pf ( cd_pessoa_fisica_p text, dt_previsto_p timestamp, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_p INOUT text, cd_empresa_ref_p INOUT bigint) FROM PUBLIC;

