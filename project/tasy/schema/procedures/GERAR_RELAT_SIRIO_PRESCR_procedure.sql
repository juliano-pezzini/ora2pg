-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_relat_sirio_prescr (nr_prescricao_p bigint) AS $body$
DECLARE


nr_atendimento_w	bigint;
nr_seq_exame_w		bigint;
nm_exame_w		varchar(100);
nr_seq_prescr_w		integer;
ds_result_atual_w	varchar(150);
ds_result_ant1_w	varchar(60);
ds_result_ant2_w	varchar(60);
ds_result_ant3_w	varchar(60);
ds_result_ant4_w	varchar(60);
ds_result_ant5_w	varchar(60);
dt_atual_w		timestamp;
dt_ant1_w		timestamp;
dt_ant2_w		timestamp;
dt_ant3_w		timestamp;
dt_ant4_w		timestamp;
dt_ant5_w		timestamp;
ds_referencia_w		varchar(100);
ds_referencia1_w	varchar(100);
ds_referencia2_w	varchar(100);
ds_referencia3_w	varchar(100);
ds_referencia4_w	varchar(100);
ds_referencia5_w	varchar(100);
ds_referencia_ww	varchar(100);
nr_prescricao_ant1_w	bigint;
nr_prescricao_ant2_w	bigint;
nr_prescricao_ant3_w	bigint;
nr_prescricao_ant4_w	bigint;
nr_prescricao_ant5_w	bigint;
nr_prescricao_ant6_w	bigint;
ie_ult_result_vazio_w	varchar(1);
ie_exam_prescrito_w	varchar(1);
nr_prescricao_exame_w	bigint;
ie_linha_w		integer;
nr_prescricao_ant_w	bigint;
dt_aprov_prescr_ant_w	timestamp;
ds_result_ant_w		varchar(255);
nr_prescricao_w		bigint;
dt_prev_exec_w		timestamp;


ds_exame_w			varchar(255);
nr_seq_prescr_origem_w		integer;
nr_prescricao_origem_w		bigint;
NR_SEQ_PAI_W			bigint;

nr_prescr_update_w		bigint;
nr_seq_prescr_update_w		integer;

C01 CURSOR FOR
	SELECT	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant1_w
	
union all

	SELECT	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant2_w
	and 	nr_seq_exame not in (select coalesce(nr_seq_exame,0) from prescr_procedimento where nr_prescricao in (nr_prescricao_ant1_w))
	
union all

	select	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant3_w
	and 	nr_seq_exame not in (select coalesce(nr_seq_exame,0) from prescr_procedimento where nr_prescricao in (nr_prescricao_ant1_w,nr_prescricao_ant2_w))
	
union all

	select	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant4_w
	and 	nr_seq_exame not in (select coalesce(nr_seq_exame,0) from prescr_procedimento where nr_prescricao in (nr_prescricao_ant1_w,nr_prescricao_ant2_w,nr_prescricao_ant3_w))
	
union all

	select	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant5_w
	and 	nr_seq_exame not in (select coalesce(nr_seq_exame,0) from prescr_procedimento where nr_prescricao in (nr_prescricao_ant1_w,nr_prescricao_ant2_w,nr_prescricao_ant3_w,nr_prescricao_ant4_w))
	
union all

	select	distinct
		nr_seq_exame,
		substr(obter_desc_exame(nr_seq_exame),1,100),
		nr_sequencia,
		nr_prescricao
	from	prescr_procedimento
	where	(nr_seq_exame IS NOT NULL AND nr_seq_exame::text <> '')
	and	nr_prescricao = nr_prescricao_ant6_w
	and 	nr_seq_exame not in (select coalesce(nr_seq_exame,0) from prescr_procedimento where nr_prescricao in (nr_prescricao_ant1_w,nr_prescricao_ant2_w,nr_prescricao_ant3_w,nr_prescricao_ant4_w, nr_prescricao_ant5_w))
	order by 2;

C03 CURSOR FOR
	SELECT	distinct
		c.nr_seq_exame,
		substr(obter_desc_exame(c.nr_seq_exame),1,100)
	from	exame_laboratorio d,
		exame_lab_result_item c,
		exame_lab_resultado b,
		prescr_medica a
	where	a.nr_prescricao 	= b.nr_prescricao
	and	b.nr_seq_resultado	= c.nr_seq_resultado
	and	c.nr_seq_exame		= d.nr_seq_exame
	and	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')
	and	b.nr_prescricao = nr_prescricao_origem_w
	and	((c.nr_seq_prescr = nr_seq_prescr_origem_w) or (c.nr_seq_prescr = 0 and lab_obter_seq_prescr(a.nr_prescricao,c.nr_seq_exame) = nr_seq_prescr_origem_w));

C04 CURSOR FOR /* Buscando os exames da 6 últimas prescrições*/
	SELECT row_number() OVER () AS rownum, nr_prescricao
	FROM (
	SELECT 	x.nr_prescricao, MAX(x.dt_prev_execucao)dt_prev_exec
	FROM (
	SELECT	DISTINCT
		a.nr_prescricao,
		e.dt_prev_execucao
	FROM	exame_laboratorio d,
		exame_lab_result_item c,
		exame_lab_resultado b,
		PRESCR_procedimento e,
		prescr_medica a
	WHERE	a.nr_prescricao 	= b.nr_prescricao
	AND	b.nr_seq_resultado	= c.nr_seq_resultado
	AND	c.nr_seq_exame		= d.nr_seq_exame
	AND	e.nr_prescricao 	= a.nr_prescricao
	AND	(c.nr_seq_exame IS NOT NULL AND c.nr_seq_exame::text <> '')
	AND	a.nr_prescricao 	IN (	SELECT	x.nr_prescricao
						FROM (SELECT DISTINCT a.nr_prescricao
								FROM exame_laboratorio d,
								 exame_lab_result_item c,
								 exame_lab_resultado b,
								 prescr_procedimento e,
								 prescr_medica a
								WHERE b.nr_seq_resultado = c.nr_seq_resultado
								AND d.nr_seq_exame   = c.nr_seq_exame
								AND b.nr_prescricao  = a.nr_prescricao
								AND e.nr_prescricao = a.nr_prescricao
								AND a.nr_atendimento  = nr_atendimento_w
								AND a.nr_prescricao  <= nr_prescricao_p
								ORDER BY nr_prescricao DESC
								) x LIMIT 5)
		ORDER BY a.nr_prescricao DESC) x
	GROUP BY x.nr_prescricao
	ORDER BY 2 DESC) alias5;

C05 CURSOR FOR
	SELECT	distinct
		a.nr_prescricao,
		a.nr_sequencia
	from 	prescr_procedimento a,
		prescr_medica b
	where   a.nr_prescricao = b.nr_prescricao
	and	a.nr_prescricao <= nr_prescricao_p
	and	b.nr_atendimento = nr_atendimento_w
	and	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and	coalesce(dt_emissao_resultado::text, '') = '';


BEGIN

delete from w_gerar_relat_sirio;
delete from w_gerar_relat_sirio_sup;

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;


open C05;
loop
fetch C05 into
	nr_prescr_update_w,
	nr_seq_prescr_update_w;
EXIT WHEN NOT FOUND; /* apply on C05 */
	begin
	update	prescr_procedimento
	set	dt_emissao_resultado 	= clock_timestamp()
	where	nr_prescricao		= nr_prescr_update_w
	and	nr_sequencia		= nr_seq_prescr_update_w;
	end;
end loop;
close C05;

open C04;
loop
fetch C04 into
	ie_linha_w,
	nr_prescricao_ant_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin

	if (ie_linha_w = 1) then
		nr_prescricao_ant1_w	:= 	nr_prescricao_ant_w;
	elsif (ie_linha_w = 2) then
		nr_prescricao_ant2_w	:= 	nr_prescricao_ant_w;
	elsif (ie_linha_w = 3) then
		nr_prescricao_ant3_w	:= 	nr_prescricao_ant_w;
	elsif (ie_linha_w = 4) then
		nr_prescricao_ant4_w	:= 	nr_prescricao_ant_w;
	elsif (ie_linha_w = 5) then
		nr_prescricao_ant5_w	:= 	nr_prescricao_ant_w;
	elsif (ie_linha_w = 6) then
		nr_prescricao_ant6_w	:= 	nr_prescricao_ant_w;
	end if;

	end;
end loop;
close C04;

open C01;
loop
fetch C01 into
	nr_seq_exame_w,
	ds_exame_w,
	nr_seq_prescr_origem_w,
	nr_prescricao_origem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

		select 	nextval('w_gerar_relat_sirio_sup_seq')
		into STRICT	nr_seq_pai_w
		;

		insert into w_gerar_relat_sirio_sup(nr_sequencia,
					nr_seq_exame,
					nr_seq_prescr,
					ds_exame,
					nr_prescricao,
					ie_ult_result_vazio)
		values (nr_seq_pai_w,
					nr_seq_exame_w,
					nr_seq_prescr_origem_w,
					ds_exame_w,
					nr_prescricao_origem_w,
					'N');

		open c03;
		loop
		fetch c03 into
			nr_seq_exame_w,
			nm_exame_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin

			select	CASE WHEN coalesce(max(obter_data_aprov_lab(nr_prescricao_p,c.nr_seq_prescr)),clock_timestamp())=clock_timestamp() THEN 				CASE WHEN lab_obter_exame_prescrito(nr_prescricao_p,nr_seq_exame_w)='' THEN '[*]'  ELSE 'Pendente' END   ELSE coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,100),'Pendente')),'[*]') END ,
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_atual_w,
				ds_referencia_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	a.nr_atendimento 	= nr_atendimento_w
			and	a.nr_prescricao 	= nr_prescricao_ant1_w
			and	c.nr_seq_exame		= nr_seq_exame_w;

			select	substr(coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,60),'Pendente')),'[*]'),1,60),
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_ant1_w,
				ds_referencia1_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_w
			and	a.nr_prescricao		= nr_prescricao_ant2_w;

			select	substr(coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,60),'Pendente')),'[*]'),1,60),
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_ant2_w,
				ds_referencia2_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_w
			and	a.nr_prescricao		= nr_prescricao_ant3_w;

			select	substr(coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,60),'Pendente')),'[*]'),1,60),
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_ant3_w,
				ds_referencia3_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_w
			and	a.nr_prescricao		= nr_prescricao_ant4_w;

			select	substr(coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,60),'Pendente')),'[*]'),1,60),
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_ant4_w,
				ds_referencia4_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_w
			and	a.nr_prescricao		= nr_prescricao_ant5_w;

			select	substr(coalesce(max(coalesce(substr(coalesce(coalesce(CASE WHEN c.ds_resultado='0' THEN ''  ELSE CASE WHEN d.ie_formato_resultado='V' THEN ''  ELSE c.ds_resultado END  END ,	coalesce(to_char(c.qt_resultado),to_char(CASE WHEN c.pr_resultado=0 THEN ''  ELSE c.pr_resultado END ))),c.ds_resultado),1,60),'Pendente')),'[*]'),1,60),
				max(substr(ds_referencia,1,100)||coalesce(c.ds_unidade_medida,substr(obter_lab_unid_med(c.nr_seq_unid_med,'D'),1,40)))
			into STRICT	ds_result_ant5_w,
				ds_referencia5_w
			from	exame_laboratorio d,
				exame_lab_result_item c,
				exame_lab_resultado b,
				prescr_medica a
			where	b.nr_seq_resultado	= c.nr_seq_resultado
			and	d.nr_seq_exame 		= c.nr_seq_exame
			and	b.nr_prescricao		= a.nr_prescricao
			and	c.nr_seq_exame		= nr_seq_exame_w
			and	a.nr_prescricao		= nr_prescricao_ant6_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_atual_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant1_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_ant1_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant2_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_ant2_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant3_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_ant3_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant4_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_ant4_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant5_w;

			select	max(dt_prev_execucao)
			into STRICT	dt_ant5_w
			from	prescr_procedimento
			where	nr_prescricao	= nr_prescricao_ant6_w;

			/* Verifcando se os 6 útimos resultados não existem */

			if (ds_result_atual_w	= '[*]') and (ds_result_ant1_w 	= '[*]') and (ds_result_ant2_w 	= '[*]') and (ds_result_ant3_w 	= '[*]') and (ds_result_ant4_w 	= '[*]') and (ds_result_ant5_w 	= '[*]') then

				begin

				ie_ult_result_vazio_w	:= 'S';

				update	w_gerar_relat_sirio_sup
				set	ie_ult_result_vazio = 'S'
				where	nr_sequencia = nr_seq_pai_w
				and	nr_seq_exame = nr_seq_exame_w;

				end;
			else
				ie_ult_result_vazio_w	:= 'N';
			end if;

			if (ds_referencia_w IS NOT NULL AND ds_referencia_w::text <> '') then
				ds_referencia_ww := ds_referencia_w;
			elsif (ds_referencia1_w IS NOT NULL AND ds_referencia1_w::text <> '') then
				ds_referencia_ww := ds_referencia1_w;
			elsif (ds_referencia2_w IS NOT NULL AND ds_referencia2_w::text <> '') then
				ds_referencia_ww := ds_referencia2_w;
			elsif (ds_referencia3_w IS NOT NULL AND ds_referencia3_w::text <> '') then
				ds_referencia_ww := ds_referencia3_w;
			elsif (ds_referencia4_w IS NOT NULL AND ds_referencia4_w::text <> '') then
				ds_referencia_ww := ds_referencia4_w;
			elsif (ds_referencia5_w IS NOT NULL AND ds_referencia5_w::text <> '') then
				ds_referencia_ww := ds_referencia5_w;
			else
				ds_referencia_ww := '';
			end if;

			/* Inserindo registros  */

			insert into w_gerar_relat_sirio(nr_prescricao,
							nr_seq_exame,
							nm_exame,
							ds_referencia,
							ds_result_atual,
							ds_result_ant1,
							ds_result_ant2,
							ds_result_ant3,
							ds_result_ant4,
							ds_result_ant5,
							dt_atual,
							dt_ant1,
							dt_ant2,
							dt_ant3,
							dt_ant4,
							dt_ant5,
							nr_prescricao_ant1,
							nr_prescricao_ant2,
							nr_prescricao_ant3,
							nr_prescricao_ant4,
							nr_prescricao_ant5,
							ie_ult_result_vazio,
							nr_seq_superior)
					values (nr_prescricao_p,
							nr_seq_exame_w,
							nm_exame_w,
							ds_referencia_ww,
							ds_result_atual_w,
							ds_result_ant1_w,
							ds_result_ant2_w,
							ds_result_ant3_w,
							ds_result_ant4_w,
							ds_result_ant5_w,
							dt_atual_w,
							dt_ant1_w,
							dt_ant2_w,
							dt_ant3_w,
							dt_ant4_w,
							dt_ant5_w,
							nr_prescricao_ant1_w,
							nr_prescricao_ant2_w,
							nr_prescricao_ant3_w,
							nr_prescricao_ant4_w,
							nr_prescricao_ant5_w,
							ie_ult_result_vazio_w,
							nr_seq_pai_w);
		end;
		end loop;
		close C03;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_relat_sirio_prescr (nr_prescricao_p bigint) FROM PUBLIC;
