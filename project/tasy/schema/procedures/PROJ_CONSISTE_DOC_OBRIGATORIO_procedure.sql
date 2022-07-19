-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_consiste_doc_obrigatorio ( nm_usuario_p text, nr_seq_projeto_p bigint) AS $body$
DECLARE


-- 'RE' (Repasse)		-- 'AC' (Acordo Comercial)		-- 'CR' (Cronograma)		-- 'PI' (Plano de implantação)		-- 'RC' (Reunião Consultoria)		-- 'RCO' (Reunião de coordenação)
-- 'R' (Risco)		-- 'MA'  (MPO e Aderência)		-- 'TR' (Treinamento)	-- 'M' (Manual)			-- 'OU' (Oficialização de uso)		-- 'ATA' (Ata de finalização do projeto)
-- 'EP' (Equipe e papéis)	-- 'R' (Risco)			-- 'SR' (Status report)	-- 'SP' (Score projeto)		-- 'PS' (Posicionamento semanal)
-- ie_tipo_arquivo_w >>>>	-- A - Anexo			-- R - Registro		-- T - Ata				-- C - RisCo
-- Variáveis do sistema;
ds_observacao_w		varchar(4000);
ds_documento_w		varchar(255);
ds_arquivo_w		varchar(255);
ds_objetivo_w		varchar(255);
ds_atividade_w		varchar(255);
ds_ativ_virada_w		varchar(255);
ds_tipo_nc_w		varchar(255);
ie_gravar_documento_w	varchar(1);
ie_tipo_arquivo_w		varchar(1);
ie_documento_w		varchar(1);
ie_treinamento_w		varchar(1);
ie_aderencia_w		varchar(1);
ie_mpo_w		varchar(1);
ie_virada_w		varchar(1);
dia_semana_w		varchar(1);
dia_mes_w		varchar(1);
mes_w			varchar(1);
ano_w			varchar(1);
qt_reg_w			bigint;
nr_seq_cronograma_w	bigint;
nr_seq_crono_proj_w	bigint;
nr_seq_etapa_tre_w	bigint;
nr_seq_mpo_aderencia_w	bigint;
nr_etapa_w		bigint;
nr_seq_treina_w		bigint;
nr_seq_etapa_w		bigint;
nr_seq_virada_w		bigint;
qt_alimentacao_w		bigint;
qt_deslocamento_w		bigint;
qt_estadia_w		bigint;
nr_sequencia_w		bigint;
nr_seq_cliente_w		bigint;
nr_seq_classif_w		bigint;
qt_classif_w		bigint;
nr_seq_ata_w		bigint;
nr_seq_interno_w		bigint;
dt_documento_w		timestamp;
dt_referencia_w		timestamp;
dt_virada_w		timestamp;

-- Gravar documentos obrigatório
c01 CURSOR FOR
SELECT	a.vl_dominio
from	valor_dominio a
where	a.cd_dominio = 5538
order by	vl_dominio;

-- Obter Cronograma
c02 CURSOR FOR
SELECT	a.nr_sequencia
from	proj_cronograma a
where	a.nr_seq_proj = nr_seq_projeto_p;

-- Obter Etapa
c03 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_treinamento,
	a.nr_seq_etapa
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_crono_proj_w;

-- Obter etapa que obrigam treinamento
c04 CURSOR FOR
SELECT	a.nr_sequencia
from	proj_cron_etapa a
where	a.nr_seq_superior = nr_seq_etapa_w
and	(a.pr_etapa IS NOT NULL AND a.pr_etapa::text <> '')
and	a.pr_etapa > 0;

-- Obter se foi documentado a atividade
c05 CURSOR FOR
SELECT	a.nr_seq_etapa_cron
from	proj_documento a
where	a.nr_seq_proj = nr_seq_projeto_p;

-- Obter se etapa é treinamento
c06 CURSOR FOR
SELECT	a.nr_sequencia
from	proj_cron_etapa a
where	a.nr_seq_superior in (	select	a.nr_sequencia
				from	proj_cron_etapa a
				where	a.ie_treinamento = 'S'
				and	a.nr_seq_cronograma = nr_seq_crono_proj_w);

-- Obter se possui etapa na atividade
c07 CURSOR FOR
SELECT	a.nr_sequencia
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_crono_proj_w
and	(a.nr_seq_etapa IS NOT NULL AND a.nr_seq_etapa::text <> '');

-- Obter se possui mpo/Aderencia na atividade
c08 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_aderencia,
	a.ie_mpo
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_crono_proj_w
and	(a.pr_etapa IS NOT NULL AND a.pr_etapa::text <> '')
and	a.pr_etapa > 89;

-- obter se possui campo virada setado
c09 CURSOR FOR
SELECT	a.nr_sequencia,
	a.dt_inicio_real,
	a.ds_atividade
from	proj_cron_etapa a
where	a.nr_seq_cronograma = nr_seq_crono_proj_w
and	(a.ie_virada IS NOT NULL AND a.ie_virada::text <> '');

-- obter se data fim real está null
c10 CURSOR FOR
SELECT (select ds_tipo_nc from proj_tipo_nao_conform h where h.nr_sequencia = g.nr_seq_tipo_nc) ds_tipo_nc
FROM	proj_projeto a,
	proj_tp_cliente b,
	proj_tp_roteiro c,
	proj_tp_cli_rot d,
	proj_tp_rot_item e,
	proj_tp_cli_rot_item f,
	proj_tp_cli_rot_acao g
where	a.nr_sequencia = b.nr_seq_proj
and	b.nr_sequencia = d.nr_seq_cliente
and	c.nr_sequencia = e.nr_seq_roteiro
and	c.nr_sequencia = d.nr_seq_roteiro
and	d.nr_sequencia = f.nr_seq_rot_cli
and	e.nr_sequencia = f.nr_seq_item
and	f.nr_sequencia = g.nr_seq_rot_item
and	coalesce(g.dt_fim_real::text, '') = ''
and	a.nr_sequencia = nr_seq_projeto_p;


BEGIN
delete
from	proj_doc_obrigatorio_w;

select	max(a.nr_seq_cliente),
	max(a.nr_seq_classif)
into STRICT	nr_seq_cliente_w,
	nr_seq_classif_w
from	proj_projeto a
where	a.nr_sequencia = nr_seq_projeto_p;

open C01;
loop
fetch C01 into
	ds_documento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_gravar_documento_w := 'N';
	if	(ds_documento_w = 'RE') then -- 'RE' (Repasse)
		ds_observacao_w := 'Falta documento de tipo "Repasse"';
		ie_tipo_arquivo_w := 'A'; -- Anexo
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'AC') then -- 'AC' (Acordo Comercial)
		ds_observacao_w := 'Falta documento de tipo "Acordo Comercial"';
		ie_tipo_arquivo_w := 'R'; -- Registro
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'CR') then -- 'CR' (Cronograma)
		ds_observacao_w := 'Falta cronograma com etapa neste projeto';
		ie_tipo_arquivo_w := 'R'; -- Registro
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'PI') then -- 'PI' (Plano de implantação)
		ds_observacao_w := 'Falta de "Plano de implantação"';
		ie_tipo_arquivo_w := 'A'; -- Anexo
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'RC') then -- 'RC' (Reunião Consultoria)
		ds_observacao_w := 'Falta de Ata com a classificação "Reunião Consultoria"';
		ie_tipo_arquivo_w := 'T'; -- Ata
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'RCO') then -- 'RCO' (Reunião de coordenação)
		ds_observacao_w := 'Falta de Ata com a classificação "Reunião de coordenação"';
		ie_tipo_arquivo_w := 'T'; -- Ata
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'R') then -- 'R' (Risco)
		ds_observacao_w := 'Falta de documento com o risco do projeto';
		ie_tipo_arquivo_w := 'C'; -- Risco
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'MA') then -- 'MA'  (MPO e Aderência)
		ds_observacao_w := 'Falta de MPO e Aderência';
		ie_tipo_arquivo_w := 'A'; -- Ata
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'TR') then -- 'TR' (Treinamento)
		ds_observacao_w := 'Falta de documento de tipo Treinamento';
		ie_tipo_arquivo_w := 'A'; -- Treinamento
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'M') then -- 'M' (Manual)
		ds_observacao_w := 'Falta do Manual para este projeto';
		ie_tipo_arquivo_w := 'A'; -- Manual
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'OU') then -- 'OU' (Oficialização de uso)
		ds_observacao_w := 'Falta do documento "Oficialização de uso"';
		ie_tipo_arquivo_w := 'A'; -- Anexo
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'ATA') then -- 'ATA' (Ata de finalização do projeto)
		ds_observacao_w := 'Falta da Ata de finalização do projeto';
		ie_tipo_arquivo_w := 'T'; -- Ata
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'EP') then -- 'EP' (Equipe e papéis)
		ds_observacao_w := 'Falta de registro em "Equipes e papéis"';
		ie_tipo_arquivo_w := 'R'; -- Registro
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'SR') then -- 'SR' (Status report)
		ds_observacao_w := 'Falta do registro "Status Report"';
		ie_tipo_arquivo_w := 'A'; -- Status Report
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'SP') then -- 'SP' (Score projeto)
		ds_observacao_w := 'Falta do registro "Score Projeto"';
		ie_tipo_arquivo_w := 'R'; -- Score projeto
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif	(ds_documento_w = 'PS') then -- 'PS' (Posicionamento semanal)
		ds_observacao_w := 'Falta de posicionamento semanal';
		ie_tipo_arquivo_w := 'R'; -- Posicionamento
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	elsif (ds_documento_w = 'ANC') then
		ds_observacao_w := 'Falta da data fim real em "Ação Não Conformidade"';
		ie_tipo_arquivo_w := 'R'; -- Não Conformidade
		ie_documento_w := proj_obter_status_documento(ds_documento_w);
	end if;

	ie_gravar_documento_w := proj_obter_se_grava_doc_obriga(ds_documento_w,nr_seq_projeto_p);

	if (ie_gravar_documento_w = 'S') then
		begin
		select	nextval('proj_doc_obrigatorio_w_seq')
		into STRICT	nr_sequencia_w
		;

		select	count(*)
		into STRICT	qt_classif_w
		from	proj_doc_classif a
		where	a.nr_seq_classif = nr_seq_classif_w
		and	a.nr_estagio_proj in (	SELECT	b.nr_sequencia
						from	proj_estagio_projetos b
						where	b.nr_sequencia = a.nr_estagio_proj
						and	exists (select	1
								from	proj_doc_obrigatorio x
								where	x.nr_seq_estagio = b.nr_sequencia
								and	x.ds_documento = ds_documento_w))  LIMIT 1;

		if (qt_classif_w > 0) then
			begin
			insert into proj_doc_obrigatorio_w(	nr_sequencia,
								dt_atualizacao,
								nm_usuario,
								ie_tipo_arquivo,
								dt_documento,
								nm_documento,
								ds_caminho_anexo,
								nr_seq_ata,
								ie_status,
								ds_observacao,
								ie_documento,
								nr_seq_interno)
							values (	nr_sequencia_w,
								clock_timestamp(),
								nm_usuario_p,
								ie_tipo_arquivo_w,
								'',
								ds_documento_w,
								'',
								null,
								'P',
								ds_observacao_w,
								ie_documento_w,
								null);

			if	(ds_documento_w = 'RE') then -- 'RE' (Repasse)
				begin
				select	count(*),
					max(a.ds_arquivo),
					max(a.ds_titulo),
					max(a.dt_arquivo),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					ds_arquivo_w,
					ds_observacao_w,
					dt_documento_w,
					nr_seq_interno_w
				from	proj_documento a
				where	a.nr_sequencia = (	SELECT	max(x.nr_sequencia)
								from	proj_documento x
								where	x.nr_seq_tipo_documento = 7
								and	x.nr_seq_proj = nr_seq_projeto_p); --3847
				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= ds_arquivo_w,
						ds_observacao		= ds_observacao_w,
						dt_documento		= dt_documento_w,
						nr_seq_interno		= nr_seq_interno_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'AC') then -- 'AC' (Acordo Comercial)
				begin
				select	count(*), -- Alimentação.
					max(a.dt_liberacao)
				into STRICT	qt_alimentacao_w,
					dt_documento_w
				from	com_cliente_acordo a
				where	a.ie_tipo_acordo = 'A'
				and	a.nr_seq_cliente = nr_seq_cliente_w;

				select	count(*), -- Deslocamento.
					max(a.dt_liberacao)
				into STRICT	qt_deslocamento_w,
					dt_documento_w
				from	com_cliente_acordo a
				where	a.ie_tipo_acordo = 'D'
				and	a.nr_seq_cliente = nr_seq_cliente_w;

				select	count(*), -- Estadia.
					max(a.dt_liberacao)
				into STRICT	qt_estadia_w,
					dt_documento_w
				from	com_cliente_acordo a
				where	a.ie_tipo_acordo = 'E'
				and	a.nr_seq_cliente = nr_seq_cliente_w;

				if (qt_alimentacao_w > 0) and (qt_deslocamento_w > 0) and (qt_estadia_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_observacao		= '',
						dt_documento		= dt_documento_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				else
					begin
					delete
					from	proj_doc_obrigatorio_w
					where	nm_documento = ds_documento_w;

					ds_observacao_w := '';
					if (qt_alimentacao_w = 0) then
						ds_observacao_w := ' - Falta acordo comercial (Alimentação)';
					end if;
					if (qt_deslocamento_w = 0) then
						ds_observacao_w := ds_observacao_w || ' - Falta acordo comercial (Deslocamento)';
					end if;
					if (qt_estadia_w = 0) then
						ds_observacao_w := ds_observacao_w || ' - Falta acordo comercial (Estadia)';
					end if;
					insert into proj_doc_obrigatorio_w(	nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										ie_tipo_arquivo,
										dt_documento,
										nm_documento,
										ds_caminho_anexo,
										nr_seq_ata,
										ie_status,
										ds_observacao,
										ie_documento,
										nr_seq_interno)
									values (	nr_sequencia_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_tipo_arquivo_w,
										'',
										ds_documento_w,
										'',
										null,
										'P',
										ds_observacao_w,
										ie_documento_w,
										null);
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'CR') then -- 'CR' (Cronograma)
				begin
				select	count(*)
				into STRICT	qt_reg_w
				from	proj_cron_etapa a
				where	a.nr_seq_cronograma in (SELECT	x.nr_sequencia
								from	proj_cronograma x
								where	x.nr_seq_proj	= nr_seq_projeto_p);

				if (qt_reg_w > 1) then
					begin
					delete
					from	proj_doc_obrigatorio_w
					where	nm_documento = 'CR';

					open C02;
					loop
					fetch C02 into
						nr_seq_cronograma_w;
					EXIT WHEN NOT FOUND; /* apply on C02 */
						begin
						select	nextval('proj_doc_obrigatorio_w_seq')
						into STRICT	nr_sequencia_w
						;

						select	dt_inicio
						into STRICT	dt_documento_w
						from	proj_cronograma a
						where	a.nr_sequencia = nr_seq_cronograma_w;

						insert into proj_doc_obrigatorio_w(	nr_sequencia,
											dt_atualizacao,
											nm_usuario,
											ie_tipo_arquivo,
											dt_documento,
											nm_documento,
											ds_caminho_anexo,
											nr_seq_ata,
											ie_status,
											ds_observacao,
											ie_documento,
											nr_seq_interno)
										values (	nr_sequencia_w,
											clock_timestamp(),
											nm_usuario_p,
											ie_tipo_arquivo_w,
											dt_documento_w,
											ds_documento_w,
											'',
											null,
											'D',
											'',
											ie_documento_w,
											nr_seq_cronograma_w);
						end;
					end loop;
					close C02;

					end;
				elsif (qt_reg_w = 1) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_observacao		= '',
						dt_documento		 = NULL
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'PI') then -- 'PI' (Plano de implantação)
				begin
				select	count(*),
					max(a.ds_arquivo),
					max(a.ds_titulo),
					max(a.dt_arquivo),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					ds_arquivo_w,
					ds_observacao_w,
					dt_documento_w,
					nr_seq_interno_w
				from	proj_documento a
				where	a.nr_seq_tipo_documento = 14
				and	nr_seq_proj = nr_seq_projeto_p; -- 3847
				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= ds_arquivo_w,
						ds_observacao		= ds_observacao_w,
						dt_documento		= dt_documento_w,
						nr_seq_interno		= nr_seq_interno_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'RC') then -- 'RC' (Reunião Consultoria)
				begin
				select	count(*),
					max(a.dt_ata),
					max(a.ds_ata),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					dt_documento_w,
					ds_observacao_w,
					nr_seq_ata_w
				from	proj_ata a
				where	a.nr_seq_projeto = nr_seq_projeto_p
				and	a.nr_seq_classif = 6;

				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= '',
						ds_observacao		= ds_observacao_w,
						dt_documento		= dt_documento_w,
						nr_seq_ata		= nr_seq_ata_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'RCO') then -- 'RCO' (Reunião de coordenação)
				begin
				select	count(*),
					max(a.dt_ata),
					max(a.ds_ata),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					dt_documento_w,
					ds_observacao_w,
					nr_seq_ata_w
				from	proj_ata a
				where	a.nr_seq_projeto = nr_seq_projeto_p
				and	a.nr_seq_classif = 5;

				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= '',
						ds_observacao		= ds_observacao_w,
						dt_documento		= dt_documento_w,
						nr_seq_ata		= nr_seq_ata_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'R') then -- 'R' (Risco)
				begin
				select	count(*),
					max(a.ds_titulo),
					max(a.dt_prev_solucao),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					ds_observacao_w,
					dt_documento_w,
					nr_seq_interno_w
				from	proj_risco_implantacao a
				where	a.nr_seq_proj = nr_seq_projeto_p;

				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= '',
						ds_observacao		= 'Existem ' || qt_reg_w || ' riscos documentados',
						dt_documento		= dt_documento_w,
						nr_seq_interno		= nr_seq_interno_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'MA') then -- 'MA'  (MPO e Aderência)
				begin

				open C02;
				loop
				fetch C02 into
					nr_seq_crono_proj_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin

					select	count(*)
					into STRICT	qt_reg_w
					from	proj_cron_etapa a
					where	a.nr_seq_cronograma = nr_seq_crono_proj_w
					and	(a.pr_etapa IS NOT NULL AND a.pr_etapa::text <> '')
					and	a.pr_etapa > 89;

					if (qt_reg_w > 0) then
						begin

						delete
						from	proj_doc_obrigatorio_w
						where	nm_documento = ds_documento_w;

						open C08;
						loop
						fetch C08 into
							nr_seq_mpo_aderencia_w,
							ie_aderencia_w,
							ie_mpo_w;
						EXIT WHEN NOT FOUND; /* apply on C08 */
							begin
							if (ie_aderencia_w = 'S') or (ie_mpo_w = 'S') then
								begin

								select	a.ds_atividade
								into STRICT	ds_atividade_w
								from	proj_cron_etapa a
								where	a.nr_sequencia = nr_seq_mpo_aderencia_w;

								select	nextval('proj_doc_obrigatorio_w_seq')
								into STRICT	nr_sequencia_w
								;

								ds_observacao_w :=	'Cronograma: ' 	|| nr_seq_crono_proj_w || ' - A atividade ' ||
										nr_seq_mpo_aderencia_w || ' - ' || ltrim(ds_atividade_w) || ' não foi documentado.';

								insert into proj_doc_obrigatorio_w(	nr_sequencia,
													dt_atualizacao,
													nm_usuario,
													ie_tipo_arquivo,
													dt_documento,
													nm_documento,
													ds_caminho_anexo,
													nr_seq_ata,
													ie_status,
													ds_observacao,
													ie_documento)
												values (	nr_sequencia_w,
													clock_timestamp(),
													nm_usuario_p,
													ie_tipo_arquivo_w,
													'',
													ds_documento_w,
													'',
													null,
													'P',
													ds_observacao_w,
													ie_documento_w);

								select	count(*),
									max(a.dt_arquivo),
									max(a.ds_titulo),
									max(a.ds_arquivo)
								into STRICT	qt_reg_w,
									dt_documento_w,
									ds_observacao_w,
									ds_arquivo_w
								from	proj_documento a
								where	a.nr_seq_proj = nr_seq_projeto_p
								and	a.nr_seq_etapa_cron = nr_seq_mpo_aderencia_w
								and	a.nr_seq_tipo_documento = 4;

								if (qt_reg_w > 0) then
									begin
									update	proj_doc_obrigatorio_w
									set	ie_status		= 'D',
										ds_observacao		= ds_observacao_w,
										dt_documento		= dt_documento_w,
										ds_caminho_anexo	= ds_arquivo_w
									where	nr_sequencia		= nr_sequencia_w;
									end;
								end if;
								end;
							end if;
							end;
						end loop;
						close C08;
						end;
					end if;
					end;
				end loop;
				close C02;
				end;
			elsif	(ds_documento_w = 'TR') then -- 'TR' (Treinamento)
				begin
				open C02;
				loop
				fetch C02 into
					nr_seq_crono_proj_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					select	count(*)
					into STRICT	qt_reg_w
					from	proj_cron_etapa a
					where	a.pr_etapa > 0
					and	a.nr_seq_superior in (	SELECT	a.nr_sequencia
									from	proj_cron_etapa a
									where	a.ie_treinamento = 'S'
									and	a.nr_seq_cronograma = nr_seq_crono_proj_w);

					if (qt_reg_w > 0) then
						begin
						delete
						from	proj_doc_obrigatorio_w a
						where	a.nm_documento = ds_documento_w;

						open C06;
						loop
						fetch C06 into
							nr_seq_treina_w;
						EXIT WHEN NOT FOUND; /* apply on C06 */
							begin
							select	a.ds_atividade
							into STRICT	ds_atividade_w
							from	proj_cron_etapa a
							where	a.nr_sequencia = nr_seq_treina_w;

							select	nextval('proj_doc_obrigatorio_w_seq')
							into STRICT	nr_sequencia_w
							;

							ds_observacao_w :=	'Cronograma: ' 		|| nr_seq_crono_proj_w || ' - A atividade ' ||
										nr_seq_treina_w || ' - ' || ltrim(ds_atividade_w) || ' não foi documentado.';
							insert into proj_doc_obrigatorio_w(	nr_sequencia,
												dt_atualizacao,
												nm_usuario,
												ie_tipo_arquivo,
												dt_documento,
												nm_documento,
												ds_caminho_anexo,
												nr_seq_ata,
												ie_status,
												ds_observacao,
												ie_documento)
											values (	nr_sequencia_w,
												clock_timestamp(),
												nm_usuario_p,
												ie_tipo_arquivo_w,
												'',
												ds_documento_w,
												'',
												null,
												'P',
												ds_observacao_w,
												ie_documento_w);

							select	count(*),
								max(a.dt_arquivo),
								max(a.ds_titulo),
								max(a.ds_arquivo)
							into STRICT	qt_reg_w,
								dt_documento_w,
								ds_observacao_w,
								ds_arquivo_w
							from	proj_documento a
							where	a.nr_seq_proj = nr_seq_projeto_p
							and	a.nr_seq_etapa_cron = nr_seq_treina_w
							and	a.nr_seq_tipo_documento = 6;

							if (qt_reg_w > 0) then
								begin
								update	proj_doc_obrigatorio_w
								set	ie_status		= 'D',
									ds_observacao		= ds_observacao_w,
									dt_documento		= dt_documento_w,
									ds_caminho_anexo	= ds_arquivo_w
								where	nr_sequencia		= nr_sequencia_w;
								end;
							end if;
							end;
						end loop;
						close C06;
						end;
					end if;
					end;
				end loop;
				close C02;
				end;
			elsif	(ds_documento_w = 'M') then -- 'M' (Manual)
				begin
				open C02;
				loop
				fetch C02 into
					nr_seq_crono_proj_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					select	count(*)
					into STRICT	qt_reg_w
					from	proj_cron_etapa a
					where	a.pr_etapa > 0
					and	a.nr_seq_cronograma = nr_seq_crono_proj_w
					and	(a.nr_seq_etapa IS NOT NULL AND a.nr_seq_etapa::text <> '');

					if (qt_reg_w > 0) then
						begin
						delete
						from	proj_doc_obrigatorio_w a
						where	a.nm_documento = ds_documento_w;

						open C07;
						loop
						fetch C07 into
							nr_etapa_w;
						EXIT WHEN NOT FOUND; /* apply on C07 */
							begin
							select	a.ds_atividade
							into STRICT	ds_atividade_w
							from	proj_cron_etapa a
							where	a.nr_sequencia = nr_etapa_w;

							select	nextval('proj_doc_obrigatorio_w_seq')
							into STRICT	nr_sequencia_w
							;

							ds_observacao_w :=	'Cronograma: ' 		|| nr_seq_crono_proj_w || ' - A atividade ' ||
										nr_etapa_w || ' - ' || ltrim(ds_atividade_w) || ' não foi documentado.';

							insert into proj_doc_obrigatorio_w(	nr_sequencia,
												dt_atualizacao,
												nm_usuario,
												ie_tipo_arquivo,
												dt_documento,
												nm_documento,
												ds_caminho_anexo,
												nr_seq_ata,
												ie_status,
												ds_observacao,
												ie_documento)
											values (	nr_sequencia_w,
												clock_timestamp(),
												nm_usuario_p,
												ie_tipo_arquivo_w,
												'',
												ds_documento_w,
												'',
												null,
												'P',
												ds_observacao_w,
												ie_documento_w);
							select	count(*),
								max(a.dt_arquivo),
								max(a.ds_titulo),
								max(a.ds_arquivo)
							into STRICT	qt_reg_w,
								dt_documento_w,
								ds_observacao_w,
								ds_arquivo_w
							from	proj_documento a
							where	a.nr_seq_proj = nr_seq_projeto_p
							and	a.nr_seq_etapa_cron = nr_etapa_w
							and	a.nr_seq_tipo_documento = 16;

							if (qt_reg_w > 0) then
								begin
								update	proj_doc_obrigatorio_w
								set	ie_status		= 'D',
									ds_observacao		= ds_observacao_w,
									dt_documento		= dt_documento_w,
									ds_caminho_anexo	= ds_arquivo_w
								where	nr_sequencia		= nr_sequencia_w;
								end;
							end if;
							end;
						end loop;
						close C07;
						end;
					end if;
					end;
				end loop;
				close C02;
				end;
			elsif	(ds_documento_w = 'OU') then -- 'OU' (Oficialização de uso)
				begin
				delete
				from	proj_doc_obrigatorio_w
				where	nm_documento = ds_documento_w;

				open C02;
				loop
				fetch C02 into
					nr_seq_crono_proj_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					open C09;
					loop
					fetch C09 into
						nr_seq_virada_w,
						dt_virada_w,
						ds_ativ_virada_w;
					EXIT WHEN NOT FOUND; /* apply on C09 */
						begin
						if (trunc(dt_virada_w + 20) < trunc(clock_timestamp())) then
							begin
							select	nextval('proj_doc_obrigatorio_w_seq')
							into STRICT	nr_sequencia_w
							;

							select	count(*),
								max(a.ds_arquivo),
								max(a.ds_titulo),
								max(a.dt_arquivo)
							into STRICT	qt_reg_w,
								ds_arquivo_w,
								ds_observacao_w,
								dt_documento_w
							from	proj_documento a
							where	a.nr_seq_tipo_documento = 2
							and	nr_seq_proj = nr_seq_projeto_p
							and	a.nr_seq_etapa_cron = nr_seq_virada_w; -- 3847
							if (qt_reg_w > 0) then
								begin
								insert into proj_doc_obrigatorio_w(	nr_sequencia,
													dt_atualizacao,
													nm_usuario,
													ie_tipo_arquivo,
													dt_documento,
													nm_documento,
													ds_caminho_anexo,
													nr_seq_ata,
													ie_status,
													ds_observacao,
													ie_documento,
													nr_seq_interno)
												values (	nr_sequencia_w,
													clock_timestamp(),
													nm_usuario_p,
													ie_tipo_arquivo_w,
													dt_documento_w,
													ds_documento_w,
													ds_arquivo_w,
													null,
													'D',
													ds_observacao_w,
													ie_documento_w,
													null);
								end;
							else
								begin
								insert into proj_doc_obrigatorio_w(	nr_sequencia,
													dt_atualizacao,
													nm_usuario,
													ie_tipo_arquivo,
													dt_documento,
													nm_documento,
													ds_caminho_anexo,
													nr_seq_ata,
													ie_status,
													ds_observacao,
													ie_documento,
													nr_seq_interno)
												values (	nr_sequencia_w,
													clock_timestamp(),
													nm_usuario_p,
													ie_tipo_arquivo_w,
													'',
													ds_documento_w,
													'',
													null,
													'P',
													'Falta o documento de oficialização de uso para a atividade ('||nr_seq_virada_w||' - '|| trim(both ds_ativ_virada_w) ||')',
													ie_documento_w,
													null);
								end;
							end if;
							end;
						end if;
						end;
					end loop;
					close C09;
					end;
				end loop;
				close C02;
				end;
			elsif	(ds_documento_w = 'ATA') then -- 'ATA' (Ata de finalização do projeto)
				begin
				select	count(*),
					max(a.dt_ata),
					max(a.ds_ata),
					max(a.nr_sequencia)
				into STRICT	qt_reg_w,
					dt_documento_w,
					ds_observacao_w,
					nr_seq_ata_w
				from	proj_ata a
				where	a.nr_seq_projeto = nr_seq_projeto_p
				and	a.nr_seq_classif = 8;

				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= '',
						ds_observacao		= ds_observacao_w,
						dt_documento		= dt_documento_w,
						nr_seq_ata		= nr_seq_ata_w
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'EP') then -- 'EP' (Equipe e papéis)
				begin
				select	count(*)
				into STRICT	qt_reg_w
				from	proj_equipe a
				where	a.nr_seq_proj = nr_seq_projeto_p;

				if (qt_reg_w > 0) then
					begin
					update	proj_doc_obrigatorio_w
					set	ie_status		= 'D',
						ds_caminho_anexo	= '',
						ds_observacao		= '',
						dt_documento		 = NULL,
						nr_seq_ata		 = NULL
					where	nr_sequencia		= nr_sequencia_w;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'SR') then -- 'SR' (Status report)
				begin
				delete
				from	proj_doc_obrigatorio_w
				where	nr_sequencia = nr_sequencia_w;

				select	pkg_date_utils.get_WeekDay(clock_timestamp())
				into STRICT	dia_semana_w
				;

				if ((dia_semana_w)::numeric  > 2) then
					begin
					select	count(*),
						max(a.dt_arquivo),
						max(a.ds_titulo),
						max(a.ds_arquivo)
					into STRICT	qt_reg_w,
						dt_documento_w,
						ds_observacao_w,
						ds_arquivo_w
					from	proj_documento a
					where	a.nr_seq_proj = nr_seq_projeto_p
					and	a.nr_seq_tipo_documento = 3;

					insert into proj_doc_obrigatorio_w(	nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										ie_tipo_arquivo,
										dt_documento,
										nm_documento,
										ds_caminho_anexo,
										nr_seq_ata,
										ie_status,
										ds_observacao,
										ie_documento)
									values (	nr_sequencia_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_tipo_arquivo_w,
										'',
										ds_documento_w,
										'',
										null,
										'P',
										'Falta do registro "Status Report"',
										ie_documento_w);

					dt_referencia_w := clock_timestamp() - (pkg_date_utils.get_WeekDay(clock_timestamp()) - 2);
					if (qt_reg_w > 0) and (trunc(dt_documento_w) >= trunc(dt_referencia_w)) then
						begin
						update	proj_doc_obrigatorio_w
						set	ie_status		= 'D',
							ds_caminho_anexo	= ds_arquivo_w,
							ds_observacao		= ds_observacao_w,
							dt_documento		= dt_documento_w,
							nr_seq_ata		 = NULL
						where	nr_sequencia		= nr_sequencia_w;
						end;
					end if;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'SP') then -- 'SP' (Score projeto)
				begin
				select	count(*),
					max(a.dt_escore)
				into STRICT	qt_reg_w,
					dt_documento_w
				from	proj_escore a
				where	a.nr_seq_proj = nr_seq_projeto_p;

				if (qt_reg_w > 0) then
					begin
					if (to_char(dt_documento_w,'mm') = to_char(clock_timestamp(),'mm')) then -- Se último score for mês atual
						begin
						update	proj_doc_obrigatorio_w
						set	ie_status		= 'D',
							ds_caminho_anexo	= '',
							ds_observacao		= '',
							dt_documento		= dt_documento_w,
							nr_seq_ata		 = NULL
						where	nr_sequencia		= nr_sequencia_w;
						end;
					elsif	(to_char(dt_documento_w,'mm') = (to_char((to_char(clock_timestamp(),'mm'))::numeric -1))) and -- 1 Mês anterior
						(to_char(clock_timestamp(),'dd') <= 20) then
						begin
						delete
						from	proj_doc_obrigatorio_w
						where	nr_sequencia = nr_sequencia_w;
						end;
					end if;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'PS') then -- 'PS' (Posicionamento semanal)
				begin
				delete
				from	proj_doc_obrigatorio_w
				where	nr_sequencia = nr_sequencia_w;

				select	pkg_date_utils.get_WeekDay(clock_timestamp())
				into STRICT	dia_semana_w
				;

				if ((dia_semana_w)::numeric  > 2) then
					begin
					select	count(*),
						max(a.dt_posicao),
						max(a.nr_sequencia)
					into STRICT	qt_reg_w,
						dt_documento_w,
						nr_seq_interno_w
					from	proj_posicao_coordenacao a
					where	a.nr_seq_proj = nr_seq_projeto_p;

					insert into proj_doc_obrigatorio_w(	nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										ie_tipo_arquivo,
										dt_documento,
										nm_documento,
										ds_caminho_anexo,
										nr_seq_ata,
										ie_status,
										ds_observacao,
										ie_documento,
										nr_seq_interno)
									values (	nr_sequencia_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_tipo_arquivo_w,
										'',
										ds_documento_w,
										'',
										null,
										'P',
										'Falta de posicionamento semanal',
										ie_documento_w,
										null);

					dt_referencia_w := clock_timestamp() - (pkg_date_utils.get_WeekDay(clock_timestamp()) - 2);
					if (qt_reg_w > 0) and (trunc(dt_documento_w) >= trunc(dt_referencia_w)) then
						begin
						update	proj_doc_obrigatorio_w
						set	ie_status		= 'D',
							ds_caminho_anexo	= '',
							ds_observacao		= '',
							dt_documento		= dt_documento_w,
							nr_seq_ata		 = NULL,
							nr_seq_interno		= nr_seq_interno_w
						where	nr_sequencia		= nr_sequencia_w;
						end;
					end if;
					end;
				end if;
				end;
			elsif	(ds_documento_w = 'ANC') then -- 'ANC' (Ação Não Conformidade)
				begin
					delete
					from	proj_doc_obrigatorio_w
					where	nm_documento = ds_documento_w;

					open c10;
					loop
					fetch c10 into ds_tipo_nc_w;
					EXIT WHEN NOT FOUND; /* apply on c10 */
						begin

						select	nextval('proj_doc_obrigatorio_w_seq')
						into STRICT	nr_sequencia_w
						;

						if (ds_tipo_nc_w IS NOT NULL AND ds_tipo_nc_w::text <> '') then
							ds_tipo_nc_w := ds_observacao_w||' - '||ds_tipo_nc_w;
						end if;

						insert into proj_doc_obrigatorio_w(	nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										ie_tipo_arquivo,
										dt_documento,
										nm_documento,
										ds_caminho_anexo,
										nr_seq_ata,
										ie_status,
										ds_observacao,
										ie_documento,
										nr_seq_interno)
									values (	nr_sequencia_w,
										clock_timestamp(),
										nm_usuario_p,
										ie_tipo_arquivo_w,
										'',
										ds_documento_w,
										'',
										null,
										'P',
										ds_tipo_nc_w,
										ie_documento_w,
										null);

						end;
					end loop;
					close c10;
				end;
			end if;
			end;
		end if;
		end;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_consiste_doc_obrigatorio ( nm_usuario_p text, nr_seq_projeto_p bigint) FROM PUBLIC;

