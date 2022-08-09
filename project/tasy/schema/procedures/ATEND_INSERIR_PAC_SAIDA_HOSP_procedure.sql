-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_inserir_pac_saida_hosp ( nm_usuario_p text, nr_atendimento_p bigint, ds_observacao_p text, dt_saida_p timestamp, dt_chegada_p timestamp, ie_saida_p text) AS $body$
DECLARE



nr_sequencia_min_w	bigint := 0;

BEGIN

select coalesce(min(nr_sequencia),0)
into STRICT nr_sequencia_min_w
from atend_pac_saida_hosp
where nr_atendimento = nr_atendimento_p
and   coalesce(dt_chegada::text, '') = '';

if (ie_saida_p = 'S') then  /*Verifica se é saída ou chegada*/
	begin

	if	not(nr_sequencia_min_w	>	0) then

		insert into atend_pac_saida_hosp(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_atendimento,
					ds_observacao,
					dt_saida,
					dt_chegada)
			values (nextval('atend_pac_saida_hosp_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_atendimento_p,
					substr(ds_observacao_p,1,255),
					dt_saida_p,
					dt_chegada_p);
	else
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(262506);
	end if;

	end;
else
	begin

	if (nr_sequencia_min_w	>	0) then

		update atend_pac_saida_hosp
		set dt_chegada = dt_chegada_p
		where	nr_atendimento = nr_atendimento_p
		and		nr_sequencia = nr_sequencia_min_w;

	else
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(262507);
   	end if;

	end;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_inserir_pac_saida_hosp ( nm_usuario_p text, nr_atendimento_p bigint, ds_observacao_p text, dt_saida_p timestamp, dt_chegada_p timestamp, ie_saida_p text) FROM PUBLIC;
