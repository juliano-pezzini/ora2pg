-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_taxa_dia_horario ( nm_usuario_p text, nr_atendimento_p bigint, dt_alta_p timestamp ) AS $body$
DECLARE

					
cd_tipo_acomodacao_w	smallint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
hr_inicial_w		timestamp;
hr_final_w		timestamp;
hr_entrada_ant_w	timestamp;
ie_considera_dia_ant_w	varchar(1);
qt_min_tolerancia_w	bigint;
dt_entrada_w		timestamp;
qt_procedimento_w	bigint;
qt_dias_atend_w		double precision;
dt_alta_w		timestamp;
hr_inicial_int_w	bigint;
hr_final_int_w		bigint;
hr_entrada_ant_int_w	bigint;
hr_entrada_w		bigint;
hr_alta_w		bigint;
qt_min_w		bigint;
qt_horas_w		bigint;

nr_sequencia_w		bigint;
dt_entrada_unidade_w	timestamp;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
nr_doc_convenio_w	varchar(20);
cd_setor_atendimento_w	integer;
nr_seq_atepacu_w	bigint;
ie_flag_w		bigint:= 1;
dt_inicio_proc_w	timestamp;
ds_observacao_w		varchar(100);
nr_seq_regra_w		regra_tx_dia_horario.nr_sequencia%Type;
ie_liberado_w		regra_tx_conv_lib.ie_liberado%type;

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced,
		hr_inicial,
		hr_final,
		hr_entrada_ant,
		ie_considera_dia_ant,
		coalesce(qt_min_tolerancia,0),
		nr_sequencia
	from	regra_tx_dia_horario
	where	ie_situacao = 'A'
	and	coalesce(cd_tipo_acomodacao, cd_tipo_acomodacao_w) = cd_tipo_acomodacao_w
	order by	coalesce(cd_tipo_acomodacao,0);
	
	
C02 CURSOR FOR
	SELECT 	ie_liberado
	from 	regra_tx_conv_lib
	where 	nr_seq_regra_tx_dia = nr_seq_regra_w
	and 	coalesce(cd_convenio, coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0)
	order by
		coalesce(cd_convenio,0);


BEGIN

ie_flag_w:= 1;

select	coalesce(max(a.cd_tipo_acomodacao),0)
into STRICT	cd_tipo_acomodacao_w
from	atend_categoria_convenio a
where	a.nr_atendimento = nr_atendimento_p
and	a.dt_inicio_vigencia	=	(	SELECT	max(b.dt_inicio_vigencia)
						from	Atend_categoria_convenio b
						where	b.nr_atendimento	= nr_atendimento_p);

nr_sequencia_w:= 0;						
						
open C01;
loop
fetch C01 into	
	cd_procedimento_w,
	ie_origem_proced_w,
	hr_inicial_w,
	hr_final_w,
	hr_entrada_ant_w,
	ie_considera_dia_ant_w,
	qt_min_tolerancia_w,
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_procedimento_w	:= cd_procedimento_w;
	ie_origem_proced_w	:= ie_origem_proced_w;
	hr_inicial_w		:= hr_inicial_w;
	hr_final_w		:= hr_final_w;
	hr_entrada_ant_w	:= hr_entrada_ant_w;
	ie_considera_dia_ant_w	:= ie_considera_dia_ant_w;
	qt_min_tolerancia_w	:= qt_min_tolerancia_w;
	nr_seq_regra_w		:= nr_seq_regra_w;
	end;
end loop;
close C01;

begin
select	dt_entrada,
	dt_entrada_unidade,
	cd_convenio,
	cd_categoria,
	nr_doc_convenio,
	cd_setor_atendimento,
	nr_seq_atepacu
into STRICT	dt_entrada_w,
	dt_entrada_unidade_w,
	cd_convenio_w,
	cd_categoria_w,
	nr_doc_convenio_w,
	cd_setor_atendimento_w,
	nr_seq_atepacu_w
from	atendimento_paciente_v
where	nr_atendimento = nr_atendimento_p;
exception
	when others then
	ie_flag_w:= 0;
	--insert into log_XXtasy (dt_atualizacao, nm_usuario, cd_log, ds_log)

	--values (sysdate, nm_usuario_p, 1720, 'Erro ao gerar a regra taxa dia. Atendimento: ' || nr_atendimento_p);
end;


ie_liberado_w:= 'S';
open C02;
loop
fetch C02 into	
	ie_liberado_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_liberado_w:= ie_liberado_w;
	end;
end loop;
close C02;

if (ie_liberado_w = 'N') then -- Se nao esta liberado, e nao deve gerar a regra.
	ie_flag_w:= 0;
end if;


if (ie_flag_w > 0) then

	hr_inicial_int_w	:= coalesce((obter_minutos_hora(to_char(hr_inicial_w,'hh24:mi:ss')))::numeric ,0);
	hr_final_int_w		:= coalesce((obter_minutos_hora(to_char(hr_final_w,'hh24:mi:ss')))::numeric ,0);
	hr_entrada_ant_int_w	:= coalesce((obter_minutos_hora(to_char(hr_entrada_ant_w,'hh24:mi:ss')))::numeric ,0);
	hr_entrada_w		:= coalesce((obter_minutos_hora(to_char(dt_entrada_w,'hh24:mi:ss')))::numeric ,0);
	hr_alta_w		:= coalesce((obter_minutos_hora(to_char(dt_alta_p,'hh24:mi:ss')))::numeric ,0);

	qt_dias_atend_w		:= dt_alta_p - dt_entrada_w;
	qt_procedimento_w	:= 0;

	if (qt_dias_atend_w < 1) and (hr_alta_w < hr_final_int_w) and (hr_alta_w >= hr_inicial_int_w)	then
		if (pkg_date_utils.start_of(dt_alta_p,'DD', 0) <> pkg_date_utils.start_of(dt_entrada_w, 'DD', 0)) then
			if (coalesce(ie_considera_dia_ant_w,'N') = 'S') and (hr_entrada_w >= hr_entrada_ant_int_w) then
				qt_horas_w		:= trunc(dividir(hr_alta_w - hr_inicial_int_w, 60));
				qt_min_w		:= (hr_alta_w - hr_inicial_int_w) - qt_horas_w * 60;
				dt_inicio_proc_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_alta_p, coalesce(to_char(hr_inicial_w, pkg_date_formaters.localize_mask('shortTime', pkg_date_formaters.getUserLanguageTag(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO))), '00:00'));			
				
				if (qt_min_w <= qt_min_tolerancia_w) then
					qt_procedimento_w	:= qt_horas_w;
				else
					qt_procedimento_w	:= qt_horas_w + 1;
				end if;
			end if;
		else
			if (hr_entrada_w < hr_inicial_int_w) then
				qt_horas_w		:= trunc(dividir(hr_alta_w - hr_inicial_int_w, 60));
				qt_min_w		:= (hr_alta_w - hr_inicial_int_w) - qt_horas_w * 60;
				dt_inicio_proc_w	:= ESTABLISHMENT_TIMEZONE_UTILS.dateAtTime(dt_alta_p, coalesce(to_char(hr_inicial_w, pkg_date_formaters.localize_mask('shortTime', pkg_date_formaters.getUserLanguageTag(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO))), '00:00'));
			else
				qt_horas_w		:= trunc(dividir(hr_alta_w - hr_entrada_w, 60));
				qt_min_w		:= (hr_alta_w - hr_entrada_w) - qt_horas_w * 60;
				dt_inicio_proc_w	:= dt_entrada_w;
			end if;
				
			if (qt_min_w <= qt_min_tolerancia_w) then
				qt_procedimento_w	:= qt_horas_w;
			else
				qt_procedimento_w	:= qt_horas_w + 1;
			end if;
		end if;
	end if;

	if (qt_procedimento_w <> 0) then

		select	nextval('procedimento_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		ds_observacao_w	:= wheb_mensagem_pck.get_texto(297885);

		insert into procedimento_paciente(	nr_sequencia, nr_atendimento, dt_entrada_unidade, cd_procedimento,
				dt_procedimento, qt_procedimento, dt_atualizacao, nm_usuario, cd_convenio,
				cd_categoria, vl_procedimento, vl_medico, vl_anestesista, vl_materiais,
				dt_acerto_conta, vl_auxiliares, vl_custo_operacional, tx_medico,
				tx_anestesia, nr_doc_convenio, dt_conta, cd_setor_atendimento,	
				ie_origem_proced, nr_seq_atepacu, ie_auditoria, dt_inicio_procedimento,
				ds_observacao)
		values (	nr_sequencia_w, nr_atendimento_p, dt_entrada_unidade_w,	cd_procedimento_w,
				dt_alta_p, qt_procedimento_w, clock_timestamp(), nm_usuario_p, cd_convenio_w,
				cd_categoria_w, 0, 0, 0, 0,
				null, 0, 0, 0,
				0, nr_doc_convenio_w, dt_alta_p, cd_setor_atendimento_w,
				ie_origem_proced_w, nr_seq_atepacu_w, 'N', dt_inicio_proc_w,
				ds_observacao_w);
				
		CALL Atualiza_Preco_Procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
	end if;
	
end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_taxa_dia_horario ( nm_usuario_p text, nr_atendimento_p bigint, dt_alta_p timestamp ) FROM PUBLIC;
