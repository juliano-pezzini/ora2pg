-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_hora_itens_status ( nr_sequencia_p bigint, ie_status_medicacao_p text, hr_valor_hora_p text) RETURNS varchar AS $body$
DECLARE


/* Objetivo:	retornar a hora de atualização realizada dos seguintes status

ie_status_medicacao_p:	( Dominio 3461)
	AC ->	Aguardando conferência
	CM ->	Conferência da medicação
	EM ->	Entrega da medicação
	RR ->	Registro do receituário
	SM ->	Separação do medicamento
	MS ->	Substituição do medicamento

nr_sequencia_p:	Sequencia da emtrega da receita
*/
dt_auxiliar_w		timestamp;
hr_status_item_w	varchar(10);
qtd_w			integer;

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	count(*)
	into STRICT	qtd_w
	from	fa_entr_medic_item_status s
	where	to_char(s.dt_atualizacao,'hh24')	= hr_valor_hora_p
	and	s.ie_status_medicacao 			= ie_status_medicacao_p
	and	s.nr_seq_fa_entrega_item 		= nr_sequencia_p;

	if (qtd_w > 0) then

		select	obter_horario_formatado(to_char(max(s.dt_atualizacao),'hh24'))
		into STRICT	hr_status_item_w
		from	fa_entr_medic_item_status s
		where	to_char(s.dt_atualizacao,'hh24')	= hr_valor_hora_p
		and	s.ie_status_medicacao 			= ie_status_medicacao_p
		and	s.nr_seq_fa_entrega_item 		= nr_sequencia_p;
	end if;
end if;

return hr_status_item_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_hora_itens_status ( nr_sequencia_p bigint, ie_status_medicacao_p text, hr_valor_hora_p text) FROM PUBLIC;

