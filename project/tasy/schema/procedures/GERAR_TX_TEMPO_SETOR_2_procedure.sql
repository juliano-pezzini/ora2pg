-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tx_tempo_setor_2 (DT_PARAMETRO_P timestamp, NM_USUARIO_P text) AS $body$
DECLARE

			
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
dt_entrada_w			atendimento_paciente.dt_entrada%type;
dt_entrada_unid_atual_w		atend_paciente_unidade.dt_entrada_unidade%type;
ie_rn_regra_tx_tempo_setor_w	parametro_faturamento.ie_rn_regra_tx_tempo_setor%type;
dt_param_ant_w			timestamp;

C01 CURSOR FOR
	SELECT	e.nr_atendimento,
		e.dt_entrada,
		e.cd_estabelecimento,
		coalesce(e.ie_tipo_convenio,0),
		e.ie_tipo_atendimento,
		e.nr_seq_classificacao,
		e.ie_clinica
	from	atendimento_paciente e
	where	e.dt_entrada	<= dt_parametro_p
	and	coalesce(e.dt_fim_conta::text, '') = ''
	and	coalesce(e.ie_tipo_convenio,0) <> 3
	and	coalesce(e.dt_alta,to_date('2999','yyyy')) > dt_parametro_p
	order by e.nr_atendimento;
	
C02 CURSOR FOR
	SELECT	/*+ INDEX (A ATEPACU_ATEPACI_FK_I) */		a.dt_entrada_unidade
	from 	setor_atendimento c,
		atend_paciente_unidade a
	where	a.nr_atendimento 			= nr_atendimento_w
	and	c.cd_setor_atendimento		= a.cd_setor_atendimento
	and 	a.dt_entrada_unidade 		<= dt_parametro_p
	and	(c.cd_classif_setor(1,2,3,4,5,8)-- pronto socorro(1),centro cirurgico(2),unidades de internacao(3),UTI(4), Servicos Especiais(5),Home Care(8)		
			or (ie_rn_regra_tx_tempo_setor_w = 'S' AND c.cd_classif_setor = 9))-- recem nascidos(9)
	order by coalesce(a.dt_saida_unidade, a.dt_entrada_unidade + 9999) desc;
	
type		tabela_atendimentos is table of C01%rowtype;
atendimentos	tabela_atendimentos;

i		integer := 1;
type vetor is table of tabela_atendimentos index by integer;
vetor_c01_w			vetor;
		
BEGIN

dt_param_ant_w	:= dt_parametro_p - (0.5/24);

open c01;
loop
fetch c01 bulk collect into atendimentos limit 1000;
	vetor_c01_w(i) := atendimentos;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

for i in 1..vetor_c01_w.count loop
	atendimentos := vetor_c01_w(i);
	
	for z in 1..atendimentos.count loop
	
		nr_atendimento_w	:= atendimentos[z].nr_atendimento;
		dt_entrada_w		:= atendimentos[z].dt_entrada;
	
		select	coalesce(max(ie_rn_regra_tx_tempo_setor),'N')
		into STRICT	ie_rn_regra_tx_tempo_setor_w
		from	parametro_faturamento
		where	cd_estabelecimento = atendimentos[z].cd_estabelecimento;
		
		open C02;
		loop
		fetch C02 into	
			dt_entrada_unid_atual_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			dt_entrada_unid_atual_w	:= dt_entrada_unid_atual_w;
			exit;
			end;
		end loop;
		close C02;	
		
		if (dt_param_ant_w < dt_entrada_unid_atual_w) and (dt_entrada_w < dt_param_ant_w) then
			CALL gerar_tx_tempo_setor(dt_param_ant_w, nm_usuario_p, nr_atendimento_w);
			CALL gerar_tx_tempo_setor(dt_parametro_p, nm_usuario_p, nr_atendimento_w);
		else
			CALL gerar_tx_tempo_setor(dt_parametro_p, nm_usuario_p, nr_atendimento_w);
		end if;		
	
	end loop;
end loop;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tx_tempo_setor_2 (DT_PARAMETRO_P timestamp, NM_USUARIO_P text) FROM PUBLIC;

