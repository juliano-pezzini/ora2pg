-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_atendimento_paciente (nr_atendimento_p bigint, ds_consistencia_p INOUT text) AS $body$
DECLARE

 
ds_consistencia_w	varchar(255)	:= '';
qt_categoria_w		integer	:= 0;
qt_unidade_w		integer	:= 0;
qt_existe_w		bigint;


BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p 
and	coalesce(dt_cancelamento::text, '') = '';
 
if (qt_existe_w > 0) then 
	begin 
	select	count(*) 
	into STRICT	qt_categoria_w 
	from	atend_categoria_convenio 
	where	nr_atendimento	= nr_atendimento_p;
 
	 
	if (qt_categoria_w = 0) then 
		ds_consistencia_w	:= substr(ds_consistencia_w || obter_texto_tasy(312384, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		-- 'Este atendimento não possui dados do convênio' 
	end if;
 
	select	count(*) 
	into STRICT	qt_unidade_w 
	from	atend_paciente_unidade 
	where	nr_atendimento	= nr_atendimento_p;
 
 
	if (qt_unidade_w = 0) then 
		ds_consistencia_w	:= substr(ds_consistencia_w || obter_texto_tasy(312385, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		--'Este atendimento não possui dados do setor de atendimento' 
	end if;
	end;
end if;
 
ds_consistencia_p	:= ds_consistencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_atendimento_paciente (nr_atendimento_p bigint, ds_consistencia_p INOUT text) FROM PUBLIC;

