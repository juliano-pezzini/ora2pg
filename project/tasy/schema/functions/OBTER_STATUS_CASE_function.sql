-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_case ( nr_sequencia_p bigint, ie_opcao_p text default null, nr_atendimento_p bigint default null) RETURNS varchar AS $body$
DECLARE


ie_status_case_w      varchar(50);
nr_seq_episodio_w     episodio_paciente.nr_sequencia%type;

ie_planned_w		varchar(1) := 'F';
ie_cancel_w     	varchar(1) := 'C';
ie_current_w     	varchar(1) := 'A';
ie_fim_episodio_w       varchar(1) := 'X';
ie_expression_desc_w	varchar(1) := 'E';


BEGIN

  nr_seq_episodio_w := nr_sequencia_p;

  if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
      select  nr_seq_episodio
      into STRICT    nr_seq_episodio_w
      from    atendimento_paciente
      where   nr_atendimento = nr_atendimento_p;
  end if;

	select
      case 
            when (dt_cancelamento IS NOT NULL AND dt_cancelamento::text <> '') then ie_cancel_w
            when (dt_fim_episodio IS NOT NULL AND dt_fim_episodio::text <> '') then ie_fim_episodio_w
            when dt_episodio > clock_timestamp() then ie_planned_w
            else ie_current_w
      end
    	into STRICT	    ie_status_case_w
    	from    	episodio_paciente
    	where   	nr_sequencia = nr_seq_episodio_w;

    	if (ie_opcao_p = ie_expression_desc_w) then
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
-- REVOKE ALL ON FUNCTION obter_status_case ( nr_sequencia_p bigint, ie_opcao_p text default null, nr_atendimento_p bigint default null) FROM PUBLIC;
