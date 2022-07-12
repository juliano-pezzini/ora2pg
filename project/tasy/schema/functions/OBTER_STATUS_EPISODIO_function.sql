-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_episodio ( nr_sequencia_p bigint, ie_opcao_p text default null) RETURNS varchar AS $body$
DECLARE


ie_status_case_w	varchar(50);
is_planned_w     	char(1);
ie_find_current_w	char(1);

ie_planned_w		char(1) := 'F';
ie_cancel_w     	char(1) := 'C';
ie_current_w     	char(1) := 'A';
ie_fim_episodio_w   char(1) := 'X';

c_atend_paciente CURSOR FOR
	SELECT  ap.nr_atendimento
	from    atendimento_paciente ap
	where   ap.nr_seq_episodio = nr_sequencia_p
	and     coalesce(ap.dt_cancelamento::text, '') = '';

BEGIN

	select
		case 
            when (ep.dt_cancelamento IS NOT NULL AND ep.dt_cancelamento::text <> '') then ie_cancel_w
            when (ep.dt_fim_episodio IS NOT NULL AND ep.dt_fim_episodio::text <> '') then ie_fim_episodio_w
            when ep.dt_episodio > clock_timestamp() then ie_planned_w
            else ie_current_w
		end
    into STRICT	ie_status_case_w
    from    episodio_paciente ep
    where   ep.nr_sequencia = nr_sequencia_p;
	
	if ie_status_case_w = ie_current_w then

		ie_find_current_w:= 'N';
		for c_atend_paciente_w in c_atend_paciente loop
		
			if ie_find_current_w = 'N' then
				select 	obter_se_atendimento_futuro(c_atend_paciente_w.nr_atendimento)
				into STRICT	is_planned_w
				;
				
				if is_planned_w = 'S' then
					ie_status_case_w := ie_planned_w;
				else
					ie_status_case_w := ie_current_w;
					ie_find_current_w := 'S';
				end if;
			end if;
		
		end loop;
	
	end if;
	
	if (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
        if (ie_status_case_w = ie_planned_w) then
            ie_status_case_w := obter_desc_expressao(497767);
        elsif (ie_status_case_w = ie_cancel_w) then
                ie_status_case_w := obter_desc_expressao(322155);
        elsif (ie_status_case_w = ie_fim_episodio_w) then
                ie_status_case_w := obter_desc_expressao(290046);
        else
                ie_status_case_w := obter_desc_expressao(283952);
        end if;
    end if;

    return ie_status_case_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_episodio ( nr_sequencia_p bigint, ie_opcao_p text default null) FROM PUBLIC;

