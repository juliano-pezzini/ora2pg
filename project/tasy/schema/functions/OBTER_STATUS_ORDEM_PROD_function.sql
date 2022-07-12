-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_ordem_prod (nr_sequencia_p bigint, ie_codigo_desc_p text, ie_utiliza_legenda_p text default null) RETURNS varchar AS $body$
DECLARE


/*ie_codigo_desc_p D - Descricao C- Codigo */

ds_status_w		varchar(80);
dt_inicio_preparo_w	timestamp;
dt_entrega_setor_w	timestamp;
dt_administracao_w	timestamp;
dt_fim_preparo_w	timestamp;
dt_devolucao_w		timestamp;
dt_liberacao_w		timestamp;
dt_liberacao_enf_w		timestamp;
nr_prescricao_w		bigint;
ie_cancelada_w		varchar(1);
ie_suspensa_w		varchar(1);
dt_solic_perda_w	timestamp;
dt_transferencia_w	timestamp;
ie_conferido_w		varchar(1);
ie_utiliza_legenda_w	varchar(1);
dt_expedido_w		timestamp;
dt_entregue_w		timestamp;
dt_recebido_w		timestamp;
ie_reaproveitado_w 	varchar(1);
dt_conf_medicamento_w can_ordem_prod.dt_conf_medicamento%type;
dt_higienizacao_w can_ordem_prod.dt_higienizacao%type;
dt_inicio_separacao_w can_ordem_prod.dt_inicio_separacao%type;


BEGIN
if (coalesce(ie_utiliza_legenda_p::text, '') = '') then
	ie_utiliza_legenda_w := Obter_Param_Usuario(3130, 280, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_utiliza_legenda_w);
else
	ie_utiliza_legenda_w := ie_utiliza_legenda_p;
end if;

select	a.dt_inicio_preparo,
	a.dt_entrega_setor,
	a.dt_administracao,
	a.dt_fim_preparo,
	a.dt_devolucao,
	a.nr_prescricao,
	b.dt_liberacao_medico,
	b.dt_liberacao,
	a.ie_cancelada,
	a.ie_suspensa,
	a.dt_solic_perda,
	dt_transferencia,
	ie_conferido,
	dt_expedido,
	dt_recebido,
	dt_entregue,
	a.dt_conf_medicamento,
	a.dt_higienizacao,
	a.dt_inicio_separacao,
	substr(obter_se_ordem_reaproveitada(a.nr_sequencia),1,1)
into STRICT	dt_inicio_preparo_W,
	dt_entrega_setor_W,
	dt_administracao_W,
	dt_fim_preparo_W,
	dt_devolucao_w,
	nr_prescricao_W,
	dt_liberacao_w,
	dt_liberacao_enf_w,
	ie_cancelada_w,
	ie_suspensa_w,
	dt_solic_perda_w,
	dt_transferencia_w,
	ie_conferido_w,
	dt_expedido_w,
	dt_recebido_w,
	dt_entregue_w,
	dt_conf_medicamento_w,
	dt_higienizacao_w,
	dt_inicio_separacao_w,
	ie_reaproveitado_w
from	prescr_medica b,
	can_ordem_prod a
where	a.nr_sequencia	= nr_sequencia_p
and	a.nr_prescricao = b.nr_prescricao;

if (dt_entregue_w IS NOT NULL AND dt_entregue_w::text <> '') then
	ds_status_w		:= '3902';
elsif (dt_recebido_w IS NOT NULL AND dt_recebido_w::text <> '') then
	ds_status_w		:= '3901';
elsif (dt_expedido_w IS NOT NULL AND dt_expedido_w::text <> '') then
	ds_status_w		:= '3900';
elsif (ie_reaproveitado_w = 'S') then
	ds_status_w		:= '4101';
elsif (ie_cancelada_w = 'S') then
	ds_status_w		:= '151';
elsif (dt_solic_perda_w IS NOT NULL AND dt_solic_perda_w::text <> '') then 	
	ds_status_w		:= '2776';
elsif (dt_devolucao_w IS NOT NULL AND dt_devolucao_w::text <> '') then
	ds_status_w		:= '92';
elsif (ie_suspensa_w = 'S') then
	ds_status_w		:= '356';
elsif (dt_administracao_W IS NOT NULL AND dt_administracao_W::text <> '') then
	ds_status_w		:= '91';
elsif (dt_entrega_setor_W IS NOT NULL AND dt_entrega_setor_W::text <> '') then
	ds_status_w		:= '90';
elsif (dt_transferencia_w IS NOT NULL AND dt_transferencia_w::text <> '') then
	ds_status_w		:= '2826';
elsif (dt_conf_medicamento_w IS NOT NULL AND dt_conf_medicamento_w::text <> '') then
	ds_status_w		:= '11351';
elsif (dt_fim_preparo_W IS NOT NULL AND dt_fim_preparo_W::text <> '') then
	ds_status_w		:= '89';
elsif (dt_inicio_preparo_W IS NOT NULL AND dt_inicio_preparo_W::text <> '') then
	ds_status_w		:= '88';
elsif (dt_higienizacao_w IS NOT NULL AND dt_higienizacao_w::text <> '') then
	ds_status_w		:= '11332';
elsif (dt_inicio_separacao_w IS NOT NULL AND dt_inicio_separacao_w::text <> '') then
	ds_status_w		:= '11333';
elsif (ie_conferido_w = 'S') and (ie_utiliza_legenda_w = 'S') then
	ds_status_w		:= '3462';
elsif (dt_liberacao_enf_w IS NOT NULL AND dt_liberacao_enf_w::text <> '') then
	ds_status_w		:= '6447';
elsif (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
	ds_status_w		:= '87';
else
	ds_status_w		:= '85';
end if;

if (ie_codigo_desc_p = 'D') then
	select	obter_valor_dominio(1243, ds_status_w)
	into STRICT	ds_status_w
	;
end if;

return ds_status_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_ordem_prod (nr_sequencia_p bigint, ie_codigo_desc_p text, ie_utiliza_legenda_p text default null) FROM PUBLIC;

