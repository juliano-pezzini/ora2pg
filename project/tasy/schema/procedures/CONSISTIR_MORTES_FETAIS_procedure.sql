-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_mortes_fetais ( nm_campo_p text, ds_campo_p bigint, qt_idade_mae_p bigint, qt_sobreviventes_p bigint, qt_filhos_vivos_p bigint, qt_natimortos_p bigint, nr_ano_nascimento_p bigint, nr_mes_nascimento_p bigint, nr_dia_nascimento_p bigint, nr_hora_nascimento_p bigint, nr_min_nascimento_p bigint, nr_ano_certificacao_p bigint, nr_mes_certificacao_p bigint, nr_dia_certificacao_p bigint, ds_mensagem_confirm_p INOUT text, ds_mensagem_abort_p INOUT text) AS $body$
DECLARE


qt_total_filhos_w		smallint;
data_expulsion_hora_w 	timestamp;
data_expulsion_w 		timestamp;
data_certificacao_w		timestamp;


BEGIN

	if (nm_campo_p = 'QT_IDADE_PROD') then
		if ((ds_campo_p < 1) or (ds_campo_p > 46) and ds_campo_p <> 88 and ds_campo_p <> 99)  then
			ds_mensagem_abort_p := 'Edad Gestacional Erronea. Los rangos permitidos son de 1-46 ó 88 (No Especificado) ó 99 (Se Ignora).';
		elsif (ds_campo_p > 0 and ds_campo_p < 13) or (ds_campo_p > 42 and ds_campo_p < 47) then
			ds_mensagem_confirm_p := 'El dato ingresado de la Edad Gestacional es: ' || ds_campo_p || '. Este dato es correcto?';
		end if;
	end if;
	
	if (nm_campo_p = 'QT_PESO_PROD') then
		if ((ds_campo_p < 20) or (ds_campo_p > 8000) and ds_campo_p <> 8888 and ds_campo_p <> 9999) then
			ds_mensagem_abort_p := 'El peso capturado es de: ' || ds_campo_p || '. Los rangos permitidos son de 20-8000 ó 8888 (No especificado) ó 9999 (Se ignora).';
		elsif (ds_campo_p > 6000 and ds_campo_p < 8001) then
			ds_mensagem_confirm_p := 'El dato ingresado en el Peso es: ' || ds_campo_p || '. Este dato es correcto?';
		end if;
	end if;
	
	if (nm_campo_p = 'QT_FETOS') then
		if (ds_campo_p = 2) or (ds_campo_p = 3) then
			ds_mensagem_confirm_p := 'Recuerde que debe de llenar un certificado por cada producto muerto.';
		end if;
	end if;
	
	if (nm_campo_p = 'QT_CONSULTAS') then
		if ((ds_campo_p < 0) or (ds_campo_p > 18) and ds_campo_p <> 88 and ds_campo_p <> 99) then
			ds_mensagem_abort_p := 'El total de consultas recibidas capturado es de: ' || ds_campo_p || '. Los rangos permitidos son de 00-18 ó 88 (No especificado) ó 99 (Se ignora).';
		end if;
	end if;
	
	if (nm_campo_p = 'QT_IDADE_MAE') then
		if ((ds_campo_p < 8) or (ds_campo_p > 59) and ds_campo_p <> 88 and ds_campo_p <> 99) then
			ds_mensagem_abort_p := 'Los rangos pemitidos de la Edad son de 8-59 años ó 88 (No especificado) ó 99 (Se ignora).';
		elsif (ds_campo_p > 7 and ds_campo_p < 10) or (ds_campo_p > 54 and ds_campo_p < 60) then
			ds_mensagem_confirm_p := 'El dato ingresado en la Edad del Madre es: ' || ds_campo_p || '. Este dato es correcto?';
		end if;
	end if;
	
	if (nm_campo_p = 'QT_GESTACOES') then
		if (qt_idade_mae_p < 15) then
			if (ds_campo_p < 1 or ds_campo_p > 9) and ds_campo_p <> 99 then
				ds_mensagem_abort_p := 'Los rangos pemitidos de la Gestaciones son de 1-9. Edad de la madre es: ' || qt_idade_mae_p || '.';
			end if;	
		elsif (ds_campo_p < 1 or ds_campo_p > 25) and ds_campo_p <> 99 then
			ds_mensagem_abort_p := 'Los rangos pemitidos de la Gestaciones son de 1-25.';
		elsif (ds_campo_p > 9) and (ds_campo_p <> 99) then
			ds_mensagem_confirm_p := 'El dato ingresado en la Gestaciones es: ' || ds_campo_p || '. Este dato es correcto?';
		end if;
	end if;
	
	select
	CASE WHEN coalesce(qt_filhos_vivos_p, 0)=99 THEN  0  ELSE qt_filhos_vivos_p END  + CASE WHEN coalesce(qt_natimortos_p, 0)=99 THEN  0  ELSE qt_natimortos_p END 
	into STRICT qt_total_filhos_w 
	;
	
	if (nm_campo_p = 'QT_FILHOS_VIVOS') then
		if (qt_filhos_vivos_p > 25 or qt_filhos_vivos_p < 0) and qt_filhos_vivos_p <> 99 then
			ds_mensagem_abort_p := 'El numero total de hijos nacidos vivos no debe de pasar de 25.';
		elsif (qt_total_filhos_w > 25) and (qt_natimortos_p > 0) and (qt_filhos_vivos_p > 0) and (qt_filhos_vivos_p <> 99) then
			ds_mensagem_abort_p := 'La suma de nacidos vivos y muertos no debe de pasar de 25 ó menos de 0 (favor de verificar).';
		else	
			if (ds_campo_p < 0 or ds_campo_p > 25) and ds_campo_p <> 99 then
				ds_mensagem_abort_p := 'El número total de hijos nacidos vivos es de: ' || ds_campo_p || '. Los rangos permitidos son de 0-25.';
			elsif (ds_campo_p < qt_sobreviventes_p) and qt_sobreviventes_p <> 99 then
				ds_mensagem_abort_p := 'El número de hijos nacidos vivos es menos que el numero hijos sobrevivientes.';
			elsif (ds_campo_p > 9) and (ds_campo_p <> 99) then
				ds_mensagem_confirm_p := 'El dato ingresado en el campo Nacidos Vivos es: ' || ds_campo_p || '. Este dato es correcto?';
			end if;
		end if;
	end if;
	
	if (nm_campo_p = 'QT_NATIMORTOS') then
		if (qt_natimortos_p > 25 or qt_natimortos_p < 0) and qt_natimortos_p <> 99 then
			ds_mensagem_abort_p := 'El numero total de hijos nacidos muertos no debe de pasar de 25.';
		elsif (qt_total_filhos_w > 25) and (qt_filhos_vivos_p > 0) and (qt_natimortos_p > 0) then
			ds_mensagem_abort_p := 'La suma de nacidos vivos y muertos no debe de pasar de 25 ó menos de 0 (favor de verificar).';
		else	
			if (ds_campo_p < 1 or ds_campo_p > 25) and ds_campo_p <> 99 then
				ds_mensagem_abort_p := 'El número total de hijos nacidos muertos es de: ' || ds_campo_p || '. Los rangos permitidos son de 1-25.';
			elsif (ds_campo_p > 9) and (ds_campo_p <> 99) then
				ds_mensagem_confirm_p := 'El dato ingresado en el campo Nacidos Muertos es: ' || ds_campo_p || '. Este dato es correcto?';
			end if;
		end if;	
	end if;	
	
	if (nm_campo_p = 'QT_SOBREVIVENTES') then
		if (ds_campo_p > qt_filhos_vivos_p) and (qt_filhos_vivos_p <> 99) and (ds_campo_p <> 99) then
			ds_mensagem_abort_p := 'El número de hijos sobrevivientes es mayor que el numero hijos nacidos vivos.';
		elsif (ds_campo_p < 0) or (ds_campo_p > 25) and (ds_campo_p <> 99) then
			ds_mensagem_abort_p := 'El número total de hijos sobrevivientes es de: ' || ds_campo_p || '. Los rangos permitidos son de 0-25.';
		elsif (ds_campo_p > 9) and (ds_campo_p <> 99) then
			ds_mensagem_confirm_p := 'El dato ingresado en el campo Sobrevivientes es: ' || ds_campo_p || '. Este dato es correcto?';
		end if;
	end if;
	
	if (nr_ano_nascimento_p IS NOT NULL AND nr_ano_nascimento_p::text <> '') and (nr_mes_nascimento_p IS NOT NULL AND nr_mes_nascimento_p::text <> '') and (nr_dia_nascimento_p IS NOT NULL AND nr_dia_nascimento_p::text <> '') then
		data_expulsion_hora_w  := pkg_date_utils.get_dateTime(nr_ano_nascimento_p, nr_mes_nascimento_p, nr_dia_nascimento_p, nr_hora_nascimento_p, nr_min_nascimento_p);
		data_expulsion_w := pkg_date_utils.get_date(nr_ano_nascimento_p, nr_mes_nascimento_p, nr_dia_nascimento_p);
	end if;	
	
	if (nm_campo_p = 'NR_DIA_NASCIMENTO' or nm_campo_p = 'NR_MES_NASCIMENTO' or nm_campo_p = 'NR_ANO_NASCIMENTO' or nm_campo_p = 'NR_HORA_NASCIMENTO' or nm_campo_p = 'NR_MIN_NASCIMENTO') then
		if (data_expulsion_hora_w > clock_timestamp()) then
			ds_mensagem_abort_p := 'La fecha de la Expulsión o Extracción no debe de ser mayor a la fecha del día de hoy: Capturada: ' || to_char(data_expulsion_hora_w, 'dd-MON-yyyy HH24:MI') || ' > ' || 'Fecha de hoy: ' || to_char(clock_timestamp(), 'dd-MON-yyyy HH24:MI');
		elsif (data_expulsion_w > data_certificacao_w) then
			ds_mensagem_abort_p := 'La fecha de Expulsión no puede ser mayor a la fecha de certificación.';
		end if;
	end if;
	
	if (nr_ano_certificacao_p IS NOT NULL AND nr_ano_certificacao_p::text <> '') and (nr_mes_certificacao_p IS NOT NULL AND nr_mes_certificacao_p::text <> '') and (nr_dia_certificacao_p IS NOT NULL AND nr_dia_certificacao_p::text <> '') then
		data_certificacao_w := pkg_date_utils.get_date(nr_ano_certificacao_p, nr_mes_certificacao_p, nr_dia_certificacao_p);
	end if;	
	
	if (nm_campo_p = 'NR_DIA_CERTIFICACAO' or nm_campo_p = 'NR_MES_CERTIFICACAO' or nm_campo_p = 'NR_ANO_CERTIFICACAO') then
		if (data_certificacao_w > clock_timestamp()) then
			ds_mensagem_abort_p := 'La fecha de la Certificación debe ser menor o igual a la del día de hoy: Capturada: ' || data_certificacao_w || ' > ' || 'Fecha de hoy: ' || clock_timestamp();
		elsif (data_certificacao_w < data_expulsion_w) then
			ds_mensagem_abort_p := 'La fecha de certificación no puede ser inferior a la fecha de expulsión.';
		end if;
	end if;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_mortes_fetais ( nm_campo_p text, ds_campo_p bigint, qt_idade_mae_p bigint, qt_sobreviventes_p bigint, qt_filhos_vivos_p bigint, qt_natimortos_p bigint, nr_ano_nascimento_p bigint, nr_mes_nascimento_p bigint, nr_dia_nascimento_p bigint, nr_hora_nascimento_p bigint, nr_min_nascimento_p bigint, nr_ano_certificacao_p bigint, nr_mes_certificacao_p bigint, nr_dia_certificacao_p bigint, ds_mensagem_confirm_p INOUT text, ds_mensagem_abort_p INOUT text) FROM PUBLIC;

