-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_medic_admin (nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_atendimento_p paciente_atendimento.nr_seq_atendimento%type) AS $body$
DECLARE


quantidade_w bigint;


BEGIN

select  	count(*)
into STRICT    	quantidade_w
from    	paciente_atend_medic medic
inner join 	paciente_atendimento atend on medic.nr_seq_atendimento = atend.nr_seq_atendimento
where   	atend.nr_seq_atendimento = nr_seq_atendimento_p
and     	medic.ie_administracao = 'A';

if (quantidade_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1191756);
end if;

select count(*)
into STRICT   quantidade_w
from   prescr_mat_hor
where  nr_prescricao = nr_prescricao_p
and    (dt_checagem IS NOT NULL AND dt_checagem::text <> '');

if (quantidade_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1191757);
end if;

select count(*)
into STRICT   quantidade_w
from   can_ordem_prod
where  nr_prescricao = nr_prescricao_p
and    (dt_checagem IS NOT NULL AND dt_checagem::text <> '');

if (quantidade_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(1191758);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_medic_admin (nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_atendimento_p paciente_atendimento.nr_seq_atendimento%type) FROM PUBLIC;

