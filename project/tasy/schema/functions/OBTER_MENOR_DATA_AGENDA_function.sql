-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_menor_data_agenda ( ds_lista_agendas_p text) RETURNS timestamp AS $body$
DECLARE

nr_pos_separador_w			bigint;
ds_lista_agendas_w			varchar(6000);
nr_pos_sep_itens_w			bigint;
cd_tipo_agenda_w			bigint;
ds_ultimo_caracter_w		varchar(1);
dt_primeira_agenda_w		timestamp;
dt_agenda_select_w		timestamp;
nr_seq_agenda_w				agenda_consulta.nr_sequencia%type;
qt_controle_w				bigint;				

BEGIN
ds_lista_agendas_w	:= ds_lista_agendas_p;

if (position('(' in ds_lista_agendas_w) > 0 ) and (position(')' in ds_lista_agendas_w) > 0 ) then
	ds_lista_agendas_w	:= substr(ds_lista_agendas_p,(position('(' in ds_lista_agendas_p)+1),(position(')' in ds_lista_agendas_p)-2));
end if;

select	substr(ds_lista_agendas_w, length(ds_lista_agendas_w), length(ds_lista_agendas_w))
into STRICT	ds_ultimo_caracter_w
;

if (ds_ultimo_caracter_w	<> ',') then
	ds_lista_agendas_w	:= ds_lista_agendas_w || ',';
end if;

qt_controle_w 		:= 0;
nr_pos_separador_w	:= position(',' in ds_lista_agendas_w);
nr_pos_sep_itens_w	:= position('-' in ds_lista_agendas_w);

while(nr_pos_separador_w > 0) and (qt_controle_w < 1000 ) loop
	
	nr_seq_agenda_w		:= substr(ds_lista_agendas_w,1,nr_pos_sep_itens_w - 1);
	cd_tipo_agenda_w	:= substr(ds_lista_agendas_w,nr_pos_sep_itens_w + 1,1);
	
	/*Obter as informacoes da agenda */

	if (cd_tipo_agenda_w = 2)then
		select max(HR_INICIO)
		into STRICT 	dt_agenda_select_w
		from agenda_paciente
		where nr_sequencia = nr_seq_agenda_w;
	elsif (cd_tipo_agenda_w in (3,4,5))then
		select max(dt_agenda)
		into STRICT 	dt_agenda_select_w
		from agenda_consulta
		where nr_sequencia = nr_seq_agenda_w;	
	end if;
	
	if (dt_agenda_select_w < dt_primeira_agenda_w) then
		dt_primeira_agenda_w := dt_agenda_select_w;
	elsif (coalesce(dt_primeira_agenda_w::text, '') = '') then
		dt_primeira_agenda_w := dt_agenda_select_w;
	end if;
	
	ds_lista_agendas_w	:= substr(ds_lista_agendas_w,nr_pos_separador_w+1,length(ds_lista_agendas_w));
	nr_pos_separador_w 	:= position(',' in ds_lista_agendas_w);
	nr_pos_sep_itens_w	:= position('-' in ds_lista_agendas_w);
	qt_controle_w		:= qt_controle_w + 1;
	
end loop;

return dt_primeira_agenda_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_menor_data_agenda ( ds_lista_agendas_p text) FROM PUBLIC;

