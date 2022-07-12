-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_reserva_cpoe ( nr_prescricao_p bigint, nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_setor_reserva_w		integer;


BEGIN
select coalesce(cd_setor_recebimento,cd_setor_tranfusao)
into STRICT cd_setor_reserva_w
from cpoe_hemoterapia h,
    prescr_solic_bco_sangue b
where b.nr_prescricao = nr_prescricao_p
and h.nr_sequencia = b.nr_seq_hemo_cpoe;

return coalesce(cd_setor_reserva_w, substr(obter_unidade_atendimento(nr_atendimento_p, 'IAA', 'CS'),1,50));
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_reserva_cpoe ( nr_prescricao_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

