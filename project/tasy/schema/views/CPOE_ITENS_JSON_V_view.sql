-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cpoe_itens_json_v (nr_atendimento, dt_prox_geracao) AS select	nr_atendimento, dt_prox_geracao
FROM	cpoe_dieta
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_material
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_procedimento
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_gasoterapia
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_recomendacao
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_hemoterapia
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_prox_geracao
from	cpoe_dialise
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_inicio dt_prox_geracao
from	cpoe_anatomia_patologica
where	dt_liberacao is not null

union all

select	nr_atendimento, dt_inicio dt_prox_geracao
from	cpoe_intervencao
where	dt_liberacao is not null;

