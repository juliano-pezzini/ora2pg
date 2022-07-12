-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proxima_seq_grade (nr_seq_protocolo_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_seq_grade_w	integer;
cd_convenio_w		integer;
cd_interface_w		integer := 0;
dt_mesano_referencia_w	timestamp;
nr_seq_protocolo_w	bigint;
nr_seq_int_envio_inicial_w bigint;
nr_seq_int_envio_w 	bigint;


BEGIN 
 
/* Achar o Número da Grade ++ Inicio ++ */
 
 
select 	max(cd_convenio), 
	max(dt_mesano_referencia), 
	max(coalesce(cd_interface_envio,0)) 
into STRICT	cd_convenio_w, 
	dt_mesano_referencia_w, 
	cd_interface_w 
from 	protocolo_convenio 
where 	nr_seq_protocolo = nr_seq_protocolo_p;
 
if (cd_interface_w = 0) then 
	select 	max(coalesce(cd_interface_envio,0)) 
	into STRICT	cd_interface_w 
	from 	convenio 
	where 	cd_convenio = cd_convenio_w;
end if;
 
select 	max(coalesce(nr_seq_int_envio_inicial,0)) 
into STRICT	nr_seq_int_envio_inicial_w 
from 	protocolo_convenio 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
 
if (nr_seq_int_envio_inicial_w = 0) then 
	select 	max(coalesce(nr_seq_int_envio,0)) 
	into STRICT	nr_seq_int_envio_w 
	from 	protocolo_convenio 
	where	cd_convenio = cd_convenio_w 
	and	trunc(dt_mesano_referencia, 'month') 		= trunc(dt_mesano_referencia_w, 'month') 
	and 	coalesce(cd_interface_envio, cd_interface_w)		= cd_interface_w;
	 
	if (nr_seq_int_envio_w = 0) then 
		select	max(coalesce(nr_seq_envio_prot,0)) 
		into STRICT	nr_seq_grade_w 
		from	conv_regra_envio_protocolo 
		where	cd_convenio					= cd_convenio_w 
		and 	coalesce(cd_interface, cd_interface_w)		= cd_interface_w 
		and 	coalesce(ie_tipo_regra, 'S') = 'I';
	else 
		nr_seq_grade_w:= nr_seq_int_envio_w + 1;
	end if;
else 
	nr_seq_grade_w:= nr_seq_int_envio_inicial_w;
end if;
 
/* Achar o Número da Grade ++ Fim ++ */
 
 
return nr_seq_grade_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proxima_seq_grade (nr_seq_protocolo_p bigint) FROM PUBLIC;
