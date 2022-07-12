-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_interv_solucao_vipe ( ie_acm_p text, ie_sn_p text, ie_agora_p text, nr_etapas_p bigint, qt_tempo_etapa_p bigint) RETURNS varchar AS $body$
DECLARE


ds_interv_w	varchar(240);


BEGIN
if (ie_acm_p = 'S') or (ie_sn_p = 'S') or (ie_agora_p = 'S') then
	begin
	if (ie_acm_p = 'S') then
		begin
		ds_interv_w := wheb_mensagem_pck.get_texto(308400); -- ACM
		end;
	elsif (ie_sn_p = 'S') then
		begin
		ds_interv_w := wheb_mensagem_pck.get_texto(308401); -- SN
		end;
	else
		begin
		ds_interv_w := upper(wheb_mensagem_pck.get_texto(308402)); -- AGORA
		end;
	end if;
	end;
end if;

if (nr_etapas_p IS NOT NULL AND nr_etapas_p::text <> '') then
	begin
	if (ds_interv_w IS NOT NULL AND ds_interv_w::text <> '') then
		begin
		ds_interv_w := ds_interv_w || ' ' || nr_etapas_p || ' ' || upper(wheb_mensagem_pck.get_texto(901766)); -- E
		end;
	else
		begin
		ds_interv_w := nr_etapas_p || ' ' || upper(wheb_mensagem_pck.get_texto(901766)); -- E
		end;
	end if;
	end;
end if;

if (qt_tempo_etapa_p IS NOT NULL AND qt_tempo_etapa_p::text <> '') then
	begin
	if (ds_interv_w IS NOT NULL AND ds_interv_w::text <> '') and (nr_etapas_p IS NOT NULL AND nr_etapas_p::text <> '') then
		begin
		ds_interv_w := ds_interv_w || ' / ' || qt_tempo_etapa_p || ' ' || wheb_mensagem_Pck.get_texto(308403); -- H
		end;
	elsif (ds_interv_w IS NOT NULL AND ds_interv_w::text <> '') then
		begin
		ds_interv_w := ds_interv_w || ' ' || qt_tempo_etapa_p || ' ' || wheb_mensagem_pck.get_texto(308403); -- H
		end;
	else
		begin
		ds_interv_w := qt_tempo_etapa_p || ' ' || wheb_mensagem_pck.get_texto(308403); -- H
		end;
	end if;
	end;
end if;
return ds_interv_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_interv_solucao_vipe ( ie_acm_p text, ie_sn_p text, ie_agora_p text, nr_etapas_p bigint, qt_tempo_etapa_p bigint) FROM PUBLIC;
