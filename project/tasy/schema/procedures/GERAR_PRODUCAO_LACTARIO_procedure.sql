-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_producao_lactario ( nr_seq_producao_p bigint, Ie_Excluir_itens_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_producao_w	timestamp;
ie_tipo_w	varchar(1);
nr_seq_turno_w	bigint;
hr_inicial_w	timestamp;
hr_final_w	timestamp;
dt_inicio_turno_w	timestamp;
dt_fim_turno_w		timestamp;

nr_prescricao_w		bigint;
nr_Seq_material_w	bigint;
nr_Seq_mat_hor_w	bigint;
qt_dose_w		double precision;
cd_material_w		bigint;
dt_horario_w		timestamp;
nr_atendimento_w	bigint;
nr_Seq_prod_item_w	bigint;
cd_estabelecimento_w	smallint;


nr_Seq_material_deriv_w	bigint;
qt_dose_deriv_w		double precision;
qt_porcentagem_deriv_w	double precision;
cd_material_deriv_w	bigint;

C01 CURSOR FOR
	SELECT	a.nr_prescricao,
		a.nr_Sequencia,
		c.nr_sequencia,
		a.qt_dose,
		c.cd_material,
		c.dt_horario,
		b.nr_atendimento
	FROM	prescr_material a,
		prescr_medica b,
		prescr_mat_hor c,
		prescr_leite_deriv d
	WHERE	a.nr_prescricao = b.nr_prescricao
	and 	(b.nr_atendimento IS NOT NULL AND b.nr_atendimento::text <> '')
	AND	a.nr_seq_leite_deriv = d.nr_sequencia
	AND ((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> ''))
	AND	coalesce(a.ie_suspenso,'N') <> 'S'
	AND	d.ie_se_necessario = 'N'
	AND	c.nr_prescricao = a.nr_prescricao
	AND 	coalesce(c.dt_suspensao::text, '') = ''
	AND	a.nr_sequencia = c.nr_seq_material
	AND 	(c.dt_lib_horario IS NOT NULL AND c.dt_lib_horario::text <> '')
	AND	dt_horario BETWEEN dt_inicio_turno_w AND dt_fim_turno_w
	AND (b.cd_estabelecimento = cd_estabelecimento_w or coalesce(cd_estabelecimento_w::text, '') = '')
	AND	not exists (SELECT 1 from nut_producao_lactario_item z
			    where c.nr_sequencia = z.nr_Seq_mat_hor);

			
C02 CURSOR FOR
	SELECT	a.nr_Sequencia,		
		a.qt_dose,
		a.qt_porcentagem,
		a.cd_material
	from	prescr_material a
	where	a.nr_prescricao 	= nr_prescricao_w
	and	a.nr_Sequencia_diluicao 	= nr_Seq_material_w;
	
C03 CURSOR FOR
	SELECT	a.nr_prescricao,
		a.nr_Sequencia,		
		a.qt_dose,
		a.cd_material,
		b.nr_atendimento
	FROM	prescr_material a,
		prescr_medica b,			
		prescr_leite_deriv d
	WHERE	a.nr_prescricao = b.nr_prescricao
	and 	(b.nr_atendimento IS NOT NULL AND b.nr_atendimento::text <> '')
	AND	a.nr_seq_leite_deriv = d.nr_sequencia
	AND ((b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') or (b.dt_liberacao_medico IS NOT NULL AND b.dt_liberacao_medico::text <> ''))
	AND	coalesce(a.ie_suspenso,'N') <> 'S'
	AND 	d.ie_se_necessario = 'S'
	AND (dt_inicio_turno_w BETWEEN dt_inicio_prescr AND dt_validade_prescr OR
 		 dt_fim_turno_w BETWEEN dt_inicio_prescr AND dt_validade_prescr)
	AND (b.cd_estabelecimento = cd_estabelecimento_w or coalesce(cd_estabelecimento_w::text, '') = '')
	AND	NOT EXISTS (SELECT 1 FROM nut_producao_lactario_item z
			    WHERE a.nr_sequencia = z.nr_Seq_prescr
				AND	  a.nr_prescricao = z.nr_prescricao);		


BEGIN

if (Ie_Excluir_itens_p = 'S') then
	begin
	delete	FROM nut_prod_alt_item a
	where	exists (SELECT 	1
			from 	nut_producao_lactario_item b
			where	b.nr_seq_prod_lac = nr_seq_producao_p
			and	coalesce(b.dt_producao::text, '') = ''
			and	a.nr_seq_nut_prod_lac_item = nr_sequencia);
	
	delete	FROM nut_producao_lactario_item
	where	nr_seq_prod_lac	= nr_seq_producao_p
	and	coalesce(dt_producao::text, '') = '';	
	end;
end if;

select	max(dt_producao),
	max(ie_tipo),
	max(nr_seq_turno),
	max(cd_estabelecimento)
into STRICT	dt_producao_w,
	ie_tipo_w,
	nr_seq_turno_w,
	cd_estabelecimento_w
from	nut_producao_lactario
where	nr_Sequencia =	nr_seq_producao_p;

select	hr_inicial,
	hr_final
into STRICT	hr_inicial_w,
	hr_final_w
from	nut_turno_lactario
where	nr_sequencia	= nr_seq_turno_w;

dt_inicio_turno_w	:=	to_date(to_char(dt_producao_w,'dd/mm/yyyy')||' ' || to_char(hr_inicial_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
dt_fim_turno_w		:=	to_date(to_char(dt_producao_w,'dd/mm/yyyy')||' ' || to_char(hr_final_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');
if (dt_fim_turno_w < dt_inicio_turno_w) then
	dt_fim_turno_w	:=	dt_fim_turno_w+1;
end if;

if (ie_tipo_w = 'N') then

	
	
	open C01;
	loop
	fetch C01 into	
		nr_prescricao_w,
		nr_Seq_material_w,
		nr_Seq_mat_hor_w,
		qt_dose_w,
		cd_material_w,
		dt_horario_w,
		nr_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		
		select	nextval('nut_producao_lactario_item_seq')
		into STRICT	nr_Seq_prod_item_w
		;
		
		insert into nut_producao_lactario_item(	nr_sequencia,
							nr_atendimento,
							cd_material,
							qt_dose,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_prescricao,
							nr_seq_prod_lac,
							nr_seq_prescr,
							nr_seq_mat_hor,
							dt_horario)
						values (nr_Seq_prod_item_w,
							nr_atendimento_w,
							cd_material_w,
							qt_dose_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_prescricao_w,
							nr_seq_producao_p,
							nr_Seq_material_w,
							nr_Seq_mat_hor_w,
							dt_horario_w);		
		open C02;
		loop
		fetch C02 into	
			nr_Seq_material_deriv_w,
			qt_dose_deriv_w,
			qt_porcentagem_deriv_w,
			cd_material_deriv_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			insert into nut_producao_lac_item_adic(NR_SEQUENCIA,
				CD_MATERIAL,
				QT_DOSE,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				NR_PRESCRICAO,
				NR_SEQ_MATERIAL,
				NR_SEQ_PROD_ITEM,
				NR_SEQ_NUT_PROD_LAC,
				PR_DOSE)
			values (nextval('nut_producao_lac_item_adic_seq'),
				cd_material_deriv_w,
				qt_dose_deriv_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_w,
				nr_Seq_material_deriv_w,
				nr_Seq_prod_item_w,
				nr_seq_producao_p,
				qt_porcentagem_deriv_w);
			
			
			
			end;
		end loop;
		close C02;
		
		end;
	end loop;
	close C01;
else
	open C03;
	loop
	fetch C03 into	
		nr_prescricao_w,
		nr_Seq_material_w,		
		qt_dose_w,
		cd_material_w,		
		nr_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		
		select	nextval('nut_producao_lactario_item_seq')
		into STRICT	nr_Seq_prod_item_w
		;
		
		insert into nut_producao_lactario_item(	nr_sequencia,
							nr_atendimento,
							cd_material,
							qt_dose,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_prescricao,
							nr_seq_prod_lac,
							nr_seq_prescr)
						values (nr_Seq_prod_item_w,
							nr_atendimento_w,
							cd_material_w,
							qt_dose_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),
							nm_usuario_p,
							nr_prescricao_w,
							nr_seq_producao_p,
							nr_Seq_material_w);		
		open C02;
		loop
		fetch C02 into	
			nr_Seq_material_deriv_w,
			qt_dose_deriv_w,
			qt_porcentagem_deriv_w,
			cd_material_deriv_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			
			insert into nut_producao_lac_item_adic(NR_SEQUENCIA,
				CD_MATERIAL,
				QT_DOSE,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				NR_PRESCRICAO,
				NR_SEQ_MATERIAL,
				NR_SEQ_PROD_ITEM,
				NR_SEQ_NUT_PROD_LAC,
				PR_DOSE)
			values (nextval('nut_producao_lac_item_adic_seq'),
				cd_material_deriv_w,
				qt_dose_deriv_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_w,
				nr_Seq_material_deriv_w,
				nr_Seq_prod_item_w,
				nr_seq_producao_p,
				qt_porcentagem_deriv_w);
			
			
			
			end;
		end loop;
		close C02;		
		
		
		
		end;
	end loop;
	close C03;

end if;


commit;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_producao_lactario ( nr_seq_producao_p bigint, Ie_Excluir_itens_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
