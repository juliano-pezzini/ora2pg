-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_regra_copartic ( nr_seq_regra_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE



	procedure consistir_apropriacoes_regra is
	
		qt_regras_tipo_fixo_w		integer := 0;
		qt_regras_tipo_percentual_w	integer := 0;
		qt_regras_tipo_percent_dif_w	integer := 0;

		qt_percentual_apropriacao_w	pls_regra_copartic_aprop.tx_apropriacao%type := 0;
		vl_apropriacao_w		pls_regra_copartic_aprop.vl_apropriacao%type := 0;

		apropriacoes_regra CURSOR FOR
			SELECT	*
			from	pls_regra_copartic_aprop
			where	nr_seq_regra = nr_seq_regra_p;

	
BEGIN
		for apropriacoes_regra_w in apropriacoes_regra loop
			if (apropriacoes_regra_w.ie_tipo_apropriacao = 1) then
				if (coalesce(apropriacoes_regra_w.vl_apropriacao::text, '') = '' or apropriacoes_regra_w.vl_apropriacao <= 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310432);
				end if;
				if (apropriacoes_regra_w.tx_apropriacao IS NOT NULL AND apropriacoes_regra_w.tx_apropriacao::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310433);
				end if;
				qt_regras_tipo_fixo_w := qt_regras_tipo_fixo_w + 1;
				vl_apropriacao_w := vl_apropriacao_w + apropriacoes_regra_w.vl_apropriacao;
			elsif (apropriacoes_regra_w.ie_tipo_apropriacao = 2) then
				if (coalesce(apropriacoes_regra_w.tx_apropriacao::text, '') = '' or apropriacoes_regra_w.tx_apropriacao <= 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310431);
				end if;
				if (apropriacoes_regra_w.vl_apropriacao IS NOT NULL AND apropriacoes_regra_w.vl_apropriacao::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310437);
				end if;
				qt_regras_tipo_percentual_w := qt_regras_tipo_percentual_w + 1;
				qt_percentual_apropriacao_w := qt_percentual_apropriacao_w + apropriacoes_regra_w.tx_apropriacao;
			elsif (apropriacoes_regra_w.ie_tipo_apropriacao = 3) then
				if (coalesce(apropriacoes_regra_w.tx_apropriacao::text, '') = '' or apropriacoes_regra_w.tx_apropriacao <= 0) then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310431);
				end if;
				if (apropriacoes_regra_w.vl_apropriacao IS NOT NULL AND apropriacoes_regra_w.vl_apropriacao::text <> '') then
					CALL wheb_mensagem_pck.exibir_mensagem_abort(310437);
				end if;
				qt_regras_tipo_percent_dif_w := qt_regras_tipo_percent_dif_w + 1;
				qt_percentual_apropriacao_w := qt_percentual_apropriacao_w + apropriacoes_regra_w.tx_apropriacao;
			end if;
		end loop;

		if (	qt_regras_tipo_fixo_w = 0 and
			qt_regras_tipo_percentual_w = 0 and
			qt_regras_tipo_percent_dif_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310416);
		end if;
		if (qt_regras_tipo_fixo_w <> 0) then
			if (qt_regras_tipo_percentual_w <> 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(346360);
			elsif (qt_regras_tipo_percent_dif_w = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310417);
			end if;
		end if;
		if (qt_regras_tipo_percentual_w <> 0) then
			if (qt_percentual_apropriacao_w <> 100) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310420);
			elsif (qt_regras_tipo_percent_dif_w <> 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(306577);
			end if;
		end if;
		if (qt_regras_tipo_percent_dif_w <> 0) then
			if (qt_regras_tipo_fixo_w = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310430);
			elsif (qt_percentual_apropriacao_w <> 100) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310420);
			end if;
		end if;
	end;

	procedure consistir_beneficiarios_regra is

		beneficiarios_regra CURSOR FOR
			SELECT	*
			from	pls_regra_copartic_benef
			where	nr_seq_regra = nr_seq_regra_p;

		ie_existe_regra_repetida_w	number(15);

	begin
		for beneficiarios_regra_w in beneficiarios_regra loop
			if (	beneficiarios_regra_w.ie_titularidade = 'A' or
				beneficiarios_regra_w.ie_titularidade = 'T') and (beneficiarios_regra_w.ie_tipo_parentesco IS NOT NULL AND beneficiarios_regra_w.ie_tipo_parentesco::text <> '')then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310545);
			elsif (	beneficiarios_regra_w.qt_idade_min < 0 or
				beneficiarios_regra_w.qt_idade_max < 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310505);
			elsif (	beneficiarios_regra_w.qt_idade_min > beneficiarios_regra_w.qt_idade_max) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310567);
			elsif (	beneficiarios_regra_w.dt_contrato_de > beneficiarios_regra_w.dt_contrato_ate) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310574);
			elsif (	beneficiarios_regra_w.nr_faixa_salarial_inicial > beneficiarios_regra_w.nr_faixa_salarial_final) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310583);
			end if;
		end loop;

	end;

	procedure consistir_conta_regra is
		contas_regra CURSOR FOR
			SELECT	*
			from	pls_regra_copartic_conta
			where	nr_seq_regra = nr_seq_regra_p;
	begin
		for contas_regra_w in contas_regra loop
			if (contas_regra_w.vl_item_minimo < 0 or
			    contas_regra_w.vl_item_maximo < 0) then
			    CALL wheb_mensagem_pck.exibir_mensagem_abort(310798);
			elsif (contas_regra_w.vl_item_minimo > contas_regra_w.vl_item_maximo) then
			    CALL wheb_mensagem_pck.exibir_mensagem_abort(310800);
			end if;
		end loop;
	end;

	procedure consistir_incidencia_regra is
		regras_incidencia CURSOR FOR
			SELECT	*
			from	pls_regra_copartic_util
			where	nr_seq_regra = nr_seq_regra_p;
	begin
		for regras_incidencia_w in regras_incidencia loop
			if (	regras_incidencia_w.qt_evento_minimo < 0 or
				regras_incidencia_w.qt_evento_maximo < 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310623);
			elsif (	regras_incidencia_w.qt_evento_maximo < regras_incidencia_w.qt_evento_minimo) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310624);
			elsif (	coalesce(regras_incidencia_w.ie_eventos_incidencia, 'N') = 'S' and
				(regras_incidencia_w.nr_seq_grupo_serv IS NOT NULL AND regras_incidencia_w.nr_seq_grupo_serv::text <> '')) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310627, null, -20012);
			elsif (	regras_incidencia_w.ie_tipo_data_consistencia <> 'S' and (regras_incidencia_w.qt_periodo_ocorrencia IS NOT NULL AND regras_incidencia_w.qt_periodo_ocorrencia::text <> '')) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310628);
			elsif (	((regras_incidencia_w.ie_tipo_periodo_ocor IS NOT NULL AND regras_incidencia_w.ie_tipo_periodo_ocor::text <> '') and coalesce(regras_incidencia_w.qt_periodo_ocorrencia::text, '') = '') or ((regras_incidencia_w.qt_periodo_ocorrencia IS NOT NULL AND regras_incidencia_w.qt_periodo_ocorrencia::text <> '') and coalesce(regras_incidencia_w.ie_tipo_periodo_ocor::text, '') = '')) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(310629);
			end if;
		end loop;
	end;

	procedure consistir_prestador_regra is
		ie_existe_prest_tipo_prest_w	number(15);
		ie_existe_regra_repetida_w	number(15);
	begin
		select	count(1)
		into STRICT	ie_existe_prest_tipo_prest_w
		from	pls_regra_copartic_prest
		where	nr_seq_regra = nr_seq_regra_p
		and	(nr_seq_tipo_prestador_atend IS NOT NULL AND nr_seq_tipo_prestador_atend::text <> '')
		and	(nr_seq_prestador_atend IS NOT NULL AND nr_seq_prestador_atend::text <> '');

		if (ie_existe_prest_tipo_prest_w > 1) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310608);
		end if;

	end;

	procedure consistir_regras_repetidas is
		ie_existe_regra_repetida_w	number(15);
	begin

		--Beneficiário
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_benef
			 where	nr_seq_regra = nr_seq_regra_p
			 group by nr_seq_plano,
				  ie_titularidade,
				  ie_tipo_parentesco,
                  ie_situacao_benef,
				  qt_idade_min,
				  qt_idade_max,
				  dt_contrato_de,
				  dt_contrato_ate,
				  nr_faixa_salarial_inicial,
				  nr_faixa_salarial_final) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310617);
		end if;

		--Conta
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_conta
			 where	nr_seq_regra = nr_seq_regra_p
			 group by ie_cobranca_prevista,
				  vl_item_minimo,
				  vl_item_maximo,
				  nr_seq_tipo_conta) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310612);
		end if;

		--Incidência
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_util
			 where	nr_seq_regra = nr_seq_regra_p
			 group by ie_eventos_incidencia,
				  nr_seq_grupo_serv,
				  qt_evento_minimo,
				  qt_evento_maximo,
				  ie_tipo_data_consistencia,
				  qt_periodo_ocorrencia,
				  ie_tipo_periodo_ocor) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310630);
		end if;

		--Prestador
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_prest
			 where	nr_seq_regra = nr_seq_regra_p
			 group by ie_prestador_cooperado,
				  nr_seq_tipo_prestador_atend,
				  nr_seq_prestador_atend) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310609);
		end if;

		--Guia
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_guia
			 where	nr_seq_regra = nr_seq_regra_p
			 group by ie_tipo_atend_tiss,
				  nr_seq_controle_interno) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(310605);
		end if;

		--Internação
		select	count(1)
		into STRICT	ie_existe_regra_repetida_w
		from (SELECT	count(1)	qt_regras_repetidas
			 from	pls_regra_copartic_interna
			 where	nr_seq_regra = nr_seq_regra_p
			 group by nr_seq_clinica,
				  qt_diaria_inicial,
				  qt_diaria_final) alias2
		where	qt_regras_repetidas > 1;

		if (ie_existe_regra_repetida_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(322427);
		end if;

	end;

begin

	CALL consistir_apropriacoes_regra();
	consistir_beneficiarios_regra;
	consistir_conta_regra;
	consistir_incidencia_regra;
	consistir_prestador_regra;
	consistir_regras_repetidas;

	update	pls_regra_copartic
	set	dt_liberacao = clock_timestamp(),
		nm_usuario_liberacao = nm_usuario_p
	where	nr_sequencia	= nr_seq_regra_p;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_regra_copartic ( nr_seq_regra_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
