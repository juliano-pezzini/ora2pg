-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_duplicar_apac_mes (nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
nr_sequencia_w		bigint;
nr_apac_w		bigint;
qt_apac_w		integer;
ds_erro_w		varchar(255) := ' ';

C01 CURSOR FOR 
	SELECT	a.nr_atendimento, 
		b.nr_sequencia, 
		b.nr_apac 
	from	sus_apac_unif	b, 
		conta_paciente	a 
	where	a.nr_interno_conta	= b.nr_interno_conta 
	and	b.ie_tipo_apac		not in (3,4) 
	and	Obter_Tipo_Convenio(a.cd_convenio_parametro) = 3 
	and (SELECT	count(*) 
		from	sus_apac_unif x 
		where	x.nr_apac	= b.nr_apac) < 3 
	and	not exists (	select	1 
			from	sus_apac_unif z 
			where	z.nr_apac	= b.nr_apac 
			and	trunc(z.dt_competencia,'mm') = trunc(clock_timestamp(),'mm'));


BEGIN 
 
open c01;
	loop 
	fetch c01 into 
		nr_atendimento_w, 
		nr_sequencia_w, 
		nr_apac_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin	 
	ds_erro_w := sus_duplicar_apac(nr_atendimento_w, nr_sequencia_w, nm_usuario_p, null, null, ds_erro_w);	
	exception 
	when others then 
		ds_erro_w := nr_atendimento_w;
	end;
	 
	end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_duplicar_apac_mes (nm_usuario_p text) FROM PUBLIC;

