-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dose_mov_musc ( nr_seq_item_p bigint) AS $body$
DECLARE

 
nr_seq_toxina_w		bigint;			
qt_conversao_w		double precision;
qt_dose_w		double precision;
qt_dose_prescr_w		double precision;
nr_Seq_atendimento_w	bigint;
nr_Atendimento_w		bigint;
qt_idade_w		integer;
qt_peso_w		double precision;
ie_forma_calculo_w		varchar(3);
cd_pessoa_fisica_w	varchar(255);
nr_seq_art_mov_musculo_w 	bigint;
cd_unidade_medida_w	varchar(30);		
qt_dose_diluida_w double precision;
qt_conversao_calc_w		double precision;


BEGIN 
 
select	max(nr_seq_toxina), 
	max(qt_dose), 
	max(nr_Seq_atendimento), 
	max(nr_seq_art_mov_musculo) 
into STRICT	nr_seq_toxina_w, 
	qt_dose_w, 
	nr_Seq_atendimento_w, 
	nr_seq_art_mov_musculo_w 
from	atend_toxina_item 
where	nr_sequencia = nr_seq_item_p;
 
select 	max(nr_Atendimento) 
into STRICT	nr_Atendimento_w 
from 	atendimento_toxina 
where	nr_Sequencia = nr_Seq_atendimento_w;
 
 
cd_pessoa_fisica_w	:= obter_pessoa_atendimento(nr_atendimento_w,'C');
 
select	max(obter_idade(dt_nascimento,clock_timestamp(),'A')) 
into STRICT	qt_idade_w 
from	pessoa_fisica 
where	cd_pessoa_fisica = cd_pessoa_fisica_w;
 
select	coalesce(max(qt_peso),0) 
into STRICT	qt_peso_w 
from	atendimento_sinal_vital	 
where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1) 
			from	atendimento_sinal_vital 
			where	(qt_peso IS NOT NULL AND qt_peso::text <> '') 
			and	cd_paciente	= cd_pessoa_fisica_w 
			and	ie_situacao = 'A' 
			and	coalesce(IE_RN,'N')	= 'N');
 
 
select	max(ie_forma_calculo) 
into STRICT	ie_forma_calculo_w 
from 	artic_mov_musculo_regra a 
where 	a.nr_seq_art_mov_musculo = nr_seq_art_mov_musculo_w 
and	qt_idade_w between a.qt_idade_min and a.qt_idade_max 
and 	qt_peso_w between coalesce(a.qt_peso_min,0) and coalesce(a.qt_peso_max,999);
 
 
select	max(qt_conversao) 
into STRICT	qt_conversao_w 
from	toxina_botulinica 
where	nr_sequencia = nr_seq_toxina_w;
 
if (upper(ie_forma_calculo_w) = 'KG') then 
	 
	qt_dose_prescr_w	:= (qt_dose_w	* qt_peso_w * qt_conversao_w);
	select	max(cd_unidade_medida)		 
	into STRICT	cd_unidade_medida_w 
	from	unidade_medida_dose_v a, 
		toxina_botulinica b 
	where	a.cd_material = b.cd_material 
	and	b.nr_sequencia = nr_seq_toxina_w 
	and	upper(a.ds_unidade_medida) like('%UNIDADE%');
	 
	qt_dose_diluida_w := null;
else 
	qt_dose_prescr_w	:= (qt_dose_w	* qt_conversao_w);
	select	max(cd_unidade_medida)		 
	into STRICT	cd_unidade_medida_w 
	from	unidade_medida_dose_v a, 
		toxina_botulinica b 
	where	a.cd_material = b.cd_material 
	and	b.nr_sequencia = nr_seq_toxina_w 
	and	upper(a.cd_unidade_medida) = 'UI';
 
	select max(CASE WHEN qt_conversao_w=0 THEN  1  ELSE qt_conversao_w END ) 
	into STRICT  qt_conversao_calc_w 
	;
	 
	qt_dose_diluida_w := qt_dose_prescr_w / coalesce(qt_conversao_calc_w, 2.2);
	 
	if (qt_conversao_calc_w = 0) then 
		qt_dose_diluida_w := null;
	end if;
	 
end if;
 
if (qt_dose_prescr_w > 0) then 
 
	if (coalesce(ie_forma_calculo_w::text, '') = '') then 
	 
		update	atend_toxina_item 
		set	qt_dose_prescr	= qt_dose_prescr_w, 
		  qt_dose_diluida = qt_dose_diluida_w, 
			qt_diluente = qt_conversao_w 
		where	nr_sequencia = nr_seq_item_p;
	 
	else 
		update	atend_toxina_item 
		set	qt_dose_prescr	= qt_dose_prescr_w, 
			cd_unidade_medida = cd_unidade_medida_w, 
			qt_dose_diluida = qt_dose_diluida_w, 
			qt_diluente = qt_conversao_w 
		where	nr_sequencia = nr_seq_item_p;
	end if;
end if;
 
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dose_mov_musc ( nr_seq_item_p bigint) FROM PUBLIC;

