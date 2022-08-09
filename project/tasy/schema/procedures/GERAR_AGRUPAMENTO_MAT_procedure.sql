-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agrupamento_mat ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w         	bigint;
cd_grupo_material_w   	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w  	integer;						
qt_material_w			double precision;
qt_agrupamento_w		double precision;
dt_atendimento_w		timestamp;									
cd_convenio_w			integer;
qt_diferenca_w			double precision;
nr_seq_gerada_w			bigint;
nr_sequencia_w			bigint;
qt_item_regra_w			bigint:=0;
qt_reg_agrup_mat_w		bigint;
cd_convenio_parametro_w		convenio.cd_convenio%type;

C01 CURSOR FOR
	SELECT	cd_material,
		sum(qt_material),
		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atendimento),
		cd_convenio
	from	material_atend_paciente
	where	nr_interno_conta = nr_interno_conta_p
	and	coalesce(cd_motivo_exc_conta::text, '') = ''
	group by cd_material,
		cd_convenio,
		 ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atendimento);
	
C02 CURSOR FOR
	SELECT	qt_agrupamento
	from	conv_regra_agrupamento_mat
	where	cd_convenio = cd_convenio_w
	and	qt_material_w between qt_inicial and qt_final	
	order by coalesce(cd_material,0),
		 coalesce(cd_classe_material,0),
		 coalesce(cd_subgrupo_material,0),
		 coalesce(cd_grupo_material,0);
									

BEGIN

select	coalesce(max(cd_convenio_parametro),0)
into STRICT	cd_convenio_parametro_w
from 	conta_paciente
where 	nr_interno_conta = nr_interno_conta_p;

select 	count(*)
into STRICT	qt_reg_agrup_mat_w
from	conv_regra_agrupamento_mat
where	cd_convenio = cd_convenio_parametro_w;

if (qt_reg_agrup_mat_w > 0) then

	select	count(*)
	into STRICT	qt_item_regra_w
	from	material_atend_paciente
	where	nr_interno_conta = nr_interno_conta_p
	and	ds_observacao like '%' || Wheb_mensagem_pck.get_Texto(305699) || '%'
	and	coalesce(cd_motivo_exc_conta::text, '') = '';

	if (qt_item_regra_w = 0) then
		open C01;
		loop
		fetch C01 into	
			cd_material_w,
			qt_material_w,
			dt_atendimento_w,
			cd_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
				
			select	coalesce(max(cd_grupo_material),0),
				coalesce(max(cd_subgrupo_material),0),
				coalesce(max(cd_classe_material),0)
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;
			
			open C02;
			loop
			fetch C02 into	
				qt_agrupamento_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				qt_agrupamento_w:=qt_agrupamento_w;
				end;
			end loop;
			close C02;	
			
			select	coalesce(max(nr_sequencia),0)
			into STRICT 	nr_sequencia_w
			from	material_atend_paciente
			where	nr_interno_conta = nr_interno_conta_p
			and	coalesce(cd_motivo_exc_conta::text, '') = ''
			and	cd_material = cd_material_w
			and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atendimento) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atendimento_w);	
			
			qt_diferenca_w := qt_agrupamento_w - qt_material_w;
			
			if (qt_diferenca_w > 0) then
			
				nr_seq_gerada_w := Duplicar_Mat_Paciente(nr_sequencia_w, nm_usuario_p, 'N', nr_seq_gerada_w);
				
				update	material_atend_paciente
				set		qt_material = qt_diferenca_w,
						ds_observacao = Wheb_mensagem_pck.get_Texto(305699) /*'Gerado pela Regra para agrupamento de materiais'*/
				where	nr_sequencia = nr_seq_gerada_w;
				
				CALL atualiza_preco_material(nr_seq_gerada_w,nm_usuario_p);		
				
			end if;
			
			end;
		end loop;
		close C01;
	end if;
	
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agrupamento_mat ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
