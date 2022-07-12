-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_parto_nascimento ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


c01 CURSOR(nr_atendimento_nasc_p bigint) FOR
SELECT nr_sequencia, qt_altura, qt_peso_sala_parto, dt_nascimento, obter_nome_pf(cd_pediatra) ds_pediatra
from nascimento
where nr_atendimento = nr_atendimento_nasc_p;


c02 CURSOR(nr_atendimento_nasc_p bigint) FOR
SELECT field, ds_tipo_parto, field_value
from (
SELECT 'IE_PARTO_NORMAL' field, OBTER_DESC_EXPRESSAO(295335) ds_tipo_parto, IE_PARTO_NORMAL field_value, 1 field_order
from parto
where nr_atendimento = nr_atendimento_nasc_p

union

select 'IE_PARTO_CESARIA' field, OBTER_DESC_EXPRESSAO(560188) ds_tipo_parto, IE_PARTO_CESARIA field_value, 2 field_order
from parto
where nr_atendimento = nr_atendimento_nasc_p

union

select 'IE_PARTO_FORCEPS' field, OBTER_DESC_EXPRESSAO(290239) ds_tipo_parto, IE_PARTO_FORCEPS field_value, 3 field_order
from parto
where nr_atendimento = nr_atendimento_nasc_p

union

select 'IE_PARTO_EPISIO' field, OBTER_DESC_EXPRESSAO(289339) ds_tipo_parto, IE_PARTO_EPISIO field_value, 4 field_order
from parto
where nr_atendimento = nr_atendimento_nasc_p

union

select 'IE_PARTO_ANALGESIA' field, OBTER_DESC_EXPRESSAO(283445) ds_tipo_parto, IE_PARTO_ANALGESIA field_value, 5 field_order
from parto
where nr_atendimento = nr_atendimento_nasc_p) a
order by field_order;

vl_retorno_w		varchar(4000);
vl_retorno_adic_w	varchar(4000);
vl_retorno_adic2_w	varchar(4000);
nr_atendimento_w	bigint;

BEGIN

begin

if (nr_atendimento_p > 0) and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	begin
	
	select  coalesce(nr_atendimento_mae,nr_atendimento_p)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;
	
	if (ie_opcao_p = 'GEST') then
		select	qt_gestacoes
		into STRICT	vl_retorno_w
		from	parto
		where	nr_atendimento =  nr_atendimento_w
		and	(qt_gestacoes IS NOT NULL AND qt_gestacoes::text <> '');
		
	elsif (ie_opcao_p = 'PANORMAL') then
		select	QT_PARTO_NORMAL
		into STRICT	vl_retorno_w
		from	parto
		where	nr_atendimento =  nr_atendimento_w
		and	(QT_PARTO_NORMAL IS NOT NULL AND QT_PARTO_NORMAL::text <> '');
		
	elsif (ie_opcao_p = 'PACESARIANA') then
		select	QT_PARTO_CESARIO
		into STRICT	vl_retorno_w
		from	parto
		where	nr_atendimento =  nr_atendimento_w
		and	(QT_PARTO_CESARIO IS NOT NULL AND QT_PARTO_CESARIO::text <> '');
		
	elsif (ie_opcao_p = 'ABORTOS') then
		select	QT_ABORTOS
		into STRICT	vl_retorno_w
		from	parto
		where	nr_atendimento =  nr_atendimento_w
		and	(QT_ABORTOS IS NOT NULL AND QT_ABORTOS::text <> '');
		
	elsif (ie_opcao_p = 'TPPARTO') then
		select	CASE WHEN IE_PARTO_NORMAL='S' THEN  OBTER_DESC_EXPRESSAO(295335)  ELSE (CASE  ELSE 'S', OBTER_DESC_EXPRESSAO(560188),null)))		-- 295335: 'Parto normal'		560188: 'Parto cesario'			into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w;			elsif (ie_opcao_p = 'DTADMISSAO') then		select	TO_CHAR(DT_ADMISSAO, 'DD/MM/YYYY HH24:MI:SS')		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w;			elsif (ie_opcao_p = 'TPSANGUEMAE') then		select	IE_TIPO_SANGUE_MAE		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_TIPO_SANGUE_MAE IS NOT NULL AND IE_TIPO_SANGUE_MAE::text <> '');			elsif (ie_opcao_p = 'FATORRHMAE') then		select	IE_FATOR_RH_MAE		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_FATOR_RH_MAE IS NOT NULL AND IE_FATOR_RH_MAE::text <> '');			elsif (ie_opcao_p = 'TPSANGUEPAI') then		select	IE_TIPO_SANGUE_PAI		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_TIPO_SANGUE_PAI IS NOT NULL AND IE_TIPO_SANGUE_PAI::text <> '');			elsif (ie_opcao_p = 'FATORRHPAI') then		select	IE_FATOR_RH_PAI		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_FATOR_RH_PAI IS NOT NULL AND IE_FATOR_RH_PAI::text <> '');			elsif (ie_opcao_p = 'NOMEDAMAE') then		select	obter_dados_atendimento(nr_atendimento_w,'NP')		into STRICT	vl_retorno_w		;		elsif (ie_opcao_p = 'HABITOS') then		select	CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729516)||DS_CIGARRO,null)||			-- 729516: ' - Tabagismo  '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729458)||DS_DROGAS,null)||					-- 729458: ' - Drogas '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729462)||DS_ETILISMO,null)					-- 729462: ' - Etilismo '		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_FATOR_RH_PAI IS NOT NULL AND IE_FATOR_RH_PAI::text <> '');			elsif (ie_opcao_p = 'IDADEGESTACIONAL') then				select	QT_SEM_IG_INI_PRE_NATAL		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(QT_SEM_IG_INI_PRE_NATAL IS NOT NULL AND QT_SEM_IG_INI_PRE_NATAL::text <> '');			elsif (ie_opcao_p = 'SOROLOGIA') then		select	CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729472)||OBTER_VALOR_DOMINIO(4512,IE_AIDS_POSITIVO),null)||								-- 729472: ' - HIV  '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729500)||OBTER_VALOR_DOMINIO(4512,IE_RUBEOLA_POSITIVO),null)||							-- 729500: ' - Rubeola '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729512)||OBTER_VALOR_DOMINIO(4512,IE_SIFILIS_POSITIVO),null)||							-- 729512: ' - Sifilis '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729520)||OBTER_VALOR_DOMINIO(4512,IE_TOXOPLASMOSE_POSITIVO),null)||					-- 729520: ' - Toxoplasmose '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729498)||OBTER_VALOR_DOMINIO(4512,IE_ESTREPTOCOCO_POSITIVO),null)					-- 729498: ' - Pesquisa Estreptococo '		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w;			elsif (ie_opcao_p = 'ANTPATOLOGICOS') then		select	CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729456),null)||								-- 729456: ' - Diabetes '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729436),null)||									-- 729436: ' - Cardiopatia '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729526),null)||									-- 729526: ' - Tuberculose '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729478),null)||									-- 729478: ' - Hipertensao '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729434),null)||										-- 729434: ' - Anemia '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729494),null)||									-- 729494: ' - Neoplasia '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729486),null)||									-- 729486: ' - Infeccoes '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729454)||DS_DST,null)||									-- 729454: ' - DST '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729442)||DS_CIRURGIA_PREVIA,null)||			-- 729442: ' - Cirurgias '			CASE  ELSE 'S', OBTER_DESC_EXPRESSAO(729432) ||DS_ALERGIA,null)							-- 729432: ' - Alergia '		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w;			elsif (ie_opcao_p = 'DOENCASGESTACAO') then		select	CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729448),null)||			-- 729448: ' - DHEG '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729480),null)||	-- 729480: ' - Infeccao Urinaria '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729504),null)||				-- 729504: ' - Ruprema '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729452),null)||				-- 729452: ' - DM Gestacional '			CASE  ELSE 'S',OBTER_DESC_EXPRESSAO(729446),null)||		-- 729446: ' - Coagulopatia '			CASE WHEN  IE_TPP='S',OBTER_DESC_EXPRESSAO(729514),null)||					-- 729514: ' - TPP '			CASE WHEN  IE_OUTRAS_INFEC='S' THEN ' - '||DS_DOENCAS_GESTACAO  ELSE null END 					into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w;			elsif (ie_opcao_p = 'PRENATAL') then			select	max(nr_sequencia)		into STRICT	vl_retorno_adic2_w		from	pre_natal		where	nr_atendimento =  nr_atendimento_w		and	(NR_SEQ_LOCAL IS NOT NULL AND NR_SEQ_LOCAL::text <> '');					if (vl_retorno_adic2_w IS NOT NULL AND vl_retorno_adic2_w::text <> '') then					select	obter_descricao_padrao('PRE_NATAL_LOCAL','DS_LOCAL',NR_SEQ_LOCAL) THEN				nm_obstetra			into STRICT	vl_retorno_w  ELSE vl_retorno_adic_w			from	pre_natal			where	nr_atendimento =  nr_atendimento_w			and	(NR_SEQ_LOCAL IS NOT NULL AND NR_SEQ_LOCAL::text <> '');						if (vl_retorno_adic_w IS NOT NULL AND vl_retorno_adic_w::text <> '') then				vl_retorno_w := vl_retorno_w || ' , ' || OBTER_DESC_EXPRESSAO(729428) || ' ' ||vl_retorno_adic_w;					-- 729428: 'Obstetra:'
			end if;				end if;			elsif (ie_opcao_p = 'BOLSAAMNI') then		select	obter_valor_dominio(2951,IE_BOLSA_AMNIOTICA_INTEGRO)		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_BOLSA_AMNIOTICA_INTEGRO IS NOT NULL AND IE_BOLSA_AMNIOTICA_INTEGRO::text <> '');			elsif (ie_opcao_p = 'BCF') then		select	QT_BAT_CARDIO_FETAIS		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(QT_BAT_CARDIO_FETAIS IS NOT NULL AND QT_BAT_CARDIO_FETAIS::text <> '');	elsif (ie_opcao_p = 'APRESFETAL') then		select	CASE WHEN IE_APRESENTACAO_FETAL='1' THEN ' ' || OBTER_DESC_EXPRESSAO(487947) || ' ',null)||				-- 487947: 'Cefalica'			CASE WHEN IE_APRESENTACAO_FETAL='2' THEN ' ' || OBTER_DESC_EXPRESSAO(487948) || ' ',null)||					-- 487948: 'Pelvica'			CASE WHEN IE_APRESENTACAO_FETAL='3' THEN  DS_APRESENTACAO_FETAL  ELSE null END		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(IE_APRESENTACAO_FETAL IS NOT NULL AND IE_APRESENTACAO_FETAL::text <> '');		elsif (ie_opcao_p = 'MEDICAMENTOS_PARTO') then		select	DS_USO_MEDIC		into STRICT	vl_retorno_w		from	parto		where	nr_atendimento =  nr_atendimento_w		and	(DS_USO_MEDIC IS NOT NULL AND DS_USO_MEDIC::text <> '');		elsif (ie_opcao_p = 'SEMANASGRAVIDEZ') then 		select max(qt_ig_semana)		into STRICT vl_retorno_w		from atendimento_gravidez		where nr_atendimento = nr_atendimento_w;		elsif (ie_opcao_p = 'PARTOANESTESISTA') then 		select obter_nome_pf(cd_anestesista)		into STRICT vl_retorno_w		from parto		where nr_atendimento = nr_atendimento_w;		elsif (ie_opcao_p = 'PARTOANESTESIA') then 		select obter_valor_dominio(9613, cd_tipo_anestesia)		into STRICT vl_retorno_w		from parto		where nr_atendimento = nr_atendimento_w;		elsif (ie_opcao_p = 'ALTURANASCIMENTO') then 		for c01w in c01(nr_atendimento_w) loop			select				CASE WHEN coalesce(vl_retorno_w::text, '') = '' THEN  OBTER_DESC_EXPRESSAO(302572) || ' ' || c01w.nr_sequencia || ': ' || c01w.qt_altura  ELSE vl_retorno_w || ' | ' || OBTER_DESC_EXPRESSAO(302572) || ' ' || c01w.nr_sequencia || ': ' || c01w.qt_altura END 			into STRICT				vl_retorno_w			;		end loop;		elsif (ie_opcao_p = 'PESONASCIMENTO') then 		for c01w in c01(nr_atendimento_w) loop			select				CASE WHEN coalesce(vl_retorno_w::text, '') = '' THEN  OBTER_DESC_EXPRESSAO(305630) || ' ' || c01w.nr_sequencia || ': ' || c01w.qt_peso_sala_parto  ELSE vl_retorno_w || ' | ' || OBTER_DESC_EXPRESSAO(305630) || ' ' || c01w.nr_sequencia || ': ' || c01w.qt_peso_sala_parto END 			into STRICT				vl_retorno_w			;		end loop;		elsif (ie_opcao_p = 'PARTODTNASCIMENTO') then 		for c01w in c01(nr_atendimento_w) loop			select				CASE WHEN coalesce(vl_retorno_w::text, '') = '' THEN  OBTER_DESC_EXPRESSAO(303437) || ' ' || c01w.nr_sequencia || ': ' || c01w.dt_nascimento  ELSE vl_retorno_w || ' | ' || OBTER_DESC_EXPRESSAO(303437) || ' ' || c01w.nr_sequencia || ': ' || c01w.dt_nascimento END 			into STRICT				vl_retorno_w			;		end loop;		elsif (ie_opcao_p = 'PEDIATRA') then 		for c01w in c01(nr_atendimento_w) loop			select				CASE WHEN coalesce(vl_retorno_w::text, '') = '' THEN  OBTER_DESC_EXPRESSAO(295392) || ' ' || c01w.nr_sequencia || ': ' || c01w.ds_pediatra  ELSE vl_retorno_w || ' | ' || OBTER_DESC_EXPRESSAO(295392) || ' ' || c01w.nr_sequencia || ': ' || c01w.ds_pediatra END 			into STRICT				vl_retorno_w			;		end loop;		elsif (ie_opcao_p = 'TIPONASCIMENTOCOMPOSTO') then 		for c02w in c02(nr_atendimento_w) loop			select				CASE WHEN c02w.field_value='S' THEN  CASE WHEN coalesce(vl_retorno_w::text, '') = '' THEN  c02w.ds_tipo_parto  ELSE vl_retorno_w || ' | ' || c02w.ds_tipo_parto END   ELSE vl_retorno_w END 			into STRICT				vl_retorno_w			;		end loop;		end if;			end;end if;exception	when others then	null;	end;return vl_retorno_w;END; END END END END END END END END END END END END END END END END END END END END END END END END END END  END  END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_parto_nascimento ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

