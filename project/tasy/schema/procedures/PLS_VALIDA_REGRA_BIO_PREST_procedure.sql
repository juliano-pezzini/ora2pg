-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_regra_bio_prest (nm_usuario_p text) AS $body$
DECLARE



/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Controlar a ativacao da biometria do prestador
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ x ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Rotina e chamada pelo JOB.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_horario_desabilita_w		varchar(60);
ds_armazena_w				varchar(10);
ds_horario_w				varchar(5);
ie_desabilita_td_w			boolean := false;
qt_horas_desabilita_w		integer;
nr_seq_regra_w				bigint;
nr_seq_prestador_w			bigint;
cd_prestador_w				varchar(30);
ie_valida_cod_prest_w		varchar(1);
nr_seq_controle_bio_pre_w	bigint;
ds_historico_w 				varchar(255);
qt_registros_w				bigint;
dt_atual_w					timestamp;

C01 CURSOR FOR
	SELECT	ds_horario_desabilita,
		qt_horas_desabilita,
		nr_sequencia
	from	pls_regra_biometria_prest
	where	ie_situacao = 'A'
	and	dt_atual_w between trunc(dt_inicio_vigencia) and coalesce(trunc(dt_fim_vigencia),dt_atual_w)
	and ((ds_horario_desabilita IS NOT NULL AND ds_horario_desabilita::text <> '') or (qt_horas_desabilita IS NOT NULL AND qt_horas_desabilita::text <> ''))
	and (coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento and pls_obter_se_controle_estab('RE') = 'S')
	and	coalesce(ie_aplicacao_regra, 1) = 1
	
union all

	SELECT	ds_horario_desabilita,
		qt_horas_desabilita,
		nr_sequencia
	from	pls_regra_biometria_prest
	where	ie_situacao = 'A'
	and	dt_atual_w between trunc(dt_inicio_vigencia) and coalesce(trunc(dt_fim_vigencia),dt_atual_w)
	and ((ds_horario_desabilita IS NOT NULL AND ds_horario_desabilita::text <> '') or (qt_horas_desabilita IS NOT NULL AND qt_horas_desabilita::text <> ''))
	and 	pls_obter_se_controle_estab('RE') = 'N'
	and	coalesce(ie_aplicacao_regra, 1) = 1;

C02 CURSOR FOR
	SELECT	nr_seq_prestador,
		ie_valida_cod_prest
	from	pls_prest_exige_biometria
	where	nr_seq_regra_biometria = nr_seq_regra_w
	and	ie_situacao = 'A';

C03 CURSOR FOR
	SELECT  a.nr_sequencia
	from	pls_controle_biomet_prest a,
		pls_prestador b
	where	b.nr_sequencia = a.nr_seq_prestador
	and (b.nr_sequencia = nr_seq_prestador_w
	or (coalesce(ie_valida_cod_prest_w, 'N') = 'S'
	and	b.cd_prestador  = cd_prestador_w
	and	(b.cd_prestador IS NOT NULL AND b.cd_prestador::text <> '')
	and	(cd_prestador_w IS NOT NULL AND cd_prestador_w::text <> '') ))
	and	coalesce(a.dt_desativacao::text, '') = '';

BEGIN

dt_atual_w   := trunc(clock_timestamp());
ds_horario_w := to_char(clock_timestamp(), 'hh24:mi');

open C01;
loop
fetch C01 into
	ds_horario_desabilita_w,
	qt_horas_desabilita_w,
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		-- Regra definida por horarios especificos
		if (ds_horario_desabilita_w IS NOT NULL AND ds_horario_desabilita_w::text <> '') then
			for x in 1..length(ds_horario_desabilita_w)
			loop
				if (substr(ds_horario_desabilita_w,x,1) = ',' or length(ds_horario_desabilita_w) = x) then
					if (substr(ds_horario_desabilita_w,x,1) <> ',') then
						ds_armazena_w := ds_armazena_w || substr(ds_horario_desabilita_w,x,1);
					end if;

					if (ds_armazena_w = ds_horario_w ) then
						ie_desabilita_td_w := true;
						exit;
					else
						ds_armazena_w := '';
					end if;
				else
					ds_armazena_w := ds_armazena_w || substr(ds_horario_desabilita_w,x,1);
				end if;
			end loop;
		end if;

		open C02;
		loop
		fetch C02 into
			nr_seq_prestador_w,
			ie_valida_cod_prest_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

				begin
					select	cd_prestador
					into STRICT	cd_prestador_w
					from 	pls_prestador
					where	nr_sequencia = nr_seq_prestador_w;
				exception
				when others then
					cd_prestador_w :=  null;
				end;

				open C03;
				loop
				fetch C03 into
					nr_seq_controle_bio_pre_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
						if ( not ie_desabilita_td_w  and coalesce(ds_horario_desabilita_w::text, '') = '' ) then
							-- Regra definida por tempo de ativacao
							select	count(1)
							into STRICT	qt_registros_w
							from	pls_controle_biomet_prest
							where	nr_sequencia = nr_seq_controle_bio_pre_w
							and	clock_timestamp() > (dt_ativacao + (qt_horas_desabilita_w / 24));

							if (qt_registros_w > 0) then
								ie_desabilita_td_w := true;
							end if;
						end if;

						if ( ie_desabilita_td_w ) then
							-- Caso se encaixe em das regras, desabilita a biometria
							ds_historico_w := 'Biometria desabilitada pela JOB, conforme regra '||nr_seq_regra_w||'.';

							update	pls_controle_biomet_prest
							set	dt_desativacao = clock_timestamp(),
								dt_atualizacao = clock_timestamp(),
								nm_usuario = nm_usuario_p
							where	nr_sequencia = nr_seq_controle_bio_pre_w;

							insert into pls_hist_biometria_prest(
									nr_sequencia, dt_historico, nr_seq_controle_prest,
									ds_historico, dt_atualizacao, nm_usuario,
									dt_atualizacao_nrec, nm_usuario_nrec)
							values (
									nextval('pls_hist_biometria_prest_seq'), clock_timestamp(), nr_seq_controle_bio_pre_w,
									ds_historico_w, clock_timestamp(), nm_usuario_p,
									clock_timestamp(), nm_usuario_p);
						 end if;

					end;
				end loop;
				close C03;

			end;
		end loop;
		close C02;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_regra_bio_prest (nm_usuario_p text) FROM PUBLIC;

