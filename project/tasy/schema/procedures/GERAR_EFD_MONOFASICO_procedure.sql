-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_efd_monofasico ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
dt_inicio_w				timestamp;
dt_fim_w				timestamp;
vl_material_w			double precision;
cd_material_w			integer;
qt_material_w			double precision;
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
cd_convenio_w			integer;
contador_w				bigint;
			
c01 CURSOR FOR 
	SELECT	cd_convenio, 
		cd_pessoa_fisica, 
		sum(qt_material) qt_material, 
		cd_material, 
		sum(vl_material), 
		nr_atendimento 
	from (	SELECT 	a.cd_convenio, 
			d.cd_pessoa_fisica,  
			b.cd_material,  
			(a.qt_material) qt_material, 
			a.vl_material, 
			a.nr_atendimento 
		from 	material_atend_paciente a, 
			material b, 
			atendimento_paciente c, 
			pessoa_fisica d 
		where	a.cd_material = b.cd_material 
		and	a.nr_atendimento = c.nr_atendimento 
		and	c.cd_pessoa_fisica = d.cd_pessoa_fisica 
		and	(b.cd_classif_fiscal IS NOT NULL AND b.cd_classif_fiscal::text <> '') 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
		and	a.vl_material    > 0 
		and	a.dt_atendimento  >= dt_inicio_w 
		and 	a.dt_atendimento  <= dt_fim_w 
		and (substr(b.cd_classif_fiscal,1,4) in ('3003', '3004', '3303', '3304', '3305', '3306', '3307') or (b.cd_classif_fiscal in (34011190, 34012010, 96032100))) 
		and	b.ie_tipo_material in (2,3)) alias11 
	group by	cd_convenio, 
				cd_pessoa_fisica, 
				cd_material, 
				nr_atendimento 
	order by cd_pessoa_fisica;
			

BEGIN 
dt_inicio_w := trunc(dt_referencia_p,'mm');
dt_fim_w	:= fim_dia(last_day(trunc(dt_referencia_p,'mm')));
 
open C01;
loop 
fetch C01 into	 
	cd_convenio_w, 
	cd_pessoa_fisica_w, 
	qt_material_w, 
	cd_material_w, 
	vl_material_w, 
	nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	contador_w := contador_w + 1;
 
	insert into efd_monofasico(	nr_sequencia, 
									dt_atualizacao, 
									nm_usuario, 
									dt_atualizacao_nrec, 
									nm_usuario_nrec, 
									vl_material, 
									cd_material, 
									qt_material, 
									cd_pessoa_fisica, 
									nr_atendimento, 
									cd_convenio) 
						values (	nextval('efd_monofasico_seq'), 
									clock_timestamp(), 
									nm_usuario_p, 
									clock_timestamp(), 
									nm_usuario_p, 
									vl_material_w, 
									cd_material_w, 
									qt_material_w, 
									cd_pessoa_fisica_w, 
									nr_atendimento_w, 
									cd_convenio_w);
 
	if (mod(contador_w,100) = 0) then 
		commit;
	end if;
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_efd_monofasico ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
