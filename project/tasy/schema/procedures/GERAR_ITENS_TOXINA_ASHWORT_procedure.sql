-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_toxina_ashwort ( nr_atendimento_p bigint, nr_seq_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_ashwort_w			bigint;
nr_seq_art_mov_musculo_w		bigint;
nr_seq_toxina_w			bigint;
qt_dose_padrao_w			double precision;
qt_pontos_min_w			double precision;
qt_dose_min_w			double precision;
qt_pontos_padrao_w		smallint;
cd_unidade_medida_w		varchar(30);
qt_idade_w			varchar(5);
qt_peso_w			bigint;
ie_ashworth_d_w			varchar(3);
ie_ashworth_e_w			varchar(3);
ie_forma_calculo_w			varchar(3);
cd_pessoa_fisica_w		varchar(10);
ds_regra_w			varchar(255);		
 
 
C01 CURSOR FOR 
	SELECT	b.nr_seq_art_mov_musculo, 
		b.ie_ashworth_d, 
		b.ie_ashworth_e 
	from	escala_ashworth_item b, 
		escala_ashworth a 
	where	b.nr_seq_ashworth = nr_seq_ashwort_w 
	and	b.nr_seq_ashworth = a.nr_sequencia 
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') 
	and	coalesce(a.dt_inativacao::text, '') = '' 
	and	((b.ie_ashworth_d <> '0') or (b.ie_ashworth_e <> '0'));
	
	 
C02 CURSOR FOR 
	SELECT	c.nr_seq_toxina, 
		c.QT_DOSE_PADRAO, 
		QT_PONTOS_PADRAO, 
		c.ie_forma_calculo, 
		c.QT_PONTOS_MIN, 
		c.QT_DOSE_MIN 
	from	artic_mov_musculo_regra c, 
		artic_mov_musculo d, 
		TOXINA_BOTULINICA e 
	where	c.nr_seq_art_mov_musculo = d.nr_sequencia 
	and	e.nr_sequencia = c.nr_seq_toxina 
	and	d.nr_sequencia = nr_seq_art_mov_musculo_w 
	and	qt_idade_w between coalesce(qt_idade_min,0) and coalesce(qt_idade_max,999) 
	and	qt_peso_w between coalesce(qt_peso_min,0) and coalesce(qt_peso_max,999) 
	order by e.NR_SEQ_PRIOR desc;
	
	 
	procedure inserir_tox_item(ie_lado_p text) is 
	nr_seq_item_w	bigint;
	
BEGIN
		 
		ds_regra_w := substr(obter_intervalos_mov_musc(cd_pessoa_fisica_w,nr_seq_art_mov_musculo_w,nr_seq_toxina_w),1,255);
		 
		select	nextval('atend_toxina_item_seq') 
		into STRICT	nr_seq_item_w 
		;
	 
		insert into	atend_toxina_item( 
					nr_sequencia, 
					nm_usuario, 
					dt_atualizacao, 
					nr_seq_art_mov_musculo, 
					nr_seq_toxina, 
					cd_unidade_medida, 
					qt_dose, 
					qt_dose_prescr, 
					qt_pontos_prev, 
					nr_seq_atendimento, 
					ie_lado, 
					ds_regra) 
			values ( 
					nr_seq_item_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					nr_seq_art_mov_musculo_w, 
					nr_seq_toxina_w, 
					cd_unidade_medida_w, 
					coalesce(qt_dose_padrao_w,qt_dose_min_w), 
					coalesce(qt_dose_padrao_w,qt_dose_min_w), 
					coalesce(qt_pontos_padrao_w,qt_pontos_min_w), 
					nr_seq_atendimento_p, 
					ie_lado_p, 
					ds_regra_w);	
		CALL gerar_dose_mov_musc(nr_seq_item_w);
	 
	end;
	 
	 
begin 
select	coalesce(max(obter_idade(dt_nascimento,clock_timestamp(),'A')),0), 
	max(a.cd_pessoa_fisica) 
into STRICT	qt_idade_w, 
	cd_pessoa_fisica_w 
from	pessoa_fisica a, 
	atendimento_paciente b 
where	a.cd_pessoa_fisica = b.cd_pessoa_fisica 
and	b.nr_atendimento = nr_atendimento_p;
 
qt_peso_w	:= coalesce(obter_sinal_vital(nr_atendimento_p,'Peso'),0);
 
 
 
select	max(nr_sequencia) 
into STRICT	nr_seq_ashwort_w 
from	escala_ashworth 
where	nr_atendimento = nr_atendimento_p 
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
and	coalesce(dt_inativacao::text, '') = '';
 
open C01;
loop 
fetch C01 into	 
	nr_seq_art_mov_musculo_w, 
	ie_ashworth_d_w, 
	ie_ashworth_e_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	nr_seq_toxina_w		:= null;
	qt_dose_padrao_w 	:= null;
	qt_pontos_padrao_w	:= null;
	cd_unidade_medida_w	:= null;
	 
	open C02;
	loop 
	fetch C02 into	 
		nr_seq_toxina_w, 
		qt_dose_padrao_w, 
		qt_pontos_padrao_w, 
		ie_forma_calculo_w, 
		qt_pontos_min_w, 
		qt_dose_min_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
	end loop;
	close C02;
	 
	if (upper(ie_forma_calculo_w) = 'F') then 
	 
		select	max(cd_unidade_medida)		 
		into STRICT	cd_unidade_medida_w 
		from	unidade_medida_dose_v a, 
			toxina_botulinica b 
		where	a.cd_material = b.cd_material 
		and	b.nr_sequencia = nr_seq_toxina_w 
		and	upper(a.ds_unidade_medida) not like('%UNIDADE%');		
	 
	 
	elsif (upper(ie_forma_calculo_w) = 'KG') then 
	 
		select	max(cd_unidade_medida)		 
		into STRICT	cd_unidade_medida_w 
		from	unidade_medida_dose_v a, 
			toxina_botulinica b 
		where	a.cd_material = b.cd_material 
		and	b.nr_sequencia = nr_seq_toxina_w 
		and	upper(a.ds_unidade_medida) like('%UNIDADE%');	
	 
	end if;
	 
	if (coalesce(cd_unidade_medida_w::text, '') = '') then 
	 
		select	max(cd_unidade_medida)		 
		into STRICT	cd_unidade_medida_w 
		from	unidade_medida_dose_v a, 
			toxina_botulinica b 
		where	a.cd_material = b.cd_material 
		and	b.nr_sequencia = nr_seq_toxina_w;
		 
	end if;
	 
	if (nr_seq_toxina_w > 0) 	then		 
		 
		/*if 	(ie_ashworth_d_w = ie_ashworth_e_w) then 
		 
			inserir_tox_item('A'); 
					 
		else */
 
		if (ie_ashworth_d_w IS NOT NULL AND ie_ashworth_d_w::text <> '') and (ie_ashworth_d_w <> '0') then 
		 
			inserir_tox_item('D');
		 
		end if;
		 
		if (ie_ashworth_e_w IS NOT NULL AND ie_ashworth_e_w::text <> '') and (ie_ashworth_e_w <> '0') then 
		 
			inserir_tox_item('E');
		 
		end if;
		--end if; 
		 
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
-- REVOKE ALL ON PROCEDURE gerar_itens_toxina_ashwort ( nr_atendimento_p bigint, nr_seq_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
