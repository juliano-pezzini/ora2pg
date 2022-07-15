-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agenda_mensal ( nm_usuario_p text, cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_referencia_p timestamp, dt_final_p timestamp, ie_forma_geracao_p text, ds_separador_mes_p text, ds_separador_ano_p text, cd_turno_p bigint, cd_departamento_medico_p bigint default null, ds_status_mes_p INOUT text DEFAULT NULL, ds_status_janeiro_p INOUT text DEFAULT NULL, ds_status_fevereiro_p INOUT text DEFAULT NULL, ds_status_marco_p INOUT text DEFAULT NULL, ds_status_abril_p INOUT text DEFAULT NULL, ds_status_maio_p INOUT text DEFAULT NULL, ds_status_junho_p INOUT text DEFAULT NULL, ds_status_julho_p INOUT text DEFAULT NULL, ds_status_agosto_p INOUT text DEFAULT NULL, ds_status_setembro_p INOUT text DEFAULT NULL, ds_status_outubro_p INOUT text DEFAULT NULL, ds_status_novembro_p INOUT text DEFAULT NULL, ds_status_dezembro_p INOUT text DEFAULT NULL, ds_status_periodo_p INOUT text DEFAULT NULL, cd_convenio_p bigint default null, ie_classif_agenda_p text default null, ds_lista_total_livre_p INOUT text DEFAULT NULL) AS $body$
DECLARE


dt_inicio_mes_w	timestamp;
dt_final_mes_w	timestamp;
dt_referencia_w	timestamp;
nr_mes_w	smallint;
qt_meses_w	bigint;
nr_ano_w	integer;


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_agenda_p IS NOT NULL AND cd_agenda_p::text <> '') and (dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '') and (ie_forma_geracao_p IS NOT NULL AND ie_forma_geracao_p::text <> '') then
	begin
	if (ie_forma_geracao_p = 'M') then
		begin
		dt_referencia_w	:= dt_referencia_p;
		dt_inicio_mes_w	:= PKG_DATE_UTILS.start_of(dt_referencia_w,'month',0);
		dt_final_mes_w	:= pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_referencia_w, 'MONTH', 0), dt_referencia_w);


		SELECT * FROM agenda_dia_status(
			cd_estabelecimento_p, cd_agenda_p, dt_inicio_mes_w, dt_final_mes_w, cd_turno_p, nm_usuario_p, ds_status_mes_p, cd_departamento_medico_p, cd_convenio_p, ie_classif_agenda_p, ds_lista_total_livre_p) INTO STRICT ds_status_mes_p, ds_lista_total_livre_p;
		end;
	elsif (ie_forma_geracao_p = 'A') then
		begin
		nr_mes_w	:= 1;
		dt_referencia_w	:= PKG_DATE_UTILS.start_of(dt_referencia_p,'year', 0);
		while(nr_mes_w <= 12) loop
			begin
			if (nr_mes_w > 1) then
				begin
				dt_referencia_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_referencia_w,1,0);
				end;
			end if;
			dt_inicio_mes_w	:= PKG_DATE_UTILS.start_of(dt_referencia_w,'month', 0);
			dt_final_mes_w	:= pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_referencia_w, 'MONTH', 0), dt_referencia_w);

			SELECT * FROM agenda_dia_status(
				cd_estabelecimento_p, cd_agenda_p, dt_inicio_mes_w, dt_final_mes_w, cd_turno_p, nm_usuario_p, ds_status_mes_p, null, cd_convenio_p, ie_classif_agenda_p, ds_lista_total_livre_p) INTO STRICT ds_status_mes_p, ds_lista_total_livre_p;

			if (nr_mes_w = 1) then
				begin
				ds_status_janeiro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 2) then
				begin
				ds_status_fevereiro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 3) then
				begin
				ds_status_marco_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 4) then
				begin
				ds_status_abril_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 5) then
				begin
				ds_status_maio_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 6) then
				begin
				ds_status_junho_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 7) then
				begin
				ds_status_julho_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 8) then
				begin
				ds_status_agosto_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 9) then
				begin
				ds_status_setembro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 10) then
				begin
				ds_status_outubro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 11) then
				begin
				ds_status_novembro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 12) then
				begin
				ds_status_dezembro_p	:= ds_status_mes_p;
				end;
			end if;
			nr_mes_w	:= nr_mes_w + 1;
			end;
		end loop;
		end;
	elsif (ie_forma_geracao_p = 'P') and (dt_final_p IS NOT NULL AND dt_final_p::text <> '') and (ds_separador_mes_p IS NOT NULL AND ds_separador_mes_p::text <> '') and (ds_separador_ano_p IS NOT NULL AND ds_separador_ano_p::text <> '') then
		begin
		ds_status_periodo_p	:= '';
		dt_inicio_mes_w	:= PKG_DATE_UTILS.start_of(dt_referencia_p, 'month', 0);
		nr_mes_w		:= PKG_DATE_UTILS.extract_field('MONTH', dt_referencia_p );

		qt_meses_w	:= 0;
		nr_ano_w		:= PKG_DATE_UTILS.extract_field('YEAR', dt_final_p) - PKG_DATE_UTILS.extract_field('YEAR',dt_referencia_p);
		while nr_ano_w > 0 loop
			begin
			qt_meses_w	:= qt_meses_w + 12;
			nr_ano_w		:= nr_ano_w - 1;
			end;
		end loop;
		qt_meses_w	:= qt_meses_w + (PKG_DATE_UTILS.extract_field('MONTH',dt_final_p) - PKG_DATE_UTILS.extract_field('MONTH',dt_referencia_p));

		while(qt_meses_w >= 0) loop
			begin
			SELECT * FROM agenda_dia_status(
				cd_estabelecimento_p, cd_agenda_p, dt_inicio_mes_w, pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_inicio_mes_w, 'MONTH', 0), dt_inicio_mes_w), cd_turno_p, nm_usuario_p, ds_status_mes_p, null, cd_convenio_p, ie_classif_agenda_p, ds_lista_total_livre_p) INTO STRICT ds_status_mes_p, ds_lista_total_livre_p;

			ds_status_periodo_p	:= ds_status_periodo_p || ds_status_mes_p;
			if (qt_meses_w > 0) then
				begin
				if (nr_mes_w = '12') then
					begin
					nr_mes_w	:= '0';
					ds_status_periodo_p	:= ds_status_periodo_p || ds_separador_ano_p;
					end;
				else
					ds_status_periodo_p	:= ds_status_periodo_p || ds_separador_mes_p;
				end if;
				end;
			end if;

			dt_inicio_mes_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_inicio_mes_w, 1, 0);
			nr_mes_w		:= nr_mes_w + 1;
			qt_meses_w	:= qt_meses_w - 1;
			end;
		end loop;
		end;

	elsif (ie_forma_geracao_p = 'R') then

		nr_mes_w	:= 1;
		dt_referencia_w	:= PKG_DATE_UTILS.start_of(dt_referencia_p,'year', 0);
		while(nr_mes_w <= 12) loop
			begin
			if (nr_mes_w > 1) then
				begin
				dt_referencia_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_referencia_w,1,0);
				end;
			end if;
			dt_inicio_mes_w	:= PKG_DATE_UTILS.start_of(dt_referencia_w,'month', 0);
			dt_final_mes_w	:= pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_referencia_w, 'MONTH', 0), dt_referencia_w);

			ds_status_mes_p := agenda_radioterapia_dia_status(
				cd_estabelecimento_p, cd_agenda_p, dt_inicio_mes_w, dt_final_mes_w, nm_usuario_p, ds_status_mes_p);

			if (nr_mes_w = 1) then
				begin
				ds_status_janeiro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 2) then
				begin
				ds_status_fevereiro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 3) then
				begin
				ds_status_marco_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 4) then
				begin
				ds_status_abril_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 5) then
				begin
				ds_status_maio_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 6) then
				begin
				ds_status_junho_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 7) then
				begin
				ds_status_julho_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 8) then
				begin
				ds_status_agosto_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 9) then
				begin
				ds_status_setembro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 10) then
				begin
				ds_status_outubro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 11) then
				begin
				ds_status_novembro_p	:= ds_status_mes_p;
				end;
			elsif (nr_mes_w = 12) then
				begin
				ds_status_dezembro_p	:= ds_status_mes_p;
				end;
			end if;
			nr_mes_w	:= nr_mes_w + 1;
			end;
		end loop;

	end if;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agenda_mensal ( nm_usuario_p text, cd_estabelecimento_p bigint, cd_agenda_p bigint, dt_referencia_p timestamp, dt_final_p timestamp, ie_forma_geracao_p text, ds_separador_mes_p text, ds_separador_ano_p text, cd_turno_p bigint, cd_departamento_medico_p bigint default null, ds_status_mes_p INOUT text DEFAULT NULL, ds_status_janeiro_p INOUT text DEFAULT NULL, ds_status_fevereiro_p INOUT text DEFAULT NULL, ds_status_marco_p INOUT text DEFAULT NULL, ds_status_abril_p INOUT text DEFAULT NULL, ds_status_maio_p INOUT text DEFAULT NULL, ds_status_junho_p INOUT text DEFAULT NULL, ds_status_julho_p INOUT text DEFAULT NULL, ds_status_agosto_p INOUT text DEFAULT NULL, ds_status_setembro_p INOUT text DEFAULT NULL, ds_status_outubro_p INOUT text DEFAULT NULL, ds_status_novembro_p INOUT text DEFAULT NULL, ds_status_dezembro_p INOUT text DEFAULT NULL, ds_status_periodo_p INOUT text DEFAULT NULL, cd_convenio_p bigint default null, ie_classif_agenda_p text default null, ds_lista_total_livre_p INOUT text DEFAULT NULL) FROM PUBLIC;

