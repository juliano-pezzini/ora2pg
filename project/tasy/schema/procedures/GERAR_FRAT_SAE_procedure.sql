-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_frat_sae ((nr_sequencia_p bigint, nm_usuario_p text) is nr_atendimento_w bigint) RETURNS varchar AS $body$
DECLARE


	ie_retorno_w	varchar(15);
	nr_seq_result_escala_w	varchar(15);
	
BEGIN

	select	max(f.nr_seq_result_escala)
	into STRICT	nr_seq_result_escala_w
	from	pe_prescricao a,
		pe_prescr_item_result b,
		pe_regra_item_escala c,
		pe_regra_result_escala f
	where	a.nr_sequencia = nr_sequencia_p
	and	a.nr_sequencia = b.nr_seq_prescr
	and	b.nr_seq_item = c.nr_seq_item_sae
	and	c.nr_seq_item_escala = nr_seq_item_escala_p
	and	f.nr_seq_result_sae = b.nr_seq_result
	and	f.nr_seq_regra = c.nr_sequencia;

	select 	max(x.vl_result)
	into STRICT	ie_retorno_w
	from	pe_result_item x,
		pe_regra_result_escala f
	where	x.nr_sequencia = nr_seq_result_escala_w;



	return ie_retorno_w;
	end;

begin

select	max(a.cd_prescritor),
	max(a.nr_atendimento)
into STRICT	cd_profissional_w,
	nr_atendimento_w
from	pe_prescricao a,
	pe_prescr_item_result b
where	a.nr_sequencia = b.nr_seq_prescr
and	a.nr_sequencia = nr_sequencia_p;

select	count(*)
into STRICT	qt_reg_w
from 	pe_prescricao a,
	pe_prescr_item_result b,
	pe_regra_item_escala c,
	pe_regra_result_escala d
where	a.nr_sequencia	= b.nr_seq_prescr
and	b.nr_seq_result = d.nr_seq_result_sae
and	b.nr_seq_item	= c.nr_seq_item_sae
and	a.nr_sequencia	= nr_sequencia_p
and	(c.nr_seq_item_escala IS NOT NULL AND c.nr_seq_item_escala::text <> '')
and 	c.ie_escala = 173;

if (qt_reg_w > 0) then
	begin
	ie_categoria_w 		:= obter_valor_escala(3);
	ie_queda_6_meses_w	:= obter_valor_escala(5);
	ie_eliminacao_w		:= obter_valor_escala(8);
	ie_medicacao_w		:= obter_valor_escala(9);
	ie_dispositivo_w	:= obter_valor_escala(10);
	ie_auxilio_superv_w	:= obter_valor_escala(11);
	ie_marcha_w		:= obter_valor_escala(12);
	ie_comprometimento_w	:= obter_valor_escala(13);
	ie_percepcao_w		:= obter_valor_escala(14);
	ie_impulsividade_w	:= obter_valor_escala(15);
	ie_limitacao_w		:= obter_valor_escala(16);
	end;

	select	(obter_idade_pf(cd_pessoa_fisica,clock_timestamp(),'A'))::numeric
	into STRICT	qt_idade_w
	from	pe_prescricao
	where	nr_sequencia = nr_sequencia_p;

	if (qt_idade_w between 60 and 69) then
		ie_idade_w := 1;
	elsif (qt_idade_w between 70 and 79) then
		ie_idade_w := 2;
	elsif (qt_idade_w > 80) then
		ie_idade_w := 3;
	else
		ie_idade_w := null;
	end if;

	if (ie_categoria_w IS NOT NULL AND ie_categoria_w::text <> '') then
		begin
		ie_queda_6_meses_w	:= 'N';
		ie_idade_w		:= null;
		ie_eliminacao_w		:= null;
		ie_medicacao_w		:= null;
		ie_dispositivo_w	:= null;
		ie_auxilio_superv_w 	:= 'N';
		ie_marcha_w		:= 'N';
		ie_comprometimento_w 	:= 'N';
		ie_percepcao_w 		:= 'N';
		ie_impulsividade_w	:= 'N';
		ie_limitacao_w 		:= 'N';
		end;
	end if;

	insert into escala_frat(nr_sequencia,
				cd_profissional,
				dt_atualizacao,
				dt_avaliacao,
				ie_categoria,
				ie_queda_6_meses,
				ie_eliminacao,
				ie_medicacao,
				ie_dispositivo,
				ie_auxilio_superv,
				ie_marcha,
				ie_comprometimento,
				ie_percepcao,
				ie_impulsividade,
				ie_limitacao,
				nm_usuario,
				nr_atendimento,
				ie_situacao,
				dt_liberacao,
				ie_idade)
	values (	nextval('escala_frat_seq'),
				cd_profissional_w,
				clock_timestamp(),
				clock_timestamp(),
				ie_categoria_w,
				coalesce(ie_queda_6_meses_w,'N'),
				ie_eliminacao_w,
				ie_medicacao_w,
				ie_dispositivo_w,
				coalesce(ie_auxilio_superv_w,'N'),
				coalesce(ie_marcha_w,'N'),
				coalesce(ie_comprometimento_w,'N'),
				coalesce(ie_percepcao_w,'N'),
				coalesce(ie_impulsividade_w,'N'),
				coalesce(ie_limitacao_w,'N'),
				nm_usuario_p,
				nr_atendimento_w,
				'A',
				clock_timestamp(),
				ie_idade_w);

end if;


if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_frat_sae ((nr_sequencia_p bigint, nm_usuario_p text) is nr_atendimento_w bigint) FROM PUBLIC;

