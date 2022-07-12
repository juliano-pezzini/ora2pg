-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atendimento_perda_ganho_insert ON atendimento_perda_ganho CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atendimento_perda_ganho_insert() RETURNS trigger AS $BODY$
DECLARE

cd_turno_w			varchar(11) := 'a';
cd_turno_ww			varchar(11);
cd_setor_atendimento_w		integer;
cd_estabelecimento_w		integer;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_atual_w			timestamp;
dt_entrada_w			timestamp;
hr_balanco_w			timestamp;
ie_volume_ocorrencia_w		varchar(1);
qt_conv_peso_volume_w		double precision;
qt_hora_retroativa_w		double precision;
qt_hora_retroativa_desc_w	varchar(25);

ds_hora_w			varchar(20);
dt_registro_w			timestamp;
dt_apap_w			timestamp;
qt_hora_w			double precision;
nr_medida_w			bigint;
ie_regra_apap_ganho_perda_w	varchar(10);

C01 CURSOR FOR
	SELECT	to_date('01/01/1999' || ' ' || to_char(dt_inicial,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_inicial,
		to_date('01/01/1999' || ' ' || to_char(dt_final,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_final,
		to_date('01/01/1999' || ' ' || to_char(NEW.dt_medida,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss') dt_atual,
		cd_turno
	from	regra_turno_gp
	where	cd_estabelecimento	= cd_estabelecimento_w
	and (cd_setor_atendimento is null or cd_setor_atendimento = cd_setor_atendimento_w)
	order by coalesce(cd_setor_atendimento,0);
	
BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'N') then
    goto final;
end if;

select	dt_entrada
into STRICT	dt_entrada_w
from	atendimento_paciente
where	nr_atendimento = NEW.nr_atendimento;
	
if (trunc(dt_entrada_w, 'MI') > trunc(NEW.dt_medida, 'MI')) or (trunc(LOCALTIMESTAMP,'MI') < trunc(NEW.dt_medida,'MI')) then
	-- A data da medida deve estar entre a data de inicio do atendimento e a data atual

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263485);
end if;

qt_hora_retroativa_w		:= Obter_Valor_Param_Usuario(281,1069,obter_Perfil_Ativo,NEW.nm_usuario,0);
if (qt_hora_retroativa_w is not null) and
	(NEW.dt_medida < (LOCALTIMESTAMP - qt_hora_retroativa_w/24)) then
	-- A data da medida nao pode ser menor que '|| to_char(qt_hora_retroativa_w)||' hora(s) em relacao a data atual.#@#@

	qt_hora_retroativa_desc_w := to_char(qt_hora_retroativa_w);
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263486,'QT_HORA_RETROATIVA_W=' || qt_hora_retroativa_desc_w);
end if;

select	max(a.ie_volume_ocorrencia),
	max(a.qt_conv_peso_volume)
into STRICT	ie_volume_ocorrencia_w,
	qt_conv_peso_volume_w
from	tipo_perda_ganho a
where	a.nr_sequencia = NEW.nr_seq_tipo;

if (ie_volume_ocorrencia_w = 'P') and (qt_conv_peso_volume_w > 0) and (NEW.qt_peso > 0) then
	BEGIN
	NEW.qt_volume	:= NEW.qt_volume + (NEW.qt_peso * qt_conv_peso_volume_w);
	end;
end if;	

select	cd_estabelecimento,
	Obter_Setor_Atendimento(NEW.nr_atendimento)
into STRICT	cd_estabelecimento_w,
	cd_setor_atendimento_w
from	atendimento_paciente
where	nr_atendimento	= NEW.nr_atendimento;

OPEN  C01;
LOOP
FETCH C01 into	dt_inicial_w,
		dt_final_w,
		dt_atual_w,
		cd_turno_ww;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if	(dt_atual_w >= dt_inicial_w AND dt_atual_w <= dt_final_w) or
		((dt_final_w < dt_inicial_w) and
		 ((dt_atual_w >= dt_inicial_w) or (dt_atual_w <= dt_final_w))) then
		cd_turno_w := cd_turno_ww;
	end if;
	
END LOOP;
CLOSE C01;

if (cd_turno_w = 'a') then
	cd_turno_w := cd_turno_ww;
end if;

NEW.cd_turno			:= cd_turno_w;
NEW.cd_setor_atendimento	:= coalesce(cd_setor_atendimento_w, NEW.cd_setor_atendimento);

if (NEW.cd_turno	is null) then
    -- 'Nao ha turno definido para este horario. '||chr(13)||'Favor verificar o cadastro Ganhos e perdas - regra turno, no Shift + F11. #@#@'

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263487);
end if;

/* Rafael em 15/9/7 OS68536 */


select	to_date(to_char(LOCALTIMESTAMP,'dd/mm/yyyy') || ' ' || coalesce(max(to_char(hr_inicio_balanco,'hh24:mi:ss')),'00:00:00'),'dd/mm/yyyy hh24:mi:ss')
into STRICT	hr_balanco_w
from	parametro_medico
where	cd_estabelecimento = cd_estabelecimento_w;

if (to_char(NEW.dt_medida,'hh24:mi') < to_char(hr_balanco_w,'hh24:mi')) then
	NEW.dt_referencia := NEW.dt_medida - 1;
else
	NEW.dt_referencia := NEW.dt_medida;
end if;

if (NEW.nr_hora is null) or (NEW.dt_medida <> OLD.dt_medida) then
	BEGIN
	
	NEW.nr_hora	:= Obter_Hora_Apap_GP(NEW.dt_medida);
	end;
end if;

select	coalesce(max(ie_regra_apap_ganho_perda),'R')
into STRICT	ie_regra_apap_ganho_perda_w
from	parametro_medico
where	cd_estabelecimento = obter_estabelecimento_ativo;


if (ie_regra_apap_ganho_perda_w	= 'R') then

	nr_medida_w	:= (to_char(round(NEW.dt_medida,'hh24'),'hh24'))::numeric;

else
	nr_medida_w	:= (to_char(trunc(NEW.dt_medida,'hh24'),'hh24'))::numeric;

end if;

if (NEW.nr_hora not between nr_medida_w - 1 and nr_medida_w + 1) then
	--A hora informada para APAP nao condiz com a data da medida.#@#@

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(263489);
end if;

if (NEW.nr_hora is not null) and
	((OLD.nr_hora is null) or (OLD.dt_medida is null) or (NEW.nr_hora <> OLD.nr_hora) or (NEW.dt_medida <> OLD.dt_medida)) then
	BEGIN
	ds_hora_w	:= lpad(NEW.nr_hora,'2','0');
	dt_registro_w	:= trunc(NEW.dt_medida,'hh24');
	dt_apap_w	:= to_date(to_char(NEW.dt_medida,'dd/mm/yyyy') ||' '||ds_hora_w||':00:00','dd/mm/yyyy hh24:mi:ss');
	if (to_char(round(NEW.dt_medida,'hh24'),'hh24') = ds_hora_w) then
		NEW.dt_apap	:= round(NEW.dt_medida,'hh24');
	else
		BEGIN
		qt_hora_w	:= (trunc(NEW.dt_medida,'hh24') - to_date(to_char(NEW.dt_medida,'dd/mm/yyyy') ||' '||ds_hora_w||':00:00','dd/mm/yyyy hh24:mi:ss')) * 24;
		if (qt_hora_w > 12) then
			NEW.dt_apap	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_medida + 1),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w > 0) and (qt_hora_w <= 12) then
			NEW.dt_apap	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_medida),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w >= -12) then
			NEW.dt_apap	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_medida),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		elsif (qt_hora_w < -12) then
			NEW.dt_apap	:= to_date(to_char(ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(NEW.dt_medida - 1),'dd/mm/yyyy') ||' '||ds_hora_w ||':00:00','dd/mm/yyyy hh24:mi:ss');
		end if;
		end;
	end if;
	end;
end if;

<<final>>
null;

RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atendimento_perda_ganho_insert() FROM PUBLIC;

CREATE TRIGGER atendimento_perda_ganho_insert
	BEFORE INSERT ON atendimento_perda_ganho FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atendimento_perda_ganho_insert();
