-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_alerta_tempo_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_mensagem_w		varchar(2000)	:= null;			
qt_reg_w		bigint;
cd_estabelecimento_w	bigint;
ie_tipo_atendimento_w	bigint;
cd_setor_atendimento_w	bigint;
dt_entrada_w		timestamp;
ie_tipo_atend_w		bigint;
			
C01 CURSOR FOR 
	SELECT	ie_tipo_atendimento, 
		ds_texto 
	from	alerta_tempo_atend_setor 
	where	cd_estabelecimento	= cd_estabelecimento_w 
	and	cd_setor_atendimento	= cd_setor_atendimento_w 
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)	= ie_tipo_atendimento_w 
	and	(clock_timestamp() - (qt_tempo/1440)) 	> dt_entrada_w 
	order by 1, 2;			
			 

BEGIN 
 
select	count(*) 
into STRICT	qt_reg_w 
from 	alerta_tempo_atend_setor;
 
if	((qt_reg_w > 0) and (obter_se_atendimento_alta(nr_atendimento_p) = 'N')) then 
	begin 
 
	select	cd_estabelecimento, 
		ie_tipo_atendimento, 
		Obter_Unidade_Atendimento(nr_atendimento, 'A', 'CS'), 
		dt_entrada 
	into STRICT	cd_estabelecimento_w, 
		ie_tipo_atendimento_w, 
		cd_setor_atendimento_w, 
		dt_entrada_w 
	from	atendimento_paciente 
	where	nr_atendimento		= nr_atendimento_p;
 
	open C01;
	loop 
	fetch C01 into	 
		ie_tipo_atend_w, 
		ds_mensagem_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		ds_mensagem_w	:= ds_mensagem_w;
		end;
	end loop;
	close C01;
	 
	end;
end if;
 
return	ds_mensagem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_alerta_tempo_atend (nr_atendimento_p bigint) FROM PUBLIC;

