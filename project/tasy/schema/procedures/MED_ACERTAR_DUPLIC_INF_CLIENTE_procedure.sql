-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_acertar_duplic_inf_cliente (nr_seq_origem_p bigint, nr_seq_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w	bigint;
ds_long_w	text;


BEGIN
if (nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '') and (nr_seq_destino_p IS NOT NULL AND nr_seq_destino_p::text <> '') then

	/* alerta */

	update	med_alerta
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* antecedente neonatal */

	update	med_antecedente_neonatal
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* atendimento */

	update	med_atendimento
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* atestado */

	update	med_atestado
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* avaliação completa */

	update	med_aval_completa_pac
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* consulta */

	select	coalesce(count(*),0)
	into STRICT	qt_registro_w
	from	med_consulta
	where	nr_seq_cliente = nr_seq_destino_p;

	if (qt_registro_w = 0) then
		update	med_consulta
		set	nr_seq_cliente = nr_seq_destino_p
		where	nr_seq_cliente = nr_seq_origem_p;
	else
		select	coalesce(count(*),0)
		into STRICT	qt_registro_w
		from	med_consulta
		where	nr_seq_cliente = nr_seq_origem_p;

		if (qt_registro_w > 0) then
			select	ds_consulta
			into STRICT	ds_long_w
			from	med_consulta
			where	nr_seq_cliente = nr_seq_origem_p;

			insert into med_evolucao(
							nr_sequencia,
							nr_atendimento,
							dt_atualizacao,
							nm_usuario,
							dt_evolucao,
							ds_evolucao,
							nr_seq_cliente
							)
						SELECT	nextval('med_evolucao_seq'),
							null,
							clock_timestamp(),
							nm_usuario_p,
							trunc(clock_timestamp()),
							ds_long_w,
							nr_seq_destino_p
						;

		delete	from med_consulta
		where	nr_seq_cliente = nr_seq_origem_p;
		end if;
	end if;

	/* evolução */

	update	med_evolucao
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* exame avaliacao */

	update	med_exame_avaliacao
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* cid */

	update	med_pac_cid
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* contato */

	update	med_pac_contato
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* diagnóstico */

	select	coalesce(count(*),0)
	into STRICT	qt_registro_w
	from	med_pac_diagnostico
	where	nr_seq_cliente = nr_seq_destino_p;

	if (qt_registro_w = 0) then
		update	med_pac_diagnostico
		set	nr_seq_cliente = nr_seq_destino_p
		where	nr_seq_cliente = nr_seq_origem_p;
	else
		insert into med_evolucao(
						nr_sequencia,
						nr_atendimento,
						dt_atualizacao,
						nm_usuario,
						dt_evolucao,
						ds_evolucao,
						nr_seq_cliente
						)
					SELECT	nextval('med_evolucao_seq'),
						null,
						clock_timestamp(),
						nm_usuario_p,
						trunc(clock_timestamp()),
						ds_diagnostico,
						nr_seq_destino_p
					from	med_pac_diagnostico
					where	nr_seq_cliente = nr_seq_origem_p;

		delete	from med_pac_diagnostico
		where	nr_seq_cliente = nr_seq_origem_p;
	end if;

	/* ginecologia */

	update	med_pac_ginecologia
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* pré natal */

	update	med_pac_pre_natal
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* sinal vital */

	update	med_pac_sinal_vital
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* parecer médico */

	update	med_parecer_medico
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* pedido exame */

	update	med_pedido_exame
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* receita */

	update	med_receita
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* resultado exame */

	update	med_result_exame
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* segurança */

	update	med_seguranca
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* texto adicional */

	update	med_texto_adicional
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;

	/* tratamento */

	update	med_tratamento
	set	nr_seq_cliente = nr_seq_destino_p
	where	nr_seq_cliente = nr_seq_origem_p;



	/* cliente */

	delete	from med_cliente
	where	nr_sequencia = nr_seq_origem_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_acertar_duplic_inf_cliente (nr_seq_origem_p bigint, nr_seq_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
