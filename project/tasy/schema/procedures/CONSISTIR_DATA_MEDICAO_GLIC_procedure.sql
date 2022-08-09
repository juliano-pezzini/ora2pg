-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_data_medicao_glic (nr_atendimento_p bigint, nr_seq_glicemia_p bigint, nr_seq_protocolo_p bigint, dt_medicao_p timestamp) AS $body$
DECLARE


dt_entrada_w		timestamp;
dt_alta_w		timestamp;
nr_seq_glic_ant_w	bigint;
dt_medicao_w		timestamp;


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_seq_glicemia_p IS NOT NULL AND nr_seq_glicemia_p::text <> '') and (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') and (dt_medicao_p IS NOT NULL AND dt_medicao_p::text <> '') then
	/* obter dados atendimento */

	select	max(dt_entrada),
		max(dt_alta)
	into STRICT	dt_entrada_w,
		dt_alta_w
	from	atendimento_paciente
	where	nr_atendimento = nr_atendimento_p;

	if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
		---Este atendimento teve alta em #@DT_ALTA#@!Nao e possivel registrar medicoes de glicemia para atendimentos com alta!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261470,	'DT_ALTA='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_alta_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
	elsif (dt_medicao_p < dt_entrada_w) then
		---A data da medicao atual nao pode ser anterior a data de entrada do atendimento!
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(261477);
	end if;
	
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_glic_ant_w
	from	atendimento_glicemia
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_protocolo = nr_seq_protocolo_p
	and	coalesce(nr_seq_glicemia,0) = coalesce(nr_seq_glicemia_p,nr_seq_glicemia)
	and	ie_status_glicemia <> 'T';

	if (nr_seq_glic_ant_w > 0) then
		select	dt_controle
		into STRICT	dt_medicao_w
		from	atendimento_glicemia
		where	nr_sequencia = nr_seq_glic_ant_w;
		if (dt_medicao_p < dt_medicao_w) then
			---A data da medicao atual nao pode ser inferior a data da medicao anterior, a qual foi realizada em #@DT_MEDICAO#@.
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(261479,'DT_MEDICAO='||PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_medicao_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone));
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_data_medicao_glic (nr_atendimento_p bigint, nr_seq_glicemia_p bigint, nr_seq_protocolo_p bigint, dt_medicao_p timestamp) FROM PUBLIC;
