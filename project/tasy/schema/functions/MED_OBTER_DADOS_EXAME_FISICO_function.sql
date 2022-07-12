-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION med_obter_dados_exame_fisico ( nr_seq_cliente_p bigint, ie_tipo_consulta_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		double precision;
qt_peso_w		real;
qt_altura_cm_w		real;
qt_imc_w		real;
qt_superf_corporia_w	double precision;
qt_ca_w			real;
qt_pa_sistolica_w	smallint;
qt_pa_diastolica_w	smallint;
qt_temp_w		real;
qt_perimetro_cefalico_w	real;

/* ie_opcao_p
P - Peso
A - Altura
I - IMC
S - Superficie corporia
PS - PA Sistolica
PD - PA Diastolica
T - Temperatura
CA - CA
PC - Perimetro cefalico
*/
BEGIN

if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
	begin
	select	coalesce(qt_peso,0),
		coalesce(qt_altura_cm,0),
		coalesce(qt_imc,0),
		coalesce(qt_superf_corporia,0),
		coalesce(qt_pa_sistolica,0),
		coalesce(qt_pa_diastolica,0),
		coalesce(qt_temp,0),
		coalesce(qt_ca,0),
		coalesce(qt_perimetro_cefalico,0)
	into STRICT	qt_peso_w,
		qt_altura_cm_w,
		qt_imc_w,
		qt_superf_corporia_w,
		qt_pa_sistolica_w,
		qt_pa_diastolica_w,
		qt_temp_w,
		qt_ca_w,
		qt_perimetro_cefalico_w
	from	med_consulta
	where	nr_seq_cliente		= nr_seq_cliente_p
	and	ie_tipo_consulta	= ie_tipo_consulta_p;

	if (ie_opcao_p = 'P') then
		ds_retorno_w := qt_peso_w;
	elsif (ie_opcao_p = 'A') then
		ds_retorno_w := qt_altura_cm_w;
	elsif (ie_opcao_p = 'I') then
		ds_retorno_w := qt_imc_w;
	elsif (ie_opcao_p = 'S') then
		ds_retorno_w := qt_superf_corporia_w;
	elsif (ie_opcao_p = 'PS') then
		ds_retorno_w := qt_pa_sistolica_w;
	elsif (ie_opcao_p = 'PD') then
		ds_retorno_w := qt_pa_diastolica_w;
	elsif (ie_opcao_p = 'T') then
		ds_retorno_w := qt_temp_w;
	elsif (ie_opcao_p = 'CA') then
		ds_retorno_w := qt_ca_w;
	elsif (ie_opcao_p = 'PC') then
		ds_retorno_w := qt_perimetro_cefalico_w;
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION med_obter_dados_exame_fisico ( nr_seq_cliente_p bigint, ie_tipo_consulta_p bigint, ie_opcao_p text) FROM PUBLIC;

