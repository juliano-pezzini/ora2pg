-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_hist_saude_alergia (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := null;
ds_classe_w	varchar(60);
ds_medic_w	varchar(100);
ds_reacao_w	varchar(100);
ds_abordagem_w	varchar(60);
ds_substancia_w	varchar(80);
dt_inicial_w	timestamp;
dt_ultima_w	timestamp;
dt_fim_w	timestamp;
ds_observacao_w	varchar(255);
ds_duracao_w	varchar(20);
ds_principio_w	varchar(100);
ie_nega_alergias_w	varchar(10);
ds_agente_causador_w	varchar(1000);


BEGIN

select	substr(Obter_desc_classe_mat(cd_classe_mat),1,60),
	substr(obter_desc_material(cd_material),1,100),
	substr(obter_desc_reacao_alergica(nr_seq_reacao),1,100),
	substr(obter_desc_ficha_tecnica(nr_seq_ficha_tecnica),1,80),
	substr(obter_valor_dominio(1337,ie_abordagem),1,60),
	dt_inicio,
	dt_ultima,
	substr(ds_observacao,1,255),
	substr(obter_desc_dcb(nr_seq_dcb),1,80),
	dt_fim,
	substr(obter_idade(dt_inicio,coalesce(dt_fim,clock_timestamp()),'S'),1,20),
	ie_nega_alergias,
	substr(obter_desc_alergeno(nr_seq_tipo),1,1000) ds_agente_causador
into STRICT	ds_classe_w,
	ds_medic_w,
	ds_reacao_w,
	ds_principio_w,
	ds_abordagem_w,
	dt_inicial_w,
	dt_ultima_w,
	ds_observacao_w,
	ds_substancia_w,
	dt_fim_w,
	ds_duracao_w,
	ie_nega_alergias_w,
	ds_agente_causador_w
from	paciente_alergia
where	nr_sequencia	= nr_sequencia_p;

if (ds_agente_causador_w IS NOT NULL AND ds_agente_causador_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(1024731) || ': '|| ds_agente_causador_w ||chr(13) || chr(10); -- Agente causador
end if;

if (dt_inicial_w IS NOT NULL AND dt_inicial_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309160) || ' '||to_char(dt_inicial_w,'dd/mm/yyyy')||chr(13) || chr(10); -- Desde
end if;

if (dt_fim_w IS NOT NULL AND dt_fim_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309160) || ' '||to_char(dt_inicial_w,'dd/mm/yyyy')||' ' || wheb_mensagem_pck.get_texto(309164) || ' '||to_char(dt_fim_w,'dd/mm/yyyy')||'   ' || wheb_mensagem_pck.get_texto(309167) || ' '||ds_duracao_w||chr(13) || chr(10); -- Desde	--até	--Duração
end if;

if (ie_nega_alergias_w = 'S') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309170) ||chr(13) || chr(10); --  Nega alergias
end if;

if (ds_substancia_w IS NOT NULL AND ds_substancia_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309172) || ': '||ds_substancia_w||chr(13) || chr(10); -- Substância
end if;

if (ds_principio_w IS NOT NULL AND ds_principio_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309175) || ': '||ds_principio_w||chr(13) || chr(10); -- Princípio ativo
end if;

if (ds_classe_w IS NOT NULL AND ds_classe_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309177) || ': '||ds_classe_w||chr(13) || chr(10); -- Classe
end if;

if (ds_medic_w IS NOT NULL AND ds_medic_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309179) || ': '||ds_medic_w||chr(13) || chr(10); -- Medicamento
end if;

if (ds_reacao_w IS NOT NULL AND ds_reacao_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309180) || ': '||ds_reacao_w||chr(13) || chr(10); -- Reação
end if;

if (ds_abordagem_w IS NOT NULL AND ds_abordagem_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309181) || ': '||ds_abordagem_w||chr(13) || chr(10); -- Abordagem
end if;

if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
	ds_retorno_w	:= ds_retorno_w || wheb_mensagem_pck.get_texto(309183) || ': '||ds_observacao_w||chr(13) || chr(10);-- Observação
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_hist_saude_alergia (nr_sequencia_p bigint) FROM PUBLIC;
