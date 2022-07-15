-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hbh_gerar_w_conta_pmmg ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* 
edgar 24/05/2005 
procedure feita especialmente para o rel "conta paciente pmmg wate02220" 
rel dividido em 4 partes pelo campo nr_seq_inf 
 
nr_seq_inf : 
 
	1 - serviços hospitalares 
	2 - taxas de sala 
	3 - procedimentos hospitalares 
	4 - serviços profissionais (honorários) 
 
*/
 
 
 
nr_atendimento_w		bigint;
qt_dia_conta_w		bigint;
nr_interno_conta_w		bigint;
cd_estabelecimento_w	smallint;
cd_convenio_w		integer;

cd_cgc_estabelecimento_w	varchar(14);	
 
ds_material_w		varchar(254);
cd_material_w		integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
dt_atendimento_w		timestamp;
qt_material_w		double precision;
vl_material_w		double precision;
vl_medico_w		double precision;

 
ds_procedimento_w		varchar(254);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_grupo_w		bigint;
cd_especialidade_w	bigint;
cd_area_w		bigint;
dt_procedimento_w		timestamp;
qt_procedimento_w		bigint;
vl_procedimento_w		double precision;
vl_unitario_w		double precision;

qt_item_w		double precision;
vl_item_w			double precision;
cd_setor_w		integer;

nr_seq_inf_w		bigint;
ds_informacao_w		varchar(90);
ie_diaria_w		varchar(1);
ie_tipo_item_w		varchar(5);

ie_existe_w		bigint;
cd_prestador_w		varchar(20);
cd_atuacao_w		varchar(10);
dt_item_w		timestamp;
ds_item_w		varchar(254);
ds_procedimento_convenio_w	varchar(254);
cd_cgc_prestador_w	varchar(20);
nr_seq_conta_w		bigint;
nr_seq_regra_w		bigint;
cd_item_w		varchar(10);
cd_informacao_w		varchar(15);
qt_diaria_w		integer;

cd_medico_w		varchar(20);
cd_atuacao_convenio_w	varchar(5);
ie_credenciado_w		varchar(3);
nr_cpf_medico_w		varchar(20);
cd_cgc_convenio_w	varchar(20);
cd_procedimento_convenio_w	varchar(254);

dt_periodo_inicial_w	timestamp;
dt_periodo_final_w		timestamp;
qt_porte_anestesico_w	smallint;

c01 CURSOR FOR 
SELECT	nr_atendimento, 
	nr_interno_conta, 
	cd_estabelecimento, 
	cd_convenio_parametro, 
	dt_periodo_inicial, 
	dt_periodo_final, 
	b.cd_cgc 
from	convenio b, 
	conta_paciente a 
where	a.nr_interno_conta 	= nr_interno_conta_p 
and	a.cd_convenio_parametro	= b.cd_convenio;

cmaterial CURSOR FOR 
SELECT	a.cd_material, 
	a.cd_setor_atendimento, 
	b.cd_grupo_material, 
	b.cd_subgrupo_material, 
	b.cd_classe_material, 
	substr(b.ds_material,1,254), 
	a.dt_atendimento, 
	a.qt_material, 
	a.vl_material, 
	a.vl_unitario 
from	estrutura_material_v b, 
	conta_paciente_material_v a 
where 	a.cd_material		= b.cd_material 
and	a.nr_interno_conta	= nr_interno_conta_w 
and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

cregramat CURSOR FOR 
SELECT	a.ds_informacao, 
	a.nr_seq_inf, 
	a.ie_diaria, 
	a.nr_sequencia, 
	a.cd_informacao 
from	conv_regra_conta_mat b, 
	convenio_regra_conta a 
where	a.nr_sequencia = b.nr_seq_regra 
and	coalesce(b.cd_material, cd_material_w)		= cd_material_w 
and	coalesce(b.cd_grupo_material, cd_grupo_material_w)	= cd_grupo_material_w 
and	coalesce(b.cd_subgrupo_material, cd_subgrupo_material_w)= cd_subgrupo_material_w 
and	coalesce(b.cd_classe_material, cd_classe_material_w)	= cd_classe_material_w 
and	coalesce(b.cd_setor_atendimento, cd_setor_w)		= cd_setor_w 
and	a.cd_convenio 					= cd_convenio_w 
and	a.nr_seq_inf					<> 4 
order	by coalesce(cd_material, 0), 
	coalesce(cd_grupo_material, 0), 
	coalesce(cd_subgrupo_material, 0), 
	coalesce(cd_classe_material, 0), 
	coalesce(cd_setor_atendimento,0);

cprocedimento CURSOR FOR 
SELECT	c.cd_procedimento, 
	c.ie_origem_proced, 
	a.cd_setor_atendimento, 
	b.cd_grupo_proc, 
	b.cd_especialidade, 
	b.cd_area_procedimento, 
	a.cd_cgc_prestador, 
	a.dt_procedimento, 
	a.qt_procedimento, 
	b.ds_procedimento, 
	a.vl_procedimento, 
	a.ds_procedimento_convenio, 
	a.cd_procedimento_convenio, 
	a.qt_porte_anestesico 
from	estrutura_procedimento_v b, 
	procedimento_paciente c, 
 	conta_paciente_procedimento_v a 
where 	c.cd_procedimento	= b.cd_procedimento 
and	c.ie_origem_proced	= b.ie_origem_proced 
and	c.nr_sequencia		= a.nr_sequencia 
and	a.nr_interno_conta	= nr_interno_conta_w 
and	coalesce(c.cd_motivo_exc_conta::text, '') = '' 
order	by c.dt_procedimento;

cregraproc CURSOR FOR 
SELECT	a.ds_informacao, 
	a.nr_seq_inf, 
	a.ie_diaria, 
	a.nr_sequencia, 
	a.cd_informacao 
from	conv_regra_conta_proc b, 
	convenio_regra_conta a 
where	a.nr_sequencia = b.nr_seq_regra 
and	coalesce(b.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w 
and	((coalesce(b.cd_procedimento::text, '') = '') or (coalesce(b.ie_origem_proced,ie_origem_proced_w)	= ie_origem_proced_w)) 
and	coalesce(b.cd_grupo_proced,cd_grupo_w)		= cd_grupo_w 
and	coalesce(b.cd_especial_proced, cd_especialidade_w)	= cd_especialidade_w 
and	coalesce(b.cd_area_proced, cd_area_w)		= cd_area_w 
and	coalesce(b.cd_setor_atendimento, cd_setor_w)		= cd_setor_w 
and	a.cd_convenio 					= cd_convenio_w 
and	a.nr_seq_inf					<> 4 
order	by coalesce(cd_procedimento, 0), 
	coalesce(cd_grupo_proced, 0), 
	coalesce(cd_especial_proced, 0), 
	coalesce(cd_area_proced, 0), 
	coalesce(cd_setor_atendimento, 0);

chonorario CURSOR FOR 
SELECT	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.cd_setor_atendimento, 
	b.cd_grupo_proc, 
	b.cd_especialidade, 
	b.cd_area_procedimento, 
	a.cd_cgc_prestador, 
	a.dt_procedimento, 
	a.qt_procedimento, 
	b.ds_procedimento, 
	a.vl_medico, 
	a.cd_medico, 
	obter_se_medico_credenciado(a.cd_estabelecimento, a.cd_medico, cd_convenio_w, null, null, null,a.cd_setor_atendimento, null, null, null, null, null), 
	a.nr_cpf_medico, 
	obter_conversao_externa(cd_cgc_convenio_w, 'ESPECIALIDADE_MEDICA','CD_ESPECIALIDADE', a.cd_especialidade), 
	a.cd_procedimento_convenio, 
	a.vl_procedimento 
from	estrutura_procedimento_v b, 
 	conta_paciente_honorario_v a 
where 	a.cd_procedimento	= b.cd_procedimento 
and	a.ie_origem_proced	= b.ie_origem_proced 
and	a.nr_interno_conta	= nr_interno_conta_w 
and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

cregrahonorario CURSOR FOR 
SELECT	a.ds_informacao, 
	a.nr_seq_inf, 
	a.ie_diaria, 
	a.nr_sequencia, 
	a.cd_informacao 
from	conv_regra_conta_proc b, 
	convenio_regra_conta a 
where	a.nr_sequencia = b.nr_seq_regra 
and	coalesce(b.cd_procedimento,cd_procedimento_w)	= cd_procedimento_w 
and	((coalesce(b.cd_procedimento::text, '') = '') or (coalesce(b.ie_origem_proced,ie_origem_proced_w)	= ie_origem_proced_w)) 
and	coalesce(b.cd_grupo_proced,cd_grupo_w)		= cd_grupo_w 
and	coalesce(b.cd_especial_proced, cd_especialidade_w)	= cd_especialidade_w 
and	coalesce(b.cd_area_proced, cd_area_w)		= cd_area_w 
and	coalesce(b.cd_setor_atendimento, cd_setor_w)		= cd_setor_w 
and	a.cd_convenio 					= cd_convenio_w 
and	a.nr_seq_inf					= 4 
order	by coalesce(cd_procedimento, 0), 
	coalesce(cd_grupo_proced, 0), 
	coalesce(cd_especial_proced, 0), 
	coalesce(cd_area_proced, 0), 
	coalesce(cd_setor_atendimento, 0);

 

BEGIN 
 
delete	from w_conta_pmmg 
where (nm_usuario = nm_usuario_p 
	or nr_interno_conta = nr_interno_conta_p);
 
commit;
 
open c01;
loop 
fetch c01 into 
	nr_atendimento_w, 
	nr_interno_conta_w, 
	cd_estabelecimento_w, 
	cd_convenio_w, 
	dt_periodo_inicial_w, 
	dt_periodo_final_w, 
	cd_cgc_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then 
		select	a.cd_cgc 
		into STRICT	cd_cgc_estabelecimento_w 
		from	estabelecimento a, 
			pessoa_juridica b 
		where	a.cd_cgc		= b.cd_cgc 
	    and	a.cd_estabelecimento	= cd_estabelecimento_w;	
	end if;
 
	select	nextval('w_conta_pmmg_seq') 
	into STRICT	nr_seq_conta_w 
	;
 
	select	coalesce(max(cd_procedimento),null) 
	into STRICT	cd_procedimento_w 
	from	procedimento_paciente 
	where	nr_interno_conta = nr_interno_conta_w 
	and	coalesce(cd_motivo_exc_conta::text, '') = '' 
	and	ie_proc_princ_atend = 'S';
 
	insert into w_conta_pmmg( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		nr_interno_conta) 
	values (	nr_seq_conta_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_interno_conta_p);
 
	open cmaterial;
	loop 
	fetch cmaterial into 
		cd_material_w, 
		cd_setor_w, 
		cd_grupo_material_w, 
		cd_subgrupo_material_w, 
		cd_classe_material_w, 
		ds_material_w, 
		dt_atendimento_w, 
		qt_material_w, 
		vl_material_w, 
		vl_unitario_w;
	EXIT WHEN NOT FOUND; /* apply on cmaterial */
 
		ds_informacao_w	:= null;
		nr_seq_inf_w		:= null;
		ie_diaria_w		:= null;
		nr_seq_regra_w	:= null;
		cd_informacao_w	:= null;
 
		open cregramat;
		loop 
		fetch cregramat into 
			ds_informacao_w, 
			nr_seq_inf_w, 
			ie_diaria_w, 
			nr_seq_regra_w, 
			cd_informacao_w;
		EXIT WHEN NOT FOUND; /* apply on cregramat */
		end loop;
		close cregramat;
 
		qt_diaria_w	:= null;
		ds_item_w	:= null;
		dt_item_w	:= null;
		cd_atuacao_w	:= null;
		vl_item_w	:= null;
		ie_tipo_item_w	:= null;
		cd_prestador_w	:= null;
 
		if (nr_seq_inf_w IS NOT NULL AND nr_seq_inf_w::text <> '') then 
			if (nr_seq_inf_w = 1) then 
 
				ds_item_w		:= ds_informacao_w;
				dt_item_w		:= dt_atendimento_w;
				qt_item_w		:= qt_material_w;
				cd_item_w		:= cd_informacao_w;
				vl_item_w		:= vl_material_w;
 
			elsif (nr_seq_inf_w = 2) then 
 
				cd_item_w		:= cd_informacao_w;
				ds_item_w		:= ds_material_w;
				dt_item_w		:= dt_atendimento_w;
				qt_item_w		:= qt_material_w;
 
			elsif (nr_seq_inf_w = 3) then 
 
				ds_item_w		:= ds_informacao_w;
				vl_item_w		:= vl_material_w;
				qt_item_w		:= qt_material_w;
				dt_item_w		:= dt_periodo_inicial_w;
				cd_item_w		:= cd_informacao_w;
 
			end if;
 
			if (ie_diaria_w = 'S') then 
				-- apenas os dias referentes ao período da conta 
				qt_dia_conta_w		:= dt_periodo_final_w - dt_periodo_inicial_w;
				if (qt_diaria_w > qt_dia_conta_w) then 
					qt_item_w	:= qt_dia_conta_w;
				end if;
				qt_diaria_w		:= qt_item_w;
			end if;
 
			select	count(*) 
			into STRICT	ie_existe_w 
			from 	w_conta_pmmg_item 
			where	nr_seq_conta_pmmg	= nr_seq_conta_w 
			and	nr_seq_regra		= nr_seq_regra_w 
			and	ie_analitica_sintetica	= 'S';
 
 
			/* inÍcio geraÇÃo da conta sintÉtica (resumo) */
 
			if (ie_existe_w = 0) then 
 
				insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
					nr_seq_regra, 
					ds_item, 
					qt_diaria, 
					vl_item, 
					ie_tipo_item, 
					cd_item, 
					cd_atuacao, 
					cd_prestador, 
					dt_item, 
					qt_item, 
					nr_seq_item, 
					ie_analitica_sintetica) 
				values (nr_seq_conta_w, 
					nr_seq_regra_w, 
					ds_item_w, 
					CASE WHEN ie_diaria_w='S' THEN qt_diaria_w  ELSE null END , 
					vl_item_w, 
					ie_tipo_item_w, 
					cd_item_w, 
					cd_atuacao_w, 
					cd_prestador_w, 
					dt_item_w, 
					qt_item_w, 
					nr_seq_inf_w, 
					'S');
			else 
 
				update	w_conta_pmmg_item 
				set	qt_diaria		= CASE WHEN ie_diaria_w='S' THEN qt_diaria + qt_diaria_w  ELSE null END , 
					vl_item			= vl_item + vl_item_w 
				where	nr_seq_conta_pmmg	= nr_seq_conta_w 
				and	nr_seq_regra		= nr_seq_regra_w 
				and	ie_analitica_sintetica	= 'S';
			end if;
			/* fim geraÇÃo da conta sintÉtica (resumo) */
 
 
 
--			dbms_output.put_line('cd_material_w = ' || cd_material_w); 
 
			/* inÍcio geraÇÃo da conta analÍtica */
 
			insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
				nr_seq_regra, 
				ds_item, 
				qt_diaria, 
				vl_item, 
				ie_tipo_item, 
				cd_item, 
				cd_atuacao, 
				cd_prestador, 
				dt_item, 
				qt_item, 
				nr_seq_item, 
				ie_analitica_sintetica, 
				vl_unitario_item) 
			values (nr_seq_conta_w, 
				nr_seq_regra_w, 
				ds_material_w, 
				null, 
				vl_material_w, 
				ie_tipo_item_w, 
				cd_material_w, 
				null, 
				null, 
				null, 
				qt_material_w, 
				nr_seq_inf_w, 
				'A', 
				vl_unitario_w);
			/* inÍcio geraÇÃo da conta analÍtica */
 
 
		end if;
	end loop;
	close cmaterial;
 
	open cprocedimento;
	loop 
	fetch cprocedimento into 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		cd_setor_w, 
		cd_grupo_w, 
		cd_especialidade_w, 
		cd_area_w, 
		cd_cgc_prestador_w, 
		dt_procedimento_w, 
		qt_procedimento_w, 
		ds_procedimento_w, 
		vl_procedimento_w, 
		ds_procedimento_convenio_w, 
		cd_procedimento_convenio_w, 
		qt_porte_anestesico_w;
	EXIT WHEN NOT FOUND; /* apply on cprocedimento */
 
		ds_informacao_w		:= null;
		nr_seq_inf_w		:= null;
		ie_diaria_w		:= null;
		nr_seq_regra_w		:= null;
		cd_informacao_w		:= null;
 
		open cregraproc;
		loop 
		fetch cregraproc into 
			ds_informacao_w, 
			nr_seq_inf_w, 
			ie_diaria_w, 
			nr_seq_regra_w, 
			cd_informacao_w;
		EXIT WHEN NOT FOUND; /* apply on cregraproc */
 
			if (nr_seq_inf_w IS NOT NULL AND nr_seq_inf_w::text <> '') then 
 
				ds_item_w	:= null;
				dt_item_w	:= null;
				cd_atuacao_w	:= null;
				dt_item_w	:= null;
				vl_item_w	:= null;
				ie_tipo_item_w	:= null;
				cd_prestador_w	:= null;
				qt_item_w	:= 0;
				qt_diaria_w	:= null;
 
				if (nr_seq_inf_w = 1) then 
 
 
					select	coalesce(min(dt_procedimento), dt_procedimento_w) 
					into STRICT	dt_item_w 
					from	procedimento_paciente 
					where	cd_procedimento		= cd_procedimento_w 
					and	ie_origem_proced	= ie_origem_proced_w 
					and	nr_interno_conta	= nr_interno_conta_w 
					and	coalesce(cd_motivo_exc_conta::text, '') = '' 
					and	vl_procedimento		= vl_procedimento_w;
 
					cd_item_w		:= cd_informacao_w;
					ds_item_w		:= ds_informacao_w;
					qt_item_w		:= qt_procedimento_w;
					vl_item_w		:= vl_procedimento_w;
 
 
				elsif (nr_seq_inf_w = 2) then 
	 
					ds_item_w		:= cd_procedimento_convenio_w;
					dt_item_w		:= dt_procedimento_w;
					cd_item_w		:= cd_informacao_w;
					qt_item_w		:= qt_porte_anestesico_w;
 
				elsif (nr_seq_inf_w = 3) then 
	 
					ds_item_w		:= ds_informacao_w;
					vl_item_w		:= vl_procedimento_w;
					qt_item_w		:= qt_procedimento_w;
					dt_item_w		:= dt_periodo_inicial_w;
					cd_item_w		:= cd_informacao_w;
	 
				end if;
 
				if (ie_diaria_w = 'S') then 
					qt_diaria_w		:= qt_item_w;
				end if;
 
				select	count(*) 
				into STRICT	ie_existe_w 
				from 	w_conta_pmmg_item 
				where	nr_seq_conta_pmmg	= nr_seq_conta_w 
				and	nr_seq_regra		= nr_seq_regra_w 
				and	ie_analitica_sintetica	= 'S';
 
				/* inÍcio geraÇÃo da conta sintÉtica (resumo)*/
 
				if (nr_seq_inf_w in (1,2)) or (ie_existe_w = 0) then 
					insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
						nr_seq_regra, 
						ds_item, 
						qt_diaria, 
						vl_item, 
						ie_tipo_item, 
						cd_item, 
						cd_atuacao, 
						cd_prestador, 
						dt_item, 
						qt_item, 
						nr_seq_item, 
						ie_analitica_sintetica) 
					values (nr_seq_conta_w, 
						nr_seq_regra_w, 
						ds_item_w, 
						CASE WHEN ie_diaria_w='S' THEN qt_diaria_w  ELSE null END , 
						vl_item_w, 
						ie_tipo_item_w, 
						cd_item_w, 
						cd_atuacao_w, 
						cd_prestador_w, 
						dt_item_w, 
						qt_item_w, 
						nr_seq_inf_w, 
						'S');
				else 
					update	w_conta_pmmg_item 
					set	qt_diaria		= CASE WHEN ie_diaria_w='S' THEN qt_diaria + qt_diaria_w  ELSE null END , 
						vl_item			= vl_item + vl_item_w 
					where	nr_seq_conta_pmmg	= nr_seq_conta_w 
					and	nr_seq_regra		= nr_seq_regra_w 
					and	ie_analitica_sintetica	= 'S';
				end if;
				/* fim geraÇÃo da conta sintÉtica (resumo) */
 
 
				/* inÍcio geraÇÃo da conta analÍtica */
 
				insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
					nr_seq_regra, 
					ds_item, 
					qt_diaria, 
					vl_item, 
					ie_tipo_item, 
					cd_item, 
					cd_atuacao, 
					cd_prestador, 
					dt_item, 
					qt_item, 
					nr_seq_item, 
					ie_analitica_sintetica, 
					vl_unitario_item) 
				values (nr_seq_conta_w, 
					nr_seq_regra_w, 
					substr(ds_procedimento_w,1,254), 
					null, 
					vl_procedimento_w, 
					ie_tipo_item_w, 
					cd_procedimento_convenio_w, 
					null, 
					null, 
					dt_procedimento_w, 
					qt_procedimento_w, 
					nr_seq_inf_w, 
					'A', 
					dividir(vl_procedimento_w, qt_procedimento_w));
				/* fim geraÇÃo da conta analÍtica */
 
 
			end if;
		end loop;
		close cregraproc;
 
 
	end loop;
	close cprocedimento;
 
	open chonorario;
	loop 
	fetch chonorario into 
		cd_procedimento_w, 
		ie_origem_proced_w, 
		cd_setor_w, 
		cd_grupo_w, 
		cd_especialidade_w, 
		cd_area_w, 
		cd_cgc_prestador_w, 
		dt_procedimento_w, 
		qt_procedimento_w, 
		ds_procedimento_w, 
		vl_medico_w, 
		cd_medico_w, 
		ie_credenciado_w, 
		nr_cpf_medico_w, 
		cd_atuacao_convenio_w, 
		cd_procedimento_convenio_w, 
		vl_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on chonorario */
 
		open cregrahonorario;
		loop 
		fetch cregrahonorario into 
			ds_informacao_w, 
			nr_seq_inf_w, 
			ie_diaria_w, 
			nr_seq_regra_w, 
			cd_informacao_w;
		EXIT WHEN NOT FOUND; /* apply on cregrahonorario */
 
			ds_item_w	:= ds_procedimento_w;
			dt_item_w	:= null;
			dt_item_w	:= null;
			vl_item_w	:= vl_medico_w;
			ie_tipo_item_w	:= null;
			cd_prestador_w	:= nr_cpf_medico_w;
			qt_item_w	:= 0;
			qt_diaria_w	:= null;
 
			/*if	(nvl(ie_credenciado_w,'N') = 'N') then			somente exibir o CPF a pedido do sergio. 
				ie_tipo_item_w		:= '00'; 
				cd_prestador_w		:= cd_cgc_estabelecimento_w; 
				vl_item_w			:= vl_procedimento_w; 
			else 
				ie_tipo_item_w		:= '01'; 
				cd_prestador_w		:= nr_cpf_medico_w; 
				vl_item_w			:= vl_medico_w; 
			end if; 
			*/
  
			 
			 
 
			cd_atuacao_w		:= cd_atuacao_convenio_w;
			cd_item_w		:= coalesce(cd_procedimento_convenio_w, cd_procedimento_w);
			qt_item_w		:= qt_procedimento_w;
			dt_item_w		:= dt_procedimento_w;
 
			if (ie_diaria_w = 'S') then 
				-- apenas os dias referentes ao período da conta 
				qt_dia_conta_w		:= dt_periodo_final_w - dt_periodo_inicial_w;
				if (qt_diaria_w > qt_dia_conta_w) then 
					qt_item_w	:= qt_dia_conta_w;
				end if;
				qt_diaria_w		:= qt_item_w;
			end if;
 
 
			insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
				nr_seq_regra, 
				ds_item, 
				qt_diaria, 
				vl_item, 
				ie_tipo_item, 
				cd_item, 
				cd_atuacao, 
				cd_prestador, 
				dt_item, 
				qt_item, 
				nr_seq_item, 
				cd_medico, 
				ie_analitica_sintetica, 
				ie_origem_proced) 
			values (nr_seq_conta_w, 
				nr_seq_regra_w, 
				ds_item_w, 
				CASE WHEN ie_diaria_w='S' THEN qt_diaria_w  ELSE null END , 
				vl_item_w, 
				ie_tipo_item_w, 
				cd_item_w, 
				cd_atuacao_w, 
				cd_prestador_w, 
				dt_item_w, 
				qt_item_w, 
				nr_seq_inf_w, 
				cd_medico_w, 
				'S', 
				ie_origem_proced_w);
 
			insert into w_conta_pmmg_item(nr_seq_conta_pmmg, 
				nr_seq_regra, 
				ds_item, 
				qt_diaria, 
				vl_item, 
				ie_tipo_item, 
				cd_item, 
				cd_atuacao, 
				cd_prestador, 
				dt_item, 
				qt_item, 
				nr_seq_item, 
				cd_medico, 
				ie_analitica_sintetica, 
				vl_unitario_item, 
				ie_origem_proced) 
			values (nr_seq_conta_w, 
				nr_seq_regra_w, 
				ds_item_w, 
				CASE WHEN ie_diaria_w='S' THEN qt_diaria_w  ELSE null END , 
				vl_item_w, 
				ie_tipo_item_w, 
				cd_item_w, 
				cd_atuacao_w, 
				cd_prestador_w, 
				dt_procedimento_w, 
				qt_item_w, 
				nr_seq_inf_w, 
				cd_medico_w, 
				'A', 
				dividir(vl_item_w,qt_item_w), 
				ie_origem_proced_w);
		end loop;
		close cregrahonorario;
	end loop;
	close chonorario;
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hbh_gerar_w_conta_pmmg ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

