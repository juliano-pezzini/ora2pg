-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_regra_tempo_atend ( nr_seq_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_tempo_w		bigint;
nr_seq_atendimento_evento_w	bigint;
nr_seq_tipo_ocorrencia_w	bigint;
qt_tempo_maximo_w		bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_atend_regra_tempo 	b,
		pls_atendimento		a
	where	b.ie_situacao 		= 'A'
	and	b.qt_tempo_maximo 	>= round((coalesce(a.dt_fim_atendimento, clock_timestamp()) - a.dt_inicio) * 86400,2)
	and	a.nr_sequencia 		= nr_seq_atendimento_p
	and (pls_obter_se_controle_estab('GA') = 'S' and (b.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
	
union all

	SELECT	b.nr_sequencia
	from	pls_atend_regra_tempo 	b,
		pls_atendimento		a
	where	b.ie_situacao 		= 'A'
	and	b.qt_tempo_maximo 	>= round((coalesce(a.dt_fim_atendimento, clock_timestamp()) - a.dt_inicio) * 86400,2)
	and	a.nr_sequencia 		= nr_seq_atendimento_p
	and (pls_obter_se_controle_estab('GA') = 'N');

C02 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_atendimento_evento a
	where	a.nr_seq_atendimento = nr_seq_atendimento_p;

C03 CURSOR FOR
	SELECT	b.nr_sequencia
	from	pls_regra_tempo_event_ocor 	b,
		pls_atendimento_evento	 	a
	where	b.ie_situacao			= 'A'
	and	b.qt_tempo_maximo		>= round((coalesce(a.dt_fim_evento, clock_timestamp()) - a.dt_inicio) * 86400,2)
	and	b.nr_seq_tipo_ocorrencia	= a.nr_seq_tipo_ocorrencia
	and	a.nr_sequencia			= nr_seq_atendimento_evento_w
	and (pls_obter_se_controle_estab('GA') = 'S' and (b.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento))
	
union all

	SELECT	b.nr_sequencia
	from	pls_regra_tempo_event_ocor 	b,
		pls_atendimento_evento	 	a
	where	b.ie_situacao			= 'A'
	and	b.qt_tempo_maximo		>= round((coalesce(a.dt_fim_evento, clock_timestamp()) - a.dt_inicio) * 86400,2)
	and	b.nr_seq_tipo_ocorrencia	= a.nr_seq_tipo_ocorrencia
	and	a.nr_sequencia			= nr_seq_atendimento_evento_w
	and (pls_obter_se_controle_estab('GA') = 'N');


BEGIN
if (nr_seq_atendimento_p IS NOT NULL AND nr_seq_atendimento_p::text <> '') then
	/* Obter regra em que o atendimento se encaixa */

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_tempo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;

	if (coalesce(nr_seq_regra_tempo_w::text, '') = '') then
		if (pls_obter_se_controle_estab('GA') = 'S') then
			begin
				select	nr_sequencia
				into STRICT	nr_seq_regra_tempo_w
				from	pls_atend_regra_tempo
				where	ie_situacao 	= 'A'
				and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento)
				and	qt_tempo_maximo = (	SELECT	max(qt_tempo_maximo)
								from	pls_atend_regra_tempo
								where	ie_situacao = 'A'
								and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento));
			exception
				when others then
				nr_seq_regra_tempo_w := null;
			end;
		else
			begin
				select	nr_sequencia
				into STRICT	nr_seq_regra_tempo_w
				from	pls_atend_regra_tempo
				where	ie_situacao 	= 'A'
				and	qt_tempo_maximo = (	SELECT	max(qt_tempo_maximo)
								from	pls_atend_regra_tempo
								where	ie_situacao = 'A');
			exception
				when others then
				nr_seq_regra_tempo_w := null;
			end;
		end if;
	end if;

	if (nr_seq_regra_tempo_w IS NOT NULL AND nr_seq_regra_tempo_w::text <> '') then
		update	pls_atendimento
		set	nr_seq_regra_tempo	= nr_seq_regra_tempo_w
		where	nr_sequencia 		= nr_seq_atendimento_p;

		nr_seq_regra_tempo_w := null;
	end if;

	/* Obter regra em que o evento se encaixa */

	open C02;
	loop
	fetch C02 into
		nr_seq_atendimento_evento_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		open C03;
		loop
		fetch C03 into
			nr_seq_regra_tempo_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		end loop;
		close C03;

		if (coalesce(nr_seq_regra_tempo_w::text, '') = '') then
			begin
				select	a.nr_seq_tipo_ocorrencia
				into STRICT	nr_seq_tipo_ocorrencia_w
				from	pls_atendimento_evento a
				where	a.nr_sequencia = nr_seq_atendimento_evento_w;
			exception
				when others then
				nr_seq_tipo_ocorrencia_w := null;
			end;

			if (nr_seq_tipo_ocorrencia_w IS NOT NULL AND nr_seq_tipo_ocorrencia_w::text <> '') then
				if (pls_obter_se_controle_estab('GA') = 'S') then
					begin
						select	qt_tempo_maximo
						into STRICT	qt_tempo_maximo_w
						from	pls_regra_tempo_event_ocor
						where	ie_situacao		= 'A'
						and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
						and	coalesce(nr_seq_evento::text, '') = ''
						and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
					exception
						when others then
						qt_tempo_maximo_w := null;
					end;

					if (qt_tempo_maximo_w IS NOT NULL AND qt_tempo_maximo_w::text <> '') then
						begin
							select	nr_sequencia
							into STRICT	nr_seq_regra_tempo_w
							from	pls_regra_tempo_event_ocor
							where	ie_situacao 		= 'A'
							and	qt_tempo_maximo 	= qt_tempo_maximo_w
							and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
							and	coalesce(nr_seq_evento::text, '') = ''
							and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento );
						exception
							when others then
							nr_seq_regra_tempo_w := null;
						end;
					end if;
				else
					begin
						select	qt_tempo_maximo
						into STRICT	qt_tempo_maximo_w
						from	pls_regra_tempo_event_ocor
						where	ie_situacao		= 'A'
						and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
						and	coalesce(nr_seq_evento::text, '') = '';
					exception
						when others then
						qt_tempo_maximo_w := null;
					end;

					if (qt_tempo_maximo_w IS NOT NULL AND qt_tempo_maximo_w::text <> '') then
						begin
							select	nr_sequencia
							into STRICT	nr_seq_regra_tempo_w
							from	pls_regra_tempo_event_ocor
							where	ie_situacao 		= 'A'
							and	qt_tempo_maximo 	= qt_tempo_maximo_w
							and	nr_seq_tipo_ocorrencia	= nr_seq_tipo_ocorrencia_w
							and	coalesce(nr_seq_evento::text, '') = '';
						exception
							when others then
							nr_seq_regra_tempo_w := null;
						end;
					end if;
				end if;
			end if;
		end if;

		if (nr_seq_regra_tempo_w IS NOT NULL AND nr_seq_regra_tempo_w::text <> '') then
			update 	pls_atendimento_evento
			set	nr_seq_regra_tempo 	= nr_seq_regra_tempo_w
			where 	nr_sequencia 		= nr_seq_atendimento_evento_w;
		end if;
		end;
	end loop;
	close C02;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_regra_tempo_atend ( nr_seq_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
