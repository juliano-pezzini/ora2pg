-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_mensagem_avaliacao ( nr_seq_med_aval_paciente_p bigint, nr_seq_med_tipo_avaliacao_p bigint, ds_mensagem_p INOUT text ) AS $body$
DECLARE


exibir_mensagem_w		boolean;
nr_seq_regra_mens_w	bigint;
ds_mensagem_w		varchar(255);
vl_minimo_w		bigint;
vl_maximo_w		bigint;
ds_resultado_regra_w	varchar(255);
nr_seq_item_avaliar_w	bigint;
qt_resultado_w		bigint;
ds_resultado_w		varchar(4000);
ie_resultado_w		varchar(2);
nr_atendimento_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_mensagem
	from	regra_mensagem_aval
	where	nr_seq_tipo_aval = nr_seq_med_tipo_avaliacao_p;

C02 CURSOR FOR
	SELECT	vl_minimo,
		vl_maximo,
		ds_resultado,
		nr_seq_item_avaliar
	from	regra_mensagem_aval_item
	where	nr_seq_regra_mens = nr_seq_regra_mens_w;


BEGIN

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	med_avaliacao_paciente
where	nr_sequencia	= nr_seq_med_aval_paciente_p;

--Regra de lançamento automático para o PEP
if (wheb_usuario_pck.get_cd_funcao <> 872) then
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,501,wheb_usuario_pck.get_nm_usuario,nr_seq_med_aval_paciente_p,null,null,null,null,null);
else
	CALL gerar_lancamento_automatico(nr_atendimento_w,null,576,wheb_usuario_pck.get_nm_usuario,nr_seq_med_aval_paciente_p,null,null,null,null,null);
end if;

--Gerar_Evolucao_Avaliacao_Pac(nr_seq_med_aval_paciente_p,wheb_usuario_pck.get_nm_usuario);
--Geração de orientação de alta para o PEP
if (wheb_usuario_pck.get_cd_funcao <> 872) then
	CALL Gerar_orient_alta_Avaliacao(nr_seq_med_aval_paciente_p,wheb_usuario_pck.get_nm_usuario);
end if;

-- Abre cursor regra_mensagem_aval
open C01;
loop
fetch C01 into
	nr_seq_regra_mens_w,
	ds_mensagem_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	exibir_mensagem_w := false;

	-- Abre cursor regra_mensagem_aval_item
	open C02;
	loop
	fetch C02 into
		vl_minimo_w,
		vl_maximo_w,
		ds_resultado_regra_w,
		nr_seq_item_avaliar_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		-- Verificar os itens do resultado da avaliação
		select 	max(a.qt_resultado),
			max(a.ds_resultado),
			max(b.ie_resultado)
		into STRICT	qt_resultado_w,
			ds_resultado_w,
			ie_resultado_w
		from 	med_avaliacao_result a,
			med_item_avaliar b
		where	a.nr_seq_item = b.nr_sequencia
		  and	a.nr_seq_item = nr_seq_item_avaliar_w
		  and	a.nr_seq_avaliacao = nr_seq_med_aval_paciente_p;

		-- Se houver resultado de avaliação para o tipo de item, verificar se os itens da avaliação possuem igualdade com os itens da regra, e emitir a mensagem.
		if (ie_resultado_w IS NOT NULL AND ie_resultado_w::text <> '') then
			begin
			-- Verifica se valores med_avaliacao_result = regra_mensagem_aval_item
			if ((ie_resultado_w = 'A' or	-- Data/Hora
				 ie_resultado_w = 'Z' or	-- Localizador
				 ie_resultado_w = 'D' or	-- Descrição
				 ie_resultado_w = 'C') and	-- Descrição Curta
				(upper(substr(ds_resultado_w, 1, 255)) = upper(ds_resultado_regra_w)))
			then
				exibir_mensagem_w := true;
			elsif ((ie_resultado_w = 'U' or		-- Seleção Única (RadioGroup)
					ie_resultado_w = 'R' or		-- Select
					ie_resultado_w = 'B' or		-- Booleano (Sim/Não)
					ie_resultado_w = 'O' or		-- Domínio
					ie_resultado_w = 'E' or		-- Resultado select
					ie_resultado_w = 'S' or		-- Seleção Simples (Lookup)
					ie_resultado_w = 'M') and	-- Multi Seleção
				   (qt_resultado_w = vl_minimo_w))
			then
				exibir_mensagem_w := true;
			elsif ((ie_resultado_w = 'V' or		-- Valor
					ie_resultado_w = 'L') and	-- Cálculo
				   (qt_resultado_w between vl_minimo_w and vl_maximo_w))
			then
				exibir_mensagem_w := true;
			else
				begin
				exibir_mensagem_w := false;
				exit;
				end;
			end if;

			end;
		-- Se não há resultado de avaliação para o item em questão, a regra em questão já está inválida. Deve-se verificar a próxima regra.
		else
			begin
			exibir_mensagem_w := false;
			exit;
			end;
		end if;

		end;
	end loop;
	close C02;

	-- Apresenta mensagem, se respeitar todas regras
	if (exibir_mensagem_w) then
		ds_mensagem_p := ds_mensagem_p||ds_mensagem_w||';'||chr(13)||chr(10);
	end if;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_mensagem_avaliacao ( nr_seq_med_aval_paciente_p bigint, nr_seq_med_tipo_avaliacao_p bigint, ds_mensagem_p INOUT text ) FROM PUBLIC;

