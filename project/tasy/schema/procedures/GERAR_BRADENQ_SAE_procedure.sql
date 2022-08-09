-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_bradenq_sae ((nr_sequencia_p bigint, nm_usuario_p text) is nr_atendimento_w bigint) RETURNS varchar AS $body$
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
into STRICT	cd_pessoa_fisica_w,
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
and 	c.ie_escala = 67;

if (qt_reg_w > 0) then
	begin
		ie_mobilidade_w		  := obter_valor_escala(26);
		ie_atividade_fisica_w	  := obter_valor_escala(27);
		ie_percepcao_sensorial_w  := obter_valor_escala(28);
		ie_umidade_w		  := obter_valor_escala(29);
		ie_friccao_cisalhamento_w := obter_valor_escala(30);
		ie_nutricao_w	    	  := obter_valor_escala(31);
		ie_perfusao_w	    	  := obter_valor_escala(32);
	end;

	insert into atend_escala_braden_q(nr_sequencia,
					cd_pessoa_fisica,
					dt_atualizacao,
					dt_avaliacao,
					ie_mobilidade,
					ie_atividade_fisica,
					ie_percepcao_sensorial,
					ie_umidade,
					ie_friccao_cisalhamento,
					ie_nutricao,
					ie_perfusao,
					nm_usuario,
					nr_atendimento,
					ie_situacao,
					dt_liberacao,
					nr_seq_prescr)
		values (	nextval('atend_escala_braden_q_seq'),
					cd_pessoa_fisica_w,
					clock_timestamp(),
					clock_timestamp(),
					coalesce(ie_mobilidade_w,1),
					coalesce(ie_atividade_fisica_w,1),
					coalesce(ie_percepcao_sensorial_w,1),
					coalesce(ie_umidade_w,1),
					coalesce(ie_friccao_cisalhamento_w,1),
					coalesce(ie_nutricao_w,1),
					coalesce(ie_perfusao_w,1),
					nm_usuario_p,
					nr_atendimento_w,
					'A',
					clock_timestamp(),
					nr_sequencia_p);

end if;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_bradenq_sae ((nr_sequencia_p bigint, nm_usuario_p text) is nr_atendimento_w bigint) FROM PUBLIC;
