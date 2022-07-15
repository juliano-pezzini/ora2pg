-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE medic_entregue_regulacao (nr_seq_entrega_p bigint, ie_status_medicacao_p text) AS $body$
DECLARE

nr_seq_regulacao_w  regulacao_atend.nr_sequencia%type;
nr_atendimento_w fa_receita_farmacia.nr_atendimento%type;
ie_integracao_w varchar(2);

BEGIN
  select r.nr_seq_atendimento
    into STRICT nr_atendimento_w
  from
    fa_receita_farmacia r,
    fa_entrega_medicacao e
  where e.nr_seq_receita_amb = r.nr_sequencia
		and e.nr_sequencia = nr_seq_entrega_p;

  select max(a.nr_sequencia)
    into STRICT nr_seq_regulacao_w
  from regulacao_atend a
  where a.nr_atendimento = nr_atendimento_w;

  select	coalesce(max('S'),'N')
    into STRICT	ie_integracao_w
	from	fa_receita_farmacia r
	where	r.nr_seq_regulacao = nr_atendimento_w
	  and		(r.nr_seq_origem IS NOT NULL AND r.nr_seq_origem::text <> '');

  if (nr_seq_regulacao_w IS NOT NULL AND nr_seq_regulacao_w::text <> '') then
		if (ie_status_medicacao_p = 'EC')then
			CALL alterar_status_regulacao(nr_seq_regulacao_w,'CA','',null,'S',null, null, ie_integracao_w);
		end  if;
		if (ie_status_medicacao_p = 'EN')then
			CALL alterar_status_regulacao(nr_seq_regulacao_w,'FI','',null,'S',null, null, ie_integracao_w);
		end  if;
  end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE medic_entregue_regulacao (nr_seq_entrega_p bigint, ie_status_medicacao_p text) FROM PUBLIC;

