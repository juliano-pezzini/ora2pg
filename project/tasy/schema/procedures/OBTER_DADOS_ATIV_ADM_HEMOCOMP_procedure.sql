-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_ativ_adm_hemocomp ( nr_seq_graf_atual_p bigint, dt_value_x_p text, ie_fim_administracao_p INOUT text, ds_titulo_hemocomp_p INOUT text, qt_dose_p INOUT bigint, ds_observacao_p INOUT text, ds_identificacao_bolsa_p INOUT text, dt_inicio_hemocomponente_p INOUT text, dt_inicio_hemocomp_date_p INOUT timestamp, dt_value_x_date_p timestamp default null) AS $body$
DECLARE


ie_fim_administracao_w		varchar(5);
ds_titulo_hemocomp_w		varchar(255);
qt_dose_w			double precision;
ds_observacao_w			varchar(255);
ds_identificacao_bolsa_w	varchar(15);
dt_inicio_hemocomponente_w	timestamp;
dt_value_w				timestamp;


BEGIN
select	max(obter_se_fim_administracao(nr_sequencia)) ie_fim_administracao,
	max(substr(obter_desc_san_derivado(nr_seq_derivado),1,50))
into STRICT	ie_fim_administracao_w,
	ds_titulo_hemocomp_w
from	cirurgia_agente_anestesico
where	nr_sequencia = nr_seq_graf_atual_p;

if (dt_value_x_date_p IS NOT NULL AND dt_value_x_date_p::text <> '') then
	dt_value_w	:= dt_value_x_date_p;
else
	dt_value_w	:= to_date(dt_value_X_p, 'dd/mm/yyyy hh24:mi:ss');
end if;

if (ie_fim_administracao_w = 'S') then
	begin
	select	coalesce(max(qt_dose),0) qt_dose,
		max(ds_observacao) ds_observacao,
		max(ds_identificacao_bolsa) ds_identificacao_bolsa,
		coalesce(max(dt_inicio_adm), dt_value_w) inicio_hemocomponente
	into STRICT	qt_dose_w,
		ds_observacao_w,
		ds_identificacao_bolsa_w,
		dt_inicio_hemocomponente_w
	from	cirurgia_agente_anest_ocor
	where	coalesce(dt_final_adm::text, '') = ''
	and	coalesce(ie_situacao,'A') = 'A'
	and	nr_seq_cirur_agente = nr_seq_graf_atual_p;
	end;
end if;

ie_fim_administracao_p		:= ie_fim_administracao_w;
ds_titulo_hemocomp_p		:= ds_titulo_hemocomp_w;
qt_dose_p			:= qt_dose_w;
ds_observacao_p			:= ds_observacao_w;
ds_identificacao_bolsa_p	:= ds_identificacao_bolsa_w;


if (coalesce(dt_value_x_date_p::text, '') = '') then
	dt_inicio_hemocomponente_p	:= to_char(dt_inicio_hemocomponente_w,'dd/mm/yyyy hh24:mi:ss');
end if;


dt_inicio_hemocomp_date_p	:= dt_inicio_hemocomponente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_ativ_adm_hemocomp ( nr_seq_graf_atual_p bigint, dt_value_x_p text, ie_fim_administracao_p INOUT text, ds_titulo_hemocomp_p INOUT text, qt_dose_p INOUT bigint, ds_observacao_p INOUT text, ds_identificacao_bolsa_p INOUT text, dt_inicio_hemocomponente_p INOUT text, dt_inicio_hemocomp_date_p INOUT timestamp, dt_value_x_date_p timestamp default null) FROM PUBLIC;
